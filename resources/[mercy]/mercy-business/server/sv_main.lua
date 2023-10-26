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

    EventsModule.RegisterServer('mercy-business/server/create-business', function(Source, BusinessName, StateId, Logo, IsSource) 
        local TPlayer = false
        local StateId = StateId
        -- Check if player is a source or state id
        if IsSource == nil or not IsSource then
            TPlayer = PlayerModule.GetPlayerByStateId(tonumber(StateId))
        else
            TPlayer = PlayerModule.GetPlayerBySource(tonumber(IsSource))
            StateId = TPlayer.PlayerData.CitizenId
        end
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

    EventsModule.RegisterServer('mercy-business/server/set-owner', function(Source, BusinessName, NewOwner) 
        local TPlayer = PlayerModule.GetPlayerBySource(tonumber(NewOwner))
        local StateId = TPlayer.PlayerData.CitizenId
        if not TPlayer then 
            TriggerClientEvent('mercy-ui/client/notify', Source, "not-found", "Target not found..", 'error')
            return
        end
        DatabaseModule.Execute("SELECT * FROM player_business WHERE name = ?", {
            BusinessName
        }, function(BusinessResult)
            if BusinessResult[1] ~= nil then
                local Business = BusinessResult[1]
                local Employees = json.decode(Business.employees)
                -- Set old CEO as employee
                for k, v in pairs(Employees) do
                    if v.CitizenId == Business.owner then
                        Employees[k].Rank = 'Employee'
                    end
                end
                -- Import into employees if not exist
                local IsEmployee = false
                for k, v in pairs(Employees) do
                    if v.CitizenId == StateId then
                        IsEmployee = true
                    end
                end

                if not IsEmployee then
                    table.insert(Employees, {
                        CitizenId = StateId,
                        Rank = 'Owner',
                        Name = TPlayer.PlayerData.CharInfo.Firstname..' '..TPlayer.PlayerData.CharInfo.Lastname,
                    })
                else
                    -- Set new CEO as owner
                    for k, v in pairs(Employees) do
                        if v.CitizenId == StateId then
                            Employees[k].Rank = 'Owner'
                        end
                    end
                end
                
                DatabaseModule.Update("UPDATE player_business SET owner = ?, employees = ? WHERE name = ?", {
                    StateId,
                    json.encode(Employees),
                    BusinessName
                })
                TriggerClientEvent('mercy-ui/client/notify', Source, "set-owner", "Successfully set "..TPlayer.PlayerData.CharInfo.Firstname..' '..TPlayer.PlayerData.CharInfo.Lastname.." as the owner of "..BusinessName, 'success')
                TriggerClientEvent('mercy-ui/client/notify', TPlayer.PlayerData.Source, "received-business", "You are now the CEO of "..BusinessName, 'success')
            else
                TriggerClientEvent('mercy-ui/client/notify', Source, "not-found", "Business not found..", 'error')
            end
        end)
    end)

    EventsModule.RegisterServer('mercy-business/server/set-logo', function(Source, BusinessName, NewLogo) 
        DatabaseModule.Execute("SELECT * FROM player_business WHERE name = ?", {
            BusinessName
        }, function(BusinessResult)
            if BusinessResult[1] ~= nil then
                DatabaseModule.Update("UPDATE player_business SET logo = ? WHERE name = ?", {
                    NewLogo,
                    BusinessName
                })
                TriggerClientEvent('mercy-ui/client/notify', Source, "set-logo", "Successfully set the logo of "..BusinessName, 'success')
            else
                TriggerClientEvent('mercy-ui/client/notify', Source, "not-found", "Business not found..", 'error')
            end
        end)
    end)

    EventsModule.RegisterServer('mercy-business/server/delete-business', function(Source, BusinessName) 
        DatabaseModule.Execute("SELECT * FROM player_business WHERE name = ?", {
            BusinessName
        }, function(BusinessResult)
            if BusinessResult[1] ~= nil then
                DatabaseModule.Execute("DELETE FROM player_business WHERE name = ?", {
                    BusinessName
                })
                TriggerClientEvent('mercy-ui/client/notify', Source, "deleted-business", "Successfully deleted "..BusinessName, 'success')
            else
                TriggerClientEvent('mercy-ui/client/notify', Source, "not-found", "Business not found..", 'error')
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
                        ['hire'] = Data.Result['hire'] or false,
                        ['fire'] = Data.Result['fire'] or false,
                        ['change_role'] = Data.Result['change_role'] or false,
                        ['pay_employee'] = Data.Result['pay_employee'] or false,
                        ['pay_external'] = Data.Result['pay_external'] or false,
                        ['charge_external'] = Data.Result['charge_external'] or false,
                        ['property_keys'] = Data.Result['property_keys'] or false,
                        ['stash_access'] = Data.Result['stash_access'] or false,
                        ['craft_access'] = Data.Result['craft_access'] or false,
                        ['account_access'] = Data.Result['account_access'] or false,
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
        -- Admin Menu 
        if Data.Result['state_id'] == nil then
            local Player = PlayerModule.GetPlayerBySource(tonumber(Data.Result['player']))
            Data.Result['state_id'] = Player.PlayerData.CitizenId
        end

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

    CallbackModule.CreateCallback('mercy-business/server/get-businesses', function(Source, Cb)
        local BusinessList = {}
        DatabaseModule.Execute("SELECT * FROM player_business", {}, function(BusinessData)
            if BusinessData ~= nil then
                for BusinessId, BusinessData in pairs(BusinessData) do
                    table.insert(BusinessList, {
                        Name = BusinessData.name,
                        Owner = BusinessData.owner,
                        Employees = json.decode(BusinessData.employees),
                        Ranks = json.decode(BusinessData.ranks),
                        Logo = BusinessData.logo,
                    })
                end
            end
        end, true)
        Cb(BusinessList)
    end)
end)

-- [ Functions ] --

function HasBusinessPermission(Player, Name, PermissionName)
    local Promise = promise:new()
    DatabaseModule.Execute("SELECT * FROM player_business WHERE name = ?", {
        Name
    }, function(BusinessResult)
        if BusinessResult[1] ~= nil then
            if Player then
                local Employees = json.decode(BusinessResult[1].employees)
                for k, v in pairs(Employees) do
                    if v.CitizenId == Player.PlayerData.CitizenId then
                        local Ranks = json.decode(BusinessResult[1].ranks)
                        for Rank, RankData in pairs(Ranks) do
                            if RankData.Name == v.Rank then
                                if RankData.Permissions[PermissionName] ~= nil and RankData.Permissions[PermissionName] then
                                    Promise:resolve(true)
                                else
                                    Promise:resolve(false)
                                end
                            end
                        end
                    end
                end
            else
                Promise:resolve(false)
            end
        else
            Promise:resolve(false)
        end
    end)
    return Citizen.Await(Promise)
end
exports('HasBusinessPermission', HasBusinessPermission)

function GetOnlineBusinessEmployees(Name)
    local Promise = promise:new()
    local Employees = {}
    DatabaseModule.Execute("SELECT * FROM player_business WHERE name = ?", {
        Name
    }, function(BusinessResult)
        if BusinessResult[1] ~= nil then
            local EmployeeList = json.decode(BusinessResult[1].employees)
            for Employee, Employees in pairs(EmployeeList) do
                local Player = PlayerModule.GetPlayerByStateId(Employees.CitizenId)
                if Player then
                    table.insert(Employees, {
                        CitizenId = Employees.CitizenId,
                        Name = Player.PlayerData.CharInfo.Firstname..' '..Player.PlayerData.CharInfo.Lastname,
                        Rank = Employees.Rank,
                    })
                end
            end
            Promise:resolve(Employees)
        else
            Promise:resolve(false)
        end
    end)
    return Citizen.Await(Promise)
end
exports('GetOnlineBusinessEmployees', GetOnlineBusinessEmployees)

function GetBusinessOwnerName(Name)
    local Promise = promise:new()
    DatabaseModule.Execute("SELECT * FROM player_business WHERE name = ?", {
        Name
    }, function(BusinessResult)
        if BusinessResult[1] ~= nil then
            local Player = PlayerModule.GetPlayerByStateId(BusinessResult[1].owner)
            if Player then
                Promise:resolve(Player.PlayerData.CharInfo.Firstname..' '..Player.PlayerData.CharInfo.Lastname)
            else
                DatabaseModule.Execute("SELECT * FROM players WHERE CitizenId = ?", {
                    BusinessResult[1].owner
                }, function(CharacterResult)
                    if CharacterResult[1] ~= nil then
                        local CharInfo = json.decode(CharacterResult[1].CharInfo)
                        Promise:resolve(CharInfo.Firstname..' '..CharInfo.Lastname)
                    else
                        Promise:resolve('Unknown')
                    end
                end)
            end
        else
            Promise:resolve('Unknown')
        end
    end)
    return Citizen.Await(Promise)
end
exports('GetBusinessOwnerName', GetBusinessOwnerName)

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
    if Amount == nil or Amount <= 0 then Promise:resolve(false) end
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