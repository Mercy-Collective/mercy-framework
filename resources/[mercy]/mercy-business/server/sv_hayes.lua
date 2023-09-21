-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(450)
    end

    CallbackModule.CreateCallback('mercy-business/server/hayes/get-parts', function(Source, Cb)
        Cb(Config.VehicleParts)
    end)

    CallbackModule.CreateCallback('mercy-business/server/hayes/get-new-percentage', function(Source, Cb, Misc, CreateDate, Slot, VehNetId)
        -- TODO: Calculate Item Quality from CreateDate / how much item has decayed and return as percentage
        local NewPercentage = 100
        TriggerEvent('mercy-vehicles/server/set-veh-meta', VehNetId, Misc, NewPercentage)
        Cb(NewPercentage)
    end)

    EventsModule.RegisterServer('mercy-business/server/hayes/repair-part', function(Source, Plate, Part) 
        Config.VehicleParts[Plate][Part] = 100
        SaveVehicleParts(Plate, Config.VehicleParts[Plate])
        TriggerClientEvent('mercy-business/client/hayes/sync-parts', -1, Plate, Config.VehicleParts[Plate])
    end)

    EventsModule.RegisterServer('mercy-business/server/hayes/do-parts-damage', function(Source, Plate, Model, PartName) 
        if Config.VehicleParts[Plate] ~= nil then
            local VehicleData = Shared.Vehicles[Model]
            if VehicleData == nil then return end
            if Config.VehicleParts[Plate][PartName] == nil then return end
            if VehicleData.Class == 'S' then
                local RandomMinus = math.random(1, 2)
                if Config.VehicleParts[Plate][PartName] - RandomMinus > 0 then
                    Config.VehicleParts[Plate][PartName] = Config.VehicleParts[Plate][PartName] - RandomMinus
                else
                    Config.VehicleParts[Plate][PartName] = 0
                end
            elseif VehicleData.Class == 'A' then
                local RandomMinus = math.random(1, 3)
                if Config.VehicleParts[Plate][PartName] - RandomMinus > 0 then
                    Config.VehicleParts[Plate][PartName] = Config.VehicleParts[Plate][PartName] - RandomMinus
                else
                    Config.VehicleParts[Plate][PartName] = 0
                end
            elseif VehicleData.Class == 'B' then
                local RandomMinus = math.random(1, 4)
                if Config.VehicleParts[Plate][PartName] - RandomMinus > 0 then
                    Config.VehicleParts[Plate][PartName] = Config.VehicleParts[Plate][PartName] - RandomMinus
                else
                    Config.VehicleParts[Plate][PartName] = 0
                end
            elseif VehicleData.Class == 'C' then
                local RandomMinus = math.random(1, 5)
                if Config.VehicleParts[Plate][PartName] - RandomMinus > 0 then
                    Config.VehicleParts[Plate][PartName] = Config.VehicleParts[Plate][PartName] - RandomMinus
                else
                    Config.VehicleParts[Plate][PartName] = 0
                end
            elseif VehicleData.Class == 'D' then
                local RandomMinus = math.random(1, 6)
                if Config.VehicleParts[Plate][PartName] - RandomMinus > 0 then
                    Config.VehicleParts[Plate][PartName] = Config.VehicleParts[Plate][PartName] - RandomMinus
                else
                    Config.VehicleParts[Plate][PartName] = 0
                end
            elseif VehicleData.Class == 'E' then
                local RandomMinus = math.random(1, 7)
                if Config.VehicleParts[Plate][PartName] - RandomMinus > 0 then
                    Config.VehicleParts[Plate][PartName] = Config.VehicleParts[Plate][PartName] - RandomMinus
                else
                    Config.VehicleParts[Plate][PartName] = 0
                end
            elseif VehicleData.Class == 'M' then
                local RandomMinus = math.random(1, 8)
                if Config.VehicleParts[Plate][PartName] - RandomMinus > 0 then
                    Config.VehicleParts[Plate][PartName] = Config.VehicleParts[Plate][PartName] - RandomMinus
                else
                    Config.VehicleParts[Plate][PartName] = 0
                end
            end
            SaveVehicleParts(Plate, Config.VehicleParts[Plate])
            TriggerClientEvent('mercy-business/client/hayes/sync-parts', -1, Plate, Config.VehicleParts[Plate])
        end
    end)
end)

-- [ Events ] --

RegisterNetEvent("mercy-business/server/hayes/load-parts", function(Plate, Parts)
    if Parts ~= nil then
        Config.VehicleParts[Plate] = Parts
    else
        local VehicleParts = LoadVehicleParts(Plate) or {
            Engine = 100,
            Body = 100,
            Fuel = 100,
            Axle = 100,
            Transmission = 100,
            FuelInjectors = 100,
            Clutch = 100,
            Brakes = 100,
        }
        Config.VehicleParts[Plate] = VehicleParts
        TriggerClientEvent('mercy-business/client/hayes/sync-parts', -1, Plate, Config.VehicleParts[Plate])
    end
end)

RegisterNetEvent("mercy-business/server/hayes/unload-parts", function(Plate)
    SaveVehicleParts(Plate, Config.VehicleParts[Plate])
    Config.VehicleParts[Plate] = nil
    TriggerClientEvent('mercy-business/client/hayes/sync-parts', -1, Plate, Config.VehicleParts[Plate])
end)

-- [ Functions ] --

function SaveVehicleParts(Plate, PartData)
    if PartData == nil then return end
    DatabaseModule.Update("UPDATE player_vehicles SET parts = ? WHERE plate = ? ", {
        json.encode(PartData),
        Plate
    })
end

function LoadVehicleParts(Plate)
    local Promise = promise:new()
    DatabaseModule.Execute("SELECT * FROM player_vehicles WHERE plate = ?", {
        Plate
    }, function(VehicleData)
        if VehicleData[1] ~= nil then
            Promise:resolve(json.decode(VehicleData[1].parts))
        else
            Promise:resolve(false)
        end
    end)
    return Citizen.Await(Promise)
end
