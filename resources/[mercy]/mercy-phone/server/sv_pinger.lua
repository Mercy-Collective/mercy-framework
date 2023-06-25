-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(4)
    end

    CallbackModule.CreateCallback('mercy-phone/server/pinger/do-ping-request', function(Source, Cb, Data, Coords)
        -- Data.Receiver, Data.IsAnon
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Data.IsAnon then
            TriggerClientEvent('mercy-phone/client/pinger/receive', Data.Receiver, Coords, Source, "Anonymous")
        else
            local Receiver = PlayerModule.GetPlayerBySource(tonumber(Data.Receiver))
            if not Receiver then return print('[DEBUG:Pings]: Could not find ping receiver..') end
            TriggerClientEvent('mercy-phone/client/pinger/receive', Data.Receiver, Coords, Source, Player.PlayerData.CharInfo.Firstname .. ' ' .. Player.PlayerData.CharInfo.Lastname)
        end
    end)
end)

-- [ Events ] --

RegisterNetEvent("mercy-phone/server/pinger/sender-message", function(SenderId, Message)
    TriggerClientEvent('mercy-phone/client/notification', SenderId, {
        Id = math.random(11111111, 99999999),
        Title = "Ping!",
        Message = Message,
        Icon = "fas fa-map-pin",
        IconBgColor = "#4f5efc",
        IconColor = "white",
        Sticky = false,
        Duration = 3000,
        Buttons = {},
    })
end)