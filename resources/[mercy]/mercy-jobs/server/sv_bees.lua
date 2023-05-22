-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(450)
    end

    EventsModule.RegisterServer("mercy-jobs/server/bees/place", function(Source, Coords, Heading)
        local NewHive = {
            Stage = 0,
            Queen = false,
            Id = math.random(1111, 9999),
            Coords = { 
                X = Coords.x,
                Y = Coords.y,
                Z = Coords.z,
                H = Heading
            }
        }
        Config.BeeHives[NewHive.Id] = NewHive
        TriggerClientEvent('mercy-jobs/client/bees/action', -1, 2, NewHive)
    end)
end)

-- Update Bee Hives
Citizen.CreateThread(function()
    Citizen.SetTimeout(750, function()
        while true do
            local RandomValue = math.random(1, 10)
            for k, hive in pairs(Config.BeeHives) do
                if hive['Stage'] + RandomValue > 100 then
                    hive['Stage'] = 100
                else
                    hive['Stage'] = hive['Stage'] + RandomValue
                end
            end
            TriggerClientEvent('mercy-jobs/client/bees/action', -1, 1, Config.BeeHives)
            Citizen.Wait((60 * 1000) * 20) -- 20 Mins
        end
    end)
end)

-- [ Events ] --

RegisterNetEvent("mercy-jobs/server/bees/do-stuff", function(Type, HiveId)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    if Type == 'Queen' then
        Config.BeeHives[HiveId].Queen = true
        TriggerClientEvent('mercy-jobs/client/bees/action', -1, 3, Config.BeeHives[HiveId])
    elseif Type == 'Destroy' then
        Player.Functions.AddItem('beehive', 1, false, false, true)
        TriggerClientEvent('mercy-jobs/client/bees/action', -1, 4, Config.BeeHives[HiveId])
        Config.BeeHives[HiveId] = nil
    elseif Type == 'Harvest' then
        if Config.BeeHives[HiveId] ~= nil then
            Config.BeeHives[HiveId].Stage = 0
            TriggerClientEvent('mercy-jobs/client/bees/action', -1, 3, Config.BeeHives[HiveId])
            Player.Functions.AddItem('bee-honey', math.random(1, 2), false, false, true)
            if math.random(1,5) <= 2 then
                Player.Functions.AddItem('bee-wax', math.random(1, 2), false, false, true)
            end
        end
    end
end)