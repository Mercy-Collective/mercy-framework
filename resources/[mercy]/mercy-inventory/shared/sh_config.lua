Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

Config = Config or {}

Config.Drops = {}
Config.InventorySlots = 44
Config.InventoryBusy = false
Config.InventoryOpen = false
Config.IsCrafting = false
Config.MaxInventoryWeight = 250.0

Config.Containers = {
    [GetHashKey("prop_cs_dumpster_01a")] = true,
    [GetHashKey("p_dumpster_t")] = true,
    [GetHashKey("prop_dumpster_01a")] = true,
    [GetHashKey("prop_dumpster_02a")] = true,
    [GetHashKey("prop_dumpster_02b")] = true,
    [GetHashKey("prop_dumpster_3a")] = true,
    [GetHashKey("prop_dumpster_4a")] = true,
    [GetHashKey("prop_dumpster_4b")] = true,
    -- Jail
    [GetHashKey('prop_elecbox_09')] = true,
    [GetHashKey('prop_elecbox_10')] = true,
    [GetHashKey('prop_elecbox_01b')] = true,
}

Config.TrunkSpaces = {
    [0]  = { 1.0,  50,  150 }, -- Compacts
    [1]  = { 2.0,  150, 300 }, -- Sedans
    [2]  = { 5.0,  200, 500 }, -- SUVs
    [3]  = { 3.0,  100, 250 }, -- Coupes
    [4]  = { 3.0,  100, 250 }, -- Muscle
    [5]  = { 1.0,  150, 200 }, -- Sports Classics
    [6]  = { 1.0,  150, 200 }, -- Sports
    [7]  = { 1.0,  75,  200 }, -- Super
    [8]  = { 0.0,  0,   0 }, -- Motorcycles
    [9]  = { 1.0,  100, 300 }, -- Off-road
    [10] = { 4.0,  300, 1000 }, -- Industrial
    [11] = { 5.0,  250, 1000 }, -- Utility
    [12] = { 5.0,  250, 1000 }, -- Vans
    [13] = { 0.0,  0,   0 }, -- Cycles
    [14] = { 2.0,  100, 300 }, -- Boats
    [15] = { 1.0,  100, 400 }, -- Helicopters
    [16] = { 5.0,  100, 4000 }, -- Planes
    [17] = { 10.0, 100, 1200 }, -- Service
    [18] = { 2.0,  200,  500 }, -- Emergency
    [19] = { 5.0,  200,  500 }, -- Military
    [20] = { 20.0, 250, 2000 }, -- Commerical
    [21] = { 10.0, 200, 500 }, -- Trains
}

Config.BackEngine = {
    [GetHashKey("ninef")] = true,
    [GetHashKey("adder")] = true,
    [GetHashKey("vagner")] = true,
    [GetHashKey("t20")] = true,
    [GetHashKey("infernus")] = true,
    [GetHashKey("zentorno")] = true,
    [GetHashKey("reaper")] = true,
    [GetHashKey("comet2")] = true,
    [GetHashKey("comet3")] = true,
    [GetHashKey("jester")] = true,
    [GetHashKey("jester2")] = true,
    [GetHashKey("cheetah")] = true,
    [GetHashKey("cheetah2")] = true,
    [GetHashKey("prototipo")] = true,
    [GetHashKey("turismor")] = true,
    [GetHashKey("pfister811")] = true,
    [GetHashKey("ardent")] = true,
    [GetHashKey("nero")] = true,
    [GetHashKey("nero2")] = true,
    [GetHashKey("tempesta")] = true,
    [GetHashKey("vacca")] = true,
    [GetHashKey("bullet")] = true,
    [GetHashKey("osiris")] = true,
    [GetHashKey("entityxf")] = true,
    [GetHashKey("turismo2")] = true,
    [GetHashKey("fmj")] = true,
    [GetHashKey("re7b")] = true,
    [GetHashKey("tyrus")] = true,
    [GetHashKey("italigtb")] = true,
    [GetHashKey("penetrator")] = true,
    [GetHashKey("monroe")] = true,
    [GetHashKey("ninef2")] = true,
    [GetHashKey("stingergt")] = true,
    [GetHashKey("surfer")] = true,
    [GetHashKey("surfer2")] = true,
    [GetHashKey("gp1")] = true,
    [GetHashKey("autarch")] = true,
    [GetHashKey("tyrant")] = true
}

Config.Throwables = {
    ["weapon_stickybomb"] = true,
    ["weapon_molotov"] = true,
    ["weapon_brick"] = true,
    ["weapon_flare"] = true,
    ["weapon_grenade"] = true,
    ["weapon_smokegrenade"] = true,
    ["weapon_shoe"] = true,
}

Config.Attachments = {
    ['pistol_extendedclip'] = {
        ['weapon_vintagepistol'] = 'COMPONENT_VINTAGEPISTOL_CLIP_02',
        ['weapon_pistol'] = 'COMPONENT_PISTOL_CLIP_02',
        ['weapon_combatpistol'] = 'COMPONENT_COMBATPISTOL_CLIP_02',
        ['weapon_browning'] = 'COMPONENT_BROWNING_CLIP_02',
    },
    ['smg_extendedclip'] = {
        ['weapon_appistol'] = 'COMPONENT_APPISTOL_CLIP_02',
        ['weapon_machinepistol'] = 'COMPONENT_MACHINEPISTOL_CLIP_02',
        ['weapon_microsmg'] = 'COMPONENT_MICROSMG_CLIP_02',
    },
    ['silencer_oilcan'] = {
        ['weapon_m70'] = 'COMPONENT_OIL_SUPP',
        ['weapon_colt'] = 'COMPONENT_OIL_SUPP',
        ['weapon_beretta'] = 'COMPONENT_OIL_SUPP',
        ['weapon_glock18c'] = 'COMPONENT_OIL_SUPP',
        ['weapon_heavypistol'] = 'COMPONENT_OIL_SUPP',
    },
}