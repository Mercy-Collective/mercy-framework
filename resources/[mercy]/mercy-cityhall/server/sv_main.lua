PlayerModule, DatabaseModule, EventsModule, CommandsModule = nil, nil, nil, nil

local _Ready = false
AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Player',
        'Database',
        'Events',
        'Commands',
    }, function(Succeeded)
        if not Succeeded then return end
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        DatabaseModule = exports['mercy-base']:FetchModule('Database')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        CommandsModule = exports['mercy-base']:FetchModule('Commands')
        _Ready = true
    end)
end)

-- [ Code ] --

Citizen.CreateThread(function() 
    while not _Ready do 
        Citizen.Wait(4) 
    end 

    -- [ Commands ] --

    CommandsModule.Add("setlawyer", "Make person lawyer..", {}, false, function(Source, args)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.PlayerData.Job.Name == 'judge' and Player.PlayerData.Job.Duty then
            TriggerClientEvent('mercy-cityhall/client/lawyer/add-closest', Source)
        else
            Player.Functions.Notify('not-judge', 'You can\'t do this..', 'error')
        end
    end)

    CommandsModule.Add("setprosecutor", "Make person prosecutor..", {}, false, function(Source, args)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.PlayerData.Job.Name == 'judge' and Player.PlayerData.Job.Duty then
            TriggerClientEvent('mercy-cityhall/client/prosecutor/add-closest', Source)
        else
            Player.Functions.Notify('not-judge', 'You can\'t do this..', 'error')
        end
    end)

    -- [ Events ] --

    EventsModule.RegisterServer('mercy-cityhall/server/lawyer/add', function(Source, Target)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local TPlayer = PlayerModule.GetPlayerBySource(tonumber(Target))
        if not TPlayer then return end
        TPlayer.Functions.SetJob('lawyer', 'Judge-Set')
        Player.Functions.Notify('lawyer-added', 'Made person lawyer..', 'success')
        TPlayer.Functions.Notify('lawyer-added', 'You are now a lawyer..', 'success')
    end)
    
    EventsModule.RegisterServer('mercy-cityhall/server/prosecutor/add', function(Source, Target)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local TPlayer = PlayerModule.GetPlayerBySource(tonumber(Target))
        if not TPlayer then return end
        TPlayer.Functions.SetJob('prosecutor', 'Judge-Set')
        Player.Functions.Notify('prosecutor-added', 'Made person prosecutor..', 'success')
        TPlayer.Functions.Notify('prosecutor-added', 'You are now a prosecutor..', 'success')
    end)
    
    EventsModule.RegisterServer('mercy-cityhall/server/do-license-things', function(Source, Type, StateId, LicenseType) -- Give License
        local Player = PlayerModule.GetPlayerBySource(Source)
        local TPlayer = PlayerModule.GetPlayerByStateId(tonumber(StateId))
        if TPlayer then
            if Type == 'Give' then
                local License = TPlayer.PlayerData.Licenses[LicenseType]
                if License then
                    Player.Functions.Notify('lic-already', 'Person already has a '.. LicenseType ..' license..', 'error')
                else
                    TPlayer.Functions.SetPlayerLicense(LicenseType, true)
                    Player.Functions.Notify('license-given-s', 'Gave a '.. LicenseType ..' license to the person..', 'success')
                    TPlayer.Functions.Notify('license-given-r', 'You have been given a '.. LicenseType ..' license..', 'success')
                end
            else
                local License = TPlayer.PlayerData.Licenses[LicenseType]
                if License then
                    TPlayer.Functions.SetPlayerLicense(LicenseType, false)
                    Player.Functions.Notify('lic-revoked-s', 'Revoked '.. LicenseType ..' license from person..', 'error')
                    TPlayer.Functions.Notify('lic-revoked-r', 'You\'re  '.. LicenseType ..' license has been revoked..', 'error')
                else
                    Player.Functions.Notify('license-not', 'Person does not have a '.. LicenseType ..' license..', 'error')
                end
            end
        else
            Player.Functions.Notify('not-found', 'Player not found..', 'error')
        end
    end)

    
    EventsModule.RegisterServer('mercy-cityhall/server/create-account', function(Source, AccountName, StateId, AccountType) 
        local TPlayer = PlayerModule.GetPlayerByStateId(StateId)
        if not TPlayer then
            TriggerClientEvent('mercy-ui/client/notify', Source, "not-found", "Target not found..", 'error')
            return
        end

        DatabaseModule.Execute("SELECT * FROM player_accounts WHERE name = ?", {
            AccountName
        }, function(AccountResult)
            if AccountResult[1] == nil then
                DatabaseModule.Insert("INSERT INTO player_accounts (CitizenId, Type, Name, BankId) VALUES (?, ?, ?, ?)", {
                    StateId,
                    AccountType == 'Savings Account' and 'Standard' or 'Business',
                    AccountName,
                    exports['mercy-financials']:GetUniqueAccountId()
                })
                TriggerClientEvent('mercy-ui/client/notify', Source, "gave-account", "Successfully created a bank account. ("..AccountName..") - ("..AccountType..")", 'success')
            else
                TriggerClientEvent('mercy-ui/client/notify', Source, "already-exists-account", "An account with this name already exists..", 'error')
            end
        end)
    end)

    EventsModule.RegisterServer('mercy-cityhall/server/do-account-monitor', function(Source, AccountId, Bool) 
        local Player = PlayerModule.GetPlayerBySource(Source)
        DatabaseModule.Execute("UPDATE player_accounts SET Monitoring = ? WHERE BankId = ?", {
            Bool,
            AccountId
        }, function()
            Player.Functions.Notify('account-monitoring', 'Account monitoring has been '.. (Bool and 'activated' or 'deactivated') ..'..', 'success')
        end)
    end)

    EventsModule.RegisterServer('mercy-cityhall/server/do-account-active', function(Source, AccountId, Bool) 
        local Player = PlayerModule.GetPlayerBySource(Source)
        DatabaseModule.Execute("UPDATE player_accounts SET Active = ? WHERE BankId = ?", {
            Bool,
            AccountId
        }, function()
            Player.Functions.Notify('account-active', 'Account has been '.. (Bool and 'activated' or 'deactivated') ..'..', 'success')
        end)
    end)

    EventsModule.RegisterServer('mercy-cityhall/server/do-house-active', function(Source, HouseName, Bool) 
        local Player = PlayerModule.GetPlayerBySource(Source)
        DatabaseModule.Execute("UPDATE player_houses SET active = ? WHERE house = ?", {
            Bool,
            HouseName:lower()
        }, function()
            Player.Functions.Notify('house-active', 'House has been '.. (Bool and 'activated' or 'deactivated') ..'..', 'success')
        end)
    end)
end)

RegisterNetEvent("mercy-cityhall/server/purchase-id", function()
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    if Player ~= nil then -- 2338776
        if Player.Functions.RemoveMoney('Cash', Config.IdPrice) then
            local CardInfo = {}
            CardInfo.CitizenId = Player.PlayerData.CitizenId
            CardInfo.Firstname = Player.PlayerData.CharInfo.Firstname
            CardInfo.Lastname = Player.PlayerData.CharInfo.Lastname
            CardInfo.Date = Player.PlayerData.CharInfo.Date
            CardInfo.Sex = Player.PlayerData.CharInfo.Gender
            Player.Functions.AddItem('idcard', 1, false, CardInfo, true)
        else
            Player.Functions.Notify('not-enough-m', 'You don\'t have enough money..', 'error')
        end
    end
end)