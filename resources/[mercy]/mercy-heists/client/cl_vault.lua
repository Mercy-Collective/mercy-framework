-- 338.5
-- vector3(256.93, 220.42, 106.24)

--[[
    Doors:
    135 -- first
    87 -- second
]]

InsidePacificBank, PacificHits = false, {}

-- Events

RegisterNetEvent('mercy-items/client/used-thermite-charge', function()
    --[[
        -- local Entity, EntityType, EntityCoords = FunctionsModule.GetEntityPlayerIsLookingAt(2.0, 0.2, 286, PlayerPedId())
        -- if GetEntityType(Entity) ~= 2 or GetEntityModel(Entity) ~= GetHashKey("stockade") then return end
    
        -- if exports['mercy-police']:GetTotalOndutyCops() >= Config.BanktruckCops then

                local IsHit = CallbackModule.SendCallback("mercy-heists/server/vault-canHit", 'FirstDoor')
                Citizen.SetTimeout(450, function()
                    if IsHit then return exports['mercy-ui']:Notify("heists-error", "Already burnt..", "error") end

                    local DidRemove = CallbackModule.SendCallback("mercy-base/server/remove-item", 'thermitecharge', 1, nil, true)
                    if DidRemove then
                        local Success = DoThermite(vector3(257.40, 220.20, 106.35))
                        if Success then
                            TriggerServerEvent('mercy-doors/server/set-locks', 135, 0)
                            TriggerServerEvent('mercy-ui/server/send-pacific-rob', FunctionsModule.GetStreetName())
                            EventsModule.TriggerServer("mercy-heists/server/vault-setHitStatus", 'FirstDoor')
                        end
                    end
                end)
        -- else
        --     exports['mercy-ui']:Notify("banktruck-error", "You can't do this now..", "error")
        -- end
    ]]
end)

