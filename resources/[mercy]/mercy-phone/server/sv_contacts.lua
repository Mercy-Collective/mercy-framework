local Calls = {}

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(4)
    end

    -- Get

    CallbackModule.CreateCallback('mercy-phone/server/contacts/get-contacts', function(Source, Cb)
        local Player = PlayerModule.GetPlayerBySource(Source)
        DatabaseModule.Execute('SELECT * FROM player_phone_contacts WHERE citizenid = ?', {
            Player.PlayerData.CitizenId
        }, function(Contacts)
            if Contacts[1] ~= nil then
                Cb(Contacts)
            else
                Cb(false)
            end
        end)
    end) 

    CallbackModule.CreateCallback('mercy-phone/server/contacts/get-contact', function(Source, Cb, Number)
        local Player = PlayerModule.GetPlayerBySource(Source)
        DatabaseModule.Execute('SELECT * FROM player_phone_contacts WHERE citizenid = ? AND number = ?', {
            Player.PlayerData.CitizenId,
            Number
        }, function(Contacts)
            if Contacts[1] ~= nil then
                Cb(Contacts[1])
            else
                Cb(false)
            end
        end)
    end)

    -- Contact Main

    EventsModule.RegisterServer("mercy-phone/server/contacts/add-contact", function(Source, Data)
        local Player = PlayerModule.GetPlayerBySource(Source)
        DatabaseModule.Execute('SELECT * FROM player_phone_contacts WHERE citizenid = ?', {
            Player.PlayerData.CitizenId
        }, function(Contacts)
            for _, SubData in pairs(Data) do
                if Contacts[1] ~= nil then
                    for k, v in pairs(Contacts) do
                        if v.number == SubData.contact_number then
                            return
                        end
                    end
                    DatabaseModule.Insert('INSERT INTO player_phone_contacts (citizenid, name, number) VALUES (?, ?, ?)', {
                        Player.PlayerData.CitizenId,
                        SubData.contact_name,
                        SubData.contact_number
                    })
                else
                    DatabaseModule.Insert('INSERT INTO player_phone_contacts (citizenid, name, number) VALUES (?, ?, ?)', {
                        Player.PlayerData.CitizenId,
                        SubData.contact_name,
                        SubData.contact_number
                    })
                end
            end
            TriggerClientEvent('mercy-phone/client/contacts/refresh', Source)
        end, true)
    end)
    
    EventsModule.RegisterServer("mercy-phone/server/contacts/remove-contact", function(Source, Data)
        local Player = PlayerModule.GetPlayerBySource(Source)
        DatabaseModule.Execute('DELETE FROM player_phone_contacts WHERE citizenid = ? AND id = ?', {
            Player.PlayerData.CitizenId,
            Data.ContactId
        }, function(result) 
            TriggerClientEvent('mercy-phone/client/contacts/refresh', Source)
        end, true)
    end)
    
    function GetReceiverData(Caller, ContactNumber)
        -- Check if receiver the caller is trying to call is in his contacts (if not then display number of person.)
        local Promise = promise:new()
        local Target = PlayerModule.GetPlayerByPhoneNumber(ContactNumber)
        DatabaseModule.Execute('SELECT * FROM player_phone_contacts WHERE number = ? AND citizenid = ?', {
            ContactNumber,
            Caller.PlayerData.CitizenId
        }, function(Contacts)
            if Contacts[1] ~= nil then
                Contacts[1].stateIdReceiver = Target and Target.PlayerData.CitizenId or false
                Promise:resolve(Contacts[1]) 
            else
                Promise:resolve({
                    stateIdReceiver = Target and Target.PlayerData.CitizenId or false
                }) 
            end
        end, true)
        return Citizen.Await(Promise)
    end
    
    function AlreadyStoppedCall(ContactNumber, Caller)
        if Calls[ContactNumber] == nil then -- Check if already hung up.
            return true
        else
            TriggerClientEvent('mercy-phone/client/hide-notification', Caller.PlayerData.Source, ContactNumber)
            return false
        end
    end
    
    function FormatPhone(PhoneNumber)
        local digitsOnly = PhoneNumber:gsub("%D", "")
        return string.format("(%s) %s-%s",
            digitsOnly:sub(1, 3),
            digitsOnly:sub(4, 6),
            digitsOnly:sub(7, 10)
        )
    end
    
    EventsModule.RegisterServer('mercy-phone/server/dial-payphone', function(Source, Data)
        -- Data.Phone, Data.CallerName, Data.CallingFrom
        Data.Phone = Data.Phone:gsub('%-', '')
        local Caller = PlayerModule.GetPlayerBySource(Source)
        local RecData = GetReceiverData(Caller, Data.Phone)
        local Receiver = false
        if RecData then
            Receiver = PlayerModule.GetPlayerByStateId(RecData.stateIdReceiver)
        end
        if RecData and Receiver then -- Check if online
            if Calls[Data.Phone] == nil then
                Calls[Data.Phone] = {
                    InCall = false,
                    Caller = Caller.PlayerData.Source,
                    Receiver = Receiver.PlayerData.Source,
                }
                TriggerClientEvent('mercy-phone/client/set-call-id', Caller.PlayerData.Source, Data.Phone)
                TriggerClientEvent('mercy-phone/client/set-call-id', Receiver.PlayerData.Source, Data.Phone)
                TriggerClientEvent('mercy-phone/client/call/do-anim', Caller.PlayerData.Source)
                TriggerClientEvent('mercy-phone/client/set-call-data', Caller.PlayerData.Source, {
                    Payphone = true,
                    Id = Data.Phone,
                })
    
                Wait(1500)
                if AlreadyStoppedCall(Data.Phone, Caller) then 
                    TriggerClientEvent('mercy-phone/client/call/do-anim', Caller.PlayerData.Source)
                    TriggerClientEvent('mercy-phone/client/call/do-anim', Receiver.PlayerData.Source)
                    return 
                end -- Check if caller already hung up on connect message
                local ReceiverName = FormatPhone(Data.Phone)
              
                -- Add prompt to receiver
                TriggerClientEvent('mercy-phone/client/notification', Receiver.PlayerData.Source, {
                    Id = Data.Phone..'-receiver',
                    Title = Data.CallerName,
                    Message = "Incoming call...",
                    Icon = "fas fa-phone",
                    IconBgColor = "#4f5efc",
                    IconColor = "white",
                    Sticky = true,
                    Duration = 10000,
                    Buttons = {
                        {
                            Icon = "fas fa-times-circle",
                            Event = "mercy-phone/client/call/force-disconnect",
                            EventData = true,
                            Tooltip = "Disconnect",
                            Color = "#f2a365",
                            CloseOnClick = false,
                        },
                        {
                            Icon = "fas fa-check-circle",
                            Event = "mercy-phone/client/calling/answer-call",
                            EventData = { Declined = false, Id = Data.Phone, CallName = Data.CallerName, IsPayphone = true, },
                            Tooltip = "Answer",
                            Color = "#2ecc71",
                            CloseOnClick = false,
                        },
                    },
                })
                -- Do call sounds and stuff
                local RepeatTimeout = 2000
                local Tries = 0
                while Calls[Data.Phone] ~= nil and not Calls[Data.Phone].InCall do
                    Tries = Tries + 1
                    if Tries < 5 then
                        local PlayerCoords = GetEntityCoords(GetPlayerPed(Source))
                        local TargetCoords = GetEntityCoords(GetPlayerPed(Receiver.PlayerData.Source))
                        TriggerClientEvent('mercy-ui/client/play-audio-at-pos', -1, {[1] = PlayerCoords.x, [2] = PlayerCoords.y, [3] = PlayerCoords.z}, 5.0, "phone-calling", 0.6)
                        TriggerClientEvent('mercy-ui/client/play-audio-at-pos', -1, {[1] = TargetCoords.x, [2] = TargetCoords.y, [3] = TargetCoords.z}, 5.0, "phone-ringing", 0.6)
                    else                            
                        TriggerClientEvent('mercy-phone/client/call/force-disconnect', Source, true)
                        TriggerClientEvent('mercy-phone/client/hide-notification', Source, Data.Phone..'-caller')
                        TriggerClientEvent('mercy-phone/client/hide-notification', Receiver.PlayerData.Source, Data.Phone..'-receiver')
                        Tries = 0
                        break
                    end
                    Citizen.Wait(RepeatTimeout)
                end

            else
                Caller.Functions.Notify('This number is currently unavailable..', 'error', 3500)
            end
        else -- Receiver Offline
            TriggerClientEvent('mercy-phone/client/hide-notification', Source, Data.Phone..'-caller')
            TriggerClientEvent('mercy-phone/client/call/force-disconnect', Source, true)
            return
        end


    end)
    
    EventsModule.RegisterServer("mercy-phone/server/contacts/call-contact", function(Source, Data)
        Data.ContactData.number = Data.ContactData.number ~= nil and Data.ContactData.number:gsub('%-', '') or Data.ContactData.to_phone
        local Caller = PlayerModule.GetPlayerBySource(Source)
        local RecData = GetReceiverData(Caller, Data.ContactData.number)
        local Receiver = false
        if RecData then
            Receiver = PlayerModule.GetPlayerByStateId(RecData.stateIdReceiver)
        end
        -- Add Connect Prompt to Caller
        TriggerClientEvent('mercy-phone/client/notification', Caller.PlayerData.Source, {
            Id = Data.ContactData.number,
            Title = Data.ContactData.number,
            Message = "Connecting...",
            Icon = "fas fa-phone",
            IconBgColor = "#4f5efc",
            IconColor = "white",
            Sticky = false,
            Duration = 1500,
            Buttons = {
                {
                    Icon = "fas fa-times-circle",
                    Event = "mercy-phone/client/call/force-disconnect",
                    Tooltip = "Disconnect",
                    Color = "#f2a365",
                    CloseOnClick = false,
                },
            },
        })
        if RecData and Receiver then -- Check if online
            if Calls[Data.ContactData.number] == nil then
                Calls[Data.ContactData.number] = {
                    InCall = false,
                    Caller = Caller.PlayerData.Source,
                    Receiver = Receiver.PlayerData.Source,
                }
                TriggerClientEvent('mercy-phone/client/set-call-id', Caller.PlayerData.Source, Data.ContactData.number)
                TriggerClientEvent('mercy-phone/client/set-call-id', Receiver.PlayerData.Source, Data.ContactData.number)
    
                Wait(1500)
                if AlreadyStoppedCall(Data.ContactData.number, Caller) then return end -- Check if caller already hung up on connect message
                local ReceiverContact = IsInContacts(Receiver, Caller.PlayerData.CharInfo.PhoneNumber:gsub('%-', '')) -- Checks if caller in in receiver contacts.
                local ReceiverName = RecData.name ~= nil and RecData.name or FormatPhone(Data.ContactData.number)
                local CallerName = ReceiverContact ~= false and ReceiverContact[1] and Caller.PlayerData.CharInfo.Firstname..' '..Caller.PlayerData.CharInfo.Lastname or FormatPhone(Caller.PlayerData.CharInfo.PhoneNumber) or FormatPhone(Caller.PlayerData.CharInfo.PhoneNumber)
              
                -- Add Prompt to caller
                TriggerClientEvent('mercy-phone/client/notification', Caller.PlayerData.Source, {
                    Id = Data.ContactData.number.."-caller",
                    Title = ReceiverName,
                    Message = "Dialing...",
                    Icon = "fas fa-phone",
                    IconBgColor = "#4f5efc",
                    IconColor = "white",
                    Sticky = true,
                    Duration = 10000,
                    Buttons = {
                        {
                            Icon = "fas fa-times-circle",
                            Event = "mercy-phone/client/call/force-disconnect",
                            Tooltip = "Disconnect",
                            Color = "#f2a365",
                            CloseOnClick = false,
                        },
                    },
                })
    
                -- Add prompt to receiver
                TriggerClientEvent('mercy-phone/client/notification', Receiver.PlayerData.Source, {
                    Id = Data.ContactData.number..'-receiver',
                    Title = CallerName,
                    Message = "Incoming call...",
                    Icon = "fas fa-phone",
                    IconBgColor = "#4f5efc",
                    IconColor = "white",
                    Sticky = true,
                    Duration = 10000,
                    Buttons = {
                        {
                            Icon = "fas fa-times-circle",
                            Event = "mercy-phone/client/call/force-disconnect",
                            Tooltip = "Disconnect",
                            Color = "#f2a365",
                            CloseOnClick = false,
                        },
                        {
                            Icon = "fas fa-check-circle",
                            Event = "mercy-phone/client/calling/answer-call",
                            EventData = { Declined = false, Id = Data.ContactData.number },
                            Tooltip = "Answer",
                            Color = "#2ecc71",
                            CloseOnClick = false,
                        },
                    },
                })
                
                -- Do call sounds and stuff
                local RepeatTimeout = 2000
                local Tries = 0
                while Calls[Data.ContactData.number] ~= nil and not Calls[Data.ContactData.number].InCall do
                    Tries = Tries + 1
                    if Tries < 5 then
                        local PlayerCoords = GetEntityCoords(GetPlayerPed(Source))
                        local TargetCoords = GetEntityCoords(GetPlayerPed(Receiver.PlayerData.Source))
                        TriggerClientEvent('mercy-ui/client/play-audio-at-pos', -1, {[1] = PlayerCoords.x, [2] = PlayerCoords.y, [3] = PlayerCoords.z}, 5.0, "phone-calling", 0.6)
                        TriggerClientEvent('mercy-ui/client/play-audio-at-pos', -1, {[1] = TargetCoords.x, [2] = TargetCoords.y, [3] = TargetCoords.z}, 5.0, "phone-ringing", 0.6)
                    else                            
                        TriggerClientEvent('mercy-phone/client/call/force-disconnect', Source)
                        TriggerClientEvent('mercy-phone/client/hide-notification', Source, Data.ContactData.number..'-caller')
                        TriggerClientEvent('mercy-phone/client/hide-notification', Receiver.PlayerData.Source, Data.ContactData.number..'-receiver')
                        Tries = 0
                        break
                    end
                    Citizen.Wait(RepeatTimeout)
                end
            else
                TriggerClientEvent('mercy-phone/client/call/do-anim', Source)
                TriggerClientEvent('mercy-phone/client/notification', Source, {
                    Id = Data.ContactData.number,
                    Title = ReceiverName,
                    Message = "This person is unavailable.",
                    Icon = "fas fa-phone",
                    IconBgColor = "#4f5efc",
                    IconColor = "white",
                    Sticky = false,
                    Duration = 3000,
                    Buttons = {},
                })
            end
        else -- Receiver Offline
            TriggerClientEvent('mercy-phone/client/hide-notification', Source, Data.ContactData.number..'-caller')
            TriggerClientEvent('mercy-phone/client/call/force-disconnect', Source)
            TriggerClientEvent('mercy-phone/client/call/do-anim', Source)
            return
        end
    end)
    
    EventsModule.RegisterServer("mercy-phone/server/calling/answer-call", function(Source, Data)
        local CallData = Calls[Data.Id]
        local Caller = PlayerModule.GetPlayerBySource(CallData.Caller)
        local Receiver = PlayerModule.GetPlayerBySource(CallData.Receiver)
        if Caller and Receiver then
            local IsPayphone = Data.IsPayphone ~= nil and Data.IsPayphone or false
            if not Data.Declined then
                CallData.InCall = true
                TriggerClientEvent('mercy-phone/client/set-notification-buttons', Receiver.PlayerData.Source, Data.Id..'-receiver', {
                    {
                        Icon = "fas fa-times-circle",
                        Event = "mercy-phone/client/call/force-disconnect",
                        Tooltip = "Disconnect",
                        EventData = IsPayphone,
                        Color = "#f2a365",
                        CloseOnClick = false,
                    },
                })                
                TriggerClientEvent('mercy-phone/client/contacts/set-call-thread', Caller.PlayerData.Source, true, Data.Id..'-caller')   
                TriggerClientEvent('mercy-phone/client/contacts/set-call-thread', Receiver.PlayerData.Source, true, Data.Id..'-receiver')
                TriggerClientEvent('mercy-phone/client/contacts/connect-voice', Caller.PlayerData.Source, true, Receiver.PlayerData.CharInfo.PhoneNumber, Receiver.PlayerData.Source)
            else 
                Calls[Data.Id] = nil
                TriggerClientEvent('mercy-phone/client/contacts/set-call-thread', Caller.PlayerData.Source, false, Data.Id..'-caller')
                TriggerClientEvent('mercy-phone/client/contacts/set-call-thread', Receiver.PlayerData.Source, false, Data.Id..'-receiver')
                TriggerClientEvent('mercy-phone/client/contacts/connect-voice', Caller.PlayerData.Source, false, Receiver.PlayerData.CharInfo.PhoneNumber)
                TriggerClientEvent('mercy-phone/client/set-call-id', Caller.PlayerData.Source, nil)
                TriggerClientEvent('mercy-phone/client/set-call-id', Receiver.PlayerData.Source, nil)
                if IsPayphone then
                    TriggerClientEvent('mercy-phone/client/set-call-data', Caller.PlayerData.Source, false)
                end
                SetTimeout(1500, function()
                    TriggerClientEvent('mercy-phone/client/hide-notification', Caller.PlayerData.Source, Data.Id..'-caller')
                    TriggerClientEvent('mercy-phone/client/hide-notification', Receiver.PlayerData.Source, Data.Id..'-receiver')
                    TriggerClientEvent('mercy-phone/client/call/do-anim', Caller.PlayerData.Source)
                    TriggerClientEvent('mercy-phone/client/call/do-anim', Receiver.PlayerData.Source)
                end)
            end
    
            -- Add Logs
            local ReceiverName = Data.RecName ~= nil and Data.RecName or FormatPhone(Receiver.PlayerData.CharInfo.PhoneNumber)
            local CallLogReceiver = { Type = 'Outgoing', Name = ReceiverName, Timestamp = os.date(), Contact = {
                number = Receiver.PlayerData.CharInfo.PhoneNumber,
            }}
            local CallerName = Data.CallName ~= nil and Data.CallName or FormatPhone(Caller.PlayerData.CharInfo.PhoneNumber)
            local CallLogSender = { Type = 'Incoming', IsPayphone = IsPayphone, Name = CallerName, Timestamp = os.date(), Contact = {
                number = Caller.PlayerData.CharInfo.PhoneNumber,
            }}
            if not IsPayphone then
                TriggerClientEvent('mercy-phone/client/calls/add-call-log', Caller.PlayerData.Source, CallLogReceiver)
            end
            TriggerClientEvent('mercy-phone/client/calls/add-call-log', Receiver.PlayerData.Source, CallLogSender)
        else
            TriggerClientEvent('mercy-phone/client/call/force-disconnect', Source, IsPayphone)
        end
    end)
end)