local RegisteredCallbacks = {} -- Server
local RegisteredClientCallbacks = {} -- CLient

local _Ready = false
AddEventHandler('Modules/server/ready', function()
    if not _Ready then
        _Ready = true
        exports[GetCurrentResourceName()]:CreateModule("Callback", CallbackModule)
    end
end)

CallbackModule = {
    TriggerCallback = function(Name, Cb, ...)
        local CbId = #RegisteredClientCallbacks + 1
        CbId = Name ..":" ..CbId
        RegisteredClientCallbacks[CbId] = Cb
        local src = source
        TriggerClientEvent("mercy-base/client/callbacks-client-trigger", src, CbId, Name, ...)
    end,
    CreateCallback = function(Name, Cb)
        RegisteredCallbacks[Name] = Cb
    end,
}

-- Client Callbacks
RegisterNetEvent("mercy-base/server/callbacks-client-response", function(Id, Data)
    local src = source
    TriggerClientEvent('mercy-base/client/callbacks-client-response', src, Id, Data)
end)

-- Server callbacks
RegisterNetEvent("mercy-base/server/callbacks-trigger", function(Id, Name, ...)
    if not RegisteredCallbacks[Name] then return end
    if RegisteredCallbacks[Name] == nil then return print(('[DEBUG:Callbacks]: Tried to access callback %s but the callback was not found.. (Not created or not yet initialised perhaps?)'):format(Name)) end
    local src = source
    if src == 0 or src == nil then
        print(('[DEBUG:Callbacks]: Tried to access callback %s but the source was 0.. (Not created or not yet initialised perhaps?)'):format(Name))
        return
    end
    RegisteredCallbacks[Name](src, function(Data)
        TriggerClientEvent("mercy-base/client/callbacks-response", src, Id, Data)
    end, ...)
end)