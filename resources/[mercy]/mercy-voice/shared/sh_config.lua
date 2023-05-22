Config = Config or {}

Config.Debug = false -- Only when voice is broken use this
Config.VoiceEnabled = false
Config.EnvironmentEffects = false

Config.EnableGrids = true
Config.GridSize = 384
Config.GridEdge = 192
Config.GridMinX = -4600
Config.GridMaxX = 4600
Config.GridMaxY = 9200

Config.EnableSubmixes = true
Config.EnableMegaphone = true
Config.EnablePodium = true
Config.EnableRadio = true
Config.EnablePhone = true
Config.EnableGag = true

Config.VoiceRanges = {
    {['Name'] = "Whisper", ['Range'] = 1.5},
    {['Name'] = "Normal",  ['Range'] = 3.0},
    {['Name'] = "Shout",   ['Range'] = 7.5}
}

Config.RadioVoiceRanges = {
    ['Radio-Medium'] = {
        ['Ranges'] = {
            ['Min'] = 900,
            ['Max'] = 1300.0
        }
    },
    ['Radio-Far'] = {
        ['Ranges'] = {
            ['Min'] = 1300.0,
            ['Max'] = 1700.0
        }
    }
}