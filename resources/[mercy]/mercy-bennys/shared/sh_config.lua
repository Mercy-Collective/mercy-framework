Config = Config or {}

Config.WheelFitment = {
    Width = { 0.5, 1.25 },
    OffsetLeft = { -0.71, -1.10 },
    OffsetRight = { 0.69, 1.10 },
    RotationLeft = { 0.0, -1.0 },
    RotationRight = { 0.0, 1.0 },
}

Config.Zones = {
    -- MRPD
    {
        center = vector3(450.1, -975.84, 25.7),
        length = 13.2,
        width = 5.4,
        heading = 91,
        minZ = 24.7,
        maxZ = 28.7,
        ShowBlip = false,
        data = {
            Authorized = { Job = { "police" } },
            Heading = 85.32,
        },
    },

    -- Hayes
    {
        center = vector3(281.62, -1809.68, 26.91),
        length = 5.2,
        width = 6.0,
        heading = 50,
        minZ = 25.91,
        maxZ = 28.71,
        ShowBlip = false,
        data = {
            Authorized = { Business = { "Hayes Repairs" } },
            Heading = 139.47,
        },
    },

    -- Tunershop
    {
        center = vector3(124.57, -3047.23, 7.04),
        length = 8.2,
        width = 5.8,
        heading = 270,
        minZ = 6.04,
        maxZ = 10.04,
        ShowBlip = false,
        data = {
            Authorized = { Business = { "6STR. Tuner Shop" } },
            Heading = 270.53,
        },
    },
    {
        center = vector3(144.94, -3030.48, 6.41),
        length = 6.4,
        width = 4.0,
        name = "wheelfitment",
        heading = 0,
        minZ = 6.01,
        maxZ = 8.61,
        ShowBlip = false,
        data = {
            IsWheelfitment = true,
            Authorized = { Business = { "6STR. Tuner Shop" } },
            Heading = 6.41,
        },
    },

    -- Vespucci
    {
        center = vector3(-1143.0, -845.3, 3.75),
        length = 6.2,
        width = 8.4,
        heading = 36,
        minZ = 2.75,
        maxZ = 6.35,
        ShowBlip = false,
        data = {
            Authorized = { Job = { "police" } },
            Heading = 36.35,
        },
    },

    -- Sandy Shores
    {
        center = vector3(1812.13, 3687.61, 33.97),
        length = 8.2,
        width = 5.4,
        heading = 120,
        minZ = 32.97,
        maxZ = 36.97,
        ShowBlip = false,
        data = {
            Authorized = { Job = { "police" } },
            Heading = 297.8,
        },
    },

    -- Davis Ave
    {
        center = vector3(378.69, -1626.95, 28.77),
        length = 8.4,
        width = 6.4,
        heading=139,
        minZ=27.97,
        maxZ=31.97,
        data = {
            Authorized = { Job = { "police" } },
            Heading = 318.73,
        },
    },

    -- Hub
    {
        center = vector3(-38.55, -1053.3, 28.4),
        length = 6.6,
        width = 5.0,
        heading=340,
        minZ=26.79,
        maxZ=30.79,
        ShowBlip = false,
        data = {
            Heading = 339.93,
        }
    },
    {   
        center = vector3(-29.33, -1056.76, 27.79),
        length = 6.2,
        width = 7.6,
        heading=340,
        minZ=26.79,
        maxZ=30.79,
        ShowBlip = false,
        data = {
            Heading = 69.67,
        }
    },
    {
        center = vector3(-32.7, -1066.32, 27.88),
        length = 7.6,
        width = 6.6,
        heading=340,
        minZ=26.79,
        maxZ=30.79,
        ShowBlip = true,
        data = {
            Heading = 339.1,
        }
    },

    -- Paleto Bay
    {
        center = vector3(110.8, 6626.46, 31.89),
        length = 7.4,
        width = 8,
        minZ = 30.0,
        maxZ = 36.0,
        heading = 44.0,
        ShowBlip = true,
        data = {
            Heading = 225.2,
        }
    },

    -- Sandy Shores
    {
        center = vector3(1174.86, 2639.85, 37.75),
        length = 7.8,
        width = 5.0,
        heading = 0,
        minZ = 36.75,
        maxZ = 40.75,
        ShowBlip = true,
        data = {
            Heading = 0.88
        }
    },

    -- Original Bennys
    {
        center = vector3(-214.12, -1331.03, 30.9),
        length = 5.0,
        width = 5.0,
        heading = 0,
        minZ = 29.9,
        maxZ = 33.9,
        ShowBlip = true,
        data = {
            Heading = 352.46
        }
    },
    {
        center = vector3(-212.55, -1319.91, 30.89),
        length = 4.2,
        width = 8.0,
        heading = 0,
        minZ = 29.49,
        maxZ = 33.2,
        ShowBlip = false,
        data = {
            Heading = 271.77
        }
    },
    {
        center = vector3(-223.1, -1329.67, 30.89),
        length = 5.8,
        width = 8.4,
        heading = 0,
        minZ = 29.89,
        maxZ = 33.8,
        ShowBlip = false,
        data = {
            Heading = 269.1
        }
    },
}

Config.Prices = {
    ['Respray'] = 400,
    ['ModPlateIndex'] = 400,
    ['ModSpoilers'] = 400,
    ['ModFrontBumper'] = 400,
    ['ModRearBumper'] = 400,
    ['ModSideSkirt'] = 400,
    ['ModExhaust'] = 400,
    ['ModFrame'] = 400,
    ['ModGrille'] = 400,
    ['ModHood'] = 400,
    ['ModFender'] = 400,
    ['ModRightFender'] = 400,
    ['ModRoof'] = 400,
    ['ModVanityPlate'] = 400,
    ['ModTrimA'] = 400,
    ['ModOrnaments'] = 400,
    ['ModDashboard'] = 400,
    ['ModDial'] = 400,
    ['ModDoorSpeaker'] = 400,
    ['ModSeats'] = 400,
    ['ModSteeringWheel'] = 400,
    ['ModShifterLeavers'] = 400,
    ['ModAPlate'] = 400,
    ['ModSpeakers'] = 400,
    ['ModTrunk'] = 400,
    ['ModHydrolic'] = 400,
    ['ModEngineBlock'] = 400,
    ['ModAirFilter'] = 400,
    ['ModStruts'] = 400,
    ['ModArchCover'] = 400,
    ['ModAerials'] = 400,
    ['ModTrimB'] = 400,
    ['ModTank'] = 400,
    ['ModWindows'] = 400,
    ['ModLivery'] = 100,
    ['ModHorns'] = 400,
    ['ModArmor'] = { 3250, 5500, 10450, 15250, 20500 },
    ['ModEngine'] = { 3250, 5500, 10450, 15250, 20500 },
    ['ModBrakes'] = { 3250, 5500, 10450, 15250, 20500 },
    ['ModTransmission'] = { 3250, 5500, 10450, 15250, 20500 },
    ['ModSuspension'] = { 3250, 5500, 10450, 15250, 20500 },
    ['ModTurbo'] = { 0, 15000 },
    ['NeonSide'] = 100,
    ['NeonColor'] = 500,
    ['Headlights'] = { 0, 100 },
    ['XenonColor'] = 500,
    ['Wheels'] = 400,
}

Config.ParentMenus = {
    { Menu = 'MainMenu', Parent = nil },
    { Menu = 'ModHorns', Parent = 'MainMenu' },
    { Menu = 'ResprayMenu', Parent = 'MainMenu' },
    { Menu = 'ResprayTypeMenu', Parent = 'ResprayMenu' },
    { Menu = 'ResprayMetallic', Parent = 'ResprayTypeMenu' },
    { Menu = 'ResprayMetal', Parent = 'ResprayTypeMenu' },
    { Menu = 'ResprayMatte', Parent = 'ResprayTypeMenu' },
    { Menu = 'PlateIndexMenu', Parent = 'MainMenu' },
    { Menu = 'WheelsMenu', Parent = 'MainMenu' },
    { Menu = 'WindowTintMenu', Parent = 'MainMenu' },
    { Menu = 'VehicleExtrasMenu', Parent = 'MainMenu' },
    { Menu = 'ColorPresetsMenu', Parent = 'MainMenu' },
    { Menu = 'NeonsMenu', Parent = 'MainMenu' },
    { Menu = 'NeonColorsMenu', Parent = 'NeonsMenu' },
    { Menu = 'XenonsMenu', Parent = 'MainMenu' },
    { Menu = 'HeadlightsMenu', Parent = 'XenonsMenu' },
    { Menu = 'XenonColorsMenu', Parent = 'XenonsMenu' },
    { Menu = 'ModTurboMenu', Parent = 'MainMenu' },
}

