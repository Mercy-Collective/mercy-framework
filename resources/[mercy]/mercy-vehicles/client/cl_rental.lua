local ParkingSlots = {
    [1] = {['Coords'] = vector4(117.46, -1081.91, 29.22, 179.70)},
    [2] = {['Coords'] = vector4(111.44, -1080.59, 29.19, 157.12)},
    [3] = {['Coords'] = vector4(107.84, -1079.72, 29.19, 158.10)},
    [4] = {['Coords'] = vector4(104.53, -1078.11, 29.19, 157.17)},
}

-- [ Events ] --

RegisterNetEvent('mercy-items/client/used-rental-papers', function(Plate)
    if not HasKeysToVehicle(Plate) then
        SetVehicleKeys(Plate, true)
        exports['mercy-ui']:Notify('rental-keys', "Received key for this vehicle!", 'success')
    else
        exports['mercy-ui']:Notify('rental-keys', "You already have keys to this vehicle..", 'error')
    end
end)

RegisterNetEvent('mercy-vehicles/client/try-rent', function(Data)
    local MenuItems = {}
    for k, v in pairs(Config.Rentals[Data.Type]) do
        local MenuData = {}
        MenuData['Title'] = v.Label
        MenuData['Desc'] = ("Rent Price: $%s"):format(FunctionsModule.GetTaxPrice(v.Price, 'Vehicle'))
        MenuData['Data'] = { ['Event'] = '', ['Type'] = '' }
        MenuData['SecondMenu'] = {
            {
                ['Title'] = 'Confirm',
                ['Type'] = 'Click',
                ['CloseMenu'] = true,
                ['Data'] = { 
                    ['Event'] = 'mercy-vehicles/client/rent-vehicle', 
                    ['Type'] = 'Client', 
                    ['RentalType'] = Data.Type,
                    ['Model'] = v.Model,
                    ['Price'] = FunctionsModule.GetTaxPrice(v.Price, 'Vehicle') },
            },
        }
        table.insert(MenuItems, MenuData)
    end
    exports['mercy-ui']:OpenContext({ ['MainMenuItems'] = MenuItems })
end)

RegisterNetEvent('mercy-vehicles/client/rent-vehicle', function(Data)
    local RandomPlate = ('RE'..Shared.RandomInt(3)..Shared.RandomStr(3)):upper()

    local CanSpawn = VehicleModule.CanVehicleSpawnAtCoords(vector3(Config.RentalSpawn[Data.RentalType].x, Config.RentalSpawn[Data.RentalType].y, Config.RentalSpawn[Data.RentalType].z), 1.85)
    if not CanSpawn then
        return exports['mercy-ui']:Notify('blocking', "There is a vehicle blocking the spot..", "error")
    end

    local HasPaid = CallbackModule.SendCallback("mercy-base/server/remove-cash", Data.Price)
    if HasPaid then
        exports['mercy-ui']:ProgressBar('Fixing up papers.. (Don\'t move)', 15000, {}, false, true, true, function(DidComplete)
            if DidComplete then
                local StartRentCoords = GetEntityCoords(PlayerPedId())
                if #(GetEntityCoords(PlayerPedId()) - StartRentCoords) > 2.0 then
                    return exports['mercy-ui']:Notify('too-far', "Idiot, you went too far..", "error")
                end
                local LoadedVehicle = FunctionsModule.RequestModel(Data.Model)
                if LoadedVehicle then
                    local VehicleCoords = {['X'] = Config.RentalSpawn[Data.RentalType].x, ['Y'] = Config.RentalSpawn[Data.RentalType].y, ['Z'] = Config.RentalSpawn[Data.RentalType].z - 1.0, ['Heading'] = Config.RentalSpawn[Data.RentalType].w}
                    local Vehicle = VehicleModule.SpawnVehicle(Data.Model, VehicleCoords, RandomPlate, false)
                    if Vehicle ~= nil then        
                        SetTimeout(650, function()
                            EventsModule.TriggerServer('mercy-vehicles/server/receive-rental-papers', RandomPlate)
                            exports['mercy-vehicles']:SetVehicleKeys(RandomPlate, true, false)
                            exports['mercy-vehicles']:SetFuelLevel(Vehicle['Vehicle'], 100)
                            SetVehicleDirtLevel(Vehicle['Vehicle'], 0.0)
                        end)
                    end
                end
            end
        end)
    else
        exports['mercy-ui']:Notify('rental-error', "Need more money than that..", 'error')
    end
end)

-- [ Threads ] --

CreateThread(function()
    exports['mercy-ui']:AddEyeEntry("vehicle-rentals", {
        Type = 'Entity',
        EntityType = 'Ped',
        SpriteDistance = 10.0,
        Distance = 5.0,
        Position = vector4(110.67, -1090.19, 28.40, 30.3),
        Model = 'a_m_y_genstreet_01',
        Anim = {},
        Props = {},
        Options = {
            {
                Name = 'rent_vehicle',
                Icon = 'fas fa-car',
                Label = 'Rent Vehicle',
                EventType = 'Client',
                EventName = 'mercy-vehicles/client/try-rent',
                EventParams = { Type = "Cars" },
                Enabled = function(Entity)
                    return true
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("boat_rental_puerta", {
        Type = 'Entity',
        EntityType = 'Ped',
        SpriteDistance = 10.0,
        Distance = 1.0,
        Position = vector4(-848.55, -1368.33, 0.61, 288.03),
        Model = 'mp_m_boatstaff_01',
        Options = {
            {
                Name = 'rent_boat',
                Icon = 'fas fa-circle',
                Label = 'Rent Boat',
                EventType = 'Client',
                EventName = 'mercy-vehicles/client/try-rent',
                EventParams = { Type = "Boats" },
                Enabled = function(Entity)
                    return true
                end,
            },
        }
    })
end)