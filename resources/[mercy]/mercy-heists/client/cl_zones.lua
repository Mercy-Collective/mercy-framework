function InitZones()
    Citizen.CreateThread(function()
        -- Fleecas
        exports['mercy-ui']:AddEyeEntry("heists_panel_bank_one", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 2.5,
            ZoneData = {
                Center = vector3(147.22, -1046.24, 29.38),
                Length = 0.5,
                Width = 0.2,
                Data = {
                    debugPoly = false,
                    heading = 340.0,
                    minZ = 29.23,
                    maxZ = 29.93
                },
            },
            Options = {
                {
                    Name = 'heist_bank_panel',
                    Icon = 'fas fa-sort-numeric-up-alt',
                    Label = 'Hack Panel',
                    EventType = 'Client',
                    EventName = 'mercy-heists/client/try-panel-hack',
                    EventParams = {Panel = 1, Laptop = 'Green'},
                    Enabled = function(Entity)
                        if exports['mercy-inventory']:HasEnoughOfItem('heist-laptop-green', 1) and exports['mercy-police']:GetTotalOndutyCops() >= Config.BankCops then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("heists_panel_bank_two", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 2.5,
            ZoneData = {
                Center = vector3(311.57, -284.61, 54.17),
                Length = 0.5,
                Width = 0.2,
                Data = {
                    debugPoly = false,
                    heading = 340.0,
                    minZ = 54.02,
                    maxZ = 54.72
                },
            },
            Options = {
                {
                    Name = 'heist_bank_panel',
                    Icon = 'fas fa-sort-numeric-up-alt',
                    Label = 'Hack Panel',
                    EventType = 'Client',
                    EventName = 'mercy-heists/client/try-panel-hack',
                    EventParams = {Panel = 2, Laptop = 'Green'},
                    Enabled = function(Entity)
                        if exports['mercy-inventory']:HasEnoughOfItem('heist-laptop-green', 1) and exports['mercy-police']:GetTotalOndutyCops() >= Config.BankCops then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("heists_panel_bank_three", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 2.5,
            ZoneData = {
                Center = vector3(-353.5, -55.47, 49.05),
                Length = 0.45,
                Width = 0.2,
                Data = {
                    debugPoly = false,
                    heading = 340.0,
                    minZ = 48.9,
                    maxZ = 49.55
                },
            },
            Options = {
                {
                    Name = 'heist_bank_panel',
                    Icon = 'fas fa-sort-numeric-up-alt',
                    Label = 'Hack Panel',
                    EventType = 'Client',
                    EventName = 'mercy-heists/client/try-panel-hack',
                    EventParams = {Panel = 3, Laptop = 'Green'},
                    Enabled = function(Entity)
                        if exports['mercy-inventory']:HasEnoughOfItem('heist-laptop-green', 1) and exports['mercy-police']:GetTotalOndutyCops() >= Config.BankCops then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("heists_panel_bank_four", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 2.5,
            ZoneData = {
                Center = vector3(-1210.45, -336.44, 37.79),
                Length = 0.4,
                Width = 0.2,
                Data = {
                    debugPoly = false,
                    heading = 25.0,
                    minZ = 37.69,
                    maxZ = 38.29
                },
            },
            Options = {
                {
                    Name = 'heist_bank_panel',
                    Icon = 'fas fa-sort-numeric-up-alt',
                    Label = 'Hack Panel',
                    EventType = 'Client',
                    EventName = 'mercy-heists/client/try-panel-hack',
                    EventParams = {Panel = 4, Laptop = 'Green'},
                    Enabled = function(Entity)
                        if exports['mercy-inventory']:HasEnoughOfItem('heist-laptop-green', 1) and exports['mercy-police']:GetTotalOndutyCops() >= Config.BankCops then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("heists_panel_bank_five", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 2.5,
            ZoneData = {
                Center = vector3(-1303.63, -815.94, 17.3),
                Length = 0.4,
                Width = 0.2,
                Data = {
                    debugPoly = false,
                    heading = 36.0,
                    minZ = 17.3,
                    maxZ = 17.95
                },
            },
            Options = {
                {
                    Name = 'heist_bank_panel',
                    Icon = 'fas fa-sort-numeric-up-alt',
                    Label = 'Hack Panel',
                    EventType = 'Client',
                    EventName = 'mercy-heists/client/try-panel-hack',
                    EventParams = {Panel = 5, Laptop = 'Green'},
                    Enabled = function(Entity)
                        if exports['mercy-inventory']:HasEnoughOfItem('heist-laptop-green', 1) and exports['mercy-police']:GetTotalOndutyCops() >= Config.BankCops then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("heists_panel_bank_six", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 2.5,
            ZoneData = {
                Center = vector3(-2956.5, 482.12, 15.71),
                Length = 0.4,
                Width = 0.2,
                Data = {
                    debugPoly = false,
                    heading = 88.0,
                    minZ = 15.61,
                    maxZ = 16.21
                },
            },
            Options = {
                {
                    Name = 'heist_bank_panel',
                    Icon = 'fas fa-sort-numeric-up-alt',
                    Label = 'Hack Panel',
                    EventType = 'Client',
                    EventName = 'mercy-heists/client/try-panel-hack',
                    EventParams = {Panel = 6, Laptop = 'Green'},
                    Enabled = function(Entity)
                        if exports['mercy-inventory']:HasEnoughOfItem('heist-laptop-green', 1) and exports['mercy-police']:GetTotalOndutyCops() >= Config.BankCops then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("heists_panel_bank_seven", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 2.5,
            ZoneData = {
                Center = vector3(1175.69, 2712.9, 38.1),
                Length = 0.4,
                Width = 0.2,
                Data = {
                    debugPoly = false,
                    heading = 0.0,
                    minZ = 38.0,
                    maxZ = 38.6
                },
            },
            Options = {
                {
                    Name = 'heist_bank_panel',
                    Icon = 'fas fa-sort-numeric-up-alt',
                    Label = 'Hack Panel',
                    EventType = 'Client',
                    EventName = 'mercy-heists/client/try-panel-hack',
                    EventParams = {Panel = 7, Laptop = 'Green'},
                    Enabled = function(Entity)
                        if exports['mercy-inventory']:HasEnoughOfItem('heist-laptop-green', 1) and exports['mercy-police']:GetTotalOndutyCops() >= Config.BankCops then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("heists_panel_bank_eight", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 2.5,
            ZoneData = {
                Center = vector3(-105.89, 6472.13, 31.63),
                Length = 0.1,
                Width = 0.2,
                Data = {
                    debugPoly = false,
                    heading = 45.0,
                    minZ = 31.78,
                    maxZ = 31.98
                },
            },
            Options = {
                {
                    Name = 'heist_bank_panel',
                    Icon = 'fas fa-sort-numeric-up-alt',
                    Label = 'Hack Panel',
                    EventType = 'Client',
                    EventName = 'mercy-heists/client/try-panel-hack',
                    EventParams = {Panel = 8, Laptop = 'Green'},
                    Enabled = function(Entity)
                        if exports['mercy-inventory']:HasEnoughOfItem('heist-laptop-green', 1) and exports['mercy-police']:GetTotalOndutyCops() >= Config.BankCops then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        -- Trolly
        exports['mercy-ui']:AddEyeEntry(GetHashKey("ch_prop_ch_cash_trolly_01c"), {
            Type = 'Model',
            Model = 'ch_prop_ch_cash_trolly_01c',
            SpriteDistance = 3.0,
            Options = {
                {
                    Name = 'heist_trolly',
                    Icon = 'fas fa-hand-holding',
                    Label = 'Grab!',
                    EventType = 'Client',
                    EventName = 'mercy-heists/client/try-trolly-gabbing',
                    EventParams = 'Fleeca',
                    Enabled = function(Entity)
                        return true
                    end,
                },
            }
        })
        exports['mercy-ui']:AddEyeEntry(GetHashKey("ch_prop_gold_trolly_01c"), {
            Type = 'Model',
            Model = 'ch_prop_gold_trolly_01c',
            SpriteDistance = 3.0,
            Options = {
                {
                    Name = 'heist_trolly',
                    Icon = 'fas fa-hand-holding',
                    Label = 'Grab!',
                    EventType = 'Client',
                    EventName = 'mercy-heists/client/try-trolly-gabbing',
                    EventParams = 'Fleeca',
                    Enabled = function(Entity)
                        return true
                    end,
                },
            }
        })
        -- Store Robbery
        exports['mercy-ui']:AddEyeEntry(GetHashKey("prop_till_01"), {
            Type = 'Model',
            Model = 'prop_till_01',
            SpriteDistance = 3.0,
            Options = {
                {
                    Name = 'heist_steal_register',
                    Icon = 'fas fa-hammer',
                    Label = 'Smash!',
                    EventType = 'Client',
                    EventName = 'mercy-heists/client/stores-steal-register',
                    EventParams = '',
                    Enabled = function(Entity)
                        local Coords = GetEntityCoords(Entity)
                        if exports['mercy-heists']:GetRegisterIdByCoords(Coords) ~= nil then
                            return GetObjectFragmentDamageHealth(Entity, true) < 1.0
                        else
                            return false
                        end
                    end,
                },
                {
                    Name = 'heist_check_register',
                    Icon = 'fas fa-search',
                    Label = 'Inspect',
                    EventType = 'Client',
                    EventName = 'mercy-heists/client/stores-inspect-register',
                    EventParams = '',
                    Enabled = function(Entity)
                        local Coords = GetEntityCoords(Entity)
                        local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
                        if exports['mercy-heists']:GetRegisterIdByCoords(Coords) ~= nil then
                            if Player.Job.Name == 'police' and Player.Job.Duty then
                                return true
                            else
                                return false
                            end
                        else
                            return false
                        end
                    end,
                },
            }
        })
        -- Powerplant
        exports['mercy-ui']:AddEyeEntry("heists_panel_power", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 4.5,
            ZoneData = {
                Center = vector3(711.93, 165.25, 80.75),
                Length = 0.3,
                Width = 1.6,
                Data = {
                    debugPoly = false,
                    heading = 339.0,
                    minZ = 79.75,
                    maxZ = 82.55
                },
            },
            Options = {
                {
                    Name = 'heist_panel_power',
                    Icon = 'fas fa-plug',
                    Label = 'Bomb Power Panel',
                    EventType = 'Client',
                    EventName = 'mercy-heists/client/try-bomb-power-panel',
                    EventParams = '',
                    Enabled = function(Entity)
                        if exports['mercy-inventory']:HasEnoughOfItem('weapon_stickybomb', 1) then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        -- Bobcat
        exports['mercy-ui']:AddEyeEntry("heists_bobcat_steal_1", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 2.0,
            ZoneData = {
                Center = vector3(881.94, -2282.82, 30.47),
                Length = 1.8,
                Width = 0.4,
                Data = {
                    debugPoly = false,
                    heading = 335.0,
                    minZ = 29.47,
                    maxZ = 30.87
                },
            },
            Options = {
                {
                    Name = 'heist_bobcat_steal',
                    Icon = 'fas fa-sign-language',
                    Label = 'Steal Weapons',
                    EventType = 'Client',
                    EventName = 'mercy-heists/client/bobcat/steal-loot',
                    EventParams = 1,
                    Enabled = function(Entity)
                        if exports['mercy-heists']:CanLootSpot(1) then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("heists_bobcat_steal_2", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 2.0,
            ZoneData = {
                Center = vector3(886.82, -2282.01, 30.47),
                Length = 1.9,
                Width = 1.0,
                Data = {
                    debugPoly = false,
                    heading = 86.0,
                    minZ = 29.47,
                    maxZ = 30.47
                },
            },
            Options = {
                {
                    Name = 'heist_bobcat_steal',
                    Icon = 'fas fa-sign-language',
                    Label = 'Steal Weapons',
                    EventType = 'Client',
                    EventName = 'mercy-heists/client/bobcat/steal-loot',
                    EventParams = 2,
                    Enabled = function(Entity)
                        if exports['mercy-heists']:CanLootSpot(2) then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("heists_bobcat_steal_3", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 2.0,
            ZoneData = {
                Center = vector3(882.5, -2285.72, 30.47),
                Length = 1.9,
                Width = 0.4,
                Data = {
                    debugPoly = false,
                    heading = 250.0,
                    minZ = 29.47,
                    maxZ = 30.87
                },
            },
            Options = {
                {
                    Name = 'heist_bobcat_steal',
                    Icon = 'fas fa-sign-language',
                    Label = 'Steal Weapons',
                    EventType = 'Client',
                    EventName = 'mercy-heists/client/bobcat/steal-loot',
                    EventParams = 3,
                    Enabled = function(Entity)
                        if exports['mercy-heists']:CanLootSpot(3) then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("heists_bobcat_blow_door", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 2.5,
            ZoneData = {
                Center = vector3(890.54, -2284.7, 30.47),
                Length = 2.2,
                Width = 0.2,
                Data = {
                    debugPoly = false,
                    heading = 355.0,
                    minZ = 29.47,
                    maxZ = 32.07
                },
            },
            Options = {
                {
                    Name = 'heist_bobcat_steal',
                    Icon = 'fas fa-sign-language',
                    Label = 'Bomb Door',
                    EventType = 'Client',
                    EventName = 'mercy-heists/client/blow-bobcat-vault',
                    EventParams = '',
                    Enabled = function(Entity)
                        if exports['mercy-inventory']:HasEnoughOfItem('weapon_stickybomb', 1) then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
    end)
end