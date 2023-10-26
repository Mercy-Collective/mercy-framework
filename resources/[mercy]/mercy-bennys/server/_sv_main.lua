CallbackModule, PlayerModule, DatabaseModule, FunctionsModule, CommandsModule, EventsModule = nil, nil, nil, nil, nil, nil

_Ready = false
AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Callback',
        'Player',
        'Database',
        'Functions',
        'Commands',
        'Events',
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        DatabaseModule = exports['mercy-base']:FetchModule('Database')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
        CommandsModule = exports['mercy-base']:FetchModule('Commands')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        _Ready = true
    end)
end)

Citizen.CreateThread(function() 
    while not _Ready do 
        Citizen.Wait(500) 
    end 

    -- [ Callbacks ] --

    local MechanicBusinesses = {
        'Bennys Motorworks',
        'Hayes Repairs',
        'Harmony Repairs',
    }

    CallbackModule.CreateCallback('mercy-bennys/server/is-mechanic-online', function(Source, Cb)
        local EmployeeCount = 0
        for _, Name in pairs(MechanicBusinesses) do
            local Amount = exports['mercy-business']:GetOnlineBusinessEmployees(Name)
            if not Amount then goto Skip end
            if #Amount > 0 then
                EmployeeCount = EmployeeCount + 1
            end
            ::Skip::
        end
        print('Ready', EmployeeCount > 0)
        if EmployeeCount > 0 then
            Cb(true)
        else
            Cb(false)
        end
    end)

end)