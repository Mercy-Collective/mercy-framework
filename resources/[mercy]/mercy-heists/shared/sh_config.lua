Config = Config or {}

-- Misc

Config.ResetTimes = { -- In minutes
    ['Bobcat'] = 300, -- 5 hours
    ['Banktruck'] = 30, -- 30 Mins
    ['Jewellery'] = 30, -- 30 Mins
    ['Stores'] = 10, -- 10 Mins
}

Config.StoreCops, Config.BankCops, Config.VaultCops, Config.JewelleryCops, Config.BanktruckCops, Config.BobcatCops = 0, 0, 0, 0, 0, 0 -- 2, 3, 6, 3, 3, 4

Config.GemTypes = {'Jade', 'Ruby', 'Onyx', 'Diamond', 'Sapphire', 'Aquamarine'}

-- Bankrob

Config.BobcatSecurity = {
    [1] = {
        ['Model'] = 'ig_casey',
        ['Coords'] = vector4(895.11, -2275.29, 30.47, 98.91),
    },
    [2] = {
        ['Model'] = 'ig_casey',
        ['Coords'] = vector4(894.94, -2287.58, 30.47, 46.99),
    },
    [3] = {
        ['Model'] = 'ig_casey',
        ['Coords'] = vector4(892.67, -2292.31, 30.47, 5.2),
    },
    [4] = {
        ['Model'] = 'ig_casey',
        ['Coords'] = vector4(891.4, -2283.48, 30.47, 334.42),
    },
}

Config.Zones = {
    {
        ['BankKey'] = 1,
        ['Name'] = 'Legion Bank',
        ['Type'] = 'Fleeca',
        ['Coords'] = vector3(149.26, -1043.31, 29.37),
    },
    {
        ['BankKey'] = 2,
        ['Name'] = 'Motels Bank',
        ['Type'] = 'Fleeca',
        ['Coords'] = vector3(314.13, -283.26, 54.14),
    },
    {
        ['BankKey'] = 3,
        ['Name'] = 'Hawick Bank',
        ['Type'] = 'Fleeca',
        ['Coords'] = vector3(-353.98, -53.04, 49.04),
    },
    {
        ['BankKey'] = 4,
        ['Name'] = 'Rockford Bank',
        ['Type'] = 'Fleeca',
        ['Coords'] = vector3(-1212.5, -335.08, 37.78),
    },
    {
        ['BankKey'] = 5,
        ['Name'] = 'Del Perro Bank',
        ['Type'] = 'Fleeca',
        ['Coords'] = vector3(-1305.69, -817.41, 17.3),
    },
    {
        ['BankKey'] = 6,
        ['Name'] = 'Highway Bank',
        ['Type'] = 'Fleeca',
        ['Coords'] = vector3(-2958.68, 480.95, 15.7),
    },
    {
        ['BankKey'] = 7,
        ['Name'] = 'Sandy Bank',
        ['Type'] = 'Fleeca',
        ['Coords'] = vector3(1176.85, 2710.76, 38.09),
    },
    {
        ['BankKey'] = 8,
        ['Name'] = 'Paleto Bank',
        ['Type'] = 'Fleeca',
        ['Coords'] = vector3(-103.68, 6471.27, 31.63),
    },
}

