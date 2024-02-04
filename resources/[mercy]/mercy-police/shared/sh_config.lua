Config = Config or {}


Config.PoliceAccount = '1247668815'

Config.EnableHelicam = true
Config.Barricades = {}
Config.Handcuffed, Config.Escorted = false, false
Config.Secure = false

Config.ValidRanks = { 
    Cadet = true,
    Officer = true,
    Detective = true,
    Corporal = true,
    Sergeant = true,
    Lieutenant = true,
    Captain = true,
    Chief = true,
}

Config.ParkingSlots = {
    ['MRPD'] = {
        vector4(445.81, -988.8, 25.7, 90.31),
        vector4(446.12, -991.57, 25.7, 88.64),
        vector4(446.12, -994.22, 25.7, 90.11),
        vector4(446.0, -996.96, 25.7, 87.28),
        vector4(437.01, -994.32, 25.7, 270.53),
        vector4(437.01, -991.52, 25.7, 264.33),
        vector4(436.84, -988.83, 25.7, 267.13), 
    },
    ['VCPD'] = {
        vector4(-1147.73, -849.09, 3.75, 36.29),
        vector4(-1144.63, -846.47, 3.75, 33.89),
        vector4(-1141.35, -844.12, 3.75, 34.19),
        vector4(-1138.1, -841.56, 3.75, 33.79),
        vector4(-1134.42, -839.11, 3.75, 38.45),
        vector4(-1131.02, -836.68, 3.75, 37.0),
    },
    ['SYPD'] = {
        vector4(1882.12, 3691.85, 33.54, 208.66),
        vector4(1879.09, 3690.03, 33.54, 204.2),
        vector4(1877.35, 3707.51, 33.55, 30.39),
        vector4(1874.29, 3705.63, 33.55, 26.19),
        vector4(1871.35, 3703.78, 33.54, 28.62),
    }
}

Config.DepotParkingSpots = {
    vector4(-184.05, -1173.98, 22.44, 199.34),
    vector4(-187.63, -1174.02, 22.44, 199.03),
    vector4(-191.0, -1174.39, 22.44, 199.34),
    vector4(-194.59, -1174.12, 22.44, 199.34),
    vector4(-198.08, -1173.87, 22.44, 201.71),
}

Config.JailCoords = vector3(1694.9, 2587.19, 45.56)
Config.JailSpawns = {
    vector4(1745.78, 2489.61, 50.42, 212.02),
    vector4(1751.85, 2492.73, 50.42, 213.78),
    vector4(1760.81, 2498.14, 50.43, 208.27),
    vector4(1754.86, 2494.59, 45.82, 212.48),
    vector4(1748.83, 2491.35, 45.82, 203.42)
}

Config.PrisonTasks = {
    {
        Task = 'Scrapyard',
        Info = 'Sort trash and stack stones.',
    },
    {
        Task = 'Kitchen',
        Info = 'Sort the kitchen and clean the tables.',
    },
    {
        Task = 'None',
        Info = 'Chill out and act like you have nothing better to do.',
    },
}

