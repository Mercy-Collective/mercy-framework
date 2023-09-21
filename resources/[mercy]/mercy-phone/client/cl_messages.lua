--[[
    App: Messages
]]

Messages = {}
Messages.Active = false
Messages.ChatNumber = nil

function Messages.Render()
    SetAppUnread('messages', false)
    Messages.Active = true
    local Result = CallbackModule.SendCallback("mercy-phone/server/messages/get-chats")
    exports['mercy-ui']:SendUIMessage("Phone", "RenderMessagesChats", {
        Chats = Result
    })
end

RegisterNUICallback("Messages/GetChat", function(Data, Cb)
    Messages.ChatNumber = Data.ContactData.number
    local Messages = CallbackModule.SendCallback("mercy-phone/server/messages/get-chat-messages", Data)
    Cb(Messages or {})
end)

RegisterNUICallback("Messages/RefreshChats", function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-phone/server/messages/get-chats")
    exports['mercy-ui']:SendUIMessage("Phone", "RenderMessagesChats", {
        Chats = Result
    })
    Cb('Ok')
end)

RegisterNUICallback("Messages/SendMessage", function(Data, Cb)
    local Success = CallbackModule.SendCallback("mercy-phone/server/messages/send-message", Data)
    Cb(Success)
end)

RegisterNetEvent('mercy-phone/client/messages/refresh-chat', function(ChatNumber, NewMessages)
    if not Messages.Active then
        local ContactData = CallbackModule.SendCallback("mercy-phone/server/contacts/get-contact", ChatNumber)
        local Preferences = PreferencesModule.GetPreferences()
        if not Preferences.Phone.Notifications['SMS'] then return end

        TriggerEvent('mercy-phone/client/notification', {
            Title = ContactData ~= nil and ContactData.name or ChatNumber,
            Message = NewMessages[#NewMessages].Message,
            Icon = "fas fa-comment",
            IconBgColor = "#3ce53b",
            IconColor = "white",
            Sticky = false,
            Duration = 5000,
        })

        SetAppUnread('messages', true)

        if Messages.ChatNumber == ChatNumber then
            exports['mercy-ui']:SendUIMessage("Phone", "RefreshActiveMessagesChat", {
                Messages = NewMessages
            })
        end

        return
    end

    if Messages.ChatNumber ~= ChatNumber then return end

    exports['mercy-ui']:SendUIMessage("Phone", "RefreshActiveMessagesChat", {
        Messages = NewMessages
    })
end)