Config.Panels = {
    ['Pacific'] = {
        ['FirstDoor'] = {
            ['HasBeenHit'] = false,
        },
        ['SecondDoor'] = {
            ['HasBeenHit'] = false,
        },
        ['LowerVault'] = {
            ['HasBeenHit'] = false,
        },
        ['UpperVault'] = {
            ['HasBeenHit'] = false,
        },
    },
    ['Fleeca'] = {
        [1] = {
            ['Name'] = 'Legion Bank',
            ['Hacked'] = false,
            ['CanUsePanel'] = true,
            ['Trolly'] = {
                ['Coords'] = vector4(147.23, -1049.52, 29.35, 353.79),
                ['Busy'] = false,
            },
            ['Doors'] = {
                ['Model'] = GetHashKey("v_ilev_gb_vauldr"),
                ['Coords'] = vector3(147.25, -1046.28, 29.36),
                ['States'] = {
                    ['Open'] = 160.0,
                    ['Closed'] = 250.0,
                },
            }
        },
        [2] = {
            ['Name'] = 'Motels Bank',
            ['Hacked'] = false,
            ['CanUsePanel'] = true,
            ['Trolly'] = {
                ['Coords'] = vector4(311.62, -288.17, 54.14, 356.05),
                ['Busy'] = false,
            },
            ['Doors'] = {
                ['Model'] = GetHashKey("v_ilev_gb_vauldr"),
                ['Coords'] = vector3(311.58, -284.64, 54.17),
                ['States'] = {
                    ['Open'] = 160.0,
                    ['Closed'] = 250.0,
                },
            }
        },
        [3] = {
            ['Name'] = 'Hawick Bank',
            ['Hacked'] = false,
            ['CanUsePanel'] = true,
            ['Trolly'] = {
                ['Coords'] = vector4(-353.52, -58.73, 49.01, 144.83),
                ['Busy'] = false,
            },
            ['Doors'] = {
                ['Model'] = GetHashKey("v_ilev_gb_vauldr"),
                ['Coords'] = vector3(-352.89, -54.28, 48.92),
                ['States'] = {
                    ['Open'] = 160.0,
                    ['Closed'] = 250.0,
                },
            }
        },
        [4] = {
            ['Name'] = 'Rockford Bank',
            ['Hacked'] = false,
            ['CanUsePanel'] = true,
            ['Trolly'] = {
                ['Coords'] = vector4(-1208.03, -338.61, 37.76, 191.52),
                ['Busy'] = false,
            },
            ['Doors'] = {
                ['Model'] = GetHashKey("v_ilev_gb_vauldr"),
                ['Coords'] = vector3(-1210.72, -335.23, 37.79),
                ['States'] = {
                    ['Open'] = 205.0,
                    ['Closed'] = 295.0,
                },
            }
        },
        [5] = {
            ['Name'] = 'Del Perro Bank',
            ['Hacked'] = false,
            ['CanUsePanel'] = true,
            ['Trolly'] = {
                ['Coords'] = vector4(-1310.87, -811.96, 17.15, 25.42),
                ['Busy'] = false,
            },
            ['Doors'] = {
                ['Model'] = GetHashKey("v_ilev_bk_vaultdoor"),
                ['Coords'] = vector3(-1307.5, -816.73, 17.3),
                ['States'] = {
                    ['Open'] = 245.0,
                    ['Closed'] = 37.0,
                },
            }
        },
        [6] = {
            ['Name'] = 'Highway Bank',
            ['Hacked'] = false,
            ['CanUsePanel'] = true,
            ['Trolly'] = {
                ['Coords'] = vector4(-2953.31, 483.15, 15.68, 263.79),
                ['Busy'] = false,
            },
            ['Doors'] = {
                ['Model'] = GetHashKey("hei_prop_heist_sec_door"),
                ['Coords'] = vector3(-2953.19, 483.16, 15.68),
                ['States'] = {
                    ['Open'] = 265.0,
                    ['Closed'] = 357.0,
                },
            }
        },
        [7] = {
            ['Name'] = 'Sandy Bank',
            ['Hacked'] = false,
            ['CanUsePanel'] = true,
            ['Trolly'] = {
                ['Coords'] = vector4(1174.35, 2716.1, 38.07, 354.22),
                ['Busy'] = false,
            },
            ['Doors'] = {
                ['Model'] = GetHashKey("v_ilev_gb_vauldr"),
                ['Coords'] = vector3(1175.56, 2711.62, 38.27),
                ['States'] = {
                    ['Open'] = 356.0,
                    ['Closed'] = 90.0,
                },
            }
        },
        [8] = {
            ['Name'] = 'Paleto Bank',
            ['Hacked'] = false,
            ['CanUsePanel'] = true,
            ['Trolly'] = {
                ['Coords'] = vector4(-102.8, 6476.77, 31.63, 311.02),
                ['Busy'] = false,
            },
            ['Doors'] = {
                ['Model'] = GetHashKey("v_ilev_cbankvauldoor01"),
                ['Coords'] = vector3(-105.24, 6473.05, 31.63),
                ['States'] = {
                    ['Open'] = 139.0,
                    ['Closed'] = 45.0,
                },
            }
        },
    },
}

-- [ Stores ] --

