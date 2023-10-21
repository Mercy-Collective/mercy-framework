CallbackModule, PlayerModule, CommandsModule, EventsModule = nil, nil, nil, nil

local _Ready = false
AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Callback',
        'Player',
        'Commands',
        'Events',
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        CommandsModule = exports['mercy-base']:FetchModule('Commands')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        _Ready = true
    end)
end)

Citizen.CreateThread(function() 
    while not _Ready do 
        Citizen.Wait(4) 
    end 

    -- [ Callbacks ] --
    CallbackModule.CreateCallback('mercy-hospital/server/is-serverid-dead', function(Source, Cb, ServerId)
        local Player = PlayerModule.GetPlayerBySource(tonumber(ServerId))
        if Player ~= nil then
            Cb(Player.PlayerData.MetaData['Dead'])
        end
    end)

    CallbackModule.CreateCallback('mercy-hospital/server/get-samples', function(Source, Cb, Type)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if not Player then return Cb(false) end

        local EvidenceList = {}
        for k, Item in pairs(Player.PlayerData.Inventory) do
            if Item.ItemName == Type then
                table.insert(EvidenceList, Item)
            end
        end
        if #EvidenceList > 0 then
            Cb(EvidenceList)
        else
            Cb(false)
        end
    end)

    -- [ Commands ] -- 
    CommandsModule.Add("revive", "Revive yourself", {}, false, function(source, args)
        local Player = PlayerModule.GetPlayerBySource(source)
        if Player then
            Player.Functions.SetMetaData("Food", 100)
            Player.Functions.SetMetaData("Water", 100)
            Player.Functions.SetMetaData("Stress", 0)
            TriggerClientEvent('mercy-hospital/client/revive', source, true)
        end
    end, "admin")

    CommandsModule.Add("revive#", "Revive a player", {{Name="Id", Help="Player ID"}}, false, function(source, args)
        if args[1] ~= nil then
            local Player = PlayerModule.GetPlayerBySource(tonumber(args[1]))
            if Player then
                Player.Functions.SetMetaData("Food", 100)
                Player.Functions.SetMetaData("Water", 100)
                Player.Functions.SetMetaData("Stress", 0)
                TriggerClientEvent('mercy-hospital/client/revive', Player.PlayerData.Source, true)
            else
                Player.Functions.Notify('not-online', 'Player is not online.', 'error')
            end
        else
            Player.Functions.Notify('no-id', 'This is not a valid player id.', 'error')
        end
    end, "admin")

    CommandsModule.Add("hireems", "Hire EMS", {{Name="Id", Help="Player ID"}}, true, function(source, args)
        local Player = PlayerModule.GetPlayerBySource(source)
        local TargetPlayer = PlayerModule.GetPlayerBySource(tonumber(args[1]))
        if Player.PlayerData.Job.HighCommand and Player.PlayerData.Job.Name == 'ems' then
            if TargetPlayer ~= nil then
                TargetPlayer.Functions.Notify('got-hired-ems', 'You\'re hired as EMS. Congrats!', 'success')
                Player.Functions.Notify('hired-ems', 'You hired '..TargetPlayer.PlayerData.CharInfo.Firstname..' '..TargetPlayer.PlayerData.CharInfo.Lastname..'!', 'success')
                TargetPlayer.Functions.SetJob('ems')
            end
        end
    end)

    CommandsModule.Add("fireems", "Fire EMS", {{Name="Id", Help="Player ID"}}, true, function(source, args)
        local Player = PlayerModule.GetPlayerBySource(source)
        local TargetPlayer = PlayerModule.GetPlayerBySource(tonumber(args[1]))
        if Player.PlayerData.Job.HighCommand then
            if TargetPlayer ~= nil and TargetPlayer.PlayerData.Job.Name == 'ems' then
                TargetPlayer.Functions.Notify('got-fired-ems', 'You\'re fired!', 'error')
                Player.Functions.Notify('fired-ems', 'You fired '..TargetPlayer.PlayerData.CharInfo.Firstname..' '..TargetPlayer.PlayerData.CharInfo.Lastname..'!', 'success')
                TargetPlayer.Functions.SetJob('unemployed')
            end
        end
    end)

    -- [ Events ] --

    EventsModule.RegisterServer("mercy-hospital/server/set-dead-state", function(Source, Bool)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player ~= nil then
            Player.Functions.SetMetaData('Dead', Bool)
        end
    end)

    EventsModule.RegisterServer("mercy-hospital/server/take-blood", function(Source, ServerId)
        local SourcePlayer = PlayerModule.GetPlayerBySource(Source)
        local TargetPlayer = PlayerModule.GetPlayerBySource(ServerId)
        if TargetPlayer ~= nil then
            local Info = {Blood = math.random(11111,99999), Type = TargetPlayer.PlayerData.MetaData['BloodType']}
            SourcePlayer.Functions.AddItem('blood-sample', 1, false, Info, true)
        end
    end)

    EventsModule.RegisterServer('mercy-hospital/server/receive-result', function(Source, Data)
        TriggerClientEvent('mercy-chat/client/post-message', Source, "Blood Result #"..Data.Blood, "Type: "..Data.Type, "error")
    end)

    EventsModule.RegisterServer("mercy-hospital/server/heal-player", function(Source, ServerId)
        local TargetPlayer = PlayerModule.GetPlayerBySource(ServerId)
        if TargetPlayer ~= nil then
            TriggerClientEvent('mercy-hospital/client/heal', TargetPlayer.PlayerData.Source)
        end
    end)

    EventsModule.RegisterServer("mercy-hospital/server/revive-player", function(Source, ServerId)
        local TargetPlayer = PlayerModule.GetPlayerBySource(ServerId)
        if TargetPlayer ~= nil then
            TargetPlayer.Functions.SetMetaData("Food", 100)
            TargetPlayer.Functions.SetMetaData("Water", 100)
            TargetPlayer.Functions.SetMetaData("Stress", 0)
            TriggerClientEvent('mercy-hospital/client/revive', TargetPlayer.PlayerData.Source, true)
        end
    end)

    EventsModule.RegisterServer("mercy-hospital/server/reset-vitals", function(Source)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player ~= nil then
            Player.Functions.SetMetaData("Food", 100)
            Player.Functions.SetMetaData("Water", 100)
            Player.Functions.SetMetaData("Stress", 0)
        end
    end)
end)

-- [ Code ] --

-- [ Events ] --

RegisterNetEvent("mercy-hospital/server/set-hospital-bed-busy", function(BedId, Bool)
    Config.HospitalBeds[BedId]['Busy'] = Bool
    TriggerClientEvent('mercy-hospital/client/set-hospital-bed-busy', -1, BedId, Bool)
end)

RegisterNetEvent("mercy-hospital/server/save-vitals", function(PArmor, PHealth)
    if PlayerModule == nil then return end
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    if Player then
        Player.Functions.SetMetaData('Health', PHealth)
        Player.Functions.SetMetaData('Armor', PArmor)
    end
end)

RegisterNetEvent("mercy-hospital/server/clear-inventory", function()
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    Player.Functions.RemoveMoney('Bank', 500, 'respawn-fund')
    Player.Functions.ClearInventory()
    Citizen.SetTimeout(250, function()
        Player.Functions.Save()
    end)
end)