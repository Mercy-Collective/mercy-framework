Config = Config or {}

Config.VehicleParts = {}

-- [ Main ] --

Config.BusinessAccounts = {
    ['Burger Shot'] = '5614377086',
    ['Diamond Casino'] = '1513596937',
    ['Dynasty 8'] = '2118938858',
    ['Vultur Le Culture'] = '4364364320',
    ['Digital Den'] = '3079865210',
    ['Hayes Repairs'] = '6384518886',
    ['UwU Café'] = '5407872372',
}

Config.DefaultRanks = {
    ['Owner'] = {
        ['Default'] = true,
        ['Name'] = 'Owner',
        ['Permissions'] = {
            ['hire'] = true,
            ['fire'] = true,
            ['change_role'] = true,
            ['pay_employee'] = true,
            ['pay_external'] = true,
            ['charge_external'] = true,
            ['property_keys'] = true,
            ['stash_access'] = true,
            ['craft_access'] = true,
            ['account_access'] = true,
        }
    },
    ['Employee'] = {
        ['Default'] = true,
        ['Name'] = 'Employee',
        ['Permissions'] = {
            ['hire'] = false,
            ['fire'] = false,
            ['change_role'] = false,
            ['pay_employee'] = false,
            ['pay_external'] = false,
            ['charge_external'] = false,
            ['property_keys'] = true,
            ['stash_access'] = false,
            ['craft_access'] = false,
            ['account_access'] = false,
        }
    },
}

-- [ Foodchain ] --

Config.FoodChainLocations = {
    ['Burger Shot'] = vector3(-1196.12, -894.95, 13.98),
    ['UwU Café'] = vector3(-581.79, -1059.72, 22.34)
}

Config.ActiveEmployees = {
    ['Burger Shot'] = {},
    ['UwU Café'] = {}
}

Config.ActivePayments = {
    ['Burger Shot'] = {},
    ['UwU Café'] = {}
}

Config.FoodChainDishes = {
    ['Burger Shot'] = {
        ['Main'] = {
            'heartstopper',
            'bleeder',
            'moneyshot',
            'torpedo',
        },
        ['Drink'] = {
            'coffee',
            'softdrink',
            'milkshake',
        },
        ['Side'] = {
            'fries',
            'ingredient-patty',
        }
    },
    ['UwU Café'] = {
        ['Main'] = {
            'uwu-sushi',
            'uwu-sashamiboat',
            'uwu-omurice',
        },
        ['Drink'] = {
            'uwu-strawberrytea',
            'uwu-matchatea',
            'uwu-cataccino-strawberry',
        },
        ['Side'] = {
            'uwu-magicdrcandy',
            'uwu-avocadotoast',
            'uwu-misosoup',
            'uwu-seaweedsalad',
            'uwu-onigiri',
        },
    },
}

Config.FoodChainOrders = {
    -- A separate title can be created for each business and configured as desired.
    ['UwU Café'] = {
        [1] = {
            ['Title'] = 'Customer order',
            ['OrderMail'] = '1x Patates Kızartması, 1x Soft Drink',
            price = 500,
            center = vector3(1060.18, -377.85, 67.85),
            length = 1.0,
            width = 0.2,
            name = "order",
            heading = 311,
            minZ = 67.25,
            maxZ = 69.45,
            options = {
                {
                    Name = 'order_1',
                    Icon = 'fas fa-circle',
                    Label = 'Deliver Orders',
                    EventType = 'Client',
                    EventName = 'mercy-business/client/deliver-order',
                    EventParams = { RequestItem = { {Name = 'fries', Amount = 1}, {Name = 'softdrink', Amount = 1}, }, },
                    Enabled = function(Entity)
                        if not exports['mercy-hospital']:IsDead() and exports['mercy-business']:NearCustomerLoc() and (exports['mercy-business']:IsPlayerInBusiness('UwU Café') or exports['mercy-business']:IsPlayerInBusiness('Burger Shot') or exports['mercy-business']:IsPlayerInBusiness('Pizza This')) then
                            return true
                        end
                    end,
                }
            },
        },
    },
}

-- [ Gallery ] --

Config.GemColors = {
    ['Jade'] = 92,  -- 53 92
    ['Ruby'] = 34, -- 27
    ['Onyx'] = 53,
    ['Diamond'] = 111,
    ['Sapphire'] = 62,
    ['Aquamarine'] = 74,
}

-- [ Digital Den ] --

Config.DigitalCrafting = {
    {
        ['ItemName'] = 'phone',
        ['Slot'] = 1,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'radio',
        ['Slot'] = 2,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'walkman',
        ['Slot'] = 3,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'gopro',
        ['Slot'] = 4,
        ['Amount'] = 100,
        ['Info'] = '',
    },
}

-- [ Hayes ] --

-- Config.DefaultParts = {['Axle'] = 100, ['Brakes'] = 100, ['Engine'] = 100, ['Clutch'] = 100, ['FuelInjectors'] = 100, ['Transmission'] = 100}

