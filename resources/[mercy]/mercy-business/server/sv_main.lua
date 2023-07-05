CallbackModule, PlayerModule, DatabaseModule, FunctionsModule, CommandsModule, EventsModule = nil, nil, nil, nil, nil, nil

_Ready = false
AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Callback',
        'Player',
        'Database',
        'Functions',
        'Commands',
        'Events',
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        DatabaseModule = exports['mercy-base']:FetchModule('Database')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
        CommandsModule = exports['mercy-base']:FetchModule('Commands')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        _Ready = true
    end)
end)

-- [ Code ] --

RegisterNetEvent("mercy-business/server/create-badge", function(Data, Type)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    if not Player then return end
    Player.Functions.AddItem(Type..'badge', 1, false, {
        Name = Data['Name'],
        Image = Data['Image'],
    }, true)
end)

Citizen.CreateThread(function() 
    while not _Ready do 
        Citizen.Wait(500) 
    end 

    -- [ Callbacks ] --

    -- General

    CallbackModule.CreateCallback('mercy-business/server/get-specific-business', function(Source, Cb, Name)
        local BusinessData = {}
        DatabaseModule.Execute("SELECT * FROM player_business WHERE Name = ?", {
            Name
        }, function(BusinessResult)
            if BusinessResult[1] ~= nil then
                BusinessData = {
                    Owner = BusinessResult[1].owner,
                    Employees = json.decode(BusinessResult[1].employees),
                    Ranks = json.decode(BusinessResult[1].ranks),
                }
                Cb(BusinessData)
            else
                Cb(false)
            end
        end)
    end)
    
    -- Employment Actions

    EventsModule.RegisterServer('mercy-business/server/create-business', function(Source, BusinessName, StateId, Logo) 
        local TPlayer = PlayerModule.GetPlayerByStateId(StateId)
        if not TPlayer then 
            TriggerClientEvent('mercy-ui/client/notify', Source, "not-found", "Target not found..", 'error')
            return
        end
        DatabaseModule.Execute("SELECT * FROM player_business WHERE name = ?", {
            BusinessName
        }, function(BusinessResult)
            if BusinessResult[1] == nil then
                local Employees = {}
                Employees[#Employees+1] = {
                    ['CitizenId'] = StateId,
                    ['Rank'] = 'Owner',
                    ['Name'] = TPlayer.PlayerData.CharInfo.Firstname..' '..TPlayer.PlayerData.CharInfo.Lastname,
                }
                DatabaseModule.Insert("INSERT INTO player_business (name, owner, employees, ranks, logo) VALUES (?, ?, ?, ?, ?)", {
                    BusinessName,
                    StateId,
                    json.encode(Employees),
                    json.encode(Config.DefaultRanks),
                    Logo
                })
                TriggerClientEvent('mercy-ui/client/notify', Source, "gave-business", "Successfully created a business. ("..BusinessName..")", 'success')
                DatabaseModule.Execute("SELECT * FROM player_accounts WHERE name = ?", {
                    BusinessName
                }, function(AccountResult)
                    if AccountResult[1] == nil then
                        DatabaseModule.Insert("INSERT INTO player_accounts (CitizenId, Type, Name, BankId, Balance) VALUES (?, ?, ?, ?, ?)", {
                            StateId,
                            'Business',
                            BusinessName,
                            exports['mercy-financials']:GetUniqueAccountId(),
                            0
                        })
                        TriggerClientEvent('mercy-ui/client/notify', Source, "gave-business-acc", "Successfully created a business account. ("..BusinessName..")", 'success')
                    else
                        TriggerClientEvent('mercy-ui/client/notify', Source, "already-exists-account", "An bank account with this business name already exists..", 'error')
                    end
                end)
                TriggerClientEvent('mercy-ui/client/notify', TPlayer.PlayerData.Source, "received-business", "You are now the CEO of "..BusinessName, 'success')
            else
                TriggerClientEvent('mercy-ui/client/notify', Source, "already-exists-busi", "A business with this name already exists..", 'error')
            end
        end)
    end)

    -- Phone Employment

    CallbackModule.CreateCallback('mercy-business/server/create-rank', function(Source, Cb, Data) 
        -- BusinessName, Data['name'], Data
        DatabaseModule.Execute("SELECT * FROM player_business WHERE name = ?", {
            Data['BusinessName']
        }, function(BusinessResult)
            if BusinessResult[1] ~= nil then
                local Business = BusinessResult[1]
                local RanksList = json.decode(Business.ranks)
                if RanksList[Data.Result['name']] ~= nil then return Cb(false) end
                RanksList[Data.Result['name']] = {
                    Name = Data.Result['name'],
                    Default = false,
                    Permissions = {
                        ['hire'] = Data.Result['hire'],
                        ['fire'] = Data.Result['fire'],
                        ['change_role'] = Data.Result['change_role'],
                        ['pay_employee'] = Data.Result['pay_employee'],
                        ['pay_external'] = Data.Result['pay_external'],
                        ['charge_external'] = Data.Result['charge_external'],
                        ['property_keys'] = Data.Result['property_keys'],
                        ['stash_access'] = Data.Result['stash_access'],
                        ['craft_access'] = Data.Result['craft_access'],
                    }
                }
                DatabaseModule.Update("UPDATE player_business SET ranks = ? WHERE name = ?", {
                    json.encode(RanksList),
                    Data['BusinessName']
                })
                Cb(true)
            else
                Cb(false)
            end
        end)
    end)

    CallbackModule.CreateCallback('mercy-business/server/edit-rank', function(Source, Cb, Data) 
        DatabaseModule.Execute("SELECT * FROM player_business WHERE name = ?", {
            Data['BusinessName']
        }, function(BusinessResult)
            if BusinessResult[1] ~= nil then
                local Business = BusinessResult[1]
                local Ranks = json.decode(Business.ranks)
                for k, v in pairs(Ranks) do
                    if v.Name == Data.Result['name'] then
                        Ranks[k].Permissions = Data.Result
                    end
                end
                DatabaseModule.Update("UPDATE player_business SET ranks = ? WHERE name = ?", {
                    json.encode(Ranks),
                    Data['BusinessName']
                })
                Cb(true)
            else
                Cb(false)
            end
        end)
    end)

    CallbackModule.CreateCallback('mercy-business/server/remove-rank', function(Source, Cb, Data) 
        DatabaseModule.Execute("SELECT * FROM player_business WHERE name = ?", {
            Data['BusinessName']
        }, function(BusinessResult)
            if BusinessResult[1] ~= nil then
                local Business = BusinessResult[1]
                local Ranks = json.decode(Business.ranks)
                for k, v in pairs(Ranks) do
                    if v.Name == Data.Result['name'] then
                        Ranks[k] = nil
                    end
                end
                DatabaseModule.Update("UPDATE player_business SET ranks = ? WHERE name = ?", {
                    json.encode(Ranks),
                    Data['BusinessName']
                })
                Cb(true)
            else
                Cb(false)
            end
        end)
    end)

    CallbackModule.CreateCallback('mercy-business/server/add-employee', function(Source, Cb, Data) 
        -- Data.Result['state_id'], Data['BusinessName'], Data.Result['rank']
        DatabaseModule.Execute("SELECT * FROM player_business WHERE name = ?", {
            Data['BusinessName']
        }, function(BusinessResult)
            if BusinessResult[1] ~= nil then
                local Business = BusinessResult[1]
                local TPlayer = PlayerModule.GetPlayerByStateId(tonumber(Data.Result['state_id']))
                if not TPlayer then return Cb({ Success = false, Fail = 'Target player not found..', }) end
                local Employees = json.decode(Business.employees)

                -- Check if already works
                for k, v in pairs(Employees) do
                    if v['CitizenId'] == Data.Result['state_id'] then 
                        return Cb({ Success = false, Fail = 'Person already works in this company..', })
                    end
                end

                -- Import
                local NewEmployee = {
                    CitizenId = Data.Result['state_id'],
                    Rank = Data.Result['rank'],
                    Name = TPlayer.PlayerData.CharInfo.Firstname..' '..TPlayer.PlayerData.CharInfo.Lastname,
                }
                table.insert(Employees, NewEmployee)
                DatabaseModule.Update("UPDATE player_business SET employees = ? WHERE name = ?", {
                    json.encode(Employees),
                    Data['BusinessName']
                })
                Cb({
                    Success = true,
                })
            else
                Cb({
                    Success = false,
                    Fail = 'Business not found',
                })
            end
        end)
    end)
            
    CallbackModule.CreateCallback('mercy-business/server/remove-employee', function(Source, Cb, Data) 
        -- Data['BusinessName'], Data['CitizenId']
        DatabaseModule.Execute("SELECT * FROM player_business WHERE name = ?", {
            Data['BusinessName']
        }, function(BusinessResult)
            if BusinessResult[1] ~= nil then
                local Business = BusinessResult[1]
                local Employees = json.decode(Business.employees)
                for k, v in pairs(Employees) do
                    if v.CitizenId == Data['CitizenId'] then
                        if v.CitizenId ~= Business.owner then
                            table.remove(Employees, k)
                        else
                            return Cb({
                                Success = false,
                                Fail = 'You can\'t fire the owner of this company..',
                            })
                        end
                    end
                end
                DatabaseModule.Update("UPDATE player_business SET employees = ? WHERE name = ?", {
                    json.encode(Employees),
                    Data['BusinessName']
                })
                Cb({
                    Success = true,
                })
            else
                Cb({
                    Success = false,
                    Fail = 'Business not found',
                })
            end
        end)
    end)

    CallbackModule.CreateCallback('mercy-business/server/set-employee-rank', function(Source, Cb, Data) 
        -- Data['BusinessName'], Data['state_id'], Data['rank']
        DatabaseModule.Execute("SELECT * FROM player_business WHERE name = ?", {
            Data['BusinessName']
        }, function(BusinessResult)
            if BusinessResult[1] ~= nil then
                local Business = BusinessResult[1]
                local Employees = json.decode(Business.employees)
                for k, v in pairs(Employees) do
                    if v.CitizenId == Data.Result['state_id'] then
                        Employees[k].Rank = Data.Result['rank']
                    end
                end
                DatabaseModule.Update("UPDATE player_business SET employees = ? WHERE name = ?", {
                    json.encode(Employees),
                    Data['BusinessName']
                })
                Cb({
                    Success = true,
                })
            else
                Cb({
                    Success = false,
                    Fail = 'Business not found',
                })
            end
        end)
    end)
    
    CallbackModule.CreateCallback('mercy-business/server/is-employed-at-business', function(Source, Cb)
        local Data = IsEmployedAtBusiness(Source)
        Cb({ IsBusiness = Data[1], Name = Data[2] })
    end)

    CallbackModule.CreateCallback('mercy-business/server/get-employed-businesses', function(Source, Cb)
        local BusinessList = {}
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player then
            DatabaseModule.Execute("SELECT * FROM player_business", {}, function(BusinessData)
                if BusinessData ~= nil then
                    for BusinessId, BusinessData in pairs(BusinessData) do
                        local Employees = json.decode(BusinessData.employees)
                        if Employees ~= nil then
                            for EmployeeId, EmployeeData in pairs(Employees) do
                                if Player.PlayerData.CitizenId == EmployeeData.CitizenId then
                                    table.insert(BusinessList, {
                                        Name = BusinessData.name,
                                        Rank = EmployeeData.Rank,
                                    })
                                end
                            end
                        end
                    end
                end
            end, true)
            Cb(BusinessList)
        end
    end)
end)

