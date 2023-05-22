local InsideMeetingRoom, PodiumActive, NearHeliPad, ShowingInteraction = false, false, false, false
local NearJail, IsNearGarage, NearReclaim = false, false, false
local CurrentMeetingRoom = "police_meeting"

function InitZones()
    Citizen.CreateThread(function()
        exports['mercy-ui']:AddEyeEntry("police_check_in", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 3.5,
            ZoneData = {
                Center = vector3(441.84, -982.04, 30.69),
                Length = 0.5,
                Width = 0.35,
                Data = {
                    debugPoly = false,
                    heading = 11,
                    minZ = 30.79,
                    maxZ = 30.84
                },
            },
            Options = {
                {
                    Name = 'police_toggle_duty',
                    Icon = 'fas fa-toggle-on',
                    Label = 'Duty Options',
                    EventType = 'Client',
                    EventName = 'mercy-base/client/duty-menu',
                    EventParams = {},
                    Enabled = function(Entity)
                        local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
                        if Player.Job.Name == 'police' then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("police_locker", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 4.0,
            ZoneData = {
                Center = vector3(482.53, -994.83, 30.69),
                Length = 0.2,
                Width = 1.0,
                Data = {
                    debugPoly = false,
                    heading = 11,
                    minZ = 30.14,
                    maxZ = 31.54
                },
            },
            Options = {
                {
                    Name = 'police_locker',
                    Icon = 'fas fa-shopping-basket',
                    Label = 'Police Locker',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/open-police-store',
                    EventParams = {},
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
        exports['mercy-ui']:AddEyeEntry("police_personal_locker", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 4.0,
            ZoneData = {
                Center = vector3(479.79, -996.71, 30.69),
                Length = 1.0,
                Width = 0.4,
                Data = {
                    debugPoly = false,
                    heading = 0,
                    minZ = 30.59,
                    maxZ = 30.84
                },
            },
            Options = {
                {
                    Name = 'police_personal_locker',
                    Icon = 'fas fa-archive',
                    Label = 'Police Personal Locker',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/open-police-locker',
                    EventParams = {},
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
        exports['mercy-ui']:AddEyeEntry("police_trash", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 4.0,
            ZoneData = {
                Center = vector3(474.33, -988.87, 26.27),
                Length = 0.45,
                Width = 0.4,
                Data = {
                    debugPoly = false,
                    heading = 6,
                    minZ = 25.27,
                    maxZ = 25.97
                },
            },
            Options = {
                {
                    Name = 'police_trash',
                    Icon = 'fas fa-trash-alt',
                    Label = 'Trashcan',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/open-police-trash',
                    EventParams = {},
                    Enabled = function(Entity)
                        return true
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry(GetHashKey("p_planning_board_02"), {
            Type = 'Model',
            Model = 'p_planning_board_02',
            SpriteDistance = 5.0,
            Options = {
                {
                    Name = 'meeting_change_url',
                    Icon = 'far fa-file-code',
                    Label = 'Change URL',
                    EventType = 'Client',
                    EventName = 'mercy-assets/client/change-dui-url',
                    EventParams = "police",
                    Enabled = function(Entity)
                        return true
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("police_evidence_stash_1", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 3.0,
            ZoneData = {
                Center = vector3(482.71, -993.65, 30.69),
                Length = 0.1,
                Width = 1.0,
                Data = {
                    debugPoly = false,
                    heading = 0,
                    minZ = 29.74,
                    maxZ = 31.99
                },
            },
            Options = {
                {
                    Name = 'police_evidence_stash',
                    Icon = 'fas fa-archive',
                    Label = 'Evidence Stash',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/open-police-evidence',
                    EventParams = {},
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
        exports['mercy-ui']:AddEyeEntry("police_evidence_stash_2", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 1.0,
            ZoneData = {
                Center = vector3(475.76, -994.07, 26.27),
                Length = 2.3,
                Width = 0.65,
                Data = {
                    debugPoly = false,
                    heading = 0,
                    minZ = 26.57,
                    maxZ = 27.02
                },
            },
            Options = {
                {
                    Name = 'police_evidence_stash',
                    Icon = 'fas fa-archive',
                    Label = 'Evidence Stash',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/open-police-evidence',
                    EventParams = {},
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
        exports['mercy-ui']:AddEyeEntry("police_stash_high", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 4.0,
            ZoneData = {
                Center = vector3(463.36, -984.22, 30.73),
                Length = 0.6,
                Width = 1.2,
                Data = {
                    debugPoly = false,
                    heading = 0,
                    minZ = 29.68,
                    maxZ = 30.68
                },
            },
            Options = {
                {
                    Name = 'police_high_officers',
                    Icon = 'fas fa-user',
                    Label = 'Employee List',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/open-employee-list',
                    EventParams = {},
                    Enabled = function(Entity)
                        local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
                        if Player.Job.Name == 'police' and Player.Job.Duty and Player.Job.HighCommand then
                            return true
                        else
                            return false
                        end
                    end,
                },
                {
                    Name = 'police_stash_high',
                    Icon = 'fas fa-archive',
                    Label = 'High Command Cabin',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/open-police-command-stash',
                    EventParams = {},
                    Enabled = function(Entity)
                        local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
                        if Player.Job.Name == 'police' and Player.Job.Duty and Player.Job.HighCommand then
                            return true
                        else
                            return false
                        end
                    end,
                },
                {
                    Name = 'police_high_badge',
                    Icon = 'fas fa-id-badge',
                    Label = 'Create Badge',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/create-badge',
                    EventParams = {},
                    Enabled = function(Entity)
                        local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
                        if Player.Job.Name == 'police' and Player.Job.Duty and Player.Job.HighCommand then
                            return true
                        else
                            return false
                        end
                    end,
                },
                {
                    Name = 'police_high_vehicle',
                    Icon = 'fas fa-car',
                    Label = 'Purchase Vehicle',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/try-purchase-vehicle',
                    EventParams = {},
                    Enabled = function(Entity)
                        local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
                        if Player.Job.Name == 'police' and Player.Job.Duty and Player.Job.HighCommand then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-polyzone']:CreateBox({
            center = vector3(445.2, -985.92, 34.97), 
            length = 9.6, 
            width = 11.6,
        }, {
            name = 'police_meeting',
            minZ = 33.37,
            maxZ = 36.37,
            heading = 0.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
        exports['mercy-polyzone']:CreateBox({
            center = vector3(474.06, -994.94, 30.69), 
            length = 10.4, 
            width = 5.2,
        }, {
            name = 'police_meeting_2',
            minZ = 28.49,
            maxZ = 32.49, 
            heading = 0.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
        exports['mercy-polyzone']:CreateBox({
            center = vector3(441.63, -992.61, 25.7), 
            length = 16.0, 
            width = 12.45,
        }, {
            name = 'police_garage',
            minZ = 24.7,
            maxZ = 26.7,
            heading = 0.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
        exports['mercy-polyzone']:CreateBox({
            center = vector3(449.45, -981.12, 43.69), 
            length = 10.8, 
            width = 10.8,
        }, {
            name = 'police_helipad',
            minZ = 42.69,
            maxZ = 46.69,
            heading = 0.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
        exports['mercy-polyzone']:CreateBox({
            center = vector3(440.57, -985.75, 34.97), 
            length = 1.0, 
            width = 1.0,
        }, {
            name = 'police_podium',
            minZ = 31.97,
            maxZ = 35.97,
            heading = 0.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
        exports['mercy-polyzone']:CreateBox({
            center = vector3(473.18, -1007.45, 26.27), 
            length = 0.8, 
            width = 1.0,
        }, {
            name = 'police_jail_stuff',
            minZ = 25.27,
            maxZ = 27.17,
            heading = 359.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
        -- VCPD
        exports['mercy-ui']:AddEyeEntry("police_check_in_vcpd", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 4.0,
            ZoneData = {
                Center = vector3(-1087.11, -814.19, 19.3),
                Length = 0.5,
                Width = 0.3,
                Data = {
                    debugPoly = false,
                    heading = 18.0,
                    minZ = 19.5,
                    maxZ = 19.7
                },
            },
            Options = {
                {
                    Name = 'police_toggle_duty',
                    Icon = 'fas fa-toggle-on',
                    Label = 'Duty Options',
                    EventType = 'Client',
                    EventName = 'mercy-base/client/duty-menu',
                    EventParams = {},
                    Enabled = function(Entity)
                        local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
                        if Player.Job.Name == 'police' then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("police_evidence_stash_vcpd", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 3.5,
            ZoneData = {
                Center = vector3(-1084.25, -834.74, 13.52),
                Length = 0.4,
                Width = 1.2,
                Data = {
                    debugPoly = false,
                    heading = 38.0,
                    minZ = 13.27,
                    maxZ = 13.92
                },
            },
            Options = {
                {
                    Name = 'police_evidence_stash',
                    Icon = 'fas fa-archive',
                    Label = 'Evidence Stash',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/open-police-evidence',
                    EventParams = {},
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
        exports['mercy-ui']:AddEyeEntry("police_personal_locker_vcpd", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 4.0,
            ZoneData = {
                Center = vector3(-1079.59, -823.6, 19.3),
                Length = 0.4,
                Width = 0.8,
                Data = {
                    debugPoly = false,
                    heading = 40.0,
                    minZ = 19.25,
                    maxZ = 19.5
                },
            },
            Options = {
                {
                    Name = 'police_personal_locker',
                    Icon = 'fas fa-archive',
                    Label = 'Police Personal Locker',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/open-police-locker',
                    EventParams = {},
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
        exports['mercy-ui']:AddEyeEntry("police_locker_vcpd", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 4.0,
            ZoneData = {
                Center = vector3(-1075.13, -826.8, 19.3),
                Length = 1.5,
                Width = 0.2,
                Data = {
                    debugPoly = false,
                    heading = 38.0,
                    minZ = 18.3,
                    maxZ = 20.3
                },
            },
            Options = {
                {
                    Name = 'police_locker',
                    Icon = 'fas fa-shopping-basket',
                    Label = 'Police Locker',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/open-police-store',
                    EventParams = {},
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
        exports['mercy-ui']:AddEyeEntry("police_stash_high_vcpd", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 4.0,
            ZoneData = {
                Center = vector3(-1075.52, -816.67, 19.3),
                Length = 1.3,
                Width = 0.6,
                Data = {
                    debugPoly = false,
                    heading = 39.0,
                    minZ = 18.3,
                    maxZ = 19.3
                },
            },
            Options = {
                {
                    Name = 'police_high_officers',
                    Icon = 'fas fa-user',
                    Label = 'Employee List',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/open-employee-list',
                    EventParams = {},
                    Enabled = function(Entity)
                        local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
                        if Player.Job.Name == 'police' and Player.Job.Duty and Player.Job.HighCommand then
                            return true
                        else
                            return false
                        end
                    end,
                },
                {
                    Name = 'police_stash_high',
                    Icon = 'fas fa-archive',
                    Label = 'High Command Cabin',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/open-police-command-stash',
                    EventParams = {},
                    Enabled = function(Entity)
                        local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
                        if Player.Job.Name == 'police' and Player.Job.Duty and Player.Job.HighCommand then
                            return true
                        else
                            return false
                        end
                    end,
                },
                {
                    Name = 'police_high_badge',
                    Icon = 'fas fa-id-badge',
                    Label = 'Create Badge',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/create-badge',
                    EventParams = {},
                    Enabled = function(Entity)
                        local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
                        if Player.Job.Name == 'police' and Player.Job.Duty and Player.Job.HighCommand then
                            return true
                        else
                            return false
                        end
                    end,
                },
                {
                    Name = 'police_high_vehicle',
                    Icon = 'fas fa-car',
                    Label = 'Purchase Vehicle',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/try-purchase-vehicle',
                    EventParams = {},
                    Enabled = function(Entity)
                        local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
                        if Player.Job.Name == 'police' and Player.Job.Duty and Player.Job.HighCommand then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-polyzone']:CreateBox({
            center = vector3(-1139.44, -842.42, 3.75), 
            length = 6.4, 
            width = 25.6,
        }, {
            name = 'police_garage_vcpd',
            minZ = 2.75,
            maxZ = 5.95,
            heading = 36.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
        -- SYPD
        exports['mercy-ui']:AddEyeEntry("police_check_in_sypd", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 4.0,
            ZoneData = {
                Center = vector3(1852.5, 3687.03, 34.22),
                Length = 0.6,
                Width = 0.5,
                Data = {
                    debugPoly = false,
                    heading = 29.0,
                    minZ = 34.12,
                    maxZ = 34.52
                },
            },
            Options = {
                {
                    Name = 'police_toggle_duty',
                    Icon = 'fas fa-toggle-on',
                    Label = 'Duty Options',
                    EventType = 'Client',
                    EventName = 'mercy-base/client/duty-menu',
                    EventParams = {},
                    Enabled = function(Entity)
                        local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
                        if Player.Job.Name == 'police' then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("police_evidence_stash_sypd", {
            Type = 'Zone',
            SpriteDistance = 3.5,
            Distance = 1.0,
            ZoneData = {
                Center = vector3(1855.76, 3691.59, 29.82),
                Length = 1.4,
                Width = 0.6,
                Data = {
                    debugPoly = false,
                    heading = 300.0,
                    minZ = 29.92,
                    maxZ = 30.37
                },
            },
            Options = {
                {
                    Name = 'police_evidence_stash',
                    Icon = 'fas fa-archive',
                    Label = 'Evidence Stash',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/open-police-evidence',
                    EventParams = {},
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
        exports['mercy-ui']:AddEyeEntry("police_personal_locker_sypd", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 3.0,
            ZoneData = {
                Center = vector3(1860.69, 3691.74, 34.22),
                Length = 0.2,
                Width = 0.6,
                Data = {
                    debugPoly = false,
                    heading = 30.0,
                    minZ = 34.12,
                    maxZ = 34.52
                },
            },
            Options = {
                {
                    Name = 'police_personal_locker',
                    Icon = 'fas fa-archive',
                    Label = 'Police Personal Locker',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/open-police-locker',
                    EventParams = {},
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
        exports['mercy-ui']:AddEyeEntry("police_locker_sypd", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 3.5,
            ZoneData = {
                Center = vector3(1860.59, 3687.23, 34.22),
                Length = 1.5,
                Width = 0.2,
                Data = {
                    debugPoly = false,
                    heading = 300.0,
                    minZ = 33.22,
                    maxZ = 35.02
                },
            },
            Options = {
                {
                    Name = 'police_locker',
                    Icon = 'fas fa-shopping-basket',
                    Label = 'Police Locker',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/open-police-store',
                    EventParams = {},
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
        exports['mercy-ui']:AddEyeEntry("police_stash_high_sypd", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 3.5,
            ZoneData = {
                Center = vector3(1846.58, 3694.19, 38.22),
                Length = 1.2,
                Width = 0.6,
                Data = {
                    debugPoly = false,
                    heading = 30.0,
                    minZ = 37.22,
                    maxZ = 38.12
                },
            },
            Options = {
                {
                    Name = 'police_high_officers',
                    Icon = 'fas fa-user',
                    Label = 'Employee List',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/open-employee-list',
                    EventParams = {},
                    Enabled = function(Entity)
                        local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
                        if Player.Job.Name == 'police' and Player.Job.Duty and Player.Job.HighCommand then
                            return true
                        else
                            return false
                        end
                    end,
                },
                {
                    Name = 'police_stash_high',
                    Icon = 'fas fa-archive',
                    Label = 'High Command Cabin',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/open-police-command-stash',
                    EventParams = {},
                    Enabled = function(Entity)
                        local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
                        if Player.Job.Name == 'police' and Player.Job.Duty and Player.Job.HighCommand then
                            return true
                        else
                            return false
                        end
                    end,
                },
                {
                    Name = 'police_high_badge',
                    Icon = 'fas fa-id-badge',
                    Label = 'Create Badge',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/create-badge',
                    EventParams = {},
                    Enabled = function(Entity)
                        local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
                        if Player.Job.Name == 'police' and Player.Job.Duty and Player.Job.HighCommand then
                            return true
                        else
                            return false
                        end
                    end,
                },
                {
                    Name = 'police_high_vehicle',
                    Icon = 'fas fa-car',
                    Label = 'Purchase Vehicle',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/try-purchase-vehicle',
                    EventParams = {},
                    Enabled = function(Entity)
                        local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
                        if Player.Job.Name == 'police' and Player.Job.Duty and Player.Job.HighCommand then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })


        exports['mercy-polyzone']:CreateBox({
            center = vector3(1878.58, 3698.61, 33.54), 
            length = 21.6, 
            width = 10.1,
        }, {
            name = 'police_garage_sypd',
            minZ = 32.54,
            maxZ = 36.14,
            heading = 30.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
        -- Jail
        exports['mercy-ui']:AddEyeEntry(GetHashKey('p_phonebox_02_s'), {
            Type = 'Model',
            Model = 'p_phonebox_02_s',
            SpriteDistance = 1.0,
            Options = {
                {
                    Name = 'jail_time',
                    Icon = 'fas fa-clock',
                    Label = 'Check Time',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/check-jail-time',
                    EventParams = '',
                    Enabled = function(Entity)
                        if exports['mercy-police']:IsInJail() then
                            return true
                        else
                            return false
                        end
                    end,
                },
                {
                    Name = 'jail_sleep',
                    Icon = 'fas fa-bed',
                    Label = 'Sleep (Logout)',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/go-to-jail-sleep',
                    EventParams = '',
                    Enabled = function(Entity)
                        if exports['mercy-police']:IsInJail() then
                            return true
                        else
                            return false
                        end
                    end,
                },
                {
                    Name = 'change_task',
                    Icon = 'fas fa-list-alt',
                    Label = 'Change Job',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/change-task',
                    EventParams = '',
                    Enabled = function(Entity)
                        if exports['mercy-police']:IsInJail() and PlayerModule.GetPlayerData().MetaData['Jail'] > 1 then
                            return true
                        end
                        return false
                    end,
                },
            }
        })
        exports['mercy-ui']:AddEyeEntry("jail_hole", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 2.5,
            ZoneData = {
                Center = vector3(1753.35, 2496.45, 50.42),
                Length = 0.1,
                Width = 0.9,
                Data = {
                    debugPoly = false,
                    heading = 29,
                    minZ = 50.52,
                    maxZ = 51.42
                },
            },
            Options = {
                {
                    Name = 'jail_hole',
                    Icon = 'fas fa-circle',
                    Label = 'Escape Jail',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/escape-jail',
                    EventParams = {},
                    Enabled = function(Entity)
                        return true
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("jail_craft", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 3.5,
            ZoneData = {
                Center = vector3(1636.12, 2585.52, 45.79),
                Length = 0.6,
                Width = 1.2,
                Data = {
                    debugPoly = false,
                    heading = 0,
                    minZ = 44.79,
                    maxZ = 45.79
                },
            },
            Options = {
                {
                    Name = 'jail_craft',
                    Icon = 'fas fa-circle',
                    Label = '????',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/open-jail-craft',
                    EventParams = {},
                    Enabled = function(Entity)
                        return true
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("jail_slushy", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 3.0,
            ZoneData = {
                Center = vector3(1777.63, 2559.97, 45.67),
                Length = 0.5,
                Width = 0.55,
                Data = {
                    debugPoly = false,
                    heading = 0,
                    minZ = 45.67,
                    maxZ = 46.67
                },
            },
            Options = {
                {
                    Name = 'jail_slushy',
                    Icon = 'fab fa-gulp',
                    Label = 'Tap a Slushy!',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/jail-tap-slushy',
                    EventParams = {},
                    Enabled = function(Entity)
                        return true
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("jail_food", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 3.0,
            ZoneData = {
                Center = vector3(1783.11, 2559.53, 45.67),
                Length = 0.4,
                Width = 0.6,
                Data = {
                    debugPoly = false,
                    heading = 0,
                    minZ = 45.67,
                    maxZ = 45.87
                },
            },
            Options = {
                {
                    Name = 'jail_food',
                    Icon = 'fas fa-utensils',
                    Label = 'Take A Plate!',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/jail-take-late',
                    EventParams = {},
                    Enabled = function(Entity)
                        return true
                    end,
                }
            }
        })
        -- Jail Jobs
        -- Prison Tasks
        exports['mercy-ui']:AddEyeEntry("jail_task_stack_bricks", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 3.0,
            ZoneData = {
                Center = vector3(1641.97, 2535.69, 46.45),
                Length = 4.0,
                Width = 2.85,
                Data = {
                    debugPoly = false,
                    heading = 10,
                    minZ = 44.45,
                    maxZ = 45.85
                },
            },
            Options = {
                {
                    Name = 'jail_task_stack_bricks',
                    Icon = 'fas fa-chess-rook',
                    Label = 'Stack Stones',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/do-prison-task',
                    EventParams = { Task = 'Scrapyard', Job = 'StackBricks' },
                    Enabled = function(Entity)
                        if not exports['mercy-police']:IsInJail() then return false end
                        local Task = exports['mercy-police']:GetPrisonJob().Task
                        return Task == 'Scrapyard'
                    end,
                }
            }
        })

        exports['mercy-ui']:AddEyeEntry("jail_task_sort_scrap", {
            Type = 'Zone',
            SpriteDistance = 10.0,
            Distance = 7.0,
            ZoneData = {
                Center = vector3(1640.51, 2525.96, 48.42),
                Length = 6.0,
                Width = 10.0,
                Data = {
                    debugPoly = false,
                    heading = 0,
                    minZ = 44.42,
                    maxZ = 48.62
                },
            },
            Options = {
                {
                    Name = 'jail_task_sort_scrap',
                    Icon = 'fas fa-trash-restore',
                    Label = 'Sort Trash',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/do-prison-task',
                    EventParams = { Task = 'Scrapyard', Job = 'SortScrap' },
                    Enabled = function(Entity)
                        if not exports['mercy-police']:IsInJail() then return false end
                        local Task = exports['mercy-police']:GetPrisonJob().Task
                        return Task == 'Scrapyard'
                    end,
                }
            }
        })

        exports['mercy-ui']:AddEyeEntry("jail_task_deliver_scrap", {
            Type = 'Zone',
            SpriteDistance = 10.0,
            Distance = 7.0,
            ZoneData = {
                Center = vector3(1720.68, 2567.0, 45.55),
                Length = 3.15,
                Width = 0.3,
                Data = {
                    debugPoly = false,
                    heading = 45,
                    minZ = 44.55,
                    maxZ = 47.75
                },
            },
            Options = {
                {
                    Name = 'jail_task_deliver_scrap',
                    Icon = 'fas fa-inbox',
                    Label = 'Deliver Materials',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/do-prison-task',
                    EventParams = { Task = 'Scrapyard', Job = 'DeliverScrap' },
                    Enabled = function(Entity)
                        if not exports['mercy-police']:IsInJail() then return false end
                        local Task = exports['mercy-police']:GetPrisonJob().Task
                        return Task == 'Scrapyard'
                    end,
                }
            }
        })

        exports['mercy-ui']:AddEyeEntry("jail_task_sort_kitchen", {
            Type = 'Zone',
            SpriteDistance = 10.0,
            Distance = 1.5,
            ZoneData = {
                Center = vector3(1786.92, 2564.81, 45.67),
                Length = 0.4,
                Width = 2.8,
                Data = {
                    debugPoly = false,
                    heading = 0,
                    minZ = 44.67,
                    maxZ = 46.67
                },
            },
            Options = {
                {
                    Name = 'jail_task_sort_kitchen',
                    Icon = 'fas fa-sort',
                    Label = 'Sort',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/do-prison-task',
                    EventParams = { Task = 'Kitchen', Job = 'SortKitchen' },
                    Enabled = function(Entity)
                        if not exports['mercy-police']:IsInJail() then return false end
                        local Task = exports['mercy-police']:GetPrisonJob().Task
                        return Task == 'Kitchen'
                    end,
                }
            }
        })

        exports['mercy-ui']:AddEyeEntry("jail_task_clean_table_01", {
            Type = 'Zone',
            SpriteDistance = 10.0,
            Distance = 2.3,
            ZoneData = {
                Center = vector3(1789.84, 2556.23, 45.67),
                Length = 1.2,
                Width = 2.8,
                Data = {
                    debugPoly = false,
                    heading = 0,
                    minZ = 45.42,
                    maxZ = 45.67
                },
            },
            Options = {
                {
                    Name = 'jail_task_clean_table',
                    Icon = 'fas fa-soap',
                    Label = 'Clean Table',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/do-prison-task',
                    EventParams = { Task = 'Kitchen', Job = 'CleanTable' },
                    Enabled = function(Entity)
                        if not exports['mercy-police']:IsInJail() then return false end
                        local Task = exports['mercy-police']:GetPrisonJob().Task
                        return Task == 'Kitchen'
                    end,
                }
            }
        })

        exports['mercy-ui']:AddEyeEntry("jail_task_clean_table_02", {
            Type = 'Zone',
            SpriteDistance = 10.0,
            Distance = 2.3,
            ZoneData = {
                Center = vector3(1780.77, 2556.55, 45.67),
                Length = 1.2,
                Width = 2.8,
                Data = {
                    debugPoly = false,
                    heading = 90,
                    minZ = 45.42,
                    maxZ = 45.67
                },
            },
            Options = {
                {
                    Name = 'jail_task_clean_table',
                    Icon = 'fas fa-soap',
                    Label = 'Clean Table',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/do-prison-task',
                    EventParams = { Task = 'Kitchen', Job = 'CleanTable' },
                    Enabled = function(Entity)
                        if not exports['mercy-police']:IsInJail() then return false end
                        local Task = exports['mercy-police']:GetPrisonJob().Task
                        return Task == 'Kitchen'
                    end,
                }
            }
        })

        exports['mercy-ui']:AddEyeEntry("jail_task_clean_table_03", {
            Type = 'Zone',
            SpriteDistance = 10.0,
            Distance = 2.3,
            ZoneData = {
                Center = vector3(1777.76, 2547.97, 45.67),
                Length = 1.2,
                Width = 2.8,
                Data = {
                    debugPoly = false,
                    heading = 0,
                    minZ = 45.42,
                    maxZ = 45.67
                },
            },
            Options = {
                {
                    Name = 'jail_task_clean_table',
                    Icon = 'fas fa-soap',
                    Label = 'Clean Table',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/do-prison-task',
                    EventParams = { Task = 'Kitchen', Job = 'CleanTable' },
                    Enabled = function(Entity)
                        if not exports['mercy-police']:IsInJail() then return false end
                        local Task = exports['mercy-police']:GetPrisonJob().Task
                        return Task == 'Kitchen'
                    end,
                }
            }
        })

        exports['mercy-ui']:AddEyeEntry("jail_task_clean_table_04", {
            Type = 'Zone',
            SpriteDistance = 10.0,
            Distance = 2.3,
            ZoneData = {
                Center = vector3(1782.19, 2549.31, 45.67),
                Length = 2.8,
                Width = 1.2,
                Data = {
                    debugPoly = false,
                    heading = 0,
                    minZ = 45.42,
                    maxZ = 45.67
                },
            },
            Options = {
                {
                    Name = 'jail_task_clean_table',
                    Icon = 'fas fa-soap',
                    Label = 'Clean Table',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/do-prison-task',
                    EventParams = { Task = 'Kitchen', Job = 'CleanTable' },
                    Enabled = function(Entity)
                        if not exports['mercy-police']:IsInJail() then return false end
                        local Task = exports['mercy-police']:GetPrisonJob().Task
                        return Task == 'Kitchen'
                    end,
                }
            }
        })

        exports['mercy-ui']:AddEyeEntry("jail_task_clean_table_05", {
            Type = 'Zone',
            SpriteDistance = 10.0,
            Distance = 2.3,
            ZoneData = {
                Center = vector3(1782.18, 2546.54, 46.13),
                Length = 2.6,
                Width = 1.2,
                Data = {
                    debugPoly = false,
                    heading = 0,
                    minZ = 45.42,
                    maxZ = 45.67
                },
            },
            Options = {
                {
                    Name = 'jail_task_clean_table',
                    Icon = 'fas fa-soap',
                    Label = 'Clean Table',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/do-prison-task',
                    EventParams = { Task = 'Kitchen', Job = 'CleanTable' },
                    Enabled = function(Entity)
                        if not exports['mercy-police']:IsInJail() then return false end
                        local Task = exports['mercy-police']:GetPrisonJob().Task
                        return Task == 'Kitchen'
                    end,
                }
            }
        })

        exports['mercy-ui']:AddEyeEntry("jail_task_clean_table_06", {
            Type = 'Zone',
            SpriteDistance = 10.0,
            Distance = 2.3,
            ZoneData = {
                Center = vector3(1786.38, 2549.37, 45.67),
                Length = 2.8,
                Width = 1.2,
                Data = {
                    debugPoly = false,
                    heading = 0,
                    minZ = 45.42,
                    maxZ = 45.67
                },
            },
            Options = {
                {
                    Name = 'jail_task_clean_table',
                    Icon = 'fas fa-soap',
                    Label = 'Clean Table',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/do-prison-task',
                    EventParams = { Task = 'Kitchen', Job = 'CleanTable' },
                    Enabled = function(Entity)
                        if not exports['mercy-police']:IsInJail() then return false end
                        local Task = exports['mercy-police']:GetPrisonJob().Task
                        return Task == 'Kitchen'
                    end,
                }
            }
        })

        exports['mercy-ui']:AddEyeEntry("jail_task_clean_table_07", {
            Type = 'Zone',
            SpriteDistance = 10.0,
            Distance = 2.3,
            ZoneData = {
                Center = vector3(1786.35, 2546.56, 46.13),
                Length = 2.6,
                Width = 1.2,
                Data = {
                    debugPoly = false,
                    heading = 0,
                    minZ = 45.42,
                    maxZ = 45.67
                },
            },
            Options = {
                {
                    Name = 'jail_task_clean_table',
                    Icon = 'fas fa-soap',
                    Label = 'Clean Table',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/do-prison-task',
                    EventParams = { Task = 'Kitchen', Job = 'CleanTable' },
                    Enabled = function(Entity)
                        if not exports['mercy-police']:IsInJail() then return false end
                        local Task = exports['mercy-police']:GetPrisonJob().Task
                        return Task == 'Kitchen'
                    end,
                }
            }
        })

        exports['mercy-ui']:AddEyeEntry("jail_task_clean_table_08", {
            Type = 'Zone',
            SpriteDistance = 10.0,
            Distance = 2.3,
            ZoneData = {
                Center = vector3(1790.03, 2547.97, 45.67),
                Length = 1.2,
                Width = 2.8,
                Data = {
                    debugPoly = false,
                    heading = 0,
                    minZ = 45.42,
                    maxZ = 45.67
                },
            },
            Options = {
                {
                    Name = 'jail_task_clean_table',
                    Icon = 'fas fa-soap',
                    Label = 'Clean table',
                    EventType = 'Client',
                    EventName = 'mercy-police/client/do-prison-task',
                    EventParams = { Task = 'Kitchen', Job = 'CleanTable' },
                    Enabled = function(Entity)
                        if not exports['mercy-police']:IsInJail() then return false end
                        local Task = exports['mercy-police']:GetPrisonJob().Task
                        return Task == 'Kitchen'
                    end,
                }
            }
        })
        exports['mercy-polyzone']:CreateBox({
            center = vector3(1840.4, 2579.36, 46.01), 
            length = 1.1, 
            width = 1.5,
        }, {
            name = 'jail_reclaim',
            minZ = 45.01,
            maxZ = 47.01,
            heading = 0.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
        exports['mercy-polyzone']:CreateBox({
            center = vector3(1687.47, 2582.62, 55.03), 
            length = 230.6, 
            width = 218.6,
        }, {
            name = 'jail_zone',
            minZ = 44.43,
            maxZ = 59.43,
            heading = 0.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
    end)
end

RegisterNetEvent('mercy-polyzone/client/enter-polyzone', function(PolyData, Coords)
    if PolyData.name == 'police_meeting' or PolyData.name == 'police_meeting_2' then
        if not InsideMeetingRoom then
            InsideMeetingRoom = true
            CurrentMeetingRoom = PolyData.name
            local DuiData = exports['mercy-assets']:GenerateNewDui('https://i.imgur.com/5Ust2GQ.jpg', 1920, 1080, CurrentMeetingRoom)
            if DuiData == false then
                local SecondDuiData = exports['mercy-assets']:GetDuiData(CurrentMeetingRoom)
                AddReplaceTexture('prop_planning_b1', 'prop_base_white_01b', SecondDuiData['TxdDictName'], SecondDuiData['TxdName'])
                exports['mercy-assets']:ActivateDui(CurrentMeetingRoom)
            else
                AddReplaceTexture('prop_planning_b1', 'prop_base_white_01b', DuiData['TxdDictName'], DuiData['TxdName'])
            end
        end
    elseif PolyData.name == 'police_podium' then
        if PodiumActive then return end
        TriggerServerEvent("mercy-voice/server/transmission-state", 'Podium', true)
        TriggerEvent('mercy-voice/client/proximity-override', "Podium", 3, 15.0, 2)
        PodiumActive = true
    elseif PolyData.name == 'jail_zone' then
        NearJail = true
    elseif PolyData.name == 'police_helipad' then
        NearHeliPad = true
        if not ShowingInteraction then
            ShowingInteraction = true
            exports['mercy-ui']:SetInteraction('Helipad', 'primary')
        end
    elseif PolyData.name == 'police_garage' then
        IsNearGarage, CurrentGarage = true, 'MRPD'
        if not ShowingInteraction then
            ShowingInteraction = true
            exports['mercy-ui']:SetInteraction('Parking', 'primary')
        end
    elseif PolyData.name == 'police_garage_vcpd' then
        IsNearGarage, CurrentGarage = true, 'VCPD'
        if not ShowingInteraction then
            ShowingInteraction = true
            exports['mercy-ui']:SetInteraction('Parking', 'primary')
        end
    elseif PolyData.name == 'police_garage_sypd' then
        IsNearGarage, CurrentGarage = true, 'SYPD'
        if not ShowingInteraction then
            ShowingInteraction = true
            exports['mercy-ui']:SetInteraction('Parking', 'primary')
        end
    elseif PolyData.name == 'jail_reclaim' or PolyData.name == 'police_jail_stuff' then
        if not NearReclaim then
            NearReclaim = true
            if not ShowingInteraction then
                ShowingInteraction = true
                exports['mercy-ui']:SetInteraction('[E] Reclaim', 'primary')
            end
            while NearReclaim do
                Citizen.Wait(4)
                if IsControlJustReleased(0, 38) then
                    exports['mercy-ui']:HideInteraction()
                    if exports['mercy-inventory']:CanOpenInventory() then
                        local MyStateId =  PlayerModule.GetPlayerData().CitizenId
                        EventsModule.TriggerServer('mercy-inventory/server/open-other-inventory', "jail-"..MyStateId, 'Stash', 45, 0.0)
                    end
                end
            end
        end
    else
        return
    end
end)

RegisterNetEvent('mercy-polyzone/client/leave-polyzone', function(PolyData, Coords)
    if PolyData.name == 'police_meeting' or PolyData.name == 'police_meeting_2' then
        if InsideMeetingRoom then
            InsideMeetingRoom = false
            RemoveReplaceTexture('prop_planning_b1', 'prop_base_white_01b')
            exports['mercy-assets']:ReleaseDui(CurrentMeetingRoom)
        end
    elseif PolyData.name == 'jail_zone' then
        NearJail = false
    elseif PolyData.name == 'police_podium' then
        if not PodiumActive then return end
        TriggerServerEvent("mercy-voice/server/transmission-state", 'Podium', false)
        TriggerEvent('mercy-voice/client/proximity-override', "Podium", 3, -1, -1)
        PodiumActive = false
    elseif PolyData.name == 'police_helipad' then
        NearHeliPad = false
        if ShowingInteraction then
            ShowingInteraction = false
            exports['mercy-ui']:HideInteraction()
        end
    elseif PolyData.name == 'police_garage' or PolyData.name == 'police_garage_vcpd' or PolyData.name == 'police_garage_sypd' then
        IsNearGarage, CurrentGarage = false, nil
        if ShowingInteraction then
            ShowingInteraction = false
            exports['mercy-ui']:HideInteraction()
        end
    elseif PolyData.name == 'jail_reclaim' or PolyData.name == 'police_jail_stuff' then
        if NearReclaim then
            NearReclaim = false
            if ShowingInteraction then
                ShowingInteraction = false
                exports['mercy-ui']:HideInteraction()
            end
        end
    else
        return
    end
end)

function IsNearHeliPad()
    return NearHeliPad
end
exports('IsNearHeliPad', IsNearHeliPad)

function IsNearPoliceGarage()
    return IsNearGarage
end
exports('IsNearPoliceGarage', IsNearPoliceGarage)

function IsInJailZone()
    return NearJail
end
exports('IsInJailZone', IsInJailZone)

function GetCurrentGarage()
    return CurrentGarage
end

function GetMeetingRoomId()
    return CurrentMeetingRoom
end
exports('GetMeetingRoomId', GetMeetingRoomId)