Config = Config or {}

-- Damage System

Config.BodySafeGuard, Config.EngineSafeGuard = 50.0, 50.0

-- Vehicle Keys

Config.VehicleKeys = {}

-- Main Data

Config.VehicleData = {}

-- Gov Vehicles
Config.EmsVehicles = { 'emsspeedo', 'emsexp', 'emstau', 'emsbike' }
Config.PoliceVehicles = { 'polvic', 'polchal', 'polstang', 'polvette', 'poltaurus', 'polexp', 'polchar', 'polblazer', 'polmotor', 'policeb', 'ucbanshee', 'ucrancher', 'ucbuffalo', 'ucballer', 'pbus' }

-- Rental

Config.RentalSpawn = {
    Cars = vector4(117.84, -1079.95, 29.23, 355.92),
    Boats = vector4(-845.19, -1361.23, 0.09, 109.32)
}

Config.Rentals = {
    Cars = {
        -- { Label = "Boat Trailer", Model = "boattrailer", Price = 500 },
        { Label = "Bison", Model = "bison", Price = 500 },
        { Label = "Enus", Model = "cog55", Price = 1500 },
        { Label = "Futo", Model = "Futo", Price = 600 },
        { Label = "Buccaneer", Model = "buccaneer", Price = 625},
        -- { Label = "Sultan", Model = "sultan", Price = 700 },
        -- { Label = "Buffalo S", Model = "buffalo2", Price = 725),
        { Label = "Scooter", Model = "faggio", Price = 750 },
        { Label = "Sanchez", Model = "sanchez", Price = 10000 },
        { Label = "Coach", Model = "coach", Price = 800 },
        { Label = "Shuttle Bus", Model = "rentalbus", Price = 800 },
        { Label = "Tour Bus", Model = "tourbus", Price = 800 },
        { Label = "Taco Truck", Model = "nptaco", Price = 800 },
        { Label = "Limo", Model = "stretch", Price = 1500 },
        { Label = "Hearse", Model = "romero", Price = 1500 },
        { Label = "Clown Car", Model = "speedo2", Price = 5000 },
        { Label = "Festival Bus", Model = "pbus2", Price = 10000 },
    },
    Boats = {
        { Label = "Jet Ski", Model = "seashark", Price = 250 },
        { Label = "Suntrap", Model = "suntrap", Price = 500 },
        { Label = "Squalo", Model = "squalo", Price = 500 },
        { Label = "Speeder", Model = "speeder", Price = 750 },
        { Label = "Dinghy", Model = "dinghy", Price = 1000 },
        { Label = "Marquis", Model = "marquis", Price = 1250 },
        { Label = "Submersible", Model = "submersible", Price = 2000 },
    }
}

-- Fuel

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

-- Garages

Config.DepotSpots = {
    vector4(-194.48, -1173.57, 23.04, 192.74),
    vector4(-191.24, -1173.26, 23.04, 194.86),
    vector4(-187.66, -1173.72, 23.04, 195.35),
    vector4(-184.01, -1173.63, 23.04, 198.56),
}

