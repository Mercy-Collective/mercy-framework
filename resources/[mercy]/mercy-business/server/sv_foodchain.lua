-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(450)
    end

    EventsModule.RegisterServer('mercy-business/server/foodchain/create-meal', function(Source, ItemName)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local ItemCost = Shared.ItemList[ItemName].Cost
        local MissingItem = false
        for _, Data in pairs(ItemCost) do
            Player.Functions.RemoveItem(Data.Item, Data.Amount)
        end
        Player.Functions.AddItem(ItemName, 1, false, false, true)
    end)

    CallbackModule.CreateCallback('mercy-business/server/foodchain/get-payment-data', function(Source, Cb, Business, RegisterId)
        local Register = Config.ActivePayments[Business]
        if Register == nil then Cb(false) end
        if Register[RegisterId] == nil then Cb(false) end
        Cb(Register[RegisterId])
    end)
end)

-- [ Events ] --

RegisterNetEvent("mercy-business/server/foodchain/add-to-register", function(Business, RegisterId, Cost, Order)
    local src = source
    Config.ActivePayments[Business][RegisterId] = {Creator = src, Costs = Cost, Order = Order}
end)

RegisterNetEvent("mercy-business/server/foodchain/pay-register", function(Data)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    local Payment = Config.ActivePayments[Data['Foodchain']][Data['Register']]
    if Payment ~= nil then
        if Data.PaymentType == 'Bank' then
            if Player.Functions.RemoveMoney('Bank', Payment.Costs, 'FoodChain-Order-Bank') then
                TriggerClientEvent('mercy-business/client/foodchain/receive-receipt', Payment.Creator, Data['Foodchain'], Payment)
                Config.ActivePayments[Data['Foodchain']][Data['Register']] = nil
            else
                Player.Functions.Notify('foodchain-bank-money', 'Not enough money..', 'error')
            end
        elseif Data.PaymentType == 'Cash' then
            if Player.Functions.RemoveMoney('Cash', Payment.Costs, 'FoodChain-Order-Cash') then
                TriggerClientEvent('mercy-business/client/foodchain/receive-receipt', Payment.Creator, Data['Foodchain'], Payment)
                Config.ActivePayments[Data['Foodchain']][Data['Register']] = nil
            else
                Player.Functions.Notify('foodchain-cash-money', 'Not enough money..', 'error')
            end
        end
    else
        Player.Functions.Notify('error-paid', 'Order already paid for..', 'error')
    end
end)
