
-- [ Code ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(4)
    end

    EventsModule.RegisterServer("mercy-heists/server/banks/receive-trolly-goods", function(Source, Type)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Type == 'Fleeca' then
            Player.Functions.AddItem('cash-rolls', math.random(5, 20), false, false, true)
            Player.Functions.AddItem('markedbills', 1, false, {Worth = math.random(8000, 13000)}, true)
        end
    end)
end)

-- [ Events ] --

RegisterNetEvent("mercy-heists/server/banks/set-panel-state", function(Type, PanelId, Bool)
    Config.Panels[Type][PanelId]['CanUsePanel'] = Bool
    TriggerClientEvent('mercy-heists/client/banks/sync-data', -1, Type, PanelId, Config.Panels[Type][PanelId])
end)

RegisterNetEvent("mercy-heists/server/banks/set-hacked-state", function(Type, PanelId, Bool)
    Config.Panels[Type][PanelId]['Hacked'] = Bool
    TriggerClientEvent('mercy-heists/client/banks/sync-data', -1, Type, PanelId, Config.Panels[Type][PanelId])
end)

RegisterNetEvent("mercy-heists/server/banks/set-trolly-busy", function(Type, PanelId, Bool)
    Config.Panels[Type][PanelId]['Trolly']['Busy'] = Bool
    TriggerClientEvent('mercy-heists/client/banks/sync-data', -1, Type, PanelId, Config.Panels[Type][PanelId])
end)

RegisterNetEvent("mercy-heists/server/thermite-syncFx", function(Coords, Detcord)
    TriggerClientEvent('mercy-heists/client/thermite/sync-fx', -1, Coords, Detcord)
end)