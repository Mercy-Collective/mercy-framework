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
                    EventName = 'mercy-business/client/digitalden-open-table',
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
                    Name = 'digital_craft',
                    Icon = 'fas fa-tools',
                    Label = 'Craft',
                    EventType = 'Client',
                    EventName = 'mercy-business/client/hayes/craft',
                    EventParams = '',
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
                    Name = 'digital_craft',
                    Icon = 'fas fa-tools',
                    Label = 'Craft',
                    EventType = 'Client',
                    EventName = 'mercy-business/client/hayes/craft',
                    EventParams = '',
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
                    Name = 'digital_craft',
                    Icon = 'fas fa-tools',
                    Label = 'Craft',
                    EventType = 'Client',
                    EventName = 'mercy-business/client/hayes/craft',
                    EventParams = '',
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
                    EventType = 'Client',
                    EventName = 'mercy-business/client/foodchain/set-duty',
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
                    EventType = 'Client',
                    EventName = 'mercy-business/client/foodchain/set-duty',
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
                    EventName = 'mercy-business/client/open-storage',
                    EventParams = 'bs-food-tray',
                    Enabled = function(Entity)
                        return true
                    end,
                }
            }
        })
    end)
end