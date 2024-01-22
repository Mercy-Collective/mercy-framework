-- Emergency Lights
--[[
    Airhorn
    AIRHORN_EQD - Generic Bullhorn               SirenSound - SIRENS_AIRHORN

    Police Bike
    SIREN_WAIL_03 - PoliceB Main                 SirenSound - RESIDENT_VEHICLES_SIREN_WAIL_03
    SIREN_QUICK_03 - PoliceB Secondary           SirenSound - RESIDENT_VEHICLES_SIREN_QUICK_03

    FIB
    SIREN_WAIL_02 - FIB Primary                  SirenSound - RESIDENT_VEHICLES_SIREN_WAIL_02
    SIREN_QUICK_02 - FIB Secondary               SirenSound - RESIDENT_VEHICLES_SIREN_QUICK_02

    Police
    SIREN_PA20A_WAIL - Police Primary            SirenSound - VEHICLES_HORNS_SIREN_1
    SIREN_2 - Police Secondary                   SirenSound - VEHICLES_HORNS_SIREN_2
    POLICE_WARNING     - Police Warning          SirenSound - VEHICLES_HORNS_POLICE_WARNING

    Ambulance
    SIREN_WAIL_01 - Ambulance Primary            SirenSound - RESIDENT_VEHICLES_SIREN_WAIL_01
    SIREN_QUICK_01 - Ambulance Secondary         SirenSound - RESIDENT_VEHICLES_SIREN_QUICK_01
    AMBULANCE_WARNING - Ambulance Warning        SirenSound - VEHICLES_HORNS_AMBULANCE_WARNING

    Fire Trucks
    FIRE_TRUCK_HORN - Fire Horn                  SirenSound - VEHICLES_HORNS_FIRETRUCK_WARNING
    SIREN_FIRETRUCK_WAIL_01 - Fire Primary       SirenSound - RESIDENT_VEHICLES_SIREN_FIRETRUCK_WAIL_01
    SIREN_FIRETRUCK_QUICK_01 - Fire Secondary    SirenSound - RESIDENT_VEHICLES_SIREN_FIRETRUCK_QUICK_01
]]

Config.CustomHorns = {
    ['firetruk'] = 'VEHICLES_HORNS_FIRETRUCK_WARNING',
}

Config.SirenData = {
    [GetHashKey("polvic")] = {
        SirenSounds = { "VEHICLES_HORNS_SIREN_1", "VEHICLES_HORNS_SIREN_2", "VEHICLES_HORNS_POLICE_WARNING" },
    },
    [GetHashKey("polchal")] = {
        SirenSounds = { "VEHICLES_HORNS_SIREN_1", "VEHICLES_HORNS_SIREN_2", "VEHICLES_HORNS_POLICE_WARNING" },
    },
    [GetHashKey("polstang")] = {
        SirenSounds = { "VEHICLES_HORNS_SIREN_1", "VEHICLES_HORNS_SIREN_2", "VEHICLES_HORNS_POLICE_WARNING" },
    },
    [GetHashKey("polvette")] = {
        SirenSounds = { "VEHICLES_HORNS_SIREN_1", "VEHICLES_HORNS_SIREN_2", "VEHICLES_HORNS_POLICE_WARNING" },
    },
    [GetHashKey("poltaurus")] = {
        SirenSounds = { "VEHICLES_HORNS_SIREN_1", "VEHICLES_HORNS_SIREN_2", "VEHICLES_HORNS_POLICE_WARNING" },
    },
    [GetHashKey("polexp")] = {
        SirenSounds = { "VEHICLES_HORNS_SIREN_1", "VEHICLES_HORNS_SIREN_2", "VEHICLES_HORNS_POLICE_WARNING" },
    },
    [GetHashKey("polchar")] = {
        SirenSounds = { "VEHICLES_HORNS_SIREN_1", "VEHICLES_HORNS_SIREN_2", "VEHICLES_HORNS_POLICE_WARNING" },
    },
    [GetHashKey("polblazer")] = {
        SirenSounds = { "VEHICLES_HORNS_SIREN_1", "VEHICLES_HORNS_SIREN_2", "VEHICLES_HORNS_POLICE_WARNING" },
    },
    [GetHashKey("polmotor")] = {
        SirenSounds = { "RESIDENT_VEHICLES_SIREN_WAIL_03", "RESIDENT_VEHICLES_SIREN_QUICK_03" },
    },
    [GetHashKey("policeb")] = {
        SirenSounds = { "RESIDENT_VEHICLES_SIREN_WAIL_03", "RESIDENT_VEHICLES_SIREN_QUICK_03" },
    },
    [GetHashKey("ucbanshee")] = {
        SirenSounds = { "VEHICLES_HORNS_SIREN_1", "VEHICLES_HORNS_SIREN_2", "VEHICLES_HORNS_POLICE_WARNING" },
    },
    [GetHashKey("ucrancher")] = {
        SirenSounds = { "VEHICLES_HORNS_SIREN_1", "VEHICLES_HORNS_SIREN_2", "VEHICLES_HORNS_POLICE_WARNING" },
    },
    [GetHashKey("ucbuffalo")] = {
        SirenSounds = { "VEHICLES_HORNS_SIREN_1", "VEHICLES_HORNS_SIREN_2", "VEHICLES_HORNS_POLICE_WARNING" },
    },
    [GetHashKey("ucballer")] = {
        SirenSounds = { "VEHICLES_HORNS_SIREN_1", "VEHICLES_HORNS_SIREN_2", "VEHICLES_HORNS_POLICE_WARNING" },
    },
    [GetHashKey("emsspeedo")] = {
        SirenSounds = { "RESIDENT_VEHICLES_SIREN_WAIL_01", "RESIDENT_VEHICLES_SIREN_QUICK_01", "VEHICLES_HORNS_AMBULANCE_WARNING" },
    },
    [GetHashKey("emsexp")] = {
        SirenSounds = { "RESIDENT_VEHICLES_SIREN_WAIL_01", "RESIDENT_VEHICLES_SIREN_QUICK_01", "VEHICLES_HORNS_AMBULANCE_WARNING" },
    },
    [GetHashKey("emstau")] = {
        SirenSounds = { "RESIDENT_VEHICLES_SIREN_WAIL_01", "RESIDENT_VEHICLES_SIREN_QUICK_01", "VEHICLES_HORNS_AMBULANCE_WARNING" },
    },
    [GetHashKey("emsbike")] = {
        SirenSounds = { "RESIDENT_VEHICLES_SIREN_WAIL_03", "RESIDENT_VEHICLES_SIREN_QUICK_03" },
    },
}