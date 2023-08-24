Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

Config = Config or {}

Config.Casino = {
    ['Rent'] = 750,
}
Config.WheelURL = "http://localhost/Mercy-CasinoWheelUI/" -- URL where you host the wheel here.
Config.TVImage = "https://i.imgur.com/yUoVJ5M.png" -- Image for TV
Config.Debug = true

Config.CasinoLocations = {
    ['Wheel'] = vector4(975.5, 40.41, 72.16 + 0.05, 0.0),
    ['AUXWheel'] = vector4(1007.23, 46.5, 70.47 + 0.05, 197.13),
}

Config.Locations = {
    {
        ['Name'] = 'casino_entrance',
        ['Coords'] = vector4(930.0, 43.48, 81.1, 328),
        ['Length'] = 12.2,
        ['Width'] = 10.0,
        ['MinHeight'] = 79.9,
        ['MaxHeight'] = 83.9,
    },
    {
        ['Name'] = 'casino_exit',
        ['Coords'] = vector4(921.06, 48.99, 81.1, 328),
        ['Length'] = 10.8,
        ['Width'] = 10,
        ['MinHeight'] = 79.7,
        ['MaxHeight'] = 83.7,
    },
    {
        ['Name'] = 'casino_post_gate',
        ['Coords'] = vector4(1122.36, 240.28, -50.44, 42),
        ['Length'] = 10.8,
        ['Width'] = 5,
        ['MinHeight'] = -51.44,
        ['MaxHeight'] = -49.04,
    },
    {
        ['Name'] = 'casino_betting_screen',
        ['Coords'] = vector4(1100.96, 256.81, -51.24, 306),
        ['Length'] = 20,
        ['Width'] = 25.6,
        ['MinHeight'] = -52.04,
        ['MaxHeight'] = -48.04,
    },
    {
        ['Name'] = 'casino_laptop',
        ['Coords'] = vector4(964.89, 47.08, 71.7, 329),
        ['Length'] = 0.4,
        ['Width'] = 1.4,
        ['MinHeight'] = 71.6,
        ['MaxHeight'] = 72.0,
    },
}

