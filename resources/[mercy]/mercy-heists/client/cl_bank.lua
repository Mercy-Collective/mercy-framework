-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('mercy-heists/client/try-panel-hack', function(Data, Entity)
    local Secure = CallbackModule.SendCallback('mercy-police/server/can-rob')
    if Secure then return exports['mercy-ui']:Notify("heists-error", "Secure active!", "error") end
    Citizen.SetTimeout(450, function()
        if Data.Laptop == 'Green' then
            local Type = GetCurrentRobberyType()
            local BankData = Config.Panels[Type][Data.Panel] ~= nil and Config.Panels[Type][Data.Panel] or false
            if BankData ~= false and not BankData.Hacked and BankData.CanUsePanel then
                local StreetLabel = FunctionsModule.GetStreetName()
                EventsModule.TriggerServer('mercy-ui/server/send-bank-rob', StreetLabel)
                TriggerServerEvent('mercy-heists/server/banks/set-panel-state', 'Fleeca', Data.Panel, false)
                EventsModule.TriggerServer('mercy-inventory/server/degen-item', exports['mercy-inventory']:GetSlotForItem('heist-laptop-green'), 33.0)
                exports['mercy-ui']:MemoryMinigame(function(Outcome)
                    if Outcome then
                        TriggerEvent('mercy-ui/client/notify', "bankrob-success", "Be patient bitch", 'success')
                        local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', 'heist-laptop-green', 1, false, true)
                        Citizen.CreateThread(function()
                            Citizen.SetTimeout((1000 * 60) * 1.75, function()
                                SpawnTrolley(BankData.Trolly.Coords, 'Money')
                                TriggerServerEvent('mercy-heists/server/banks/set-hacked-state', 'Fleeca', Data.Panel, true)
                            end)
                        end)
                    else
                        TriggerServerEvent('mercy-heists/server/banks/set-panel-state', 'Fleeca', Data.Panel, true)
                        TriggerEvent('mercy-ui/client/notify', "bankrob-error", "Something went wrong! (You\'re a noob)", 'error')
                    end
                end)
            end
        end
    end)
end)
