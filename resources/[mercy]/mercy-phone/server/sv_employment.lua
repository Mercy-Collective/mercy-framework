-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(4)
    end

    CallbackModule.CreateCallback('mercy-phone/server/get-businesses-by-citizenid', function(Source, Cb)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local Businesses = {}
        DatabaseModule.Execute("SELECT * FROM player_business", {}, function(BusinessData)
            if BusinessData ~= nil then
                for BusinessId, BusinessData in pairs(BusinessData) do
                    local Employees = json.decode(BusinessData.employees)
                    if Employees ~= nil then
                        for EmployeeId, EmployeeData in pairs(Employees) do
                            if Player.PlayerData.CitizenId == EmployeeData.CitizenId then
                                table.insert(Businesses, BusinessData)
                            end
                        end
                    end
                end
            end
        end, true)
        Cb(Businesses)
    end)

    CallbackModule.CreateCallback('mercy-phone/server/get-specific-business', function(Source, Cb, Name)
        local Player = PlayerModule.GetPlayerBySource(Source)
        DatabaseModule.Execute('SELECT * FROM player_business WHERE name = ?', {Name}, function(BusinessData)
            if BusinessData[1] ~= nil then
                Cb(BusinessData[1])
            else
                Cb(false)
            end
        end)
    end)
    
    CallbackModule.CreateCallback('mercy-phone/server/employment/request-customer-charge', function(Source, Cb, Data)
        local TargetPlayer = PlayerModule.GetPlayerByStateId(Data['StateId'])
        if not TargetPlayer then return end
        TriggerClientEvent('mercy-phone/client/notification', TargetPlayer.PlayerData.Source, {
            Id = TargetPlayer.PlayerData.Source,
            Title = "Pay Request - " .. Data['BusinessName'],
            Message = "$" .. Data['Amount'].. ' | '..Data['Comment'],
            Icon = "fas fa-briefcase",
            IconBgColor = "#e0891d",
            IconColor = "white",
            Sticky = true,
            Duration = 30000,
            Buttons = {
                {
                    Icon = "fas fa-times-circle",
                    Event = "mercy-phone/client/employment/pay-charge-customer",
                    EventType = "Client",
                    EventData = {
                        ['Accepted'] = false,
                        ['TargetSource'] = TargetPlayer.PlayerData.Source,
                    },
                    Tooltip = "Decline",
                    Color = "#f2a365",
                    CloseOnClick = true,
                },
                {
                    Icon = "fas fa-check-circle",
                    Event = "mercy-phone/client/employment/pay-charge-customer",
                    EventType = "Client",
                    EventData = {
                        ['Accepted'] = true,
                        ['SenderSource'] = Source,
                        ['TargetSource'] = TargetPlayer.PlayerData.Source,
                        ['Data'] = Data,
                    },
                    Tooltip = "Pay",
                    Color = "#2ecc71",
                    CloseOnClick = true,
                },
            },
        })
    end)

    CallbackModule.CreateCallback('mercy-phone/server/employment/pay-external', function(Source, Cb, Data)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local TPlayer = PlayerModule.GetPlayerByStateId(tonumber(Data.Result['state_id']))
        local CompanyBankId = nil
        local TargetName, TargetBankId = nil, nil
        DatabaseModule.Execute("SELECT * FROM player_accounts WHERE name = ?", {
            Data['BusinessName']
        }, function(Result)
            if Result[1] == nil then return false end
            CompanyBankId = Result[1].BankId
        end, true)

        Data.Result['amount'] = tonumber(Data.Result['amount'])
        if Data.Result['amount'] == nil or Data.Result['amount'] == '' or Data.Result['amount'] <= 0 then
            Cb({
                Success = false,
                FailMessage = 'Amount is required and can\'t be 0 or lower',
            })
            return
        end
        
        print('[DEBUG:PayExternal]: Paying employee', CompanyBankId)
        if CompanyBankId then
            if TPlayer then -- Online
                TargetName = TPlayer.PlayerData.CharInfo.Firstname..' '..TPlayer.PlayerData.CharInfo.Lastname
                TargetBankId = TPlayer.PlayerData.CharInfo['BankNumber']
                print('[DEBUG:PayExternal]: REMOVING Money from business account. ONLINE')
                -- Remove
                if exports['mercy-business']:RemoveMoneyFromBusinessAccount(Data['BusinessName'], Data.Result['amount']) then
                    print('[DEBUG:PayExternal]: REMOVED Money from business account. ONLINE')
                    -- Add
                    TPlayer.Functions.AddMoney('Bank', tonumber(Data.Result['amount']), 'Employee-payment-Received')
                    print('[DEBUG:PayExternal]: Added Money to target account. ONLINE')
                    -- Logs
                    exports['mercy-financials']:AddTransactionCard({['Title'] = 'Employee Payment sent', ['Who'] = Player.PlayerData.CharInfo.Firstname..' '..Player.PlayerData.CharInfo.Lastname, ['Id'] = CompanyBankId, ['Amount'] = Data.Result['amount'], ['Reason'] = Data.Result['comment'], ['Type'] = 'Transfer'})
                    exports['mercy-financials']:AddTransactionCard({['Title'] = 'Employee Payment received', ['Who'] = TargetName, ['Id'] = TargetBankId, ['Amount'] = Data.Result['amount'], ['Reason'] = Data.Result['comment'], ['Type'] = 'Transfer Received'})
                    Cb({
                        Success = true
                    })
                else
                    Cb({
                        Success = false,
                        FailMessage = 'Could not remove money from business account...',
                    })
                end
            else -- Offline
                DatabaseModule.Execute("SELECT * FROM players WHERE CitizenId = ?", {
                    Data.Result['state_id']
                }, function(PlayerResult)
                    if PlayerResult[1] ~= nil then
                        local CharInfo = json.decode(PlayerResult[1].CharInfo)
                        TargetName = CharInfo.Firstname..' '..CharInfo.Lastname
                        TargetBankId = CharInfo['BankNumber']
                        print('[DEBUG:PayExternal]: REMOVING Money from business account. OFFLINE')
                        -- Remove
                        if exports['mercy-business']:RemoveMoneyFromBusinessAccount(Data['BusinessName'], Data.Result['amount']) then
                            print('[DEBUG:PayExternal]: REMOVED Money from business account. OFFLINE')
                            -- Add
                            local TargetMoney = json.decode(PlayerResult[1].Money)
                            TargetMoney['Bank'] = (TargetMoney['Bank'] + Data.Result['amount'])
                            DatabaseModule.Update("UPDATE players SET Money = ? WHERE CitizenId = ?", {
                                json.encode(TargetMoney),
                                Data.Result['state_id']
                            })
                            print('[DEBUG:PayExternal]: Added Money to target account. OFFLINE')
                            -- Logs
                            exports['mercy-financials']:AddTransactionCard({['Title'] = 'Employee Payment sent', ['Who'] = Player.PlayerData.CharInfo.Firstname..' '..Player.PlayerData.CharInfo.Lastname, ['Id'] = CompanyBankId, ['Amount'] = Data.Result['amount'], ['Reason'] = Data.Result['comment'], ['Type'] = 'Transfer'})
                            exports['mercy-financials']:AddTransactionCard({['Title'] = 'Employee Payment received', ['Who'] = TargetName, ['Id'] = TargetBankId, ['Amount'] = Data.Result['amount'], ['Reason'] = Data.Result['comment'], ['Type'] = 'Transfer Received'})                
                            Cb({
                                Success = true
                            })
                        else
                            Cb({
                                Success = false,
                                FailMessage = 'Could not remove money from business account...',
                            })
                        end
                    end
                end)
            end
        else
            Cb({
                Success = false,
                FailMessage = 'The business account could not be loaded',
            })
        end
    end)
