Config = Config or {}

Config.SellingList = {
    ["weed-bag"] = { -- This is the item name
        ['Item'] = "weed-bag",
        ['Label'] = "Weed Bags",
        ['SellPrice'] = 30, -- p/ SellAmount
        ['SellAmount'] = "ALL", -- AMOUNT as number, "HALF or "ALL" (This example will sell "ALL" weed bags for $30 each so Y x $30)
        ['Timeout'] = 3500, -- Progressbar Timeout
        ['Ped'] = {
            ['Id'] = "weed-bags-seller",
            ['SpriteDistance'] = 10.0,
            ['Distance'] = 5.0,
            ['Position'] = vector4(-1168.5546, -1572.9141, 3.6636, 117.9008),
            ['Model'] = "mp_m_weed_01",
            ['Anim'] = {"amb@world_human_smoking@male@male_b@idle_a idle_a"},
            ['Props'] = {},
        },
        ['Options'] ={
            {
                ['Name'] = "weed_sales",
                ['Icon'] = "fas fa-circle",
                ['Label'] = "Pass Over",
                ['EventType'] = "Client",
                ['EventName'] = "mercy-illegal/client/sell",
                ['EventParams'] = {
                    ['Type'] = "weed-bag", -- This is the item name
                },
                Enabled = function(Entity)
                    return exports["mercy-inventory"]:HasEnoughOfItem("weed-bag", 1) -- Edit this if changing Sell Amount
                end,
            }
        },
    },
    ["cash-rolls"] = { -- This is the item name
        ['Item'] = "cash-rolls",
        ['Label'] = "Cash Rolls",
        ['SellPrice'] = 400, -- p/ SellAmount
        ['SellAmount'] = 5,  -- AMOUNT as number, "HALF or "ALL" (This example will sell 5 cash rolls for $400)
        ['Timeout'] = 3500, -- Progressbar Timeout
        ['Ped'] = {
            ['Id'] = "cash-rolls-selling",
            ['SpriteDistance'] = 10.0,
            ['Distance'] = 5.0,
            ['Position'] = vector4(-1099.1653, -1258.7200, 4.3405, 34.8051),
            ['Model'] = "g_m_m_casrn_01",
            ['Anim'] = {},
            ['Props'] = {},
        },
        ['Options'] ={
            {
                ['Name'] = "rolls_sales",
                ['Icon'] = "fas fa-circle",
                ['Label'] = "Sell Something",
                ['EventType'] = "Client",
                ['EventName'] = "mercy-illegal/client/sell",
                ['EventParams'] = {
                    ['Type'] = "cash-rolls", -- This is the item name 
                },
                Enabled = function(Entity)
                    return exports["mercy-inventory"]:HasEnoughOfItem("cash-rolls", 5) -- Edit this if changing Sell Amount
                end,
            }
        },
    },
}

Config.WeedPlants = {}
Config.WeedUpdateTime = 15 -- Every 15 minutes
Config.WeedRackDryTime = 2 -- 2 Minutes

Config.ContainerWhitelist = { '9432', '7078' }

Config.LabsState = {
    [1] = false,
    [2] = false,
    [3] = false,
    [4] = false
}

Config.GrowthObjects = {
    [1] = {
        ['Hash'] = GetHashKey('bkr_prop_weed_01_small_01b'),
        ['Z-Offset'] = -0.5,
    },
    [2] = {
        ['Hash'] = GetHashKey('bkr_prop_weed_med_01a'),
        ['Z-Offset'] = -3.0,
    },
    [3] = {
        ['Hash'] = GetHashKey('bkr_prop_weed_med_01b'),
        ['Z-Offset'] = -3.0,
    },
    [4] = {
        ['Hash'] = GetHashKey('bkr_prop_weed_lrg_01a'),
        ['Z-Offset'] = -3.0,
    },
    [5] = {
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
