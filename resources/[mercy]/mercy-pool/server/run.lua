TableGames = {}
TablePlayers = {}

RegisterCommand("showpool", function(source)
    if source == 0 then 
        print(">> Cue data")
        GetTableData(TablePlayers)
        print("")
        print(">> Table data")
        GetTableData(TableGames)
    end 
end, false)

RegisterNetEvent("mercy-pool:setTableState", function(TableData)
    local src = source 
    local TablePos = TableData["tablePosition"] 
    local TableDat = TableData["data"] 
    local GameId = GetTableIdByPos(TablePos)
    if not TableGames[GameId] or not TableGames[GameId]["player"] then
        if Config["PayForSettingBalls"] then
            TriggerEvent("mercy-pool:payForPool", src, function()
                SetGameById(GameId, TablePos, TableDat)
            end)
        else 
            SetGameById(GameId, TablePos, TableDat)
        end 
    end 
end)

SetGameById = function(GameId, TablePos, TableDat)
    TableGames[GameId] = {
        ["tablePos"] = TablePos,
        ["cueBallIdx"] = TableDat["cueBallIdx"],
        ["balls"] = TableDat["balls"]
    }
    SyncGames(GameId)
end

RegisterNetEvent("mercy-pool:internalPlayerHasTakenCue", function(cueNetId, Coords)
    local src = source
    TriggerEvent("mercy-pool:playerHasTakenCue", src)
    TablePlayers[src] = {cueNetId, Coords}
    TriggerEvent("mercy-pool:onTakeCue", src)
end)

RegisterNetEvent("mercy-pool:internalDeleteCue", function()
    local src = source 
    StopPlaying(src)
end)

RegisterNetEvent("mercy-pool:registerTable", function(pos)
    local TableId = GetTableIdByPos(pos)
    if not TableGames[TableId] then
        TableGames[TableId] = {
            ["tablePos"] = pos,
            ["cueBallIdx"] = nil,
            ["balls"] = {}
        }
        SyncGames(TableId)
    end 
end)

RegisterNetEvent("mercy-pool:requestTurn", function(GameId)
    local src = source 
    if TableGames[GameId] and not TableGames[GameId]["player"]then
        TableGames[GameId]["player"] =src 
        TableGames[GameId]["lastPlayer"] =src
        SyncGames(GameId)
        TriggerClientEvent("mercy-pool:turnGranted", src, GameId)
    end 
end)

RegisterNetEvent("mercy-pool:releaseControl", function(GameId)
    local src = source 
    if TableGames[GameId] and TableGames[GameId]["player"] == src then
        TableGames[GameId]["player"] = nil
        SyncGames(GameId)
    end 
end)

RegisterNetEvent("mercy-pool:syncFinalTableState", function(GameId, balls)
    local src = source 
    if TableGames[GameId] and TableGames[GameId]["player"] == src then
        TableGames[GameId]["player"] = nil
        TableGames[GameId]["balls"] = balls 
        SyncGames(GameId)
    end 
end)

RegisterNetEvent("mercy-pool:syncCueBallVelocity", function(GameId, cueBallPosition, cueBallVelocity, hitStrength)
    local src = source 
    if TableGames[GameId] and TableGames[GameId]["player"] == src then
        local BallId = TableGames[GameId]["cueBallIdx"] 
        TableGames[GameId]["balls"][BallId]["velocity"] = cueBallVelocity 
        TableGames[GameId]["balls"][BallId]["position"] = cueBallPosition 
        SyncGames(GameId,GameId,hitStrength)
    end
end)

RegisterNetEvent("mercy-pool:setBallInHandData", function(GameId, NewPos)
    local src = source 
    if TableGames[GameId] and TableGames[GameId]["player"] == src then
        local BallId = TableGames[GameId]["cueBallIdx"]
        TableGames[GameId]["balls"][BallId]["disabled"] = false
        TableGames[GameId]["balls"][BallId]["position"] = NewPos 
        SyncDistance(GameId, src)
    end
end)

