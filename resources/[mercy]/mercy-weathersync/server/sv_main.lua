CallbackModule, PlayerModule, FunctionsModule, CommandsModule, EventsModule = nil, nil, nil, nil, nil

local _Ready = false
AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Callback',
        'Player',
        'Functions',
        'Commands',
        'Events'
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
        CommandsModule = exports['mercy-base']:FetchModule('Commands')
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

    CallbackModule.CreateCallback('mercy-weathersync/server/get-data', function(Source, Cb)
        Cb(Config.SyncData)
    end)

    -- [ Commands ] --

    CommandsModule.Add("togglesync", "Toggle Weather Sync", {}, false, function(source, args)
        if Config.Syncing then
            Config.Syncing = false
            Player.Functions.Notify('not-sync', '[Syncing] Disabled.', "error")
        else
            Config.Syncing = true
            Player.Functions.Notify('sync', '[Syncing] Enabled.', "error")
        end
    end, 'admin')

    CommandsModule.Add("settime", "Set Time", {{Name="Hour", Help="Hour"}, {Name="Minute", Help="Minute"}}, false, function(source, args)
        local Hour = tonumber(args[1])
        local Minutes = tonumber(args[2])
        local Player = PlayerModule.GetPlayerBySource(source)
        if Minutes <= 60 and Hour < 24 then
            Config.SyncData['Minutes'] = Minutes
            Config.SyncData['Hour'] = Hour
            TriggerClientEvent('mercy-weathersync/client/sync', -1, Config.SyncData)
            Player.Functions.Notify('time-changed', 'Time succesfully changed.', 'success')
        else
            Player.Functions.Notify('invalid-time', 'An error occurred: Invalid time.', 'error')
        end
    end, 'admin')

    CommandsModule.Add("setweather", "Set Weather", {{Name="Weather Type", Help="Weather Type"}}, false, function(source, args)
        local WeatherType = args[1]:upper()
        local Player = PlayerModule.GetPlayerBySource(source)
        for k, v in pairs(Config.WeatherTypes) do
            if v['Weather'] == WeatherType then
                Config.SyncData['Weather'] = Config.WeatherTypes[k]['Weather']
                TriggerClientEvent('mercy-weathersync/client/sync', -1, Config.SyncData)
                Player.Functions.Notify('weather-changed', 'Weather succesfully changed to: '..Config.SyncData['Weather'], 'success')
            end
        end
    end, 'admin')

    CommandsModule.Add({"freezeweather", "freezetime"}, "Freeze Weather and Time", {}, false, function(source, args)
        local Player = PlayerModule.GetPlayerBySource(source)
        if Config.Frozen then
            Config.Frozen = false
            Player.Functions.Notify('not-frozen', '[Frozen Weather] Disabled', "error")
        else
            Config.Frozen = true
            Player.Functions.Notify('frozen', '[Frozen Weather] Enabled', "success")
        end
        TriggerClientEvent('mercy-weathersync/client/sync', -1, Config.SyncData)
    end, "admin")

    CommandsModule.Add("blackout", "Toggle blackout", {}, false, function(source, args)
        local Player = PlayerModule.GetPlayerBySource(source)
        ToggleBlackout(Player)
    end, "admin")

    -- Events

    EventsModule.RegisterServer("mercy-weathersync/server/set-blackout", function(Source)
        Config.SyncData['Blackout'] = true
        TriggerClientEvent('mercy-weathersync/client/sync', -1, Config.SyncData)
        SetTimeout((1000 * 60) * 60, function() -- 1 hour
            Config.SyncData['Blackout'] = false
            TriggerClientEvent('mercy-weathersync/client/sync', -1, Config.SyncData)
        end)
    end)
end)

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if Config.Syncing and not Config.Frozen then
            if Config.SyncData['Minutes'] + 1 < 60 then
                Config.SyncData['Minutes'] = Config.SyncData['Minutes'] + 1
            else
                Config.SyncData['Minutes'] = 0
                if Config.SyncData['Hour'] + 1 < 24 then
                    Config.SyncData['Hour'] = Config.SyncData['Hour'] + 1
                else
                    Config.SyncData['Hour'] = 1
                end
            end
            TriggerClientEvent('mercy-weathersync/client/sync', -1, Config.SyncData)
            Citizen.Wait(2350)
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if Config.Syncing and not Config.Frozen then
            local NewWeather = GetRandomWeather(Config.SyncData['Weather'])
            local WaitTime = 0
            if Config.SyncData['Weather'] == 'RAIN' or Config.SyncData['Weather'] == 'THUNDER' then
                Config.SyncData['Weather'] = 'CLEARING'
                WaitTime = 1
            elseif Config.SyncData['Weather'] == 'CLEARING' then
                Config.SyncData['Weather'] = 'EXTRASUNNY'
                WaitTime = 6
            else
                Config.SyncData['Weather'] = NewWeather['Weather']
                WaitTime = NewWeather['MaxTime']
            end
            TriggerClientEvent('mercy-weathersync/client/sync', -1, Config)
            Citizen.Wait((60 * 1000) * (60 * WaitTime))
        end
    end
end)

-- [ Functions ] --

function SetTime(Hour, Minutes)
    Config.SyncData['Minutes'] = Minutes
    Config.SyncData['Hour'] = Hour
    TriggerClientEvent('mercy-weathersync/client/sync', -1, Config.SyncData)
    return true
end
exports('SetTime', SetTime)

function SetWeather(WeatherType)
    local Player = PlayerModule.GetPlayerBySource(source)
    for k, v in pairs(Config.WeatherTypes) do
        if v['Weather'] == WeatherType then
            Config.SyncData['Weather'] = Config.WeatherTypes[k]['Weather']
            TriggerClientEvent('mercy-weathersync/client/sync', -1, Config.SyncData)
            return true
        end
    end
    return false
end
exports('SetWeather', SetWeather)

function GetRandomWeather(CurrentWeather)
    local Found = false
    while not Found do 
        local RandomWeather = Config.WeatherTypes[math.random(1, #Config.WeatherTypes)]
        if RandomWeather['Weather'] ~= CurrentWeather and RandomWeather['AllowRandom'] then
            Found = true
            return RandomWeather
        end
    end
end

function ToggleBlackout(Player, Bool)
    if Bool == nil then
        Config.SyncData['Blackout'] = not Config.SyncData['Blackout']
    else
        Config.SyncData['Blackout'] = Bool
    end
    local Type = Config.SyncData['Blackout'] and 'success' or 'error'
    local Msg = Config.SyncData['Blackout'] and "Enabled" or "Disabled"
    Player.Functions.Notify('blackout-toggle', '[Blackout] '..Msg, Type)
    TriggerClientEvent('mercy-weathersync/client/sync', -1, Config.SyncData)
end

function GetCurrentTime()
    return Config.SyncData['Hour'], Config.SyncData['Minutes']
end

exports('GetCurrentTime', GetCurrentTime)