-- Cams
Config.SecurityCams = {
    { Coords = vector4(-57.32, -1752.09, 30.4, 266.79),   Label = 'Grove Street' },
    { Coords = vector4(-1485.66, -376.66, 41.4, 137.59),  Label = 'Morningwood' },
    { Coords = vector4(-1220.76, -909.15, 13.55, 37.12),  Label = 'San Andreas' },
    { Coords = vector4(-718.05, -916.04, 20.04, 313.80),  Label = 'Little Seoul' },
    { Coords = vector4(28.55, -1344.2, 29.91, 127.07),    Label = 'Innocence' },
    { Coords = vector4(1132.66, -983.17, 47.11, 279.92),  Label = 'El Rancho' },
    { Coords = vector4(1153.48, -327.02, 70.30, 324.08),  Label = 'West Mirror Drive' },
    { Coords = vector4(378.95, 329.69, 104.8, 111.29),    Label = 'Clinton Ave' },
    { Coords = vector4(-1827.25, 784.65, 139.42, 353.42), Label = 'Banham Canvon' },
    { Coords = vector4(-2965.01, 391.32, 16.24, 93.29),   Label = 'Great Ocean Hyw' },
    { Coords = vector4(-3045.23, 588.74, 8.9, 235.91),    Label = 'Ineseno Road' },
    { Coords = vector4(-3246.29, 1006.2, 13.91, 210.33),  Label = 'Barbareno Rd' },
    { Coords = vector4(544.92, 2666.69, 42.97, 310.03),   Label = 'Route 68' },
    { Coords = vector4(1165.42, 2712.17, 39.35, 181.28),  Label = 'Route 68 2' },
    { Coords = vector4(2676.92, 3285.52, 55.99, 182.06),  Label = 'Senora Fwy' },
    { Coords = vector4(1962.34, 3746.56, 33.26, 154.49),  Label = 'Alhambra Dr' },
    { Coords = vector4(1733.99, 6417.05, 35.85, 98.21),   Label = 'Senora Fwy 2' },
    { Coords = vector4(-161.75, 6319.98, 32.78, 318.76),  Label = 'Pyrite Ave' },
    { Coords = vector4(167.13, 6641.66, 32.56, 81.21),    Label = 'Paleto Blvd' },
    { Coords = vector4(1702.95, 4934.05, 43.26, 181.29),  Label = 'Grapeseed' },
    { Coords = vector4(2553.42, 386.08, 109.71, 212.2),   Label = 'Palomino Fwy' },
    { Coords = vector4(6.35, -1102.92, 30.59, 220.63),    Label = 'Ammunation Legion Square' },
    { Coords = vector4(817.06, -778.56, 26.5, 118.02),    Label = '24/7 Otto\'s' },
    { Coords = vector4(-665.68, -943.22, 23.39, 317.53),  Label = 'Ammunation Little Seoul' },
    { Coords = vector4(-1312.46, -388.69, 38.0, 214.54),  Label = 'Ammunation Morningwood' },
    { Coords = vector4(-1645.21, 2079.44, 72.90, 274.17), Label = 'Waterfalls' },
}

Config.ExemptWeapons = {
    "WEAPON_UNARMED",
    "WEAPON_SNOWBALL",
    "WEAPON_PETROLCAN",
    "WEAPON_TASER",
    "WEAPON_FIREEXTINGUISHER",
}

Config.PurchaseVehicles = {'polvic','polchal','polstang','polvette','polexp','polchar','polbike','ucbanshee','ucrancher','ucbuffalo','ucballer'}

Config.CameraHelicopters = {
    [GetHashKey('airone')] = true,
}

Config.HeliPad = {
    {
        Model = 'airone',
        Coords = vector4(449.34, -981.22, 43.69, 85.08),
    }
}

Config.PoliceStore = {
    {
        ['ItemName'] = 'weapon_scar',
        ['Amount'] = 1,
        ['Slot'] = 1,
        ['Info'] = {}
    },
    {
        ['ItemName'] = 'weapon_m4',
        ['Amount'] = 1,
        ['Slot'] = 2,
        ['Info'] = {}
    },
    {
        ['ItemName'] = 'weapon_mpx',
        ['Amount'] = 1,
        ['Slot'] = 3,
        ['Info'] = {}
    },
    {
        ['ItemName'] = 'weapon_remington',
        ['Amount'] = 1,
        ['Slot'] = 4,
        ['Info'] = {}
    },
    {
        ['ItemName'] = 'weapon_rubberslug',
        ['Amount'] = 1,
        ['Slot'] = 5,
        ['Info'] = {}
    },
    {
        ['ItemName'] = 'weapon_glock',
        ['Amount'] = 1,
        ['Slot'] = 6,
        ['Info'] = {}
    },
    {
        ['ItemName'] = 'weapon_taser',
        ['Amount'] = 1,
        ['Slot'] = 7,
        ['Info'] = {}
    },
    {
        ['ItemName'] = 'weapon_empgun',
        ['Amount'] = 1,
        ['Slot'] = 8,
        ['Info'] = {}
    },
    {
        ['ItemName'] = 'weapon_flashlight',
        ['Amount'] = 1,
        ['Slot'] = 9,
        ['Info'] = {}
    },
    {
        ['ItemName'] = 'rifle-ammo',
        ['Amount'] = 25,
        ['Slot'] = 10,
    },
    {
        ['ItemName'] = 'smg-ammo',
        ['Amount'] = 25,
        ['Slot'] = 11,
    },
    {
        ['ItemName'] = 'shotgun-ammo',
        ['Amount'] = 25,
        ['Slot'] = 12,
    },
    {
        ['ItemName'] = 'rubber-shotgun-ammo',
        ['Amount'] = 25,
        ['Slot'] = 13,
    },
    {
        ['ItemName'] = 'pistol-ammo',
        ['Amount'] = 25,
        ['Slot'] = 14,
    },
    {
        ['ItemName'] = 'taser-ammo',
        ['Amount'] = 25,
        ['Slot'] = 15,
    },
    {
        ['ItemName'] = 'emp-ammo',
        ['Amount'] = 25,
        ['Slot'] = 16,
    },
    {
        ['ItemName'] = 'ifak',
        ['Amount'] = 25,
        ['Slot'] = 17,
    },
    {
        ['ItemName'] = 'pdchestarmor',
        ['Amount'] = 25,
        ['Slot'] = 18,
    },
    {
        ['ItemName'] = 'handcuffs',
        ['Amount'] = 5,
        ['Slot'] = 19,
    },
    {
        ['ItemName'] = 'pdradio',
        ['Amount'] = 5,
        ['Slot'] = 20,
    },
    {
        ['ItemName'] = 'spikes',
        ['Amount'] = 5,
        ['Slot'] = 21,
    },
    {
        ['ItemName'] = 'evidence',
        ['Amount'] = 5,
        ['Slot'] = 22,
    },
    {
        ['ItemName'] = 'megaphone',
        ['Amount'] = 5,
        ['Slot'] = 23,
    },
    {
        ['ItemName'] = 'toolbox',
        ['Amount'] = 5,
        ['Slot'] = 24,
    },
    {
        ['ItemName'] = 'tirekit',
        ['Amount'] = 5,
        ['Slot'] = 25,
    },
    {
        ['ItemName'] = 'binoculars',
        ['Amount'] = 5,
        ['Slot'] = 26,
    },
    {
        ['ItemName'] = 'pdcamera',
        ['Amount'] = 5,
        ['Slot'] = 27,
    },
    {
        ['ItemName'] = 'gopropd',
        ['Amount'] = 5,
        ['Slot'] = 28,
    },
    {
        ['ItemName'] = 'detcord',
        ['Amount'] = 10,
        ['Slot'] = 29,
    },
    {
        ['ItemName'] = 'pdwatch',
        ['Amount'] = 1,
        ['Slot'] = 30,
    },
}