Config.Garages = {
    ['apartment_1'] = {
        Blip = { Sprite = 357, Color = 3, Text = "Garage" },
        Zone = { vector3(-320.51, -982.35, 31.08), 6.6, 51.8, 340, 30.08, 34.08 },
        Spots = {
            vector4(-297.85, -990.41, 30.48, 159.99),
            vector4(-301.24, -989.18, 30.48, 159.99),
            vector4(-304.62, -987.94, 30.48, 159.99),
            vector4(-308.0, -986.71, 30.48, 159.99),
            vector4(-311.48, -985.44, 30.48, 159.99),
            vector4(-315.05, -984.14, 30.48, 159.99),
            vector4(-318.4, -982.84, 30.48, 158.89),
            vector4(-321.86, -981.51, 30.48, 159.36),
            vector4(-325.42, -980.2, 30.48, 159.84),
            vector4(-328.9, -978.92, 30.48, 159.84),
            vector4(-332.37, -977.64, 30.48, 159.84),
            vector4(-335.65, -976.43, 30.48, 159.84),
            vector4(-339.22, -975.13, 30.48, 159.92),
            vector4(-342.76, -973.74, 30.48, 158.66),
        },
    },
    ['legionsquare_1'] = {
        Blip = { Sprite = 357, Color = 3, Text = "Garage" },
        Zone = { vector3(219.81, -801.88, 30.74), 10.95, 10, 338, 29.74, 33.74 },
        Spots = {
            vector4(220.49, -806.56, 30.69, 240.71),
            vector4(221.60, -804.05, 30.69, 240.71),
            vector4(222.80, -801.57, 30.69, 240.71),
            vector4(223.58, -798.93, 30.69, 240.71),
            vector4(215.76, -804.36, 30.69, 68.45),
            vector4(216.48, -801.75, 30.69, 68.45),
            vector4(217.00, -799.08, 30.69, 68.45),
            vector4(218.49, -796.84, 30.69, 68.45),
        },
    },
    ['paletobay_1'] = {
        Blip = { Sprite = 357, Color = 3, Text = "Garage" },
        Zone = { vector3(66.65, 6402.56, 30.61), 18.2, 18.0, 45, 29.61, 33.61 },
        Spots = {
            vector4(62.28, 6403.58, 31.22, 32.89),
            vector4(59.37, 6400.46, 31.22, 32.89),
            vector4(65.02, 6405.86, 31.22, 32.89),
            vector4(72.11, 6403.87, 31.22, 310.32),
            vector4(75.05, 6401.27, 31.22, 310.32),
        },
    },
    ['mrpd_1'] = {
        Zone = { vector3(442.55, -1026.12, 28.09), 17.8, 5.8, 277, 27.09, 31.09 },
        Spots = {
            vector4(449.55, -1025.67, 28.24, 4.01),
            vector4(446.0, -1025.5, 28.44, 5.66),
            vector4(442.32, -1025.89, 28.51, 7.06),
            vector4(439.01, -1026.28, 28.57, 6.24),
            vector4(435.63, -1027.01, 28.65, 5.96),
        },
    },
    ['tunershop_1'] = {
        Blip = { Sprite = 357, Color = 3, Text = "Garage" },
        Zone = { vector3(163.92, -2999.51, 5.31), 23.0, 9.4, 0, 4.31, 8.31 },
        Spots = {
            vector4(162.79, -3009.26, 5.9, 269.83),
            vector4(163.37, -3006.26, 5.9, 270.32),
            vector4(162.99, -3003.03, 5.9, 271.79),
            vector4(163.23, -2996.33, 5.9, 272.05),
            vector4(162.88, -2993.01, 5.9, 271.45),
            vector4(163.04, -2989.69, 5.9, 268.68),
        },
    },
    ['hayes_1'] = {
        Blip = { Sprite = 357, Color = 3, Text = "Garage" },
        Zone = { vector3(-1376.83, -449.41, 33.86), 6.0, 14.0, 35, 32.86, 36.86 },
        Spots = {
            vector4(-1372.28, -446.28, 34.14, 215.03),
            vector4(-1374.64, -447.94, 34.14, 216.91),
            vector4(-1376.7, -449.84, 34.14, 216.41),
            vector4(-1378.74, -451.24, 34.14, 218.4),
            vector4(-1381.24, -452.76, 34.14, 215.53),
        },
    },
    ['townhall_1'] = {
        Blip = { Sprite = 357, Color = 3, Text = "Garage" },
        Zone = { vector3(-487.36, -198.02, 37.01), 4.4, 48.6, 300, 35.01, 40.01 },
        Spots = {
            vector4(-497.73, -180.1, 37.04, 209.51),
            vector4(-494.96, -185.04, 36.9, 209.43),
            vector4(-492.23, -189.91, 36.75, 209.35),
            vector4(-489.14, -195.44, 36.58, 209.27),
            vector4(-486.07, -200.96, 36.42, 209.17),
            vector4(-483.19, -206.16, 36.27, 209.09),
            vector4(-479.88, -211.35, 36.11, 210.09),
            vector4(-477.18, -216.04, 35.97, 209.97),
        },
    },
    ['crusade_hospital_1'] = {
        Blip = { Sprite = 357, Color = 3, Text = "Garage" },
        Zone = { vector3(307.19, -1378.41, 31.85), 31.2, 6.0, 320, 29.45, 34.45 },
        Spots = {
            vector4(299.48, -1388.08, 30.82, 320.39),
            vector4(303.0, -1383.13, 31.13, 321.76),
            vector4(307.17, -1378.36, 31.3, 318.69),
            vector4(311.07, -1373.94, 31.33, 318.54),
            vector4(314.93, -1369.59, 31.31, 318.31)
        },
    },  
    ['pizzeria_1'] = {
        Blip = { Sprite = 357, Color = 3, Text = "Garage" },
        Zone = { vector3(805.49, -727.63, 27.01), 17.0, 7.6, 40, 26.01, 30.01 },
        Spots = {
            vector4(800.35, -722.85, 27.37, 135.99),
            vector4(803.23, -724.64, 27.15, 132.82),
            vector4(805.4, -727.51, 27.0, 135.65),
            vector4(807.61, -730.11, 26.97, 132.15),
            vector4(809.67, -733.17, 26.97, 134.34),
        },
    },
    ['airport_1'] = {
        Blip = { Sprite = 307, Color = 3, Text = "Vliegtuig Garage" },
        Zone = { vector3(-1664.01, -3131.58, 13.99), 20.0, 20.0, 330, 12.9, 18.9 },
        Spots = {
            vector4(-1664.01, -3131.58, 13.99, 330.19)
        },
    },
    ['gov_mrpd'] = {
        Zone = { vector3(441.61, -991.6, 25.7), 13.8, 12.6, 0, 24.7, 28.5 },
        Spots = {
            vector4(437.41, -996.92, 25.18, 92.02),
            vector4(437.24, -994.38, 25.18, 90.22),
            vector4(437.42, -991.61, 25.18, 91.11),
            vector4(437.64, -988.92, 25.18, 89.45),
            vector4(437.37, -986.13, 25.18, 88.67),
            vector4(445.51, -996.89, 25.18, 267.83),
            vector4(445.15, -994.18, 25.18, 268.86),
            vector4(445.78, -991.69, 25.18, 269.05),
            vector4(445.59, -988.96, 25.18, 270.15),
            vector4(445.55, -986.11, 25.18, 270.19),
        },
    },
    ['gov_vespucci'] = {
        Zone = { vector3(-1122.99, -830.36, 3.75), 17.0, 6.8, 306, 2.75, 5.95 },
        Spots = {
            vector4(-1117.68, -826.7, 3.03, 217.41),
            vector4(-1121.05, -829.03, 3.03, 214.65),
            vector4(-1124.51, -831.97, 3.03, 216.17),
            vector4(-1127.8, -834.07, 3.03, 218.78),
        },
    },
    ['gov_paleto'] = {
        Zone = { vector3(-475.58, 6031.99, 31.34), 24.4, 6.2, 315, 30.34, 34.34 },
        Spots = {
            vector4(-482.65, 6024.66, 30.62, 223.01),
            vector4(-479.59, 6027.9, 30.61, 224.57),
            vector4(-475.69, 6031.65, 30.61, 224.56),
            vector4(-472.39, 6035.63, 30.61, 226.22),
            vector4(-468.8, 6038.78, 30.61, 228.28),
        },
    },
    ['gov_sdso'] = {
        Zone = { vector3(1829.96, 3688.12, 33.97), 15.4, 5.0, 300, 32.97, 36.97 },
        Spots = {
            vector4(1834.99, 3691.12, 33.25, 30.85),
            vector4(1831.67, 3688.85, 33.25, 30.66),
            vector4(1828.54, 3686.9, 33.25, 28.15),
            vector4(1824.98, 3685.15, 33.25, 29.14),
        },
    },
}

