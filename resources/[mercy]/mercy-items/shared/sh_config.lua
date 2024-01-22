Config = Config or {}

Config.RandomPresentItems = {
    'lockpick',
    'bandage',
    'bread',
    'water',
}

Config.BuffItems = {}

Config.SpecialFood = {
    ['heartstopper'] = true,
}

Config.SpecialWater = {
    ['milkshake'] = true,
    ['slushy'] = true,
}

Config.FastFood = {
    ['heartstopper'] = true,
    ['moneyshot'] = true,
    ['bleeder'] = true,
    ['torpedo'] = true,
    ['fries'] = true,
}

Config.Fruits = { -- Name, Amount of Food / Thirst
    ['apple'] = {
        ['Water'] = math.random(2, 6),
        ['Food'] = math.random(5, 8),
    },
    ['banana'] = {
        ['Water'] = math.random(1, 3),
        ['Food'] = math.random(6, 9),
    },
    ['cherry'] = {
        ['Water'] = math.random(2, 5),
        ['Food'] = math.random(3, 7),
    },
    ['coconut'] = {
        ['Water'] = math.random(10, 15),
        ['Food'] = math.random(5, 7),
    },
    ['grapes'] = {
        ['Water'] = math.random(6, 9),
        ['Food'] = math.random(3, 6),
    },
    ['kiwi'] = {
        ['Water'] = math.random(5, 9),
        ['Food'] = math.random(4, 8),
    },
    ['lemon'] = {
        ['Water'] = math.random(4, 8),
        ['Food'] = math.random(4, 5),
    },
    ['lime'] = {
        ['Water'] = math.random(4, 8),
        ['Food'] = math.random(4, 5),
    },
    ['orange'] = {
        ['Water'] = math.random(4, 8),
        ['Food'] = math.random(5, 9),
    },
    ['peach'] = {
        ['Water'] = math.random(6, 10),
        ['Food'] = math.random(5, 8),
    },
    ['strawberry'] = {
        ['Water'] = math.random(3, 6),
        ['Food'] = math.random(5, 8),
    },
    ['watermelon'] = {
        ['Water'] = math.random(10, 15),
        ['Food'] = math.random(5, 8),
    },
}

Config.Sprays = {
    "angels",
    "ballas",
    "bbmc",
    "bcf",
    "bsk",
    "cerberus",
    "cg",
    "gg",
    "gsf",
    "guild",
    "hoa",
    "hydra",
    "kingz",
    "lost",
    "mandem",
    "mayhem",
    "nbc",
    "ramee",
    "ron",
    "rust",
    "scu",
    "seaside",
    "st",
    "vagos",
}

Config.Chains = {
    "cerberus",
    "cg",
    "cg2",
    "esv",
    "gg",
    "gsf",
    "koil",
    "mdm",
    "nbc",
    "rl",
    "seaside",
}