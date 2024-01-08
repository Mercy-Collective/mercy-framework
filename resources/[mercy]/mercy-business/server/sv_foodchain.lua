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

    EventsModule.RegisterServer("mercy-business/server/give-reward", function(Source, RequestItem, business, price)
        local Player = PlayerModule.GetPlayerBySource(Source)
        Player.Functions.AddMoney('Cash', price)
        exports['mercy-business']:AddMoneyToBusinessAccount(business, price)
        if RequestItem then
            for k, v in ipairs(RequestItem) do
                Player.Functions.RemoveItem(v.Name, v.Amount, false, true)
            end
        end
    end)

    CallbackModule.CreateCallback('mercy-business/server/foodchain/get-payment-data', function(Source, Cb, Business, RegisterId)
        local Register = Config.ActivePayments[Business]
        if Register == nil then return Cb(false) end
        if Register[RegisterId] == nil then return Cb(false) end
        Cb(Register[RegisterId])
    end)

    CallbackModule.CreateCallback('mercy-business/server/get-clocked-in-employees', function(Source, Cb, Business)
        Cb(Config.ActiveEmployees[Business])
    end)
end)

-- [ Events ] --

RegisterNetEvent('mercy-business/server/foodchain/set-duty', function(Data)
    local src = source
    if Data.Clocked then
        table.insert(Config.ActiveEmployees[Data.Business], {
            Source = src,
            Name = GetPlayerName(src),
            Business = Data.Business,
            Clocked = Data.Clocked,
        })
        TriggerClientEvent('mercy-business/client/foodchain/set-duty-data', -1, Data.Business, Config.ActiveEmployees[Data.Business])	
    else
        local ClockedData = GetClockedData(src)
        if  ClockedData then 
            if Config.ActiveEmployees[ClockedData.Business] ~= nil then 
                for EmployeeId, Employee in pairs(Config.ActiveEmployees[ClockedData.Business]) do
                    if Employee.Source == src then
                        table.remove(Config.ActiveEmployees[ClockedData.Business], EmployeeId)
                    end
                end
                TriggerClientEvent('mercy-business/client/foodchain/set-duty-data', -1, Data.Business, Config.ActiveEmployees[ClockedData.Business])	
            end
        else
            print('[DEBUG:FoodChain]: Something went wrong while trying to clock out..')
        end
    end
    TriggerClientEvent('mercy-business/client/foodchain/set-duty', src, Data)
end)


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

function GetClockedData(src)
    local Player = PlayerModule.GetPlayerBySource(src)
    for _, Business in pairs(Config.ActiveEmployees) do
        for k, BusinessData in pairs(Business) do
            if BusinessData.Source == src then
                return BusinessData
            end
        end
    end
    return false
end
