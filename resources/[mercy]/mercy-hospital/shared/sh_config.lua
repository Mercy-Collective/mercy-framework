Config = Config or {}

Config.InHospitalBed = false
Config.Dead, Config.Timer = false, 60

Config.HealthDamage, Config.ArmorDamage = 5, 5

Config.BodyHealth = {
    ['HEAD'] =       {['Name'] = 'head',        ['Health'] = 100.0},
    ['NECK'] =       {['Name'] = 'neck',        ['Health'] = 100.0},
    ['SPINE'] =      {['Name'] = 'spine',       ['Health'] = 100.0},
    ['LARM'] =       {['Name'] = 'left arm',    ['Health'] = 100.0},
    ['RARM'] =       {['Name'] = 'right arm',   ['Health'] = 100.0},
    ['LHAND'] =      {['Name'] = 'left hand',   ['Health'] = 100.0},
    ['RHAND'] =      {['Name'] = 'right hand',  ['Health'] = 100.0},
    ['LLEG'] =       {['Name'] = 'left leg',    ['Health'] = 100.0},
    ['RLEG'] =       {['Name'] = 'right leg',   ['Health'] = 100.0},
    ['LFOOT'] =      {['Name'] = 'left feet',   ['Health'] = 100.0},
    ['RFOOT'] =      {['Name'] = 'right feet',  ['Health'] = 100.0},
}

Config.HospitalBeds = {
    {
        ['Busy'] = false,
        ['Coords'] = vector4(-812.18, -1224.62, 8.26, 315.27)
    },
    {
        ['Busy'] = false,
        ['Coords'] = vector4(-809.42, -1226.75, 8.26, 316.81)
    },
    {
        ['Busy'] = false,
        ['Coords'] = vector4(-806.82, -1229.19, 8.26, 316.26)
    },
    {
        ['Busy'] = false,
        ['Coords'] = vector4(-803.99, -1231.33, 8.26, 316.47)
    },
    {
        ['Busy'] = false,
        ['Coords'] = vector4(-800.11, -1234.7, 8.26, 318.02)
    },
}

Config.ParkingSlots = {
    [1] = vector4(-837.0, -1231.26, 6.93, 322.25),
    [2] = vector4(-840.23, -1229.8, 6.93, 320.6),
    [3] = vector4(-844.1, -1219.41, 6.68, 12.28),
    [4] = vector4(-831.8, -1217.47, 6.93, 139.09),
    [5] = vector4(-827.38, -1220.1, 6.93, 315.94),
}

Config.Garage = {
    {
        Model = 'emsspeedo'
    }
}

Config.HeliPad = {
    {
        Model = 'AirTwo',
        Coords = vector4(-791.16, -1191.6, 53.03, 52.0),
    }
}

Config.BodyParts = {
    [0]     = 'NONE',
    [31085] = 'HEAD',
    [31086] = 'HEAD',
    [39317] = 'NECK',
    [57597] = 'SPINE',
    [23553] = 'SPINE',
    [24816] = 'SPINE',
    [24817] = 'SPINE',
    [24818] = 'SPINE',
    [10706] = 'UPPER_BODY',
    [64729] = 'UPPER_BODY',
    [11816] = 'LOWER_BODY',
    [45509] = 'LARM',
    [61163] = 'LARM',
    [18905] = 'LHAND',
    [4089] = 'LFINGER',
    [4090] = 'LFINGER',
    [4137] = 'LFINGER',
    [4138] = 'LFINGER',
    [4153] = 'LFINGER',
    [4154] = 'LFINGER',
    [4169] = 'LFINGER',
    [4170] = 'LFINGER',
    [4185] = 'LFINGER',
    [4186] = 'LFINGER',
    [26610] = 'LFINGER',
    [26611] = 'LFINGER',
    [26612] = 'LFINGER',
    [26613] = 'LFINGER',
    [26614] = 'LFINGER',
    [58271] = 'LLEG',
    [63931] = 'LLEG',
    [2108] = 'LFOOT',
    [14201] = 'LFOOT',
    [40269] = 'RARM',
    [28252] = 'RARM',
    [57005] = 'RHAND',
    [58866] = 'RFINGER',
    [58867] = 'RFINGER',
    [58868] = 'RFINGER',
    [58869] = 'RFINGER',
    [58870] = 'RFINGER',
    [64016] = 'RFINGER',
    [64017] = 'RFINGER',
    [64064] = 'RFINGER',
    [64065] = 'RFINGER',
    [64080] = 'RFINGER',
    [64081] = 'RFINGER',
    [64096] = 'RFINGER',
    [64097] = 'RFINGER',
    [64112] = 'RFINGER',
    [64113] = 'RFINGER',
    [36864] = 'RLEG',
    [51826] = 'RLEG',
    [20781] = 'RFOOT',
    [52301] = 'RFOOT',
}

Config.EmsStore = {
    {
        ['ItemName'] = 'wheelchair',
        ['Amount'] = 1,
        ['Slot'] = 1,
    },
    {
        ['ItemName'] = 'pdchestarmor',
        ['Amount'] = 15,
        ['Slot'] = 2,
    },
    {
        ['ItemName'] = 'bandage',
        ['Amount'] = 50,
        ['Slot'] = 3,
    },
    {
        ['ItemName'] = 'ifak',
        ['Amount'] = 50,
        ['Slot'] = 4,
    },
    {
        ['ItemName'] = 'pdradio',
        ['Amount'] = 1,
        ['Slot'] = 5,
    },
    {
        ['ItemName'] = 'toolbox',
        ['Amount'] = 5,
        ['Slot'] = 6,
    },
    {
        ['ItemName'] = 'tirekit',
        ['Amount'] = 5,
        ['Slot'] = 7,
    },
    {
        ['ItemName'] = 'binoculars',
        ['Amount'] = 1,
        ['Slot'] = 8,
    },
}