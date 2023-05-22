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

    EventsModule.RegisterServer('mercy-phone/server/messages/send-message', function(Source, Data)
        -- Data['ContactData'].name,.. and Data['Message']
        local Sender = PlayerModule.GetPlayerBySource(Source)
        local Receiver = PlayerModule.GetPlayerByPhoneNumber(Data.ContactData.number)
        local SenderPhone = Sender.PlayerData.CharInfo.PhoneNumber:gsub('%-', '')

        DatabaseModule.Execute('SELECT * FROM player_phone_messages WHERE citizenid = ? AND number = ? AND name = ?', {
            Sender.PlayerData.CitizenId,
            Data.ContactData.number,
            Data.ContactData.name
        }, function(ChatData)
            if ChatData[1] ~= nil then -- Check if sender already has chat with receiver.
                print('[DEBUG]: Sender has chat with Receiver.')
                -- Get Chat messages
                local Messages = json.decode(ChatData[1].messages)
                Messages[#Messages+1] = {
                    ['Message'] = Data.Message,
                    ['Sender'] = Sender.PlayerData.CitizenId,
                    ['Time'] = os.date(),
                }
                print('[DEBUG]: Adding new message to array.')
                -- Update messages for sender
                DatabaseModule.Execute('UPDATE player_phone_messages SET messages = ? WHERE citizenid = ? AND number = ? AND name = ?', {
                    json.encode(Messages),
                    Sender.PlayerData.CitizenId,
                    Data.ContactData.number,
                    Data.ContactData.name
                }, function()
                    print('[DEBUG]: Saved sender\'s chat, currently refreshing.')
                    TriggerClientEvent('mercy-phone/client/messages/refresh-chat', Source, Data.ContactData.number, Messages)

                    -- Update messages for receiver
                    if Receiver then -- Online
                        print('[DEBUG]: Receiver is online, trying to update chat.')
                        local ContactData = IsInContacts(Receiver, SenderPhone) -- Checks if caller in in receiver contacts.
                        local SenderName = ContactData ~= false and ContactData[2] ~= nil and ContactData[2] or SenderPhone or SenderPhone -- Get name by checking if sender is in receiver's contacts.

                        print('[DEBUG]: Checked if Sender is in Receiver\'s contacts.', ContactData[1], ContactData[2], SenderName)

                        -- Check if target already has chat with person
                        DatabaseModule.Execute('SELECT * FROM player_phone_messages WHERE citizenid = ? AND number = ? AND name = ?', {
                            Receiver.PlayerData.CitizenId,
                            SenderPhone,
                            SenderName
                        }, function(TargetChatData)
                            if TargetChatData[1] ~= nil then -- Target already has chat with sender
                                print('[DEBUG]: Receiver has chat with Sender, updating it..')
                                DatabaseModule.Execute('UPDATE player_phone_messages SET messages = ? WHERE citizenid = ? AND number = ? AND name = ?', {
                                    json.encode(Messages),
                                    Receiver.PlayerData.CitizenId,
                                    SenderPhone,
                                    SenderName
                                }, function()
                                    print('[DEBUG]: Saved Receiver\'s chat, currently refreshing..')
                                    TriggerClientEvent('mercy-phone/client/messages/refresh-chat', Receiver.PlayerData.Source, SenderPhone, Messages)
                                end)
                            else -- Target does not have chat with sender so import
                                print('[DEBUG]: Receiver DOES NOT have chat with Sender, creating one and updating it..')
                                DatabaseModule.Execute('INSERT INTO player_phone_messages (citizenid, name, number, messages) VALUES (?, ?, ?, ?)', {
                                    Receiver.PlayerData.CitizenId,
                                    SenderPhone,
                                    SenderName,
                                    json.encode(Messages)
                                }, function()
                                    print('[DEBUG]: Saved Receiver\'s chat 2, currently refreshing..')
                                    TriggerClientEvent('mercy-phone/client/messages/refresh-chat', Receiver.PlayerData.Source, Data.ContactData.number, Messages)
                                end)
                            end
                        end)
                    else -- Offline
                        print('[DEBUG]: Receiver is offline, trying to update chat using database info..', (string.sub(Data.ContactData.number, 0, 3)..'-'..string.sub(Data.ContactData.number, 4, (string.len(Data.ContactData.number) + 1))))
                        DatabaseModule.Execute('SELECT * FROM players WHERE CharInfo LIKE ?', { -- Get Target's CitizenId
                            "%"..(string.sub(Data.ContactData.number, 0, 3)..'-'..string.sub(Data.ContactData.number, 4, (string.len(Data.ContactData.number) + 1))).."%"
                        }, function(Players)
                            if Players[1] ~= nil then
                                print('[DEBUG]: Receiver data found in database..')
                                local ContactData = IsInContacts(Players[1].CitizenId, SenderPhone) -- Checks if caller in in receiver contacts.
                                local SenderName = ContactData ~= false and ContactData[2] ~= nil and ContactData[2] or SenderPhone or SenderPhone
                                print('[DEBUG]: Checked if Sender is in Receiver\'s contacts.', ContactData[1], ContactData[2], SenderName)

                                DatabaseModule.Execute('UPDATE player_phone_messages SET messages = ? WHERE citizenid = ? AND number = ? AND name = ?', {
                                    json.encode(Messages),
                                    Players[1].CitizenId,
                                    SenderPhone,
                                    SenderName
                                }, function()
                                    print('[DEBUG]: Saved Receiver\'s chat in database..')
                                end)
                            end
                        end)
                    end

                end)
            else
                local Messages = {}
                Messages[#Messages+1] = {
                    ['Message'] = Data.Message,
                    ['Sender'] = Sender.PlayerData.CitizenId,
                    ['Time'] = os.date(),
                }
                print('[DEBUG:NEW]: Adding new message to array.')
                -- Insert messages for sender
                DatabaseModule.Execute('INSERT INTO player_phone_messages (citizenid, name, number, messages) VALUES (?, ?, ?, ?)', {
                    Sender.PlayerData.CitizenId,
                    Data.ContactData.name,
                    Data.ContactData.number,
                    json.encode(Messages)
                }, function()
                    print('[DEBUG:NEW]: Saved sender\'s chat, currently refreshing.')
                    TriggerClientEvent('mercy-phone/client/messages/refresh-chat', Source, Data.ContactData.number, Messages)

                    -- Update messages for receiver
                    if Receiver then -- Online
                        print('[DEBUG:NEW]: Receiver is online, trying to update chat.')
                        local ContactData = IsInContacts(Receiver, SenderPhone) -- Checks if caller in in receiver contacts.
                        local SenderName = ContactData ~= false and ContactData[2] ~= nil and ContactData[2] or SenderPhone or SenderPhone-- Get name by checking if sender is in receiver's contacts.

                        print('[DEBUG:NEW]: Checked if Sender is in Receiver\'s contacts.', ContactData[1], ContactData[2], SenderName)

                        -- Check if target already has chat with person
                        DatabaseModule.Execute('SELECT * FROM player_phone_messages WHERE citizenid = ? AND number = ? AND name = ?', {
                            Receiver.PlayerData.CitizenId,
                            SenderPhone,
                            SenderName
                        }, function(TargetChatData)
                            if TargetChatData[1] ~= nil then -- Target already has chat with sender
                                print('[DEBUG:NEW]: Receiver has chat with Sender, updating it..')
                                DatabaseModule.Execute('UPDATE player_phone_messages SET messages = ? WHERE citizenid = ? AND number = ? AND name = ?', {
                                    json.encode(Messages),
                                    Receiver.PlayerData.CitizenId,
                                    SenderPhone,
                                    SenderName
                                }, function()
                                    print('[DEBUG:NEW]: Saved Receiver\'s chat, currently refreshing..')
                                    TriggerClientEvent('mercy-phone/client/messages/refresh-chat', Receiver.PlayerData.Source, SenderPhone, Messages)
                                end)
                            else -- Target does not have chat with sender so import
                                print('[DEBUG:NEW]: Receiver DOES NOT have chat with Sender, creating one and updating it..')
                                DatabaseModule.Execute('INSERT INTO player_phone_messages (citizenid, name, number, messages) VALUES (?, ?, ?, ?)', {
                                    Receiver.PlayerData.CitizenId,
                                    SenderPhone,
                                    SenderName,
                                    json.encode(Messages)
                                }, function()
                                    print('[DEBUG:NEW]: Saved Receiver\'s chat, currently refreshing..')
                                    TriggerClientEvent('mercy-phone/client/messages/refresh-chat', Receiver.PlayerData.Source, Data.ContactData.number, Messages)
                                end)
                            end
                        end)
                    else -- Offline
                        print('[DEBUG:NEW]: Receiver is offline, trying to update chat using database info..', string.sub(Data.ContactData.number, 0, 3)..''..string.sub(Data.ContactData.number, 4, (string.len(Data.ContactData.number) + 1)))
                        DatabaseModule.Execute('SELECT * FROM players WHERE CharInfo LIKE ?', { -- Get Target's CitizenId
                            "%"..(string.sub(Data.ContactData.number, 0, 3)..'-'..string.sub(Data.ContactData.number, 4, (string.len(Data.ContactData.number) + 1))).."%"
                        }, function(Players)
                            if Players[1] ~= nil then
                                print('[DEBUG:NEW]: Receiver data found in database..')
                                local ContactData = IsInContacts(Players[1].CitizenId, SenderPhone) -- Checks if caller in in receiver contacts.
                                local SenderName = ContactData ~= false and ContactData[2] ~= nil and ContactData[2] or SenderPhone or SenderPhone
                                print('[DEBUG:NEW]: Checked if Sender is in Receiver\'s contacts.', ContactData[1], ContactData[2], SenderName)
                                DatabaseModule.Execute('UPDATE player_phone_messages SET messages = ? WHERE citizenid = ? AND number = ? AND name = ?', {
                                    json.encode(Messages),
                                    Receiver.PlayerData.CitizenId,
                                    SenderPhone,
                                    SenderName
                                }, function()
                                    print('[DEBUG:NEW]: Saved Receiver\'s chat 3, currently refreshing..')
                                    TriggerClientEvent('mercy-phone/client/messages/refresh-chat', Receiver.PlayerData.Source, SenderPhone, Messages)
                                end)
                            end
                        end)
                    end

                end)
            end
        end)
    end)
end)