Config = {}

Config.Server = {
    ['Debug'] = true,
    ['IdentifierType'] = "steam",
    -- Don't touch
    ['PermissionList'] = {}
}

Config.JoinChecks = {
    ['Name'] = true,
    ['Discord'] = false,
    ['Identifier'] = true,
    ['Ban'] = true,
}

Config.Player = {
    ['MoneyTypes'] = {
        ['Cash'] = 500, 
        ['Bank'] = 2500, 
        ['Casino'] = 0,
        ['Crypto'] = {
            ['shungite'] = 0.00,
            ['guinea'] = 0.00,
        },
    },
    ['LicenseTypes'] = {
        ["Drivers"] = true, 
        ['Hunting'] = false, 
        ['Fishing'] = false,
        ['Weapons'] = false,
        ['Pilot'] = false,
    },
    ['InventoryMaxWeight'] = 250.0,
    ['BloodTypes'] = {"A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"},
    ['DefaultPhone'] = "202-555"..math.random(1111, 9999),
    ['DefaultBank'] = math.random(1111111111, 9999999999),
    ['DefaultEmail'] = "@lossantos.com",
    ['DeleteTables'] = { -- Tables to delete on char deletion.
        'player_skins', 
        'player_outfits', 
        'player_vehicles', 
        'player_houses',
        'player_phone_debts',
        'player_phone_contacts',
        'player_phone_documents',
        'player_phone_messages',
    },
}