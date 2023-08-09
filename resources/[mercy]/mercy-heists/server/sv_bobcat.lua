-- [ Code ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(4)
    end

    EventsModule.RegisterServer("mercy-heists/server/bobcat/receive-goods", function(Source)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local RandomItem = math.random(1, #Config.HeistRewards['Bobcat']['Items'])
        local Item = Config.HeistRewards['Bobcat']['Items'][RandomItem]
        local Min, Max = Config.HeistRewards['Bobcat']['Min'], Config.HeistRewards['Bobcat']['Max']
        Player.Functions.AddItem(Item, math.random(Min, Max), false, false, true)
    end)
end)

-- [ Events ] --

RegisterNetEvent("mercy-heists/server/bobcat/set-door-state", function(Type)
    if Type == 'Outside' then
        Config.OutsideDoorsThermited = true
    elseif Type == 'Inside' then
        Config.InsideDoorsThermited = true
    end
    TriggerClientEvent('mercy-heists/client/bobcat/sync-door-state', -1, Config.OutsideDoorsThermited, Config.InsideDoorsThermited)
end)

RegisterNetEvent("mercy-heists/server/bobcat/blow-vault", function()
    TriggerClientEvent('mercy-heists/client/bobcat/process-blow-vault', -1)
    Citizen.SetTimeout((1000 * 60) * Config.ResetTimes['Bobcat'], function() -- 5 Hours
        Config.BobcatExploded = false
        TriggerClientEvent('mercy-heists/client/bobcat/reset-exploded', -1)
        Config.OutsideDoorsThermited = false
        Config.InsideDoorsThermited = false
        TriggerClientEvent('mercy-heists/client/bobcat/sync-door-state', -1, Config.OutsideDoorsThermited, Config.InsideDoorsThermited)
        TriggerEvent('mercy-doors/server/set-locks', Config.BobcatDoors[1], 1)
        TriggerEvent('mercy-doors/server/set-locks', Config.BobcatDoors[2], 1)
        TriggerEvent('mercy-doors/server/set-locks', Config.BobcatDoors[3], 1)
        TriggerEvent('mercy-doors/server/set-locks', Config.BobcatDoors[4], 1)
    end)
end)

RegisterNetEvent("mercy-heists/server/set-loot-state", function(BoxId, Bool)
    Config.LootSpots[BoxId] = Bool
    TriggerClientEvent('mercy-heists/client/sync-loot-state', -1, Config.LootSpots)
end)