Config.NeonColors = {
    {
        Id = "NeonColor",
        Label = "White",
        Parent = "NeonColorsMenu",
        Disabled = { Emergency = false, Vin = false },
        Costs = '$' .. Config.Prices['NeonColor'],
        Data = { Costs = Config.Prices['NeonColor'], ModType = 'NeonColor',  ModIndex = { R = 222, G = 222, B = 255 }, }
    },
    {
        Id = "NeonColor",
        Label = "Blue",
        Parent = "NeonColorsMenu",
        Disabled = { Emergency = false, Vin = false },
        Costs = '$' .. Config.Prices['NeonColor'],
        Data = { Costs = Config.Prices['NeonColor'], ModType = 'NeonColor',  ModIndex = { R = 2, G = 21, B = 255 }, }
    },
    {
        Id = "NeonColor",
        Label = "Electric Blue",
        Parent = "NeonColorsMenu",
        Disabled = { Emergency = false, Vin = false },
        Costs = '$' .. Config.Prices['NeonColor'],
        Data = { Costs = Config.Prices['NeonColor'], ModType = 'NeonColor',  ModIndex = { R = 3, G = 83, B = 255 }, }
    },
    {
        Id = "NeonColor",
        Label = "Mint Green",
        Parent = "NeonColorsMenu",
        Disabled = { Emergency = false, Vin = false },
        Costs = '$' .. Config.Prices['NeonColor'],
        Data = { Costs = Config.Prices['NeonColor'], ModType = 'NeonColor',  ModIndex = { R = 0, G = 255, B = 140 }, }
    },
    {
        Id = "NeonColor",
        Label = "Lime Green",
        Parent = "NeonColorsMenu",
        Disabled = { Emergency = false, Vin = false },
        Costs = '$' .. Config.Prices['NeonColor'],
        Data = { Costs = Config.Prices['NeonColor'], ModType = 'NeonColor',  ModIndex = { R = 94, G = 255, B = 1 }, }
    },
    {
        Id = "NeonColor",
        Label = "Yellow",
        Parent = "NeonColorsMenu",
        Disabled = { Emergency = false, Vin = false },
        Costs = '$' .. Config.Prices['NeonColor'],
        Data = { Costs = Config.Prices['NeonColor'], ModType = 'NeonColor',  ModIndex = { R = 255, G = 255, B = 0 }, }
    },
    {
        Id = "NeonColor",
        Label = "Golden Shower",
        Parent = "NeonColorsMenu",
        Disabled = { Emergency = false, Vin = false },
        Costs = '$' .. Config.Prices['NeonColor'],
        Data = { Costs = Config.Prices['NeonColor'], ModType = 'NeonColor',  ModIndex = { R = 255, G = 150, B = 0 }, }
    },
    {
        Id = "NeonColor",
        Label = "Orange",
        Parent = "NeonColorsMenu",
        Disabled = { Emergency = false, Vin = false },
        Costs = '$' .. Config.Prices['NeonColor'],
        Data = { Costs = Config.Prices['NeonColor'], ModType = 'NeonColor',  ModIndex = { R = 255, G = 62, B = 0 }, }
    },
    {
        Id = "NeonColor",
        Label = "Red",
        Parent = "NeonColorsMenu",
        Disabled = { Emergency = false, Vin = false },
        Costs = '$' .. Config.Prices['NeonColor'],
        Data = { Costs = Config.Prices['NeonColor'], ModType = 'NeonColor',  ModIndex = { R = 255, G = 1, B = 1 }, }
    },
    {
        Id = "NeonColor",
        Label = "Pony Pink",
        Parent = "NeonColorsMenu",
        Disabled = { Emergency = false, Vin = false },
        Costs = '$' .. Config.Prices['NeonColor'],
        Data = { Costs = Config.Prices['NeonColor'], ModType = 'NeonColor',  ModIndex = { R = 255, G = 50, B = 100 }, }
    },
    {
        Id = "NeonColor",
        Label = "Hot Pink",
        Parent = "NeonColorsMenu",
        Disabled = { Emergency = false, Vin = false },
        Costs = '$' .. Config.Prices['NeonColor'],
        Data = { Costs = Config.Prices['NeonColor'], ModType = 'NeonColor',  ModIndex = { R = 255, G = 5, B = 190 }, }
    },
    {
        Id = "NeonColor",
        Label = "Purple",
        Parent = "NeonColorsMenu",
        Disabled = { Emergency = false, Vin = false },
        Costs = '$' .. Config.Prices['NeonColor'],
        Data = { Costs = Config.Prices['NeonColor'], ModType = 'NeonColor',  ModIndex = { R = 35, G = 1, B = 255 }, }
    },
    {
        Id = "NeonColor",
        Label = "Blacklight",
        Parent = "NeonColorsMenu",
        Disabled = { Emergency = false, Vin = false },
        Costs = '$' .. Config.Prices['NeonColor'],
        Data = { Costs = Config.Prices['NeonColor'], ModType = 'NeonColor',  ModIndex = { R = 15, G = 3, B = 255 }, }
    },
}

Config.XenonColors = {
    {
        Id = 'XenonColor',
        Label = "Stock",
        Parent = 'XenonColorsMenu',
        Disabled = { Emergency = false, Vin = false },
        Costs = '$' .. Config.Prices['XenonColor'],
        Data = { Costs = Config.Prices['XenonColor'], ModType = 'XenonColor', ModIndex = 255 },
    },
    {
        Id = 'XenonColor',
        Label = "White",
        Parent = 'XenonColorsMenu',
        Disabled = { Emergency = false, Vin = false },
        Costs = '$' .. Config.Prices['XenonColor'],
        Data = { Costs = Config.Prices['XenonColor'], ModType = 'XenonColor', ModIndex = 0 },
    },
    {
        Id = 'XenonColor',
        Label = "Blue",
        Parent = 'XenonColorsMenu',
        Disabled = { Emergency = false, Vin = false },
        Costs = '$' .. Config.Prices['XenonColor'],
        Data = { Costs = Config.Prices['XenonColor'], ModType = 'XenonColor', ModIndex = 1 },
    },
    {
        Id = 'XenonColor',
        Label = "Electric Blue",
        Parent = 'XenonColorsMenu',
        Disabled = { Emergency = false, Vin = false },
        Costs = '$' .. Config.Prices['XenonColor'],
        Data = { Costs = Config.Prices['XenonColor'], ModType = 'XenonColor', ModIndex = 2 },
    },
    {
        Id = 'XenonColor',
        Label = "Mint Green",
        Parent = 'XenonColorsMenu',
        Disabled = { Emergency = false, Vin = false },
        Costs = '$' .. Config.Prices['XenonColor'],
        Data = { Costs = Config.Prices['XenonColor'], ModType = 'XenonColor', ModIndex = 3 },
    },
    {
        Id = 'XenonColor',
        Label = "Lime Green",
        Parent = 'XenonColorsMenu',
        Disabled = { Emergency = false, Vin = false },
        Costs = '$' .. Config.Prices['XenonColor'],
        Data = { Costs = Config.Prices['XenonColor'], ModType = 'XenonColor', ModIndex = 4 },
    },
    {
        Id = 'XenonColor',
        Label = "Yellow",
        Parent = 'XenonColorsMenu',
        Disabled = { Emergency = false, Vin = false },
        Costs = '$' .. Config.Prices['XenonColor'],
        Data = { Costs = Config.Prices['XenonColor'], ModType = 'XenonColor', ModIndex = 5 },
    },
    {
        Id = 'XenonColor',
        Label = "Golden Shower",
        Parent = 'XenonColorsMenu',
        Disabled = { Emergency = false, Vin = false },
        Costs = '$' .. Config.Prices['XenonColor'],
        Data = { Costs = Config.Prices['XenonColor'], ModType = 'XenonColor', ModIndex = 6 },
    },
    {
        Id = 'XenonColor',
        Label = "Orange",
        Parent = 'XenonColorsMenu',
        Disabled = { Emergency = false, Vin = false },
        Costs = '$' .. Config.Prices['XenonColor'],
        Data = { Costs = Config.Prices['XenonColor'], ModType = 'XenonColor', ModIndex = 7 },
    },
    {
        Id = 'XenonColor',
        Label = "Red",
        Parent = 'XenonColorsMenu',
        Disabled = { Emergency = false, Vin = false },
        Costs = '$' .. Config.Prices['XenonColor'],
        Data = { Costs = Config.Prices['XenonColor'], ModType = 'XenonColor', ModIndex = 8 },
    },
    {
        Id = 'XenonColor',
        Label = "Pony Pink",
        Parent = 'XenonColorsMenu',
        Disabled = { Emergency = false, Vin = false },
        Costs = '$' .. Config.Prices['XenonColor'],
        Data = { Costs = Config.Prices['XenonColor'], ModType = 'XenonColor', ModIndex = 9 },
    },
    {
        Id = 'XenonColor',
        Label = "Hot Pink",
        Parent = 'XenonColorsMenu',
        Disabled = { Emergency = false, Vin = false },
        Costs = '$' .. Config.Prices['XenonColor'],
        Data = { Costs = Config.Prices['XenonColor'], ModType = 'XenonColor', ModIndex = 10 },
    },
    {
        Id = 'XenonColor',
        Label = "Purple",
        Parent = 'XenonColorsMenu',
        Disabled = { Emergency = false, Vin = false },
        Costs = '$' .. Config.Prices['XenonColor'],
        Data = { Costs = Config.Prices['XenonColor'], ModType = 'XenonColor', ModIndex = 11 },
    },
    {
        Id = 'XenonColor',
        Label = "Blacklight",
        Parent = 'XenonColorsMenu',
        Disabled = { Emergency = false, Vin = false },
        Costs = '$' .. Config.Prices['XenonColor'],
        Data = { Costs = Config.Prices['XenonColor'], ModType = 'XenonColor', ModIndex = 12 },
    },
}