end)

-- [ Events ] --

RegisterNetEvent("mercy-phone/server/employment/pay-charge-customer", function(Data)
    local TargetPlayer = PlayerModule.GetPlayerBySource(Data['TargetSource'])
    if not TargetPlayer then return end
    TriggerClientEvent('mercy-phone/client/hide-notification', TargetPlayer.PlayerData.Source, TargetPlayer.PlayerData.Source)
    Wait(300)
    if Data['Accepted'] then
        if TargetPlayer.Functions.RemoveMoney('Bank', Data['Data']['Amount'], 'paid-employment-charge-bank') then
            if exports['mercy-business']:AddMoneyToBusinessAccount(Data['Data']['BusinessName'], Data['Data']['Amount']) then
                TriggerClientEvent('mercy-phone/client/notification', Data['SenderSource'], {
                    Id = Data['SenderSource'],
                    Title = "Pay Request - Processed",
                    Message = "Money has been added to business account.",
                    Icon = "fas fa-briefcase",
                    IconBgColor = "#e0891d",
                    IconColor = "white",
                    Sticky = false,
                    Duration = 3000,
                    Buttons = {},
                })
                TriggerClientEvent('mercy-phone/client/notification', TargetPlayer.PlayerData.Source, {
                    Id = TargetPlayer.PlayerData.Source,
                    Title = "Pay Request - Processed",
                    Message = "Money has been removed from bank.",
                    Icon = "fas fa-briefcase",
                    IconBgColor = "#e0891d",
                    IconColor = "white",
                    Sticky = false,
                    Duration = 3000,
                    Buttons = {},
                })
            else
                print('[DEBUG:Business]: Failed to add money to business account ['..Data['Data']['BusinessName']..']')
            end
        else
            TriggerClientEvent('mercy-phone/client/notification', Data['SenderSource'], {
                Id = Data['SenderSource'],
                Title = "Pay Request - Failed",
                Message = "Person does not have enough money.",
                Icon = "fas fa-briefcase",
                IconBgColor = "#e0891d",
                IconColor = "white",
                Sticky = false,
                Duration = 3000,
                Buttons = {},
            })
            TriggerClientEvent('mercy-phone/client/notification', TargetPlayer.PlayerData.Source, {
                Id = TargetPlayer.PlayerData.Source,
                Title = "Pay Request - Failed",
                Message = "You do not have enough money.",
                Icon = "fas fa-briefcase",
                IconBgColor = "#e0891d",
                IconColor = "white",
                Sticky = false,
                Duration = 3000,
                Buttons = {},
            })
        end
    else
        TriggerClientEvent('mercy-phone/client/hide-notification', TargetPlayer.PlayerData.Source, TargetPlayer.PlayerData.Source)
    end
end)
