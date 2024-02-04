local IsSmashingVitrine = false

function InitJewellery()
    local NewState = CallbackModule.SendCallback('mercy-heists/server/jewellery/get-state')
    Config.JewelleryState = NewState
end

RegisterNetEvent('mercy-items/client/used-thermite-charge', function()
    local Secure = CallbackModule.SendCallback('mercy-police/server/can-rob')
    if Secure then return exports['mercy-ui']:Notify("heists-error", "Secure active!", "error") end
    if exports['mercy-police']:GetTotalOndutyCops() < exports['mercy-heists']:GetJewelleryCops() then return end
    if #(GetEntityCoords(PlayerPedId()) - vector3(-595.87, -283.66, 50.32)) > 1.5 then return end
    if Config.JewelleryState then
        return exports['mercy-ui']:Notify("jewelrob", "Already burnt!", "error")
    end

    Citizen.SetTimeout(450, function()
        local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', 'thermitecharge', 1, nil, true)
        if DidRemove then
            exports['mercy-inventory']:SetBusyState(true)
            local Success = DoThermite(vector3(-596.02, -283.72, 50.6), true)
            exports['mercy-inventory']:SetBusyState(false)
            if Success then
                EventsModule.TriggerServer('mercy-ui/server/send-jewelery-rob', FunctionsModule.GetStreetName())
                EventsModule.TriggerServer('mercy-heists/server/jewellery/set-state', true)
                TriggerEvent('mercy-ui/client/notify', "jewelrob", "Success! The doors will open any minute now!", 'success')
                Citizen.SetTimeout((1000 * 60) * 3, function()
                    TriggerServerEvent('mercy-doors/server/set-locks', Config.JewelleryDoors[1], 0)
                    TriggerServerEvent('mercy-doors/server/set-locks', Config.JewelleryDoors[2], 0)
                end)
            end
        end
    end)
end)

RegisterNetEvent('mercy-heists/client/jewellery/sync-state', function(NewState)
    Config.JewelleryState = NewState
end)

