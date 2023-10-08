local RegisteredEvents = {}

local _Ready = false
AddEventHandler('Modules/server/ready', function()
    if not _Ready then
        _Ready = true
        exports[GetCurrentResourceName()]:CreateModule("Events", EventsModule, true)
    end
end)

RegisterNetEvent("mercy-base/server/load-token", function()
    local EventsToken = "EGTOKEN"..math.random(1111111, 9999999)
    local EventsModule = exports[GetCurrentResourceName()]:FetchModule('Events')
    if EventsModule['Token'] == nil then
        EventsModule['Token'] = EventsToken
    end
    TriggerClientEvent('mercy-base/client/eventguard-set-token', -1, EventsModule['Token'])
    exports[GetCurrentResourceName()]:CreateModule("Events", EventsModule, true)
end)

EventsModule = {
    ['Token'] = nil,
    RegisterServer = function(Name, Callback)
        if RegisteredEvents[Name] ~= nil then
            RemoveEventHandler(RegisteredEvents[Name])
        else
            RegisterNetEvent(Name)
        end
        RegisteredEvents[Name] = AddEventHandler(Name, function(Token, ...)
            local src = source
            if Token ~= exports[GetCurrentResourceName()]:FetchModule('Events')['Token'] then return end
            if src == nil then return print('[DEBUG:EventsModule]: Source not found, not able to finish creating Protected Event..') end
            Callback(src, ...)
        end)
    end,
}