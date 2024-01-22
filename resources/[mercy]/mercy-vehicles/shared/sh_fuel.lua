Config.FuelPrice, Config.ChargePrice, Config.AddingAmount = 10, 5, 2

Config.ElectricVehicles = {
    "surge",
    "iwagen",
    "voltic",
    "voltic2",
    "raiden",
    "cyclone",
    "tezeract",
    "neon",
    "omnisegt",
    "iwagen",
    "caddy",
    "caddy2",
    "caddy3",
    "airtug",
    "rcbandito",
    "imorgon",
    "dilettante",
    "khamelion",
}

Config.Chargers = {
    {
        ['Charger'] = nil,
        ['Coords'] = vector4(175.9, -1546.65, 28.26, 224.29),
    },
    {
        ['Charger'] = nil,
        ['Coords'] = vector4(-51.09, -1767.02, 28.26, 47.16),
    },
    {
        ['Charger'] = nil,
        ['Coords'] = vector4(-514.06, -1216.25, 17.46, 66.29),
    },
    {
        ['Charger'] = nil,
        ['Coords'] = vector4(-704.64, -935.71, 18.21, 90.02),
    },
    {
        ['Charger'] = nil,
        ['Coords'] = vector4(279.79, -1237.35, 28.35, 181.07),
    },
    {
        ['Charger'] = nil,
        ['Coords'] = vector4(834.27, -1028.7, 26.16, 88.39),
    },
    {
        ['Charger'] = nil,
        ['Coords'] = vector4(1194.41, -1394.44, 34.37, 270.3),
    },
    {
        ['Charger'] = nil,
        ['Coords'] = vector4(1168.38, -323.56, 68.3, 280.22),
    },
    {
        ['Charger'] = nil,
        ['Coords'] = vector4(633.64, 247.22, 102.3, 60.29),
    },
    {
        ['Charger'] = nil,
        ['Coords'] = vector4(-1420.51, -278.76, 45.26, 137.35),
    },
    {
        ['Charger'] = nil,
        ['Coords'] = vector4(-2080.61, -338.52, 12.26, 352.21),
    },
    {
        ['Charger'] = nil,
        ['Coords'] = vector4(-98.12, 6403.39, 30.64, 141.49),
    },
    {
        ['Charger'] = nil,
        ['Coords'] = vector4(181.14, 6636.17, 30.61, 179.96),
    },
    {
        ['Charger'] = nil,
        ['Coords'] = vector4(1714.14, 6425.44, 31.79, 155.94),
    },
    {
        ['Charger'] = nil,
        ['Coords'] = vector4(1703.57, 4937.23, 41.08, 55.74),
    },
    {
        ['Charger'] = nil,
        ['Coords'] = vector4(1994.54, 3778.44, 31.18, 215.25),
    },
    {
        ['Charger'] = nil,
        ['Coords'] = vector4(1770.86, 3337.97, 40.43, 301.1),
    },
    {
        ['Charger'] = nil,
        ['Coords'] = vector4(2690.25, 3265.62, 54.24, 58.98),
    },
    {
        ['Charger'] = nil,
        ['Coords'] = vector4(1208.26, 2649.46, 36.85, 222.32),
    },
    {
        ['Charger'] = nil,
        ['Coords'] = vector4(1033.32, 2662.91, 38.55, 95.38),
    },
    {
        ['Charger'] = nil,
        ['Coords'] = vector4(267.96, 2599.47, 43.69, 5.8),
    },
    {
        ['Charger'] = nil,
        ['Coords'] = vector4(50.21, 2787.38, 56.88, 147.2),
    },
    {
        ['Charger'] = nil,
        ['Coords'] = vector4(-2570.04, 2317.1, 32.22, 21.29),
    },
    {
        ['Charger'] = nil,
        ['Coords'] = vector4(2545.81, 2586.18, 36.94, 83.74),
    },
    {
        ['Charger'] = nil,
        ['Coords'] = vector4(2561.24, 357.3, 107.62, 266.65),
    },
    {
        ['Charger'] = nil,
        ['Coords'] = vector4(-1819.22, 798.51, 137.16, 315.13),
    },
    {
        ['Charger'] = nil,
        ['Coords'] = vector4(-341.63, -1459.39, 29.76, 271.73),
    },
}