Config.Horns = {
    {
        Id = "VehicleHorn",
        Label = "Truck Horn",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 0 },
    },
    {
        Id = "VehicleHorn",
        Label = "Cop Horn",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 1 },
    },
    {
        Id = "VehicleHorn",
        Label = "Clown Horn",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 2 },
    },
    {
        Id = "VehicleHorn",
        Label = "Musical Horn 1",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 3 },
    },
    {
        Id = "VehicleHorn",
        Label = "Musical Horn 2",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 4 },
    },
    {
        Id = "VehicleHorn",
        Label = "Musical Horn 3",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 5 },
    },
    {
        Id = "VehicleHorn",
        Label = "Musical Horn 4",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 6 },
    },
    {
        Id = "VehicleHorn",
        Label = "Musical Horn 5",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 7 },
    },
    {
        Id = "VehicleHorn",
        Label = "Sad Trombone",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 8 },
    },
    {
        Id = "VehicleHorn",
        Label = "Classical Horn 1",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 9 },
    },
    {
        Id = "VehicleHorn",
        Label = "Classical Horn 2",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 10 },
    },
    {
        Id = "VehicleHorn",
        Label = "Classical Horn 3",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 11 },
    },
    {
        Id = "VehicleHorn",
        Label = "Classical Horn 4",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 12 },
    },
    {
        Id = "VehicleHorn",
        Label = "Classical Horn 5",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 13 },
    },
    {
        Id = "VehicleHorn",
        Label = "Classical Horn 6",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 14 },
    },
    {
        Id = "VehicleHorn",
        Label = "Classical Horn 7",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 15 },
    },
    {
        Id = "VehicleHorn",
        Label = "Scale - Do",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 16 },
    },
    {
        Id = "VehicleHorn",
        Label = "Scale - Re",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 17 },
    },
    {
        Id = "VehicleHorn",
        Label = "Scale - Mi",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 18 },
    },
    {
        Id = "VehicleHorn",
        Label = "Scale - Fa",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 19 },
    },
    {
        Id = "VehicleHorn",
        Label = "Scale - Sol",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 20 },
    },
    {
        Id = "VehicleHorn",
        Label = "Scale - La",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 21 },
    },
    {
        Id = "VehicleHorn",
        Label = "Scale - Ti",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 22 },
    },
    {
        Id = "VehicleHorn",
        Label = "Scale - Do",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 23 },
    },
    {
        Id = "VehicleHorn",
        Label = "Jazz Horn 1",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 24 },
    },
    {
        Id = "VehicleHorn",
        Label = "Jazz Horn 2",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 25 },
    },
    {
        Id = "VehicleHorn",
        Label = "Jazz Horn 3",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 26 },
    },
    {
        Id = "VehicleHorn",
        Label = "Jazz Horn Loop",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 27 },
    },
    {
        Id = "VehicleHorn",
        Label = "Star Spangled Banner 1",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 28 },
    },
    {
        Id = "VehicleHorn",
        Label = "Star Spangled Banner 2",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 29 },
    },
    {
        Id = "VehicleHorn",
        Label = "Star Spangled Banner 3",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 30 },
    },
    {
        Id = "VehicleHorn",
        Label = "Star Spangled Banner 4",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 31 },
    },
    {
        Id = "VehicleHorn",
        Label = "Classical Horn 8 Loop",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 32 },
    },
    {
        Id = "VehicleHorn",
        Label = "Classical Horn 9 Loop",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 33 },
    },
    {
        Id = "VehicleHorn",
        Label = "Classical Horn 10 Loop",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 34 },
    },
    {
        Id = "VehicleHorn",
        Label = "Classical Horn 8",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 35 },
    },
    {
        Id = "VehicleHorn",
        Label = "Classical Horn 9",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 36 },
    },
    {
        Id = "VehicleHorn",
        Label = "Classical Horn 10",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 37 },
    },
    {
        Id = "VehicleHorn",
        Label = "Funeral Loop",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 38 },
    },
    {
        Id = "VehicleHorn",
        Label = "Funeral",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 39 },
    },
    {
        Id = "VehicleHorn",
        Label = "Spooky Loop",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 40 },
    },
    {
        Id = "VehicleHorn",
        Label = "Spooky",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 41 },
    },
    {
        Id = "VehicleHorn",
        Label = "San Andreas Loop",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 42 },
    },
    {
        Id = "VehicleHorn",
        Label = "San Andreas",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 43 },
    },
    {
        Id = "VehicleHorn",
        Label = "Liberty City Loop",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 44 },
    },
    {
        Id = "VehicleHorn",
        Label = "Liberty City",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 45 },
    },
    {
        Id = "VehicleHorn",
        Label = "Festive 1 Loop",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 46 },
    },
    {
        Id = "VehicleHorn",
        Label = "Festive 1",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 47 },
    },
    {
        Id = "VehicleHorn",
        Label = "Festive 2 Loop",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 48 },
    },
    {
        Id = "VehicleHorn",
        Label = "Festive 2",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 49 },
    },
    {
        Id = "VehicleHorn",
        Label = "Festive 3 Loop",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 50 },
    },
    {
        Id = "VehicleHorn",
        Label = "Festive 3",
        Parent = "ModHorns",
        Disabled = { Emergency = false, Vin = false },
        Data = { Costs = Config.Prices['ModHorns'], ModType = 14, ModIndex = 51 },
    }
}

Config.ResprayColors = {
    ['Metallic'] = {
        {
            Id = "ResprayColor",
            Label = "Black",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 0 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Carbon Black",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 147 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Hraphite",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 1 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Anhracite Black",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 11 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Black Steel",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 2 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Dark Steel",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 3 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Silver",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 4 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Bluish Silver",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 5 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Rolled Steel",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 6 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Shadow Silver",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 7 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Stone Silver",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 8 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Midnight Silver",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 9 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Cast Iron Silver",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 10 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Red",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 27 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Torino Red",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 28 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Formula Red",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 29 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Lava Red",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 150 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Blaze Red",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 30 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Grace Red",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 31 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Garnet Red",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 32 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Sunset Red",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 33 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Cabernet Red",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 34 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Wine Red",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 143 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Candy Red",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 35 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Hot Pink",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 135 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Pfsiter Pink",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 137 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Salmon Pink",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 136 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Sunrise Orange",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 36 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Orange",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 38 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Bright Orange",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 138 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Gold",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 99 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Bronze",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 90 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Yellow",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 88 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Race Yellow",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 89 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Dew Yellow",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 91 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Dark Green",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 49 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Racing Green",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 50 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Sea Green",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 51 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Olive Green",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 52 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Bright Green",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 53 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Gasoline Green",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 54 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Lime Green",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 92 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Midnight Blue",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 141 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Galaxy Blue",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 61 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Dark Blue",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 62 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Saxon Blue",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 63 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Blue",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 64 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Mariner Blue",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 65 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Harbor Blue",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 66 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Diamond Blue",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 67 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Surf Blue",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 68 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Nautical Blue",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 69 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Racing Blue",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 73 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Ultra Blue",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 70 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Light Blue",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 74 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Chocolate Brown",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 96 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Bison Brown",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 101 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Creeen Brown",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 95 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Feltzer Brown",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 94 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Maple Brown",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 97 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Beechwood Brown",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 103 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Sienna Brown",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 104 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Saddle Brown",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 98 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Moss Brown",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 100 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Woodbeech Brown",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 102 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Straw Brown",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 99 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Sandy Brown",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 105 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Bleached Brown",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 106 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Schafter Purple",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 71 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Spinnaker Purple",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 72 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Midnight Purple",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 142 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Bright Purple",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 145 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Cream",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 107 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Ice White",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 111 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Frost White",
            Parent = 'ResprayMetallic',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 112 },
            Disabled = { Emergency = false, Vin = false },
        }
    },
    ['Metal'] = {
        {
            Id = "ResprayColor",
            Label = "Brushed Steel",
            Parent = 'ResprayMetal',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 117 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Brushed Black Steel",
            Parent = 'ResprayMetal',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 118 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Brushed Aluminum",
            Parent = 'ResprayMetal',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 119 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Pure Gold",
            Parent = 'ResprayMetal',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 158 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Brushed Gold",
            Parent = 'ResprayMetal',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 150 },
            Disabled = { Emergency = false, Vin = false },
        },
    },
    ['Matte'] = {
        {
            Id = "ResprayColor",
            Label = "Black",
            Parent = 'ResprayMatte',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 12 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Gray",
            Parent = 'ResprayMatte',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 13 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Light Gray",
            Parent = 'ResprayMatte',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 14 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Ice White",
            Parent = 'ResprayMatte',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 131 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Blue",
            Parent = 'ResprayMatte',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 83 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Dark Blue",
            Parent = 'ResprayMatte',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 82 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Midnight Blue",
            Parent = 'ResprayMatte',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 84 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Midnight Purple",
            Parent = 'ResprayMatte',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 149 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Schafter Purple",
            Parent = 'ResprayMatte',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 148 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Red",
            Parent = 'ResprayMatte',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 39 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Dark Red",
            Parent = 'ResprayMatte',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 40 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Orange",
            Parent = 'ResprayMatte',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 41 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Yellow",
            Parent = 'ResprayMatte',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 42 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Lime Green",
            Parent = 'ResprayMatte',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 55 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Green",
            Parent = 'ResprayMatte',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 128 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Frost Green",
            Parent = 'ResprayMatte',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 151 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Foliage Green",
            Parent = 'ResprayMatte',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 155 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Olive Darb",
            Parent = 'ResprayMatte',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 152 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Dark Earth",
            Parent = 'ResprayMatte',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 153 },
            Disabled = { Emergency = false, Vin = false },
        },
        {
            Id = "ResprayColor",
            Label = "Desert Tan",
            Parent = 'ResprayMatte',
            Costs = '$' .. Config.Prices['Respray'],
            Data = { Costs = Config.Prices['Respray'], ModType = 'Respray', ModIndex = 154 },
            Disabled = { Emergency = false, Vin = false },
        }
    },
}

