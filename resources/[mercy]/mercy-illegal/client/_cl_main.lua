EntityModule, LoggerModule, EventsModule, CallbackModule, FunctionsModule, PlayerModule = nil

local _Ready = false
AddEventHandler('Modules/client/ready', function()
    if not _Ready then
        _Ready = true
    end
    TriggerEvent('Modules/client/request-dependencies', {
        'Player',
        'Events',
        'Entity',
        'Logger',
        'Callback',
        'Functions',
    }, function(Succeeded)
        if not Succeeded then return end
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        EntityModule = exports['mercy-base']:FetchModule("Entity")
        LoggerModule = exports['mercy-base']:FetchModule('Logger')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
    end)
end)

RegisterNetEvent('mercy-base/client/on-login', function()
    Citizen.SetTimeout(1250, function()
        InitZones() InitPlants()
    end)
end)

RegisterNetEvent('mercy-base/client/on-logout', function()
    RemoveAllPlants()
end)

-- [ Code ] --

-- [ Events ] --

local CanSell = true
RegisterNetEvent('mercy-illegal/client/sell-something', function()
    if not CanSell then return end
    EventsModule.TriggerServer('mercy-illegal/server/sell-something') 
    CanSell = false
    Citizen.SetTimeout(10000, function()
        CanSell = true
    end)
end)