Config.BarricadeObjects = {
    {
        ['Prop'] = 'prop_roadcone02a',
        ['Label'] = 'Cone',
        ['Desc'] = 'A traffic cone to block off roads.',
        ['Static'] = false,
        ['Traffic'] = true,
    },
    {
        ['Prop'] = 'prop_barrier_work05',
        ['Label'] = 'Barrier Police',
        ['Desc'] = 'A police barrier to block off roads.',
        ['Static'] = true,
        ['Traffic'] = true,
    },
    {
        ['Prop'] = 'prop_barrier_work06a',
        ['Label'] = 'Barrier Work',
        ['Desc'] = 'A work barrier to block off roads.',
        ['Static'] = true,
        ['Traffic'] = true,
    },
    {
        ['Prop'] = 'prop_barrier_work06b',
        ['Label'] = 'Barrier Work 2',
        ['Desc'] = 'A work barrier to block off roads.',
        ['Static'] = true,
        ['Traffic'] = true,
    },
    {
        ['Prop'] = 'prop_gazebo_03',
        ['Label'] = 'Tent',
        ['Desc'] = 'A tent to help at crime scenes.',
        ['Static'] = true,
        ['Traffic'] = false,
    },
    {
        ['Prop'] = 'prop_worklight_03b',
        ['Label'] = 'Work Light',
        ['Desc'] = 'A work light to help at crime scenes.',
        ['Static'] = true,
        ['Traffic'] = false,
    },
    {
        ['Prop'] = 'delete_closest',
        ['Label'] = 'Remove Barricade',
        ['Desc'] = 'Remove the closest barricade.',
        ['Static'] = false,
        ['Traffic'] = false,
    }
}

Config.JailCrafting = {
    {
        ['ItemName'] = 'weapon_shiv',
        ['Slot'] = 1,
        ['Amount'] = 1,
        ['Info'] = '',
    },
}

Config.RandomFirstName = {
    'Dean',
    'Conrad',
    'Tristan',
    'Sadie',
    'Zeph',
    'Todd',
    'Juliet',
    'Bridget',
    'Caldwell',
    'Clarissa',
    'Myrtle',
    'Warren',
    'Luke',
    'Michael',
    'Roberta',
}

Config.RandomLastName = {
    'Walker',
    'Henry',
    'Davis',
    'Presley',
    'Malone',
    'Jarvis',
    'Thornton',
    'Morales',
    'Lane',
    'Perkins',
    'Bourn',
    'Vega',
}