Config.GasStations = {
     -- Paleto PD, Helicopter
     {
        center = vector3(-475.14, 5988.95, 31.34),
        length = 28.4,
        width = 20.6,
        heading = 45,
        minZ = 30.34,
        maxZ = 36.74,
        data = {
            vehicleClass = 15
        }
    },

    -- -- VBPD, Helicopter
    -- {
    --     center = vector3(-1095.41, -835.28, 37.68),
    --     length = 11.0,
    --     width = 10.8,
    --     heading = 39,
    --     minZ = 36.68,
    --     maxZ = 43.08,
    --     data = {
    --         vehicleClass = 15
    --     }
    -- },

    -- Marina, Helicopter
    {
        center = vector3(-724.52, -1444.08, 5.0),
        length = 15.0,
        width = 15.2,
        heading = 50,
        minZ = 4.0,
        maxZ = 10.4,
        data = {
            vehicleClass = 15
        }
    },

    -- -- MRPD, Helicopter
    -- {
    --     center = vector3(481.83, -982.1, 41.01),
    --     length = 11.0,
    --     width = 10.8,
    --     heading = 91,
    --     minZ = 40.01,
    --     maxZ = 46.41,
    --     data = {
    --         vehicleClass = 15
    --     }
    -- },

    -- Grapeseed, Airplane
    {
        center = vector3(2104.14, 4784.48, 41.06),
        length = 11.0,
        width = 10.8,
        heading = 116,
        minZ = 40.06,
        maxZ = 46.46,
        data = {
            vehicleClass = 16
        }
    },

    -- Sandy Shores, Airplane
    {
        center = vector3(1734.57, 3298.99, 41.11),
        length = 16.4,
        width = 42.4,
        heading = 104,
        minZ = 40.11,
        maxZ = 46.51,
        data = {
            vehicleClass = 16
        }
    },

    -- Sandy Shores, Helicopter
    {
        center = vector3(1770.36, 3239.85, 41.36),
        length = 14.0,
        width = 14.8,
        heading = 15,
        minZ = 40.79,
        maxZ = 45.79,
        data = {
            vehicleClass = 15
        }
    },

    -- LSIA, Airplane
    {
        center = vector3(-1272.96, -3383.31, 13.94),
        length = 38.8,
        width = 46.8,
        heading = 60,
        minZ = 12.94,
        maxZ = 21.54,
        data = {
            vehicleClass = 16
        }
    },

    -- Drift School, Cars
    {
        blip = true,
        center = vector3(-66.37, -2532.39, 6.01),
        length = 20.2,
        width = 18.8,
        heading = 54,
        minZ = 4.86,
        maxZ = 10.86
    },

    -- Innocence Blvd / La Puerta, Cars
    {
        blip = true,
        center = vector3(-319.98, -1471.75, 30.72),
        length = 19.4,
        width = 28.6,
        heading = 30,
        minZ = 29.57,
        maxZ = 35.57
    },

    -- Panorama Drive, Sandy, Cars
    {
        blip = true,
        center = vector3(1785.61, 3330.48, 41.24),
        length = 7.6,
        width = 6.05,
        heading = 29,
        minZ = 40.09,
        maxZ = 46.09
    },

    -- Palamino Freway, Cars
    {
        blip = true,
        center = vector3(2580.96, 361.65, 108.46),
        length = 24.2,
        width = 15.45,
        heading = 88,
        minZ = 107.46,
        maxZ = 111.26
    },

    -- Clinton Avenue, Cars
    {
        blip = true,
        center = vector3(621.11, 269.04, 103.03),
        length = 28.0,
        width = 19.25,
        heading = 90,
        minZ = 102.03,
        maxZ = 105.83
    },

    -- Mirror Park Blvd, Cars
    {
        blip = true,
        center = vector3(1181.16, -330.36, 69.18),
        length = 25.8,
        width = 22.05,
        heading = 10,
        minZ = 68.18,
        maxZ = 71.98
    },

    -- El Rancho Blvd, Cars
    {
        blip = true,
        center = vector3(1208.43, -1402.33, 35.23),
        length = 18.55,
        width = 8.65,
        heading = 45,
        minZ = 34.23,
        maxZ = 38.03
    },

    -- Vespucci Blvd, Cars
    {
        blip = true,
        center = vector3(818.88, -1029.24, 26.12),
        length = 29.15,
        width = 17.05,
        heading = 271,
        minZ = 25.12,
        maxZ = 28.92
    },

    -- Strawberry, Cars
    {
        blip = true,
        center = vector3(264.06, -1261.88, 29.17),
        length = 30.55,
        width = 23.65,
        heading = 269,
        minZ = 28.17,
        maxZ = 31.97
    },

    -- Grove Street, Cars
    {
        blip = true,
        center = vector3(-70.69, -1761.35, 29.39),
        length = 28.55,
        width = 15.65,
        heading = 249,
        minZ = 28.39,
        maxZ = 32.19
    },

    -- Calais Ave / Dutch London, Cars
    {
        blip = true,
        center = vector3(-525.44, -1211.17, 18.18),
        length = 24.55,
        width = 17.65,
        heading = 247,
        minZ = 17.18,
        maxZ = 20.98
    },

    -- Lindsay Circus, Cars
    {
        blip = true,
        center = vector3(-723.7, -935.56, 19.01),
        length = 25.95,
        width = 14.45,
        heading = 270,
        minZ = 18.01,
        maxZ = 21.81
    },

    -- West Eclipse Blvd, Cars
    {
        blip = true,
        center = vector3(-2096.84, -318.99, 13.02),
        length = 26.15,
        width = 20.85,
        heading = 264,
        minZ = 12.02,
        maxZ = 15.82
    },

    -- Perth Street, Cars
    {
        blip = true,
        center = vector3(-1436.6, -275.84, 46.56),
        length = 19.75,
        width = 19.05,
        heading = 221,
        minZ = 45.16,
        maxZ = 48.96
    },

    -- North Rockford Drive, Cars
    {
        blip = true,
        center = vector3(-1799.94, 803.18, 138.7),
        length = 16.15,
        width = 26.25,
        heading = 224,
        minZ = 137.3,
        maxZ = 141.1
    },

    -- Route 68, Cars
    {
        blip = true,
        center = vector3(-2555.18, 2332.81, 33.06),
        length = 16.15,
        width = 27.05,
        heading = 274,
        minZ = 31.66,
        maxZ = 35.46
    },

    -- Cascabel Avenue, Cars
    {
        blip = true,
        center = vector3(-93.79, 6420.09, 31.42),
        length = 10.2,
        width = 14.0,
        heading = 45,
        minZ = 30.37,
        maxZ = 34.37
    },

    -- Paleto Gas Station, Cars
    {
        blip = true,
        center = vector3(179.51, 6602.49, 31.85),
        length = 15.4,
        width = 27.8,
        heading = 10,
        minZ = 30.8,
        maxZ = 34.8
    },

    -- Great Ocean  Highway / Paleto, Cars
    {
        blip = true,
        center = vector3(1701.99, 6416.48, 32.61),
        length = 14.0,
        width = 10.6,
        heading = 65,
        minZ = 31.61,
        maxZ = 35.61
    },

    -- Grapeseed, Cars
    {
        blip = true,
        center = vector3(1687.92, 4929.84, 42.08),
        length = 14.6,
        width = 10.2,
        heading = 55,
        minZ = 41.08,
        maxZ = 45.08
    },

    -- Marina Drive, Cars
    {
        blip = true,
        center = vector3(2005.41, 3774.53, 32.18),
        length = 14.6,
        width = 10.2,
        heading = 299,
        minZ = 31.18,
        maxZ = 35.18
    },

    -- Senora Fwy, Cars
    {
        blip = true,
        center = vector3(2680.2, 3264.51, 55.24),
        length = 14.6,
        width = 10.2,
        heading = 151,
        minZ = 54.24,
        maxZ = 58.24
    },

    -- Senora Way, Cars
    {
        blip = true,
        center = vector3(2536.92, 2593.69, 37.95),
        length = 4.0,
        width = 4.8,
        heading = 113,
        minZ = 36.95,
        maxZ = 40.95
    },

    -- Route 68, Harmony, Cars
    {
        blip = true,
        center = vector3(1208.14, 2660.14, 37.81),
        length = 10.6,
        width = 9.4,
        heading = 135,
        minZ = 36.81,
        maxZ = 40.81
    },

    -- Route 68, Motel, Cars
    {
        blip = true,
        center = vector3(1038.76, 2671.25, 39.55),
        length = 17.6,
        width = 13.6,
        heading = 90,
        minZ = 38.55,
        maxZ = 42.55
    },

    -- Route 68, Joshua Road, Cars
    {
        blip = true,
        center = vector3(264.23, 2607.21, 44.98),
        length = 7.0,
        width = 9.2,
        heading = 100,
        minZ = 43.98,
        maxZ = 47.98
    },

    -- Route 68, Approach, Cars
    {
        blip = true,
        center = vector3(50.05, 2778.29, 57.88),
        length = 9.8,
        width = 10.8,
        heading = 52,
        minZ = 56.88,
        maxZ = 60.88
    },

    -- Above toolshop LS
    {
        blip = true,
        center = vector3(176.35, -1562.06, 29.27),
        length = 23.4,
        width = 18.4, 
        heading = 314,
        minZ = 28.27,
        maxZ = 33.87, 
    },


    -- Flight school, Helicopter
    {
        center = vector3(-1877.15, 2805.01, 32.81),
        length = 13.4,
        width = 12.6,
        heading = 330,
        minZ = 31.81,
        maxZ = 35.81,
        data = {
            vehicleClass = 15
        }
    },

    -- Flight school, Airplane
    {
        center = vector3(-1818.56, 2966.05, 32.81),
        length = 14.6,
        width = 15.6,
        heading = 330,
        minZ = 31.61,
        maxZ = 35.61,
        data = {
            vehicleClass = 16
        }
    },

    
    -- -- Sandy PD, Helicopters
    -- {
    --     center = vector3(1853.24, 3706.56, 33.98),
    --     length = 10.0,
    --     width = 10.0,
    --     heading = 31.0,
    --     minZ = 32.0,
    --     maxZ = 38.0,
    --     data = {
    --         vehicleClass = 15
    --     }
    -- },

    -- Crusade Hospital, Helicopters
    -- {
    --     center = vector3(299.77, -1453.53, 46.51),
    --     length = 11.0,
    --     width = 11.4,
    --     heading = 320,
    --     minZ = 45.51,
    --     maxZ = 49.51,
    --     data = {
    --         vehicleClass = 15
    --     }
    -- },
}