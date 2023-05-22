ServerConfig = ServerConfig or {}

-- Main

ServerConfig.OpenedBins = {}
ServerConfig.JobLocations = {}

-- Oxy
ServerConfig.OxyVehicles = {}
ServerConfig.OxyLocation = nil

ServerConfig.OxyPositions = {
    ['Supplier'] = vector4(980.35, -1397.07, 30.69, 209.02),
}

ServerConfig.OxyLocations = {
    [1] = {
        ['Busy'] = false,
        ['Cleaning'] = true,
        ['Coords'] = vector4(203.89, -162.60, 56.47, 346.18),
        ['SpawnCoords'] = vector4(244.68, -163.12, 59.76, 151.16),
        ['DriveCoords'] = vector4(202.41, -158.24, 56.82, 67.40),
    },
    [2] = {
        ['Busy'] = false,
        ['Cleaning'] = true,
        ['Coords'] = vector4(41.64, -103.33, 55.96, 344.51),
        ['SpawnCoords'] = vector4(91.49, -129.66, 55.69, 338.64),
        ['DriveCoords'] = vector4(41.69, -97.78, 56.44, 67.40),
    },
    [3] = {
        ['Busy'] = false,
        ['Cleaning'] = true,
        ['Coords'] = vector4(-36.57, -65.26, 59.46, 157.0),
        ['SpawnCoords'] = vector4(-68.27, -44.92, 62.69, 168.58),
        ['DriveCoords'] = vector4(-33.06, -70.34, 59.21, 253.06),
    },
    [4] = {
        ['Busy'] = false,
        ['Cleaning'] = true,
        ['Coords'] = vector4(-1783.33, -375.28, 44.97, 235.99),
        ['SpawnCoords'] = vector4(-1784.81, -346.14, 44.82, 230.25),
        ['DriveCoords'] = vector4(-1783.93, -380.62, 44.86, 140.09),
    },
    [5] = {
        ['Busy'] = false,
        ['Cleaning'] = true,
        ['Coords'] = vector4(-1693.52, -450.09, 41.07, 324.59),
        ['SpawnCoords'] = vector4(-1657.85, -461.18, 38.84, 141.25),
        ['DriveCoords'] = vector4(-1695.15, -445.09, 41.26, 229.55),
    },
    [6] = {
        ['Busy'] = false,
        ['Cleaning'] = true,
        ['Coords'] = vector4(-1308.03, -1255.03, 4.49, 293.42),
        ['SpawnCoords'] = vector4(-1284.73, -1277.25, 3.99, 103.92),
        ['DriveCoords'] = vector4(-1305.37, -1250.94, 4.5, 25.71),
    },
    [7] = {
        ['Busy'] = false,
        ['Cleaning'] = true,
        ['Coords'] = vector4(-1098.98, -1509.67, 4.7, 32.57),
        ['SpawnCoords'] = vector4(-1117.44, -1532.65, 4.3, 37.59),
        ['DriveCoords'] = vector4(-1100.08, -1507.88, 4.6, 304.72),
    },
    [8] = {
        ['Busy'] = false,
        ['Cleaning'] = true,
        ['Coords'] = vector4(-13.46, -1802.21, 27.32, 55.69),
        ['SpawnCoords'] = vector4(-15.19, -1834.92, 25.30, 57.18),
        ['DriveCoords'] = vector4(-14.56, -1799.19, 27.42, 321.10),
    },
    [9] = {
        ['Busy'] = false,
        ['Cleaning'] = true,
        ['Coords'] = vector4(405.83, -2072.77, 21.09, 144.66),
        ['SpawnCoords'] = vector4(443.93, -2092.28, 21.70, 138.59),
        ['DriveCoords'] = vector4(401.59, -2074.46, 20.66, 47.95),
    },
    [10] = {
        ['Busy'] = false,
        ['Cleaning'] = true,
        ['Coords'] = vector4(258.03, -1998.84, 20.15, 329.11),
        ['SpawnCoords'] = vector4(290.62, -2004.06, 20.22, 138.37),
        ['DriveCoords'] = vector4(257.41, -1993.64, 20.08, 50.13),
    },
    [11] = {
        ['Busy'] = false,
        ['Cleaning'] = true,
        ['Coords'] = vector4(246.05, -1952.87, 23.25, 314.05),
        ['SpawnCoords'] = vector4(221.26, -1947.91, 22.14, 322.84),
        ['DriveCoords'] = vector4(249.99, -1952.85, 23.01, 231.95),
    },
    [12] = {
        ['Busy'] = false,
        ['Cleaning'] = true,
        ['Coords'] = vector4(-57.73, -1497.80, 31.59, 145.25),
        ['SpawnCoords'] = vector4(-76.95, -1473.36, 32.09, 139.68),
        ['DriveCoords'] = vector4(-56.59, -1502.28, 31.40, 233.22),
    },
    [13] = {
        ['Busy'] = false,
        ['Cleaning'] = true,
        ['Coords'] = vector4(-106.28, -1603.05, 31.76, 58.64),
        ['SpawnCoords'] = vector4(-99.51, -1561.80, 32.93, 226.01),
        ['DriveCoords'] = vector4(-112.56, -1603.33, 31.71, 140.01),
    },
    [14] = {
        ['Busy'] = false,
        ['Cleaning'] = true,
        ['Coords'] = vector4(-211.58, -1637.49, 33.83, 351.27),
        ['SpawnCoords'] = vector4(-180.63, -1645.40, 33.35, 353.14),
        ['DriveCoords'] = vector4(-212.88, -1635.14, 33.56, 90.72),
    },
    [15] = {
        ['Busy'] = false,
        ['Cleaning'] = true,
        ['Coords'] = vector4(-175.04, -1367.68, 30.44, 292.96),
        ['SpawnCoords'] = vector4(-147.07, -1375.52, 29.52, 118.33),
        ['DriveCoords'] = vector4(-174.50, -1364.08, 30.37, 25.79),
    },
    [16] = {
        ['Busy'] = false,
        ['Cleaning'] = true,
        ['Coords'] = vector4(89.13, -824.96, 31.22, 71.44),
        ['SpawnCoords'] = vector4(78.63, -796.12, 31.52, 246.14),
        ['DriveCoords'] = vector4(83.85, -828.21, 30.93, 30.93),
    },
    [17] = {
        ['Busy'] = false,
        ['Cleaning'] = true,
        ['Coords'] = vector4(362.01, -816.32, 29.29, 279.94),
        ['SpawnCoords'] = vector4(382.48, -843.67, 29.27, 91.51),
        ['DriveCoords'] = vector4(365.11, -812.00, 29.29, 359.39),
    },
    [18] = {
        ['Busy'] = false,
        ['Cleaning'] = true,
        ['Coords'] = vector4(-65.05, 87.76, 73.18, 329.21),
        ['SpawnCoords'] = vector4(-32.40, 92.17, 76.40, 152.67),
        ['DriveCoords'] = vector4(-66.7, 90.48, 73.34, 61.11),
    },
    [19] = {
        ['Busy'] = false,
        ['Cleaning'] = true,
        ['Coords'] = vector4(-425.45, -307.79, 34.47, 169.80),
        ['SpawnCoords'] = vector4(-428.56, -282.36, 35.95, 231.60),
        ['DriveCoords'] = vector4(-422.10, -311.61, 34.19, 169.80),
    },
}

