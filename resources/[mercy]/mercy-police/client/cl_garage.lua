RegisterNetEvent('mercy-police/client/try-purchase-vehicle', function()
    Citizen.SetTimeout(450, function()
        local MenuItems = {}
        for k, v in pairs(Config.PurchaseVehicles) do
            local MenuData = {}
            local SharedData = Shared.Vehicles[GetHashKey(v)]
            MenuData['Title'] = SharedData ~= nil and SharedData.Model..' '..SharedData.Name or GetLabelText(GetDisplayNameFromVehicleModel(v))
            MenuData['Desc'] = 'Price: $'..SharedData.Price..'.00 (Bank)'
            MenuData['Data'] = {['Event'] = '', ['Type'] = '' }
            MenuData['SecondMenu'] = {
                {
                    ['Title'] = 'Purchase Vehicle',
                    ['Type'] = 'Click',
                    ['CloseMenu'] = true,
                    ['Data'] = { ['Event'] = 'mercy-police/client/purchase-vehicle', ['Type'] = 'Client', ['BuyModel'] = v, ['BuyData'] = SharedData },
                },
            }
            table.insert(MenuItems, MenuData)
        end
        exports['mercy-ui']:OpenContext({ ['MainMenuItems'] = MenuItems }) 
    end)
end)

RegisterNetEvent('mercy-police/client/purchase-vehicle', function(Data)
    SetTimeout(500, function()
        local InputData = {{Name = 'StateId', Label = 'State Id (Empty is self)', Icon = 'fas fa-user'}}
        local HireInput = exports['mercy-ui']:CreateInput(InputData)
        EventsModule.TriggerServer('mercy-police/server/purchase-police-vehicle', Data, HireInput['StateId'])
    end)
end)

-- Garage

RegisterNetEvent('mercy-menu/client/open-garage-heli', function(CurrentPad)
    if CurrentPad == 'Police' then
        local MenuItems = {}
        for k, v in pairs(Config.HeliPad) do
            local MenuData = {}
            local SharedData = Shared.Vehicles[GetHashKey(v.Model)]
            MenuData['Title'] = SharedData ~= nil and SharedData.Model..' '..SharedData.Name or GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle))
            MenuData['Desc'] = 'Police Issued Helicopter'
            MenuData['Data'] = {['Event'] = '', ['Type'] = '' }
            MenuData['SecondMenu'] = {
                {
                    ['Title'] = 'Take Out Vehicle',
                    ['Type'] = 'Click',
                    ['CloseMenu'] = true,
                    ['Data'] = { ['Event'] = 'mercy-police/client/take-out-heli', ['Type'] = 'Client', ['HeliData'] = v },
                },
            }
            table.insert(MenuItems, MenuData)
        end 
        exports['mercy-ui']:OpenContext({ ['MainMenuItems'] = MenuItems }) 
    else
        return
    end
end)

RegisterNetEvent('mercy-police/client/take-out-heli', function(Data)
    local Player = PlayerModule.GetPlayerData()
    local HeliData = Data.HeliData
    if HeliData ~= nil then
        local VehicleCoords = {['X'] = HeliData.Coords.x, ['Y'] = HeliData.Coords.y, ['Z'] = HeliData.Coords.z, ['Heading'] = HeliData.Coords.w}
        local Vehicle = VehicleModule.SpawnVehicle(HeliData.Model, VehicleCoords, nil, false)
        if Vehicle ~= nil then
            Citizen.SetTimeout(250, function()
                local Plate = GetVehicleNumberPlateText(Vehicle['Vehicle'])
                exports['mercy-vehicles']:SetFuelLevel(Vehicle['Vehicle'], 100)
                exports['mercy-vehicles']:SetVehicleKeys(Plate, true, false)
                SetVehicleModKit(Vehicle['Vehicle'], 0)
                if Player.Job.Department ~= nil and Player.Job.Department == 'LSPD' then
                    SetVehicleLivery(Vehicle['Vehicle'], 0)
                elseif Player.Job.Department ~= nil and Player.Job.Department == 'BCSO' then
                    SetVehicleLivery(Vehicle['Vehicle'], 1)
                else
                    SetVehicleLivery(Vehicle['Vehicle'], 2)
                end
                NetworkFadeInEntity(Vehicle['Vehicle'], 0)
            end)
        end
    end
end)

-- [ Functions ] --

function GetClearSpawnPoint()
    local CurrentGarage = GetCurrentGarage()
    if CurrentGarage ~= nil then
        for k, v in pairs(Config.ParkingSlots[CurrentGarage]) do
            if VehicleModule.CanVehicleSpawnAtCoords(v, 1.85) then
                return v
            end
        end
        return false
    else
        return false
    end
end

function GetClearDepotSpawnPoint()
    for k, v in pairs(Config.DepotParkingSpots) do
        if VehicleModule.CanVehicleSpawnAtCoords(v, 1.85) then
            return v
        end
    end
    return false
end

function IsVehicleStillAvailable(Plate)
    local State = CallbackModule.SendCallback("mercy-police/server/get-vehicle-state", Plate)
    if State == false or State == 'Out' then return false end
    return true
end

function GetGarageData(Type)
    local Vehicles = CallbackModule.SendCallback("mercy-police/server/get-garage", Type)
    return Vehicles
end