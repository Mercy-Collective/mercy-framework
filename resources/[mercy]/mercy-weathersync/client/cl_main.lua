local CanSync, DefaultTime, CallbackModule = false, nil, nil

RegisterNetEvent("mercy-base/client/player-spawned", function()
    Citizen.SetTimeout(500, function()
        TriggerEvent('mercy-weathersync/client/set-default-weather', 21)
	end)
end)

RegisterNetEvent('mercy-base/client/on-login', function()
    CanSync = true, true
    SetupSyncing()
end)

RegisterNetEvent('mercy-base/client/on-logout', function()
    SetClientSync(false)
end)

AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
        'Callback',
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
    end)
end)

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            local InsideInterior = exports['mercy-interiors']:IsInsideInterior()
            if InsideInterior then
                SetClientSync(false)
            else
                SetClientSync(true)
            end
            Citizen.Wait(3500)
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if not CanSync and DefaultTime ~= nil then
            NetworkOverrideClockTime(DefaultTime, 0, 0)
            Citizen.Wait(250)
        else
            Citizen.Wait(450)
        end
    end
end)

-- [ Events ] --

RegisterNetEvent('mercy-weathersync/client/sync', function(ConfigData)
    if CanSync then
        NetworkOverrideClockTime(ConfigData['Hour'], ConfigData['Minutes'], 0)
        if ConfigData['Weather'] ~= Config.SyncData['Weather'] then
            SetWeatherTypeOverTime(ConfigData['Weather'], 15.0)
            if ConfigData['Weather'] == 'XMAS' then
                SetForceVehicleTrails(true)
	        	SetForcePedFootstepsTracks(true)
	        else
	        	SetForceVehicleTrails(false)
	        	SetForcePedFootstepsTracks(false)
	        end
        end
        if ConfigData['Blackout'] ~= Config.SyncData['Blackout'] then
            SetArtificialLightsState(ConfigData['Blackout'])
            SetArtificialLightsStateAffectsVehicles(false)
        end
        Config.SyncData = ConfigData
    end
end)

RegisterNetEvent('mercy-weathersync/client/set-default-weather', function(Hour)
    Citizen.SetTimeout(500, function()
        SetRainFxIntensity(0.0)
        NetworkOverrideClockTime(Hour, 0, 0)
        SetWeatherTypePersist('EXTRASUNNY')
        SetWeatherTypeNow('EXTRASUNNY')
        SetWeatherTypeNowPersist('EXTRASUNNY')
        DefaultTime = Hour
    end)
end)

-- [ Functions ] --

function SetupSyncing()
    Config.SyncData = GetWeatherConfig()
    Citizen.SetTimeout(500, function()
        SetClientSync(true)
    end)
end

function GetWeatherConfig()
    local Config = CallbackModule.SendCallback("mercy-weathersync/server/get-data")
    return Config
end

function GetCurrentTime()
    return Config.SyncData['Hour'], Config.SyncData['Minutes']
end
exports("GetCurrentTime", GetCurrentTime)

function BlackoutActive()
    return Config.SyncData['Blackout']
end
exports("BlackoutActive", BlackoutActive)

function SetClientSync(Bool)
    CanSync = Bool
    if not CanSync then
        SetRainFxIntensity(0.0)
        NetworkOverrideClockTime(23, 0, 0)
        SetWeatherTypePersist('EXTRASUNNY')
        SetWeatherTypeNow('EXTRASUNNY')
        SetWeatherTypeNowPersist('EXTRASUNNY')
        SetForceVehicleTrails(false)
        SetForcePedFootstepsTracks(false)
    else
        DefaultTime = nil
        SetRainFxIntensity(-1.0)
        NetworkOverrideClockTime(Config.SyncData['Hour'], Config.SyncData['Minutes'], 0)
        SetWeatherTypePersist(Config.SyncData['Weather'])
        SetWeatherTypeNow(Config.SyncData['Weather'])
        SetWeatherTypeNowPersist(Config.SyncData['Weather'])
        if Config.SyncData['Weather'] == 'XMAS' then
            SetForceVehicleTrails(true)
            SetForcePedFootstepsTracks(true)
        else
            SetForceVehicleTrails(false)
            SetForcePedFootstepsTracks(false)
        end
        if Config.SyncData['Blackout'] then
            SetArtificialLightsState(true)
        else
            SetArtificialLightsState(false)
        end
    end
end
exports("SetClientSync", SetClientSync)