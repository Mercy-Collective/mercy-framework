-- [ Code ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(4)
    end

    CallbackModule.CreateCallback('mercy-heists/server/jewellery/get-state', function(Source, Cb)
        Cb(Config.JewelleryState)
    end)

    CallbackModule.CreateCallback('mercy-heists/server/jewellery/can-rob-vitrine', function(Source, Cb, VitrineId)
        Cb(not Config.JewelleryVitrines[VitrineId])
    end)

    EventsModule.RegisterServer("mercy-heists/server/jewellery/set-vitrine-state", function(Source, VitrineId, Bool)    
        Config.JewelleryVitrines[VitrineId] = Bool
    end)

    EventsModule.RegisterServer("mercy-heists/server/jewellery/set-state", function(Source, Bool)
        Config.JewelleryState = Bool
        TriggerClientEvent('mercy-heists/client/jewellery/sync-state', -1, Config.JewelleryState)
        if Bool then
            Citizen.SetTimeout((1000 * 60) * Config.ResetTimes['Jewellery'], function() -- 30 Mins
                Config.JewelleryState = false
                TriggerClientEvent('mercy-heists/client/jewellery/sync-state', -1, Config.JewelleryState)
                TriggerEvent('mercy-doors/server/set-locks', Config.JewelleryDoors[1], 1)
                TriggerEvent('mercy-doors/server/set-locks', Config.JewelleryDoors[2], 1)
                for k, v in pairs(Config.JewelleryVitrines) do
                    Config.JewelleryVitrines[k] = false
                end
            end)
        end
    end)

    EventsModule.RegisterServer("mercy-heists/server/jewellery/give-reward", function(Source)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local RandomValue = math.random(1, 100)
        if RandomValue <= 10 then
            Player.Functions.AddItem('2ctchain', math.random(6,10), false, false, true)
        elseif RandomValue >= 11 and RandomValue <= 35 then
            Player.Functions.AddItem('ring', math.random(5,7), false, false, true)
        elseif RandomValue >= 36 and RandomValue <= 45 then
            Player.Functions.AddItem('rolexwatch', math.random(5,7), false, false, true)
        elseif RandomValue >= 46 and RandomValue <= 65 then
            Player.Functions.AddItem('5ctchain', math.random(4,6), false, false, true)
        elseif RandomValue >= 66 and RandomValue <= 75 then
            Player.Functions.AddItem('8ctchain', math.random(2,4), false, false, true)
        else
            local Info = {}
            Info['GemType'] = Config.GemTypes[math.random(1, #Config.GemTypes)]
            Info['Purity'] = math.random(1, 10)
            Player.Functions.AddItem('gemstone', 1, false, Info, true)
        end
    end)
end)