Config.Registers = {
    {['Coords'] = vector3(24.9, -1344.94, 29.86), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(24.9, -1347.3, 29.89), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(-48.5, -1759.23, 29.73), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(-47.18, -1757.6, 29.77), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(1134.71, -982.37, 46.77), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(-706.6, -915.68, 19.56), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(-706.61, -913.66, 19.56), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(-1222.26, -907.89, 12.69), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(373.55, 328.59, 103.97), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(372.97, 326.36, 103.91), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(1164.6, -324.9, 69.57), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(1164.23, -322.86, 69.55), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(-1486.69, -378.43, 40.49), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(-2967.01, 390.91, 15.45), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(-3041.35, 584.24, 8.36), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(-3039.13, 584.9, 8.26), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(-3244.57, 1000.58, 13.19), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(-3242.27, 1000.41, 13.2), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(548.69, 2671.24, 42.51), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(548.96, 2668.97, 42.5), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(1165.93, 2710.24, 38.49), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(2678.24, 3279.78, 55.62), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(2676.16, 3280.92, 55.58), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(1959.3, 3742.3, 32.73), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(1960.47, 3740.23, 32.74), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(1696.65, 4924.53, 42.45), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(1698.34, 4923.32, 42.37), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(1729.3, 6417.14, 35.36), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(1728.26, 6415.07, 35.4), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(2554.89, 381.36, 108.98), ['Busy'] = false, ['Robbed'] = false},
    {['Coords'] = vector3(2557.2, 381.27, 108.99), ['Busy'] = false, ['Robbed'] = false},
}

-- [ Jewellery ] --

Config.JewelleryDoors = { 187, 188 }
Config.JewelleryState = false
Config.JewelleryVitrines = { [1] = false, [2] = false, [3] = false, [4] = false, [5] = false, [6] = false, [7] = false, [8] = false, [9] = false, [10] = false, [11] = false, [12] = false, [13] = false }

Config.JewelleryWeapons = {
    [GetHashKey("weapon_uzi")] = true,
    [GetHashKey("weapon_mac10")] = true,
    [GetHashKey("weapon_m70")] = true,
    [GetHashKey("weapon_ak47")] = true,
    [GetHashKey("weapon_m4")] = true,
    [GetHashKey("weapon_remington")] = true,
    [GetHashKey("weapon_mpx")] = true,
    [GetHashKey("weapon_draco")] = true,
}

-- Bobcat

Config.OutsideDoorsThermited, Config.InsideDoorsThermited = false, false
Config.BobcatDoors = { 200, 201, 203, 204 }
Config.BobcatExploded = false

Config.LootSpots = {
    [1] = true,
    [2] = true,
    [3] = true,
}

