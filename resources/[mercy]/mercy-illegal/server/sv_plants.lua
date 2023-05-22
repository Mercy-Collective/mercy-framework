-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(250)
    end

    CallbackModule.CreateCallback('mercy-illegal/server/get-plants', function(Source, Cb)
        DatabaseModule.Execute('SELECT * FROM player_weedplants', {}, function(Result)
            if Result[1] == nil then return Cb({}) end
            for _, Plant in pairs(Result) do
                local PlantData = json.decode(Plant.PlantData)
                Config.WeedPlants[Plant.PlantId] = {
                    Stage = PlantData.Stage,
                    Water = PlantData.Water,
                    Fertilizer = PlantData.Fertilizer,
                    Health = PlantData.Health,
                    Pregnant = PlantData.Pregnant,
                    Id = Plant.PlantId,
                    Coords = { 
                        X = PlantData.Coords.X,
                        Y = PlantData.Coords.Y,
                        Z = PlantData.Coords.Z,
                        H = PlantData.Coords.H
                    },
                }
            end
            Cb(Config.WeedPlants)
        end)
    end)
    
    EventsModule.RegisterServer("mercy-illegal/server/plants-plant", function(Source, Coords)
        local PlantId = math.random(1111, 9999)
        Config.WeedPlants[PlantId] = {
            Stage = 0,
            Water = 100,
            Fertilizer = 100,
            Health = 100,
            Pregnant = 'False',
            Id = PlantId,
            Coords = { 
                X = Coords.x,
                Y = Coords.y,
                Z = Coords.z,
                H = Heading
            },
        }
        DatabaseModule.Insert('INSERT INTO player_weedplants (PlantId, PlantData) VALUES (?, ?)', {
            PlantId,
            json.encode(Config.WeedPlants[PlantId])
        })
        TriggerClientEvent('mercy-illegal/client/plants-action', -1, 2, Config.WeedPlants[PlantId])
    end)
end)

Citizen.CreateThread(function()
    Citizen.SetTimeout(750, function()
        while true do
            local RandomValue = math.random(1, 3)
            for k, Plants in pairs(Config.WeedPlants) do
                for weed, Plant in pairs(Plants) do
                    if Plant['Fertilizer'] > 0 and Plant['Fertilizer'] - RandomValue > 0 then
                        Plant['Fertilizer'] = Plant['Fertilizer'] - RandomValue
                    else
                        Plant['Fertilizer'] = 0
                    end
                    if Plant['Fertilizer'] < 50 then
                        if Plant['Health'] > 0 then
                            Plant['Health'] = Plant['Health'] - 5
                        else
                            Plant['Health'] = 0
                        end
                    elseif Plant['Fertilizer'] > 50 then
                        if Plant['Health'] < 100 and Plant['Health'] ~= 0 then
                            Plant['Health'] = Plant['Health'] + 5
                        else
                            Plant['Health'] = 100
                        end
                    end
                    if Plant['Health'] > 0 then
                        if Plant['Progress'] < 100 then
                            local RandomGrowth = math.random(1, 3)
                            Plant['Stage'] = Plant['Stage'] + RandomGrowth
                        end
                    end
                    DatabaseModule.Update('UPDATE player_weedplants SET PlantData = ? WHERE PlantId = ?', {
                        json.encode(Plant),
                        Plant['Id']
                    })
                end
            end
            TriggerClientEvent('mercy-illegal/client/plants-action', -1, 1, Config.WeedPlants)
            Citizen.Wait((60 * 1000) * Config.WeedUpdateTime)
        end
    end)
end)

-- [ Events ] --

RegisterNetEvent("mercy-illegal/server/do-plant-stuff", function(Type, PlantId, Amount)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    local RandomWeedAmount = math.random(3, 6)
    if Type == 'Harvest' then
        if Config.WeedPlants[PlantId] ~= nil then
            Config.WeedPlants[PlantId].Stage = 0
            TriggerClientEvent('mercy-illegal/client/plants-action', -1, 3, Config.WeedPlants[PlantId])    
            Player.Functions.AddItem('weed-dried-bud-one', RandomWeedAmount, false, false, true)
            if math.random(1,5) <= 2 then
                Player.Functions.AddItem('weed-seed-female', 1, false, false, true)
            end
        end
    elseif Type == 'Water' then
        if Config.WeedPlants[PlantId].Water < 100 then
            if Config.WeedPlants[PlantId].Water + Amount < 100 then
                Config.WeedPlants[PlantId].Water = Config.WeedPlants[PlantId].Water + Amount 
            else
                Config.WeedPlants[PlantId].Water = 100
            end
        end 
        TriggerClientEvent('mercy-illegal/client/plants-action', -1, 3, Config.WeedPlants[PlantId])
    elseif Type == 'Fertilizer' then
        if Config.WeedPlants[PlantId].Fertilizer < 100 then
            if Config.WeedPlants[PlantId].Fertilizer + Amount < 100 then
                Config.WeedPlants[PlantId].Fertilizer = Config.WeedPlants[PlantId].Fertilizer + Amount 
            else
                Config.WeedPlants[PlantId].Fertilizer = 100
            end
        end 
        TriggerClientEvent('mercy-illegal/client/plants-action', -1, 3, Config.WeedPlants[PlantId])
    elseif Type == 'Pregnant' then
        Config.WeedPlants[PlantId].Pregnant = 'True'
        TriggerClientEvent('mercy-illegal/client/plants-action', -1, 3, Config.WeedPlants[PlantId])
    elseif Type == 'Destroy' then  
        Player.Functions.AddItem('weed-branch', math.random(1, 3), false, false, true)
        TriggerClientEvent('mercy-illegal/client/plants-action', -1, 4, Config.WeedPlants[PlantId])
        Config.WeedPlants[PlantId] = nil
    end
    if Config.WeedPlants[PlantId] ~= nil then
        DatabaseModule.Update('UPDATE player_weedplants SET PlantData = ? WHERE PlantId = ?', {
            json.encode(Config.WeedPlants[PlantId]),
            PlantId
        })
    else
        DatabaseModule.Delete('DELETE FROM player_weedplants WHERE PlantId = ?', {
            PlantId
        })
    end
end)