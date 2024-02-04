local ThermiteOutside, ThermiteInside = vector3(882.20, -2258.24, 30.63), vector3(881.35, -2268.12, 30.63)
local ThermiteTimeout = false
-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('mercy-items/client/used-thermite-charge', function()
    local Secure = CallbackModule.SendCallback('mercy-police/server/can-rob')
    if Secure then return exports['mercy-ui']:Notify("heists-error", "Secure active!", "error") end
    if #(GetEntityCoords(PlayerPedId()) - ThermiteOutside) > 3.0 and #(GetEntityCoords(PlayerPedId()) - ThermiteInside) > 3.0 then
        return
    end
    local ClosestDoorCoords, CanThermite, ThermiteType = ThermiteOutside, false, 'Outside'
    if #(GetEntityCoords(PlayerPedId()) - ThermiteOutside) < 3.0 then 
        if not Config.OutsideDoorsThermited then
            CanThermite = true
        end
    elseif #(GetEntityCoords(PlayerPedId()) - ThermiteInside) < 3.0 then 
        ClosestDoorCoords, ThermiteType = ThermiteInside, 'Inside'
        if not Config.InsideDoorsThermited then
            CanThermite = true
        end
    end
    if CanThermite and not ThermiteTimeout then
        ThermiteTimeout = true
        Citizen.SetTimeout(450, function()
            local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', 'thermitecharge', 1, nil, true)
            if DidRemove then
                exports['mercy-inventory']:SetBusyState(true)
                local Success = DoThermite(ClosestDoorCoords)
                ThermiteTimeout = false
                if Success then
                    TriggerServerEvent('mercy-heists/server/bobcat/set-door-state', ThermiteType)
                    if ThermiteType == 'Outside' then
                        TriggerServerEvent('mercy-doors/server/set-locks', Config.BobcatDoors[1], 0)
                        TriggerServerEvent('mercy-doors/server/set-locks', Config.BobcatDoors[2], 0)
                    else
                        TriggerServerEvent('mercy-doors/server/set-locks', Config.BobcatDoors[3], 0)
                        TriggerServerEvent('mercy-doors/server/set-locks', Config.BobcatDoors[4], 0)
                    end                
                    while ThermiteType == 'Inside' and (Config.OutsideDoorsThermited and not Config.InsideDoorsThermited) do -- Wait for inside doors status to be updated
                        Citizen.Wait(4)
                    end
                    if Config.OutsideDoorsThermited and Config.InsideDoorsThermited then
                        local StreetLabel = FunctionsModule.GetStreetName() 
                        SpawnSecurity()
                        EventsModule.TriggerServer('mercy-ui/server/send-bobcat-rob', StreetLabel)
                    end 
                    exports['mercy-inventory']:SetBusyState(false)
                else
                    exports['mercy-inventory']:SetBusyState(false)
                end
            end
        end)
    end
end)

RegisterNetEvent('mercy-heists/client/blow-bobcat-vault', function()
    local Secure = CallbackModule.SendCallback('mercy-police/server/can-rob')
    if Secure then return exports['mercy-ui']:Notify("heists-error", "Secure active!", "error") end
    local Coords, Rotation = vector3(890.45, -2284.67, 30.46), vector3(180.0, 180.0, 0.0)
    TriggerEvent('mercy-heists/client/bomb-animation', Coords, Rotation)
    exports['mercy-inventory']:SetBusyState(true)
    exports['mercy-ui']:ProgressBar('Placing Explosives..', 5000, false, false, true, false, function(DidComplete)
        if DidComplete then
            Citizen.SetTimeout(6000, function()
                TriggerEvent('mercy-heists/client/reset-bomb-animation')
                TriggerServerEvent('mercy-heists/server/bobcat/blow-vault')
                if not exports['mercy-police']:IsStatusAlreadyActive('explosive') then
                    TriggerEvent('mercy-police/client/evidence/set-status', 'explosive', 350)
                end
            end)
        end
        exports['mercy-inventory']:SetBusyState(false)
    end)
end)

