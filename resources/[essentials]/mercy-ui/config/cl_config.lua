Config = Config or {}

-- Eye
--[[
    Here's a example on how to place a interaction on a specific 'bone'.
    Well, you actually can't place it on the bone directly, but by checking the distance of the ped and the bone you will get a fairly accurate result too.
    (Full bonelist: mercy-ui/bonelist.md)

    Enabled = function(Entity)
        if GetBoneDistanceFromVehicle(2, "wheel_lr") < 1.0 then
            return true
        else
            return false
        end
    end,

    A great example of this bone checking usage would be checking the `wheel_lr` for showing the fuel option, then a player actually has to be at the fuel tank to fuel the car.
]]

--[[
    EntityTypes:
    0 = no entity
    1 = ped
    2 = vehicle
    3 = object
]]

exports("GetPeekingEntity", function()
    return PeekingEntity
end)

function GetBoneDistanceFromVehicle(EntityType, BoneName)
    if PeekingEntity ~= nil and DoesEntityExist(PeekingEntity) then
        if GetEntityType(PeekingEntity) == EntityType then
            local Bone = GetEntityBoneIndexByName(PeekingEntity, BoneName)

            local BoneCoords = GetWorldPositionOfEntityBone(PeekingEntity, Bone)
            local PlayerCoords = GetEntityCoords(PlayerPedId())        
            return #(BoneCoords - PlayerCoords)
        end
    end

    return 99999.0
end

