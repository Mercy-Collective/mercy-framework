-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(450)
    end

    CallbackModule.CreateCallback('mercy-jobs/server/can-mine-this-spot', function(Source, Cb, MiningSpot)
        if Config.MiningSpots[MiningSpot]['Busy'] then return Cb('No') end
        if not Config.MiningSpots[MiningSpot]['Mined'] then
            Cb('Yes')
        else
            Cb('No')
        end
    end)

    EventsModule.RegisterServer("mercy-jobs/server/mining/grab", function(Source, ItemName)
        local Player = PlayerModule.GetPlayerBySource(Source)
        Player.Functions.AddItem(ItemName, 1, false, false, true)
    end)
    
    EventsModule.RegisterServer("mercy-jobs/server/mining/receive-goods", function(Source, Mined)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if not Mined then
            for i = 1, math.random(2, 6) do
                local RandomItem = ServerConfig.MiningMaterials[math.random(#ServerConfig.MiningMaterials)]
                Player.Functions.AddItem(RandomItem, math.random(5, 7), false, false, true)
            end
            local RandomValue = math.random(1, 1000)
            if RandomValue >= 550 and RandomValue <= 560 then
                Player.Functions.AddItem('goldbar', 1, false, false, true)
            end
        else
            for i = 1, math.random(2, 3) do
                local RandomItem = ServerConfig.MiningMaterials[math.random(#ServerConfig.MiningMaterials)]
                Player.Functions.AddItem(RandomItem, 1, false, false, true)
            end
        end
    end)
end)