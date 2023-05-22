-- [ Code ] --

-- [ Events ] --

RegisterNetEvent("Admin:Bennys", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerEvent('mc-admin/client/force-close')
    SetTimeout(200, function()
        TriggerServerEvent('mc-admin/server/open-bennys', Result['player'])
    end)
end)

RegisterNetEvent("Admin:Kill", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerServerEvent('mc-admin/server/kill', Result['player'])
end)

RegisterNetEvent("Admin:Set:Environment", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerServerEvent('mc-admin/server/set-environment', Result['weather'], Result['hour'], Result['minute'])
end)

RegisterNetEvent("Admin:Delete:Area", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerServerEvent('mc-admin/server/delete-area', Result['type'], Result['radius'])
end)

RegisterNetEvent("Admin:Infinite:Ammo", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerServerEvent('mc-admin/server/toggle-infinite-ammo', Result['player'])
end)

RegisterNetEvent("Admin:Infinite:Stamina", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerServerEvent('mc-admin/server/toggle-infinite-stamina', Result['player'])
end)

RegisterNetEvent("Admin:Cloak", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerServerEvent('mc-admin/server/toggle-cloak', Result['player'])
end)

RegisterNetEvent("Admin:Godmode", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerServerEvent('mc-admin/server/toggle-godmode', Result['player'])
end)

RegisterNetEvent('Admin:Toggle:Noclip', function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerEvent('mc-admin/client/force-close')
    SendNUIMessage({
        Action = "SetItemEnabled",
        Name = 'noclip',
        State = not noClipEnabled
    })
    toggleFreecam(not noClipEnabled)
end)

RegisterNetEvent('Admin:Fix:Vehicle', function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerEvent('mc-admin/client/force-close')
    TriggerEvent('mercy-base/client/repair-vehicle')
end)

RegisterNetEvent('Admin:Delete:Vehicle', function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerEvent('mc-admin/client/force-close')
    TriggerEvent("mercy-base/client/delete-vehicle")
end)

RegisterNetEvent('Admin:Spawn:Vehicle', function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerEvent('mc-admin/client/force-close')
    if not IsModelValid(Result['model']) then
        exports['mercy-ui']:Notify("invalid-model", "Invalid model..", "error")
        return
    end
    TriggerEvent("mercy-base/client/spawn-vehicle", Result['model'])
end)

RegisterNetEvent('Admin:Teleport:Marker', function(Result)
     if not PlayerModule.IsPlayerAdmin() then return end
    TriggerEvent('mc-admin/client/force-close')
    TriggerEvent('mercy-admin/client/command-go-to-marker')
end)

RegisterNetEvent('Admin:Teleport:Coords', function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    if Result['x-coord'] ~= '' and Result['y-coord'] ~= '' and Result['z-coord'] ~= '' then
        TriggerEvent('mc-admin/client/force-close')
        SetEntityCoords(PlayerPedId(), tonumber(Result['x-coord']), tonumber(Result['y-coord']), tonumber(Result['z-coord']))
    end
end)

RegisterNetEvent('Admin:Teleport', function(Result)
     if not PlayerModule.IsPlayerAdmin() then return end
    TriggerEvent('mc-admin/client/force-close')
    TriggerServerEvent('mc-admin/server/teleport-player', Result['player'], Result['type'])
end)

RegisterNetEvent("Admin:Chat:Say", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerServerEvent('mc-admin/server/chat-say', Result['message'])
end)

RegisterNetEvent('Admin:Open:Clothing', function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerEvent('mc-admin/client/force-close')
    TriggerServerEvent('mc-admin/server/open-clothing', Result['player'])
end)

RegisterNetEvent('Admin:Revive:Radius', function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerServerEvent('mc-admin/server/revive-in-distance', Result['radius'])
end)

RegisterNetEvent('Admin:Revive', function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerServerEvent('mc-admin/server/revive-target', Result['player'])
end)

RegisterNetEvent('Admin:Remove:Stress', function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerServerEvent('mc-admin/server/remove-stress', Result['player'])
end)

RegisterNetEvent('Admin:Change:Model', function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    if Result['model'] ~= '' then
        local Model = GetHashKey(Result['model'])
        if IsModelValid(Model) then
            TriggerServerEvent('mc-admin/server/set-model', Result['player'], Model)
        end
    end
end)

RegisterNetEvent('Admin:Reset:Model', function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerServerEvent('mc-admin/server/reset-skin', Result['player'])
end)

RegisterNetEvent('Admin:Armor', function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerServerEvent('mc-admin/server/set-armor', Result['player'])
end)

RegisterNetEvent('Admin:Food:Drink', function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerServerEvent('mc-admin/server/set-food-drink', Result['player'])
end)