Config.EyeEntries = {
    ['vehicles'] = {
        Type = 'Default',
        SpriteDistance = 0.0,
        State = false,
        Options = {
            {
                Name = 'refuel_option',
                Label = 'Refuel Vehicle',
                Icon = 'fas fa-gas-pump',
                EventType = 'Client',
                EventName = 'mercy-vehicles/client/fuel/refuel-veh',
                EventParams = {},
                Enabled = function(Entity)
                    if exports['mercy-vehicles']:IsElectricVehicle(Entity) then
                        Config.EyeEntries['vehicles'].Options[1].Label = 'Charge Vehicle'
                        Config.EyeEntries['vehicles'].Options[1].Icon = 'fas fa-charging-station'
                    else
                        Config.EyeEntries['vehicles'].Options[1].Label = 'Refuel Vehicle'
                        Config.EyeEntries['vehicles'].Options[1].Icon = 'fas fa-gas-pump'
                    end
                    if exports['mercy-vehicles']:CanRefuel() then
                        if GetBoneDistanceFromVehicle(2, "wheel_lr") < 1.05 then
                            return true
                        else
                            return false
                        end
                    end
                end,
            },
            {
                Name = 'scan_plate',
                Label = 'Scan Plate',
                Icon = 'fas fa-closed-captioning',
                EventType = 'Client',
                EventName = 'mercy-police/client/scan-plate',
                EventParams = {},
                Enabled = function(Entity)
                    local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
                    return (GetBoneDistanceFromVehicle(2, "bumper_r") < 1.0 or GetBoneDistanceFromVehicle(2, "bumper_f") < 1.0) and Player.Job.Name == 'police' and Player.Job.Duty
                end,
            },
            {
                Name = 'flip_option',
                Label = 'Flip Vehicle',
                Icon = 'fas fa-redo',
                EventType = 'Client',
                EventName = 'mercy-vehicles/client/try-flip-vehicle',
                EventParams = {},
                Enabled = function(Entity)
                    local EntityRoll = GetEntityRoll(Entity)
                    if GetBoneDistanceFromVehicle(2, "bodyshell") < 5.0 and (EntityRoll > 75.0 or EntityRoll < -75.0) then
                        return true
                    else
                        return false
                    end
                end,
            },
            {
                Name = 'check_option',
                Label = 'Check Vehicle',
                Icon = 'fas fa-binoculars',
                EventType = 'Client',
                EventName = 'mercy-business/client/hayes/check-vehicle',
                EventParams = {},
                Enabled = function(Entity)
                    return exports['mercy-business']:IsHayes()
                end,
            },
            {
                Name = 'close_trunk',
                Label = 'Close Trunk',
                Icon = 'fas fa-truck-ramp',
                EventType = 'Client',
                EventName = 'mercy-vehicles/client/toggle-door-data',
                EventParams = {
                    IsMenu = false,
                    DoorNumber = 5,
                },
                Enabled = function(Entity)
                    return ((GetBoneDistanceFromVehicle(2, "boot") < 1.20) and (GetVehicleDoorAngleRatio(Entity, 5) > 0.0))
                end,
            },
            {
                Name = 'open_trunk',
                Label = 'Open Trunk',
                Icon = 'fas fa-truck-ramp',
                EventType = 'Client',
                EventName = 'mercy-vehicles/client/toggle-door-data',
                EventParams = {
                    IsMenu = false,
                    DoorNumber = 5,
                },
                Enabled = function(Entity)
                    return ((GetBoneDistanceFromVehicle(2, "boot") < 1.20) and (GetVehicleDoorAngleRatio(Entity, 5) == 0.0))
                end,
            },
            {
                Name = 'get_in_trunk',
                Label = 'Enter Trunk',
                Icon = 'fas fa-user-secret',
                EventType = 'Client',
                EventName = 'mercy-vehicles/client/get-in-trunk',
                EventParams = {},
                Enabled = function(Entity)
                    return ((GetBoneDistanceFromVehicle(2, "boot") < 1.20) and (GetVehicleDoorAngleRatio(Entity, 5) > 0.0))
                end,
            },
            {
                Name = 'pickup_bicycle',
                Label = 'Pickup Bicycle',
                Icon = 'fas fa-spinner',
                EventType = 'Client',
                EventName = 'mercy-vehicles/client/carry-bicycle',
                EventParams = {},
                Enabled = function(Entity)
                    return IsThisModelABicycle(GetEntityModel(Entity)) and not IsEntityAttachedToAnyPed(Entity) and not IsEntityAttachedToAnyPed(PlayerPedId())
                end,
            },
            -- Oxy
            {
                Name = 'oxy_deliver_package',
                Label = 'Drop Off Goods',
                Icon = 'fas fa-cubes',
                EventType = 'Client',
                EventName = 'mercy-jobs/client/oxy/deliver-goods',
                EventParams = {},
                Enabled = function(Entity)
                    if not exports['mercy-phone']:IsJobCenterTaskActive('oxy', 4) and not exports['mercy-phone']:IsJobCenterTaskActive('oxy', 6) then return false end

                    if Entity == exports['mercy-jobs']:GetOxyVehicle() then
                        return true
                    else
                        return false
                    end
                end,
            },
            -- Sanitation
            {
                Name = 'sanitation_throw_in_trash',
                Label = 'Throw In Trash',
                Icon = 'fas fa-trash-restore',
                EventType = 'Client',
                EventName = 'mercy-jobs/client/sanitation/throw-in-trash',
                EventParams = {},
                Enabled = function(Entity)
                    if exports['mercy-phone']:IsJobCenterTaskActive('sanitation', 4) == false and exports['mercy-phone']:IsJobCenterTaskActive('sanitation', 6) == false then return end

                    if GetEntityModel(Entity) == GetHashKey("trash") and GetBoneDistanceFromVehicle(2, "boot") < 5.0 and GetVehicleDoorAngleRatio(Entity, 5) > 0.0 then
                        return true
                    else
                        return false
                    end
                end,
            },
            {
                Name = 'sanitation_return_vehicle',
                Label = 'Return Vehicle',
                Icon = 'fas fa-circle',
                EventType = 'Client',
                EventName = 'mercy-jobs/client/sanitation/return-veh',
                EventParams = {},
                Enabled = function(Entity)
                    if not exports['mercy-phone']:IsJobCenterTaskActive('sanitation', 7) then return false end

                    if GetEntityModel(Entity) == GetHashKey("trash") and #(GetEntityCoords(Entity) - vector3(-349.49, -1541.75, 27.72)) < 25.0 then
                        return true
                    else
                        return false
                    end
                end,
            },
            -- Delivery
            {
                Name = 'delivery_grab_goods',
                Label = 'Grab Goods',
                Icon = 'fas fa-box-open',
                EventType = 'Client',
                EventName = 'mercy-jobs/client/delivery/grab-goods',
                EventParams = {},
                Enabled = function(Entity)
                    if GetEntityModel(Entity) == GetHashKey("benson") and exports['mercy-phone']:IsJobCenterTaskActive('delivery', 4) then
                        return true
                    else
                        return false
                    end
                end,
            },
            {
                Name = 'delivery_return_vehicle',
                Label = 'Return Vehicle',
                Icon = 'fas fa-circle',
                EventType = 'Client',
                EventName = 'mercy-jobs/client/delivery/return-veh',
                EventParams = {},
                Enabled = function(Entity)
                    if not exports['mercy-phone']:IsJobCenterTaskActive('delivery', 5) then return false end

                    if GetEntityModel(Entity) == GetHashKey("benson") and #(GetEntityCoords(Entity) - vector3(929.94, -1249.29, 25.5)) < 25.0 then
                        return true
                    else
                        return false
                    end
                end,
            },
        }
    },
    ['motorcycle'] = {
        Type = 'Default',
        SpriteDistance = 0.0,
        State = false,
        Options = {
            {
                Name = 'refuel_option',
                Label = 'Refuel Vehicle',
                Icon = 'fas fa-gas-pump',
                EventType = 'Client',
                EventName = 'mercy-vehicles/client/fuel/refuel-veh',
                EventParams = {},
                Enabled = function(Entity)
                    if exports['mercy-vehicles']:IsElectricVehicle(Entity) then
                        Config.EyeEntries['motorcycle'].Options[1].Label = 'Charge Vehicle'
                        Config.EyeEntries['motorcycle'].Options[1].Icon = 'fas fa-charging-station'
                    else
                        Config.EyeEntries['motorcycle'].Options[1].Label = 'Refuel Vehicle'
                        Config.EyeEntries['motorcycle'].Options[1].Icon = 'fas fa-gas-pump'
                    end
                    if exports['mercy-vehicles']:CanRefuel() then
                        if GetBoneDistanceFromVehicle(2, "bodyshell") < 1.15 then
                            return true
                        else
                            return false
                        end
                    end
                end,
            },
            {
                Name = 'check_option',
                Label = 'Check Vehicle',
                Icon = 'fas fa-binoculars',
                EventType = 'Client',
                EventName = 'mercy-business/client/hayes/check-vehicle',
                EventParams = {},
                Enabled = function(Entity)
                    return exports['mercy-business']:IsHayes()
                end,
            },
            {
                Name = 'scan_plate',
                Label = 'Scan Plate',
                Icon = 'fas fa-closed-captioning',
                EventType = 'Client',
                EventName = 'mercy-police/client/scan-plate',
                EventParams = {},
                Enabled = function(Entity)
                    local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
                    return (GetBoneDistanceFromVehicle(2, "bumper_r") < 1.0 or GetBoneDistanceFromVehicle(2, "bumper_f") < 1.0) and Player.Job.Name == 'police' and Player.Job.Duty
                end,
            },
            {
                Name = 'flip_option',
                Label = 'Flip Vehicle',
                Icon = 'fas fa-redo',
                EventType = 'Client',
                EventName = 'mercy-vehicles/client/try-flip-vehicle',
                EventParams = {},
                Enabled = function(Entity)
                    local EntityRoll = GetEntityRoll(Entity)
                    if GetBoneDistanceFromVehicle(2, "bodyshell") < 1.25 and (EntityRoll > 75.0 or EntityRoll < -75.0) then
                        return true
                    else
                        return false
                    end
                end,
            },
        }
    },
    ['watercraft'] = {
        Type = 'Default',
        SpriteDistance = 0.0,
        State = false,
        Options = {
            {
                Name = 'anchor-down',
                Label = 'Lower Anchor',
                Icon = 'fas fa-anchor',
                EventType = 'Client',
                EventName = 'mercy-items/client/use-anchor-lower',
                EventParams = {},
                Enabled = function(Entity)
                    return exports['mercy-items']:CanDropAnchor()
                end,
            },
            {
                Name = 'anchor-up',
                Label = 'Raise Anchor',
                Icon = 'fas fa-anchor',
                EventType = 'Client',
                EventName = 'mercy-items/client/use-anchor-raise',
                EventParams = {},
                Enabled = function(Entity)
                    return exports['mercy-items']:CanTiltAnchor()
                end,
            },

        }
    },
    ['aircraft'] = {
        Type = 'Default',
        SpriteDistance = 0.0,
        State = false,
        Options = {
            {
                Name = 'refuel_option',
                Label = 'Refuel Vehicle',
                Icon = 'fas fa-gas-pump',
                EventType = 'Server',
                EventName = 'mercy-vehicles/server/refuel-helicopter',
                EventParams = {},
                Enabled = function(Entity)
                    return exports['mercy-vehicles']:CanRefuelAircraft(Entity)
                end,
            },
        }
    },
    ['train'] = {
        Type = 'Default',
        SpriteDistance = 0.0,
        State = false,
        Options = {}
    },
    ['ped'] = {
        Type = 'Default',
        SpriteDistance = 0.0,
        State = false,
        Options = {
            {
                Name = 'rob_player',
                Label = 'Steal',
                Icon = 'fas fa-sign-language',
                EventType = 'Client',
                EventName = 'mercy-police/client/search-closest',
                EventParams = {},
                Enabled = function(Entity)
                    local ClosestPlayer = PlayerModule.GetClosestPlayer(nil, 2.0)
                    if ClosestPlayer['ClosestPlayerPed'] == -1 and ClosestPlayer['ClosestServer'] == -1 then return false end
                    if IsPedInAnyVehicle(ClosestPlayer['ClosestPlayerPed']) and IsPedInAnyVehicle(PlayerPedId()) then return false end
                    
                    if IsEntityPlayingAnim(ClosestPlayer['ClosestPlayerPed'], "missminuteman_1ig_2", "handsup_base", 3) or IsEntityPlayingAnim(ClosestPlayer['ClosestPlayerPed'], "mp_arresting", "idle", 3) or exports['mercy-hospital']:IsTargetDead(ClosestPlayer['ClosestServer']) then
                        return true 
                    end
                    return false
                end,
            },
        }
    }
}

