CallbackModule, PlayerModule = nil, nil

local _Ready = false
AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Callback',
        'Player',
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        _Ready = true

    end)
end)

-- [ Code ] --

Citizen.CreateThread(function() 
    while not _Ready do 
        Citizen.Wait(4) 
    end 

    CallbackModule.CreateCallback("mercy-scenes/server/get-scenes", function(Source, Cb)
        Cb(Config.Scenes)
    end)
end)

-- [ Events ] --

RegisterNetEvent("mercy-scenes/server/add-scene", function(Result, Pos)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    if Player then
        local ScenesData = Player.PlayerData.MetaData["Scenes"]
        if ScenesData.Blacklisted == true then
            TriggerClientEvent('mercy-ui/client/notify', src, "scene-invalid", "You are blacklisted from creating scenes... ("..ScenesData.Reason..")", 'error')
            return
        end
        
        for _, word in pairs(Config.BannedWords) do
            if Result.Text:match(word) then
                TriggerClientEvent('mercy-ui/client/notify', src, "scene-invalid", "Blacklisted word found, canceling scene creation...", 'error')
                return 
            end
        end
        local NewScene = {
            Coords = Pos,
            Text =  Result.Text,
            Color = Result.Color,
            Distance = tonumber(Result.Distance),
        }
        local SceneId = (#Config.Scenes + 1)
        Config.Scenes[SceneId] = NewScene
        TriggerClientEvent("mercy-scenes/client/update-scene", -1, SceneId, NewScene)
    end
end)

RegisterNetEvent("mercy-scenes/server/remove-scene", function(Scene)
    table.remove(Config.Scenes, Scene)
    TriggerClientEvent("mercy-scenes/client/update-scene", -1, Scene, false)
end)