Config.DefaultMeta = {
    Body = 1000.0, Engine = 1000.0, Fuel = 100.0, -- Defaults
    Harness = 0.0,
    Nitrous = 0.0,
    Flagged = false, -- To Do
    FakePlate = false, -- To Do
    WheelFitment = {
        Width = nil,
        FLOffset = nil,
        FROffset = nil,
        RLOffset = nil,
        RROffset = nil,
        FLRotation = nil,
        FRRotation = nil,
        RLRotation = nil,
        RRRotation = nil,
    }
}

Config.ImpoundList = {
    {
        Title = 'Vehicle Scuff',
        Desc = 'Vehicle stuck in unfixable state.',
        Hours = 0, Fee = 0, Strikes = 0,
        Reason = 'Vehicle Scuff',
        Gov = false,
    },
    {
        Title = 'Manual Depot',
        Desc = 'Send vehicle to depot by manually filling in everything.',
        Hours = 0, Fee = 0, Strikes = 0,
        Reason = '',
        Gov = true,
    },
    -- {
    --     Title = 'Depot Employee Request',
    --     Desc = 'Send notification to an Depot Employee.',
    --     Hours = 0, Fee = 0, Strikes = 0,
    --     Reason = '',
    --     Gov = true,
    -- },
}

-- Trunk