RegisterNetEvent('mercy-heists/client/bobcat/steal-loot', function(BoxId, Entity)
    local Secure = CallbackModule.SendCallback('mercy-police/server/can-rob')
    if Secure then return exports['mercy-ui']:Notify("heists-error", "Secure active!", "error") end
    if Config.BobcatExploded and not exports['mercy-ui']:IsProgressBarActive() and Config.LootSpots[BoxId] then
        TriggerServerEvent('mercy-heists/server/set-loot-state', BoxId, false)
        exports['mercy-ui']:ProgressBar('Stealing..', 25000, {['AnimName'] = 'grab', ['AnimDict'] = "anim@heists@ornate_bank@grab_cash_heels", ['AnimFlag'] = 16}, "HeistBag", true, false, function(DidComplete)
            if DidComplete then
                EventsModule.TriggerServer('mercy-heists/server/bobcat/receive-goods')
            end
        end)
    end
end)

RegisterNetEvent('mercy-heists/client/sync-loot-state', function(LootData)
    Config.LootSpots = LootData
end)

RegisterNetEvent('mercy-heists/client/bobcat/sync-door-state', function(OutsideDoor, InsideDoor)
    Config.OutsideDoorsThermited = OutsideDoor
    Config.InsideDoorsThermited = InsideDoor
end)

RegisterNetEvent('mercy-heists/client/bobcat/reset-exploded', function()
    Config.BobcatExploded = false
end)

RegisterNetEvent('mercy-heists/client/bobcat/process-blow-vault', function()
    Config.BobcatExploded = true
    SetBobcatInterior(Config.BobcatExploded)
    if #(GetEntityCoords(PlayerPedId()) - vector3(890.80, -2284.75, 32.44)) < 200.0 then	
        AddExplosion(890.83, -2284.72, 30.46, 5, 0.5, true, false, 10.0)
    end
end)

-- [ Functions ] --

function InitBobcat()
    SetBobcatInterior(Config.BobcatExploded)
end

function SetBobcatInterior(Broken)
    local InteriorId = GetInteriorAtCoords(883.41, -2282.37, 31.44)
    if Broken then
        ActivateInteriorEntitySet(InteriorId, "np_prolog_broken")
        DeactivateInteriorEntitySet(InteriorId, "np_prolog_clean")
    else
        ActivateInteriorEntitySet(InteriorId, "np_prolog_clean")
        DeactivateInteriorEntitySet(InteriorId, "np_prolog_broken")
    end
    RefreshInterior(InteriorId)
end

function CanLootSpot(BoxId)
    return Config.LootSpots[BoxId] ~= nil and Config.LootSpots[BoxId] or false
end

function SpawnSecurity()
    for k, v in pairs(Config.BobcatSecurity) do
        if FunctionsModule.RequestModel(v['Model']) then
            local Security = CreatePed(5, v['Model'], v['Coords'].x, v['Coords'].y, v['Coords'].z, v['Coords'].w, 1, 1)
            SetPedShootRate(Security, 750)
            SetPedCombatAttributes(Security, 46, true)
            SetPedFleeAttributes(Security, 0, 0)
            SetPedAsEnemy(Security, true)
            SetPedAccuracy(Security, 75)
            SetPedArmour(Security, 200.0)
            SetPedMaxHealth(Security, 2000.0)
            SetPedAlertness(Security, 3)
            SetPedCombatRange(Security, 0)
            SetPedCombatMovement(Security, 3)
            TaskCombatPed(Security, PlayerPedId(), 0, 16)
            GiveWeaponToPed(Security, GetHashKey("WEAPON_CARBINERIFLE_MK2"), 9999, true, true)
            SetCurrentPedWeapon(Security, GetHashKey("WEAPON_CARBINERIFLE_MK2"), true)
            SetPedRelationshipGroupHash(Security, GetHashKey("HATES_PLAYER"))
            SetPedDropsWeaponsWhenDead(Security, false)
            SetEntityCollision(Security, true, true)
        end
    end
end
exports('CanLootSpot', CanLootSpot)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        -- Delete Security
        for k, v in pairs(Config.BobcatSecurity) do
            if DoesEntityExist(v['Entity']) then
                DeleteEntity(v['Entity'])
            end
        end
        -- Reset Doors
        TriggerServerEvent('mercy-doors/server/set-locks', Config.BobcatDoors[1], 1)
        TriggerServerEvent('mercy-doors/server/set-locks', Config.BobcatDoors[2], 1)
        TriggerServerEvent('mercy-doors/server/set-locks', Config.BobcatDoors[3], 1)
        TriggerServerEvent('mercy-doors/server/set-locks', Config.BobcatDoors[4], 1)
    end
end)
