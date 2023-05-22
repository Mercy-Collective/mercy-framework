local _Ready = false

AddEventHandler('Modules/client/ready', function()
    if not _Ready then
        _Ready = true
        exports[GetCurrentResourceName()]:CreateModule("Onesync", OnesyncModule)
    end
end)

OnesyncModule = {
    GetPlayerCoords = function(ServerId)
        local CallbackModule = exports[GetCurrentResourceName()]:FetchModule('Callback')
        local Coords = CallbackModule.SendCallback('mercy-base/server/get-specific-coords', ServerId)
        return Coords
    end
}