Config.DisabledTrunk = {
    [GetHashKey("penetrator")] = true,
    [GetHashKey("vacca")] = true,
    [GetHashKey("monroe")] = true,
    [GetHashKey("turismor")] = true,
    [GetHashKey("osiris")] = true,
    [GetHashKey("comet")] = true,
    [GetHashKey("ardent")] = true,
    [GetHashKey("jester")] = true,
    [GetHashKey("nero")] = true,
    [GetHashKey("nero2")] = true,
    [GetHashKey("vagner")] = true,
    [GetHashKey("infernus")] = true,
    [GetHashKey("zentorno")] = true,
    [GetHashKey("comet2")] = true,
    [GetHashKey("comet3")] = true,
    [GetHashKey("comet4")] = true,
    [GetHashKey("bullet")] = true,
    -- Addon
    [GetHashKey("s15")] = true,
    [GetHashKey("gtr")] = true,
    [GetHashKey("skyline")] = true,
}

-- Pursuit
Config.PursuitVehicles = {
    ['polvic'] = {
        ['B'] = { DriveForce = 0.271000, DriveInertia = 1.000000 },
        ['A'] = { DriveForce = 0.311000, DriveInertia = 1.100000 },
        ['S'] = { DriveForce = 0.351000, DriveInertia = 1.200000 },
    },
    ['polexp'] = {
        ['B'] = { DriveForce = 0.235000, DriveInertia = 1.000000 },
        ['A'] = { DriveForce = 0.275000, DriveInertia = 1.100000 },
        ['S'] = { DriveForce = 0.315000, DriveInertia = 1.200000 },
    },
    ['polchar'] = {
        ['B'] = { DriveForce = 0.271000, DriveInertia = 1.000000 },
        ['A'] = { DriveForce = 0.311000, DriveInertia = 1.100000 },
        ['S'] = { DriveForce = 0.351000, DriveInertia = 1.200000 },
    },
    ['polchal'] = {
        ['B'] = { DriveForce = 0.275069, DriveInertia = 1.000000 },
        ['A'] = { DriveForce = 0.315069, DriveInertia = 1.100000 },
        ['S'] = { DriveForce = 0.355069, DriveInertia = 1.200000 },
    },
    ['polstang'] = {
        ['B'] = { DriveForce = 0.270000, DriveInertia = 1.000000 },
        ['A'] = { DriveForce = 0.310000, DriveInertia = 1.100000 },
        ['S'] = { DriveForce = 0.350000, DriveInertia = 1.200000 },
    },
    ['polvette'] = {
        ['B'] = { DriveForce = 0.275000, DriveInertia = 1.000000 },
        ['A'] = { DriveForce = 0.315000, DriveInertia = 1.100000 },
        ['S'] = { DriveForce = 0.355000, DriveInertia = 1.200000 },
    },
}


-- Emergency Lights
--[[
    Airhorn
    AIRHORN_EQD - Generic Bullhorn               SirenSound - SIRENS_AIRHORN

    Police Bike
    SIREN_WAIL_03 - PoliceB Main                 SirenSound - RESIDENT_VEHICLES_SIREN_WAIL_03
    SIREN_QUICK_03 - PoliceB Secondary           SirenSound - RESIDENT_VEHICLES_SIREN_QUICK_03

    FIB
    SIREN_WAIL_02 - FIB Primary                  SirenSound - RESIDENT_VEHICLES_SIREN_WAIL_02
    SIREN_QUICK_02 - FIB Secondary               SirenSound - RESIDENT_VEHICLES_SIREN_QUICK_02

    Police
    SIREN_PA20A_WAIL - Police Primary            SirenSound - VEHICLES_HORNS_SIREN_1
    SIREN_2 - Police Secondary                   SirenSound - VEHICLES_HORNS_SIREN_2
    POLICE_WARNING     - Police Warning          SirenSound - VEHICLES_HORNS_POLICE_WARNING

    Ambulance
    SIREN_WAIL_01 - Ambulance Primary            SirenSound - RESIDENT_VEHICLES_SIREN_WAIL_01
    SIREN_QUICK_01 - Ambulance Secondary         SirenSound - RESIDENT_VEHICLES_SIREN_QUICK_01
    AMBULANCE_WARNING - Ambulance Warning        SirenSound - VEHICLES_HORNS_AMBULANCE_WARNING

    Fire Trucks
    FIRE_TRUCK_HORN - Fire Horn                  SirenSound - VEHICLES_HORNS_FIRETRUCK_WARNING
    SIREN_FIRETRUCK_WAIL_01 - Fire Primary       SirenSound - RESIDENT_VEHICLES_SIREN_FIRETRUCK_WAIL_01
    SIREN_FIRETRUCK_QUICK_01 - Fire Secondary    SirenSound - RESIDENT_VEHICLES_SIREN_FIRETRUCK_QUICK_01
]]