Config.HayesCrafting = {
    {
        ['ItemName'] = 'car-polish',
        ['Slot'] = 1,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'toolbox',
        ['Slot'] = 2,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'tirekit',
        ['Slot'] = 3,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'axle-s',
        ['Slot'] = 4,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'axle-a',
        ['Slot'] = 5,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'axle-b',
        ['Slot'] = 6,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'axle-c',
        ['Slot'] = 7,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'axle-d',
        ['Slot'] = 8,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'axle-e',
        ['Slot'] = 9,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'axle-m',
        ['Slot'] = 10,
        ['Amount'] = 100,
        ['Info'] = '',
    },

    {
        ['ItemName'] = 'brakes-s',
        ['Slot'] = 11,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'brakes-a',
        ['Slot'] = 12,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'brakes-b',
        ['Slot'] = 13,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'brakes-c',
        ['Slot'] = 14,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'brakes-d',
        ['Slot'] = 15,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'brakes-e',
        ['Slot'] = 16,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'brakes-m',
        ['Slot'] = 17,
        ['Amount'] = 100,
        ['Info'] = '',
    },

    {
        ['ItemName'] = 'clutch-s',
        ['Slot'] = 18,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'clutch-a',
        ['Slot'] = 19,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'clutch-b',
        ['Slot'] = 20,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'clutch-b',
        ['Slot'] = 20,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'clutch-c',
        ['Slot'] = 21,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'clutch-d',
        ['Slot'] = 22,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'clutch-e',
        ['Slot'] = 23,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'clutch-m',
        ['Slot'] = 24,
        ['Amount'] = 100,
        ['Info'] = '',
    },

    {
        ['ItemName'] = 'engine-s',
        ['Slot'] = 25,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'engine-a',
        ['Slot'] = 26,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'engine-b',
        ['Slot'] = 27,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'engine-c',
        ['Slot'] = 28,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'engine-d',
        ['Slot'] = 29,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'engine-e',
        ['Slot'] = 30,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'engine-m',
        ['Slot'] = 31,
        ['Amount'] = 100,
        ['Info'] = '',
    },

    {
        ['ItemName'] = 'injectors-s',
        ['Slot'] = 32,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'injectors-a',
        ['Slot'] = 33,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'injectors-b',
        ['Slot'] = 34,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'injectors-c',
        ['Slot'] = 35,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'injectors-d',
        ['Slot'] = 36,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'injectors-e',
        ['Slot'] = 37,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'injectors-m',
        ['Slot'] = 38,
        ['Amount'] = 100,
        ['Info'] = '',
    },

    {
        ['ItemName'] = 'transmission-s',
        ['Slot'] = 39,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'transmission-a',
        ['Slot'] = 40,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'transmission-b',
        ['Slot'] = 41,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'transmission-c',
        ['Slot'] = 42,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'transmission-d',
        ['Slot'] = 43,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'transmission-e',
        ['Slot'] = 44,
        ['Amount'] = 100,
        ['Info'] = '',
    },
    {
        ['ItemName'] = 'transmission-m',
        ['Slot'] = 45,
        ['Amount'] = 100,
        ['Info'] = '',
    },
}

Config.HayesZones = {
    {
        center = vector3(129.22, -3031.52, 7.04),
        length = 2.0,
        width = 1.0,
        name = "tunershop_stash",
        heading = 345,
        minZ = 6.04,
        maxZ = 7.64,
        options = {
            {
                Name = 'stash',
                Icon = 'fas fa-box-open',
                Label = 'Stash',
                EventType = 'Client',
                EventName = 'mercy-business/client/hayes/stash',
                EventParams = { Business = '6STR. Tuner Shop', Name = 'tunershop' },
                Enabled = function(Entity)
                    return true
                end,
            },
            {
                Name = 'craft',
                Icon = 'fas fa-wrench',
                Label = 'Craft',
                EventType = 'Client',
                EventName = 'mercy-business/client/hayes/craft',
                EventParams = { Business = '6STR. Tuner Shop' },
                Enabled = function(Entity)
                    return true
                end,
            },
        },
    },
    {
        center = vector3(837.04, -811.74, 26.35),
        length = 2.0,
        width = 1.0,
        name = "ottos_stash",
        heading = 0,
        minZ = 25.35,
        maxZ = 26.45,
        options = {
            {
                Name = 'stash',
                Icon = 'fas fa-box-open',
                Label = 'Stash',
                EventType = 'Client',
                EventName = 'mercy-business/client/hayes/stash',
                EventParams = { Business = "Ottos Autos", Name = 'ottos' },
                Enabled = function(Entity)
                    return true
                end,
            },
            {
                Name = 'craft',
                Icon = 'fas fa-wrench',
                Label = 'Craft',
                EventType = 'Client',
                EventName = 'mercy-business/client/hayes/craft',
                EventParams = { Business = "Ottos Autos" },
                Enabled = function(Entity)
                    return true
                end,
            },
        },
    },
    {
        center = vector3(272.24, -1803.96, 26.91),
        length = 5.85,
        width = 2.1,
        name = "hayes_stash",
        heading = 320,
        minZ = 25.91,
        maxZ = 27.71,
        options = {
            {
                Name = 'stash',
                Icon = 'fas fa-box-open',
                Label = 'Stash',
                EventType = 'Client',
                EventName = 'mercy-business/client/hayes/stash',
                EventParams = { Business = "Hayes Repairs", Name = 'hayes' },
                Enabled = function(Entity)
                    return true
                end,
            },
            {
                Name = 'craft',
                Icon = 'fas fa-wrench',
                Label = 'Craft',
                EventType = 'Client',
                EventName = 'mercy-business/client/hayes/craft',
                EventParams = { Business = "Hayes Repairs" },
                Enabled = function(Entity)
                    return true
                end,
            },
        },
    },
}

function Round(Value, Decimals)
    return Decimals and math.floor((Value * 10 ^ Decimals) + 0.5) / (10 ^ Decimals) or math.floor(Value + 0.5)
end