Config.Rooms = {
    { ['Name'] = '501', ['Coords'] = vector4(924.66, -57.49, 21.00, 330.0), ['Length'] = 1.2, ['Width'] = 4.0, ['MinHeight'] = 20.0, ['MaxHeight'] = 22.4, },
    { ['Name'] = '502', ['Coords'] = vector4(927.27, -53.23, 21.00, 330.0), ['Length'] = 1.0, ['Width'] = 4.4, ['MinHeight'] = 20.0, ['MaxHeight'] = 22.4, },
    { ['Name'] = '503', ['Coords'] = vector4(930.33, -48.83, 21.00, 330.0), ['Length'] = 1.4, ['Width'] = 4.2, ['MinHeight'] = 20.0, ['MaxHeight'] = 22.4, },
    { ['Name'] = '504', ['Coords'] = vector4(929.79, -33.48, 21.89, 240.0), ['Length'] = 1.4, ['Width'] = 4.2, ['MinHeight'] = 20.0, ['MaxHeight'] = 22.4, },
    { ['Name'] = '505', ['Coords'] = vector4(925.46, -30.48, 21.00, 240.0), ['Length'] = 1.4, ['Width'] = 4.2, ['MinHeight'] = 20.0, ['MaxHeight'] = 22.4, },
    { ['Name'] = '506', ['Coords'] = vector4(921.16, -27.46, 21.00, 240.0), ['Length'] = 1.4, ['Width'] = 4.2, ['MinHeight'] = 20.0, ['MaxHeight'] = 22.4, },
    { ['Name'] = '507', ['Coords'] = vector4(905.48, -28.55, 21.32, 330.0), ['Length'] = 1.4, ['Width'] = 4.2, ['MinHeight'] = 20.0, ['MaxHeight'] = 22.4, },
    { ['Name'] = '508', ['Coords'] = vector4(902.82, -32.95, 21.34, 330.0), ['Length'] = 1.4, ['Width'] = 4.2, ['MinHeight'] = 20.0, ['MaxHeight'] = 22.4, },
    { ['Name'] = '509', ['Coords'] = vector4(899.84, -37.19, 21.00, 330.0), ['Length'] = 1.4, ['Width'] = 4.2, ['MinHeight'] = 20.0, ['MaxHeight'] = 22.4, },
    { ['Name'] = '510', ['Coords'] = vector4(878.53, -42.50, 21.43, 330.0), ['Length'] = 1.2, ['Width'] = 4.2, ['MinHeight'] = 20.0, ['MaxHeight'] = 22.4, },
    { ['Name'] = '511', ['Coords'] = vector4(875.84, -47.08, 21.30, 330.0), ['Length'] = 1.4, ['Width'] = 4.2, ['MinHeight'] = 20.0, ['MaxHeight'] = 22.4, },
    { ['Name'] = '512', ['Coords'] = vector4(872.95, -51.38, 21.11, 330.0), ['Length'] = 1.4, ['Width'] = 4.2, ['MinHeight'] = 20.0, ['MaxHeight'] = 22.4, },
    { ['Name'] = '513', ['Coords'] = vector4(870.34, -55.83, 21.52, 330.0), ['Length'] = 1.4, ['Width'] = 4.2, ['MinHeight'] = 20.0, ['MaxHeight'] = 22.4, },
    { ['Name'] = '514', ['Coords'] = vector4(867.49, -60.28, 21.00, 330.0), ['Length'] = 1.4, ['Width'] = 4.2, ['MinHeight'] = 20.0, ['MaxHeight'] = 22.4, },
    { ['Name'] = '515', ['Coords'] = vector4(868.32, -75.09, 21.00, 55.00), ['Length'] = 1.4, ['Width'] = 4.2, ['MinHeight'] = 20.0, ['MaxHeight'] = 22.4, },
    { ['Name'] = '516', ['Coords'] = vector4(872.73, -77.84, 21.00, 55.00), ['Length'] = 1.4, ['Width'] = 4.2, ['MinHeight'] = 20.0, ['MaxHeight'] = 22.4, },
    { ['Name'] = '517', ['Coords'] = vector4(877.11, -80.63, 21.00, 55.00), ['Length'] = 1.4, ['Width'] = 4.2, ['MinHeight'] = 20.0, ['MaxHeight'] = 22.4, },
    { ['Name'] = '518', ['Coords'] = vector4(881.39, -83.62, 21.00, 55.00), ['Length'] = 1.4, ['Width'] = 4.2, ['MinHeight'] = 20.0, ['MaxHeight'] = 22.4, },
    { ['Name'] = '519', ['Coords'] = vector4(885.84, -86.39, 21.00, 55.00), ['Length'] = 1.4, ['Width'] = 4.2, ['MinHeight'] = 20.0, ['MaxHeight'] = 22.4, },
    { ['Name'] = '520', ['Coords'] = vector4(890.12, -89.30, 21.00, 55.00), ['Length'] = 1.4, ['Width'] = 4.2, ['MinHeight'] = 20.0, ['MaxHeight'] = 22.4, },
    { ['Name'] = '521', ['Coords'] = vector4(905.23, -88.54, 21.00, 330.0), ['Length'] = 1.4, ['Width'] = 4.2, ['MinHeight'] = 20.0, ['MaxHeight'] = 22.4, },
    { ['Name'] = '522', ['Coords'] = vector4(908.11, -84.18, 21.00, 330.0), ['Length'] = 1.4, ['Width'] = 4.2, ['MinHeight'] = 20.0, ['MaxHeight'] = 22.4, },
    { ['Name'] = '523', ['Coords'] = vector4(910.89, -79.64, 21.00, 330.0), ['Length'] = 1.4, ['Width'] = 4.2, ['MinHeight'] = 20.0, ['MaxHeight'] = 22.4, },
    { ['Name'] = '524', ['Coords'] = vector4(913.87, -75.70, 21.00, 330.0), ['Length'] = 1.6, ['Width'] = 4.4, ['MinHeight'] = 20.0, ['MaxHeight'] = 22.4, },
}

