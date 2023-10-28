local AnchoredBoats, Synced = {}, false
local WasNearVehicle = false
local Count = 0
local InVeh = false

RegisterNetEvent('Mercy/client/on-login', function()
 	Citizen.SetTimeout(1250, function()
        local Config = CallbackModule.SendCallback('mercy-items/server/sync-anchor-config')
        AnchoredBoats = Config
 	end)
end)

RegisterNetEvent('mercy-items/client/sync-item-anchor', function(Plate, Toggle, NewAnchoredBoats)
    AnchoredBoats = NewAnchoredBoats
    local Vehicle = VehicleModule.GetClosestVehicle()
    if Plate == GetVehicleNumberPlateText(Vehicle['Vehicle']) then
        Synced = true
        SetBoatAnchor(Vehicle['Vehicle'], Toggle)
        SetForcedBoatLocationWhenAnchored(Vehicle['Vehicle'], Toggle)
    end
end)

RegisterNetEvent('mercy-items/client/use-anchor-lower', function(Source) 
    local Vehicle = VehicleModule.GetClosestVehicle()
    if GetVehicleClass(Vehicle['Vehicle']) == 14 then
        exports['mercy-inventory']:SetBusyState(true)
        EventsModule.TriggerServer('mercy-ui/server/play-sound-on-entity', 'anchorDrop', Vehicle['Vehicle'], 5000)
        exports['mercy-ui']:ProgressBar('Lowering Anchor..', 5000, {}, false, false, true, function(DidComplete)
            exports['mercy-inventory']:SetBusyState(false)
            if DidComplete then
                TriggerServerEvent('mercy-items/server/sync-item-anchor', GetVehicleNumberPlateText(Vehicle['Vehicle']), true)
                TaskPlayAnim(PlayerPedId(), 'missfbi4prepp1', '_bag_drop_garbage_man', 8.0, -8, -1, 16, 0, 0, 0, 0);
                exports['mercy-ui']:Notify('anchor-raised', 'Anchor lowered..', 'success')
            end
        end)
    end
end)

RegisterNetEvent('mercy-items/client/use-anchor-raise', function() 
    local Vehicle = VehicleModule.GetClosestVehicle()
    EventsModule.TriggerServer('mercy-ui/server/play-sound-on-entity', 'anchorRaise', Vehicle['Vehicle'], 5000)
    exports['mercy-inventory']:SetBusyState(true)
    exports['mercy-ui']:ProgressBar('Raising Anchor..', 5000, {}, false, false, true, function(DidComplete)
        exports['mercy-inventory']:SetBusyState(false)
        if DidComplete then
            TriggerServerEvent('mercy-items/server/sync-item-anchor', GetVehicleNumberPlateText(Vehicle['Vehicle']), false)
            exports['mercy-ui']:Notify('anchor-raised', 'Anchor raised..', 'success')
        end
    end)
end)

RegisterNetEvent('mercy-threads/entered-vehicle', function() 
    InVeh = true
end)

RegisterNetEvent('mercy-threads/exited-vehicle', function() 
    InVeh = false
end)

-- [ Threads ] --


Citizen.CreateThread(function() 
    while true do
        Wait(4)
        if LocalPlayer.state.LoggedIn then
            local NearVehicle = false
            if VehicleModule ~= nil then
                local Vehicle = VehicleModule.GetClosestVehicle()
                local VehicleCoords = GetEntityCoords(Vehicle['Vehicle'])
                if GetVehicleClass(Vehicle['Vehicle']) ~= 14 then 
                    Wait(1000)
                    return 
                end

                local BoatDist = #(GetEntityCoords(PlayerPedId()) - vector3(VehicleCoords.x, VehicleCoords.y, VehicleCoords.z))
                if AnchoredBoats[GetVehicleNumberPlateText(Vehicle['Vehicle'])] and BoatDist <= 2.0 then
                    WasNearVehicle = true
                    NearVehicle = true

                    if not Synced then
                        SetBoatAnchor(Vehicle['Vehicle'], true)
                        SetForcedBoatLocationWhenAnchored(Vehicle['Vehicle'], true)
                        Synced = true
                    end

                    if InVeh then
                        TaskLeaveVehicle(PlayerPedId(), Vehicle['Vehicle'], 16)
                        if not IsPedSittingInAnyVehicle(PlayerPedId()) then
                            SetBoatAnchor(Vehicle['Vehicle'], true)
                            SetForcedBoatLocationWhenAnchored(Vehicle['Vehicle'], true)
                            Count = Count + 1
                            Wait(1300)
                            if not ShowedNotify then 
                                if Count == 2 then
                                    exports['mercy-ui']:Notify('cannot-sail', 'You can sail again when the anchor is raised..', 'error')
                                    ShowedNotify = true
                                    Count = 0
                                end
                            end
                        end
                    end
                else
                    if WasNearVehicle then 
                        exports['mercy-ui']:HideInteraction()
                        WasNearVehicle = false
                    end
                end

                if not NearVehicle then
                    Wait(1000)
                end

                if ShowedNotify then
                    Wait(1300)
                    ShowedNotify = false
                end
            end
        else
            Wait(1000)
        end
    end
end)

exports('CanDropAnchor', function() 
    local Vehicle = VehicleModule.GetClosestVehicle()
    if GetVehicleClass(Vehicle['Vehicle']) == 14 then
        if not AnchoredBoats[GetVehicleNumberPlateText(Vehicle['Vehicle'])] then
            return true
        end
    end
end)

exports('CanTiltAnchor', function() 
    local Vehicle = VehicleModule.GetClosestVehicle()
    if GetVehicleClass(Vehicle['Vehicle']) == 14 then
        if AnchoredBoats[GetVehicleNumberPlateText(Vehicle['Vehicle'])] then
            return true
        end
    end
end)

