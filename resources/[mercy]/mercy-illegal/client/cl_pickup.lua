
RegisterNetEvent('mercy-illegal/client/open-pickup-store', function()
    local PlayerData = PlayerModule.GetPlayerData()
    if PlayerData.Job.Name == 'police' then TriggerEvent('mercy-ui/client/notify', "pickup-error", "I ain\'t be talking to the ops yo..", 'error') return end

    local MenuData = {}
    MenuData[#MenuData + 1] = {
        ['Title'] = 'Green Laptop',
        ['Desc'] = 'Cost: 15 SHUNG; 1 Green USB',
        ['Data'] = {['Event'] = 'mercy-illegal/client/do-purchase', ['Type'] = 'Client', ['BuyData'] = {Price = 15, Item = 'heist-usb-green', Reward = 'heist-laptop-green'} },
        ['Disabled'] = false
    }
    MenuData[#MenuData + 1] = {
        ['Title'] = 'Blue Laptop',
        ['Desc'] = 'Cost: 25 SHUNG; 1 Blue USB',
        ['Data'] = {['Event'] = '', ['Type'] = ''},
        ['Disabled'] = true
    }
    MenuData[#MenuData + 1] = {
        ['Title'] = 'Red Laptop',
        ['Desc'] = 'Cost: 35 SHUNG; 1 Red USB',
        ['Data'] = {['Event'] = '', ['Type'] = ''},
        ['Disabled'] = true
    }
    exports['mercy-ui']:OpenContext({ ['MainMenuItems'] = MenuData })
end)

RegisterNetEvent('mercy-illegal/client/do-purchase', function(Data)
    local BuyData = Data.BuyData
    if not HasEnoughCrypto('shungite', BuyData.Price) or not exports['mercy-inventory']:HasEnoughOfItem(BuyData.Item, 1) then return end
    
    CallbackModule.SendCallback('mercy-base/server/remove-item', BuyData.Item, 1, false, true)
    EventsModule.TriggerServer('mercy-base/server/remove-crypto', 'shungite', BuyData.Price)

    TriggerEvent('mercy-phone/client/dark/start-drop-off', BuyData.Reward)
    TriggerServerEvent("mercy-phone/server/mails/send-mail", "Dark Market", "#A-1001", "You know where to go.")
end)

-- [ Functions ] --

function HasEnoughCrypto(Type, Amount)
    local HasEnough = CallbackModule.SendCallback('mercy-base/server/has-enough-crypto', Type, Amount)
    return HasEnough
end