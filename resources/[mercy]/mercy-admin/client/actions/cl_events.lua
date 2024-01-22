Spectate = {
    CurrentTarget = nil,
}

-- [ Code ] --

-- [ Events ] --

-- Dev

RegisterNetEvent("Admin:Toggle:EntityFreeAim", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end

    ToggleEntityFreeView()
end)

RegisterNetEvent("Admin:Toggle:VehView", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end

    ToggleEntityVehicleView()
end)

RegisterNetEvent("Admin:Toggle:PedView", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    
    ToggleEntityPedView()
end)

RegisterNetEvent("Admin:Toggle:ObjectView", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    
    ToggleEntityObjectView()
end)

RegisterNetEvent("Admin:Coords:Toggle", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end

    ToggleShowCoordinates()
end)

RegisterNetEvent("Admin:Toggle:VehDevMode", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end

    ToggleVehicleDeveloperMode()
end)

-- Businesses

local CreateTimeout = false
RegisterNetEvent("Admin:Businesses:Create", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end
    if CreateTimeout then 
        exports['mercy-ui']:Notify("create-timeout", "You are creating businesses too fast..", "error")
        return 
    end

    CreateTimeout = true
    EventsModule.TriggerServer('mercy-business/server/create-business', Result['name'], false, Result['logo'], Result['player'])
    SetTimeout(20 * 1000, function()
        CreateTimeout = false
    end)
end)

RegisterNetEvent("Admin:Businesses:SetOwner", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end

    EventsModule.TriggerServer('mercy-business/server/set-owner', Result['name'], Result['player'])
end)

RegisterNetEvent("Admin:Businesses:SetLogo", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end

    EventsModule.TriggerServer('mercy-business/server/set-logo', Result['name'], Result['logo'])
end)

RegisterNetEvent("Admin:Businesses:AddEmployee", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end

    local Data = CallbackModule.SendCallback('mercy-business/server/add-employee', {
        ['BusinessName'] = Result['name'],
        ['Result'] = {
            ['rank'] = Result['rank'] ~= nil and Result['rank'] or 'Employee',
            ['player'] = Result['player'],
        },
    })

    if Data['Success'] then
        exports['mercy-ui']:Notify("add-employee-success", 'Successfuly added '..Result['player']..' to '..Result['name']..' as '..Result['rank'], "success")
    else
        exports['mercy-ui']:Notify("add-employee-failed", Data['Fail'], "error")
    end
end)

RegisterNetEvent("Admin:Businesses:Delete", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end

    EventsModule.TriggerServer('mercy-business/server/delete-business', Result['name'])
end)

-- Perms

RegisterNetEvent("Admin:Permissions:Set", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end

    TriggerServerEvent('mc-admin/server/set-permissions', Result['player'], Result['group'])
end)

RegisterNetEvent("Admin:Permissions:Refresh", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end

    TriggerServerEvent('mc-admin/server/refresh-permissions', Result['player'])
end)

RegisterNetEvent("Admin:Set:Ammo", function(Result)
    if not PlayerModule.IsPlayerAdmin() then return end

   TriggerEvent('mercy-weapons/client/set-ammo', Result['amount'])
end)

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
    Spectate.Toggle(Result['player'])
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

local InfiniteAmmoEnabled = false
RegisterNetEvent("mc-admin/client/toggle-infinite-ammo", function(Bool)
    InfiniteAmmoEnabled = Bool
    while InfiniteAmmoEnabled == true do
        SetInfiniteAmmo(true)
        Wait(1500) -- Just if person takes new weapon
    end
    Wait(250)
    SetInfiniteAmmo(false)
end)

local InfiniteStaminaEnabled = false
RegisterNetEvent("mc-admin/client/toggle-infinite-stamina", function(Bool)
    InfiniteStaminaEnabled = Bool
    while InfiniteStaminaEnabled == true do
        RestorePlayerStamina(PlayerId(), 1.0)
        Wait(50)
    end
end)

local GodmodeEnabled = false
RegisterNetEvent("mc-admin/client/toggle-godmode", function(Bool)
    GodmodeEnabled = Bool
    while GodmodeEnabled == true do
        SetPlayerInvincible(PlayerId(), true)
        Wait(50)
    end
    SetPlayerInvincible(PlayerId(), false)
end)

RegisterNetEvent("mc-admin/client/toggle-cloak", function(Bool)
    if Bool then
        SetEntityVisible(PlayerPedId(), false)
    else
        SetEntityVisible(PlayerPedId(), true)
    end
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
    EventsModule.TriggerServer('mercy-ui/server/play-sound-at-pos', Sound, GetEntityCoords(PlayerPedId()), 10.0, 0.6)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        TriggerEvent('mc-admin/client/force-close')
        -- Stop Noclip
        toggleFreecam(false)
        -- Stop Spectate
        if SpectateEnabled then
            if Spectate.CurrentTarget ~= nil then
                Spectate.Toggle(Spectate.CurrentTarget)
            end
        end
        -- Reset Player Stuff
        SetInfiniteAmmo(false)
        SetPlayerInvincible(PlayerId(), false)
        SetEntityVisible(PlayerPedId(), true)
    end
end)


AddEventHandler('gameEventTriggered', function(event, data)
    if event == "CEventNetworkEntityDamage" then
        local victim, attacker, victimDied = data[1], data[2], data[4]
        if not IsEntityAPed(victim) then return end
        if victimDied and NetworkGetPlayerIndexFromPed(victim) == PlayerId() and IsEntityDead(PlayerPedId()) then
            if SpectateEnabled then
                if Spectate.CurrentTarget ~= nil then
                    Spectate.Toggle(Spectate.CurrentTarget)
                end
            end
        end
    end
end)