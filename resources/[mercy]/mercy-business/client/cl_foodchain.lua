local SkippedMinigames = 0

-- [ Code ] --

-- [ Threads ] --

-- Distance Check
Citizen.CreateThread(function()
    while true do
        if LocalPlayer.state.LoggedIn and ClockedData.Clocked then
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local Distance = #(PlayerCoords - Config.FoodChainLocations[ClockedData.Business])
            if Distance > 30.0 then
                TriggerEvent('mercy-business/client/foodchain/set-duty', {Business = 'None', Clocked = false})
            end
            Citizen.Wait(2000)
        else
            Citizen.Wait(450)
        end
    end
end)

-- Give tickets every 5 min
Citizen.CreateThread(function()
    while true do
        if LocalPlayer.state.LoggedIn and ClockedData.Business == 'Burger Shot' and ClockedData.Clocked then
            Citizen.Wait((1000 * 60) * 5) -- 5 min
            if ClockedData.Business == 'Burger Shot' and ClockedData.Clocked then -- Or Pizza This or UwU,..
                EventsModule.TriggerServer('mercy-inventory/server/add-item', 'receipt', 1, false, {Business = ClockedData.Business, Money = math.random(150, 250), Comment = 'Paycheck'}, true)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- [ Events ] --


RegisterNetEvent('mercy-business/client/foodchain/open-storage', function(Storage)
    Citizen.SetTimeout(350, function()
        if exports['mercy-inventory']:CanOpenInventory() then
            EventsModule.TriggerServer('mercy-inventory/server/open-other-inventory', Storage, 'Stash', 10, 200)
        end
    end)
end)

RegisterNetEvent('mercy-business/client/foodchain/order-menu', function(Data)
    local OrderInput = exports['mercy-ui']:CreateInput({
        {Name = 'Price', Label = 'Price', Icon = 'fas fa-dollar-sign'}, 
        {Name = 'Comment', Label = 'Comment', Icon = 'fas fa-comment'}
    })
    if OrderInput['Price'] and tonumber(OrderInput['Price']) > 0 then
        TriggerServerEvent('mercy-business/server/foodchain/add-to-register', ClockedData.Business, Data.RegisterId, math.floor(OrderInput['Price']), OrderInput['Comment'])
    end
end)

RegisterNetEvent('mercy-business/client/foodchain/pay-menu', function(Data)
    local Payment = CallbackModule.SendCallback("mercy-business/server/foodchain/get-payment-data", Data.Foodchain, Data.RegisterId)
    if not Payment then
        exports['mercy-ui']:Notify("foodchain-error", "No active orders!", 'error')
        return
    end
    local MenuItems = {
        {
            Title = 'Restaurant Order',
            Desc = "$"..Payment.Costs..'.00 | ' .. Payment.Order, 
            Data = { Event = '', Type = '' }
        },
        {
            Title = '<i class="fas fa-credit-card"></i> Pay with Bank',
            CloseMenu = true,
            Data = {
                Event = 'mercy-business/server/foodchain/pay-register',
                Type = 'Server',
                Foodchain = Data.Foodchain,
                Register = Data.RegisterId,
                PaymentType = 'Bank',
            },
        },
        {
            Title = '<i class="fas fa-money-bill"></i> Pay with Cash',
            CloseMenu = true,
            Data = {
                Event = 'mercy-business/server/foodchain/pay-register',
                Type = 'Server',
                Foodchain = Data.Foodchain,
                Register = Data.RegisterId,
                PaymentType = 'Cash',
            },
        },
    }
    exports['mercy-ui']:OpenContext({ ['MainMenuItems'] = MenuItems })
end)

RegisterNetEvent('mercy-business/client/foodchain/receive-receipt', function(Business, Data)
    if not ClockedData.Clocked then return end
    if ClockedData.Business ~= Business then return end
    EventsModule.TriggerServer('mercy-inventory/server/add-item', 'receipt', 1, false, {Business = Business, Money = Data.Costs, Comment = Data.Order}, true)
end)

RegisterNetEvent('mercy-business/client/foodchain/set-duty', function(Data)
    ClockedData = Data
    if ClockedData.Clocked then
        exports['mercy-ui']:Notify("foodchain-error", "Clocked In!", 'success')
    else
        exports['mercy-ui']:Notify("foodchain-error", "Clocked Out!", 'error')
    end
end)

RegisterNetEvent("mercy-business/client/foodchain/set-duty-data", function(Business, Data)
    Config.ActiveEmployees[Business] = Data   
end)

RegisterNetEvent('mercy-business/client/foodchain/prepare-meal', function(Type)
    local MenuItems = {}
    local FoodType = Config.FoodChainDishes[ClockedData.Business][Type]
    for k, Name in pairs(FoodType) do
        local SharedData = Shared.ItemList[Name]
        local Requirements = ""
        for Key, Cost in pairs(SharedData['Cost']) do
            local IngredientLabel = Shared.ItemList[Cost.Item]['Label']
            Requirements = Requirements .. Cost.Amount .. "x "..IngredientLabel..(SharedData['Cost'][Key + 1] and " | " or "")
        end
        table.insert(MenuItems, {
            ['Title'] = '<img style="width: auto; height: 5vh; float: left; margin-right: 2vh;" src="' .. 'nui://mercy-inventory/nui/img/items/' .. SharedData.Image .. '"></img> ' .. SharedData['Label'],
            ['Desc'] = Requirements,
            ['Disabled'] = not HasAllIngredients(Name),
            ['Data'] = { 
                ['Event'] = 'mercy-business/client/foodchain/create-meal', 
                ['Type'] = 'Client', 
                ['FoodType'] = Type,
                ['Item'] = Name
            },
        })
    end
    exports['mercy-ui']:OpenContext({ ['MainMenuItems'] = MenuItems, })
end)

RegisterNetEvent('mercy-business/client/foodchain/create-meal', function(Data)
    local Item = Data.Item
    if Item == nil then
        exports['mercy-ui']:Notify('foodchain-error', "An error occured! (Try Again!)", 'error')
        return
    end
    
    local HasIngredients = HasAllIngredients(Item)
    if not HasIngredients then
        SkippedMinigames = 0
        exports['mercy-ui']:Notify('foodchain-error', "You don\'t seem to have all the ingredients for this!", 'error')
        return 
    end
    
    if Data.Skip and SkippedMinigames >= 10 then
        SkippedMinigames = 0
        return
    end

    if Data.Skip then
        SkippedMinigames = SkippedMinigames + 1
        CreateMeal(Data)
        return
    end

    local Outcome = exports['mercy-ui']:StartSkillTest(3, { 7, 10 }, { 1000, 1500 }, false)
    if Outcome then
        CreateMeal(Data)
    else
        SkippedMinigames = 0
        exports['mercy-ui']:Notify('foodchain-error', "Failed attempt..", 'error')
    end
    TriggerEvent('mercy-animations/client/clear-animation')
end)

function CreateMeal(Data)
    if Data.FoodType == 'Food' then
        TriggerEvent('mercy-ui/client/play-sound', 'wrapping', 0.3)
        TriggerEvent('mercy-animations/client/play-animation', 'preparing')
    elseif Data.FoodType == 'Drink' then
        TriggerEvent('mercy-animations/client/play-animation', 'preparing')
    elseif Data.FoodType == 'Side' then
        TriggerEvent('mercy-ui/client/play-sound', 'frying', 0.1)
        TriggerEvent('mercy-animations/client/play-animation', 'frying')
    end
    exports['mercy-inventory']:SetBusyState(true)
    exports['mercy-ui']:ProgressBar('Preparing meal..', 6000, {['AnimName'] = 'fullcut_cycle_v6_cokecutter', ['AnimDict'] = 'anim@amb@business@coc@coc_unpack_cut@', ['AnimFlag'] = 16}, false, true, true, function(DidComplete)
        if DidComplete then
            exports['mercy-inventory']:SetBusyState(false)
            StopAnimTask(PlayerPedId(), "anim@amb@business@coc@coc_unpack_cut@", "fullcut_cycle_v6_cokecutter", 1.0)
            EventsModule.TriggerServer('mercy-business/server/foodchain/create-meal', Data.Item)
            Data.Skip = true
            Citizen.SetTimeout(100, function()
                TriggerEvent('mercy-business/client/foodchain/create-meal', Data)
            end)
        else
            exports['mercy-inventory']:SetBusyState(false)
            StopAnimTask(PlayerPedId(), "anim@amb@business@coc@coc_unpack_cut@", "fullcut_cycle_v6_cokecutter", 1.0)
            SkippedMinigames = 0
            Data.Skip = false
        end
    end)
end

-- [ Functions ] --

function HasAllIngredients(ItemName)
    local ItemsChecked = 0
    local ItemCost = Shared.ItemList[ItemName].Cost
    for k, v in pairs(ItemCost) do
        if exports['mercy-inventory']:HasEnoughOfItem(v.Item, v.Amount) then
            ItemsChecked = ItemsChecked + 1
        end
    end
    if ItemsChecked == #ItemCost then
        return true
    else
        return false
    end
end