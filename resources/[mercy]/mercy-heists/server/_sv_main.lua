CallbackModule, PlayerModule, EventsModule = nil, nil, nil
TruckStates = {}

_Ready = false
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

    CallbackModule.CreateCallback('mercy-heists/server/get-config', function(Source, Cb)
        Cb(Config)
    end)
end)