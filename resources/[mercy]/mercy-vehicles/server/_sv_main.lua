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

CreateThread(function() 
    while not _Ready do 
        Wait(100) 
    end 

    -- [ Commands ] --

    CommandsModule.Add("givekeys", "Give keys from your vehicle", {}, false, function(Source, args)
        TriggerClientEvent('mercy-vehicles/client/give-keys', Source)
    end)
    
    CommandsModule.Add("getkeys", "Get keys of vehicle", {}, false, function(Source, args)
        TriggerClientEvent('mercy-vehicles/client/get-keys', Source)
    end, 'god')

    CommandsModule.Add("door", "/door open 0-7 or /door close 0-7", {{Name="State", Help="State"}, {Name="Door", Help="Door"}}, false, function(Source, args)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local State = args[1]
        local DoorId = tonumber(args[2])
        if (State ~= nil and (State == 'close' or State == 'open')) and (DoorId ~= nil and (DoorId <= 7 and DoorId >= 0)) then
            TriggerClientEvent('mercy-vehicles/client/toggle-door', Source, State, DoorId)
        else
            Player.Functions.Notify('error-doors', 'An error occurred.', 'error')
        end
    end)

    CommandsModule.Add("seat", "/seat -1 or /seat 5", {{Name="Seat", Help="Seat"}}, false, function(Source, args)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local SeatId = tonumber(args[1])
        if SeatId >= -1 and SeatId <= 5 then
            TriggerClientEvent('mercy-vehicles/client/switch-seat', Source, SeatId, false)
        else
            Player.Functions.Notify('error-doors', 'An error occurred.', 'error')
        end
    end)

    CommandsModule.Add("forceintrunk", "Force player into trunk", {}, false, function(Source, args)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local Data = {}
        Data.Forced = true
        TriggerClientEvent('mercy-vehicles/client/get-in-trunk', Source, Data)
    end)
end)