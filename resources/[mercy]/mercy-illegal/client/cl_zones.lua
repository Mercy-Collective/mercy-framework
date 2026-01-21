local PlantProps = {'bkr_prop_weed_01_small_01b', 'bkr_prop_weed_med_01a', 'bkr_prop_weed_med_01b', 'bkr_prop_weed_lrg_01a', 'bkr_prop_weed_lrg_01b'}

function InitZones()
    Citizen.CreateThread(function()
        exports['mercy-polyzone']:CreateBox({
            center = vector3(844.26, -2881.01, 11.41), 
            length = 2.55, 
            width = 11.8,
        }, {
            name = 'crafting_bench',
            minZ = 10.41,
            maxZ = 13.01,
            heading = 0.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
        exports['mercy-ui']:AddEyeEntry(GetHashKey("gr_prop_gr_bench_04b"), {
            Type = 'Model',
            Model = 'gr_prop_gr_bench_04b',
            SpriteDistance = 5.0,
            Options = {
                {
                    Name = 'container_bench',
                    Icon = 'fas fa-tools',
                    Label = 'Crafting Bench',
                    EventType = 'Client',
                    EventName = 'mercy-illegal/client/open-crafting-bench',
                    EventParams = '',
                    Enabled = function(Entity)
                        if exports['mercy-illegal']:IsInsideBenchContainer() then
                            return true
                        end
                    end,
                },
            }
        })

        exports['mercy-ui']:AddEyeEntry("illegal-sells", {
            Type = 'Entity',
            EntityType = 'Ped',
            SpriteDistance = 10.0,
            Distance = 5.0,
            Position = vector4(-35.22, 1950.84, 189.50, 299.47),
            Model = 'a_m_m_farmer_01',
            Anim = {},
            Props = {},
            Options = {
                {
                    Name = 'illegal_pocket',
                    Icon = 'fas fa-box',
                    Label = 'Sell Something',
                    EventType = 'Client',
                    EventName = 'mercy-illegal/client/sell-something',
                    EventParams = {},
                    Enabled = function(Entity)
                        return true
                    end,
                }
            }
        })

        exports['mercy-ui']:AddEyeEntry(GetHashKey("v_res_tre_mixer"), {
            Type = 'Model',
            Model = 'v_res_tre_mixer',
            SpriteDistance = 5.0,
            Options = {
                {
                    Name = 'housing_meth_1',
                    Icon = 'fas fa-circle',
                    Label = 'Create the mix',
                    EventType = 'Client',
                    EventName = 'mercy-illegal/client/methLabs/cook-meth',
                    EventParams = { Id = 10, Item = "xmadde", Amount = 1, RequestItem = { {Name = "cleaningproduct", Amount = 3}, }, Animation = "base_a_m_y_vinewood_01", AnimDict = "anim@amb@casino@valet_scenario@pose_d@", ProgressText = "Mixing..." },
                    Enabled = function(Entity)
                        if exports['mercy-housing']:IsPlayerInHouse() then
                            return true
                        end
                    end,
                },
            }
        })
        exports['mercy-ui']:AddEyeEntry(GetHashKey("prop_cooker_03"), {
            Type = 'Model',
            Model = 'prop_cooker_03',
            SpriteDistance = 5.0,
            Options = {
                {
                    Name = 'housing_meth_2',
                    Icon = 'fas fa-circle',
                    Label = 'Cook the mixture',
                    EventType = 'Client',
                    EventName = 'mercy-illegal/client/methLabs/cook-meth',
                    EventParams = { Id = 10, Item = "methbrick", Amount = 1, RequestItem = { {Name = "xmadde", Amount = 3}, }, Animation = "fixing_a_player", AnimDict = "mini@repair", ProgressText = "Cooking..." },
                    Enabled = function(Entity)
                        if exports['mercy-housing']:IsPlayerInHouse() then
                            return true
                        end
                    end,
                },
            }
        })
        exports['mercy-ui']:AddEyeEntry(GetHashKey("v_ret_fh_pot01"), {
            Type = 'Model',
            Model = 'v_ret_fh_pot01',
            SpriteDistance = 5.0,
            Options = {
                {
                    Name = 'housing_meth_3',
                    Icon = 'fas fa-circle',
                    Label = 'Cool the mixture',
                    EventType = 'Client',
                    EventName = 'mercy-illegal/client/methLabs/cook-meth',
                    EventParams = { Id = 10, Item = "methcured", Amount = 3, RequestItem = { {Name = "methbrick", Amount = 1}, }, Animation = "fixing_a_player", AnimDict = "mini@repair", ProgressText = "Cooling Methbrick..." },
                    Enabled = function(Entity)
                        if exports['mercy-housing']:IsPlayerInHouse() then
                            return true
                        end
                    end,
                },
            }
        })
        exports['mercy-ui']:AddEyeEntry(GetHashKey("v_res_fa_chopbrd"), {
            Type = 'Model',
            Model = 'v_res_fa_chopbrd',
            SpriteDistance = 5.0,
            Options = {
                {
                    Name = 'housing_meth_4',
                    Icon = 'fas fa-circle',
                    Label = 'Crystallize the mixture',
                    EventType = 'Client',
                    EventName = 'mercy-illegal/client/methLabs/cook-meth',
                    EventParams = { Id = 10, Item = "methbatch", Amount = 1, RequestItem = { {Name = "methcured", Amount = 1}, {Name = 'emptybaggies', Amount = 1}, }, Animation = "urinal_sink_loop", AnimDict = "missheist_agency3aig_23", ProgressText = "Crystallize Meth..." },
                    Enabled = function(Entity)
                        if exports['mercy-housing']:IsPlayerInHouse() then
                            return true
                        end
                    end,
                },
            }
        })

        exports['mercy-ui']:AddEyeEntry("weed-dry-rack", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 4.0,
            ZoneData = {
                Center = vector3(3817.85, 4439.48, 2.81),
                Length = 1.3,
                Width = 1.5,
                Data = {
                    debugPoly = false, -- Optional, shows the box zone (Default: false)
                    heading = 0,
                    minZ = 1.11,
                    maxZ = 4.31
                },
            },
            Options = {
                {
                    Name = 'dry_rack_inventory',
                    Icon = 'fas fa-archive',
                    Label = 'Dry Rack',
                    EventType = 'Client',
                    EventName = 'mercy-illegal/client/open-dry-rack',
                    EventParams = {},
                    Enabled = function(Entity)
                        return true
                    end,
                },
                {
                    Name = 'dry_rack_start',
                    Icon = 'fas fa-play',
                    Label = 'Start Drying Process',
                    EventType = 'Server',
                    EventName = 'mercy-illegal/server/start-dry-process',
                    EventParams = {},
                    Enabled = function(Entity)
                        return true
                    end,
                }
            }
        })
        
        exports['mercy-ui']:AddEyeEntry("illegal-store", {
            Type = 'Entity',
            EntityType = 'Ped',
            SpriteDistance = 5.0,
            Distance = 5.0,
            Position = vector4(-1359.19, -759.73, 21.5, 341.57),
            Model = 'g_m_m_chicold_01',
            Anim = {},
            Props = {},
            Options = {
                {
                    Name = 'illegal-store',
                    Icon = 'fas fa-user-secret',
                    Label = 'Purchase Goods',
                    EventType = 'Client',
                    EventName = 'mercy-illegal/client/open-pickup-store',
                    EventParams = {},
                    Enabled = function(Entity)
                        return true
                    end,
                }
            }
        })

        for k, v in pairs(PlantProps) do
            exports['mercy-ui']:AddEyeEntry(GetHashKey(v), {
                Type = 'Model',
                Model = v,
                SpriteDistance = 1.0,
                Options = {
                    {
                        Name = 'plant_pick',
                        Icon = 'fas fa-sign-language',
                        Label = 'Pick Plant',
                        EventType = 'Client',
                        EventName = 'mercy-illegal/client/plants-pick-plant',
                        EventParams = '',
                        Enabled = function(Entity)
                            if exports['mercy-illegal']:IsPlantPickable(Entity) then
                                return true
                            else
                                return false
                            end
                        end,
                    },
                    {
                        Name = 'plant_check',
                        Icon = 'fas fa-cannabis',
                        Label = 'Check Plant',
                        EventType = 'Client',
                        EventName = 'mercy-illegal/client/plants-open-context',
                        EventParams = '',
                        Enabled = function(Entity)
                            return true
                        end,
                    },
                    {
                        Name = 'plant_destroy',
                        Icon = 'fas fa-cut',
                        Label = 'Destroy Plant',
                        EventType = 'Client',
                        EventName = 'mercy-illegal/client/plants-destroy',
                        EventParams = '',
                        Enabled = function(Entity)
                            local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
                            if Player.Job.Name == 'police' and Player.Job.Duty then
                                return true
                            else
                                return false
                            end
                        end,
                    }
                }
            })
        end

        -- Selling
        for k, v in pairs(Config.SellingList) do
            exports["mercy-ui"]:AddEyeEntry(v['Ped']['Id'], {
                Type = "Entity",
                EntityType = "Ped",
                SpriteDistance = v['Ped']['SpriteDistance'],
                Distance = v['Ped']['Distance'],
                Position = v['Ped']['Position'],
                Model = v['Ped']['Model'],
                Anim = v['Ped']['Anim'],
                Props = v['Ped']['Props'],
                Options = v['Options'],
            }) 
        end
    end)
end
