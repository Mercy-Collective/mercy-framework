CallbackModule, PlayerModule, FunctionsModule, DatabaseModule, CommandsModule, EventsModule = nil, nil, nil, nil, nil, nil

_Ready = false
AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Callback',
        'Player',
        'Functions',
        'Database',
        'Commands',
        'Events',
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
        DatabaseModule = exports['mercy-base']:FetchModule('Database')
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

    CallbackModule.CreateCallback('mercy-illegal/server/methLabs/can-cook-meth', function(Source, Cb, Id)
        Cb(Config.LabsState[Id])
    end)

    EventsModule.RegisterServer('mercy-illegal/server/methLabs/set-open-close', function(Source, Id)
        if Config.LabsState[Id] then
            Config.LabsState[Id] = false
            TriggerClientEvent('mercy-ui/client/notify', Source, "close-electric", "You turned off the electricity!", 'error', 3000)
        else
            Config.LabsState[Id] = true
            TriggerClientEvent('mercy-ui/client/notify', Source, "open-electric", "You turned on the electricity!", 'success', 3000)
        end
        TriggerClientEvent('mercy-illegal/client/methLabs/sync-state', -1, Config.LabsState[Id], Id)
    end)

    EventsModule.RegisterServer("mercy-illegal/server/methLabs/give-reward", function(Source, Item, Amount, RequestItem, RequestItemAmount)
        local Player = PlayerModule.GetPlayerBySource(Source)
        Player.Functions.AddItem(Item, Amount, false, false, true)
        if RequestItem then
            Player.Functions.RemoveItem(RequestItem, RequestItemAmount, false, true)
        end
    end)
end)