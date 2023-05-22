local RegisteredCallbacks = {}
local RegisteredClientCallbacks = {}

local _Ready = false
AddEventHandler('Modules/client/ready', function()
    if not _Ready then
        _Ready = true
        exports[GetCurrentResourceName()]:CreateModule("Callback", CallbackModule)
    end
end)

CallbackModule = {
    TriggerCallback = function(Name, Cb, ...)
        local CbId = Name ..":" ..tostring(math.random(11111, 99999))
        RegisteredCallbacks[CbId] = Cb
        TriggerServerEvent("mercy-base/server/callbacks-trigger", CbId, Name, ...)
    end,
    CreateCallback = function(Name, Cb)
        RegisteredClientCallbacks[Name] = Cb
    end,
    SendCallback = function(Event, ...)
        local Promise = promise:new()
        CallbackModule.TriggerCallback(Event, function(Result) 
            Promise:resolve(Result)
        end, ...)
        return Citizen.Await(Promise)
    end
}

-- [ Events ] --

-- Server Callbacks
RegisterNetEvent("mercy-base/client/callbacks-response", function(Id, Data)
    local CallbackEvent = RegisteredCallbacks[Id]
    if CallbackEvent ~= nil then
        CallbackEvent(Data)
    end
end)

-- Client Callbacks
RegisterNetEvent("mercy-base/client/callbacks-client-response", function(Id, Data)
    local CallbackEvent = RegisteredClientCallbacks[Id]
    if CallbackEvent ~= nil then
        CallbackEvent(Data)
    end
end)

RegisterNetEvent("mercy-base/client/callbacks-client-trigger", function(Id, Name, ...)
    if not RegisteredClientCallbacks[Name] then return end
    RegisteredClientCallbacks[Name](function(Data)
        TriggerServerEvent("mercy-base/server/callbacks-client-response", Id, Data)
    end, ...)
end)