-- Houses
Config.Houses = {
    Cops = 2,
    Houses = {
        -- furnitured_motel
        -- furnitured_lowapart
        {
            Id = 1,
            Coords = vector4(-167.49, -1534.48, 35.1, 144.17),
            Shell = 'furnitured_motel',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 2,
            Coords = vector4(-174.55, -1528.49, 34.35, 136.58),
            Shell = 'furnitured_motel',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 3,
            Coords = vector4(-180.32, -1534.52, 34.36, 231.93),
            Shell = 'furnitured_motel',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 4,
            Coords = vector4(-184.37, -1539.55, 34.36, 228.32),
            Shell = 'furnitured_motel',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 5,
            Coords = vector4(-196.39, -1555.74, 34.96, 229.0),
            Shell = 'furnitured_motel',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 6,
            Coords = vector4(-192.11, -1559.88, 34.95, 315.54),
            Shell = 'furnitured_motel',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 7,
            Coords = vector4(-187.13, -1563.33, 35.76, 44.54),
            Shell = 'furnitured_motel',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 8,
            Coords = vector4(-179.74, -1554.11, 35.13, 48.4),
            Shell = 'furnitured_motel',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 9,
            Coords = vector4(-173.6, -1547.2, 35.13, 47.48),
            Shell = 'furnitured_motel',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 10,
            Coords = vector4(-167.37, -1534.43, 38.33, 135.2),
            Shell = 'furnitured_motel',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 11,
            Coords = vector4(-174.6, -1528.46, 37.54, 140.01),
            Shell = 'furnitured_motel',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 12,
            Coords = vector4(-180.18, -1534.31, 37.54, 234.01),
            Shell = 'furnitured_motel',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 13,
            Coords = vector4(-184.51, -1539.45, 37.54, 232.07),
            Shell = 'furnitured_motel',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 14,
            Coords = vector4(-196.36, -1555.71, 38.33, 230.69),
            Shell = 'furnitured_motel',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 15,
            Coords = vector4(-192.14, -1559.91, 38.34, 320.19),
            Shell = 'furnitured_motel',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 16,
            Coords = vector4(-187.09, -1563.27, 39.13, 54.97),
            Shell = 'furnitured_motel',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 17,
            Coords = vector4(-179.57, -1554.32, 38.33, 47.62),
            Shell = 'furnitured_motel',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 18,
            Coords = vector4(-173.68, -1547.3, 38.33, 49.98),
            Shell = 'furnitured_motel',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 19,
            Coords = vector4(-141.49, -1693.02, 32.87, 136.54),
            Shell = 'furnitured_motel',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 20,
            Coords = vector4(-146.96, -1688.43, 33.07, 140.96),
            Shell = 'furnitured_motel',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 21,
            Coords = vector4(-157.89, -1679.82, 33.84, 226.95),
            Shell = 'furnitured_motel',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 22,
            Coords = vector4(-146.96, -1688.43, 33.07, 140.96),
            Shell = 'furnitured_motel',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 23,
            Coords = vector4(-148.06, -1687.49, 36.17, 140.83),
            Shell = 'furnitured_motel',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 24,
            Coords = vector4(-141.63, -1693.58, 36.17, 51.72),
            Shell = 'furnitured_motel',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 25,
            Coords = vector4(952.8, -252.35, 67.96, 60.91),
            Shell = 'furnitured_lowapart',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 26,
            Coords = vector4(930.67, -244.99, 69.0, 231.84),
            Shell = 'furnitured_lowapart',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 27,
            Coords = vector4(920.84, -238.15, 70.39, 155.54),
            Shell = 'furnitured_lowapart',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 28,
            Coords = vector4(840.76, -182.16, 74.39, 56.31),
            Shell = 'furnitured_lowapart',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 29,
            Coords = vector4(808.72, -163.6, 75.88, 152.25),
            Shell = 'furnitured_lowapart',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 30,
            Coords = vector4(773.94, -149.83, 75.62, 149.82),
            Shell = 'furnitured_lowapart',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 31,
            Coords = vector4(-1970.43, 246.1, 87.81, 287.09),
            Shell = 'furnitured_lowapart',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 32,
            Coords = vector4(-1995.27, 300.86, 91.97, 189.05),
            Shell = 'furnitured_lowapart',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 33,
            Coords = vector4(-2009.21, 367.38, 94.81, 266.06),
            Shell = 'furnitured_lowapart',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 34,
            Coords = vector4(-1940.64, 387.45, 96.51, 188.98),
            Shell = 'furnitured_lowapart',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 35,
            Coords = vector4(-1942.86, 449.67, 102.93, 97.35),
            Shell = 'furnitured_lowapart',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
        {
            Id = 36,
            Coords = vector4(-2014.91, 499.87, 107.17, 255.43),
            Shell = 'furnitured_lowapart',
            Available = true,
            Alarm = true,
            Locked = true,
            Loot = {},
            Timer = 35,
        },
    },
    Offsets = {
        ['furnitured_lowapart'] = {
            { Type = 'Kitchen', Coords = vector3(5.67, 0.12, 0.34) },
            { Type = 'Kitchen', Coords = vector3(4.59, 4.34, 0.34) },
            { Type = 'House', Coords = vector3(1.83, 4.73, 0.34) },
            { Type = 'House', Coords = vector3(-3.14, 4.07, 0.34) },
            { Type = 'Shower', Coords = vector3(1.44, -2.73, 0.34) },
            { Type = 'Bed', Coords = vector3(-4.41, -1.50, 0.34) },
        },
        ['furnitured_motel'] = {
            { Type = 'Bed', Coords = vector3(1.926666, -1.686646, -0.3565521) },
            { Type = 'Bed', Coords = vector3(1.938095, 0.6599121, -0.3601608) },
            { Type = 'House', Coords = vector3(-1.746704, 0.9829102, -0.3601761) },
        },
    },
}

-- [ Misc ] --

Config.MaleNoHandshoes = {
    [0] = true, [1] = true, [2] = true, [3] = true,
    [4] = true, [5] = true, [6] = true, [7] = true,
    [8] = true, [9] = true, [10] = true, [11] = true,
    [12] = true, [13] = true, [14] = true, [15] = true,
    [18] = true, [52] = true, [53] = true,
    [54] = true, [55] = true, [56] = true, [57] = true,
    [58] = true, [59] = true, [60] = true, [61] = true,
    [62] = true, [112] = true, [113] = true, [114] = true,
    [118] = true, [125] = true, [132] = true,
}

Config.FemaleNoHandshoes = {
    [0] = true, [1] = true, [2] = true, [3] = true,
    [4] = true, [5] = true, [6] = true, [7] = true,
    [8] = true, [9] = true, [10] = true, [11] = true,
    [12] = true, [13] = true, [14] = true, [15] = true,
    [19] = true, [59] = true, [60] = true, [61] = true,
    [62] = true, [63] = true, [64] = true, [65] = true,
    [66] = true, [67] = true, [68] = true, [69] = true,
    [70] = true, [71] = true, [129] = true, [130] = true,
    [131] = true, [135] = true, [142] = true, [149] = true,
    [153] = true, [157] = true, [161] = true,[165] = true,
}