-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('mercy-illegal/client/open-dry-rack', function()
    if exports['mercy-inventory']:CanOpenInventory() then
        Citizen.SetTimeout(450, function()
            local IsBusy = CallbackModule.SendCallback('mercy-illegal/server/is-dryer-busy')
            if not IsBusy then    
                EventsModule.TriggerServer('mercy-inventory/server/open-other-inventory', 'dry-rack', 'Temp', 5, 1000)
            else
                TriggerEvent('mercy-ui/client/notify', "dryer-error", "The dryer is busy..", 'error')
            end
        end)
    end
end)

RegisterNetEvent('mercy-items/client/used-scales', function()
    local PlayerData = PlayerModule.GetPlayerData()
    if exports['mercy-inventory']:CanOpenInventory() then
        Citizen.SetTimeout(450, function()
            EventsModule.TriggerServer('mercy-inventory/server/open-other-inventory', 'Scales Crafting'..PlayerData.CitizenId, 'Crafting', 0, 0, Config.ScalesCrafting)
        end)
    end
end)
