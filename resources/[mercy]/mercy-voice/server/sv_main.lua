-- [ Code ] --

-- [ Events ] --

RegisterNetEvent("mercy-voice/server/connection-state", function(State)
    local Source = source
    Config.VoiceEnabled = State
    TriggerClientEvent('mercy-voice/client/connection-state', Source, State)
end)

RegisterNetEvent("mercy-voice/server/transmission-state", function(Context, Transmitting)
    local Source = source
    TriggerClientEvent('mercy-voice/client/transmission-state', -1, Source, Context, Transmitting)
end)

RegisterNetEvent("mercy-voice/server/transmission-state-radio", function(Group, Context, Transmitting, IsMult)
	local Source = source
    if IsMult then
        for k, v in pairs(Group) do
            TriggerClientEvent('mercy-voice/client/transmission-state', v, Source, Context, Transmitting)
        end
    else
        TriggerClientEvent('mercy-voice/client/transmission-state', Group, Source, Context, Transmitting)
    end
end)