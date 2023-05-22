Config = Config or {}

Config.Syncing, Config.Frozen = true, false

Config.BlackoutTimeout = 10

Config.SyncData = {
    ['Hour'] = 23,
    ['Minutes'] = 00,
    ['Weather'] = 'CLEARING',
    ['Blackout'] = false
}

Config.WeatherTypes = {
    [1] = {['Weather'] = 'EXTRASUNNY',  ['Label'] = 'Extra Sunny',  ['AllowRandom'] = true,  ['MaxTime'] = 8},
    [2] = {['Weather'] = 'NEUTRAL',     ['Label'] = 'Neutral',      ['AllowRandom'] = false},
    [3] = {['Weather'] = 'SMOG',        ['Label'] = 'Smog',         ['AllowRandom'] = false},
    [4] = {['Weather'] = 'FOGGY',       ['Label'] = 'Extra Foggy',  ['AllowRandom'] = true, ['MaxTime'] = 1},
    [5] = {['Weather'] = 'CLEARING',    ['Label'] = 'Clearing',     ['AllowRandom'] = false},
    [6] = {['Weather'] = 'RAIN',        ['Label'] = 'Rain',         ['AllowRandom'] = true,  ['MaxTime'] = 1},
    [7] = {['Weather'] = 'THUNDER',     ['Label'] = 'Thunder',      ['AllowRandom'] = true,  ['MaxTime'] = 1},
    [8] = {['Weather'] = 'SNOW',        ['Label'] = 'Snow',         ['AllowRandom'] = false},
    [9] = {['Weather'] = 'XMAS',        ['Label'] = 'Xmas',         ['AllowRandom'] = false},
    [10] = {['Weather'] = 'HALLOWEEN',  ['Label'] = 'Halloween',    ['AllowRandom'] = false},
}