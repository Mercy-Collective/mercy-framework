local OriginalTrace = Citizen.Trace
local ErrorMatches = {
    "failure",
    "error",
    "not",
    "failed",
    "not safe", 
    "invalid",
    "cannot",
    ".lua", 
    "server",
    "client",
    "attempt",
    "traceback",
    "stack",
    "function"
}

function Citizen.Trace(...)
    OriginalTrace(...)

    if type(...) == "string" then
        local Args = string.lower(...)
        
        for _, Word in ipairs(ErrorMatches) do
            if string.find(Args, Word) then
                TriggerServerEvent('mercy-assets/server/error-log', GetCurrentResourceName(), ...)
                return
            end
        end
    end
end