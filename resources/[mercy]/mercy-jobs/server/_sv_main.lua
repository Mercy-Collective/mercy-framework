CallbackModule, PlayerModule, FunctionsModule, DatabaseModule, CommandsModule, EventsModule = nil, nil, nil, nil, nil, nil

_Ready = false
AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Callback',
        'Player',
        'Functions',
        'Database',
        'Commands',
        'Events',
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
        DatabaseModule = exports['mercy-base']:FetchModule('Database')
        CommandsModule = exports['mercy-base']:FetchModule('Commands')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        _Ready = true
    end)
end)

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function() 
    while not _Ready do 
        Citizen.Wait(4) 
    end 

    -- [ Get ] --

    CallbackModule.CreateCallback('mercy-jobs/server/bees/get-config', function(Source, Cb)
        Cb(Config.BeeHives)
    end)

    CallbackModule.CreateCallback('mercy-jobs/server/fishing/get-current-spot', function(Source, Cb)
        Cb(ServerConfig.CurrentFishSpot)
    end)

    -- Receipts

    EventsModule.RegisterServer("mercy-jobs/server/sell-receipts", function(Source, Coords, Heading)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local Receipts = Player.Functions.GetItemByName('receipt')
        if Receipts ~= nil  then
            if Receipts.Info.Money == nil then return Player.Functions.Notify('invalid-receipt', 'Invalid receipt found, can\'t redeem..', 'error') end
            if Receipts.Amount > 0 then
                for i = 1, Receipts.Amount do
                    Player.Functions.AddMoney('Cash', Receipts.Info.Money, Receipts.Info.Business..'-sold-receipt-'..Receipts.Info.Comment)
                    Player.Functions.RemoveItem('receipt', 1, false, true)
                    Citizen.Wait(250)
                end
            end
        end
    end)
    
    -- Jobcenter

    CallbackModule.CreateCallback('mercy-jobs/server/get-job-locs', function(Source, Cb, Job, Leader)
        Cb(ServerConfig.JobLocations)
    end)

    EventsModule.RegisterServer("mercy-jobs/server/set-job-locs", function(Source, Job, Leader)
        ServerConfig.JobLocations = {}
        if Job == 'sanitation' then
            local Zone1, Zone2 = GetSanitationZones()
            ServerConfig.JobLocations = {Zone1, Zone2}
        elseif Job == 'delivery' then
            ServerConfig.JobLocations = math.random(1, #Config.DeliveryStores)
        end
    end)
end)

-- [ Functions ] --

GetSanitationZones = function()
    local Zone = math.random(1, #Config.SanitationZones)
    local Zone2 = math.random(1, #Config.SanitationZones)
    while Zone == Zone2 do
        Wait(500)
        Zone2 = math.random(1, #Config.SanitationZones)
    end
    return Zone, Zone2
end

-- [ Events ] --

RegisterNetEvent("mercy-jobs/server/receive-paycheck", function()
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    local Money = Player.PlayerData.MetaData['SalaryPayheck']
    if Money ~= nil and Money > 0 then
        Player.Functions.AddMoney('Cash', Money)
        Player.Functions.SetMetaData('SalaryPayheck', 0)
    else
        Player.Functions.Notify('no-paycheck', 'You have no paycheck..', 'error', 3500)
    end
end)