-- Hud
Config.HudValues = {
    ['Voice'] = {
        ['Show'] = true,
        ['Active'] = false,
        ['Value'] = 66.0
    },
    ['Health'] = {
        ['Show'] = true,
        ['Value'] = 50.0
    },
    ['Armor'] = {
        ['Show'] = true,
        ['Value'] = 50.0
    },
    ['Food'] = {
        ['Show'] = true,
        ['Value'] = 50.0
    },
    ['Water'] = {
        ['Show'] = true,
        ['Value'] = 50.0
    },
    ['Stress'] = {
        ['Show'] = true,
        ['Value'] = 50.0
    },
    ['Oxy'] = {
        ['Show'] = false,
        ['Value'] = 50.0
    },
    ['Nos'] = {
        ['Value'] = 50.0
    },
    ['Timer'] = {
        ['Show'] = false,
        ['Value'] = 50.0
    },
    ['FireMode'] = {
        ['Show'] = false,
        ['Value'] = 'Full-Auto'
    },
    ['PursuitMode'] = {
        ['Show'] = false,
        ['Value'] = 'B'
    },
    ['DriftMode'] = {
        ['Show'] = false,
        ['Value'] = 100.0
    },
    ['DevMode'] = {
        ['Show'] = false,
        ['Value'] = 100.0
    },
}

