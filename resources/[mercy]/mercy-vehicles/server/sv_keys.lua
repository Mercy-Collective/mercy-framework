CreateThread(function() 
    while not _Ready do 
        Wait(100) 
    end 

    CallbackModule.CreateCallback('mercy-vehicles/server/get-keys', function(Source, Cb)
        Cb(Config.VehicleKeys)
    end)
end)

-- [ Events ] --

RegisterNetEvent("mercy-vehicles/server/set-keys", function(Plate, Bool, CitizenId)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    if CitizenId then
        if Config.VehicleKeys[Plate] ~= nil then
            Config.VehicleKeys[Plate][CitizenId] = Bool
        else
            Config.VehicleKeys[Plate] = {}
            Config.VehicleKeys[Plate][CitizenId] = Bool
        end
    else
        if Config.VehicleKeys[Plate] ~= nil then
            Config.VehicleKeys[Plate][Player.PlayerData.CitizenId] = Bool
        else
            if Plate == nil then return end
            Config.VehicleKeys[Plate] = {}
            Config.VehicleKeys[Plate][Player.PlayerData.CitizenId] = Bool
        end
    end

    TriggerClientEvent('mercy-vehicles/client/set-veh-keys', -1, Plate, Config.VehicleKeys[Plate])
end)