-- [ Functions ] --

function IsPlayerInBusiness(Player, Name)   
    local Promise = promise:new()
    DatabaseModule.Execute("SELECT * FROM player_business WHERE name = ?", {
        Name
    }, function(BusinessResult)
        if BusinessResult[1] ~= nil then
            if BusinessResult[1].owner == Player.PlayerData.CitizenId then
                Promise:resolve(true)
            end
            local EmployeeList = json.decode(BusinessResult[1].employees)
            for Employee, Employees in pairs(EmployeeList) do
                if Employees.CitizenId == Player.PlayerData.CitizenId then
                    Promise:resolve(true)
                end
            end
            Promise:resolve(false)
        else
            Promise:resolve(false)
        end
    end)
    return Citizen.Await(Promise)
end
exports('IsPlayerInBusiness', IsPlayerInBusiness)

function IsEmployedAtBusiness(Source)
    if Source == nil then return false end
    if PlayerModule == nil then return false end
    local Promise = promise:new()
    local Player = PlayerModule.GetPlayerBySource(Source)
    if Player then
        DatabaseModule.Execute("SELECT * FROM player_business", {}, function(BusinessData)
            if BusinessData ~= nil then
                for BusinessId, BusinessData in pairs(BusinessData) do
                    local Employees = json.decode(BusinessData.employees)
                    if Employees ~= nil then
                        for EmployeeId, EmployeeData in pairs(Employees) do
                            if Player.PlayerData.CitizenId == EmployeeData.CitizenId then
                                Promise:resolve({ true, BusinessData.name })
                            end
                        end
                    else
                        Promise:resolve({ false, false })
                    end
                end
            else
                Promise:resolve({ false, false })
            end
        end, true)
    else
        Promise:resolve({ false, false })
    end
    return Citizen.Await(Promise)