RegisterNetEvent('mercy-heists/client/jewellery/smash-vitrine', function(Data)
    local Secure = CallbackModule.SendCallback('mercy-police/server/can-rob')
    if Secure then return exports['mercy-ui']:Notify("heists-error", "Secure active!", "error") end
    local CanRob = CallbackModule.SendCallback('mercy-heists/server/jewellery/can-rob-vitrine', Data.VitrineId)
    if not CanRob then return exports['mercy-ui']:Notify("jewelrob", "Already smashed!", "error") end
    if not Config.JewelleryWeapons[GetSelectedPedWeapon(PlayerPedId())] then return exports['mercy-ui']:Notify("jewelrob", "You need something bigger than this..", "error") end
    if IsSmashingVitrine then return exports['mercy-ui']:Notify("jewelrob", "Already smashing!", "error") end
    IsSmashingVitrine = true
    EventsModule.TriggerServer("mercy-heists/server/jewellery/set-vitrine-state", Data.VitrineId, true)
    EventsModule.TriggerServer('mercy-ui/server/set-stress', 'Add', math.random(6, 12))
    if not IsWearingHandshoes() and math.random(1, 100) <= 85 then
        TriggerServerEvent("mercy-police/server/create-evidence", 'Fingerprint')
    end

    FunctionsModule.RequestAnimDict("missheist_jewel")
    EventsModule.TriggerServer('mercy-ui/server/play-sound-in-distance', {['Distance'] = 2.0, ['Type'] = 'Distance', ['Name'] = 'jewelry-glassbreak', ['Volume'] = 0.5})
    TaskPlayAnim(PlayerPedId(), "missheist_jewel", "smash_case", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
    Citizen.Wait(4200)
    StopAnimTask(PlayerPedId(), "missheist_jewel", "smash_case", 1.0)        
    IsSmashingVitrine = false
    EventsModule.TriggerServer('mercy-heists/server/jewellery/give-reward')
end)

Citizen.CreateThread(function()
    exports['mercy-ui']:AddEyeEntry("jewellery_vitrine_1", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 1.5,
        ZoneData = {
            Center = vector3(-625.78, -238.71, 38.06),
            Length = 2.2,
            Width = 1,
            Data = {
                heading = 305,
                minZ = 37.66,
                maxZ = 38.46
            }
        },
        Options = {
            {
                Name = 'heist_jewellery_panel',
                Icon = 'fas fa-circle',
                Label = 'Smash!',
                EventType = 'Client',
                EventName = 'mercy-heists/client/jewellery/smash-vitrine',
                EventParams = { VitrineId = 1 },
                Enabled = function(Entity)
                    if exports['mercy-heists']:GetJewelleryState() and exports['mercy-police']:GetTotalOndutyCops() >= exports['mercy-heists']:GetJewelleryCops() then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("jewellery_vitrine_2", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 1.5,
        ZoneData = {
            Center = vector3(-626.55, -234.64, 38.06),
            Length = 2.2,
            Width = 0.6,
            Data = {
                heading = 306,
                minZ = 37.66,
                maxZ = 38.46
            }
        },
        Options = {
            {
                Name = 'heist_jewellery_panel',
                Icon = 'fas fa-circle',
                Label = 'Smash!',
                EventType = 'Client',
                EventName = 'mercy-heists/client/jewellery/smash-vitrine',
                EventParams = { VitrineId = 2 },
                Enabled = function(Entity)
                    if exports['mercy-heists']:GetJewelleryState() and exports['mercy-police']:GetTotalOndutyCops() >= exports['mercy-heists']:GetJewelleryCops() then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("jewellery_vitrine_3", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 1.5,
        ZoneData = {
            Center = vector3(-627.18, -233.87, 38.06),
            Length = 2.2,
            Width = 0.6,
            Data = {
                heading = 306,
                minZ = 37.66,
                maxZ = 38.46
            }
        },
        Options = {
            {
                Name = 'heist_jewellery_panel',
                Icon = 'fas fa-circle',
                Label = 'Smash!',
                EventType = 'Client',
                EventName = 'mercy-heists/client/jewellery/smash-vitrine',
                EventParams = { VitrineId = 3 },
                Enabled = function(Entity)
                    if exports['mercy-heists']:GetJewelleryState() and exports['mercy-police']:GetTotalOndutyCops() >= exports['mercy-heists']:GetJewelleryCops() then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("jewellery_vitrine_4", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 1.5,
        ZoneData = {
            Center = vector3(-619.33, -234.53, 38.06),
            Length = 2.2,
            Width = 0.6,
            Data = {
                heading = 306,
                minZ = 37.66,
                maxZ = 38.46
            }
        },
        Options = {
            {
                Name = 'heist_jewellery_panel',
                Icon = 'fas fa-circle',
                Label = 'Smash!',
                EventType = 'Client',
                EventName = 'mercy-heists/client/jewellery/smash-vitrine',
                EventParams = { VitrineId = 4 },
                Enabled = function(Entity)
                    if exports['mercy-heists']:GetJewelleryState() and exports['mercy-police']:GetTotalOndutyCops() >= exports['mercy-heists']:GetJewelleryCops() then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("jewellery_vitrine_5", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 1.5,
        ZoneData = {
            Center = vector3(-617.42, -229.71, 38.06),
            Length = 2.2,
            Width = 0.6,
            Data = {
                heading = 216,
                minZ = 37.66,
                maxZ = 38.46
            }
        },
        Options = {
            {
                Name = 'heist_jewellery_panel',
                Icon = 'fas fa-circle',
                Label = 'Smash!',
                EventType = 'Client',
                EventName = 'mercy-heists/client/jewellery/smash-vitrine',
                EventParams = { VitrineId = 5 },
                Enabled = function(Entity)
                    if exports['mercy-heists']:GetJewelleryState() and exports['mercy-police']:GetTotalOndutyCops() >= exports['mercy-heists']:GetJewelleryCops() then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("jewellery_vitrine_6", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 1.5,
        ZoneData = {
            Center = vector3(-619.54, -226.82, 38.06),
            Length = 2.2,
            Width = 0.6,
            Data = {
                heading = 216,
                minZ = 37.66,
                maxZ = 38.46
            }
        },
        Options = {
            {
                Name = 'heist_jewellery_panel',
                Icon = 'fas fa-circle',
                Label = 'Smash!',
                EventType = 'Client',
                EventName = 'mercy-heists/client/jewellery/smash-vitrine',
                EventParams = { VitrineId = 6 },
                Enabled = function(Entity)
                    if exports['mercy-heists']:GetJewelleryState() and exports['mercy-police']:GetTotalOndutyCops() >= exports['mercy-heists']:GetJewelleryCops() then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("jewellery_vitrine_7", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 1.5,
        ZoneData = {
            Center = vector3(-624.72, -227.0, 38.06),
            Length = 2.2,
            Width = 0.6,
            Data = {
                heading = 126,
                minZ = 37.66,
                maxZ = 38.46
            }
        },
        Options = {
            {
                Name = 'heist_jewellery_panel',
                Icon = 'fas fa-circle',
                Label = 'Smash!',
                EventType = 'Client',
                EventName = 'mercy-heists/client/jewellery/smash-vitrine',
                EventParams = { VitrineId = 7 },
                Enabled = function(Entity)
                    if exports['mercy-heists']:GetJewelleryState() and exports['mercy-police']:GetTotalOndutyCops() >= exports['mercy-heists']:GetJewelleryCops() then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("jewellery_vitrine_8", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 1.5,
        ZoneData = {
            Center = vector3(-620.47, -232.97, 38.06),
            Length = 1.4,
            Width = 0.6,
            Data = {
                heading = 126,
                minZ = 37.66,
                maxZ = 38.66
            }
        },
        Options = {
            {
                Name = 'heist_jewellery_panel',
                Icon = 'fas fa-circle',
                Label = 'Smash!',
                EventType = 'Client',
                EventName = 'mercy-heists/client/jewellery/smash-vitrine',
                EventParams = { VitrineId = 8 },
                Enabled = function(Entity)
                    if exports['mercy-heists']:GetJewelleryState() and exports['mercy-police']:GetTotalOndutyCops() >= exports['mercy-heists']:GetJewelleryCops() then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("jewellery_vitrine_9", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 1.5,
        ZoneData = {
            Center = vector3(-620.11, -230.74, 38.06),
            Length = 1.4,
            Width = 0.6,
            Data = {
                heading = 36,
                minZ = 37.66,
                maxZ = 38.66
            }
        },
        Options = {
            {
                Name = 'heist_jewellery_panel',
                Icon = 'fas fa-circle',
                Label = 'Smash!',
                EventType = 'Client',
                EventName = 'mercy-heists/client/jewellery/smash-vitrine',
                EventParams = { VitrineId = 9 },
                Enabled = function(Entity)
                    if exports['mercy-heists']:GetJewelleryState() and exports['mercy-police']:GetTotalOndutyCops() >= exports['mercy-heists']:GetJewelleryCops() then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("jewellery_vitrine_10", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 1.5,
        ZoneData = {
            Center = vector3(-621.47, -229.05, 38.06),
            Length = 1.4,
            Width = 0.6,
            Data = {
                heading = 36,
                minZ = 37.66,
                maxZ = 38.66
            }
        },
        Options = {
            {
                Name = 'heist_jewellery_panel',
                Icon = 'fas fa-circle',
                Label = 'Smash!',
                EventType = 'Client',
                EventName = 'mercy-heists/client/jewellery/smash-vitrine',
                EventParams = { VitrineId = 10 },
                Enabled = function(Entity)
                    if exports['mercy-heists']:GetJewelleryState() and exports['mercy-police']:GetTotalOndutyCops() >= exports['mercy-heists']:GetJewelleryCops() then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("jewellery_vitrine_11", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 1.5,
        ZoneData = {
            Center = vector3(-623.62, -228.63, 38.06),
            Length = 1.4,
            Width = 0.6,
            Data = {
                heading = 306,
                minZ = 37.66,
                maxZ = 38.66
            }
        },
        Options = {
            {
                Name = 'heist_jewellery_panel',
                Icon = 'fas fa-circle',
                Label = 'Smash!',
                EventType = 'Client',
                EventName = 'mercy-heists/client/jewellery/smash-vitrine',
                EventParams = { VitrineId = 11 },
                Enabled = function(Entity)
                    if exports['mercy-heists']:GetJewelleryState() and exports['mercy-police']:GetTotalOndutyCops() >= exports['mercy-heists']:GetJewelleryCops() then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("jewellery_vitrine_12", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 1.5,
        ZoneData = {
            Center = vector3(-624.04, -230.82, 38.06),
            Length = 1.4,
            Width = 0.6,
            Data = {
                heading = 216,
                minZ = 37.66,
                maxZ = 38.66
            }
        },
        Options = {
            {
                Name = 'heist_jewellery_panel',
                Icon = 'fas fa-circle',
                Label = 'Smash!',
                EventType = 'Client',
                EventName = 'mercy-heists/client/jewellery/smash-vitrine',
                EventParams = { VitrineId = 12 },
                Enabled = function(Entity)
                    if exports['mercy-heists']:GetJewelleryState() and exports['mercy-police']:GetTotalOndutyCops() >= exports['mercy-heists']:GetJewelleryCops() then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("jewellery_vitrine_13", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 1.5,
        ZoneData = {
            Center = vector3(-622.53, -232.86, 38.06),
            Length = 1.4,
            Width = 0.6,
            Data = {
                heading = 216,
                minZ = 37.66,
                maxZ = 38.66
            }
        },
        Options = {
            {
                Name = 'heist_jewellery_panel',
                Icon = 'fas fa-circle',
                Label = 'Smash!',
                EventType = 'Client',
                EventName = 'mercy-heists/client/jewellery/smash-vitrine',
                EventParams = { VitrineId = 13 },
                Enabled = function(Entity)
                    if exports['mercy-heists']:GetJewelleryState() and exports['mercy-police']:GetTotalOndutyCops() >= exports['mercy-heists']:GetJewelleryCops() then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
end)

exports("GetJewelleryState", function()
    return Config.JewelleryState
end)

exports("GetJewelleryCops", function()
    return Config.JewelleryCops
end)