Config.ResprayMenu = {
    {
        Id = "PrimaryColour",
        Label = "Primary Colour",
        Parent = 'ResprayMenu',
        TargetMenu = 'ResprayTypeMenu',
        Disabled = { Emergency = false, Vin = false },
        Data = { ModType = 'PrimaryColour', ModIndex = 0 },
    },
    {
        Id = "SecondaryColour",
        Label = "Secondary Colour",
        Parent = 'ResprayMenu',
        TargetMenu = 'ResprayTypeMenu',
        Disabled = { Emergency = false, Vin = false },
        Data = { ModType = 'SecondaryColour', ModIndex = 1 },
    },
    {
        Id = "PearlescentColour",
        Label = "Pearlescent Colour",
        Parent = 'ResprayMenu',
        TargetMenu = 'ResprayMetallic',
        Disabled = { Emergency = false, Vin = false },
        Data = { ModType = 'PearlescentColour', ModIndex = 2 },
    },
    {
        Id = "WheelColour",
        Label = "Wheel Colour",
        Parent = 'ResprayMenu',
        TargetMenu = 'ResprayMetallic',
        Disabled = { Emergency = false, Vin = false },
        Data = { ModType = 'WheelColour', ModIndex = 3 },
    },
    {
        Id = "DashboardColour",
        Label = "Dashboard Colour",
        Parent = 'ResprayMenu',
        TargetMenu = 'ResprayMetallic',
        Disabled = { Emergency = false, Vin = false },
        Data = { ModType = 'DashboardColour', ModIndex = 4 },
    },
    {
        Id = "InteriorColour",
        Label = "Interior Colour",
        Parent = 'ResprayMenu',
        TargetMenu = 'ResprayMetallic',
        Disabled = { Emergency = false, Vin = false },
        Data = { ModType = 'InteriorColour', ModIndex = 5 },
    }
}

