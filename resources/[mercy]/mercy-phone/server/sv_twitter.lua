local Tweets = {}

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(4)
    end

    CallbackModule.CreateCallback('mercy-phone/server/twitter/get-tweets', function(Source, Cb)
        Cb(Tweets)
    end)

    EventsModule.RegisterServer("mercy-phone/server/twitter-post", function(Source, Data)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local Tweet = {
            Tweeter = Data.IsBusiness and "@"..Data.Business:gsub("%s+", "_") or "@"..Player.PlayerData.CharInfo.Firstname..'_'..Player.PlayerData.CharInfo.Lastname,
            Message = Data.Message,
            Time = os.date(),
            IsBusiness = Data.IsBusiness,
        }
        Tweets[#Tweets + 1] = Tweet
        TriggerClientEvent('mercy-phone/client/twitter/sync-tweets', -1, Tweet)
        -- Send Notify to all Players
        for k, v in pairs(PlayerModule.GetPlayers()) do
            if v ~= Source or Config.Debug then
                TriggerClientEvent('mercy-phone/client/notification', v, {
                    Id = math.random(100000, 999999),
                    Title = Tweet.Tweeter,
                    Message = Tweet.Message,
                    Icon = "fab fa-twitter",
                    IconBgColor = "#1da0f2",
                    IconColor = "white",
                    Sticky = false,
                    Duration = 4000,
                    Buttons = {},
                })
            end
        end
    end)
end)