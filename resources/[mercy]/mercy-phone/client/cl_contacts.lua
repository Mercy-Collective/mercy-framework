--[[
    App: Contacts
]]

Contacts = {
    CallId = nil,
    Contacts = {}
}

-- Untested, needs testing.
function Contacts.InitKeybinds()
    KeybindsModule.Add('phoneAnswer', 'Phone', 'Answer Call', '', function(IsPressed)
        if not IsPressed then return end
        if Contacts.CallId == nil then return end
        if not exports['mercy-inventory']:HasEnoughOfItem('phone', 1) then return end
        local PlayerData = PlayerModule.GetPlayerData()
        if PlayerData.MetaData['Dead'] or PlayerData.MetaData['Handcuffed'] then return end
        TriggerEvent('mercy-phone/client/calling/answer-call', { Declined = false, Id = Contacts.CallId })
    end)
    
    KeybindsModule.Add('phoneDecline', 'Phone', 'Decline Call', '', function(IsPressed)
        if not IsPressed then return end
        if Contacts.CallId == nil then return end
        if not exports['mercy-inventory']:HasEnoughOfItem('phone', 1) then return end
        local PlayerData = PlayerModule.GetPlayerData()
        if PlayerData.MetaData['Dead'] or PlayerData.MetaData['Handcuffed'] then return end
        TriggerEvent('mercy-phone/client/calling/answer-call', { Declined = true, Id = Contacts.CallId })
    end)
end

function Contacts.Render()
    local Result = CallbackModule.SendCallback("mercy-phone/server/contacts/get-contacts")
    exports['mercy-ui']:SendUIMessage("Phone", "RenderContactsApp", {
        Contacts = Result or {}
    })
end

RegisterNUICallback("Contacts/AddContact", function(Data, Cb)
    EventsModule.TriggerServer("mercy-phone/server/contacts/add-contact", Data)
    Cb('Ok')
end)

RegisterNUICallback("Contacts/RemoveContact", function(Data, Cb)
    EventsModule.TriggerServer("mercy-phone/server/contacts/remove-contact", Data)
    Cb('Ok')
end)

RegisterNUICallback("Contacts/GetContacts", function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-phone/server/contacts/get-contacts")
    Cb(Result or {})
end)

RegisterNetEvent('mercy-phone/client/contacts/refresh', function()
    local Result = CallbackModule.SendCallback("mercy-phone/server/contacts/get-contacts")
    exports['mercy-ui']:SendUIMessage("Phone", "RenderContactsApp", {
        Contacts = Result or {}
    })
end)

-- Calling
RegisterNUICallback('Contacts/CallContact', function(Data, Cb)
    EventsModule.TriggerServer("mercy-phone/server/contacts/call-contact", Data)
    Cb('Ok')
end)

RegisterNetEvent('mercy-phone/client/calling/answer-call', function(Data)
    if Contacts.CallId ~= nil and Contacts.CallId ~= Data.Id then return end
    EventsModule.TriggerServer('mercy-phone/server/calling/answer-call', Data)
end)

local InCall = false
RegisterNetEvent('mercy-phone/client/contacts/set-call-thread', function(Enabled, NotificationId)
    InCall = Enabled

    if Enabled then
        Citizen.CreateThread(function()
            local SecondsSpent = 0
            local MinutesSpent = 0
            local HoursSpent = 0 -- for them grinders lmfao
            
            while InCall do
                if SecondsSpent + 1 >= 60 then
                    SecondsSpent = 0
                    if MinutesSpent + 1 >= 60 then
                        MinutesSpent = 0
                        HoursSpent = HoursSpent + 1
                    else
                        MinutesSpent = MinutesSpent + 1
                    end
                else
                    SecondsSpent = SecondsSpent + 1
                end

                local SecondsString = SecondsSpent < 10 and "0" .. tostring(SecondsSpent) or tostring(SecondsSpent)
                local MinutesString = MinutesSpent < 10 and "0" .. tostring(MinutesSpent) or tostring(MinutesSpent)
                local HoursString = HoursSpent < 10 and "0" .. tostring(HoursSpent) or tostring(HoursSpent)

                exports['mercy-ui']:SendUIMessage('Phone', 'SetNotificationText', {
                    NotificationId = NotificationId,
                    Text = HoursSpent == 0 and ("%s:%s"):format(MinutesString, SecondsString) or ("%s:%s:%s"):format(HoursString, MinutesString, SecondsString)
                })

                Citizen.Wait(1000)
            end
        end)
    else
        exports['mercy-ui']:SendUIMessage('Phone', 'SetNotificationText', {
            NotificationId = NotificationId,
            Text = 'Disconnected!'
        })

        TriggerEvent('mercy-phone/client/set-notification-buttons', NotificationId, {})

        Citizen.SetTimeout(2500, function()
            exports['mercy-ui']:SendUIMessage('Phone', 'HideNotification', NotificationId)
        end)
    end
end)

RegisterNetEvent('mercy-phone/client/contacts/connect-voice', function(StartCall, PhoneNumber, Receiver)
    if StartCall then
        TriggerServerEvent('mercy-voice/server/phone/start-call', PhoneNumber, Receiver)
    else
        InCall = false
        TriggerServerEvent('mercy-voice/server/phone/end-call', PhoneNumber)
    end
end)

RegisterNetEvent('mercy-phone/client/set-call-id', function(CallId)
    Contacts.CallId = CallId
end)

RegisterNetEvent('mercy-phone/client/call/do-anim', function()
    if Contacts.CallId ~= nil then
        Phone.DoAnim(false, true, false)
    else
        Phone.DoAnim(false, false, true)
    end
end)

RegisterNetEvent('mercy-phone/client/call/force-disconnect', function(Payphone)
    if Contacts.CallId ~= nil then
        if Payphone ~= nil and Payphone then
            TriggerEvent('mercy-phone/client/calling/answer-call', { Declined = true, CallName = "Payphone", IsPayphone = true, Id = Contacts.CallId })
        else
            TriggerEvent('mercy-phone/client/calling/answer-call', { Declined = true, Id = Contacts.CallId })
        end
    end
end)