function InitZones()
    Citizen.CreateThread(function()
        -- Gallery
        exports['mercy-polyzone']:CreateBox({
            center = vector3(-468.9, 31.72, 46.23), 
            length = 1.0, 
            width = 1.6,
        }, {
            name = 'gallery-gem-ap',
            minZ = 45.23,
            maxZ = 47.43,
            heading = 356.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
        exports['mercy-ui']:AddEyeEntry("gallery_gem_stash", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 3.0,
            ZoneData = {
                Center = vector3(-466.68, 29.99, 46.23),
                Length = 0.6,
                Width = 1.2,
                Data = {
                    debugPoly = false,
                    heading = 355.0,
                    minZ = 45.23,
                    maxZ = 46.13
                },
            },
            Options = {
                {
                    Name = 'gallery_stash',
                    Icon = 'fas fa-archive',
                    Label = 'Stash',
                    EventType = 'Client',
                    EventName = 'mercy-business/client/open-stash',
                    EventParams = {Stash = 'gallery_gems', Business = 'Vultur Le Culture'},
                    Enabled = function(Entity)
                        if exports['mercy-business']:IsPlayerInBusiness('Vultur Le Culture') then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        -- Digital
        exports['mercy-ui']:AddEyeEntry("digital_den_stash", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 3.0,
            ZoneData = {
                Center = vector3(1131.17, -467.03, 66.49),
                Length = 2.0,
                Width = 0.4,
                Data = {
                    debugPoly = false,
                    heading = 346.0,
                    minZ = 65.49,
                    maxZ = 66.69
                },
            },
            Options = {
                {
                    Name = 'digital_stash',
                    Icon = 'fas fa-archive',
                    Label = 'Stash',
                    EventType = 'Client',
                    EventName = 'mercy-business/client/open-stash',
                    EventParams = {Stash = 'digital_electronics', Business = 'Digital Den'},
                    Enabled = function(Entity)
                        if exports['mercy-business']:IsPlayerInBusiness('Digital Den') then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("digital_den_table", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 3.0,
            ZoneData = {
                Center = vector3(1134.27, -468.79, 66.49),
                Length = 0.6,
                Width = 1.0,
                Data = {
                    debugPoly = false,
                    heading = 345.0,
                    minZ = 66.44,
                    maxZ = 66.64
                },
            },
            Options = {
                {
                    Name = 'digital_table',
                    Icon = 'fas fa-archive',
                    Label = 'Table',
                    EventType = 'Client',
                    EventName = 'mercy-business/client/digitalden/open-table',
                    EventParams = '',
                    Enabled = function(Entity)
                        return true
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("digital_den_craft", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 3.0,
            ZoneData = {
                Center = vector3(1134.85, -466.64, 66.49),
                Length = 0.4,
                Width = 0.4,
                Data = {
                    debugPoly = false,
                    heading = 346.0,
                    minZ = 66.34,
                    maxZ = 66.94
                },
            },
            Options = {
                {
                    Name = 'digital_craft',
                    Icon = 'fas fa-tools',
                    Label = 'Craft',
                    EventType = 'Client',
                    EventName = 'mercy-business/client/digitalden/craft',
                    EventParams = '',
                    Enabled = function(Entity)
                        if exports['mercy-business']:IsPlayerInBusiness('Digital Den') and exports['mercy-business']:HasPlayerBusinessPermission('Digital Den', 'craft_access') then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        -- Hayes
        exports['mercy-polyzone']:CreateBox({
            center = vector3(-1421.15, -444.04, 35.59), 
            length = 30.0, 
            width = 21.2,
        }, {
            name = 'hayes-zone',
            minZ = 34.59,
            maxZ = 38.79,
            heading = 302.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
        exports['mercy-ui']:AddEyeEntry("hayes_station_1", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 4.0,
            ZoneData = {
                Center = vector3(-1421.81, -456.47, 35.91),
                Length = 0.7,
                Width = 1.5,
                Data = {
                    debugPoly = false,
                    heading = 32.0,
                    minZ = 35.91,
                    maxZ = 36.26
                },
            },
            Options = {
                {
                    Name = 'hayes_stash',
                    Icon = 'fas fa-archive',
                    Label = 'Stash',
                    EventType = 'Client',
                    EventName = 'mercy-business/client/open-stash',
                    EventParams = {Stash = 'hayes_storage', Business = 'Hayes Repairs'},
                    Enabled = function(Entity)
                        if exports['mercy-business']:IsPlayerInBusiness('Hayes Repairs') and exports['mercy-business']:HasPlayerBusinessPermission('Hayes Repairs', 'stash_access') then
                            return true
                        else
                            return false
                        end
                    end,
                },
                {
                    Name = 'hayes_craft',
                    Icon = 'fas fa-tools',
                    Label = 'Craft',
                    EventType = 'Client',
                    EventName = 'mercy-business/client/hayes/craft',
                    EventParams = { Business = "Hayes Repairs" },
                    Enabled = function(Entity)
                        if exports['mercy-business']:IsPlayerInBusiness('Hayes Repairs') and exports['mercy-business']:HasPlayerBusinessPermission('Hayes Repairs', 'craft_access') then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("hayes_station_2", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 4.0,
            ZoneData = {
                Center = vector3(-1415.2, -452.36, 35.91),
                Length = 0.7,
                Width = 1.5,
                Data = {
                    debugPoly = false,
                    heading = 32.0,
                    minZ = 35.91,
                    maxZ = 36.31
                },
            },
            Options = {
                {
                    Name = 'hayes_stash',
                    Icon = 'fas fa-archive',
                    Label = 'Stash',
                    EventType = 'Client',
                    EventName = 'mercy-business/client/open-stash',
                    EventParams = {Stash = 'hayes_storage', Business = 'Hayes Repairs'},
                    Enabled = function(Entity)
                        if exports['mercy-business']:IsPlayerInBusiness('Hayes Repairs') and exports['mercy-business']:HasPlayerBusinessPermission('Hayes Repairs', 'stash_access') then
                            return true
                        else
                            return false
                        end
                    end,
                },
                {
                    Name = 'hayes_craft',
                    Icon = 'fas fa-tools',
                    Label = 'Craft',
                    EventType = 'Client',
                    EventName = 'mercy-business/client/hayes/craft',
                    EventParams = { Business = "Hayes Repairs" },
                    Enabled = function(Entity)
                        if exports['mercy-business']:IsPlayerInBusiness('Hayes Repairs') and exports['mercy-business']:HasPlayerBusinessPermission('Hayes Repairs', 'craft_access') then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("hayes_station_3", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 4.0,
            ZoneData = {
                Center = vector3(-1408.3, -448.01, 35.91),
                Length = 0.7,
                Width = 1.5,
                Data = {
                    debugPoly = false,
                    heading = 32.0,
                    minZ = 35.91,
                    maxZ = 36.31
                },
            },
            Options = {
                {
                    Name = 'hayes_stash',
                    Icon = 'fas fa-archive',
                    Label = 'Stash',
                    EventType = 'Client',
                    EventName = 'mercy-business/client/open-stash',
                    EventParams = {Stash = 'hayes_storage', Business = 'Hayes Repairs'},
                    Enabled = function(Entity)
                        if exports['mercy-business']:IsPlayerInBusiness('Hayes Repairs') and exports['mercy-business']:HasPlayerBusinessPermission('Hayes Repairs', 'stash_access') then
                            return true
                        else
                            return false
                        end
                    end,
                },
                {
                    Name = 'hayes_craft',
                    Icon = 'fas fa-tools',
                    Label = 'Craft',
                    EventType = 'Client',
                    EventName = 'mercy-business/client/hayes/craft',
                    EventParams = { Business = "Hayes Repairs" },
                    Enabled = function(Entity)
                        if exports['mercy-business']:IsPlayerInBusiness('Hayes Repairs') and exports['mercy-business']:HasPlayerBusinessPermission('Hayes Repairs', 'craft_access') then
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

function InitFoodzones()
    Citizen.CreateThread(function()
        exports['mercy-ui']:AddEyeEntry("burgershot_storage_hot", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 3.0,
            ZoneData = {
                Center = vector3(-1197.34, -894.53, 13.98),
                Length = 1.45,
                Width = 0.4,
                Data = {
                    debugPoly = false,
                    heading = 34.0,
                    minZ = 14.08,
                    maxZ = 14.48
                },
            },
            Options = {
                {
                    Name = 'burgershot_storage_hot',
                    Icon = 'fas fa-utensils',
                    Label = 'Hot Storage',
                    EventType = 'Client',
                    EventName = 'mercy-business/client/foodchain/open-storage',
                    EventParams = 'burger_hot',
                    Enabled = function(Entity)
                        local ClockData = exports['mercy-business']:GetClockedData()
                        if ClockData.Business == 'Burger Shot' and ClockData.Clocked and exports['mercy-business']:HasPlayerBusinessPermission('Burger Shot', 'stash_access') then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("burgershot_storage_cold", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 3.0,
            ZoneData = {
                Center = vector3(-1196.7, -901.85, 13.98),
                Length = 0.3,
                Width = 1.45,
                Data = {
                    debugPoly = false,
                    heading = 35.0,
                    minZ = 13.38,
                    maxZ = 15.08
                },
            },
            Options = {
                {
                    Name = 'burgershot_storage_cold',
                    Icon = 'fas fa-utensils',
                    Label = 'Cold Storage',
                    EventType = 'Client',
                    EventName = 'mercy-business/client/foodchain/open-storage',
                    EventParams = 'burger_cold',
                    Enabled = function(Entity)
                        local ClockData = exports['mercy-business']:GetClockedData()
                        if ClockData.Business == 'Burger Shot' and ClockData.Clocked and exports['mercy-business']:HasPlayerBusinessPermission('Burger Shot', 'stash_access') then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("burgershot_storage_ice", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 3.0,
            ZoneData = {
                Center = vector3(-1193.01, -895.76, 13.98),
                Length = 1.55,
                Width = 0.55,
                Data = {
                    debugPoly = false,
                    heading = 34.0,
                    minZ = 13.83,
                    maxZ = 14.43
                },
            },
            Options = {
                {
                    Name = 'burgershot_storage_ice',
                    Icon = 'fas fa-ice-cream',
                    Label = 'Ice Storage',
                    EventType = 'Client',
                    EventName = 'mercy-business/client/foodchain/open-storage',
                    EventParams = 'burger_ice',
                    Enabled = function(Entity)
                        local ClockData = exports['mercy-business']:GetClockedData()
                        if ClockData.Business == 'Burger Shot' and ClockData.Clocked and exports['mercy-business']:HasPlayerBusinessPermission('Burger Shot', 'stash_access') then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("burgershot_meat_cooker", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 3.0,
            ZoneData = {
                Center = vector3(-1201.92, -898.69, 13.98),
                Length = 1.65,
                Width = 0.8,
                Data = {
                    debugPoly = false,
                    heading = 34.0,
                    minZ = 13.88,
                    maxZ = 14.13
                },
            },
            Options = {
                {
                    Name = 'burgershot_side_dish',
                    Icon = 'fas fa-utensils',
                    Label = 'Prepare Food',
                    EventType = 'Client',
                    EventName = 'mercy-business/client/foodchain/prepare-meal',
                    EventParams = 'Side',
                    Enabled = function(Entity)
                        local ClockData = exports['mercy-business']:GetClockedData()
                        if ClockData.Business == 'Burger Shot' and ClockData.Clocked and exports['mercy-business']:HasPlayerBusinessPermission('Burger Shot', 'craft_access') then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("burgershot_machine_drinks", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 3.0,
            ZoneData = {
                Center = vector3(-1200.0, -895.43, 13.98),
                Length = 1.1,
                Width = 0.9,
                Data = {
                    debugPoly = false,
                    heading = 34.0,
                    minZ = 13.98,
                    maxZ = 14.78
                },
            },
            Options = {
                {
                    Name = 'burgershot_machine_drinks',
                    Icon = 'fas fa-wine-bottle',
                    Label = 'Drinks Machine',
                    EventType = 'Client',
                    EventName = 'mercy-business/client/foodchain/prepare-meal',
                    EventParams = 'Drink',
                    Enabled = function(Entity)
                        local ClockData = exports['mercy-business']:GetClockedData()
                        if ClockData.Business == 'Burger Shot' and ClockData.Clocked and exports['mercy-business']:HasPlayerBusinessPermission('Burger Shot', 'craft_access') then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("burgershot_create_food", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 3.0,
            ZoneData = {
                Center = vector3(-1198.62, -897.61, 13.98),
                Length = 0.85,
                Width = 0.6,
                Data = {
                    debugPoly = false,
                    heading = 35.0,
                    minZ = 13.88,
                    maxZ = 14.08
                },
            },
            Options = {
                {
                    Name = 'burgershot_food',
                    Icon = 'fas fa-hamburger',
                    Label = 'Make Food',
                    EventType = 'Client',
                    EventName = 'mercy-business/client/foodchain/prepare-meal',
                    EventParams = 'Main',
                    Enabled = function(Entity)
                        local ClockData = exports['mercy-business']:GetClockedData()
                        if ClockData.Business == 'Burger Shot' and ClockData.Clocked and exports['mercy-business']:HasPlayerBusinessPermission('Burger Shot', 'craft_access') then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("burgershot_teller1", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 3.0,
            ZoneData = {
                Center = vector3(-1194.23, -893.86, 13.98),
                Length = 0.55,
                Width = 0.45,
                Data = {
                    debugPoly = false,
                    heading = 34.0,
                    minZ = 13.83,
                    maxZ = 14.43
                },
            },
            Options = {
                {
                    Name = 'burgershot_teller_option_one',
                    Icon = 'fas fa-cash-register',
                    Label = 'Make Payment',
                    EventType = 'Client',
                    EventName = 'mercy-business/client/foodchain/pay-menu',
                    EventParams = { Foodchain = "Burger Shot", RegisterId = 1 },
                    Enabled = function(Entity)
                        return true
                    end,
                },
                {
                    Name = 'burgershot_teller_option_two',
                    Icon = 'fas fa-credit-card',
                    Label = 'Charge Customer',
                    EventType = 'Client',
                    EventName = 'mercy-business/client/foodchain/order-menu',
                    EventParams = { RegisterId = 1 },
                    Enabled = function(Entity)
                        local ClockData = exports['mercy-business']:GetClockedData()
                        if ClockData.Business == 'Burger Shot' and ClockData.Clocked and exports['mercy-business']:HasPlayerBusinessPermission('Burger Shot', 'charge_external') then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("burgershot_teller2", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 3.0,
            ZoneData = {
                Center = vector3(-1195.28, -892.35, 13.98),
                Length = 0.55,
                Width = 0.45,
                Data = {
                    debugPoly = false,
                    heading = 34.0,
                    minZ = 13.83,
                    maxZ = 14.43
                },
            },
            Options = {
                {
                    Name = 'burgershot_teller_option_one',
                    Icon = 'fas fa-cash-register',
                    Label = 'Make Payment',
                    EventType = 'Client',
                    EventName = 'mercy-business/client/foodchain/pay-menu',
                    EventParams = { Foodchain = "Burger Shot", RegisterId = 2 },
                    Enabled = function(Entity)
                        return true
                    end,
                },
                {
                    Name = 'burgershot_teller_option_two',
                    Icon = 'fas fa-credit-card',
                    Label = 'Charge Customer',
                    EventType = 'Client',
                    EventName = 'mercy-business/client/foodchain/order-menu',
                    EventParams = { RegisterId = 2 },
                    Enabled = function(Entity)
                        local ClockData = exports['mercy-business']:GetClockedData()
                        if ClockData.Business == 'Burger Shot' and ClockData.Clocked and exports['mercy-business']:HasPlayerBusinessPermission('Burger Shot', 'charge_external') then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("burgershot_check_in", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 3.0,
            ZoneData = {
                Center = vector3(-1191.51, -900.59, 13.98),
                Length = 1.2,
                Width = 0.2,
                Data = {
                    debugPoly = false,
                    heading = 34.0,
                    minZ = 14.18,
                    maxZ = 15.33
                },
            },
            Options = {
                {
                    Name = 'burgershot_check_in',
                    Icon = 'fas fa-clock',
                    Label = 'Clock In',
                    EventType = 'Server',
                    EventName = 'mercy-business/server/foodchain/set-duty',
                    EventParams = {Business = 'Burger Shot', Clocked = true},
                    Enabled = function(Entity)
                        local ClockData = exports['mercy-business']:GetClockedData()
                        if exports['mercy-business']:IsPlayerInBusiness('Burger Shot') and not ClockData.Clocked then
                            return true
                        else
                            return false
                        end
                    end,
                },
                {
                    Name = 'burgershot_check_out',
                    Icon = 'fas fa-clock',
                    Label = 'Clock Out',
                    EventType = 'Server',
                    EventName = 'mercy-business/server/foodchain/set-duty',
                    EventParams = {Business = 'None', Clocked = false},
                    Enabled = function(Entity)
                        local ClockData = exports['mercy-business']:GetClockedData()
                        if exports['mercy-business']:IsPlayerInBusiness('Burger Shot') and ClockData.Clocked then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("burgershot_foodtray", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 2.0,
            ZoneData = {
                Center = vector3(-1194.93, -892.87, 13.98),
                Length = 0.6,
                Width = 0.4,
                Data = {
                    debugPoly = false,
                    heading = 35.0,
                    minZ = 14.03,
                    maxZ = 14.23
                },
            },
            Options = {
                {
                    Name = 'burgershot_plate',
                    Icon = 'fas fa-box',
                    Label = 'Food Tray',
                    EventType = 'Client',
                    EventName = 'mercy-business/client/foodchain/open-storage',
                    EventParams = 'bs-food-tray',
                    Enabled = function(Entity)
                        return true
                    end,
                }
            }
        })
    end)
    -- UWU
    exports['mercy-ui']:AddEyeEntry("uwu_check_in", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 3.0,
        ZoneData = {
            Center = vector3(-594.2, -1052.47, 22.34),
            Length = 1.8,
            Width = 0.2,
            Data = {
                debugPoly = false,
                heading = 0,
                minZ = 22.34,
                maxZ = 23.74
            },
        },
        Options = {
            {
                Name = 'uwu_check_in',
                Icon = 'fas fa-clock',
                Label = 'Clock In',
                EventType = 'Server',
                EventName = 'mercy-business/server/foodchain/set-duty',
                EventParams = {Business = 'UwU Café', Clocked = true},
                Enabled = function(Entity)
                    local ClockData = exports['mercy-business']:GetClockedData()
                    if exports['mercy-business']:IsPlayerInBusiness('UwU Café') and not ClockData.Clocked then
                        return true
                    else
                        return false
                    end
                end,
            },
            {
                Name = 'uwu_check_out',
                Icon = 'fas fa-clock',
                Label = 'Clock Out',
                EventType = 'Server',
                EventName = 'mercy-business/server/foodchain/set-duty',
                EventParams = {Business = 'None', Clocked = false},
                Enabled = function(Entity)
                    local ClockData = exports['mercy-business']:GetClockedData()
                    if exports['mercy-business']:IsPlayerInBusiness('UwU Café') and ClockData.Clocked then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("uwu1", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 3.0,
        ZoneData = {
            Center = vector3(-590.97, -1056.51, 22.36),
            Length = 0.8,
            Width = 0.6,
            Data = {
                debugPoly = false,
                heading = 0,
                minZ = 22.21,
                maxZ = 22.41
            },
        },
        Options = {
            {
                Name = 'uwu1',
                Icon = 'fas fa-wine-bottle',
                Label = 'Coffee Machine',
                EventType = 'Client',
                EventName = 'mercy-business/client/foodchain/prepare-meal',
                EventParams = 'Main',
                Enabled = function(Entity)
                    local ClockData = exports['mercy-business']:GetClockedData()
                    if ClockData.Business == 'UwU Café' and ClockData.Clocked and exports['mercy-business']:HasPlayerBusinessPermission('UwU Café', 'craft_access') then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("uwu2", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 3.0,
        ZoneData = {
            Center = vector3(-591.21, -1063.16, 22.36),
            Length = 1.6,
            Width = 1.0,
            Data = {
                debugPoly = false,
                heading = 0,
                minZ = 22.16,
                maxZ = 22.56
            },
        },
        Options = {
            {
                Name = 'uwu2',
                Icon = 'fas fa-wine-bottle',
                Label = 'Coffee Machine',
                EventType = 'Client',
                EventName = 'mercy-business/client/foodchain/prepare-meal',
                EventParams = 'Side',
                Enabled = function(Entity)
                    local ClockData = exports['mercy-business']:GetClockedData()
                    if ClockData.Business == 'UwU Café' and ClockData.Clocked and exports['mercy-business']:HasPlayerBusinessPermission('UwU Café', 'craft_access') then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("uwu3", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 3.0,
        ZoneData = {
            Center = vector3(-587.02, -1061.82, 22.34),
            Length = 1.0,
            Width = 1.0,
            Data = {
                debugPoly = false,
                heading = 0,
                minZ = 22.14,
                maxZ = 22.94
            },
        },
        Options = {
            {
                Name = 'uwu2',
                Icon = 'fas fa-wine-bottle',
                Label = 'Coffee Machine',
                EventType = 'Client',
                EventName = 'mercy-business/client/foodchain/prepare-meal',
                EventParams = 'Drink',
                Enabled = function(Entity)
                    local ClockData = exports['mercy-business']:GetClockedData()
                    if ClockData.Business == 'UwU Café' and ClockData.Clocked and exports['mercy-business']:HasPlayerBusinessPermission('UwU Café', 'craft_access') then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("uwu4", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 3.0,
        ZoneData = {
            Center = vector3(-590.94, -1059.73, 22.34),
            Length = 1.2,
            Width = 1.0,
            Data = {
                debugPoly = false,
                heading = 0,
                minZ = 21.34,
                maxZ = 23.74
            },
        },
        Options = {
            {
                Name = 'uwu4',
                Icon = 'fas fa-wine-bottle',
                Label = 'Coffee Machine',
                EventType = 'Client',
                EventName = 'mercy-business/client/foodchain/prepare-meal',
                EventParams = 'uwu_dessert',
                Enabled = function(Entity)
                    local ClockData = exports['mercy-business']:GetClockedData()
                    if ClockData.Business == 'UwU Café' and ClockData.Clocked and exports['mercy-business']:HasPlayerBusinessPermission('UwU Café', 'craft_access') then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("uwu_teller1", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 3.0,
        ZoneData = {
            Center = vector3(-584.08, -1058.72, 22.34),
            Length = 0.6,
            Width = 1.2,
            Data = {
                debugPoly = false,
                heading = 0,
                minZ = 22.34,
                maxZ = 22.74
            },
        },
        Options = {
            {
                Name = 'uwu_teller_option_one',
                Icon = 'fas fa-cash-register',
                Label = 'Make Payment',
                EventType = 'Client',
                EventName = 'mercy-business/client/foodchain/pay-menu',
                EventParams = { Foodchain = "UwU Cafe", RegisterId = 1 },
                Enabled = function(Entity)
                    return true
                end,
            },
            {
                Name = 'uwu_teller_option_two',
                Icon = 'fas fa-credit-card',
                Label = 'Charge Customer',
                EventType = 'Client',
                EventName = 'mercy-business/client/foodchain/order-menu',
                EventParams = { RegisterId = 1 },
                Enabled = function(Entity)
                    local ClockData = exports['mercy-business']:GetClockedData()
                    if ClockData.Business == 'UwU Café' and ClockData.Clocked and exports['mercy-business']:HasPlayerBusinessPermission('UwU Café', 'charge_external') then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("uwu_teller2", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 3.0,
        ZoneData = {
            Center = vector3(-584.02, -1061.48, 22.34),
            Length = 0.6,
            Width = 1.0,
            Data = {
                debugPoly = false,
                heading = 0,
                minZ = 22.34,
                maxZ = 22.74
            },
        },
        Options = {
            {
                Name = 'uwu_teller_option_one',
                Icon = 'fas fa-cash-register',
                Label = 'Make Payment',
                EventType = 'Client',
                EventName = 'mercy-business/client/foodchain/pay-menu',
                EventParams = { Foodchain = "UwU Cafe", RegisterId = 2 },
                Enabled = function(Entity)
                    return true
                end,
            },
            {
                Name = 'uwu_teller_option_two',
                Icon = 'fas fa-credit-card',
                Label = 'Charge Customer',
                EventType = 'Client',
                EventName = 'mercy-business/client/foodchain/order-menu',
                EventParams = { RegisterId = 2 },
                Enabled = function(Entity)
                    local ClockData = exports['mercy-business']:GetClockedData()
                    if ClockData.Business == 'UwU Café' and ClockData.Clocked and exports['mercy-business']:HasPlayerBusinessPermission('UwU Café', 'charge_external') then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("uwu_cafe_table", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 3.0,
        ZoneData = {
            Center = vector3(-587.33, -1059.59, 22.34),
            Length = 2.4,
            Width = 1.2,
            Data = {
                debugPoly = false,
                heading = 0,
                minZ = 22.24,
                maxZ = 22.74
            },
        },
        Options = {
            {
                Name = 'uwu_table',
                Icon = 'fas fa-archive',
                Label = 'Table',
                EventType = 'Client',
                EventName = 'mercy-business/client/uwucafe/open-table',
                EventParams = '',
                Enabled = function(Entity)
                    return true
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("uwu_cafe_fridge_1", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 3.0,
        ZoneData = {
            Center = vector3(-590.6, -1058.59, 22.34),
            Length = 1.2,
            Width = 0.2,
            Data = {
                debugPoly = false,
                heading = 0,
                minZ = 21.34,
                maxZ = 23.54
            },
        },
        Options = {
            {
                Name = 'uwu_cafe_fridge_1',
                Icon = 'fas fa-ice-cream',
                Label = 'Fridge',
                EventType = 'Client',
                EventName = 'mercy-business/client/foodchain/open-storage',
                EventParams = 'uwu_ice_1',
                Enabled = function(Entity)
                    local ClockData = exports['mercy-business']:GetClockedData()
                    if ClockData.Business == 'UwU Café' and ClockData.Clocked and exports['mercy-business']:HasPlayerBusinessPermission('UwU Café', 'stash_access') then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("uwu_cafe_fridge_2", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 3.0,
        ZoneData = {
            Center = vector3(-587.98, -1067.06, 22.34),
            Length = 1.6,
            Width = 0.8,
            Data = {
                debugPoly = false,
                heading = 0,
                minZ = 21.74,
                maxZ = 23.14
            },
        },
        Options = {
            {
                Name = 'uwu_cafe_fridge_2',
                Icon = 'fas fa-ice-cream',
                Label = 'Fridge',
                EventType = 'Client',
                EventName = 'mercy-business/client/foodchain/open-storage',
                EventParams = 'uwu_ice_2',
                Enabled = function(Entity)
                    local ClockData = exports['mercy-business']:GetClockedData()
                    if ClockData.Business == 'UwU Café' and ClockData.Clocked and exports['mercy-business']:HasPlayerBusinessPermission('UwU Café', 'stash_access') then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
    -- Pizza This
    exports['mercy-ui']:AddEyeEntry("pizzaThis_check_in", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 3.0,
        ZoneData = {
            Center = vector3(811.83, -756.51, 26.78),
            Length = 0.4,
            Width = 1.8,
            Data = {
                debugPoly = false,
                heading = 0,
                minZ = 26.78,
                maxZ = 28.18
            },
        },
        Options = {
            {
                Name = 'pizzaThis_check_in',
                Icon = 'fas fa-clock',
                Label = 'Clock In',
                EventType = 'Server',
                EventName = 'mercy-business/server/foodchain/set-duty',
                EventParams = {Business = 'Pizza This', Clocked = true},
                Enabled = function(Entity)
                    local ClockData = exports['mercy-business']:GetClockedData()
                    if exports['mercy-business']:IsPlayerInBusiness('Pizza This') and not ClockData.Clocked then
                        return true
                    else
                        return false
                    end
                end,
            },
            {
                Name = 'pizzaThis_check_out',
                Icon = 'fas fa-clock',
                Label = 'Clock Out',
                EventType = 'Server',
                EventName = 'mercy-business/server/foodchain/set-duty',
                EventParams = {Business = 'None', Clocked = false},
                Enabled = function(Entity)
                    local ClockData = exports['mercy-business']:GetClockedData()
                    if exports['mercy-business']:IsPlayerInBusiness('Pizza This') and ClockData.Clocked then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("pizzaThis1", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 3.0,
        ZoneData = {
            Center = vector3(808.24, -757.06, 26.78),
            Length = 0.8,
            Width = 0.4,
            Data = {
                debugPoly = false,
                heading = 265,
                minZ = 26.43,
                maxZ = 26.83
            },
        },
        Options = {
            {
                Name = 'pizzaThis1',
                Icon = 'fas fa-hamburger',
                Label = 'Main Dishes',
                EventType = 'Client',
                EventName = 'mercy-business/client/foodchain/prepare-meal',
                EventParams = 'Main',
                Enabled = function(Entity)
                    local ClockData = exports['mercy-business']:GetClockedData()
                    if ClockData.Business == 'Pizza This' and ClockData.Clocked and exports['mercy-business']:HasPlayerBusinessPermission('Pizza This', 'craft_access') then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("pizzaThis2", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 3.0,
        ZoneData = {
            Center = vector3(810.56, -765.0, 26.78),
            Length = 0.7,
            Width = 0.7,
            Data = {
                debugPoly = false,
                heading = 265,
                minZ = 26.43,
                maxZ = 26.83
            },
        },
        Options = {
            {
                Name = 'pizzaThis2',
                Icon = 'fas fa-utensils',
                Label = 'Side Dishes',
                EventType = 'Client',
                EventName = 'mercy-business/client/foodchain/prepare-meal',
                EventParams = 'Side',
                Enabled = function(Entity)
                    local ClockData = exports['mercy-business']:GetClockedData()
                    if ClockData.Business == 'Pizza This' and ClockData.Clocked and exports['mercy-business']:HasPlayerBusinessPermission('Pizza This', 'craft_access') then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("pizzaThis3", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 3.0,
        ZoneData = {
            Center = vector3(811.16, -764.37, 26.78),
            Length = 0.7,
            Width = 0.7,
            Data = {
                debugPoly = false,
                heading = 265,
                minZ = 26.43,
                maxZ = 26.83
            },
        },
        Options = {
            {
                Name = 'pizzaThis3',
                Icon = 'fas fa-wine-bottle',
                Label = 'Drinks',
                EventType = 'Client',
                EventName = 'mercy-business/client/foodchain/prepare-meal',
                EventParams = 'Drink',
                Enabled = function(Entity)
                    local ClockData = exports['mercy-business']:GetClockedData()
                    if ClockData.Business == 'Pizza This' and ClockData.Clocked and exports['mercy-business']:HasPlayerBusinessPermission('Pizza This', 'craft_access') then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("pizzaThis4", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 3.0,
        ZoneData = {
            Center = vector3(808.27, -762.25, 26.78),
            Length = 0.7,
            Width = 0.7,
            Data = {
                debugPoly = false,
                heading = 265,
                minZ = 26.43,
                maxZ = 26.83
            },
        },
        Options = {
            {
                Name = 'pizzaThis4',
                Icon = 'fa-cake-candles',
                Label = 'Dessert',
                EventType = 'Client',
                EventName = 'mercy-business/client/foodchain/prepare-meal',
                EventParams = 'Dessert',
                Enabled = function(Entity)
                    local ClockData = exports['mercy-business']:GetClockedData()
                    if ClockData.Business == 'Pizza This' and ClockData.Clocked and exports['mercy-business']:HasPlayerBusinessPermission('Pizza This', 'craft_access') then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("pizzaThis_teller1", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 3.0,
        ZoneData = {
            Center = vector3(810.88, -750.71, 26.78),
            Length = 0.6,
            Width = 0.8,
            Data = {
                debugPoly = false,
                heading = 0,
                minZ = 26.78,
                maxZ = 27.78
            },
        },
        Options = {
            {
                Name = 'pizzaThis_teller_option_one',
                Icon = 'fas fa-cash-register',
                Label = 'Make Payment',
                EventType = 'Client',
                EventName = 'mercy-business/client/foodchain/pay-menu',
                EventParams = { Foodchain = "Pizza This", RegisterId = 1 },
                Enabled = function(Entity)
                    return true
                end,
            },
            {
                Name = 'pizzaThis_teller_option_two',
                Icon = 'fas fa-credit-card',
                Label = 'Charge Customer',
                EventType = 'Client',
                EventName = 'mercy-business/client/foodchain/order-menu',
                EventParams = { RegisterId = 1 },
                Enabled = function(Entity)
                    local ClockData = exports['mercy-business']:GetClockedData()
                    if ClockData.Business == 'Pizza This' and ClockData.Clocked and exports['mercy-business']:HasPlayerBusinessPermission('Pizza This', 'charge_external') then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("pizza_this_table", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 3.0,
        ZoneData = {
            Center = vector3(809.2, -761.57, 26.78),
            Length = 2.0,
            Width = 0.8,
            Data = {
                debugPoly = false,
                heading = 0,
                minZ = 26.58,
                maxZ = 26.98
            },
        },
        Options = {
            {
                Name = 'pizza_this_table',
                Icon = 'fas fa-archive',
                Label = 'Table',
                EventType = 'Client',
                EventName = 'mercy-business/client/pizzathis/open-table',
                EventParams = '',
                Enabled = function(Entity)
                    return true
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry("pizza_this_fridge_1", {
        Type = 'Zone',
        SpriteDistance = 5.0,
        Distance = 3.0,
        ZoneData = {
            Center = vector3(805.79, -761.59, 26.78),
            Length = 1.4,
            Width = 1.0,
            Data = {
                debugPoly = false,
                heading = 0,
                minZ = 25.78,
                maxZ = 28.18
            },
        },
        Options = {
            {
                Name = 'pizza_this_fridge_1',
                Icon = 'fas fa-ice-cream',
                Label = 'Fridge',
                EventType = 'Client',
                EventName = 'mercy-business/client/foodchain/open-storage',
                EventParams = 'pizza_ice_1',
                Enabled = function(Entity)
                    local ClockData = exports['mercy-business']:GetClockedData()
                    if ClockData.Business == 'Pizza This' and ClockData.Clocked and exports['mercy-business']:HasPlayerBusinessPermission('Pizza This', 'stash_access') then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
end
