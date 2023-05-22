
RegisterNetEvent('mercy-pdm/client/open-job-store', function()
    local MenuItems = {}
    for k, v in pairs(Shared.Vehicles) do
        if v.ShopClass == 'Job' then
            local MenuData = {}
            MenuData['Title'] = v.Model..' '..v.Name
            MenuData['Desc'] = 'Purchase this vehicle for: $'.. FunctionsModule.GetTaxPrice(v.Price, 'Vehicle')..'.00'
            MenuData['Data'] = {['Event'] = 'mercy-pdm/client/try-buy-job-vehicle', ['Type'] = 'Client', ['VehicleData'] = v }
            MenuData['Type'] = 'Click'
            table.insert(MenuItems, MenuData)
        end
    end
    exports['mercy-ui']:OpenContext({ ['MainMenuItems'] = MenuItems })
end)

RegisterNetEvent('mercy-pdm/client/try-buy-job-vehicle', function(Data)
    EventsModule.TriggerServer('mercy-pdm/server/buy-vehicle', Data.VehicleData.Vehicle)
end)