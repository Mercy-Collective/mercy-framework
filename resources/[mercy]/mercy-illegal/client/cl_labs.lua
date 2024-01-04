
RegisterNetEvent('mercy-illegal/client/methLabs/sync-state', function(NewState, Id)
    Config.LabsState[Id] = NewState
end)

RegisterNetEvent('mercy-illegal/client/methLabs/cook-meth', function(Data)
    local CanCook = CallbackModule.SendCallback('mercy-illegal/server/methLabs/can-cook-meth', Data.Id)
    if CanCook then
        if exports['mercy-inventory']:HasEnoughOfItem(Data.RequestItem, Data.RequestItemAmount) then
            exports['mercy-inventory']:SetBusyState(true)
            exports['mercy-ui']:ProgressBar(Data.ProgressText, 4500, {['AnimName'] = Data.Animation, ['AnimDict'] = Data.AnimDict}, false, true, true, function(DidComplete)
                if DidComplete then
                    EventsModule.TriggerServer('mercy-illegal/server/methLabs/give-reward', Data.Item, Data.Amount, Data.RequestItem, Data.RequestItemAmount)
                    exports['mercy-inventory']:SetBusyState(false)
                end
            end)
        else
            exports['mercy-ui']:Notify("not-cooking", "you don't have enough items", 'error')
        end
    else
        exports['mercy-ui']:Notify("not-cooking", "Looks like there's no electricity", 'error')
    end
end)

RegisterNetEvent('mercy-illegal/client/methLabs/open-close', function(Data)
    EventsModule.TriggerServer('mercy-illegal/server/methLabs/set-open-close', Data.Id)
end)