-- Spawn

Config.Cam = nil
Config.Object = nil

Config.BlockedCoords = {
    {
        pos = vector3(2800.0, -3800.0, 100.0), -- arena wars
        radius = 300.0
    }
}

Config.Locations = {
    {
        Id = "mrpd",
        Name = 'Mission Row PD',
        Icon = 'fas fa-map-marker-alt',
        Coords = { X = 477.96, Y = -976.13, Z = 27.98 },
        Type = 'Location',
        Hidden = false,
    },
    {
        Id = "motelparking",
        Name = 'Motel Parking',
        Icon = 'fas fa-map-marker-alt',
        Coords = { X = 275.52, Y = -354.1, Z = 44.98 },
        Type = 'Location',
        Hidden = false,
    },
    {
        Id = "sandyshores",
        Name = 'Sandy Shores',
        Icon = 'fas fa-map-marker-alt',
        Coords = { X = 1858.02, Y = 3678.94, Z = 33.73 },
        Type = 'Location',
        Hidden = false,
    },
    {
        Id = "paletobay",
        Name = 'Paleto Bay',
        Icon = 'fas fa-map-marker-alt',
        Coords = { X = -437.11, Y = 6022.6, Z = 31.49 },
        Type = 'Location',
        Hidden = false,
    },
    {
        Id = "airport",
        Name = 'Airport',
        Icon = 'fas fa-map-marker-alt',
        Coords = { X = -1037.67, Y = -2737.61, Z = 20.16 },
        Type = 'Location',
        Hidden = false,
    },
    {
        Id = "bolingbroke_penitentiary",
        Name = 'Bolingbroke Penitentiary',
        Icon = 'fas fa-voicemail',
        Coords = { X = 1845.903, Y = 2585.873, Z = 45.672 },
        Type = 'Jail',
        Hidden = true,
    },
    {
        Id = "last_location",
        Name = 'Last Location',
    },
}

-- Characters

Config.CustomSkins = {
    ['ig_mike'] = true,
    ['ig_oldman'] = true,
    ['small_men'] = true,
    ['ig_rich'] = true,
    ['ig_fat'] = true,
    ['ig_ghostface'] = true,
    ['ig_jason'] = true,
    ['ig_meyers'] = true,
    ['ig_freddy'] = true,
}

