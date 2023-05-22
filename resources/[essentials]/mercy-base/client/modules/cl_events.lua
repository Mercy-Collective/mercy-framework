local RegisteredEvents = {}

local _Ready = false
AddEventHandler('Modules/client/ready', function()
    if not _Ready then
        _Ready = true
        exports[GetCurrentResourceName()]:CreateModule("Events", EventsModule)
    end
end)

RegisterNetEvent("mercy-base/client/eventguard-set-token", function(Token)
    if EventsModule['Token'] == nil then
        EventsModule['Token'] = Token
        print("^1EventGuard: Set Token..^7")
    else
        print("^1EventGuard: Tried to set token, but the token was already set..^7")
    end
end)

EventsModule = {
    ['Token'] = nil,
    TriggerServer = function(Name, ...)
        TriggerServerEvent(Name, EventsModule['Token'], ...)
    end,
}