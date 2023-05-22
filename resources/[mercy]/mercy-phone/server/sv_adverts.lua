local Adverts = {}

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(4)
    end

    CallbackModule.CreateCallback('mercy-phone/server/adverts/get-posts', function(Source, Cb)
        Cb(Adverts)
    end)

    EventsModule.RegisterServer("mercy-phone/server/adverts-post", function(Source, Data)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local Advert = {
            Poster = Player.PlayerData.CharInfo.Firstname..' '..Player.PlayerData.CharInfo.Lastname,
            Message = Data.Message,
            Phone = Player.PlayerData.CharInfo['PhoneNumber'],
            Time = os.date(),
        }
        Adverts[#Adverts + 1] = Advert
        TriggerClientEvent('mercy-phone/client/adverts/sync-posts', -1, Advert)
        -- Send Notify to all Players
        for k, v in pairs(PlayerModule.GetPlayers()) do
            if v ~= Source or Config.Debug then
                TriggerClientEvent('mercy-phone/client/notification', v, {
                    Id = math.random(100000, 999999),
                    Title = Advert.Poster,
                    Message = Advert.Message,
                    Icon = "fas fa-ad",
                    IconBgColor = "#ccad5e",
                    IconColor = "white",
                    Sticky = false,
                    Duration = 4000,
                    Buttons = {},
                })
            end
        end
    end)

    CallbackModule.CreateCallback('mercy-phone/server/adverts/delete-post', function(Source, Cb)
        local Player = PlayerModule.GetPlayerBySource(Source)
        for k, v in pairs(Adverts) do
            if v.Phone == Player.PlayerData.CharInfo['PhoneNumber'] then
                table.remove(Adverts, k)
                Cb({Success = true})
                TriggerClientEvent('mercy-phone/client/adverts/sync-posts', -1, k, true)
                return
            end
        end
        Cb({
            Success = false,
            Fail = 'You do not have any adverts to delete',
        })
    end)

    CallbackModule.CreateCallback('mercy-phone/server/adverts/can-post', function(Source, Cb)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local Retval = true
        for k, v in pairs(Adverts) do
            if v.Phone == Player.PlayerData.CharInfo['PhoneNumber'] then
                Retval = false
            end
        end
        Cb(Retval)
    end)
end)