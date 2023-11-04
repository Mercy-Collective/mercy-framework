-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(250)
    end

    CallbackModule.CreateCallback('mercy-illegal/server/get-plants', function(Source, Cb)
        DatabaseModule.Execute('SELECT * FROM player_weedplants', {}, function(Result)
            if Result[1] == nil then return Cb(Config.WeedPlants) end
            for _, Plant in pairs(Result) do
                local PlantData = json.decode(Plant.PlantData)
                Config.WeedPlants[#Config.WeedPlants + 1] = {
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
        local NewId = math.random(1111, 9999)
        Config.WeedPlants[NewId] = {
            Stage = 0,
            Water = 100,
            Fertilizer = 100,
            Health = 100,
            Pregnant = 'False',
            Id = NewId,
            Coords = { 
                X = Coords.x,
                Y = Coords.y,
                Z = Coords.z,
                H = Heading
            },
        }
        print('[DEBUG:WeedPlants]: Inserting Plant in Database: ' .. NewId .. ' - ' .. json.encode(Config.WeedPlants[NewId]))
        DatabaseModule.Insert('INSERT INTO player_weedplants (PlantId, PlantData) VALUES (?, ?)', {
            NewId,
            json.encode(Config.WeedPlants[NewId])
        })
        TriggerClientEvent('mercy-illegal/client/plants-action', -1, 2, Config.WeedPlants[NewId])
    end)
end)

Citizen.CreateThread(function()
    Citizen.SetTimeout(750, function()
        while true do
            local RandomValue = math.random(10, 15)
            local UpdatedPlants = {}
            for _, Plant in pairs(Config.WeedPlants) do
                -- Fertilizer
                if Plant['Fertilizer'] > 0 and Plant['Fertilizer'] - RandomValue > 0 then
                    Plant['Fertilizer'] = Plant['Fertilizer'] - RandomValue
                else
                    Plant['Fertilizer'] = 0
                end
                -- Water
                if Plant['Water'] > 0 and Plant['Water'] - RandomValue > 0 then
                    Plant['Water'] = Plant['Water'] - RandomValue
                else
                    Plant['Water'] = 0
                end

                if Plant['Fertilizer'] < 50 or Plant['Water'] < 50 then
                    if Plant['Health'] > 0 then
                        Plant['Health'] = Plant['Health'] - 5
                    else
                        Plant['Health'] = 0
                    end
                elseif Plant['Fertilizer'] > 50 or Plant['Water'] > 50 then
                    if Plant['Health'] < 100 and Plant['Health'] ~= 0 then
                        Plant['Health'] = Plant['Health'] + 5
                    else
                        Plant['Health'] = 100
                    end
                end
      
                if Plant['Health'] > 0 then
                    if Plant['Stage'] < 100 then
                        local RandomGrowth = math.random(3, 6)
                        Plant['Stage'] = Plant['Stage'] + RandomGrowth
                    end
                end
                -- print('[DEBUG:WeedPlants]: Updating Plant Data for plant: ' .. Plant['Id'] .. ' - ' .. Plant['Stage'] .. ' - ' .. Plant['Water'] .. ' - ' .. Plant['Fertilizer'] .. ' - ' .. Plant['Health'] .. ' - ' .. Plant['Pregnant'] .. ' - ' .. json.encode(Plant['Coords']))
                DatabaseModule.Update('UPDATE player_weedplants SET PlantData = ? WHERE PlantId = ?', {
                    json.encode(Plant),
                    Plant['Id']
                })
                UpdatedPlants[#UpdatedPlants + 1] = Plant
            end
            TriggerClientEvent('mercy-illegal/client/plants-action', -1, 1, UpdatedPlants)
            Citizen.Wait((60 * 1000) * Config.WeedUpdateTime)
        end
    end)
end)

-- [ Events ] --

RegisterNetEvent("mercy-illegal/server/do-plant-stuff", function(Type, PlantId, Amount)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    local RandomWeedAmount = math.random(3, 6)
    local Plant = GetPlantById(PlantId)
    if not Plant then return end
    if Type == 'Harvest' then
        Plant.Stage = 0
        TriggerClientEvent('mercy-illegal/client/plants-action', -1, 3, Plant)
        
        Player.Functions.AddItem('weed-branch', math.random(1, 3), false, false, true)
        if math.random(1,5) <= 2 then
            Player.Functions.AddItem('weed-seed-female', 1, false, false, true)
        end
        if Plant.Pregnant == 'True' then
            Player.Functions.AddItem('weed-seed-male', math.random(1, 3), false, false, true)
        end
    elseif Type == 'Water' then
        if Plant.Water < 100 then
            if Plant.Water + Amount < 100 then
                Plant.Water = Plant.Water + Amount 
            else
                Plant.Water = 100
            end
        end 
        TriggerClientEvent('mercy-illegal/client/plants-action', -1, 3, Plant)
    elseif Type == 'Fertilizer' then
        if Plant.Fertilizer < 100 then
            if Plant.Fertilizer + Amount < 100 then
                Plant.Fertilizer = Plant.Fertilizer + Amount 
            else
                Plant.Fertilizer = 100
            end
        end 
        TriggerClientEvent('mercy-illegal/client/plants-action', -1, 3, Plant)
    elseif Type == 'Pregnant' then
        Plant.Pregnant = 'True'
        TriggerClientEvent('mercy-illegal/client/plants-action', -1, 3, Plant)
    elseif Type == 'Destroy' then
        print('[DEBUG:WeedPlants]: Deleting plant from Database: ' .. PlantId)
        DatabaseModule.Execute('DELETE FROM player_weedplants WHERE PlantId = ?', {
            PlantId
        })
        TriggerClientEvent('mercy-illegal/client/plants-action', -1, 4, Plant)
        for PlantCId, Plant in pairs(Config.WeedPlants) do
            if Plant['Id'] == PlantId then
                Config.WeedPlants[PlantCId] = nil
            end
        end
    end

    -- Update plant
    if Plant ~= nil and Type ~= 'Destroy' then
        print('[DEBUG:WeedPlants]: Updating plant data for plant: ' .. PlantId .. ' - ' .. json.encode(Plant))
        DatabaseModule.Update('UPDATE player_weedplants SET PlantData = ? WHERE PlantId = ?', {
            json.encode(Plant),
            PlantId
        }) 
    end
end)

-- [ Functions ] --

function GetPlantById(Id)
    for _, Plant in pairs(Config.WeedPlants) do
        if Plant['Id'] == Id then
            return Plant
        end
    end
    return false
end