Config.WheelSlots = { -- Needs to be 23 rewards

}

Config.Options = {
    ['Wheel'] = {
        ['Types'] = {
            ['Normal'] = { ['Id'] = 1, ['Amount'] = 500,   ['SpinAmount'] = 1,  ['Speed'] = 10,  ['Time'] = 10500, },
            ['Turbo']  = { ['Id'] = 2, ['Amount'] = 5000,  ['SpinAmount'] = 5,  ['Speed'] = 3,   ['Time'] = 3300, },
            ['Omega']  = { ['Id'] = 3, ['Amount'] = 20000, ['SpinAmount'] = 40, ['Speed'] = 0.5, ['Time'] = 700, },
        },
        ['Slots'] = {
            { ['Id'] = 0,  ['Type'] = 'Money', ['Amount'] = "0",    ['Colour'] = "#000", },
            { ['Id'] = 1,  ['Type'] = 'Money', ['Amount'] = "500",  ['Colour'] = "#F2ED52", },
            { ['Id'] = 2,  ['Type'] = 'Money', ['Amount'] = "0",    ['Colour'] = "#000", },
            { ['Id'] = 3,  ['Type'] = 'Money', ['Amount'] = "1000", ['Colour'] = "#526FF2", },
            { ['Id'] = 4,  ['Type'] = 'Money', ['Amount'] = "0",    ['Colour'] = "#000", },
            { ['Id'] = 5,  ['Type'] = 'Money', ['Amount'] = "500",  ['Colour'] = "#F2ED52", },
            { ['Id'] = 6,  ['Type'] = 'Money', ['Amount'] = "0",    ['Colour'] = "#000", }, 
            { ['Id'] = 7,  ['Type'] = 'Money', ['Amount'] = "1000", ['Colour'] = "#526FF2", },
            { ['Id'] = 8,  ['Type'] = 'Money', ['Amount'] = "0",    ['Colour'] = "#000", },
            { ['Id'] = 9,  ['Type'] = 'Money', ['Amount'] = "500",  ['Colour'] = "#F2ED52", },
            { ['Id'] = 10, ['Type'] = 'Money', ['Amount'] = "0",    ['Colour'] = "#000", },
            { ['Id'] = 11, ['Type'] = 'Money', ['Amount'] = "500",  ['Colour'] = "#F2ED52", },
            { ['Id'] = 12, ['Type'] = 'Money', ['Amount'] = "0",    ['Colour'] = "#000", },
            { ['Id'] = 13, ['Type'] = 'Money', ['Amount'] = "500",  ['Colour'] = "#F2ED52", },
            { ['Id'] = 14, ['Type'] = 'Money', ['Amount'] = "0",    ['Colour'] = "#000", },
            { ['Id'] = 15, ['Type'] = 'Money', ['Amount'] = "1500", ['Colour'] = "#E852F2", },
            { ['Id'] = 16, ['Type'] = 'Money', ['Amount'] = "0",    ['Colour'] = "#000", },
            { ['Id'] = 17, ['Type'] = 'Money', ['Amount'] = "500",  ['Colour'] = "#F2ED52", },
            { ['Id'] = 18, ['Type'] = 'Money', ['Amount'] = "0",    ['Colour'] = "#000", },
            { ['Id'] = 19, ['Type'] = 'Money', ['Amount'] = "1500", ['Colour'] = "#E852F2", },
            { ['Id'] = 20, ['Type'] = 'Money', ['Amount'] = "0",    ['Colour'] = "#000", },
            { ['Id'] = 21, ['Type'] = 'Money', ['Amount'] = "500",  ['Colour'] = "#F2ED52", },
            { ['Id'] = 22, ['Type'] = 'Money', ['Amount'] = "0",    ['Colour'] = "#000", },
            { ['Id'] = 23, ['Type'] = 'Vehicle', ['Model'] = 'sultanrs', ['Colour'] = "#FF0221", },
        }
    },
    ['Slots'] = {
        ['Multiplier'] = {
            ['1'] = 5, ['2'] = 10, ['3'] = 15, ['4'] = 20, ['5'] = 25, ['6'] = 30, ['7'] = 35,
        },
        ['Wins'] = {
            [1] = '2', [2] = '3', [3] = '6', [4] = '2', [5] = '4', [6] = '1', [7] = '6', [8] = '5',
            [9] = '2', [10] = '1', [11] = '3', [12] = '6', [13] = '7', [14] = '1', [15] = '4', [16] = '5',
        },
        ['Bets'] = {
            ['vw_prop_casino_slot_01a'] = { Amount = 500,  PropA = 'vw_prop_casino_slot_01a_reels', PropB = 'vw_prop_casino_slot_01b_reels', },
            ['vw_prop_casino_slot_02a'] = { Amount = 1000, PropA = 'vw_prop_casino_slot_02a_reels', PropB = 'vw_prop_casino_slot_02b_reels', },
            ['vw_prop_casino_slot_03a'] = {	Amount = 2000, PropA = 'vw_prop_casino_slot_03a_reels', PropB = 'vw_prop_casino_slot_03b_reels', }, -- Shoot First
            ['vw_prop_casino_slot_04a'] = { Amount = 500,  PropA = 'vw_prop_casino_slot_04a_reels', PropB = 'vw_prop_casino_slot_04b_reels', }, -- Fame or Shame
            ['vw_prop_casino_slot_05a'] = { Amount = 1000, PropA = 'vw_prop_casino_slot_05a_reels', PropB = 'vw_prop_casino_slot_05b_reels', }, -- Fortune And Glory
            ['vw_prop_casino_slot_06a'] = { Amount = 1000, PropA = 'vw_prop_casino_slot_06a_reels', PropB = 'vw_prop_casino_slot_06b_reels', }, -- Have A Stab
            ['vw_prop_casino_slot_07a'] = { Amount = 2000, PropA = 'vw_prop_casino_slot_07a_reels', PropB = 'vw_prop_casino_slot_07b_reels', }, -- Diamonds
            ['vw_prop_casino_slot_08a'] = { Amount = 1000, PropA = 'vw_prop_casino_slot_08a_reels', PropB = 'vw_prop_casino_slot_08b_reels', },
        },
    },
    ['Poker'] = { -- No map
        ['Enabled'] = false,
        ['TimeLeftAfter'] = 15, -- Time remaining after one player betted (dealer actions start timeout)
        ['PlayerDecideTime'] = 15, -- Player decide time (when watching our cards)
        ['Locations'] = {
            [1] = {
                ['Position'] = vector3(1143.338, 264.2453, -52.8409),
                ['Heading'] = -135.0,
                ['MaximumBet'] = 2500,
                ['MinimumBet'] = 50
            },
            [2] = {
                ['Position'] = vector3(1146.329, 261.2543, -52.8409),
                ['Heading'] = 45.0,
                ['MaximumBet'] = 2500,
                ['MinimumBet'] = 50
            },
            [3] = {
                ['Position'] = vector3(1133.74, 266.6947, -52.0409),
                ['Heading'] = -45.0,
                ['MaximumBet'] = 2000,
                ['MinimumBet'] = 50
            },
            [4] = {
                ['Position'] = vector3(1148.74, 251.6947, -52.0409),
                ['Heading'] = -45.0,
                ['MaximumBet'] = 2000,
                ['MinimumBet'] = 50
            }
        },
        -- Default
        ['Cards'] = {
            [1] = 'vw_prop_vw_club_char_a_a', [2] = 'vw_prop_vw_club_char_02a', [3] = 'vw_prop_vw_club_char_03a', [4] = 'vw_prop_vw_club_char_04a',
            [5] = 'vw_prop_vw_club_char_05a', [6] = 'vw_prop_vw_club_char_06a', [7] = 'vw_prop_vw_club_char_07a', [8] = 'vw_prop_vw_club_char_08a',
            [9] = 'vw_prop_vw_club_char_09a', [10] = 'vw_prop_vw_club_char_10a', [11] = 'vw_prop_vw_club_char_j_a', [12] = 'vw_prop_vw_club_char_q_a', 
            [13] = 'vw_prop_vw_club_char_k_a', [14] = 'vw_prop_vw_dia_char_a_a', [15] = 'vw_prop_vw_dia_char_02a', [16] = 'vw_prop_vw_dia_char_03a', 
            [17] = 'vw_prop_vw_dia_char_04a', [18] = 'vw_prop_vw_dia_char_05a', [19] = 'vw_prop_vw_dia_char_06a', [20] = 'vw_prop_vw_dia_char_07a', 
            [21] = 'vw_prop_vw_dia_char_08a', [22] = 'vw_prop_vw_dia_char_09a', [23] = 'vw_prop_vw_dia_char_10a', [24] = 'vw_prop_vw_dia_char_j_a', 
            [25] = 'vw_prop_vw_dia_char_q_a', [26] = 'vw_prop_vw_dia_char_k_a', [27] = 'vw_prop_vw_hrt_char_a_a', [28] = 'vw_prop_vw_hrt_char_02a', 
            [29] = 'vw_prop_vw_hrt_char_03a', [30] = 'vw_prop_vw_hrt_char_04a', [31] = 'vw_prop_vw_hrt_char_05a', [32] = 'vw_prop_vw_hrt_char_06a', 
            [33] = 'vw_prop_vw_hrt_char_07a', [34] = 'vw_prop_vw_hrt_char_08a', [35] = 'vw_prop_vw_hrt_char_09a', [36] = 'vw_prop_vw_hrt_char_10a', 
            [37] = 'vw_prop_vw_hrt_char_j_a', [38] = 'vw_prop_vw_hrt_char_q_a', [39] = 'vw_prop_vw_hrt_char_k_a', [40] = 'vw_prop_vw_spd_char_a_a', 
            [41] = 'vw_prop_vw_spd_char_02a', [42] = 'vw_prop_vw_spd_char_03a', [43] = 'vw_prop_vw_spd_char_04a', [44] = 'vw_prop_vw_spd_char_05a', 
            [45] = 'vw_prop_vw_spd_char_06a', [46] = 'vw_prop_vw_spd_char_07a', [47] = 'vw_prop_vw_spd_char_08a', [48] = 'vw_prop_vw_spd_char_09a', 
            [49] = 'vw_prop_vw_spd_char_10a', [50] = 'vw_prop_vw_spd_char_j_a', [51] = 'vw_prop_vw_spd_char_q_a', [52] = 'vw_prop_vw_spd_char_k_a'
        },
        ['Chairs'] = { ['Chair_Base_01'] = 1, ['Chair_Base_02'] = 2, ['Chair_Base_03'] = 3, ['Chair_Base_04'] = 4 },
        ['Tables'] = { 'h4_prop_casino_3cardpoker_01a', 'h4_prop_casino_3cardpoker_01b', 'h4_prop_casino_3cardpoker_01c', 'h4_prop_casino_3cardpoker_01e', 'vw_prop_casino_3cardpoker_01b', 'vw_prop_casino_3cardpoker_01' },
        ['Anims'] = {
            ['Idle'] = {
                ['Male'] = {
                    'idle_cardgames_var_01', 'idle_cardgames_var_02', 'idle_cardgames_var_03',
                    'idle_cardgames_var_04', 'idle_cardgames_var_05', 'idle_cardgames_var_06', 'idle_cardgames_var_07', 'idle_cardgames_var_08',
                    'idle_cardgames_var_09', 'idle_cardgames_var_10', 'idle_cardgames_var_11', 'idle_cardgames_var_12', 'idle_cardgames_var_13'
                },
                ['Female'] = {
                    'female_idle_cardgames_var_01', 'female_idle_cardgames_var_02', 'female_idle_cardgames_var_03', 'female_idle_cardgames_var_04',
                    'female_idle_cardgames_var_05', 'female_idle_cardgames_var_06', 'female_idle_cardgames_var_07', 'female_idle_cardgames_var_08'
                },
            },
        },
    }
}