Config.Wheels = {
    ['Sport'] = {
        {
            Id = "Wheels",
            Label = "Stock",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 0, ModType = 'Wheels', ModIndex = -1 }
        },
        {
            Id = "Wheels",
            Label = "Inferno",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 0, ModType = 'Wheels', ModIndex = 0 }
        },
        {
            Id = "Wheels",
            Label = "Deepfive",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 0, ModType = 'Wheels', ModIndex = 1 }
        },
        {
            Id = "Wheels",
            Label = "Lozspeed",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 0, ModType = 'Wheels', ModIndex = 2 }
        },
        {
            Id = "Wheels",
            Label = "Diamondcut",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 0, ModType = 'Wheels', ModIndex = 3 }
        },
        {
            Id = "Wheels",
            Label = "Chrono",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 0, ModType = 'Wheels', ModIndex = 4 }
        },
        {
            Id = "Wheels",
            Label = "Feroccirr",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 0, ModType = 'Wheels', ModIndex = 5 }
        },
        {
            Id = "Wheels",
            Label = "Fiftynine",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 0, ModType = 'Wheels', ModIndex = 6 }
        },
        {
            Id = "Wheels",
            Label = "Mercie",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 0, ModType = 'Wheels', ModIndex = 7 }
        },
        {
            Id = "Wheels",
            Label = "Syntheticz",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 0, ModType = 'Wheels', ModIndex = 8 }
        },
        {
            Id = "Wheels",
            Label = "Organictyped",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 0, ModType = 'Wheels', ModIndex = 9 }
        },
        {
            Id = "Wheels",
            Label = "Endov1",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 0, ModType = 'Wheels', ModIndex = 10 }
        },
        {
            Id = "Wheels",
            Label = "Duper7",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 0, ModType = 'Wheels', ModIndex = 11 }
        },
        {
            Id = "Wheels",
            Label = "Uzer",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 0, ModType = 'Wheels', ModIndex = 12 }
        },
        {
            Id = "Wheels",
            Label = "Groundride",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 0, ModType = 'Wheels', ModIndex = 13 }
        },
        {
            Id = "Wheels",
            Label = "Spacer",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 0, ModType = 'Wheels', ModIndex = 14 }
        },
        {
            Id = "Wheels",
            Label = "Venum",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 0, ModType = 'Wheels', ModIndex = 15 }
        },
        {
            Id = "Wheels",
            Label = "Cosmo",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 0, ModType = 'Wheels', ModIndex = 16 }
        },
        {
            Id = "Wheels",
            Label = "Dashvip",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 0, ModType = 'Wheels', ModIndex = 17 }
        },
        {
            Id = "Wheels",
            Label = "Icekid",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 0, ModType = 'Wheels', ModIndex = 18 }
        },
        {
            Id = "Wheels",
            Label = "Ruffeld",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 0, ModType = 'Wheels', ModIndex = 19 }
        },
        {
            Id = "Wheels",
            Label = "Wangenmaster",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 0, ModType = 'Wheels', ModIndex = 20 }
        },
        {
            Id = "Wheels",
            Label = "Superfive",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 0, ModType = 'Wheels', ModIndex = 21 }
        },
        {
            Id = "Wheels",
            Label = "Endov2",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 0, ModType = 'Wheels', ModIndex = 22 }
        },
        {
            Id = "Wheels",
            Label = "Slitsix",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 0, ModType = 'Wheels', ModIndex = 23 }
        },
    },
    ['Muscle'] = {
        {
            Id = "Wheels",
            Label = "Stock",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs =  Config.Prices['Wheels'], WheelType = 1, ModType = 'Wheels', ModIndex = -1 },
        },
        {
            Id = "Wheels",
            Label = "Classicfive",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs =  Config.Prices['Wheels'], WheelType = 1, ModType = 'Wheels', ModIndex = 0 },
        },
        {
            Id = "Wheels",
            Label = "Dukes",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs =  Config.Prices['Wheels'], WheelType = 1, ModType = 'Wheels', ModIndex = 1 },
        },
        {
            Id = "Wheels",
            Label = "Musclefreak",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs =  Config.Prices['Wheels'], WheelType = 1, ModType = 'Wheels', ModIndex = 2 },
        },
        {
            Id = "Wheels",
            Label = "Kracka",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs =  Config.Prices['Wheels'], WheelType = 1, ModType = 'Wheels', ModIndex = 3 },
        },
        {
            Id = "Wheels",
            Label = "Azrea",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs =  Config.Prices['Wheels'], WheelType = 1, ModType = 'Wheels', ModIndex = 4 },
        },
        {
            Id = "Wheels",
            Label = "Mecha",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs =  Config.Prices['Wheels'], WheelType = 1, ModType = 'Wheels', ModIndex = 5 },
        },
        {
            Id = "Wheels",
            Label = "Blacktop",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs =  Config.Prices['Wheels'], WheelType = 1, ModType = 'Wheels', ModIndex = 6 },
        },
        {
            Id = "Wheels",
            Label = "Dragspl",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs =  Config.Prices['Wheels'], WheelType = 1, ModType = 'Wheels', ModIndex = 7 },
        },
        {
            Id = "Wheels",
            Label = "Revolver",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs =  Config.Prices['Wheels'], WheelType = 1, ModType = 'Wheels', ModIndex = 8 },
        },
        {
            Id = "Wheels",
            Label = "Classicrod",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs =  Config.Prices['Wheels'], WheelType = 1, ModType = 'Wheels', ModIndex = 9 },
        },
        {
            Id = "Wheels",
            Label = "Spooner",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs =  Config.Prices['Wheels'], WheelType = 1, ModType = 'Wheels', ModIndex = 10 },
        },
        {
            Id = "Wheels",
            Label = "Fivestar",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs =  Config.Prices['Wheels'], WheelType = 1, ModType = 'Wheels', ModIndex = 11 },
        },
        {
            Id = "Wheels",
            Label = "Oldschool",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs =  Config.Prices['Wheels'], WheelType = 1, ModType = 'Wheels', ModIndex = 12 },
        },
        {
            Id = "Wheels",
            Label = "Eljefe",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs =  Config.Prices['Wheels'], WheelType = 1, ModType = 'Wheels', ModIndex = 13 },
        },
        {
            Id = "Wheels",
            Label = "Dodman",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs =  Config.Prices['Wheels'], WheelType = 1, ModType = 'Wheels', ModIndex = 14 },
        },
        {
            Id = "Wheels",
            Label = "Sixgun",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs =  Config.Prices['Wheels'], WheelType = 1, ModType = 'Wheels', ModIndex = 15 },
        },
        {
            Id = "Wheels",
            Label = "Mercenary",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs =  Config.Prices['Wheels'], WheelType = 1, ModType = 'Wheels', ModIndex = 16 },
        },
    },
    ['Lowrider'] = {        
        {
            Id = "Wheels",
            Label = "Stock",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 2, ModType = 'Wheels', ModIndex = -1 }
        },
        {
            Id = "Wheels",
            Label = "Flare",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 2, ModType = 'Wheels', ModIndex = 0 }
        },
        {
            Id = "Wheels",
            Label = "Wired",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 2, ModType = 'Wheels', ModIndex = 1 }
        },
        {
            Id = "Wheels",
            Label = "Triplegolds",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 2, ModType = 'Wheels', ModIndex = 2 }
        },
        {
            Id = "Wheels",
            Label = "Bigworm",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 2, ModType = 'Wheels', ModIndex = 3 }
        },
        {
            Id = "Wheels",
            Label = "Sevenfives",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 2, ModType = 'Wheels', ModIndex = 4 }
        },
        {
            Id = "Wheels",
            Label = "Splitsix",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 2, ModType = 'Wheels', ModIndex = 5 }
        },
        {
            Id = "Wheels",
            Label = "Freshmesh",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 2, ModType = 'Wheels', ModIndex = 6 }
        },
        {
            Id = "Wheels",
            Label = "Leadsled",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 2, ModType = 'Wheels', ModIndex = 7 }
        },
        {
            Id = "Wheels",
            Label = "Turbine",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 2, ModType = 'Wheels', ModIndex = 8 }
        },
        {
            Id = "Wheels",
            Label = "Superfin",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 2, ModType = 'Wheels', ModIndex = 9 }
        },
        {
            Id = "Wheels",
            Label = "Classicrod",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 2, ModType = 'Wheels', ModIndex = 10 }
        },
        {
            Id = "Wheels",
            Label = "Dollar",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 2, ModType = 'Wheels', ModIndex = 11 }
        },
        {
            Id = "Wheels",
            Label = "Dukes",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 2, ModType = 'Wheels', ModIndex = 12 }
        },
        {
            Id = "Wheels",
            Label = "Lowfive",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 2, ModType = 'Wheels', ModIndex = 13 }
        },
        {
            Id = "Wheels",
            Label = "Gooch",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 2, ModType = 'Wheels', ModIndex = 14 }
        },
    },
    ['SUV'] = {
        {
            Id = "Wheels",
            Label = "Stock",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 3, ModType = 'Wheels', ModIndex = -1 }
        },
        {
            Id = "Wheels",
            Label = "Vip",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 3, ModType = 'Wheels', ModIndex = 0 }
        },
        {
            Id = "Wheels",
            Label = "Benefactor",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 3, ModType = 'Wheels', ModIndex = 1 }
        },
        {
            Id = "Wheels",
            Label = "Cosmo",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 3, ModType = 'Wheels', ModIndex = 2 }
        },
        {
            Id = "Wheels",
            Label = "Bippu",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 3, ModType = 'Wheels', ModIndex = 3 }
        },
        {
            Id = "Wheels",
            Label = "Royalsix",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 3, ModType = 'Wheels', ModIndex = 4 }
        },
        {
            Id = "Wheels",
            Label = "Fagorme",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 3, ModType = 'Wheels', ModIndex = 5 }
        },
        {
            Id = "Wheels",
            Label = "Deluxe",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 3, ModType = 'Wheels', ModIndex = 6 }
        },
        {
            Id = "Wheels",
            Label = "Icedout",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 3, ModType = 'Wheels', ModIndex = 7 }
        },
        {
            Id = "Wheels",
            Label = "Cognscenti",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 3, ModType = 'Wheels', ModIndex = 8 }
        },
        {
            Id = "Wheels",
            Label = "Lozspeedten",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 3, ModType = 'Wheels', ModIndex = 9 }
        },
        {
            Id = "Wheels",
            Label = "Supernova",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 3, ModType = 'Wheels', ModIndex = 10 }
        },
        {
            Id = "Wheels",
            Label = "Obeyrs",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 3, ModType = 'Wheels', ModIndex = 11 }
        },
        {
            Id = "Wheels",
            Label = "Lozspeedballer",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 3, ModType = 'Wheels', ModIndex = 12 }
        },
        {
            Id = "Wheels",
            Label = "Extra vaganzo",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 3, ModType = 'Wheels', ModIndex = 13 }
        },
        {
            Id = "Wheels",
            Label = "Splitsix",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 3, ModType = 'Wheels', ModIndex = 14 }
        },
        {
            Id = "Wheels",
            Label = "Empowered",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 3, ModType = 'Wheels', ModIndex = 15 }
        },
        {
            Id = "Wheels",
            Label = "Sunrise",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 3, ModType = 'Wheels', ModIndex = 16 }
        },
        {
            Id = "Wheels",
            Label = "Dashvip",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 3, ModType = 'Wheels', ModIndex = 17 }
        },
        {
            Id = "Wheels",
            Label = "Cutter",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 3, ModType = 'Wheels', ModIndex = 18 }
        },
    },
    ['Offroad'] = {
        {
            Id = "Wheels",
            Label = "Stock",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 4, ModType = 'Wheels', ModIndex = -1 }
        },
        {
            Id = "Wheels",
            Label = "Raider",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 4, ModType = 'Wheels', ModIndex = 0 }
        },
        {
            Id = "Wheels",
            Label = "Mudslinger",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 4, ModType = 'Wheels', ModIndex = 1 }
        },
        {
            Id = "Wheels",
            Label = "Nevis",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 4, ModType = 'Wheels', ModIndex = 2 }
        },
        {
            Id = "Wheels",
            Label = "Cairngorm",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 4, ModType = 'Wheels', ModIndex = 3 }
        },
        {
            Id = "Wheels",
            Label = "Amazon",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 4, ModType = 'Wheels', ModIndex = 4 }
        },
        {
            Id = "Wheels",
            Label = "Challenger",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 4, ModType = 'Wheels', ModIndex = 5 }
        },
        {
            Id = "Wheels",
            Label = "Dunebasher",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 4, ModType = 'Wheels', ModIndex = 6 }
        },
        {
            Id = "Wheels",
            Label = "Fivestar",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 4, ModType = 'Wheels', ModIndex = 7 }
        },
        {
            Id = "Wheels",
            Label = "Rockcrawler",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 4, ModType = 'Wheels', ModIndex = 8 }
        },
        {
            Id = "Wheels",
            Label = "Milspecsteelie",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 4, ModType = 'Wheels', ModIndex = 9 }
        },
    },
    ['Tuner'] = {
        {
            Id = "Wheels",
            Label = "Stock",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 5, ModType = 'Wheels', ModIndex = -1 }
        },
        {
            Id = "Wheels",
            Label = "Cosmo",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 5, ModType = 'Wheels', ModIndex = 0 }
        },
        {
            Id = "Wheels",
            Label = "Supermesh",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 5, ModType = 'Wheels', ModIndex = 1 }
        },
        {
            Id = "Wheels",
            Label = "Outsider",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 5, ModType = 'Wheels', ModIndex = 2 }
        },
        {
            Id = "Wheels",
            Label = "Rollas",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 5, ModType = 'Wheels', ModIndex = 3 }
        },
        {
            Id = "Wheels",
            Label = "Driffmeister",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 5, ModType = 'Wheels', ModIndex = 4 }
        },
        {
            Id = "Wheels",
            Label = "Slicer",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 5, ModType = 'Wheels', ModIndex = 5 }
        },
        {
            Id = "Wheels",
            Label = "Elquatro",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 5, ModType = 'Wheels', ModIndex = 6 }
        },
        {
            Id = "Wheels",
            Label = "Dubbed",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 5, ModType = 'Wheels', ModIndex = 7 }
        },
        {
            Id = "Wheels",
            Label = "Fivestar",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 5, ModType = 'Wheels', ModIndex = 8 }
        },
        {
            Id = "Wheels",
            Label = "Slideways",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 5, ModType = 'Wheels', ModIndex = 9 }
        },
        {
            Id = "Wheels",
            Label = "Apex",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 5, ModType = 'Wheels', ModIndex = 10 }
        },
        {
            Id = "Wheels",
            Label = "Stancedeg",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 5, ModType = 'Wheels', ModIndex = 11 }
        },
        {
            Id = "Wheels",
            Label = "Countersteer",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 5, ModType = 'Wheels', ModIndex = 12 }
        },
        {
            Id = "Wheels",
            Label = "Endov1",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 5, ModType = 'Wheels', ModIndex = 13 }
        },
        {
            Id = "Wheels",
            Label = "Endov2dish",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 5, ModType = 'Wheels', ModIndex = 14 }
        },
        {
            Id = "Wheels",
            Label = "Guppez",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 5, ModType = 'Wheels', ModIndex = 15 }
        },
        {
            Id = "Wheels",
            Label = "Chokadori",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 5, ModType = 'Wheels', ModIndex = 16 }
        },
        {
            Id = "Wheels",
            Label = "Chicane",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 5, ModType = 'Wheels', ModIndex = 17 }
        },
        {
            Id = "Wheels",
            Label = "Saisoku",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 5, ModType = 'Wheels', ModIndex = 18 }
        },
        {
            Id = "Wheels",
            Label = "Dishedeight",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 5, ModType = 'Wheels', ModIndex = 19 }
        },
        {
            Id = "Wheels",
            Label = "Fujiwara",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 5, ModType = 'Wheels', ModIndex = 20 }
        },
        {
            Id = "Wheels",
            Label = "Zokusha",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 5, ModType = 'Wheels', ModIndex = 21 }
        },
        {
            Id = "Wheels",
            Label = "Battlevill",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 5, ModType = 'Wheels', ModIndex = 22 }
        },
        {
            Id = "Wheels",
            Label = "Rallymaster",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 5, ModType = 'Wheels', ModIndex = 23 }
        },
    },
    ['Motorcycle'] = {
        {
            Id = "Wheels",
            Label = "Stock",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 6, ModType = 'Wheels', ModIndex = -1 }
        },
        {
            Id = "Wheels",
            Label = "Speedway",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 6, ModType = 'Wheels', ModIndex = 0 }
        },
        {
            Id = "Wheels",
            Label = "Streetspecial",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 6, ModType = 'Wheels', ModIndex = 1 }
        },
        {
            Id = "Wheels",
            Label = "Racer",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 6, ModType = 'Wheels', ModIndex = 2 }
        },
        {
            Id = "Wheels",
            Label = "Trackstar",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 6, ModType = 'Wheels', ModIndex = 3 }
        },
        {
            Id = "Wheels",
            Label = "Overlord",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 6, ModType = 'Wheels', ModIndex = 4 }
        },
        {
            Id = "Wheels",
            Label = "Trident",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 6, ModType = 'Wheels', ModIndex = 5 }
        },
        {
            Id = "Wheels",
            Label = "Triplethreat",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 6, ModType = 'Wheels', ModIndex = 6 }
        },
        {
            Id = "Wheels",
            Label = "Stilleto",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 6, ModType = 'Wheels', ModIndex = 7 }
        },
        {
            Id = "Wheels",
            Label = "Wires",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 6, ModType = 'Wheels', ModIndex = 8 }
        },
        {
            Id = "Wheels",
            Label = "Bobber",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 6, ModType = 'Wheels', ModIndex = 9 }
        },
        {
            Id = "Wheels",
            Label = "Solidus",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 6, ModType = 'Wheels', ModIndex = 10 }
        },
        {
            Id = "Wheels",
            Label = "Iceshield",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 6, ModType = 'Wheels', ModIndex = 11 }
        },
        {
            Id = "Wheels",
            Label = "Loops",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 6, ModType = 'Wheels', ModIndex = 12 }
        },
    },
    ['Highend'] = {
        {
            Id = "Wheels",
            Label = "Stock",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 7, ModType = 'Wheels', ModIndex = -1 }
        },
        {
            Id = "Wheels",
            Label = "Shadow",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 7, ModType = 'Wheels', ModIndex = 0 }
        },
        {
            Id = "Wheels",
            Label = "Hyper",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 7, ModType = 'Wheels', ModIndex = 1 }
        },
        {
            Id = "Wheels",
            Label = "Blade",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 7, ModType = 'Wheels', ModIndex = 2 }
        },
        {
            Id = "Wheels",
            Label = "Diamond",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 7, ModType = 'Wheels', ModIndex = 3 }
        },
        {
            Id = "Wheels",
            Label = "Supagee",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 7, ModType = 'Wheels', ModIndex = 4 }
        },
        {
            Id = "Wheels",
            Label = "Chromaticz",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 7, ModType = 'Wheels', ModIndex = 5 }
        },
        {
            Id = "Wheels",
            Label = "Merciechlip",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 7, ModType = 'Wheels', ModIndex = 6 }
        },
        {
            Id = "Wheels",
            Label = "Obeyrs",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 7, ModType = 'Wheels', ModIndex = 7 }
        },
        {
            Id = "Wheels",
            Label = "Gtchrome",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 7, ModType = 'Wheels', ModIndex = 8 }
        },
        {
            Id = "Wheels",
            Label = "Cheetahr",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 7, ModType = 'Wheels', ModIndex = 9 }
        },
        {
            Id = "Wheels",
            Label = "Solar",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 7, ModType = 'Wheels', ModIndex = 10 }
        },
        {
            Id = "Wheels",
            Label = "Splitten",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 7, ModType = 'Wheels', ModIndex = 11 }
        },
        {
            Id = "Wheels",
            Label = "Dashvip",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 7, ModType = 'Wheels', ModIndex = 12 }
        },
        {
            Id = "Wheels",
            Label = "Lozspeedten",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 7, ModType = 'Wheels', ModIndex = 13 }
        },
        {
            Id = "Wheels",
            Label = "Carboninferno",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 7, ModType = 'Wheels', ModIndex = 14 }
        },
        {
            Id = "Wheels",
            Label = "Carbonshadow",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 7, ModType = 'Wheels', ModIndex = 15 }
        },
        {
            Id = "Wheels",
            Label = "Carbonz",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 7, ModType = 'Wheels', ModIndex = 16 }
        },
        {
            Id = "Wheels",
            Label = "Carbonsolar",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 7, ModType = 'Wheels', ModIndex = 17 }
        },
        {
            Id = "Wheels",
            Label = "Carboncheetahr",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 7, ModType = 'Wheels', ModIndex = 18 }
        },
        {
            Id = "Wheels",
            Label = "Carbonsracer",
            Disabled = { Emergency = false, Vin = false },
            Costs = '$' .. Config.Prices['Wheels'],
            Data = { Costs = Config.Prices['Wheels'], WheelType = 7, ModType = 'Wheels', ModIndex = 19 }
        },
    },
}

