RegisterNetEvent('mercy-pdm/client/open-bicycle-store', function()
    local MenuItems = {}
    for k, v in pairs(Shared.Vehicles) do
        if v.ShopClass == 'Cycle' then
            local MenuData = {}
            MenuData['Title'] = v.Model..' '..v.Name
            MenuData['Desc'] = 'Purchase this bicycle for: $'.. FunctionsModule.GetTaxPrice(v.Price, 'Vehicle')..'.00'
            MenuData['Data'] = {['Event'] = 'mercy-pdm/client/try-buy-bicycle', ['Type'] = 'Client', ['BikeData'] = v }
            MenuData['Type'] = 'Click'
            table.insert(MenuItems, MenuData)
        end
    end
    exports['mercy-ui']:OpenContext({ ['MainMenuItems'] = MenuItems }) 
end)

RegisterNetEvent('mercy-pdm/client/try-buy-bicycle', function(Data)
    EventsModule.TriggerServer('mercy-pdm/server/buy-bicycle', Data.BikeData)
end)

RegisterNetEvent('mercy-pdm/client/bought-bicycle', function(Model, Plate)
    local ModelLoaded = FunctionsModule.RequestModel(Model)
    local VehicleCoords = { ['X'] = -1108.37, ['Y'] =  -1688.97, ['Z'] = 4.36, ['Heading'] = 33.3 }
    if ModelLoaded then
        DoScreenFadeOut(200)
        while not IsScreenFadedOut() do Citizen.Wait(10) end
        local Vehicle = VehicleModule.SpawnVehicle(Model, VehicleCoords, Plate, true)
        if Vehicle ~= nil then
            Citizen.SetTimeout(450, function()
                exports['mercy-vehicles']:SetVehicleKeys(Plate, true, false)
                exports['mercy-vehicles']:SetFuelLevel(Vehicle.Vehicle, 100)
            end)
            DoScreenFadeIn(200)
        end
    end
end)