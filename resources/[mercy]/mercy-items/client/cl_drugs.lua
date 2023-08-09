
RegisterNetEvent('mercy-items/client/used-joint', function()
    Citizen.SetTimeout(450, function()
        exports['mercy-inventory']:SetBusyState(true)
        exports['mercy-ui']:ProgressBar('Smoking Joint..', 2000, false, false, false, true, function(DidComplete)
            if DidComplete then
                local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', 'joint', 1, false, true)
                if DidRemove then
                    if IsPedInAnyVehicle(PlayerPedId()) then
                        TriggerEvent('mercy-animations/client/play-animation', 'smoke')
                    else
                        TriggerEvent('mercy-animations/client/play-animation', 'smokeweed')
                    end
                    if not RemovingStress then
                        RemovingStress = true
                        Citizen.CreateThread(function()
                            for i = 1, math.random(4, 6) do
                                EventsModule.TriggerServer('mercy-ui/server/set-stress', 'Remove', math.random(6, 7))
                                local CurrentArmor = GetPedArmour(PlayerPedId())
                                if CurrentArmor + 9 < 100 then
                                    SetPedArmour(PlayerPedId(), CurrentArmor + 9)
                                else
                                    SetPedArmour(PlayerPedId(), 100)
                                end
                                Citizen.Wait(2500)
                            end
                            TriggerEvent('mercy-hospital/client/save-vitals')
                            RemovingStress = false
                        end)
                        if not exports['mercy-police']:IsStatusAlreadyActive('redeyes') then
                            TriggerEvent('mercy-police/client/evidence/set-status', 'redeyes', 250)
                        end
                        if not exports['mercy-police']:IsStatusAlreadyActive('weedsmell') then
                            TriggerEvent('mercy-police/client/evidence/set-status', 'weedsmell', 250)
                        end
                    end
                end
            end
            exports['mercy-inventory']:SetBusyState(false)
        end)
    end)
end)