CommandsModule = {}

local _Ready = false
AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Commands',
    }, function(Succeeded)
        if not Succeeded then return end
        CommandsModule = exports['mercy-base']:FetchModule('Commands')
        _Ready = true
    end)
end)

-- [ Code ] --

Citizen.CreateThread(function() 
    while not _Ready do 
        Citizen.Wait(4) 
    end 

    -- [ Commands ] --

    CommandsModule.Add("dance", "Dance!", {{Name="Dance", Help="Dance"}}, false, function(source, args)
        TriggerClientEvent('mercy-dances/client/dance', source, tonumber(args[1]))
    end)

    CommandsModule.Add("e", "Play an animation.", {{Name="Animation", Help="Animation"}}, false, function(source, args)
        TriggerClientEvent('mercy-animations/client/play-animation', source, args[1])
    end)
end)