RegisterNetEvent('mercy-heists/client/vault-start-startHacking', function(Data, Entity)
    if not exports['mercy-inventory']:HasEnoughOfItem('heist-laptop-red', 1) then return exports['mercy-ui']:Notify("heists-error", "You miss something..", "error") end
    
    if Data.Door == 'SecondDoor' then
        -- exports['mercy-ui']:FigureMinigame(3, 3, function(Success)
        -- exports['mercy-ui']:FigureMinigame(1, 5, function(Success)
            -- if Success then
                TriggerServerEvent('mercy-doors/server/set-locks', 87, 0)
                EventsModule.TriggerServer("mercy-heists/server/vault-setHitStatus", 'SecondDoor')
            -- end
        -- end)
    elseif Data.Door == 'UpperVault' then
        -- exports['mercy-ui']:FigureMinigame(5, 3, function(Success)
        -- exports['mercy-ui']:FigureMinigame(1, 5, function(Success)
            -- if Success then
                EventsModule.TriggerServer("mercy-heists/server/vault-setHitStatus", 'UpperVault')
            -- end
        -- end)
    elseif Data.Door == 'LowerVault' then
        -- exports['mercy-ui']:FigureMinigame(8, 4, function(Success)
        -- exports['mercy-ui']:FigureMinigame(1, 5, function(Success)
            -- if Success then
                EventsModule.TriggerServer("mercy-heists/server/vault-setHitStatus", 'LowerVault')
            -- end
        -- end)
    end
end)

RegisterNetEvent('mercy-heists/client/vault-syncDoors', function(Doors)
    if PacificHits.UpperVault ~= Doors.UpperVault then
        Citizen.SetTimeout(150, function()
            if Doors.UpperVault then
                VaultSpawnTrolleys('UpperVault')
            end
            VaultToggleDoor('UpperVault')
        end)
    elseif PacificHits.LowerVault ~= Doors.LowerVault then
        Citizen.SetTimeout(150, function()
            if Doors.LowerVault then
                VaultSpawnTrolleys('LowerVault')
            end
            VaultToggleDoor('LowerVault')
        end)
    end

    PacificHits = Doors
end)


-- Functions

function InitVault()
    -- UpperVault
    local UpperVaultObject = GetClosestObjectOfType(256.93, 220.42, 106.24, 5.0, GetHashKey("v_ilev_bk_vaultdoor"), false, false, false)
    FreezeEntityPosition(UpperVaultObject, true)

    local Hits = CallbackModule.SendCallback('mercy-heists/server/vault-getHits')
    PacificHits = Hits
    VaultToggleDoor('UpperVault')
    VaultToggleDoor('LowerVault')

    exports['mercy-ui']:AddEyeEntry("heist_pacific_second_door", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 1.5,
        ZoneData = {
            Center = vector3(262.27, 223.02, 106.28),
            Length = 0.45,
            Width = 0.2,
            Data = {
                heading = 340,
                minZ = 106.33,
                maxZ = 106.93,
            }
        },
        Options = {
            {
                Name = 'heist_pacific_bank',
                Icon = 'fas fa-user-secret',
                Label = 'Hack',
                EventType = 'Client',
                EventName = 'mercy-heists/client/vault-start-startHacking',
                EventParams = { Door = 'SecondDoor' },
                Enabled = function(Entity)
                    local Prom = promise:new()
                    local IsHit = CallbackModule.SendCallback('mercy-heists/server/vault-canHit', 'SecondDoor')
                    if (not IsHit) and exports['mercy-inventory']:HasEnoughOfItem('heist-laptop-red', 1) then
                        Prom:resolve(true)
                    else
                        Prom:resolve(false)
                    end
                    return Citizen.Await(Prom)
                end,
            }
        }
    })

    exports['mercy-ui']:AddEyeEntry("heist_pacific_upper_vault", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 1.5,
        ZoneData = {
            Center = vector3(252.91, 228.52, 101.68),
            Length = 0.5,
            Width = 0.25,
            Data = {
                heading = 340,
                minZ = 101.68,
                maxZ = 102.48,
            }
        },
        Options = {
            {
                Name = 'heist_pacific_bank',
                Icon = 'fas fa-user-secret',
                Label = 'Hack',
                EventType = 'Client',
                EventName = 'mercy-heists/client/vault-start-startHacking',
                EventParams = { Door = 'UpperVault' },
                Enabled = function(Entity)
                    local Prom = promise:new()
                    local IsHit = CallbackModule.SendCallback('mercy-heists/server/vault-canHit', 'UpperVault')
                    if (not IsHit) and exports['mercy-inventory']:HasEnoughOfItem('heist-laptop-red', 1) then
                        Prom:resolve(true)
                    else
                        Prom:resolve(false)
                    end
                    return Citizen.Await(Prom)
                end,
            }
        }
    })

    VaultToggleDoor('UpperVault')
end

function VaultToggleDoor(Type)
    if Type == 'UpperVault' then
        local Object = GetClosestObjectOfType(256.93, 220.42, 106.24, 5.0, GetHashKey("v_ilev_bk_vaultdoor"), false, false, false)
        local Heading = GetEntityHeading(Object)
        if PacificHits[Type] then
            if Heading > 371 or Heading < 369 then
                SetEntityHeading(Object, 370.0)
            end
        else
            if Heading > 160 or Heading < 157 then
                SetEntityHeading(Object, 160.0)
            end
        end
    elseif Type == 'LowerVault' then
    end
end

function VaultSpawnTrolleys(Type)
    if Type == 'UpperVault' then
        SpawnTrolley(vector4(259.36, 214.72, 101.68, 42.86), 'Money')
        SpawnTrolley(vector4(262.78, 213.38, 101.68, 20.61), 'Money')
        SpawnTrolley(vector4(263.33, 215.42, 101.68, 124.09), 'Money')
        SpawnTrolley(vector4(265.68, 213.89, 101.68, 26.93), 'Gold')
    elseif Type == 'LowerVault' then

    end
end