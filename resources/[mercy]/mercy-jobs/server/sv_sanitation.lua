-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(450)
    end

    EventsModule.RegisterServer("mercy-jobs/server/sanitation/set-busy", function(Source, Location)
        Config.SanitationZones[Location].Busy = not Config.SanitationZones[Location].Busy
        ServerConfig.OpenedBins = {}
    end)

    CallbackModule.CreateCallback('mercy-jobs/server/sanitation/is-dumpster-empty', function(Source, Cb, NetId)
        if ServerConfig.OpenedBins[NetId] ~= nil then
            if ServerConfig.OpenedBins[NetId] then
                Cb(true)
            else
                ServerConfig.OpenedBins[NetId] = true
                Cb(false)
            end
        else
            ServerConfig.OpenedBins[NetId] = true
            Cb(false)
        end
    end)
end)

-- [ Events ] --

RegisterNetEvent("mercy-jobs/server/sanitation/delete-bin-bag", function(NetId)
    local Bag = NetworkGetEntityFromNetworkId(NetId)
    if DoesEntityExist(Bag) then 
        DeleteEntity(Bag)
    end
end)