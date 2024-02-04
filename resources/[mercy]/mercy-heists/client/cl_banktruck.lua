RegisterNetEvent('mercy-items/client/used-thermite-charge', function()
    local Secure = CallbackModule.SendCallback('mercy-police/server/can-rob')
    if Secure then return exports['mercy-ui']:Notify("heists-error", "Secure active!", "error") end
    local Entity, EntityType, EntityCoords = FunctionsModule.GetEntityPlayerIsLookingAt(2.0, 0.2, 286, PlayerPedId())
    if GetEntityType(Entity) ~= 2 or GetEntityModel(Entity) ~= GetHashKey("stockade") then return end
    if exports['mercy-police']:GetTotalOndutyCops() >= Config.BanktruckCops then
        local CanRob = CallbackModule.SendCallback('mercy-heists/server/banktruck/can-rob-truck', NetworkGetNetworkIdFromEntity(Entity))
        if not CanRob then return exports['mercy-ui']:Notify("banktruck-error", "Already burnt..", "error") end
        Citizen.SetTimeout(450, function()
            local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', 'thermitecharge', 1, nil, true)
            if DidRemove then
                local Coords = GetOffsetFromEntityInWorldCoords(Entity, 0.0, -3.55, 0.55)
                local Success = DoThermite(Coords)
                if Success then
                    EventsModule.TriggerServer("mercy-heists/server/banktruck/set-truck-state", NetworkGetNetworkIdFromEntity(Entity), true)
                    EventsModule.TriggerServer('mercy-ui/server/send-banktruck-rob', FunctionsModule.GetStreetName())
                end
            end
        end)
    else
        exports['mercy-ui']:Notify("banktruck-error", "You can't do this now..", "error")
    end
end)

RegisterNetEvent("mercy-heists/client/banktruck/remove-truck", function(NetId)
    local Vehicle = NetworkGetEntityFromNetworkId(NetId)
    EntityModule.DeleteEntity(Vehicle)
end)

RegisterNetEvent("mercy-heists/client/banktruck/setup", function(NetId)
    local Vehicle = NetworkGetEntityFromNetworkId(NetId)
    FunctionsModule.RequestModel('s_m_m_armoured_01')

    SetVehicleDoorsLocked(Vehicle, 3)
    FreezeEntityPosition(Vehicle, 1)
    SetVehicleDoorBroken(Vehicle, 2, 0)
    SetVehicleDoorBroken(Vehicle, 3, 0)
    SetVehicleUndriveable(Vehicle, true)
    SetVehicleEngineOn(Vehicle, false, false, true)

    for i = -1, 4 do
        local Protection = CreatePedInsideVehicle(Vehicle, 5, "s_m_m_armoured_01", i, 1, 1)
        SetPedShootRate(Protection, 750)
        SetPedCombatAttributes(Protection, 46, true)
        SetPedFleeAttributes(Protection, 0, 0)
        SetPedAsEnemy(Protection, true)
        SetPedArmour(Protection, 200.0)
        SetPedMaxHealth(Protection, 2000.0)
        SetPedAlertness(Protection, 3)
        SetPedCombatRange(Protection, 0)
        SetPedCombatMovement(Protection, 3)
        TaskCombatPed(Protection, PlayerPedId(), 0, 16)
        TaskLeaveVehicle(Protection, Vehicle, 0)
        GiveWeaponToPed(Protection, GetHashKey("WEAPON_CARBINERIFLE_MK2"), 9999, true, true)
        SetCurrentPedWeapon(Protection, GetHashKey("WEAPON_CARBINERIFLE_MK2"), true)
        SetPedRelationshipGroupHash(Protection, GetHashKey("HATES_PLAYER"))
        SetPedDropsWeaponsWhenDead(Protection, false)
    end

    Citizen.CreateThread(function()
        local RobbingTruck = true
        local ShowingInteraction = false
        while RobbingTruck do
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local TruckCoords = GetOffsetFromEntityInWorldCoords(Vehicle, 0.0, -3.5, 0.5)
            local Distance = #(PlayerCoords - TruckCoords)
            if Distance < 3.0 then
                if not ShowingInteraction then
                    ShowingInteraction = true
                    exports['mercy-ui']:SetInteraction('[E] Bank Truck')
                end
                if IsControlJustPressed(0, 38) then
                    if not exports['mercy-ui']:IsProgressBarActive() then
                        local Stealing = true
                        RobbingTruck = false
                        ShowingInteraction = false
                        if not IsWearingHandshoes() and math.random(1, 100) <= 85 then
                            TriggerServerEvent("mercy-police/server/create-evidence", 'Fingerprint')
                        end
                        exports['mercy-ui']:HideInteraction()
                        exports['mercy-ui']:ProgressBar('Stealing..', math.random(34000, 58000), {['AnimName'] = 'grab', ['AnimDict'] = "anim@heists@ornate_bank@grab_cash_heels", ['AnimFlag'] = 16}, "HeistBag", true, true, function(DidComplete)
                            if DidComplete then
                                Stealing = false
                            end
                        end)
                        Citizen.CreateThread(function()
                            while Stealing do
                                EventsModule.TriggerServer('mercy-ui/server/set-stress', 'Add', math.random(2, 3))
                                EventsModule.TriggerServer("mercy-heists/server/banktruck/receive-goods")
                                Citizen.Wait(6500)
                            end
                        end)
                    end
                end
            else
                if ShowingInteraction then
                    ShowingInteraction = false
                    exports['mercy-ui']:HideInteraction()
                end
            end
            Citizen.Wait(4)
        end
    end)
end)