Config.SirenData = {
    [GetHashKey("polvic")] = {
        SirenSounds = { "VEHICLES_HORNS_SIREN_1", "VEHICLES_HORNS_SIREN_2", "VEHICLES_HORNS_POLICE_WARNING" },
    },
    [GetHashKey("polchal")] = {
        SirenSounds = { "VEHICLES_HORNS_SIREN_1", "VEHICLES_HORNS_SIREN_2", "VEHICLES_HORNS_POLICE_WARNING" },
    },
    [GetHashKey("polstang")] = {
        SirenSounds = { "VEHICLES_HORNS_SIREN_1", "VEHICLES_HORNS_SIREN_2", "VEHICLES_HORNS_POLICE_WARNING" },
    },
    [GetHashKey("polvette")] = {
        SirenSounds = { "VEHICLES_HORNS_SIREN_1", "VEHICLES_HORNS_SIREN_2", "VEHICLES_HORNS_POLICE_WARNING" },
    },
    [GetHashKey("poltaurus")] = {
        SirenSounds = { "VEHICLES_HORNS_SIREN_1", "VEHICLES_HORNS_SIREN_2", "VEHICLES_HORNS_POLICE_WARNING" },
    },
    [GetHashKey("polexp")] = {
        SirenSounds = { "VEHICLES_HORNS_SIREN_1", "VEHICLES_HORNS_SIREN_2", "VEHICLES_HORNS_POLICE_WARNING" },
    },
    [GetHashKey("polchar")] = {
        SirenSounds = { "VEHICLES_HORNS_SIREN_1", "VEHICLES_HORNS_SIREN_2", "VEHICLES_HORNS_POLICE_WARNING" },
    },
    [GetHashKey("polblazer")] = {
        SirenSounds = { "VEHICLES_HORNS_SIREN_1", "VEHICLES_HORNS_SIREN_2", "VEHICLES_HORNS_POLICE_WARNING" },
    },
    [GetHashKey("polmotor")] = {
        SirenSounds = { "RESIDENT_VEHICLES_SIREN_WAIL_03", "RESIDENT_VEHICLES_SIREN_QUICK_03" },
    },
    [GetHashKey("policeb")] = {
        SirenSounds = { "RESIDENT_VEHICLES_SIREN_WAIL_03", "RESIDENT_VEHICLES_SIREN_QUICK_03" },
    },
    [GetHashKey("ucbanshee")] = {
        SirenSounds = { "VEHICLES_HORNS_SIREN_1", "VEHICLES_HORNS_SIREN_2", "VEHICLES_HORNS_POLICE_WARNING" },
    },
    [GetHashKey("ucrancher")] = {
        SirenSounds = { "VEHICLES_HORNS_SIREN_1", "VEHICLES_HORNS_SIREN_2", "VEHICLES_HORNS_POLICE_WARNING" },
    },
    [GetHashKey("ucbuffalo")] = {
        SirenSounds = { "VEHICLES_HORNS_SIREN_1", "VEHICLES_HORNS_SIREN_2", "VEHICLES_HORNS_POLICE_WARNING" },
    },
    [GetHashKey("ucballer")] = {
        SirenSounds = { "VEHICLES_HORNS_SIREN_1", "VEHICLES_HORNS_SIREN_2", "VEHICLES_HORNS_POLICE_WARNING" },
    },
    [GetHashKey("emsspeedo")] = {
        SirenSounds = { "RESIDENT_VEHICLES_SIREN_WAIL_01", "RESIDENT_VEHICLES_SIREN_QUICK_01", "VEHICLES_HORNS_AMBULANCE_WARNING" },
    },
    [GetHashKey("emsexp")] = {
        SirenSounds = { "RESIDENT_VEHICLES_SIREN_WAIL_01", "RESIDENT_VEHICLES_SIREN_QUICK_01", "VEHICLES_HORNS_AMBULANCE_WARNING" },
    },
    [GetHashKey("emstau")] = {
        SirenSounds = { "RESIDENT_VEHICLES_SIREN_WAIL_01", "RESIDENT_VEHICLES_SIREN_QUICK_01", "VEHICLES_HORNS_AMBULANCE_WARNING" },
    },
    [GetHashKey("emsbike")] = {
        SirenSounds = { "RESIDENT_VEHICLES_SIREN_WAIL_03", "RESIDENT_VEHICLES_SIREN_QUICK_03" },
    },
}