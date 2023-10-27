local _Ready = false
AddEventHandler('Modules/client/ready', function()
    if not _Ready then
        _Ready = true
        exports[GetCurrentResourceName()]:CreateModule("Logger", LoggerModule)
    end
end)
LoggerModule = {
    Success = function(Component, Text)
        print(("^2[SUCCESS]^7 ^5[%s]^7: %s"):format(Component, Text))
    end,
    Error = function(Component, Text)
        print(("^1[ERROR]^7 ^5[%s]^7: %s"):format(Component, Text))
    end,
    Warning = function(Component, Text)
        print(("^8[WARNING]^7 ^5[%s]^7: %s"):format(Component, Text))
    end,
    Debug = function(Component, Text)
        print(("^9[DEBUG]^7 ^5[%s]^7: %s"):format(Component, Text))
    end,
    Neutral = function(Component, Text)
        print(("^7[NEUTRAL]^7 ^5[%s]^7: %s"):format(Component, Text))
    end,
    ServerLog = function(Log)
        if EventsModule == nil then
            print(("^7[SERVERLOG]^7 %s"):format(Log))
            return
        end
        if Log == nil then
            Log = "Default"
        end
        EventsModule.TriggerServer("mercy-base/server/create-log", Log)
    end,
}