-- RegisterNetEvent('Admin:Request:Gang', function(Result)
--     if not PlayerModule.IsPlayerAdmin() then return end
--     TriggerServerEvent('mc-admin/server/request-gang', Result['player'], Result['gang'] ~= '' and Result['gang'] or 'none')
-- end)

RegisterNetEvent('Admin:Request:Job', function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerServerEvent('mc-admin/server/request-job', Result['player'], Result['job'] ~= '' and Result['job'] or 'unemployed')
end)

RegisterNetEvent("Admin:Drunk", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerServerEvent('mc-admin/server/drunk', Result['player'])
end)

RegisterNetEvent("Admin:Animal:Attack", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerServerEvent('mc-admin/server/animal-attack', Result['player'])
end)

RegisterNetEvent('Admin:Set:Fire', function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerServerEvent('mc-admin/server/set-fire', Result['player'])
end)

RegisterNetEvent('Admin:Fling:Player', function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerServerEvent('mc-admin/server/fling-player', Result['player'])
end)

RegisterNetEvent("Admin:Freeze:Player", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerServerEvent('mc-admin/server/freeze-player', Result['player'])
end)

RegisterNetEvent('Admin:SetMoney', function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerServerEvent('mc-admin/server/set-money', Result['player'], Result['moneytype'], Result['amount'])
end)

RegisterNetEvent('Admin:GiveMoney', function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end

    TriggerServerEvent('mc-admin/server/give-money', Result['player'], Result['moneytype'], Result['amount'])
end)

RegisterNetEvent('Admin:GiveItem', function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end

    TriggerServerEvent('mc-admin/server/give-item', Result['player'], Result['item'], Result['amount'])
end)

RegisterNetEvent('Admin:Ban', function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerServerEvent('mc-admin/server/ban-player', Result['player'], Result['expire'], Result['reason'])
end)

RegisterNetEvent('Admin:Unban', function(Result)
     if not PlayerModule.IsPlayerAdmin() then return end
    TriggerServerEvent("mc-admin/server/unban-player", Result['player'])
end)

RegisterNetEvent('Admin:Kick', function(Result)
     if not PlayerModule.IsPlayerAdmin() then return end
    TriggerServerEvent('mc-admin/server/kick-player', Result['player'], Result['reason'])
end)

RegisterNetEvent('Admin:Kick:All', function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
   TriggerServerEvent('mc-admin/server/kick-all-players', Result['reason'])
end)

RegisterNetEvent("Admin:Copy:Coords", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    local Coords, Heading = GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId())
    local X, Y, Z, H = roundDecimals(Coords.x, 2), roundDecimals(Coords.y, 2), roundDecimals(Coords.z, 2), roundDecimals(Heading, 2)
    TriggerEvent('mercy-admin/client/copy-to-clipboard', 
    Result['type'] == 'vector3(0.0, 0.0, 0.0)' and 'vector3('..X..', '..Y..', '..Z..')' or
    Result['type'] == 'vector4(0.0, 0.0, 0.0, 0.0)' and 'vector4('..X..', '..Y..', '..Z..', '..H..')' or
    Result['type'] == '0.0, 0.0, 0.0' and ''..X..', '..Y..', '..Z..'' or
    Result['type'] == '0.0, 0.0, 0.0, 0.0' and ''..X..', '..Y..', '..Z..', '..H..'' or
    Result['type'] == 'X = 0.0, Y = 0.0, Z = 0.0' and 'X = '..X..', Y = '..Y..', Z = '..Z..'' or
    Result['type'] == 'x = 0.0, y = 0.0, z = 0.0' and 'x = '..X..', y = '..Y..', z = '..Z..'' or
    Result['type'] == 'X = 0.0, Y = 0.0, Z = 0.0, H = 0.0' and 'X = '..X..', Y = '..Y..', Z = '..Z..', H = '..H or
    Result['type'] == 'x = 0.0, y = 0.0, z = 0.0, h = 0.0' and 'x = '..X..', y = '..Y..', z = '..Z..', h = '..H or
    Result['type'] == '["X"] = 0.0, ["Y"] = 0.0, ["Z"] = 0.0' and '["X"] = '..X..', ["Y"] = '..Y..', ["Z"] = '..Z or
    Result['type'] == '["x"] = 0.0, ["y"] = 0.0, ["z"] = 0.0' and '["x"] = '..X..', ["y"] = '..Y..', ["z"] = '..Z or
    Result['type'] == '["X"] = 0.0, ["Y"] = 0.0, ["Z"] = 0.0, ["H"] = 0.0' and '["X"] = '..X..', ["Y"] = '..Y..', ["Z"] = '..Z..', ["H"] = '..H or
    Result['type'] == '["x"] = 0.0, ["y"] = 0.0, ["z"] = 0.0, ["h"] = 0.0' and '["x"] = '..X..', ["y"] = '..Y..', ["z"] = '..Z..', ["h"] = '..H)
