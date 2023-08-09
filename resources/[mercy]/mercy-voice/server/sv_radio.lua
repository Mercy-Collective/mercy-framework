local ActiveChannels = {}
local ChannelSubscribers = {}

-- [ Code ] --

function RemovePlayerFromRadio(SiD, ChannelId)
    if not ActiveChannels[ChannelId] then return end
    ActiveChannels[ChannelId].Count = ActiveChannels[ChannelId].Count - 1
    if ActiveChannels[ChannelId].Count == 0 then
        ActiveChannels[ChannelId] = nil
    else
        ActiveChannels[ChannelId].Subscribers[SiD] = nil
        for k, v in pairs(ActiveChannels[ChannelId].Subscribers) do
            TriggerClientEvent("mercy-voice/client/radio-removed", k, ChannelId, SiD)
        end
    end

    ChannelSubscribers[SiD] = nil
    TriggerClientEvent("mercy-voice/client/radio-disconnect", SiD, ChannelId)
    -- print("Removing player: " .. SiD  .. " from channel: " .. ChannelId)
end

function AddPlayerToRadio(SiD, ChannelId, RemoveOld)
    if RemoveOld then
        RemovePlayerFromRadio(SiD, ChannelSubscribers[SiD])
    end

    if ActiveChannels[ChannelId] == nil then
        ActiveChannels[ChannelId] = {}
        ActiveChannels[ChannelId].Subscribers = {}
        ActiveChannels[ChannelId].Count = 0
    end
    ActiveChannels[ChannelId].Count = ActiveChannels[ChannelId].Count + 1

    for k, v in pairs(ActiveChannels[ChannelId].Subscribers) do
        TriggerClientEvent("mercy-voice/client/radio-added", k, ChannelId, SiD)
    end

    ChannelSubscribers[SiD] = ChannelId
    ActiveChannels[ChannelId].Subscribers[SiD] = SiD
    TriggerClientEvent('mercy-voice/client/radio-connect', SiD, ChannelId, ActiveChannels[ChannelId].Subscribers)
    -- print(SiD,ChannelId)
    -- print("Adding player: " .. SiD  .. " to channel: " .. ChannelId)
end

RegisterNetEvent("mercy-voice/server/add-player-to-radio", function(ChannelId, RemoveOld)
    local src = source
    AddPlayerToRadio(src, ChannelId, RemoveOld)
end)

RegisterNetEvent("mercy-voice/server/remove-player-from-radio", function(Channel)
    RemovePlayerFromRadio(source, ChannelSubscribers[source])
end)

AddEventHandler('playerDropped', function(reason)
    if ChannelSubscribers[source] then
        RemovePlayerFromRadio(source, ChannelSubscribers[source])
    end
end)