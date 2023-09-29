Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(4)
    end

    CallbackModule.CreateCallback('mercy-phone/server/messages/get-chats', function(Source, Cb)
        local Player = PlayerModule.GetPlayerBySource(Source)
        DatabaseModule.Execute('SELECT * FROM player_phone_messages WHERE citizenid = ?', {
            Player.PlayerData.CitizenId
        }, function(Messages)
            Cb(Messages)
        end)
    end)

    CallbackModule.CreateCallback('mercy-phone/server/messages/get-chat-messages', function(Source, Cb, Data)
        -- Data.ContactData.name, Data.ContactData.number
        local Player = PlayerModule.GetPlayerBySource(Source)
        DatabaseModule.Execute('SELECT * FROM player_phone_messages WHERE citizenid = ? AND number = ? AND name = ?', {
            Player.PlayerData.CitizenId,
            Data.ContactData.number,
            Data.ContactData.name
        }, function(Messages)
            if Messages[1] ~= nil then
                Cb(json.decode(Messages[1].messages))
            else
                Cb({})
            end
        end)
    end)

    CallbackModule.CreateCallback('mercy-phone/server/messages/send-message', function(Source, Cb, Data)
        local Sender = PlayerModule.GetPlayerBySource(Source)
        if not Sender then return Cb(false) end
        local Receiver = PlayerModule.GetPlayerByPhoneNumber(Data.ContactData.number)
        local SenderPhone = Sender.PlayerData.CharInfo.PhoneNumber:gsub('%-', '')

        DatabaseModule.Execute('SELECT * FROM player_phone_messages WHERE citizenid = ? AND number = ? AND name = ?', {
            Sender.PlayerData.CitizenId,
            Data.ContactData.number,
            Data.ContactData.name
        }, function(ChatData)
            if ChatData[1] ~= nil then -- Check if sender already has chat with receiver.
                local Messages = json.decode(ChatData[1].messages)
                Messages[#Messages+1] = {
                    ['Message'] = Data.Message,
                    ['Sender'] = Sender.PlayerData.CitizenId,
                    ['Time'] = os.date(),
                }
                MessagesDebugPrint('NewMessageOnline', ('Sender has chat with Receiver, updating it.. | CitizenId: %s'):format(Sender.PlayerData.CitizenId))
                -- Update messages for sender
                DatabaseModule.Execute('UPDATE player_phone_messages SET messages = ? WHERE citizenid = ? AND number = ? AND name = ?', {
                    json.encode(Messages),
                    Sender.PlayerData.CitizenId,
                    Data.ContactData.number,
                    Data.ContactData.name
                }, function()
                    MessagesDebugPrint('NewMessageOnline', ('Saved sender\'s chat, currently refreshing. | CitizenId: %s'):format(Sender.PlayerData.CitizenId))
                    TriggerClientEvent('mercy-phone/client/messages/refresh-chat', Source, Data.ContactData.number, Messages)

                    -- Update messages for receiver
                    if Receiver then -- Online
                        MessagesDebugPrint('NewMessageOnline', ('Receiver is online, trying to update chat. | CitizenId: %s'):format(Receiver.PlayerData.CitizenId))
                        local ContactData = IsInContacts(Receiver, SenderPhone) -- Checks if caller in in receiver contacts.
                        local SenderName = ContactData ~= false and ContactData[2] ~= nil and ContactData[2] or SenderPhone or SenderPhone -- Get name by checking if sender is in receiver's contacts.

                        MessagesDebugPrint('NewMessageOnline', ('Checked if Sender is in Receiver\'s contacts. | SenderName: %s'):format(SenderName))

                        -- Check if target already has chat with person
                        DatabaseModule.Execute('SELECT * FROM player_phone_messages WHERE citizenid = ? AND number = ? AND name = ?', {
                            Receiver.PlayerData.CitizenId,
                            SenderPhone,
                            SenderName
                        }, function(TargetChatData)
                            if TargetChatData[1] ~= nil then -- Target already has chat with sender
                                MessagesDebugPrint('NewMessageOnline', ('Receiver has chat with Sender, updating it.. | CitizenId: %s'):format(Receiver.PlayerData.CitizenId))
                                DatabaseModule.Execute('UPDATE player_phone_messages SET messages = ? WHERE citizenid = ? AND number = ? AND name = ?', {
                                    json.encode(Messages),
                                    Receiver.PlayerData.CitizenId,
                                    SenderPhone,
                                    SenderName
                                }, function()
                                    MessagesDebugPrint('NewMessageOnline', ('Saved Receiver\'s chat, currently refreshing.. | CitizenId: %s'):format(Receiver.PlayerData.CitizenId))
                                    TriggerClientEvent('mercy-phone/client/messages/refresh-chat', Receiver.PlayerData.Source, SenderPhone, Messages)
                                end)
                                Cb(true)
                            else -- Target does not have chat with sender so import
                                MessagesDebugPrint('NewMessageOnline', ('Receiver DOES NOT have chat with Sender, creating one and updating it.. | CitizenId: %s'):format(Receiver.PlayerData.CitizenId))
                                DatabaseModule.Execute('INSERT INTO player_phone_messages (citizenid, name, number, messages) VALUES (?, ?, ?, ?)', {
                                    Receiver.PlayerData.CitizenId,
                                    SenderPhone,
                                    SenderName,
                                    json.encode(Messages)
                                }, function()
                                    MessagesDebugPrint('NewMessageOnline', ('Saved Receiver\'s chat, currently refreshing.. | CitizenId: %s'):format(Receiver.PlayerData.CitizenId))
                                    TriggerClientEvent('mercy-phone/client/messages/refresh-chat', Receiver.PlayerData.Source, Data.ContactData.number, Messages)
                                end)
                                Cb(true)
                            end
                        end)
                    else -- Offline
                        MessagesDebugPrint('NewMessageOffline', ('Receiver is offline, trying to update chat using database info.. | Phone Number: %s '):format(string.sub(Data.ContactData.number, 0, 3)..''..string.sub(Data.ContactData.number, 4, (string.len(Data.ContactData.number) + 1))))
                        DatabaseModule.Execute('SELECT * FROM players WHERE CharInfo LIKE ?', { -- Get Target's CitizenId
                            "%"..(string.sub(Data.ContactData.number, 0, 3)..'-'..string.sub(Data.ContactData.number, 4, (string.len(Data.ContactData.number) + 1))).."%"
                        }, function(Players)
                            if Players[1] ~= nil then
                                MessagesDebugPrint('NewMessageOffline', ('Receiver data found in database.. | CitizenId: %s'):format(Players[1].CitizenId))
                                local ContactData = IsInContacts(Players[1].CitizenId, SenderPhone) -- Checks if caller in in receiver contacts.
                                local SenderName = ContactData ~= false and ContactData[2] ~= nil and ContactData[2] or SenderPhone or SenderPhone
                                MessagesDebugPrint('NewMessageOffline', ('Checked if Sender is in Receiver\'s contacts. | ContactData: %s | ContractData2: %s | SenderName: %s'):format(ContactData[1], ContactData[2], SenderName))

                                DatabaseModule.Execute('UPDATE player_phone_messages SET messages = ? WHERE citizenid = ? AND number = ? AND name = ?', {
                                    json.encode(Messages),
                                    Players[1].CitizenId,
                                    SenderPhone,
                                    SenderName
                                }, function()
                                    MessagesDebugPrint('NewMessageOffline', ('Saved Receiver\'s chat in database.. | CitizenId: %s'):format(Players[1].CitizenId))
                                end)
                                Cb(true)
                            else
                                Cb(false)
                            end
                        end)
                    end
                end)
            else -- Create new chat
                local Messages = {}
                Messages[#Messages+1] = {
                    ['Message'] = Data.Message,
                    ['Sender'] = Sender.PlayerData.CitizenId,
                    ['Time'] = os.date(),
                }
                MessagesDebugPrint('NewMessageOnline', ('Sender does not have chat with Receiver, creating one and updating it.. | CitizenId: %s'):format(Sender.PlayerData.CitizenId))
                -- Insert messages for sender
                DatabaseModule.Execute('INSERT INTO player_phone_messages (citizenid, name, number, messages) VALUES (?, ?, ?, ?)', {
                    Sender.PlayerData.CitizenId,
                    Data.ContactData.name,
                    Data.ContactData.number,
                    json.encode(Messages)
                }, function()
                    MessagesDebugPrint('NewMessageOnline', ('Saved sender\'s chat, currently refreshing. | CitizenId: %s'):format(Sender.PlayerData.CitizenId))
                    TriggerClientEvent('mercy-phone/client/messages/refresh-chat', Source, Data.ContactData.number, Messages)

                    -- Update messages for receiver
                    if Receiver then -- Online
                        MessagesDebugPrint('NewMessageOnline', ('Receiver is online, trying to update chat. | CitizenId: %s'):format(Receiver.PlayerData.CitizenId))
                        local ContactData = IsInContacts(Receiver, SenderPhone) -- Checks if caller in in receiver contacts.
                        local SenderName = ContactData ~= false and ContactData[2] ~= nil and ContactData[2] or SenderPhone or SenderPhone-- Get name by checking if sender is in receiver's contacts.

                        MessagesDebugPrint('NewMessageOnline', ('Checked if Sender is in Receiver\'s contacts. | SenderName: %s'):format(SenderName))

                        -- Check if target already has chat with person
                        DatabaseModule.Execute('SELECT * FROM player_phone_messages WHERE citizenid = ? AND number = ? AND name = ?', {
                            Receiver.PlayerData.CitizenId,
                            SenderPhone,
                            SenderName
                        }, function(TargetChatData)
                            if TargetChatData[1] ~= nil then -- Target already has chat with sender
                                MessagesDebugPrint('NewMessageOnline', ('Receiver has chat with Sender, updating it.. | CitizenId: %s'):format(Receiver.PlayerData.CitizenId))
                                DatabaseModule.Execute('UPDATE player_phone_messages SET messages = ? WHERE citizenid = ? AND number = ? AND name = ?', {
                                    json.encode(Messages),
                                    Receiver.PlayerData.CitizenId,
                                    SenderPhone,
                                    SenderName
                                }, function()
                                    MessagesDebugPrint('NewMessageOnline', ('Saved Receiver\'s chat, currently refreshing.. | CitizenId: %s'):format(Receiver.PlayerData.CitizenId))
                                    TriggerClientEvent('mercy-phone/client/messages/refresh-chat', Receiver.PlayerData.Source, SenderPhone, Messages)
                                end)
                                Cb(true)
                            else -- Target does not have chat with sender so import
                                MessagesDebugPrint('NewMessageOnline', ('Receiver DOES NOT have chat with Sender, creating one and updating it.. | CitizenId: %s'):format(Receiver.PlayerData.CitizenId))
                                DatabaseModule.Execute('INSERT INTO player_phone_messages (citizenid, name, number, messages) VALUES (?, ?, ?, ?)', {
                                    Receiver.PlayerData.CitizenId,
                                    SenderPhone,
                                    SenderName,
                                    json.encode(Messages)
                                }, function()
                                    MessagesDebugPrint('NewMessageOnline', ('Saved Receiver\'s chat, currently refreshing.. | CitizenId: %s'):format(Receiver.PlayerData.CitizenId))
                                    TriggerClientEvent('mercy-phone/client/messages/refresh-chat', Receiver.PlayerData.Source, Data.ContactData.number, Messages)
                                end)
                                Cb(true)
                            end
                        end)
                    else -- Offline
                        MessagesDebugPrint('NewMessageOffline', ('Receiver is offline, trying to update chat using database info.. | Phone Number: %s '):format(string.sub(Data.ContactData.number, 0, 3)..''..string.sub(Data.ContactData.number, 4, (string.len(Data.ContactData.number) + 1))))
                        DatabaseModule.Execute('SELECT * FROM players WHERE CharInfo LIKE ?', { -- Get Target's CitizenId
                            "%"..(string.sub(Data.ContactData.number, 0, 3)..'-'..string.sub(Data.ContactData.number, 4, (string.len(Data.ContactData.number) + 1))).."%"
                        }, function(Players)
                            if Players[1] ~= nil then
                                MessagesDebugPrint('NewMessageOffline', ('Receiver data found in database.. | CitizenId: %s'):format(Players[1].CitizenId))
                                local ContactData = IsInContacts(Players[1].CitizenId, SenderPhone) -- Checks if caller in in receiver contacts.
                                local SenderName = ContactData ~= false and ContactData[2] ~= nil and ContactData[2] or SenderPhone or SenderPhone
                                MessagesDebugPrint('NewMessageOffline', ('Checked if Sender is in Receiver\'s contacts. | ContactData: %s | ContractData2: %s | SenderName: %s'):format(ContactData[1], ContactData[2], SenderName))
                                DatabaseModule.Execute('UPDATE player_phone_messages SET messages = ? WHERE citizenid = ? AND number = ? AND name = ?', {
                                    json.encode(Messages),
                                    Receiver.PlayerData.CitizenId,
                                    SenderPhone,
                                    SenderName
                                }, function()
                                    MessagesDebugPrint('NewMessageOffline', ('Saved Receiver\'s chat in database.. | CitizenId: %s'):format(Players[1].CitizenId))
                                    TriggerClientEvent('mercy-phone/client/messages/refresh-chat', Receiver.PlayerData.Source, SenderPhone, Messages)
                                end)
                                Cb(true)
                            else
                                Cb(false)
                            end
                        end)
                    end
                end)
            end
        end)
    end)
end)

function MessagesDebugPrint(Type, Message, ...)
    if not ServerConfig.Debug then return end
    if ... ~= nil then
        print(('^4[^5Debug^4:^5Messages^4:^5%s^4]:^7 %s %s'):format(Type, Message, ...))
    else
        print(('^4[^5Debug^4:^5Messages^4:^5%s^4]:^7 %s'):format(Type, Message))
    end
end