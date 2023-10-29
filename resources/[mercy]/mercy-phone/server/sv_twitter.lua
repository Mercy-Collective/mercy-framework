local Tweets = {}

-- [ Code ] --

AddEventHandler('onResourceStart', function(Resource)
    if Resource == GetCurrentResourceName() then
        while DatabaseModule == nil do Citizen.Wait(10) end
        Wait(100)
        DatabaseModule.Execute('DELETE FROM player_phone_tweets WHERE `Time` < NOW() - INTERVAL ? hour', {
            Config.TweetDuration
        }, function(Result)
        if Result[1] == nil then return end
        end)
    end
end)

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(4)
    end

    CallbackModule.CreateCallback('mercy-phone/server/twitter/get-tweets', function(Source, Cb)
        DatabaseModule.Execute("SELECT * FROM player_phone_tweets WHERE `Time` > NOW() - INTERVAL ? hour", {
            Config.TweetDuration
        }, function(IsTweet)
            if IsTweet[1] ~= nil then
                Cb(IsTweet)
            else
                Cb(false)
            end
        end)
    end)

    EventsModule.RegisterServer("mercy-phone/server/twitter-post", function(Source, Data)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local Tweet = {
            Tweeter = Data.IsBusiness and "@"..Data.Business:gsub("%s+", "_") or "@"..Player.PlayerData.CharInfo.Firstname..'_'..Player.PlayerData.CharInfo.Lastname,
            Message = Data.Message,
            Time = os.date('%Y-%m-%d %H:%M:%S'),
            IsBusiness = Data.IsBusiness,
        }
        
        DatabaseModule.Insert('INSERT INTO player_phone_tweets (CitizenId, Tweeter, Message, Time, IsBusiness) VALUES (?, ?, ?, ?, ?) ', {
            Player.PlayerData.CitizenId,
            Tweet.Tweeter,
            Tweet.Message,
            Tweet.Time,
            Tweet.IsBusiness,
        }, function(IsSent)
            if IsSent then
                if Config.Debug then
                    print(Player.PlayerData.CitizenId .. ' ' .. Tweet.Tweeter .. ' ' .. Tweet.Message .. ' ' .. Tweet.Time .. ' ' .. tostring(Tweet.IsBusiness))
                end
                
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
            end
        end)
    end)
end)
