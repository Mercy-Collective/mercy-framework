-- [ Code ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(4)
    end

    EventsModule.RegisterServer("mercy-heists/server/housing/sync-house", function(Source, Type, HouseId, Extra, ExtraTwo)
        if Type == 'SetHouseId' then
            TriggerClientEvent('mercy-heists/client/housing/sync-house', Source, 'SetHouseId', HouseId, Config.Houses.Houses[HouseId])
            return
        elseif Type == 'SetLocked' then
            Config.Houses.Houses[HouseId].Locked = Extra
        elseif Type == 'SetAvailable' then
            Config.Houses.Houses[HouseId].Available = Extra
        elseif Type == 'SetAlarm' then
            Config.Houses.Houses[HouseId].Alarm = Extra
        elseif Type == 'SetLocker' then
            Config.Houses.Houses[HouseId].Loot[Extra] = ExtraTwo
            if Config.Houses.Houses[HouseId].Alarm then -- If alarm is active, send alarm police
                TriggerClientEvent('mercy-heists/client/houses-send-alarm', Source)
                for i=1, 5 do
                    TriggerClientEvent('mercy-heists/client/houses-send-alarm-beep', Source, 'alarm-beep-alarm', HouseId)
                    Wait(500)
                end
            end
        elseif Type == 'Reset' then
            Config.Houses.Houses[HouseId] = Extra
        end
        TriggerClientEvent('mercy-heists/client/housing/sync-house', -1, Type, HouseId, Extra, ExtraTwo)
    end)

    EventsModule.RegisterServer("mercy-heists/server/housing/reset-house", function(Source, HouseId, Bool)
        Config.Houses.Houses[HouseId].Alarm = true
        Config.Houses.Houses[HouseId].Available = true
        Config.Houses.Houses[HouseId].Locked = true
        Config.Houses.Houses[HouseId].Loot = {}
        TriggerClientEvent('mercy-heists/client/housing/sync-house', Source, 'ResetCurrent', HouseId, Config.Houses.Houses[HouseId])
        TriggerClientEvent('mercy-heists/client/housing/sync-house', -1, 'Reset', HouseId, Config.Houses.Houses[HouseId])
    end)

    EventsModule.RegisterServer("mercy-heists/server/housing/receive-goods", function(Source, Type)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if not Config.HeistRewards['Housing'][Type] then return end
        if not Player then return end

        local RandomItem = math.random(1, #Config.HeistRewards['Housing'][Type]['Items'])
        local Item = Config.HeistRewards['Housing'][Type]['Items'][RandomItem]
        local Min, Max = Config.HeistRewards['Housing'][Type]['Min'], Config.HeistRewards['Housing'][Type]['Max']
        Player.Functions.AddItem(Item, math.random(Min, Max), false, false, true)
    end)
end)

-- [ Events ] --

RegisterNetEvent("mercy-heists/client/housing/on-first-enter", function(HouseId)
    local src = source
    Citizen.SetTimeout((1000 * 60) * Config.Houses.Houses[HouseId].Timer, function() -- 35 Min
        print('[DEBUG:HouseRobberies]: Resetting House: '..HouseId)
        if not Config.Houses.Houses[HouseId].Locked or not Config.Houses.Houses[HouseId].Available then 
            Config.Houses.Houses[HouseId].Alarm = true
            Config.Houses.Houses[HouseId].Available = true
            Config.Houses.Houses[HouseId].Locked = true
            Config.Houses.Houses[HouseId].Loot = {}
            exports['mercy-phone']:CancelJobTask("houses")
            TriggerClientEvent('mercy-heists/client/housing/sync-house', -1, 'Reset', HouseId, Config.Houses.Houses[HouseId])
            TriggerClientEvent('mercy-heists/client/housing/sync-house', src, 'ResetCurrent', HouseId, Config.Houses.Houses[HouseId])
        end
    end)
end)
