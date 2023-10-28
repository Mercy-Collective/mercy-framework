CallbackModule, PlayerModule, DatabaseModule, CommandsModule, EventsModule = nil, nil, nil, nil, nil

local _Ready = false
AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Callback',
        'Player',
        'Database',
        'Events',
        'Commands',
    }, function(Succeeded)
        if not Succeeded then return end
        CommandsModule = exports['mercy-base']:FetchModule('Commands')
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        DatabaseModule = exports['mercy-base']:FetchModule('Database')
        _Ready = true
    end)
end)

-- [ Code ] --

Citizen.CreateThread(function() 
    while not _Ready do 
        Citizen.Wait(4) 
    end 
 
    -- [ Events ] --

    EventsModule.RegisterServer('mercy-financials/server/monitor-account', function(Source, AccountData)
        for k, v in pairs(PlayerModule.GetPlayers()) do
            local Player = PlayerModule.GetPlayerBySource(v)
            if Player.PlayerData.Job.Name == 'police' or Player.PlayerData.Job.Name == 'judge' then
                Player.Functions.Notify('account-monitor', '(Monitored Account) - '..AccountData['AccountOwner']..'\'s account has been accessed!', 'error', 10000)
            end
        end
    end)

    -- [ Commands ] --

    CommandsModule.Add("givecash", "Give cash to player", {{Name="id", Help="Player ID"}, {Name="amount", Help="Amount"}}, false, function(Source, args)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local TargetPlayer = PlayerModule.GetPlayerBySource(tonumber(args[1]))
        if TargetPlayer then
            local Amount = tonumber(args[2])
            if Player.Functions.RemoveMoney('Cash', Amount, 'Gave-money') then
                TargetPlayer.Functions.AddMoney('Cash', Amount, 'Got-money')
                Player.Functions.Notify('gave-cash', 'You gave $'..Amount..' cash.', 'success')
                TargetPlayer.Functions.Notify('got-cash', 'You got given $'..Amount..' cash.', 'success')
            end
        else
            Player.Functions.Notify('not-found', 'Player not found..', 'error')
        end
    end)

    -- [ Callbacks ] --
            
    CallbackModule.CreateCallback('mercy-financials/server/get-accounts', function(Source, Cb)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local AccountTable = {}
        DatabaseModule.Execute("SELECT * FROM player_accounts WHERE CitizenId = ?", {
            Player.PlayerData.CitizenId,
        }, function(BankData) 
            if BankData[1] ~= nil then
                -- Add Main Account of player
                for i=1, #BankData do
                    local Account = BankData[i]
                    if Account.Type == 'Standard' then
                        local AccountData = {}
                        AccountData['AccountOwner'] = Player.PlayerData.CharInfo.Firstname..' '..Player.PlayerData.CharInfo.Lastname
                        AccountData['AccountName'] = Account.Name
                        AccountData['AccountId'] = Account.BankId
                        AccountData['Balance'] = Account.Balance
                        AccountData['Type'] = Account.Type
                        AccountData['Transactions'] = json.decode(Account.Transactions)
                        AccountData['Active'] = Account.Active
                        AccountData['Monitoring'] = Account.Monitoring
                        AccountTable[#AccountTable+1] = AccountData
                    end
                end

                DatabaseModule.Execute("SELECT * FROM player_accounts", {}, function(AccountsData) 
                    if AccountsData[1] ~= nil then
                        for k, v in pairs(AccountsData) do
                            if exports['mercy-business']:IsPlayerInBusiness(Player, v.Name) and exports['mercy-business']:HasBusinessPermission(Player, v.Name, 'account_access') then
                                local AccountData = {}
                                AccountData['AccountOwner'] = exports['mercy-business']:GetBusinessOwnerName(v.Name)
                                AccountData['AccountName'] = v.Name
                                AccountData['AccountId'] = v.BankId
                                AccountData['Balance'] = v.Balance
                                AccountData['Type'] = v.Type
                                AccountData['Transactions'] = json.decode(v.Transactions)
                                AccountData['Active'] = v.Active
                                AccountData['Monitoring'] = v.Monitoring
                                AccountTable[#AccountTable+1] = AccountData
                            end
                        end
                    end
                end, true)

                Cb(AccountTable)
            else
                DebugPrint('Info', 'No accounts found for player, creating main account.')
                -- Add main account to DB
                DatabaseModule.Insert("INSERT INTO player_accounts (CitizenId, Type, Name, BankId, Balance, Authorized, Transactions, Active) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", {
                    Player.PlayerData.CitizenId,
                    'Standard',
                    'Main Account',
                    Player.PlayerData.CharInfo.BankNumber,
                    Player.PlayerData.Money['Bank'],
                    json.encode({}),
                    json.encode({}),
                    true
                }, function(Result)
                    DatabaseModule.Execute("SELECT * FROM player_accounts WHERE CitizenId = ? AND Type = ?", {
                        Player.PlayerData.CitizenId,
                        'Standard'
                    }, function(BankData) 
                        if BankData[1] ~= nil then
                            for k, v in pairs(BankData) do
                                local AccountData = {}
                                AccountData['AccountOwner'] = Player.PlayerData.CharInfo.Firstname..' '..Player.PlayerData.CharInfo.Lastname
                                AccountData['AccountName'] = v.Name
                                AccountData['AccountId'] = v.BankId
                                AccountData['Balance'] = v.Balance
                                AccountData['Type'] = 'Standard'
                                AccountData['Transactions'] = json.decode(v.Transactions)
                                AccountData['Active'] = v.Active
                                AccountData['Monitoring'] = v.Monitoring
                                AccountTable[#AccountTable+1] = AccountData
                            end
                            Cb(AccountTable)
                        else
                            Cb({})
                        end
                    end)
                end)
            end
        end, true)  
    end)

    CallbackModule.CreateCallback('mercy-financials/server/get-current-balance', function(Source, Cb, AccountId)
        local Player = PlayerModule.GetPlayerBySource(Source)
        Cb(GetCurrentAccountBalance(AccountId, Player))
    end)

    CallbackModule.CreateCallback('mercy-financials/server/withdraw-money', function(Source, Cb, Data)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local CurrentBalance = GetCurrentAccountBalance(Data['AccountId'])
        if CurrentBalance >= tonumber(Data['Amount']) then
            local NewBalance = (CurrentBalance - tonumber(Data['Amount']))
            Player.Functions.AddMoney('Cash', tonumber(Data['Amount']), Data['Reason'])
            if tonumber(Player.PlayerData.CharInfo['BankNumber']) == tonumber(Data['AccountId']) then -- Update Main Account
                Player.Functions.RemoveMoney('Bank', tonumber(Data['Amount']))
            end
            DatabaseModule.Update("UPDATE player_accounts SET Balance = ? WHERE BankId = ?", {
                NewBalance,
                Data['AccountId']
            })
            AddTransactionCard({['Title'] = 'Money withdrawal', ['Who'] = Player.PlayerData.CharInfo.Firstname..' '..Player.PlayerData.CharInfo.Lastname, ['Id'] = Data['AccountId'], ['Amount'] = Data['Amount'], ['Reason'] = Data['Reason'], ['Type'] = 'Withdraw'})
            Cb(true)
        else
            Cb(false)
        end
    end)

    CallbackModule.CreateCallback('mercy-financials/server/deposit-money', function(Source, Cb, Data)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local CurrentBalance = GetCurrentAccountBalance(Data['AccountId'])
        if Player.Functions.RemoveMoney('Cash', tonumber(Data['Amount']), Data['Reason']) then
            local NewBalance = (CurrentBalance + tonumber(Data['Amount']))
            if tonumber(Player.PlayerData.CharInfo['BankNumber']) == tonumber(Data['AccountId']) then -- Update Main Account
                Player.Functions.AddMoney('Bank', tonumber(Data['Amount']))
            end
            DatabaseModule.Update("UPDATE player_accounts SET Balance = ? WHERE BankId = ?", {
                NewBalance,
                Data['AccountId']
            })
            AddTransactionCard({['Title'] = 'Money deposit', ['Who'] = Player.PlayerData.CharInfo.Firstname..' '..Player.PlayerData.CharInfo.Lastname, ['Id'] = Data['AccountId'], ['Amount'] = Data['Amount'], ['Reason'] = Data['Reason'], ['Type'] = 'Deposit'})
            Cb(true)
        else
            Cb(false)
        end
    end)

    CallbackModule.CreateCallback('mercy-financials/server/transfer-money', function(Source, Cb, Data)
        local Player = PlayerModule.GetPlayerBySource(Source)
        DatabaseModule.Execute("SELECT * FROM players WHERE CharInfo LIKE ?", {
            "%"..Data['ToAccountId'].."%"
        }, function(PlayerResult)
            -- Remove Money Sender
            local CurrentBalance = GetCurrentAccountBalance(tonumber(Data['AccountId']))
            if CurrentBalance < tonumber(Data['Amount']) then return Cb(false) end
            if tonumber(Data['AccountId']) == tonumber(Player.PlayerData.CharInfo['BankNumber']) then -- Sender's main account
                DebugPrint('Transfer', 'Removing Sender\'s money from MAIN account')
                Player.Functions.RemoveMoney('Bank', tonumber(Data['Amount']), Data['Reason'])
            else -- Sender's other account
                DebugPrint('Transfer', 'Removing Sender\'s money from OTHER account')
                DatabaseModule.Update("UPDATE player_accounts SET Balance = ? WHERE BankId = ?", {
                    (CurrentBalance - tonumber(Data['Amount'])),
                    tonumber(Data['AccountId'])
                })
            end
            Citizen.Wait(250)
            if PlayerResult[1] ~= nil then -- Target's Main Account
                local TargetPlayer = PlayerModule.GetPlayerByStateId(tonumber(PlayerResult[1]['CitizenId']))
                if TargetPlayer then -- Target is online
                    DebugPrint('Transfer', 'Target is online, adding money to MAIN account')
                    -- Update Target Money
                    TargetPlayer.Functions.AddMoney('Bank', tonumber(Data['Amount']), Data['Reason'])
                    -- Create Transactions
                    AddTransactionCard({['Title'] = 'Money sent', ['Who'] = Player.PlayerData.CharInfo.Firstname..' '..Player.PlayerData.CharInfo.Lastname, ['Id'] = Data['AccountId'], ['Amount'] = Data['Amount'], ['Reason'] = Data['Reason'], ['Type'] = 'Transfer'})
                    SetTimeout(250, function()
                        AddTransactionCard({['Title'] = 'Money received', ['Who'] = TargetPlayer.PlayerData.CharInfo.Firstname..' '..TargetPlayer.PlayerData.CharInfo.Lastname, ['Id'] = Data['ToAccountId'], ['Amount'] = Data['Amount'], ['Reason'] = Data['Reason'], ['Type'] = 'Transfer Received'})
                        Cb(true)
                    end)
                else -- Target is offline
                    DebugPrint('Transfer', 'Target is offline, adding money to MAIN account')
                    -- Update Target Money
                    local TargetStateId = PlayerResult[1].CitizenId
                    local TargetMoney = json.decode(PlayerResult[1].Money)
                    TargetMoney['Bank'] = (tonumber(TargetMoney['Bank']) + tonumber(Data['Amount']))
                    DatabaseModule.Update("UPDATE players SET Money = ? WHERE CitizenId = ?", {
                        json.encode(TargetMoney),
                        TargetStateId
                    })
                    -- Create Transactions
                    local TargetCharInfo = json.decode(PlayerResult[1].CharInfo)
                    AddTransactionCard({['Title'] = 'Money sent', ['Who'] = Player.PlayerData.CharInfo.Firstname..' '..Player.PlayerData.CharInfo.Lastname, ['Id'] = Data['AccountId'], ['Amount'] = Data['Amount'], ['Reason'] = Data['Reason'], ['Type'] = 'Transfer'})
                    SetTimeout(250, function()
                        AddTransactionCard({['Title'] = 'Money received', ['Who'] = TargetCharInfo.Firstname..' '..TargetCharInfo.Lastname, ['Id'] = Data['ToAccountId'], ['Amount'] = Data['Amount'], ['Reason'] = Data['Reason'], ['Type'] = 'Transfer Received'})
                        Cb(true)
                    end)
                end
            else -- Target's Other Account
                DebugPrint('Transfer', 'Adding Target\'s money to OTHER account')
                local AccountOwner = GetOwnerOfAccount(Data['ToAccountId'])
                if not AccountOwner then return Cb(false) end
                -- Update Target Money
                local TargetPlayer = PlayerModule.GetPlayerByStateId(tonumber(AccountOwner))
                local TargetCurrentBalance = GetCurrentAccountBalance(Data['ToAccountId'])
                DatabaseModule.Update("UPDATE player_accounts SET Balance = ? WHERE BankId = ?", {
                    (TargetCurrentBalance + tonumber(Data['Amount'])),
                    Data['ToAccountId']
                })
                -- Create Transactions
                if TargetPlayer then -- Target is online
                    AddTransactionCard({['Title'] = 'Money sent', ['Who'] = Player.PlayerData.CharInfo.Firstname..' '..Player.PlayerData.CharInfo.Lastname, ['Id'] = Data['AccountId'], ['Amount'] = Data['Amount'], ['Reason'] = Data['Reason'], ['Type'] = 'Transfer'})
                    AddTransactionCard({['Title'] = 'Money received', ['Who'] = TargetPlayer.PlayerData.CharInfo.Firstname..' '..TargetPlayer.PlayerData.CharInfo.Lastname, ['Id'] = Data['ToAccountId'], ['Amount'] = Data['Amount'], ['Reason'] = Data['Reason'], ['Type'] = 'Transfer Received'})
                    Cb(true)
                else -- Target is offline
                    -- Get charinfo using citizenid using database
                    DatabaseModule.Execute("SELECT * FROM players WHERE CitizenId = ?", {
                        AccountOwner
                    }, function(TargetResult)
                        if TargetResult[1] ~= nil then
                            local TargetCharInfo = json.decode(TargetResult[1].CharInfo)
                            AddTransactionCard({['Title'] = 'Money sent', ['Who'] = Player.PlayerData.CharInfo.Firstname..' '..Player.PlayerData.CharInfo.Lastname, ['Id'] = Data['AccountId'], ['Amount'] = Data['Amount'], ['Reason'] = Data['Reason'], ['Type'] = 'Transfer'})
                            AddTransactionCard({['Title'] = 'Money received', ['Who'] = TargetCharInfo.Firstname..' '..TargetCharInfo.Lastname, ['Id'] = Data['ToAccountId'], ['Amount'] = Data['Amount'], ['Reason'] = Data['Reason'], ['Type'] = 'Transfer Received'})
                            Cb(true)
                        else
                            Cb(false)
                        end
                    end)
                end
            end
        end)
    end)
end)

-- [ Events ] --

RegisterNetEvent('mercy-financials/server/sync-main-bank', function(Source, BankAmount)
    local Player = PlayerModule.GetPlayerBySource(Source)
    if not Player then 
        return DebugPrint('SyncError', 'Player not found, can\'t sync main bank balance..')
    end
    
    DatabaseModule.Execute("SELECT * FROM player_accounts WHERE CitizenId = ? AND BankId = ?", {
        Player.PlayerData.CitizenId,
        Player.PlayerData.CharInfo['BankNumber']
    }, function(BankData) 
        if BankData[1] == nil then -- Main Account does not exist yet
            DebugPrint('Info', 'Main account did not exist when syncing main bank, creating...')
            DatabaseModule.Insert("INSERT INTO player_accounts (CitizenId, Type, Name, BankId, Balance, Authorized, Transactions, Active) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", {
                Player.PlayerData.CitizenId,
                'Standard',
                'Main Account',
                Player.PlayerData.CharInfo.BankNumber,
                tonumber(BankAmount),
                json.encode({}),
                json.encode({}),
                true
            }, function(Result)

            end)
        else
            DebugPrint('Info', 'Main account exists for update, updating...')
            DatabaseModule.Update("UPDATE player_accounts SET Balance = ? WHERE BankId = ?", {
                tonumber(BankAmount),
                Player.PlayerData.CharInfo['BankNumber']
            })
        end
    end)

end)

-- [ Functions ] --

function GetOwnerOfAccount(AccountId)
    local ReturnData = nil
    DatabaseModule.Execute("SELECT * FROM player_accounts WHERE BankId = ?", {
        AccountId
    }, function(BankResult)
        if BankResult[1] ~= nil then
            ReturnData = BankResult[1].CitizenId
        end
    end, true)
    return ReturnData
end

function GetCurrentAccountBalance(BankNumber, Player)
    local ReturnData = 0
    DatabaseModule.Execute("SELECT * FROM player_accounts WHERE BankId = ?", {
        BankNumber
    }, function(BankResult)
        if BankResult[1] ~= nil then
            ReturnData = tonumber(BankResult[1].Balance)
        else
            if Player ~= nil and Player.PlayerData.CharInfo['BankNumber'] == BankNumber then
                ReturnData = tonumber(Player.PlayerData.Money['Bank'])
            end
        end
    end, true)
    return ReturnData
end

function AddTransactionCard(Data)
    DatabaseModule.Execute("SELECT * FROM player_accounts WHERE BankId = ?", {
        Data['Id']
    }, function(BankResult)
        if BankResult[1] ~= nil then -- Account Exists
            local AddTransaction = {['Title'] = Data['Title'], ['Id'] = Data['Id'], ['Who'] = Data['Who'], ['Amount'] = Data['Amount'], ['Type'] = Data['Type'], ['Reason'] = Data['Reason'], ['Time'] = os.date('%H:'..'%M'), ['Date'] = os.date('%d-'..'%m-'..'%y')}
            local CurrentTransactions = json.decode(BankResult[1].Transactions)
            if CurrentTransactions ~= nil then
                CurrentTransactions[#CurrentTransactions+1] = AddTransaction
                DatabaseModule.Update("UPDATE player_accounts SET Transactions = ? WHERE BankId = ?", {
                    json.encode(CurrentTransactions),
                    Data['Id']
                })
            else
                local NewTransactionTable = {}
                NewTransactionTable[#NewTransactionTable+1] = AddTransaction
                DatabaseModule.Update("UPDATE player_accounts SET Transactions = ? WHERE BankId = ?", {
                    json.encode(NewTransactionTable),
                    Data['Id']
                })
            end
        end
    end)
end
exports('AddTransactionCard', AddTransactionCard)

function GetUniqueAccountId()
    local BankId = math.random(1111111111, 9999999999)
    DatabaseModule.Execute("SELECT * FROM player_accounts WHERE BankId = ?", {Id}, function(Result)
        while (Result[1] ~= nil) do
            BankId = math.random(1111111111, 9999999999)
            Wait(1)
        end
        return BankId
    end)
    return BankId
end
exports('GetUniqueAccountId', GetUniqueAccountId)

function DebugPrint(Type, Message, ...)
    if not Config.Debug then return end
    if ... ~= nil then
        print(('^4[^5Debug^4:^5Financials^4:^5%s^4]:^7 %s %s'):format(Type, Message, ...))
    else
        print(('^4[^5Debug^4:^5Financials^4:^5%s^4]:^7 %s'):format(Type, Message))
    end
end