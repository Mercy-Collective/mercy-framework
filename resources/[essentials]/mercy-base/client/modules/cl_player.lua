local _Ready = false
AddEventHandler('Modules/client/ready', function()
    if not _Ready then
        _Ready = true
        exports[GetCurrentResourceName()]:CreateModule("Player", PlayerModule)
    end
end)

RegisterNetEvent('mercy-base/client/set-playerdata', function(PlayerData)
    PlayerModule._PlayerData = PlayerData
end)

PlayerModule = {
    _PlayerData = {},
    GetPlayerData = function(Cb) 
        if Cb then
            Cb(PlayerModule._PlayerData)
        else
            return PlayerModule._PlayerData
        end
    end,
    GetPlayerCitizenIdBySource = function(Source)
        local Callback = exports[GetCurrentResourceName()]:FetchModule('Callback')
        local CitizenId = CallbackModule.SendCallback('mercy-base/server/get-citizenid-by-source', Source)
        return CitizenId
    end,
    GetPlayers = function()
        local Callback = exports[GetCurrentResourceName()]:FetchModule('Callback')
        local Players = CallbackModule.SendCallback('mercy-base/server/get-active-players')
        return Players
    end,
    IsPlayerAdmin = function() 
        local Callback = exports[GetCurrentResourceName()]:FetchModule('Callback')
        local IsAdmin = CallbackModule.SendCallback('mercy-base/server/is-me-admin')
        return IsAdmin
    end,
    GetPlayersInArea = function(Coords, Radius)
        local Callback = exports[GetCurrentResourceName()]:FetchModule('Callback')
        local Players = CallbackModule.SendCallback('mercy-base/server/get-active-players-in-radius', Coords, Radius)
        return Players
    end,
    GetClosestPlayer = function(Coords, Radius)
        local CallbackModule = exports[GetCurrentResourceName()]:FetchModule('Callback')
        local Coords = Coords ~= nil and Coords or GetEntityCoords(PlayerPedId())
        local ClosestPlayer = CallbackModule.SendCallback('mercy-base/server/get-closest-player', Coords, Radius)
        if ClosestPlayer.ClosestServer ~= -1 then 
            local TargetPlayer = GetPlayerFromServerId(tonumber(ClosestPlayer.ClosestServer))
            ClosestPlayer.ClosestPlayerPed = GetPlayerPed(TargetPlayer) 
        end
        return ClosestPlayer
    end
}