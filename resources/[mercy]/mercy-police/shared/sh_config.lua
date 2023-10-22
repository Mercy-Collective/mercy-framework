Config = Config or {}


Config.PoliceAccount = '1247668815'

Config.EnableHelicam = true
Config.ObjectList = {}
Config.Handcuffed, Config.Escorted = false, false

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

Config.Objects = {
    {
        ['Object'] = 'prop_roadcone02a',
        ['Label'] = 'Cone',
        ['Freeze'] = false,
    },
    {
        ['Object'] = 'prop_barrier_work05',
        ['Label'] = 'Barrier Police',
        ['Freeze'] = true,
    },
    {
        ['Object'] = 'prop_barrier_work06a',
        ['Label'] = 'Barrier Work',
        ['Freeze'] = true,
    },
    {
        ['Object'] = 'prop_barrier_work06b',
        ['Label'] = 'Barrier Work 2',
        ['Freeze'] = true,
    },
    {
        ['Object'] = 'prop_gazebo_03',
        ['Label'] = 'Tent',
        ['Freeze'] = true,
    },
    {
        ['Object'] = 'prop_worklight_03b',
        ['Label'] = 'Work Light',
        ['Freeze'] = true,
    },

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