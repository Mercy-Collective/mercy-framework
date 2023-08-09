-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('mercy-business/client/digitalden/craft', function()
    if not exports['mercy-business']:HasPlayerBusinessPermission('Digital Den', 'craft_access') then return end
    Citizen.SetTimeout(450, function()
        if exports['mercy-inventory']:CanOpenInventory() then
            EventsModule.TriggerServer('mercy-inventory/server/open-other-inventory', 'Digital Crafting', 'Crafting', 0, 0, Config.DigitalCrafting)
        end
    end)
end)

RegisterNetEvent('mercy-business/client/digitalden/open-table', function()
    Citizen.SetTimeout(450, function()
        if exports['mercy-inventory']:CanOpenInventory() then
            EventsModule.TriggerServer('mercy-inventory/server/open-other-inventory', 'digital_table', 'Temp', 5, 100.0)
        end
    end)
end)