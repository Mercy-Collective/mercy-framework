-- [ Code ] --

-- [ Threads ] --

-- Citizen.CreateThread(function()
--     while not _Ready do
--         Citizen.Wait(4)
--     end

-- end)

-- [ Events ] --

RegisterNetEvent("mercy-phone/server/mails/send-mail", function(Title, Subject, Content)
    local src = source
    TriggerClientEvent('mercy-phone/client/mails/send-mail', src, {
        Sender = Title,
        Subject = Subject,
        Content = Content,
        Timestamp = os.date()
    })
end)