end
exports('IsEmployedAtBusiness', IsEmployedAtBusiness)

function AddMoneyToBusinessAccount(BusinessName, Amount)
    local Promise = promise:new()
    DatabaseModule.Execute("SELECT * FROM player_accounts WHERE name = ?", {
        BusinessName
    }, function(Result)
        if Result[1] == nil then Promise:resolve(false) end
        Result[1].Balance = tonumber(Result[1].Balance) + tonumber(Amount)
        DatabaseModule.Update("UPDATE player_accounts SET Balance = ? WHERE Name = ?", {
            tonumber(Result[1].Balance),
            BusinessName
        })
        Promise:resolve(true)
    end, true)
    return Citizen.Await(Promise)
end
exports('AddMoneyToBusinessAccount', AddMoneyToBusinessAccount)

function RemoveMoneyFromBusinessAccount(BusinessName, Amount)
    local Promise = promise:new()
    DatabaseModule.Execute("SELECT * FROM player_accounts WHERE name = ?", {
        BusinessName
    }, function(Result)
        if Result[1] == nil then Promise:resolve(false) end
        if tonumber(Result[1].Balance) >= tonumber(Amount) then
            Result[1].Balance = tonumber(Result[1].Balance) - tonumber(Amount)
            DatabaseModule.Update("UPDATE player_accounts SET Balance = ? WHERE Name = ?", {
                tonumber(Result[1].Balance),
                BusinessName
            })
            Promise:resolve(true)
        else
            Promise:resolve(false)
        end
    end, true)
    return Citizen.Await(Promise)
end
exports('RemoveMoneyFromBusinessAccount', RemoveMoneyFromBusinessAccount)