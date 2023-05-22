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

function IsInContacts(Player, ContactNumber)
    local Promise = promise:new()
    DatabaseModule.Execute('SELECT * FROM player_phone_contacts WHERE number = ? AND citizenid = ?', {
        ContactNumber,
        Player.PlayerData ~= nil and Player.PlayerData.CitizenId or Player
    }, function(Contacts)
        if Contacts[1] ~= nil then
            Promise:resolve({true, Contacts[1].name})
        else
            Promise:resolve(false)
        end
    end, true)
    return Citizen.Await(Promise)
end