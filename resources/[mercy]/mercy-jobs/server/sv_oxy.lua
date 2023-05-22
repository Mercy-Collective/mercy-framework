-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(450)
    end

    CallbackModule.CreateCallback('mercy-jobs/server/oxy/get-pos', function(Source, Cb, Type)
        Cb(ServerConfig.OxyPositions[Type])
    end)
    
    CallbackModule.CreateCallback('mercy-jobs/server/oxy/get-random-oxy-loc', function(Source, Cb, Leader)
        local RandomLocation = ServerConfig.OxyLocations[math.random(1, #ServerConfig.OxyLocations)]
        ServerConfig.OxyLocation = RandomLocation
        Cb(ServerConfig.OxyLocation)
    end)
    
    CallbackModule.CreateCallback('mercy-jobs/server/oxy/can-deliver-package', function(Source, Cb, NetId)
        if not ServerConfig.OxyVehicles[NetId] == nil then return Cb(false) end
        if ServerConfig.OxyVehicles[NetId].Delivered then
            Cb(false)
        else
            Cb(true)
        end
    end)

    EventsModule.RegisterServer("mercy-jobs/server/oxy/spawn-oxy", function(Source)
        local VehicleCoords = ServerConfig.OxyLocation['SpawnCoords']
        local DriveCoords = ServerConfig.OxyLocation['DriveCoords']

        local RandomPed = ServerConfig.DriverPeds[math.random(1, #ServerConfig.DriverPeds)]
        local RandomVehicle = ServerConfig.DeliveryVehicles[math.random(1, #ServerConfig.DeliveryVehicles)]
        local Vehicle = CreateVehicle(GetHashKey(RandomVehicle), VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, VehicleCoords.w, true, false);
        while not DoesEntityExist(Vehicle) do
            Citizen.Wait(5)
        end
        CreatePedInsideVehicle(Vehicle, 4, GetHashKey(RandomPed), -1, true)
        -- Do veh stuff
        local OxyNetId = NetworkGetNetworkIdFromEntity(Vehicle)
        ServerConfig.OxyVehicles[OxyNetId] = {
            Delivered = false
        }
        TriggerClientEvent('mercy-jobs/client/oxy/set-veh-data', -1, OxyNetId, false)
        TriggerClientEvent('mercy-jobs/client/oxy/veh-drive-to-coord', -1, OxyNetId, DriveCoords)
    end)
    
    EventsModule.RegisterServer("mercy-jobs/server/oxy/get-reward", function(Source, NetId)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if not Player then return end

        if Player.Functions.RemoveItem('darkmarketpackage', 1, false, true) then
            -- Set vehicle delivered
            ServerConfig.OxyVehicles[NetId].Delivered = true
            TriggerClientEvent('mercy-jobs/client/oxy/set-veh-data', -1, nil, true)
            -- ServerConfig.OxyLocation = nil

            -- Give reward
            local RandomValue = math.random(1, 3)
            if RandomValue == 1 then
                Player.Functions.AddItem('moonshine', math.random(2, 4), false, false, true)
            elseif RandomValue == 2 then
                Player.Functions.AddItem('joint', math.random(1, 2), false, false, true)
            elseif RandomValue == 3 then
                Player.Functions.AddItem('oxy', math.random(1, 2), false, false, true)
            end
        end
    end)
end)