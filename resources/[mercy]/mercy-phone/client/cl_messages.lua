--[[
    App: Messages
]]

Messages = {}
Messages.Active = false

function Messages.Render()
    SetAppUnread('messages', false)
    Messages.Active = true
    Messages.SetChats()
end

function Messages.SetChats()
    local Result = CallbackModule.SendCallback("mercy-phone/server/messages/get-chats")
    exports['mercy-ui']:SendUIMessage("Phone", "RenderMessagesChats", {
        Chats = Result
    })
end

RegisterNUICallback("Messages/GetChat", function(Data, Cb)
    local Chats = CallbackModule.SendCallback("mercy-phone/server/messages/get-chats")
    Cb(Chats or {})
end)

RegisterNUICallback("Messages/RefreshChats", function(Data, Cb)
    Messages.SetChats()
    Cb('Ok')
end)

RegisterNUICallback("Messages/SendMessage", function(Data, Cb)
    local Success = CallbackModule.SendCallback("mercy-phone/server/messages/send-message", Data)
    Cb(Success)
end)

RegisterNetEvent('mercy-phone/client/messages/refresh-chat', function(Data, Notify)
    if not Messages.Active and Notify then
        if not PreferencesModule.GetPreferences().Phone.Notifications['SMS'] then return end
        TriggerEvent('mercy-phone/client/notification', {
            Title = Data.Name,
            Message = Data.Message,
            Icon = "fas fa-comment",
            IconBgColor = "#8FC24C",
            IconColor = "white",
            Sticky = false,
            Duration = 5000,
        })
        SetAppUnread('messages', true)
        return
    end

    Messages.SetChats()
end)
