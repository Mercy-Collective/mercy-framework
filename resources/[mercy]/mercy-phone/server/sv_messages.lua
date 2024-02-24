Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(4)
    end

    CallbackModule.CreateCallback('mercy-phone/server/messages/get-chats', function(Source, Cb)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if not Player then return Cb({}) end

        local Chats = {}
        local MyPhone = Player.PlayerData.CharInfo.PhoneNumber:gsub('%-', '')
        local Result = exports['oxmysql']:executeSync('SELECT * FROM `player_phone_messages` WHERE `from_phone` = @Phone OR `to_phone` = @Phone ORDER BY `timestamp` DESC', { ['@Phone'] = MyPhone })

        for k, v in pairs(Result) do
            local Receiver = MyPhone == v.to_phone and v.from_phone or v.to_phone
            if Chats[Receiver] == nil then
                Chats[Receiver] = {
                    from_phone = MyPhone == v.to_phone and v.to_phone or v.from_phone,
                    to_phone = Receiver,
                    name = GetContactName(Player.PlayerData.CitizenId, Receiver),
                    messages = {}
                }
            end
    
            Chats[Receiver].messages[#Chats[Receiver].messages + 1] = {
                Sender = v.from_phone,
                Message = v.message,
                Attachments = json.decode(v.attachments),
                Timestamp = v.timestamp,
                Unread = v.unread,
            }
        end

        Cb(Chats)
    end)

    CallbackModule.CreateCallback('mercy-phone/server/messages/send-message', function(Source, Cb, Data)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if not Player then return Cb(false) end

        local MyPhone = Player.PlayerData.CharInfo.PhoneNumber:gsub('%-', '')
        exports['oxmysql']:executeSync("INSERT INTO `player_phone_messages` (`from_phone`, `to_phone`, `message`, `attachments`) VALUES (@FromPhone, @ToPhone, @Message, @Attachments)", {
            ['@FromPhone'] = MyPhone,
            ['@ToPhone'] = Data.Phone,
            ['@Message'] = Data.Message,
            ['@Attachments'] = json.encode(Data.Attachments),
        })
        TriggerClientEvent('mercy-phone/client/messages/refresh-chat', Player.PlayerData.Source, {}, false)

        local ToPlayer = PlayerModule.GetPlayerByPhoneNumber(tostring(Data.Phone))
        if ToPlayer then
            local ChatData = {
                Name = GetContactName(ToPlayer.PlayerData.CitizenId, MyPhone),
                Phone = MyPhone,
                Message = Data.Message,
            }
            TriggerClientEvent('mercy-phone/client/messages/refresh-chat', ToPlayer.PlayerData.Source, ChatData, true)
        end

        Cb(true)
    end)
end)

RegisterNetEvent("mercy-phone/server/messages/set-chat-read", function(Data, UsingBurner)
    local Result = exports['ghmattimysql']:execute("UPDATE `player_phone_messages` SET `unread` = 0 WHERE `from_phone` = @FromPhone AND `to_phone` = @ToPhone AND `unread` = 1", {
        ["@FromPhone"] = Data.ToPhone,
        ["@ToPhone"] = Data.FromPhone,
    })
end)

function FormatPhone(Phone)
    if not Phone then return "" end
    return string.gsub(Phone, "%d%d%d-%d%d%d%d%d%d%d", "%1 %2")
end

function GetContactName(Cid, Phone)
    local Result = exports['oxmysql']:executeSync('SELECT * FROM `player_phone_contacts` WHERE `citizenid` = @Cid and `number` = @Number', { ['@Cid'] = Cid, ['@Number'] = Phone })
    return Result[1] and Result[1].name or FormatPhone(Phone)
end