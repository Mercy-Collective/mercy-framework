Config = Config or {}

Config.CommandList = {
    -- Player
    {
        ['Id'] = 'player',
        ['Name'] = 'Player',
        ['Items'] = {
            {
                ['Id'] = 'noclip',
                ['Name'] = 'Noclip',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Toggle:Noclip',
                ['EventType'] = 'Client',
                ['Collapse'] = false,
            },
            {
                ['Id'] = 'changeModel',
                ['Name'] = 'Change Model',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Change:Model',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                    {
                        ['Id'] = 'model',
                        ['Name'] = 'Model',
                        ['Type'] = 'input-choice',
                        ['Choices'] = GetModels(),
                    },
                },
            },
            {
                ['Id'] = 'resetModel',
                ['Name'] = 'Reset Model',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Reset:Model',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                },
            },
            {
                ['Id'] = 'openClothing',
                ['Name'] = 'Clothing',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Open:Clothing',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                },
            },
            {
                ['Id'] = 'giveArmor',
                ['Name'] = 'Armor',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Armor',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                },
            },
            {
                ['Id'] = 'food-drink',
                ['Name'] = 'Food & Drink',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Food:Drink',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                },
            },
            {
                ['Id'] = 'setEnvironment',
                ['Name'] = 'Set Environment',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Set:Environment',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'weather',
                        ['Name'] = 'Weather Type',
                        ['Type'] = 'input-choice',
                        ['Choices'] = GetWeatherTypes(),
                    },
                    {
                        ['Id'] = 'hour',
                        ['Name'] = 'Hour',
                        ['Type'] = 'input',
                        ['InputType'] = 'number',
                    },
                    {
                        ['Id'] = 'minute',
                        ['Name'] = 'Minutes',
                        ['Type'] = 'input',
                        ['InputType'] = 'number',
                    },
                },
            },
            {
                ['Id'] = 'opinventory',
                ['Name'] = 'Open Inventory',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:OpenInv',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                },
            },
            {
                ['Id'] = 'kill',
                ['Name'] = 'Kill',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Kill',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                },
            },
            {
                ['Id'] = 'revive',
                ['Name'] = 'Revive',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Revive',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                },
            },
            {
                ['Id'] = 'create_business',
                ['Name'] = 'Create Business',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Businesses:Create',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Owner (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                    {
                        ['Id'] = 'name',
                        ['Name'] = 'Business Name',
                        ['Type'] = 'input',
                        ['InputType'] = 'text',
                    },
                    {
                        ['Id'] = 'logo',
                        ['Name'] = 'Business Logo (Font Awesome: eg. fas fa-car)',
                        ['Type'] = 'input',
                        ['InputType'] = 'text',
                    },
                },
            },
            {
                ['Id'] = 'delete_business',
                ['Name'] = 'Delete Business',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Businesses:Delete',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'name',
                        ['Name'] = 'Business',
                        ['Type'] = 'input-choice',
                        ['Choices'] = GetBusinesses(),
                    },
                },
            },
            {
                ['Id'] = 'set_business_owner',
                ['Name'] = 'Set Business Owner',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Businesses:SetOwner',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                    {
                        ['Id'] = 'name',
                        ['Name'] = 'Business',
                        ['Type'] = 'input-choice',
                        ['Choices'] = GetBusinesses(),
                    },
                },
            },
            {
                ['Id'] = 'set_business_logo',
                ['Name'] = 'Set Business Logo',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Businesses:SetLogo',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'name',
                        ['Name'] = 'Business',
                        ['Type'] = 'input-choice',
                        ['Choices'] = GetBusinesses(),
                    },
                    {
                        ['Id'] = 'logo',
                        ['Name'] = 'Business Logo (Font Awesome: eg. fas fa-car)',
                        ['Type'] = 'input',
                        ['InputType'] = 'text',
                    },
                },
            },
            {
                ['Id'] = 'add_business_employee',
                ['Name'] = 'Add Business Employee',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Businesses:AddEmployee',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                    {
                        ['Id'] = 'name',
                        ['Name'] = 'Business',
                        ['Type'] = 'input-choice',
                        ['Choices'] = GetBusinesses(),
                    },
                    {
                        ['Id'] = 'rank',
                        ['Name'] = 'Rank',
                        ['Type'] = 'input',
                        ['InputType'] = 'text',
                    },
                },
            },
            {
                ['Id'] = 'reviveRadius',
                ['Name'] = 'Revive in Radius',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Revive:Radius',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'radius',
                        ['Name'] = 'Radius',
                        ['Type'] = 'input',
                        ['InputType'] = 'number',
                    },
                },
            },
            {
                ['Id'] = 'reviveAll',
                ['Name'] = 'Revive All',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'mc-admin/server/revive-all',
                ['EventType'] = 'Server',
                ['Collapse'] = false,
            },
            {
                ['Id'] = 'removeStress',
                ['Name'] = 'Remove Stress',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Remove:Stress',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                },
            },
            {
                ['Id'] = 'freezePlayer',
                ['Name'] = 'Freeze Player',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Freeze:Player',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                },
            },
            {
                ['Id'] = 'cloak',
                ['Name'] = 'Cloak',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Cloak',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                },
            },
            {
                ['Id'] = 'godmode',
                ['Name'] = 'Godmode',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Godmode',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                },
            },
            {
                ['Id'] = 'infAmmo',
                ['Name'] = 'Infinite Ammo',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Infinite:Ammo',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                },
            },
            {
                ['Id'] = 'infStamina',
                ['Name'] = 'Infinite Stamina',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Infinite:Stamina',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                },
            },
        }
    },
    -- Utility
    {
        ['Id'] = 'utility',
        ['Name'] = 'Utility',
        ['Items'] = {
            {
                ['Id'] = 'playerblips',
                ['Name'] = 'Player Blips',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Toggle:PlayerBlips',
                ['EventType'] = 'Client',
                ['Collapse'] = false,
            },
            {
                ['Id'] = 'playernames',
                ['Name'] = 'Player Names',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Toggle:PlayerNames',
                ['EventType'] = 'Client',
                ['Collapse'] = false,
            },
            {
                ['Id'] = 'deleteArea',
                ['Name'] = 'Delete In Area',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Delete:Area',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'type',
                        ['Name'] = 'Type',
                        ['Type'] = 'input-choice',
                        ['Choices'] = GetDeletionTypes()
                    },
                    {
                        ['Id'] = 'radius',
                        ['Name'] = 'Radius',
                        ['Type'] = 'input',
                        ['InputType'] = 'number',
                    },
                },
            },
            {
                ['Id'] = 'deleteVehicle',
                ['Name'] = 'Delete Vehicle',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Delete:Vehicle',
                ['Collapse'] = false,
            },
            {
                ['Id'] = 'spawnVehicle',
                ['Name'] = 'Spawn Vehicle',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Spawn:Vehicle',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'model',
                        ['Name'] = 'Model',
                        ['Type'] = 'input-choice',
                        ['Choices'] = GetAddonVehicles()
                    },
                },
            },
            {
                ['Id'] = 'fixVehicle',
                ['Name'] = 'Fix Vehicle',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Fix:Vehicle',
                ['EventType'] = 'Client',
                ['Collapse'] = false,
            },
            {
                ['Id'] = 'teleport',
                ['Name'] = 'Teleport',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Teleport',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                    {
                        ['Id'] = 'type',
                        ['Name'] = 'Type',
                        ['Type'] = 'input-choice',
                        ['Choices'] = {
                            {
                                Text = 'Goto'
                            },
                            {
                                Text = 'Bring'
                            }
                        }
                    },
                },
            },
            {
                ['Id'] = 'teleportAll',
                ['Name'] = 'Teleport All',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'mc-admin/server/teleport-all',
                ['EventType'] = 'Server',
                ['Collapse'] = false,
            },
            {
                ['Id'] = 'toggleCoords',
                ['Name'] = 'Toggle Coords',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Coords:Toggle',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                },
            },
            {
                ['Id'] = 'teleportCoords',
                ['Name'] = 'Teleport Coords',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Teleport:Coords',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'x-coord',
                        ['Name'] = 'X Coord',
                        ['Type'] = 'input',
                        ['InputType'] = 'number',
                    },
                    {
                        ['Id'] = 'y-coord',
                        ['Name'] = 'Y Coord',
                        ['Type'] = 'input',
                        ['InputType'] = 'number',
                    },
                    {
                        ['Id'] = 'z-coord',
                        ['Name'] = 'Z Coord',
                        ['Type'] = 'input',
                        ['InputType'] = 'number',
                    },
                },
            },
            {
                ['Id'] = 'teleportMarker',
                ['Name'] = 'Teleport Marker',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Teleport:Marker',
                ['EventType'] = 'Client',
                ['Collapse'] = false,
            },
            {
                ['Id'] = 'chatSay',
                ['Name'] = 'cSay',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Chat:Say',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'message',
                        ['Name'] = 'Message',
                        ['Type'] = 'input',
                        ['InputType'] = 'text',
                    }
                }
            },
            {
                ['Id'] = 'copyCoords',
                ['Name'] = 'Copy Coords',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Copy:Coords',
                ['Collapse'] = true,
                ['Options'] = {
                    {
            
                        ['Id'] = 'type',
                        ['Name'] = 'Type',
                        ['Type'] = 'input-choice',             
                        ['Choices'] = {
                            {
                                Text = 'vector3(0.0, 0.0, 0.0)'
                            },
                            {
                                Text = 'vector4(0.0, 0.0, 0.0, 0.0)'
                            },
                            {
                                Text = '0.0, 0.0, 0.0'
                            },
                            {
                                Text = '0.0, 0.0, 0.0, 0.0'
                            },
                            {
                                Text = 'X = 0.0, Y = 0.0, Z = 0.0'
                            },
                            {
                                Text = 'x = 0.0, y = 0.0, z = 0.0'
                            },
                            {
                                Text = 'X = 0.0, Y = 0.0, Z = 0.0, H = 0.0'
                            },
                            {
                                Text = 'x = 0.0, y = 0.0, z = 0.0, h = 0.0'
                            },
                            {
                                Text = '["X"] = 0.0, ["Y"] = 0.0, ["Z"] = 0.0'
                            },
                            {
                                Text = '["x"] = 0.0, ["y"] = 0.0, ["z"] = 0.0'
                            },
                            {
                                Text = '["X"] = 0.0, ["Y"] = 0.0, ["Z"] = 0.0, ["H"] = 0.0'
                            },
                            {
                                Text = '["x"] = 0.0, ["y"] = 0.0, ["z"] = 0.0, ["h"] = 0.0'
                            }
                        }
                    },
                },
            },
        }
    },
    -- User
    {
        ['Id'] = 'user',
        ['Name'] = 'User',
        ['Items'] = {
            -- {
            --     ['Id'] = 'setgang',
            --     ['Name'] = 'Request Gang',
            --     ['UseKVPGroups'] = true, 
            --     -- Below Groups Table will not be used when Option above is enabled. 
            --     -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
            --     ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
            --     ['Event'] = 'Admin:Request:Gang',
            --     ['Collapse'] = true,
            --     ['Options'] = {
            --         {
            --             ['Id'] = 'player',
            --             ['Name'] = 'Target (Not Required)',
            --             ['Type'] = 'input-choice',
            --             ['PlayerList'] = true,
            --         },
            --         {
            --             ['Id'] = 'gang',
            --             ['Name'] = 'Gang',
            --             ['Type'] = 'input-choice',
            --             ['Choices'] = GetGangs()
            --         },
            --     },
            -- },
            {
                ['Id'] = 'setjob',
                ['Name'] = 'Request Job',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Request:Job',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                    {
                        ['Id'] = 'job',
                        ['Name'] = 'Job',
                        ['Type'] = 'input-choice',
                        ['Choices'] = GetJobs()
                    },
                },
            },
            {
                ['Id'] = 'giveItem',
                ['Name'] = 'Give Item',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:GiveItem',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                    {
                        ['Id'] = 'item',
                        ['Name'] = 'Item',
                        ['Type'] = 'input-choice',
                        ['Choices'] = GetInventoryItems()
                    },
                    {
                        ['Id'] = 'amount',
                        ['Name'] = 'Amount',
                        ['Type'] = 'input',
                        ['InputType'] = 'number',
                    },
                },
            },
            {
                ['Id'] = 'setMoney',
                ['Name'] = 'Set Money',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:SetMoney',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                    {
                        ['Id'] = 'moneytype',
                        ['Name'] = 'Money Type',
                        ['Type'] = 'input-choice',
                        ['Choices'] = GetMoneyTypes()
                    },
                    {
                        ['Id'] = 'amount',
                        ['Name'] = 'Amount',
                        ['Type'] = 'input',
                        ['InputType'] = 'number',
                    },
                },
            },
            {
                ['Id'] = 'giveMoney',
                ['Name'] = 'Give Money',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:GiveMoney',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                    {
                        ['Id'] = 'moneytype',
                        ['Name'] = 'Money Type',
                        ['Type'] = 'input-choice',
                        ['Choices'] = GetMoneyTypes()
                    },
                    {
                        ['Id'] = 'amount',
                        ['Name'] = 'Amount',
                        ['Type'] = 'input',
                        ['InputType'] = 'number',
                    },
                },
            },
            {
                ['Id'] = 'openBennys',
                ['Name'] = 'Bennys',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Bennys',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                },
            },
            {
                ['Id'] = 'refreshPermissions',
                ['Name'] = 'Refresh Permissions',
                ['UseKVPGroups'] = false, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'admin', 'god'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Permissions:Refresh',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                },
            },
            {
                ['Id'] = 'setPermissions',
                ['Name'] = 'Set Permissions',
                ['UseKVPGroups'] = false, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'god'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Permissions:Set',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                    {
                        ['Id'] = 'group',
                        ['Name'] = 'Group',
                        ['Type'] = 'input-choice',
                        ['Choices'] = GetPlayerGroups()
                    }
                },
            },
            {
                ['Id'] = 'banPlayer',
                ['Name'] = 'Ban Player',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Ban',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                    {
                        ['Id'] = 'expire',
                        ['Name'] = 'Expire',
                        ['Type'] = 'input-choice',
                        ['Choices'] = {
                            {
                                Text = '1 Hour'
                            },
                            {
                                Text = '6 Hours'
                            },
                            {
                                Text = '12 Hours'
                            },
                            {
                                Text = '1 Day'
                            },
                            {
                                Text = '3 Days'
                            },
                            {
                                Text = '1 Week'
                            },
                            {
                                Text = 'Permanent'
                            }
                        }
                    },
                    {
                        ['Id'] = 'reason',
                        ['Name'] = 'Reason',
                        ['Type'] = 'input',
                        ['InputType'] = 'text',
                    },
                },
            },
            {
                ['Id'] = 'unbanPlayer',
                ['Name'] = 'Unban Player',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Unban',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['Choices'] = {}
                    },
                },
            },
            {
                ['Id'] = 'requestAmmo',
                ['Name'] = 'Spawn Ammo',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Set:Ammo',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                    {
                        ['Id'] = 'amount',
                        ['Name'] = 'Amount',
                        ['Type'] = 'input-text',
                        ['InputType'] = 'number',
                    },
                },
            },
            {
                ['Id'] = 'kickPlayer',
                ['Name'] = 'Kick Player',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Kick',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                    {
                        ['Id'] = 'reason',
                        ['Name'] = 'Reason',
                        ['Type'] = 'input',
                        ['InputType'] = 'text',
                    },
                },
            },
            {
                ['Id'] = 'kickAllPlayer',
                ['Name'] = 'Kick All Players',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Kick:All',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'reason',
                        ['Name'] = 'Reason',
                        ['Type'] = 'input',
                        ['InputType'] = 'text',
                    },
                },
            },
            {
                ['Id'] = 'spectate',
                ['Name'] = 'Spectate Player',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Toggle:Spectate',
                ['EventType'] = 'Client',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                }
            },
            {
                ['Id'] = 'veh_devmode',
                ['Name'] = 'Vehicle Dev Mode',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Toggle:VehDevMode',
                ['EventType'] = 'Client',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                }
            },
            {
                ['Id'] = 'object_view',
                ['Name'] = 'Object Debug',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Toggle:ObjectView',
                ['EventType'] = 'Client',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                }
            },
            {
                ['Id'] = 'ped_view',
                ['Name'] = 'Ped Debug',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Toggle:PedView',
                ['EventType'] = 'Client',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                }
            },
            {
                ['Id'] = 'veh_view',
                ['Name'] = 'Vehicle Debug',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Toggle:VehView',
                ['EventType'] = 'Client',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                }
            },
            {
                ['Id'] = 'entity_freeaim',
                ['Name'] = 'Entity Free Aim Debug',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Toggle:EntityFreeAim',
                ['EventType'] = 'Client',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                }
            },
        }
    },
    -- Fun
    {
        ['Id'] = 'fun',
        ['Name'] = 'Fun',
        ['Items'] = {
            {
                ['Id'] = 'flingPlayer',
                ['Name'] = 'Fling Player',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Fling:Player',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                },
            },
            {
                ['Id'] = 'drunkPlayer',
                ['Name'] = 'Make Player Drunk',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Drunk',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                },
            },
            {
                ['Id'] = 'animalattackPlayer',
                ['Name'] = 'Animal Attack',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Animal:Attack',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                },
            },
            {
                ['Id'] = 'setfirePlayer',
                ['Name'] = 'Set On Fire',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Set:Fire',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                },
            },
            {
                ['Id'] = 'fartPlayer',
                ['Name'] = 'Fart Sound',
                ['UseKVPGroups'] = true, 
                -- Below Groups Table will not be used when Option above is enabled. 
                -- Command Groups will be handled by KVP and can be changed thru a command ingame: menuperms [add,remove,list] [commandid] [group]
                ['Groups'] = {'all'}, -- 'all', 'admin', 'god', 'mod'
                ['Event'] = 'Admin:Fart:Player',
                ['Collapse'] = true,
                ['Options'] = {
                    {
                        ['Id'] = 'player',
                        ['Name'] = 'Target (Not Required)',
                        ['Type'] = 'input-choice',
                        ['PlayerList'] = true,
                    },
                    {
                        ['Id'] = 'fart',
                        ['Name'] = 'Fart',
                        ['Type'] = 'input-choice',
                        ['Choices'] = GetFarts()
                    },
                },
            },
        }
    },
}