end)

RegisterNetEvent("Admin:Fart:Player", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerServerEvent('mc-admin/server/play-sound', Result['player'], Result['fart'])
end)

RegisterNetEvent('Admin:Toggle:PlayerBlips', function()
    if not PlayerModule.IsPlayerAdmin() then return end
    BlipsEnabled = not BlipsEnabled
    SendNUIMessage({
        Action = "SetItemEnabled",
        Name = 'playerblips',
        State = BlipsEnabled
    })
    if not NetCheck1 then
        NetCheck1 = true
    end
end)

RegisterNetEvent('Admin:Toggle:PlayerNames', function()
    if not PlayerModule.IsPlayerAdmin() then return end
    NamesEnabled = not NamesEnabled
    SendNUIMessage({
        Action = "SetItemEnabled",
        Name = 'playernames',
        State = NamesEnabled
    })
    if not NetCheck2 then
        NetCheck2 = true
    end
end)

RegisterNetEvent('Admin:Toggle:Spectate', function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    ToggleSpectate(Result['player'])
end)

RegisterNetEvent("Admin:OpenInv", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    TriggerEvent('mc-admin/client/force-close')
    local PlayerCitizenId = PlayerModule.GetPlayerCitizenIdBySource(Result['player'])
    EventsModule.TriggerServer('mercy-inventory/server/open-other-inventory', PlayerCitizenId, 'Player', 45, 250.0)
end)

-- [ Triggered Events ] --

RegisterNetEvent("mercy-admin/client/copy-to-clipboard", function(Text)
    SendNUIMessage({
        Action = 'Copy',
        String = Text,
    })
end)

RegisterNetEvent("mc-admin/client/delete-area", function(Type, Radius)
    Type = Type:lower()
    Radius = tonumber(Radius)
    if Type == 'peds' then
        DeletePeds(Radius)
    elseif Type == 'vehicles' then
        DeleteVehs(Radius)
    elseif Type == 'objects' then
        DeleteObjs(Radius)
    elseif Type == 'all' then
        DeletePeds(Radius)
        DeleteVehs(Radius)
        DeleteObjs(Radius)
    end
end)

RegisterNetEvent("mc-admin/client/freeze-player", function(Bool)
    FreezeEntityPosition(GetPlayerPed(PlayerId()), Bool)
end)

RegisterNetEvent("mc-admin/client/toggle-infinite-ammo", function(Bool)
    while Bool do
        Wait(1)
        SetInfiniteAmmo(true)
    end
    SetTimeout(250, function()
        SetInfiniteAmmo(false)
    end)
end)

RegisterNetEvent("mc-admin/client/toggle-infinite-stamina", function(Bool)
    while Bool do
        Wait(1)
        RestorePlayerStamina(PlayerId(), 1.0)
    end
end)

RegisterNetEvent("mc-admin/client/toggle-cloak", function(Bool)
    if Bool then
        SetEntityVisible(PlayerPedId(), false)
    else
        SetEntityVisible(PlayerPedId(), true)
    end
end)

RegisterNetEvent("mc-admin/client/toggle-godmode", function(Bool)
    while Bool do
        Wait(1)
        SetPlayerInvincible(PlayerId(), true)
    end
    SetTimeout(250, function()
        SetPlayerInvincible(PlayerId(), false)
    end)
end)

RegisterNetEvent('mc-admin/client/teleport-player', function(Coords)
    local Entity = PlayerPedId()    
    SetPedCoordsKeepVehicle(Entity, Coords.x, Coords.y, Coords.z)
end)

RegisterNetEvent('mc-admin/client/set-model', function(Model)
    if FunctionsModule.RequestModel(Model) then
        SetPlayerModel(PlayerId(), Model)
        SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 0)
    else
        exports['mercy-ui']:Notify("model-not-found", 'Model could not be loaded...', 'error')
    end
end)

RegisterNetEvent('mc-admin/client/armor-up', function()
    SetPedArmour(PlayerPedId(), 100.0)
end)

RegisterNetEvent("mc-admin/client/play-sound", function(Sound)
    TriggerServerEvent("mercy-ui/client/play-sound", Sound, 0.3, 5)
end)

-- AddEventHandler('gameEventTriggered', function(event, data)
--     if event == "CEventNetworkEntityDamage" then
--         local victim, attacker, victimDied = data[1], data[2], data[4]
--         if not IsEntityAPed(victim) then return end
--         if victimDied and NetworkGetPlayerIndexFromPed(victim) == PlayerId() and IsEntityDead(PlayerPedId()) then
--             if SpectateEnabled then
--                 ToggleSpectate(storedTargetPed)
--                 TriggerServerEvent('mc-admin/server/stop-spectate')
--             end
--         end
--     end
-- end)