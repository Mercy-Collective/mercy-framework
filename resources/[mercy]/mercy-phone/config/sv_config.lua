ServerConfig = ServerConfig or {}

ServerConfig.Debug = false

ServerConfig.Networks = {
    ["old_bennys"] = {
        vector2(-227.96325683594, -1320.5069580078),
        vector2(-218.24630737305, -1321.9456787109),
        vector2(-218.22074890137, -1335.1350097656),
        vector2(-228.24429321289, -1334.2434082031),
        extraData = {
            Network = "old_bennys",
            Name = "Public Hotspot",
            Password = "",
        }
    },
    ["tunershop"] = { -- TODO
        vector2(391.65963745117, -978.50897216797),
        vector2(391.67614746094, -988.64953613281),
        vector2(387.32861328125, -989.95220947266),
        vector2(387.60003662109, -967.26043701172),
        vector2(393.71447753906, -967.67980957031),
        extraData = {
            Network = "tunershop",
            Name = "Tunershop",
            Password = "tunershop69420",
        }
    },
    -- H&O
}

ServerConfig.Groups = {
    ["sanitation"] = {},
    ["fishing"] = {},
    ["oxy"] = {},
    ["houses"] = {},
    ["delivery"] = {},
}

ServerConfig.RandomNames = {
    ['First'] = {
        'Aiden', 'Jackson', 'Lucas', 'Liam', 'Noah', 'Mason', 'Ethan', 'Caden', 'Oliver', 'Elijah', 'Grayson', 'Jacob', 'Michael', 'Joey', 'Aurelio', 'Evan',
        'Donny', 'Foster', 'Dwayne', 'Grady', 'Quinton', 'Darin', 'Mickey', 'Hank', 'Kim', 'Peter', 'Jeremy', 'Jess', 'Jimmie', 'Vern', 'Pasquale', 'Romeo',
        'Chris', 'Dale', 'Beau', 'Cliff', 'Timothy', 'Raphael', 'Brain', 'Mauro', 'Luke', 'Myron', 'Omar', 'Reynaldo', 'Major', 'Clinton', 'Nolan', 'Raymond', 
    },
    ['Last'] = {
        'Meyer', 'Fuentes', 'Henson', 'Lane', 'Mclean', 'Sanford', 'Howard', 'Huerta', 'Haynes', 'Baldwin', 'Higgins', 'Gallagher', 'Ochoa', 'Roberson',
        'Young', 'Gonzales', 'Carey', 'Banks', 'Mccoy', 'Carr', 'Carroll', 'Morales', 'Huynh', 'Preston', 'Brewer', 'Mckee', 'Suarez', 'Newman', 'Levy',
        'Randall', 'Baxter', 'Terrell', 'Dodson', 'Frazier', 'Wyatt', 'Short', 'Fischer', 'Kim', 'Gonzalez', 'Rogers', 'Walton', 'Henry',  'Cuevas', 'Ball',
        'Holland', 'Christensen', 'Hicks', 'Harmon',
    },
}

