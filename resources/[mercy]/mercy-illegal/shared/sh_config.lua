Config = Config or {}

Config.WeedPlants = {}
Config.WeedUpdateTime = 15 -- Every 15 minutes
Config.WeedRackDryTime = 2 -- 2 Minutes

Config.ContainerWhitelist = { '9432', '7078' }

Config.GrowthObjects = {
    {
        ['Hash'] = GetHashKey('bkr_prop_weed_01_small_01b'),
        ['Z-Offset'] = -0.5,
    },
    {
        ['Hash'] = GetHashKey('bkr_prop_weed_med_01a'),
        ['Z-Offset'] = -3.0,
    },
    {
        ['Hash'] = GetHashKey('bkr_prop_weed_med_01b'),
        ['Z-Offset'] = -3.0,
    },
    {
        ['Hash'] = GetHashKey('bkr_prop_weed_lrg_01a'),
        ['Z-Offset'] = -3.0,
    },
    {
        ['Hash'] = GetHashKey('bkr_prop_weed_lrg_01b'),
        ['Z-Offset'] = -3.0,
    }
}

Config.ScalesCrafting = {
    {
        ['ItemName'] = 'weed-bag',
        ['Slot'] = 1,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'joint',
        ['Slot'] = 2,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'weed-dried-bud-two',
        ['Slot'] = 3,
        ['Amount'] = 100,
        ['Info'] = '',
        ['Multiplier'] = 2,
    },
}

Config.BenchCrafting = {
    {
        ['ItemName'] = 'weapon_browning',
        ['Slot'] = 1,
        ['Amount'] = 1,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'weapon_mac10',
        ['Slot'] = 2,
        ['Amount'] = 1,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'weapon_uzi',
        ['Slot'] = 3,
        ['Amount'] = 1,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'weapon_draco',
        ['Slot'] = 4,
        ['Amount'] = 1,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'smg-ammo',
        ['Slot'] = 5,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'rifle-ammo',
        ['Slot'] = 6,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'silencer_oilcan',
        ['Slot'] = 7,
        ['Amount'] = 20,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'handcuffs',
        ['Slot'] = 8,
        ['Amount'] = 20,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'lockpick',
        ['Slot'] = 9,
        ['Amount'] = 20,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'advlockpick',
        ['Slot'] = 10,
        ['Amount'] = 20,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'thermitecharge',
        ['Slot'] = 11,
        ['Amount'] = 20,
        ['Info'] = '',
    },
}

Config.BoostingTiers = {
    "D",
    "C",
    "B",
    "A",
    "S",
    "S+",
    "MAX",
}