-- Preferences
Config.MyPreferences = {}
Config.DefaultPreferences = {
    Hud = {
        ['ShowHealth'] = true, -- NEW
        ['HealthValue'] = 95, -- NEW
        ['ShowArmor'] = true, -- NEW
        ['ArmorValue'] = 95, -- NEW
        ['ShowFood'] = true, -- NEW
        ['FoodValue'] = 95, -- NEW
        ['ShowWater'] = true, -- NEW
        ['WaterValue'] = 95, -- NEW
        ['ShowStress'] = true,
        ['ShowOxygen'] = true,

        ['MinimapOutline'] = true,
        ['WaypointDistance'] = true, -- NEW
        ['Compass'] = true, -- NEW
        ['Crosshair'] = true, -- NEW
        ['Blackbars'] = {
            Enabled = false,
            Percentage = 10,
        },
    },
    Phone = {
        ['Brand'] = 'Android', -- NEW
        ['Background'] = 'https://i.imgur.com/n63X1mU.jpg',
        ['Notifications'] = {
            ['SMS'] = true,
            ['Tweet'] = true,
            ['Email'] = true,
        },
        ['EmbeddedImages'] = true, -- NEW
    },
    Voice = {
        ['RadioClicksOut'] = true, -- NEW
        ['RadioClicksIn'] = true, -- NEW
        ['PhoneVolume'] = 100.0,
        ['RadioVolume'] = 100.0,
        ['RadioClickVolume'] = 100.0,
    },
    EmoteBinds = {
        ['F2'] = '',
        ['F3'] = '',
        ['F5'] = '',
        ['F6'] = '',
        ['F7'] = '',
        ['F9'] = '',
        ['F10'] = '',
        ['F11'] = '',
    },
}

-- Police Alerts
Config.AlertBlip = {
    ['EMS Down'] = 429,
    ['Officer Down'] = 429,
    ['Injured Person'] = 621,
    ['Illegal Hunting'] = 141,
    ['Fight In Progress'] = 311,
    ['Deadly Fight In Progress'] = 154,
    ['Gun Shots Reported From Vehicle'] = 229,
    ['Gun Shots Reported'] = 313,
    ['Tracker Device Manipulation'] = 620,
    ['Store Alarm'] = 59,
    ['Banktruck Alarm'] = 67,
    ['911 Call'] = 47,
    ['Explosion Alert'] = 486,
    ['Robbery At The Fleeca Bank'] = 108,
    ['Investigate Suspicious Activity'] = 66,
    ['Robbery At Bobcat Security'] = 106,
    ['Robbery At The Jewelery Store'] = 617,
    ['Car Theft In Progress'] = 620,
    ['Breaking and entering'] = 40,
    ['Bank Monitor'] = 606,
}

Config.Sounds = {
    'dialing',
    '10-1314',
    'HighPrioCrime',
    'ringing',
    'unlock',
    'lock',
}

Config.VehicleOperatingTypes = {
    ['Car'] = true, -- True = active
    ['Motorbike'] = false,
    ['Bicycle'] = false,
    ['Boat'] = false,
    ['Helicopter'] = false,
}

-- Media

Config.Songs = {
    {
        ['Id'] = 0,
        ['Name'] = 'Leebroman - Dreamathon'
    },
    {
        ['Id'] = 1,
        ['Name'] = 'Saint Punk - Empty Bed'
    },
    {
        ['Id'] = 2,
        ['Name'] = 'Acraze -  Do It To It'
    },
    {
        ['Id'] = 3,
        ['Name'] = 'Benny Benassi -  Satisfaction'
    },
    {
        ['Id'] = 4,
        ['Name'] = 'Sunnery James - Love, Dance & Feel'
    },
    {
        ['Id'] = 5,
        ['Name'] = 'Kungs - Never Going Home'
    },
    {
        ['Id'] = 6,
        ['Name'] = 'D-Devils - The 6th Gate'
    },
    {
        ['Id'] = 7,
        ['Name'] = 'Dj. Yo! - Love Nwantiti'
    },
    {
        ['Id'] = 8,
        ['Name'] = 'SHOUSE - Love Tonight'
    },
    {
        ['Id'] = 9,
        ['Name'] = 'Riton x Oliver Heldens - Turn Me On'
    },
    {
        ['Id'] = 10,
        ['Name'] = 'Dombresky - Soul Sacrifice'
    },
    {
        ['Id'] = 11,
        ['Name'] = 'Lewis Capaldi - Forget Me'
    },
    {
        ['Id'] = 12,
        ['Name'] = 'Vogeljongen - Fortnite Fan'
    },
    {
        ['Id'] = 13,
        ['Name'] = 'Leviathan - Chug Jug With You'
    },
}