RegisterNetEvent("mercy-pool:pocketed", function(GameId, ballNum)
    local src = source
    if TableGames[GameId] and TableGames[GameId]["lastPlayer"] == src then
        local FormattedString = string.format(Config["Text"]["BALL_POCKETED"], Config["Text"]["BALL_LABELS"][ballNum])
        TriggerClientEvent("mercy-pool:internalNotification", -1, src, GameId, FormattedString)
    end
end) 

RegisterNetEvent("mercy-pool:ballInHandNotify", function(GameId)
    local src = source
    if TableGames[GameId] and TableGames[GameId]["lastPlayer"] == src then
        TriggerClientEvent("mercy-pool:internalNotification", -1, src, GameId, Config["Text"]["BALL_IN_HAND_NOTIFY"])
    end 
end)

RegisterNetEvent("mercy-pool:requestTables", function()
    local src = source
    for addr, GameData in pairs(TableGames) do
        TriggerClientEvent("mercy-pool:syncTableState", src, addr, GameData)
        Wait(1000)
    end
end)

GetTableIdByPos = function(pos)
    local XPos = math.floor(pos["x"] * 10) / 10
    local YPos = math.floor(pos["y"] * 10) / 10
    return XPos.."/"..YPos 
end

SyncDistance = function(GameId, src)
    local Distance = 20
    for _, ServerId in ipairs(GetPlayers()) do
        if src ~= tonumber(ServerId) then
            if Distance < 20 then 
                Wait(0)
                Distance = 20
            end
            Distance = Distance - 1
            TriggerClientEvent("mercy-pool:syncTableState", ServerId, GameId, TableGames[GameId])
        end
    end
end

SyncGames = function(GameId, isCueBallHit, hitStrength)
    TriggerClientEvent("mercy-pool:syncTableState", -1, GameId, TableGames[GameId], isCueBallHit, hitStrength)
end 

Citizen.CreateThread(function() 
    while true do 
        Wait(5000)
        for ServerId, PlayerData in pairs(TablePlayers) do
            CheckDistance(ServerId, PlayerData[1], PlayerData[2])
            Wait(250)
        end
    end
end)

CheckDistance = function(ServerId, cueNetId, cueSpawnCoords)
    Citizen.CreateThread(function()
        local PlayerCoords = GetEntityCoords(GetPlayerPed(ServerId))
        if #(PlayerCoords - cueSpawnCoords) > 30.0 then
            StopPlaying(ServerId) 
        end
    end)
end

StopPlaying = function(ServerId)
    if TablePlayers[ServerId] then
        local PlayerCue = NetworkGetEntityFromNetworkId(TablePlayers[ServerId][1])
        if DoesEntityExist(PlayerCue) and GetEntityModel(PlayerCue) == GetHashKey("prop_pool_cue") then 
            DeleteEntity(PlayerCue)
        end
        TriggerEvent("mercy-pool:onReturnCue", ServerId)
        TablePlayers[ServerId] = nil
    end 
end

AddEventHandler("playerDropped", function() 
    local CanCheck = false
    StopPlaying(source)
    for GameId, GameData in pairs(TableGames) do
        if GameData and GameData["player"] == source then
            GameData["player"] = nil
            CanCheck = true
            SyncGames(GameId)
        end 
    end
end)

GetTableData = function(tbl, NeedsData)
    if not NeedsData then
        NeedsData = 0
    end
    if type(tbl) == "table" then 
        for k, v in pairs(tbl) do 
            Data = string["rep"] ("  ", NeedsData)..k..": "
            if type(v) == "table" then 
                print(Data)
                GetTableData(v, NeedsData+1.0)
            elseif type(v) == "boolean" then 
                print(Data..tostring(v))
            else 
                print(Data..v)
            end 
        end 
    else 
        print(tbl)
    end 
end