ServerConfig.DriverPeds = {
    "ig_claypain",
    "ig_nigel",
    "a_m_m_ktown_01",
    "a_m_m_malibu_01",
    "ig_tomcasino",
    "u_m_m_promourn_01",
}

ServerConfig.DeliveryVehicles = {
    'sultan',
    'baller',
    'stalion',
    'windsor',
    'asbo',
    'dilettante',
}

-- Mining

ServerConfig.MiningMaterials = {
    'metalscrap', 
    'copper', 
    'aluminum', 
    'iron', 
    'steel'
}

-- Fishing

ServerConfig.FishingSpots = {
    [1] = vector3(241.00, 3993.00, 30.40),
    [2] = vector3(1252.38, 3928.29, 30.8),
    [3] = vector3(2237.00, 4046.41, 31.6),
    [4] = vector3(1255.98, 3846.79, 31.9),
    [5] = vector3(1960.00, 4255.00, 30.55),
    [6] = vector3(1011.30, 3805.20, 31.55),
    [7] = vector3(598.80, 3723.56, 31.45),
    [8] = vector3(636.74, 4073.77, 31.45),
    [9] = vector3(-55.77, 4056.46, 31.2),
    [10] = vector3(1612.92, 4066.92, 31.8),
    [11] = vector3(-63.36, 4180.44, 31.8),
}

ServerConfig.CurrentFishSpot = vector3(241.00, 3993.00, 30.40)

ServerConfig.FishSellItems = {
    ['fish-blue'] = {
        ['Type'] = 'Money',
        ['Amount'] = math.random(40, 60),
    },
    ['fish-bass'] = {
        ['Type'] = 'Money',
        ['Amount'] = math.random(60, 80),
    },
    ['fish-cod'] = {
        ['Type'] = 'Money',
        ['Amount'] = math.random(80, 100),
    },
    ['fish-flounder'] = {
        ['Type'] = 'Money',
        ['Amount'] = math.random(60, 80),
    },
    ['fish-mackerel'] = {
        ['Type'] = 'Money',
        ['Amount'] = math.random(10, 15),
    },
    
}