Citizen.CreateThread(function()
    exports['mercy-ui']:AddEyeEntry("meth_lab_open_close", {
        Type = 'Zone',
        SpriteDistance = 1.61,
        Distance = 1.6,
        ZoneData = {
            Center = vector3(1060.02, -2315.77, 19.72),
            Length = 1.0,
            Width = 0.8,
            Data = {
                debugPoly = false,
                heading = 90,
                minZ = 18.72,
                maxZ = 20.92,
            },
        },
        Options = {
            {
                Name = 'methlab_1',
                Icon = '',
                Label = 'Mathlab Insurance',
                EventType = 'Client',
                EventName = 'mercy-illegal/client/methLabs/open-close',
                EventParams = { Id = 1 },
                Enabled = function(Entity)
                    if exports['mercy-inventory']:HasEnoughOfItem('methkey1', 1) then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })

    exports['mercy-ui']:AddEyeEntry("meth_lab_1_stage1", {
        Type = 'Zone',
        SpriteDistance = 1.61,
        Distance = 1.6,
        ZoneData = {
            Center = vector3(1059.59, -2319.35, 19.73),
            Length = 2.0,
            Width = 2.0,
            Data = {
                debugPoly = false,
                heading = 90,
                minZ = 18.72,
                maxZ = 21.33,
            },
        },
        Options = {
            {
                Name = 'methlab_1_stage1',
                Icon = '',
                Label = 'Collect X',
                EventType = 'Client',
                EventName = 'mercy-illegal/client/methLabs/cook-meth',
                EventParams = { Id = 1, Item = "xmadde", Amount = 1, RequestItem = "cleaningproduct", RequestItemAmount = 3, Animation = "base_a_m_y_vinewood_01", AnimDict = "anim@amb@casino@valet_scenario@pose_d@", ProgressText = "Collect X" },
                Enabled = function(Entity)
                    return true
                end,
            }
        }
    })

    exports['mercy-ui']:AddEyeEntry("meth_lab_1_stage2", {
        Type = 'Zone',
        SpriteDistance = 1.61,
        Distance = 1.6,
        ZoneData = {
            Center = vector3(1062.04, -2316.18, 19.72),
            Length = 2.0,
            Width = 1.0,
            Data = {
                debugPoly = false,
                heading = 90,
                minZ = 18.72,
                maxZ = 20.92,
            },
        },
        Options = {
            {
                Name = 'methlab_1_stage2',
                Icon = '',
                Label = 'Mix ingredients',
                EventType = 'Client',
                EventName = 'mercy-illegal/client/methLabs/cook-meth',
                EventParams = { Id = 1, Item = "mixidacid", Amount = 1, RequestItem = "xmadde", RequestItemAmount = 1, Animation = "gar_ig_5_filling_can", AnimDict = "timetable@gardener@filling_can", ProgressText = "Mixing" },
                Enabled = function(Entity)
                    return true
                end,
            }
        }
    })

    exports['mercy-ui']:AddEyeEntry("meth_lab_1_stage3", {
        Type = 'Zone',
        SpriteDistance = 1.61,
        Distance = 1.6,
        ZoneData = {
            Center = vector3(1065.76, -2317.4, 19.72),
            Length = 2.0,
            Width = 1.0,
            Data = {
                debugPoly = false,
                heading = 36,
                minZ = 18.72,
                maxZ = 20.32,
            },
        },
        Options = {
            {
                Name = 'methlab_1_stage3',
                Icon = '',
                Label = 'Cooking',
                EventType = 'Client',
                EventName = 'mercy-illegal/client/methLabs/cook-meth',
                EventParams = { Id = 1, Item = "methbrick", Amount = 1, RequestItem = "mixidacid", RequestItemAmount = 3, Animation = "fixing_a_player", AnimDict = "mini@repair", ProgressText = "Cooking" },
                Enabled = function(Entity)
                    return true
                end,
            }
        }
    })

    exports['mercy-ui']:AddEyeEntry("meth_lab_1_stage4", {
        Type = 'Zone',
        SpriteDistance = 1.61,
        Distance = 1.6,
        ZoneData = {
            Center = vector3(1056.98, -2318.83, 19.72),
            Length = 2.1,
            Width = 2.0,
            Data = {
                debugPoly = false,
                heading = 90,
                minZ = 18.72,
                maxZ = 20.72, 
            },
        },
        Options = {
            {
                Name = 'methlab_1_stage4',
                Icon = '',
                Label = 'Cooking',
                EventType = 'Client',
                EventName = 'mercy-illegal/client/methLabs/cook-meth',
                EventParams = { Id = 1, Item = "methcured", Amount = 3, RequestItem = "methbrick", RequestItemAmount = 1, Animation = "fixing_a_player", AnimDict = "mini@repair", ProgressText = "Cooking" },
                Enabled = function(Entity)
                    return true
                end,
            }
        }
    })

    exports['mercy-ui']:AddEyeEntry("meth_lab_1_stage5", {
        Type = 'Zone',
        SpriteDistance = 1.61,
        Distance = 1.6,
        ZoneData = {
            Center = vector3(1051.65, -2323.08, 19.72),
            Length = 2.4,
            Width = 1.0,
            Data = {
                debugPoly = false,
                heading = 90,
                minZ = 18.72,
                maxZ = 19.92,
            },
        },
        Options = {
            {
                Name = 'methlab_1_stage5',
                Icon = '',
                Label = 'packaging',
                EventType = 'Client',
                EventName = 'mercy-illegal/client/methLabs/cook-meth',
                EventParams = { Id = 1, Item = "methbatch", Amount = 1, RequestItem = "methcured", RequestItemAmount = 1, Animation = "urinal_sink_loop", AnimDict = "missheist_agency3aig_23", ProgressText = "Packaging" },
                Enabled = function(Entity)
                    return true
                end,
            }
        }
    })

    exports['mercy-ui']:AddEyeEntry("meth_lab_1_stage6", {
        Type = 'Zone',
        SpriteDistance = 1.61,
        Distance = 1.6,
        ZoneData = {
            Center = vector3(1059.76, -2323.25, 19.72),
            Length = 1.6,
            Width = 1.0,
            Data = {
                debugPoly = false,
                heading = 90,
                minZ = 18.72,
                maxZ = 21.12,
            },
        },
        Options = {
            {
                Name = 'methlab_1_stage6',
                Icon = '',
                Label = 'Rest the material',
                EventType = 'Client',
                EventName = 'mercy-illegal/client/methLabs/cook-meth',
                EventParams = { Id = 1, Item = "methbag", Amount = 1, RequestItem = "methbatch", RequestItemAmount = 1, Animation = "_idle_a", AnimDict = "random@shop_tattoo", ProgressText = "Sweet waiting" },
                Enabled = function(Entity)
                    return true
                end,
            }
        }
    })

end)

exports("GetLabsState", function(Id)
    return Config.LabsState[Id]
end)