Config.WheelTypes = {
    {
        Id = "WheelsSport",
        Label = "Sport",
        Parent = "WheelsMenu",
        Disabled = { Emergency = false, Vin = false },
        SubMenu = Config.Wheels['Sport'],
        Data = { ModType = 'Wheels', ModIndex = 0 }
    },
    {
        Id = "WheelsMuscle",
        Label = "Muscle",
        Parent = "WheelsMenu",
        Disabled = { Emergency = false, Vin = false },
        SubMenu = Config.Wheels['Muscle'],
        Data = { ModType = 'Wheels', ModIndex = 1 }
    },
    {
        Id = "WheelsLowrider",
        Label = "Lowrider",
        Parent = "WheelsMenu",
        Disabled = { Emergency = false, Vin = false },
        SubMenu = Config.Wheels['Lowrider'],
        Data = { ModType = 'Wheels', ModIndex = 2 }
    },
    {
        Id = "WheelsSUV",
        Label = "SUV",
        Parent = "WheelsMenu",
        Disabled = { Emergency = false, Vin = false },
        SubMenu = Config.Wheels['SUV'],
        Data = { ModType = 'Wheels', ModIndex = 3 }
    },
    {
        Id = "WheelsOffroad",
        Label = "Offroad",
        Parent = "WheelsMenu",
        Disabled = { Emergency = false, Vin = false },
        SubMenu = Config.Wheels['Offroad'],
        Data = { ModType = 'Wheels', ModIndex = 4 }
    },
    {
        Id = "WheelsTuner",
        Label = "Tuner",
        Parent = "WheelsMenu",
        Disabled = { Emergency = false, Vin = false },
        SubMenu = Config.Wheels['Tuner'],
        Data = { ModType = 'Wheels', ModIndex = 5 }
    },
    {
        Id = "WheelsMotorcycle",
        Label = "Motorcycle",
        Parent = "WheelsMenu",
        Disabled = { Emergency = false, Vin = false },
        SubMenu = Config.Wheels['Motorcycle'],
        Data = { ModType = 'Wheels', ModIndex = 6 }
    },
    {
        Id = "WheelsHighend",
        Label = "Highend",
        Parent = "WheelsMenu",
        Disabled = { Emergency = false, Vin = false },
        SubMenu = Config.Wheels['Highend'],
        Data = { ModType = 'Wheels', ModIndex = 7 }
    },
}

