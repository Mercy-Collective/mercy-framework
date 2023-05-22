CallbackModule, PlayerModule, EventsModule = nil, nil, nil

local _Ready = false
AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Callback',
        'Player',
        'Events',
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        EventsModule = exports['mercy-base']:FetchModule('Events')

        _Ready = true
    end)
end)

-- [ Code ] --

Citizen.CreateThread(function() 
    while not _Ready do 
        Citizen.Wait(4) 
    end 

    -- [ Callbacks ] --

    function GetPlayerByRoomId(RoomId)
        local PlayerInfo = false
        for k, v in pairs(PlayerModule.GetPlayers()) do
            local Player = PlayerModule.GetPlayerBySource(v)
            if Player.PlayerData.MetaData['RoomId'] == RoomId then
                PlayerInfo = Player
            end
        end
        return PlayerInfo
    end

    CallbackModule.CreateCallback('mercy-apartment/server/get-lockstatus-by-roomid', function(Source, Cb, RoomId)
        local Player = GetPlayerByRoomId(RoomId)
        if Player then
            Cb(not Player.PlayerData.MetaData['RoomLocked'])
        else
            Cb(false)
        end
    end)

    CallbackModule.CreateCallback('mercy-apartment/server/get-lockdown-by-roomid', function(Source, Cb, RoomId)
        local Player = GetPlayerByRoomId(RoomId)
        if Player then
            Cb(Player.PlayerData.MetaData['RoomLockdown'])
        else
            Cb(false)
        end
    end)

    CallbackModule.CreateCallback('mercy-apartment/server/get-unlocked-apps', function(Source, Cb)
        local UnlockedRooms = {}
        for k, v in pairs(PlayerModule.GetPlayers()) do
            local Player = PlayerModule.GetPlayerBySource(v)
            if not Player.PlayerData.MetaData['RoomLocked'] then
                table.insert(UnlockedRooms, Player.PlayerData.MetaData['RoomId'])
            end
        end
        Cb(UnlockedRooms)
    end)
end)

-- [ Events ] --

RegisterNetEvent("mercy-apartment/server/toggle-lock", function(Data)
    local StateId = Data['StateId']
    local Player = PlayerModule.GetPlayerByStateId(tonumber(StateId))
    if Player then
        Player.Functions.SetMetaData('RoomLocked', not Player.PlayerData.MetaData['RoomLocked'])
    end
end)

RegisterNetEvent("mercy-apartment/server/toggle-lockdown", function(StateId)
    local Player = PlayerModule.GetPlayerByStateId(tonumber(StateId))
    if Player then
        Player.Functions.SetMetaData('RoomLockdown', not Player.PlayerData.MetaData['RoomLockdown'])
    end
end)