ServerConfig.Jobs = {
    ["sanitation"] = {
        ["Rate"] = 1,
        ["Icon"] = 'fas fa-trash-alt',
        ["Label"] = "Los Santos Sanitation",
        ["Name"] = "sanitation",
        ["Location"] = vector4(-352.17, -1545.7, 26.72, 269.89),
        ["RequiresVPN"] = false,
        ['Money'] = math.random(500, 800),
        ['MaxGroupCount'] = 5, -- Max group count for job
        ['MaxMembers'] = 4, -- Max members per group for job
        -- Don't touch
        ["GroupCount"] = 0,
        ["EmployeeCount"] = 0,
        ["IsAvailable"] = true,
        -- Ped
        ["PedModel"] = "s_m_y_construct_01",
        ["Scenario"] = "",
        ["Anim"] = {},
        ["Props"] = {},
    },
    ["fishing"] = {
        ["Rate"] = 2,
        ["Icon"] = 'fas fa-fish',
        ["Label"] = "Fishing",
        ["Name"] = "fishing",
        ["Location"] = vector4(-334.38, 6105.08, 30.45, 225.46),
        ["RequiresVPN"] = false,
        ['MaxGroupCount'] = 5,
        ['MaxMembers'] = 5,
        -- Don't touch
        ["GroupCount"] = 0,
        ["EmployeeCount"] = 0,
        ["IsAvailable"] = true,
        -- Ped
        ["PedModel"] = "cs_old_man1a",
        ["Scenario"] = "",
        ["Anim"] = {},
        ["Props"] = {},
    },
    ["oxy"] = {
        ["Rate"] = 3,
        ["Icon"] = 'fas fa-user-secret',
        ["Label"] = "Dark Market Transports",
        ["Name"] = "oxy",
        ["Location"] = vector4(1701.52, 4857.86, 40.03, 278.46),
        ["RequiresVPN"] = true,
        ['MaxGroupCount'] = 5,
        ['MaxMembers'] = 2,
        -- Don't touch
        ["GroupCount"] = 0,
        ["EmployeeCount"] = 0,
        ["IsAvailable"] = true,
        -- Ped
        ["PedModel"] = "a_m_m_og_boss_01",
        ["Scenario"] = "",
        ["Anim"] = {},
        ["Props"] = {},
    },
    ["houses"] = {
        ["Rate"] = 4,
        ["Icon"] = 'fas fa-home',
        ["Label"] = "House Cleaning",
        ["Name"] = "houses",
        ["Location"] = vector4(-969.73, 524.84, 80.47, 147.54),
        ["RequiresVPN"] = true,
        ['MaxGroupCount'] = 5,
        ['MaxMembers'] = 2,
        -- Don't touch
        ["GroupCount"] = 0,
        ["EmployeeCount"] = 0,
        ["IsAvailable"] = true,
        -- Ped
        ["PedModel"] = "a_m_m_og_boss_01",
        ["Scenario"] = "",
        ["Anim"] = {},
        ["Props"] = {},
    },
    ["delivery"] = {
        ["Rate"] = 5,
        ["Icon"] = 'fas fa-truck-loading',
        ["Label"] = "24/7 Deliveries",
        ["Name"] = "delivery",
        ["Location"] = vector4(929.94, -1249.29, 24.5, 34.19),
        ["RequiresVPN"] = false,
        ['Money'] = math.random(2500, 2900),
        ['MaxGroupCount'] = 5,
        ['MaxMembers'] = 2,
        -- Don't touch
        ["GroupCount"] = 0,
        ["EmployeeCount"] = 0,
        ["IsAvailable"] = true,
        -- Ped
        ["PedModel"] = "s_m_m_gentransport",
        ["Scenario"] = "",
        ["Anim"] = {},
        ["Props"] = {},
    },
}

ServerConfig.DarkItems = {
    {
        Icon = 'fas fa-user-secret',
        Name = 'VPN',
        Label = 'VPN',
        Hidden = false,
        Payment = {
            Amount = 20,
            Label = 'Shungite'
        },
        DropOffs = {
            {
                Label = 'Drop Off 1',
                Coords = vector3(508.83, 3099.87, 41.31),
            },
        },
    },
    {
        Icon = 'fas fa-clipboard-list',
        Name = 'darkmarketdeliveries',
        Label = 'Delivery List',
        Hidden = false,
        Payment = {
            Amount = 10,
            Label = 'Shungite'
        },
        DropOffs = {
            {
                Label = 'Drop Off 1',
                Coords = vector3(508.83, 3099.87, 41.31),
            },
        },
    },
    {
        Icon = 'fas fa-laptop',
        Name = 'heist-laptop-green',
        Label = 'Laptop Green',
        Hidden = true, -- Hide from phone market
        Payment = {
            Amount = 15,
            Label = 'Shungite'
        },
        DropOffs = {
            {
                Label = 'Drop Off 1',
                Coords = vector3(508.83, 3099.87, 41.31),
            },
        },
    },
    -- Future use O_O
    -- { 
    --     Icon = 'fas fa-usb-drive',
    --     Name = 'darkmarketdeliveries',
    --     Label = 'Phone Dongle',
    --     Payment = {
    --         Amount = 50,
    --         Label = 'Guinea'
    --     },
    --     DropOffs = {
    --         {
    --             Label = 'Drop Off 1',
    --             Coords = vector3(508.83, 3099.87, 41.31),
    --         },
    --     },
    -- },
}