Config.Menus = {
    {
        Id = 'ResprayMenu',
        Label = 'Respray',
        Disabled = { Emergency = false, Vin = false },
        SubMenu = Config.ResprayMenu,
    },
    {
        Id = 'WindowTintMenu',
        Label = 'Windows',
        Disabled = { Emergency = false, Vin = false },
        SubMenu = {
            {
                Id = "ModWindows",
                Label = "None",
                Parent = "WindowTintMenu",
                Disabled = { Emergency = false, Vin = false },
                Costs = '$0',
                Data = { Costs = 0, ModType = 'Windows', ModIndex = 0 },
            },
            {
                Id = "ModWindows",
                Label = "Pure Black",
                Parent = "WindowTintMenu",
                Disabled = { Emergency = false, Vin = false },
                Costs = '$' .. Config.Prices['ModWindows'],
                Data = { Costs = Config.Prices['ModWindows'], ModType = 'Windows', ModIndex = 1 },
            },
            {
                Id = "ModWindows",
                Label = "Darksmoke",
                Parent = "WindowTintMenu",
                Disabled = { Emergency = false, Vin = false },
                Costs = '$' .. Config.Prices['ModWindows'],
                Data = { Costs = Config.Prices['ModWindows'], ModType = 'Windows', ModIndex = 2 },
            },
            {
                Id = "ModWindows",
                Label = "Lightsmoke",
                Parent = "WindowTintMenu",
                Disabled = { Emergency = false, Vin = false },
                Costs = '$' .. Config.Prices['ModWindows'],
                Data = { Costs = Config.Prices['ModWindows'], ModType = 'Windows', ModIndex = 3 },
            },
        },
    },
    {  
        Id = 'PlateIndexMenu',
        Label = 'Plate Index',
        Disabled = { Emergency = false, Vin = false },
        SubMenu = {
            {
                Id = "ModPlateIndex",
                Label = "Blue on White 1",
                Parent = "PlateIndexMenu",
                Disabled = { Emergency = false, Vin = false },
                Costs = '$' .. Config.Prices['ModPlateIndex'],
                Data = { Costs = Config.Prices['ModPlateIndex'], ModType = 'PlateIndex', ModIndex = 3 },
            },
            {
                Id = "ModPlateIndex",
                Label = "Blue on White 2",
                Parent = "PlateIndexMenu",
                Disabled = { Emergency = false, Vin = false },
                Costs = '$' .. Config.Prices['ModPlateIndex'],
                Data = { Costs = Config.Prices['ModPlateIndex'], ModType = 'PlateIndex', ModIndex = 0 },
            },
            {
                Id = "ModPlateIndex",
                Label = "Blue on White 3",
                Parent = "PlateIndexMenu",
                Disabled = { Emergency = false, Vin = false },
                Costs = '$' .. Config.Prices['ModPlateIndex'],
                Data = { Costs = Config.Prices['ModPlateIndex'], ModType = 'PlateIndex', ModIndex = 4 },
            },
            {
                Id = "ModPlateIndex",
                Label = "Yellow on Blue",
                Parent = "PlateIndexMenu",
                Disabled = { Emergency = false, Vin = false },
                Costs = '$' .. Config.Prices['ModPlateIndex'],
                Data = { Costs = Config.Prices['ModPlateIndex'], ModType = 'PlateIndex', ModIndex = 2 },
            },
            {
                Id = "ModPlateIndex",
                Label = "Yellow on Black",
                Parent = "PlateIndexMenu",
                Disabled = { Emergency = false, Vin = false },
                Costs = '$' .. Config.Prices['ModPlateIndex'],
                Data = { Costs = Config.Prices['ModPlateIndex'], ModType = 'PlateIndex', ModIndex = 1 },
            },
            {
                Id = "ModPlateIndex",
                Label = "North Yankton",
                Parent = "PlateIndexMenu",
                Disabled = { Emergency = false, Vin = false },
                Costs = '$' .. Config.Prices['ModPlateIndex'],
                Data = { Costs = Config.Prices['ModPlateIndex'], ModType = 'PlateIndex', ModIndex = 5 },
            },
        },
    },
    {
        Id = "VehicleExtrasMenu",
        Label = "Vehicle Extras Customisation",
        Disabled = { Emergency = false, Vin = false },
        ModType = 'Extra',
    },
    {
        Id = "NeonsMenu",
        Label = "Neon Customisation",
        Disabled = { Emergency = false, Vin = false },
        SubMenu = {
            {
                Id = "NeonSide",
                Label = "Front Neon",
                Parent = 'NeonsMenu',
                Disabled = { Emergency = false, Vin = false },
                Costs = '$' .. Config.Prices['NeonSide'],
                Data = { Costs = Config.Prices['NeonSide'], ModType = 'NeonSide', ModIndex = 2 }
            },
            {
                Id = "NeonSide",
                Label = "Rear Neon",
                Parent = 'NeonsMenu',
                Disabled = { Emergency = false, Vin = false },
                Costs = '$' .. Config.Prices['NeonSide'],
                Data = { Costs = Config.Prices['NeonSide'], ModType = 'NeonSide', ModIndex = 3 }
            },
            {
                Id = "NeonSide",
                Label = "Left Neon",
                Parent = 'NeonsMenu',
                Disabled = { Emergency = false, Vin = false },
                Costs = '$' .. Config.Prices['NeonSide'],
                Data = { Costs = Config.Prices['NeonSide'], ModType = 'NeonSide', ModIndex = 0 }
            },
            {
                Id = "NeonSide",
                Label = "Right Neon",
                Parent = 'NeonsMenu',
                Disabled = { Emergency = false, Vin = false },
                Costs = '$' .. Config.Prices['NeonSide'],
                Data = { Costs = Config.Prices['NeonSide'], ModType = 'NeonSide', ModIndex = 1 }
            },
        }
    },
    {
        Id = "XenonsMenu",
        Label = "Xenon Customisation",
        Disabled = { Emergency = false, Vin = false },
        SubMenu = {}
    },
    {
        Id = "WheelsMenu",
        Label = "Wheels",
        TargetMenu = "WheelsMenu",
        Disabled = { Emergency = false, Vin = false },
    },
    {
        Id = "ModSpoilers",
        Label = "Spoiler",
        Disabled = { Emergency = false, Vin = false },
        ModType = 0,
    },
    {
        Id = "ModFrontBumper",
        Label = "Front Bumper",
        Disabled = { Emergency = false, Vin = false },
        ModType = 1,
    },
    {
        Id = "ModRearBumper",
        Label = "Rear Bumper",
        Disabled = { Emergency = false, Vin = false },
        ModType = 2,
    },
    {
        Id = "ModSideSkirt",
        Label = "Side Skirt",
        Disabled = { Emergency = false, Vin = false },
        ModType = 3,
    },
    {
        Id = "ModExhaust",
        Label = "Exhaust",
        Disabled = { Emergency = false, Vin = false },
        ModType = 4,
    },
    {
        Id = "ModFrame",
        Label = "Roll Cage",
        Disabled = { Emergency = false, Vin = false },
        ModType = 5,
    },
    {
        Id = "ModGrille",
        Label = "Grille",
        Disabled = { Emergency = false, Vin = false },
        ModType = 6,
    },
    {
        Id = "ModHood",
        Label = "Hood",
        Disabled = { Emergency = false, Vin = false },
        ModType = 7,
    },
    {
        Id = "ModFender",
        Label = "Left Fender",
        Disabled = { Emergency = false, Vin = false },
        ModType = 8,
    },
    {
        Id = "ModRightFender",
        Label = "Right Fender",
        Disabled = { Emergency = false, Vin = false },
        ModType = 9,
    },
    {
        Id = "ModRoof",
        Label = "Roof",
        Disabled = { Emergency = false, Vin = false },
        ModType = 10,
    },
    {
        Id = "ModVanityPlate",
        Label = "Vanity Plates",
        Disabled = { Emergency = false, Vin = false },
        ModType = 25,
    },
    {
        Id = "ModTrimA",
        Label = "Trim A",
        Disabled = { Emergency = false, Vin = false },
        ModType = 27,
    },
    {
        Id = "ModOrnaments",
        Label = "Ornaments",
        Disabled = { Emergency = false, Vin = false },
        ModType = 28,
    },
    {
        Id = "ModDashboard",
        Label = "Dashboard",
        Disabled = { Emergency = false, Vin = false },
        ModType = 29,
    },
    {
        Id = "ModDial",
        Label = "Dial",
        Disabled = { Emergency = false, Vin = false },
        ModType = 30,
    },
    {
        Id = "ModDoorSpeaker",
        Label = "Door Speaker",
        Disabled = { Emergency = false, Vin = false },
        ModType = 31,
    },
    {
        Id = "ModSeats",
        Label = "Seats",
        Disabled = { Emergency = false, Vin = false },
        ModType = 32,
    },
    {
        Id = "ModSteeringWheel",
        Label = "Steering Wheel",
        Disabled = { Emergency = false, Vin = false },
        ModType = 33,
    },
    {
        Id = "ModShifterLeavers",
        Label = "Shifter Leaver",
        Disabled = { Emergency = false, Vin = false },
        ModType = 34,
    },
    {
        Id = "ModAPlate",
        Label = "Plaque",
        Disabled = { Emergency = false, Vin = false },
        ModType = 35,
    },
    {
        Id = "ModSpeakers",
        Label = "Speaker",
        Disabled = { Emergency = false, Vin = false },
        ModType = 36,
    },
    {
        Id = "ModTrunk",
        Label = "Trunk",
        Disabled = { Emergency = false, Vin = false },
        ModType = 37,
    },
    {
        Id = "ModHydrolic",
        Label = "Hydraulic",
        Disabled = { Emergency = false, Vin = false },
        ModType = 38,
    },
    {
        Id = "ModEngineBlock",
        Label = "Engine Block",
        Disabled = { Emergency = false, Vin = false },
        ModType = 39,
    },
    {
        Id = "ModAirFilter",
        Label = "Air Filter",
        Disabled = { Emergency = false, Vin = false },
        ModType = 40,
    },
    {
        Id = "ModStruts",
        Label = "Strut",
        Disabled = { Emergency = false, Vin = false },
        ModType = 41,
    },
    {
        Id = "ModArchCover",
        Label = "Arch Cover",
        Disabled = { Emergency = false, Vin = false },
        ModType = 42,
    },
    {
        Id = "ModAerials",
        Label = "Aerial",
        Disabled = { Emergency = false, Vin = false },
        ModType = 43,
    },
    {
        Id = "ModTrimB",
        Label = "Trim B",
        Disabled = { Emergency = false, Vin = false },
        ModType = 44,
    },
    {
        Id = "ModTank",
        Label = "Fuel Tank",
        Disabled = { Emergency = false, Vin = false },
        ModType = 45,
    },
    {
        Id = "ModWindows",
        Label = "Window",
        Disabled = { Emergency = false, Vin = false },
        ModType = 46,
    },
    {
        Id = "ModLivery",
        Label = "Livery",
        Disabled = { Emergency = false, Vin = false },
        ModType = 48,
    },
    {
        Id = "ModHorns",
        Label = "Horns",
        Disabled = { Emergency = true, Vin = false },
        ModType = 14,
        SubMenu = Config.Horns,
    },
    -- {
    --     Id = "ModArmor",
    --     Label = "Armor Upgrade",
    --     Disabled = { Emergency = true, Vin = true },
    --     ModType = 16,
    -- },
   -- -{
      --  Id = "ModEngine",
       -- Label = "Engine Upgrade",
       -- Disabled = { Emergency = true, Vin = true },
       -- ModType = 11,
  -- - },
  --  {
      --  Id = "ModBrakes",
      --  Label = "Brake Upgrade",
      --  Disabled = { Emergency = true, Vin = true },
      --  ModType = 12,
  --  },
   -- {
      --  Id = "ModTransmission",
       -- Label = "Transmission Upgrade",
       -- Disabled = { Emergency = true, Vin = true },
      --  ModType = 13,
  --  },
  --  {
       -- Id = "ModSuspension",
       -- Label = "Suspension Upgrade",
      --  Disabled = { Emergency = true, Vin = true },
       -- ModType = 15,
   -- },
    {
       -- Id = "ModTurboMenu",
       -- Label = "Turbo Upgrade",
      --  Disabled = { Emergency = true, Vin = true },
       -- SubMenu = {
         --   {
          --      Id = "ModTurbo",
          --      Label = "Disable Turbo",
         --       Parent = 'ModTurboMenu',
         --       Disabled = { Emergency = false, Vin = false },
          --      Costs = '$' .. 0,
         ---     Data = { Costs = 0, ModType = 18, ModIndex = 0 }
           -- },
         --  {
           --     Id = "ModTurbo",
          --      Label = "Enable Turbo",
         --       Parent = 'ModTurboMenu',
         --       Disabled = { Emergency = false, Vin = false },
          --      Costs = '$' .. Config.Prices['ModTurbo'][2],
         --       Data = { Costs = Config.Prices['ModTurbo'][2], ModType = 18, ModIndex = 1 }
           -- },
        },


    -- RESPRAY TYPES
    {
        Id = "ResprayMetallic",
        Label = "Metallic",
        Parent = "ResprayTypeMenu",
        SubMenu = Config.ResprayColors['Metallic'],
        Disabled = { Emergency = false, Vin = false },
    },
    {
        Id = "ResprayMetal",
        Label = "Metal",
        Parent = "ResprayTypeMenu",
        SubMenu = Config.ResprayColors['Metal'],
        Disabled = { Emergency = false, Vin = false },
    },
    {
        Id = "ResprayMatte",
        Label = "Matte",
        Parent = "ResprayTypeMenu",
        SubMenu = Config.ResprayColors['Matte'],
        Disabled = { Emergency = false, Vin = false },
    },
    
    -- NEONS
    {
        Id = "NeonColorsMenu",
        Label = "Neon Colour",
        Parent = "NeonsMenu",
        SubMenu = Config.NeonColors,
        Disabled = { Emergency = false, Vin = false },
    },

    -- HEADLIGHTS (+ XENONS)
    {
        Id = "HeadlightsMenu",
        Label = 'Headlights Customisation',
        Parent = 'XenonsMenu',
        Disabled = { Emergency = false, Vin = false },
        SubMenu = {
            {
                Id = "Headlights",
                Label = "Disable Xenons",
                Parent = 'HeadlightsMenu',
                Disabled = { Emergency = false, Vin = false },
                Costs = '$' .. 0,
                Data = { Costs = 0, ModType = 22, ModIndex = 0 }
            },
            {
                Id = "Headlights",
                Label = "Enable Xenons",
                Parent = 'HeadlightsMenu',
                Disabled = { Emergency = false, Vin = false },
                Costs = '$' .. Config.Prices['Headlights'][2],
                Data = { Costs = Config.Prices['Headlights'][2], ModType = 22, ModIndex = 1 }
            },
        },
    },
    {
        Id = "XenonColorsMenu",
        Label = 'Xenon Colours',
        Parent = 'XenonsMenu',
        Disabled = { Emergency = false, Vin = false },
        SubMenu = Config.XenonColors,
    },
}

Config.ExtraPresets = {
    [GetHashKey("polvic")] = { "Lightbar", "Driver Spotlight", "Passenger Spotlight", "Front Indicator Lights", "Front Lights", "Rear Lights", "Front Plate" },
    [GetHashKey("polstang")] = { "Lightbar", "Driver Spotlight", "Passenger Spotlight", "Grill Lights", "Front Lights", "Rear Lights" },
    [GetHashKey("polvette")] = { "Lightbar", "Driver Spotlight", "Passenger Spotlight", "Grill Lights", "Front Lights", "Rear Lights" },
    [GetHashKey("polchal")] = { "Lightbar", "Driver Spotlight", "Passenger Spotlight", "Grill Lights", "Front Lights", "Rear Lights" },
    [GetHashKey("polchar")] = { "Lightbar", "Driver Spotlight", "Passenger Spotlight", "Grill Lights", "Front Lights", "Rear Lights", "Front Plate" },
    [GetHashKey("polexp")] = { "Lightbar", "Driver Spotlight", "Passenger Spotlight", "Grill & Cabin Lights", "Driver Mirror Lights", "Passsenger Mirror Lights", "Rear Lights", "Front Plate" },
}

Config.SpecialMotorcycles = {
    [GetHashKey('polbike')] = true,
}