-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(450)
    end

    EventsModule.RegisterServer("mercy-jobs/server/fishing-sell", function(Source)
        local Player = PlayerModule.GetPlayerBySource(Source)
        for k, v in pairs(ServerConfig.FishSellItems) do
            local Item = Player.Functions.GetItemByName(k)
            if Item ~= nil then
                if Item.Amount > 0 then
                    for i = 1, Item.Amount do
                        Player.Functions.RemoveItem(Item.ItemName, 1, false, true)
                        if v['Type'] == 'Item' then
                            Player.Functions.AddItem(v['Item'], v['Amount'])
                        else
                            Player.Functions.AddMoney('Cash', v['Amount'], 'sold-fish')
                        end
                        Citizen.Wait(250)
                    end
                end
            end
        end
    end)

    EventsModule.RegisterServer("mercy-jobs/server/fishing-receive-goods", function(Source, Type)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Type == 'Big' then
            local RandomBig = math.random(1, 4)
            if RandomBig == 1 then
                Player.Functions.AddItem('fish-blue', 1, false, false, true)
            elseif RandomBig == 2 then
                Player.Functions.AddItem('fish-bass', 1, false, false, true)
            elseif RandomBig == 3 then
                Player.Functions.AddItem('fish-cod', 1, false, false, true)
            elseif RandomBig == 4 then
                Player.Functions.AddItem('fish-flounder', 1, false, false, true)
            end
        elseif Type == 'Small' then
            Player.Functions.AddItem('fish-mackerel', 1, false, false, true)
        elseif Type == 'Special' then
            local RandomSpecial = math.random(1, 2)
            local RandomFail = math.random(1, 10)
            if RandomSpecial == 1 then
                if RandomFail > 5 then
                    Player.Functions.Notify('fish-lost', 'The fish escaped..', 'error')
                else
                    Player.Functions.AddItem('fish-shark', 1, false, false, true)
                end
            else
                if RandomFail > 5 then
                    Player.Functions.Notify('fish-lost', 'The fish escaped..', 'error')
                else
                    Player.Functions.AddItem('fish-whale', 1, false, false, true)
                end
            end
        end
    end)
end)

-- Update Fishing Spot
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        ServerConfig.CurrentFishSpot = ServerConfig.FishingSpots[math.random(1, #ServerConfig.FishingSpots)]
        TriggerClientEvent('mercy-jobs/client/fishing/set-fishing-spot', -1, ServerConfig.CurrentFishSpot)
        Citizen.Wait(1000 * 60 * 6) -- 6 Mins
    end
end)