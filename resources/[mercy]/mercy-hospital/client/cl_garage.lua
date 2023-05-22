RegisterNetEvent('mercy-menu/client/open-garage-heli', function(CurrentPad)
    if CurrentPad == 'Hospital' then
        local MenuItems = {}
        for k, v in pairs(Config.HeliPad) do
            local MenuData = {}
            local SharedData = Shared.Vehicles[GetHashKey(v.Model)]
            MenuData['Title'] = SharedData ~= nil and SharedData['Model'] .. ' ' .. SharedData['Name'] or GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle))
            MenuData['Desc'] = 'EMS Issued Helicopter'
            MenuData['Data'] = {['Event'] = '', ['Type'] = '' }
            MenuData['SecondMenu'] = {
                {
                    ['Title'] = 'Take Out Vehicle',
                    ['Type'] = 'Click',
                    ['Data'] = { ['Event'] = 'mercy-hospital/client/take-out-heli', ['Type'] = 'Client', ['HeliData'] = v },
                },
            }
            table.insert(MenuItems, MenuData)
        end 
        exports['mercy-ui']:OpenContext({ ['MainMenuItems'] = MenuItems }) 
    else
        return
    end
end)

RegisterNetEvent('mercy-hospital/client/take-out-heli', function(Data)
    local HeliData = Data.HeliData
    if HeliData ~= nil then
        local VehicleCoords = {['X'] = HeliData.Coords.x, ['Y'] = HeliData.Coords.y, ['Z'] = HeliData.Coords.z, ['Heading'] = HeliData.Coords.w}
        local Vehicle = VehicleModule.SpawnVehicle(HeliData.Model, VehicleCoords, nil, false)
        if Vehicle ~= nil then
            Citizen.SetTimeout(500, function()
                local Plate = GetVehicleNumberPlateText(Vehicle['Vehicle'])
                exports['mercy-vehicles']:SetFuelLevel(Vehicle['Vehicle'], 100)
                exports['mercy-vehicles']:SetVehicleKeys(Plate, true, false)
            end)
        end
    end
end)

RegisterNetEvent('mercy-hospital/client/open-garage', function()
    local MenuItems = {}
    for k, v in pairs(Config.Garage) do
        local MenuData = {}
        local SharedData = Shared.Vehicles[GetHashKey(v.Model)]
        MenuData['Title'] = SharedData ~= nil and SharedData['Model'] .. ' ' .. SharedData['Name'] or GetLabelText(GetDisplayNameFromVehicleModel(v.Model))
        MenuData['Desc'] = 'Choose me <3'
        MenuData['Data'] = {['Event'] = '', ['Type'] = ''}
        MenuData['SecondMenu'] = {
            {
                ['Title'] = 'Choose Vehicle', 
                ['Data'] = {['Event'] = 'mercy-hospital/client/spawn-vehicle', ['Type'] = 'Client', ['Model'] = v.Model},
                ['CloseMenu'] = true,
            }
        }
        table.insert(MenuItems, MenuData)
    end
    exports['mercy-ui']:OpenContext({ ['MainMenuItems'] = MenuItems }) 
end)

RegisterNetEvent('mercy-hospital/client/spawn-vehicle', function(Data)
    if FunctionModule.RequestModel(Data.Model) then
        local TargetCoords = GetClearSpawnPoint()
        if TargetCoords ~= false then
            local VehicleCoords = {['X'] = TargetCoords.x, ['Y'] = TargetCoords.y, ['Z'] = TargetCoords.z, ['Heading'] = TargetCoords.w}
            local Vehicle = VehicleModule.SpawnVehicle(Data.Model, VehicleCoords, nil, false)
            if Vehicle ~= nil then
                Citizen.SetTimeout(500, function()
                    local Plate = GetVehicleNumberPlateText(Vehicle.Vehicle)
                    exports['mercy-vehicles']:SetVehicleKeys(Plate, true, false)
                    exports['mercy-vehicles']:SetFuelLevel(Vehicle.Vehicle, 100)
                end)
            end
        end
    end
end)

RegisterNetEvent('mercy-hospital/client/park-vehicle', function(Data)
    VehicleModule.DeleteVehicle(Data.Entity)
end)

-- [ Functions ] --

function GetClearSpawnPoint()
    for k, v in pairs(Config.ParkingSlots) do
        if VehicleModule.CanVehicleSpawnAtCoords(v, 1.85) then
            return v
        end
    end
    return false
end