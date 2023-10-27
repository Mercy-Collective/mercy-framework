Config = Config or {}

-- DO NOT DELETE DOORS, SET `DISABLED` TO TRUE FOR SPECIFIC DOOR IF YOU WANT TO REMOVE IT.

Config.Doors = {
    -- Crusade Hospital
    
    {
        Info = 'CRUSADE_HOSP_DOCTOR',
        Coords = vector3(364.45, -1388.66, 32.5),
        Model = 2115166766,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {},
            -- Item = { -- ITEM EXAMPLE
            --     'hospital_key',
            -- }
        },
    },
    {
        Info = 'CRUSADE_HOSP_LUNCH_ROOM',
        Coords = vector3(355.38, -1409.74, 32.5),
        Model = 2115166766,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'CRUSADE_HOSP_OFFICE_1',
        Coords = vector3(351.99, -1401.07, 36.52),
        Model = 2115166766,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'CRUSADE_HOSP_WARD_A_01_LEFT',
        Coords = vector3(359.5, -1394.58, 36.52),
        Model = 1884112547,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = { 'CRUSADE_HOSP_WARD_A_01_RIGHT' },
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'CRUSADE_HOSP_WARD_A_01_RIGHT',
        Coords = vector3(361.21, -1392.74, 36.52),
        Model = 1884112547,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = { 'CRUSADE_HOSP_WARD_A_01_LEFT' },
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'CRUSADE_HOSP_WARD_A_02_LEFT',
        Coords = vector3(352.35, -1403.12, 36.52),
        Model = 1884112547,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = { 'CRUSADE_HOSP_WARD_A_02_RIGHT' },
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'CRUSADE_HOSP_WARD_A_02_RIGHT',
        Coords = vector3(350.76, -1405.02, 36.52),
        Model = 1884112547,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = { 'CRUSADE_HOSP_WARD_A_02_LEFT' },
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'CRUSADE_HOSP_WARD_A_OFFICE_02',
        Coords = vector3(365.28, -1400.47, 36.52),
        Model = 2115166766,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'CRUSADE_HOSP_WARD_A_TO_B_LEFT',
        Coords = vector3(377.67, -1412.64, 36.52),
        Model = 1884112547,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = { 'CRUSADE_HOSP_WARD_A_TO_B_RIGHT' },
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'CRUSADE_HOSP_WARD_A_TO_B_RIGHT',
        Coords = vector3(375.95, -1414.68, 36.52),
        Model = 1884112547,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = { 'CRUSADE_HOSP_WARD_A_TO_B_LEFT' },
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'CRUSADE_HOSP_WARD_A_ROOM_03',
        Coords = vector3(366.31, -1418.92, 36.52),
        Model = 2115166766,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'CRUSADE_HOSP_WARD_A_ROOM_02',
        Coords = vector3(361.82, -1415.15, 36.52),
        Model = 2115166766,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'CRUSADE_HOSP_WARD_A_ROOM_01',
        Coords = vector3(357.26, -1411.33, 36.52),
        Model = 2115166766,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'CRUSADE_HOSP_WARD_A_ROOM_04',
        Coords = vector3(371.83, -1400.95, 36.52),
        Model = 2115166766,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'CRUSADE_HOSP_WARD_A_ROOM_DOUBLE',
        Coords = vector3(377.32, -1405.55, 36.52),
        Model = 2115166766,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'CRUSADE_HOSP_WARD_A_DIRECTOR_OFFICE',
        Coords = vector3(384.58, -1417.7, 36.52),
        Model = 2115166766,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'CRUSADE_HOSP_PSY_OFFICE',
        Coords = vector3(363.83, -1388.87, 36.52),
        Model = 2115166766,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'CRUSADE_HOSP_DIAGNOSTICS_1',
        Coords = vector3(358.6, -1412.22, 32.5),
        Model = 2115166766,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'CRUSADE_HOSP_DIAGNOSTICS_2',
        Coords = vector3(362.54, -1415.61, 32.5),
        Model = 2115166766,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'CRUSADE_HOSP_DIAGNOSTICS_3',
        Coords = vector3(366.49, -1419.08, 32.5),
        Model = 2115166766,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'CRUSADE_HOSP_LAB_LEFT',
        Coords = vector3(387.18, -1402.21, 32.5),
        Model = 1884112547,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = { 'CRUSADE_HOSP_LAB_RIGHT' },
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'CRUSADE_HOSP_LAB_RIGHT',
        Coords = vector3(385.5, -1404.17, 32.5),
        Model = 1884112547,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = { 'CRUSADE_HOSP_LAB_LEFT' },
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'CRUSADE_HOSP_SURGERY_01_LEFT',
        Coords = vector3(378.55, -1400.58, 32.5),
        Model = 2115166766,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = { 'CRUSADE_HOSP_SURGERY_01_RIGHT' },
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'CRUSADE_HOSP_SURGERY_01_RIGHT',
        Coords = vector3(377.12, -1402.29, 32.5),
        Model = 2115166766,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = { 'CRUSADE_HOSP_SURGERY_01_LEFT' },
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'CRUSADE_HOSP_SURGERY_02_LEFT',
        Coords = vector3(374.23, -1400.03, 32.5),
        Model = 2115166766,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = { 'CRUSADE_HOSP_SURGERY_02_RIGHT' },
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'CRUSADE_HOSP_SURGERY_02_RIGHT',
        Coords = vector3(375.83, -1398.16, 32.5),
        Model = 2115166766,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = { 'CRUSADE_HOSP_SURGERY_02_LEFT' },
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },

    -- MRPD
    {
        Info = 'MRPD_GARAGE_01',
        Coords = vector3(452.31, -1000.84, 25.72),
        Model = 'gabz_mrpd_garage_door',
        Locked = 1,
        IsGate = true,
        CanDetcord = false,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'MRPD_GARAGE_02',
        Coords = vector3(431.35, -1000.73, 25.71),
        Model = 'gabz_mrpd_garage_door',
        Locked = 1,
        IsGate = true,
        CanDetcord = false,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'MRPD_GARAGE_TO_SECTORA_LEFT',
        Coords = vector3(464.16, -996.97, 26.37),
        Model = 1830360419,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'MRPD_GARAGE_TO_SECTORA_RIGHT',
        Coords = vector3(464.41, -975.2, 26.36),
        Model = 1830360419,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'MRPD_BACK_ENTRANCE_LEFT',
        Coords = vector3(469.87, -1013.99, 26.39),
        Model = -692649124,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = { 'MRPD_BACK_ENTRANCE_RIGHT' },
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'MRPD_BACK_ENTRANCE_RIGHT',
        Coords = vector3(467.28, -1014.04, 26.39),
        Model = -692649124,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = { 'MRPD_BACK_ENTRANCE_LEFT' },
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = { },
            Business = {}
        },
    },
    {
        Info = 'MRPD_BACK_ENTRANCE_TO_CELLS',
        Coords = vector3(476.17, -1008.73, 26.27),
        Model = -53345114,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'MRPD_BACK_CELLS_TO_INTEROGATION',
        Coords = vector3(480.83, -1004.42, 26.27),
        Model = -53345114,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'MRPD_CELLS_1',
        Coords = vector3(477.62, -1011.7, 26.27),
        Model = -53345114,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'MRPD_CELLS_2',
        Coords = vector3(480.88, -1011.74, 26.27),
        Model = -53345114,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'MRPD_CELLS_3',
        Coords = vector3(483.97, -1011.87, 26.27),
        Model = -53345114,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'MRPD_CELLS_4',
        Coords = vector3(486.87, -1011.75, 26.27),
        Model = -53345114,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'MRPD_CELLS_5',
        Coords = vector3(483.97, -1008.04, 26.27),
        Model = -53345114,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'MRPD_SIDE_ENTRANCE_01_LEFT',
        Coords = vector3(458.24, -972.67, 30.71),
        Model = -1547307588,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = { 'MRPD_SIDE_ENTRANCE_01_RIGHT' },
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'MRPD_SIDE_ENTRANCE_01_RIGHT',
        Coords = vector3(455.86, -972.68, 30.71),
        Model = -1547307588,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = { 'MRPD_SIDE_ENTRANCE_01_LEFT' },
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'MRPD_SIDE_ENTRANCE_02_LEFT',
        Coords = vector3(442.96, -998.37, 30.69),
        Model = -1547307588,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = { 'MRPD_SIDE_ENTRANCE_02_RIGHT' },
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'MRPD_SIDE_ENTRANCE_02_RIGHT',
        Coords = vector3(440.96, -998.22, 30.69),
        Model = -1547307588,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = { 'MRPD_SIDE_ENTRANCE_02_LEFT' },
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'MRPD_FRONT_TO_INSIDE_LEFT',
        Coords = vector3(440.59, -978.12, 30.69),
        Model = -1406685646,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'MRPD_FRONT_TO_INSIDE_RIGHT',
        Coords = vector3(440.55, -985.71, 30.69),
        Model = -96679321,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'MRPD_CAPTAINS_OFFICE',
        Coords = vector3(458.08, -990.67, 30.69),
        Model = -96679321,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = 'MRPD_ROOF_ENTRANCE',
        Coords = vector3(464.82, -984.48, 43.67),
        Model = -692649124,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Disabled = false,
        Connected = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "MRPD_BOLLARDS_01",
        Coords = vector3(410.01, -1020.72, 29.41),
        Model = 'gabz_mrpd_bollards1',
        Locked = 1,
        IsGate = true,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "MRPD_BOLLARDS_02",
        Coords = vector3(410.12, -1028.21, 29.39),
        Model = 'gabz_mrpd_bollards2',
        Locked = 1,
        IsGate = true,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },

    -- VBPD
    {
        Info = "VBPD_ENTRANCE_TO_CLOTHING",
        Coords = vector3(-1086.32, -825.25, 19.29),
        Model = 'v_ilev_gendoor01',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connecte = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "VBPD_ENTRANCE_TO_ARMORY",
        Coords = vector3(-1081.51, -825.14, 19.32),
        Model = 'v_ilev_arm_secdoor',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connecte = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "VBPD_ENTRANCE_TO_CAPTAINS",
        Coords = vector3(-1083.21, -819.03, 19.32),
        Model = 'v_ilev_ph_gendoor002',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connecte = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "VBPD_ENTRANCE_TO_HALL_L",
        Coords = vector3(-1092.49, -822.36, 19.29),
        Model = 'v_ilev_gendoor01',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connecte = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "VBPD_ENTRANCE_TO_HALL_R",
        Coords = vector3(-1091.68, -823.38, 19.29),
        Model = 'v_ilev_gendoor01',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connecte = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "VBPD_HALL_TO_CELLS",
        Coords = vector3(-1082.65, -839.86, 13.52),
        Model = 'v_ilev_ph_cellgate',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connecte = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "VBPD_CELLS_01",
        Coords = vector3(-1084.73, -838.92, 13.52),
        Model = 'v_ilev_ph_cellgate',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connecte = {},
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "VBPD_CELLS_02",
        Coords = vector3(-1088.37, -841.85, 13.52),
        Model = 'v_ilev_ph_cellgate',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connecte = {},
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "VBPD_CELLS_03",
        Coords = vector3(-1091.17, -844.03, 13.52),
        Model = 'v_ilev_ph_cellgate',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connecte = {},
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "VBPD_GARAGE_DOOR",
        Coords = vector3(-1073.14, -850.90, 7.4),
        Model = 'apa_prop_ss1_mpint_garage2',
        Locked = 1,
        IsGate = true,
        CanDetcord = false,
        Connecte = {},
        Access = {
            Job = { 'police', 'ems', 'judge' },
            CitizenId = {},
            Business = {}
        },
    },

    -- PBSO (Paleto Bay Sherrifs Office)
    {
        Info = "PBSO_BOLLARDS_01",
        Coords = vector3(-456.47, 6031.13, 31.13),
        Model = 'gabz_paletopd_bollards1',
        Locked = 1,
        IsGate = true,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = {'police', 'ems', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "PBSO_CAPTAIN",
        Coords = vector3(-437.12, 6004.65, 36.99),
        Model = 'gabz_paletopd_doors01',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = {'police', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "PBSO_GATE",
        Coords = vector3(-450.35, 6024.46, 31.49),
        Model = 'prop_fnclink_03gate5',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = {'police', 'ems', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "PBSO_HALL_TO_RECEPTION",
        Coords = vector3(-443.64, 6016.8, 32.29),
        Model = 1362051455,
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = {'police', 'ems', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "PBSO_HALL_TO_BACK_LEFT",
        Coords = vector3(-446.19, 6003.63, 32.29),
        Model = 1362051455,
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = { 'PBSO_HALL_TO_BACK_RIGHT' },
        Access = {
            Job = {'police', 'ems', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "PBSO_HALL_TO_BACK_RIGHT",
        Coords = vector3(-447.63, 6005.22, 32.29),
        Model = 1857649811,
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = { 'PBSO_HALL_TO_BACK_LEFT' },
        Access = {
            Job = {'police', 'ems', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "PBSO_BACK_ENTRANCE_LEFT",
        Coords = vector3(-455.2, 5997.68, 32.29),
        Model = 733214349,
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = { 'PBSO_BACK_ENTRANCE_RIGHT' },
        Access = {
            Job = {'police', 'ems', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "PBSO_BACK_ENTRANCE_RIGHT",
        Coords = vector3(-453.97, 5996.4, 32.29),
        Model = 965382714,
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = { 'PBSO_BACK_ENTRANCE_LEFT' },
        Access = {
            Job = {'police', 'ems', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "PBSO_TO_CELLS",
        Coords = vector3(-444.11, 6007.06, 27.58),
        Model = -594854737,
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = {'police', 'ems', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "PBSO_CELL_01",
        Coords = vector3(-443.62, 6015.23, 27.58),
        Model = -594854737,
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = {'police', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "PBSO_CELL_02",
        Coords = vector3(-446.26, 6017.87, 27.58),
        Model = -594854737,
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = {'police', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "PBSO_CELL_03",
        Coords = vector3(-448.71, 6016.07, 27.58),
        Model = -594854737,
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = {'police', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "PBSO_CELL_04",
        Coords = vector3(-445.74, 6013.12, 27.58),
        Model = -594854737,
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = {'police', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    
    -- SDSO (Senora Desert Police Department)
    {
        Info = "SDSO_LOCKERS",
        Coords = vector3(1838.00, 3677.10, 34.28),
        Model = 'gabz_sandypd_door_02',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = {'police', 'ems', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "SDSO_OFFICE",
        Coords = vector3(1829.85, 3673.78, 34.28),
        Model = 'gabz_sandypd_door_01',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = {'police', 'ems', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "SDSO_HALLWAY",
        Coords = vector3(1830.65, 3676.56, 34.28),
        Model = 'gabz_sandypd_door_01',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = {'police', 'ems', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "SDSO_HALLWAY_OFFICE",
        Coords = vector3(1827.07, 3674.49, 34.28),
        Model = 'gabz_sandypd_door_01',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = {'police', 'ems', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "SDSO_HALLWAY_TO_CELLS",
        Coords = vector3(1813.55, 3675.05, 34.39),
        Model = 'gabz_sandypd_cell_door',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = {'police', 'ems', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "SDSO_CELLS_01",
        Coords = vector3(1810.49, 3675.91, 34.19),
        Model = 'gabz_sandypd_cell_door',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = {'police', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "SDSO_CELLS_02",
        Coords = vector3(1808.89, 3678.39, 34.19),
        Model = 'gabz_sandypd_cell_door',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = {'police', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "SDSO_CELLS_03",
        Coords = vector3(1807.48, 3681.07, 34.19),
        Model = 'gabz_sandypd_cell_door',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = {'police', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "SDSO_BACK_DOOR",
        Coords = vector3(1823.86, 3681.11, 34.33),
        Model = 'v_ilev_shrf2door',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = {'police', 'ems', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "SDSO_SHERIFF",
        Coords = vector3(1828.42, 3673.81, 38.95),
        Model = 'gabz_sandypd_door_03',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = {'police', 'ems', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "SDSO_GATE",
        Coords = vector3(1862.00, 3687.52, 33.01),
        Model = 'prop_facgate_07b',
        Locked = 1,
        IsGate = true,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = {'police', 'ems', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "SDSO_WALK_GATE",
        Coords = vector3(1846.0, 3677.58, 33.97),
        Model = 'prop_fnclink_03gate5',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = {'police', 'ems', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },

    -- DAPD (Davis Avenue Police Department)
    {
        Info = "DAPD_CELLS_WOMEN_01",
        Coords = vector3(369.45, -1605.4, 30.05),
        Model = -674638964,
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = {'police', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "DAPD_CELLS_MEN_01",
        Coords = vector3(368.25, -1604.55, 30.05),
        Model = -674638964,
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = {'police', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "DAPD_CELLS_WOMEN_02",
        Coords = vector3(374.75, -1598.94, 25.45),
        Model = -674638964,
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = {'police', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "DAPD_CELLS_MEN_02",
        Coords = vector3(375.6, -1599.47, 25.45),
        Model = -674638964,
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = {'police', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "DAPD_FRONT_ENTRANCE_LEFT",
        Coords = vector3(379.47, -1592.87, 30.05),
        Model = 1670919150,
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = { 'DAPD_FRONT_ENTRANCE_RIGHT' },
        Access = {
            Job = {'police', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "DAPD_FRONT_ENTRANCE_RIGHT",
        Coords = vector3(381.45, -1594.61, 30.05),
        Model = 618295057,
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = { 'DAPD_FRONT_ENTRANCE_LEFT' },
        Access = {
            Job = {'police', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "DAPD_BACK_ENTRANCE_LEFT",
        Coords = vector3(371.79, -1615.56, 30.05),
        Model = 1670919150,
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = { 'DAPD_BACK_ENTRANCE_RIGHT' },
        Access = {
            Job = {'police', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    {
        Info = "DAPD_BACK_ENTRANCE_RIGHT",
        Coords = vector3(369.79, -1613.88, 30.05),
        Model = 618295057,
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = { 'DAPD_BACK_ENTRANCE_LEFT' },
        Access = {
            Job = {'police', 'judge'},
            CitizenId = {},
            Business = {}
        },
    },
    
    -- Illegal Bench
    {
        Info = "ILLEGAL_BENCH_DOOR",
        Coords = vector3(441.45, 3520.73, 33.68),
        Model = "prop_ld_contain_dr",
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {
                -- '2000', -- Character Name
            },
            Business = {}
        },
    },
    

    -- PDM
    {
        Info = "PDM_PARKING_ENTRANCE",
        Coords = vector3(-48.23, -1104.02, 27.26),
        Model = 1973010099,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Premium Deluxe Motorsports' }
        },
    },
    {
        Info = "PDM_ROAD_ENTRANCE",
        Coords = vector3(-56.37, -1087.89, 27.26),
        Model = 1973010099,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Premium Deluxe Motorsports' }
        },
    },
    {
        Info = "PDM_BACK_GARAGE",
        Coords = vector3(-21.66, -1089.21, 29.7),
        Model = 1010499530,
        Locked = 1,
        IsGate = true,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Premium Deluxe Motorsports' }
        },
    },

    -- Tuner Shop
    {
        Info = 'TUNERSHOP_DOOR_01',
        Coords = vector3(151.39, -3012.43, 7.23),
        Model = 'denis3d_ts_container_doors',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { '6STR. Tuner Shop' },
        },
    },
    {
        Info = "TUNERSHOP_GARAGE_LEFT",
        Coords = vector3(154.64, -3035.35, 9.93),
        Model = -456733639,
        Locked = 1,
        IsGate = true,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { '6STR. Tuner Shop' }
        },
    },
    {
        Info = "TUNERSHOP_GARAGE_RIGHT",
        Coords = vector3(154.74, -3023.35, 10.04),
        Model = -456733639,
        Locked = 1,
        IsGate = true,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { '6STR. Tuner Shop' }
        },
    },

    -- Hayes
    {
        Info = 'HAYES_GARAGE_DOOR_01',
        Coords = vector3(262.53, -1821.2, 26.91),
        Model = -1831381864,
        Locked = 1,
        IsGate = true,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Hayes Repairs' },
        },
    },
    {
        Info = 'HAYES_GARAGE_DOOR_02',
        Coords = vector3(259.38, -1802.17, 27.27),
        Model = -440499603,
        Locked = 1,
        IsGate = true,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Hayes Repairs' },
        },
    },
    {
        Info = 'HAYES_FRONT_DOOR_03',
        Coords = vector3(272.26, -1824.31, 26.91),
        Model = 1463102904,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Hayes Repairs' },
        },
    },
    {
        Info = 'HAYES_OFFICE_DOOR_LEFT',
        Coords = vector3(278.83, -1812.66, 30.09),
        Model = -1667357871,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = { 'HAYES_OFFICE_DOOR_RIGHT' },
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Hayes Repairs' },
        },
    },
    {
        Info = 'HAYES_OFFICE_DOOR_RIGHT',
        Coords = vector3(277.13, -1811.15, 30.09),
        Model = -1667357871,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = { 'HAYES_OFFICE_DOOR_LEFT' },
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Hayes Repairs' },
        },
    },

    -- Otto's Autos
    {
        Info = 'OTTOS_AUTOS_GARAGE_DOOR_02',
        Coords = vector3(824.22, -805.21, 28.79),
        Model = 270330101,
        Locked = 1,
        IsGate = true,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Ottos Autos' },
        },
    },
    {
        Info = 'OTTOS_AUTOS_GARAGE_DOOR_02',
        Coords = vector3(824.33, -813.5, 29.03),
        Model = 270330101,
        Locked = 1,
        IsGate = true,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Ottos Autos' },
        },
    },
    {
        Info = 'OTTOS_AUTOS_GARAGE_DOOR_03',
        Coords = vector3(824.35, -820.9, 29.02),
        Model = 270330101,
        Locked = 1,
        IsGate = true,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Ottos Autos' },
        },
    },
    {
        Info = 'OTTOS_AUTOS_FRONT_DOOR',
        Coords = vector3(824.16, -829.18, 26.33),
        Model = -147325430,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Ottos Autos' },
        },
    },
    {
        Info = 'OTTOS_AUTOS_OFFICE',
        Coords = vector3(830.12, -829.02, 26.33),
        Model = -147325430,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Ottos Autos' },
        },
    },
    {
        Info = 'OTTOS_AUTOS_LOCKERS',
        Coords = vector3(837.25, -821.2, 26.33),
        Model = -147325430,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Ottos Autos' },
        },
    },
    {
        Info = 'OTTOS_AUTOS_BACK_DOOR',
        Coords = vector3(840.67, -821.16, 26.33),
        Model = 263193286,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Ottos Autos' },
        },
    },

    -- Burger Shot
    {
        Info = "BURGERSHOT_EMPLOYEE_DOOR_01",
        Coords = vector3(-1200.63, -892.56, 13.92),
        Model = 'bs_prop_door_01',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Burger Shot' }
        },
    },
    {
        Info = "BURGERSHOT_EMPLOYEE_DOOR_02",
        Coords = vector3(-1199.61, -903.34, 13.98),
        Model = 'bs_prop_door_staff_01',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Burger Shot' }
        },
    },
    {
        Info = "BURGERSHOT_EMPLOYEE_DOOR_03",
        Coords = vector3(-1178.92, -892.00, 13.98),
        Model = 'bs_prop_door_staff_01',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Burger Shot' }
        },
    },
    {
        Info = "BURGERSHOT_DOOR_01",
        Coords = vector3(-1198.41, -884.79, 14.01),
        Model = 'bs_prop_door_02_r',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = { 'BURGERSHOT_DOOR_02' },
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Burger Shot' }
        },
    },
    {
        Info = "BURGERSHOT_DOOR_02",
        Coords = vector3(-1197.18, -883.91, 14.01),
        Model = 'bs_prop_door_02_l',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = { 'BURGERSHOT_DOOR_01' },
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Burger Shot' }
        },
    },
    {
        Info = "BURGERSHOT_DOOR_03",
        Coords = vector3(-1184.44, -883.95, 14.01),
        Model = 'bs_prop_door_02_r',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = { 'BURGERSHOT_DOOR_04' },
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Burger Shot' }
        },
    },
    {
        Info = "BURGERSHOT_DOOR_04",
        Coords = vector3(-1183.61, -885.13, 14.01),
        Model = 'bs_prop_door_02_l',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = { 'BURGERSHOT_DOOR_03' },
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Burger Shot' }
        },
    },

    -- Digital Den
    {
        Info = 'DIGITAL_SECRET_DOOR',
        Coords = vector3(1136.44, -467.57, 66.62),
        Model = 'xee_digital_den_picture_door',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Digital Den' },
        },
    },
    {
        Info = 'DIGITAL_BREAK_DOOR',
        Coords = vector3(1131.94, -463.16, 66.49),
        Model = 'xee_digital_den_break_door',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Digital Den' },
        },
    },
    {
        Info = 'DIGITAL_BACK_DOOR',
        Coords = vector3(1129.68, -464.04, 66.49),
        Model = 'xee_digital_den_backdoor',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Digital Den' },
        },
    },

    -- Pizza This
    {
        Info = 'PIZZA_FRONT_DOOR_1',
        Coords = vector3(794.6, -758.79, 26.78),
        Model = 'sm_pizzeria_mdoor_r',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = { 'PIZZA_FRONT_DOOR_2' },
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Pizza This' },
        },
    },
    {
        Info = 'PIZZA_FRONT_DOOR_2',
        Coords = vector3(794.27, -757.73, 26.78),
        Model = 'sm_pizzeria_mdoor_l',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = { 'PIZZA_FRONT_DOOR_1' },
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Pizza This' },
        },
    },
    {
        Info = 'PIZZA_FRONT_DOOR_3',
        Coords = vector3(805.04, -747.94, 26.78),
        Model = 'sm_pizzeria_mdoor_l',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = { 'PIZZA_FRONT_DOOR_4' },
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Pizza This' },
        },
    },
    {
        Info = 'PIZZA_FRONT_DOOR_4',
        Coords = vector3(803.96, -747.8, 26.78),
        Model = 'sm_pizzeria_mdoor_r',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = { 'PIZZA_FRONT_DOOR_3' },
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Pizza This' },
        },
    },
    {
        Info = 'PIZZA_FREEZER',
        Coords = vector3(805.29, -759.51, 26.89),
        Model = 'sm_pizzeria_freezer_door',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Pizza This' },
        },
    },
    {
        Info = 'PIZZA_KITCHEN',
        Coords = vector3(809.66, -756.16, 26.78),
        Model = 'sm_pizzeria_wooden_door',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Pizza This' },
        },
    },
    {
        Info = 'PIZZA_CELLAR',
        Coords = vector3(807.03, -765.68, 26.78),
        Model = 'sm_pizzeria_wooden_door',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Pizza This' },
        },
    },
    {
        Info = 'PIZZA_BACK_DOOR',
        Coords = vector3(814.49, -763.57, 26.78),
        Model = 'sm_pizzeria_back_door',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Pizza This' },
        },
    },
    {
        Info = 'PIZZA_CEO',
        Coords = vector3(798.31, -758.25, 31.27),
        Model = 'sm_pizzeria_wooden_door',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Pizza This' },
        },
    },

    -- UwU Café
    {
        Info = 'CATCAFE_MAIN_1',
        Coords = vector3(-580.65, -1069.6, 22.36),
        Model = 'denis3d_catcafe_maindoors_r',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = { 'CATCAFE_MAIN_2' },
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'UwU Café' },
        },
    },
    {
        Info = 'CATCAFE_MAIN_2',
        Coords = vector3(-581.5, -1069.6, 22.31),
        Model = 'denis3d_catcafe_maindoors_l',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = { 'CATCAFE_MAIN_1' },
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'UwU Café' },
        },
    },
    {
        Info = 'CATCAFE_GARAGE_DOOR',
        Coords = vector3(-600.97, -1059.29, 22.55),
        Model = 'denis3d_catcafe_garagedoors',
        Locked = 1,
        IsGate = true,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'UwU Café' },
        },
    },
    {
        Info = 'CATCAFE_GARAGE_WALKDOOR',
        Coords = vector3(-600.90, -1055.12, 22.61),
        Model = 'v_ilev_rc_door3_l',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'UwU Café' },
        },
    },
    {
        Info = 'CATCAFE_TO_GARAGE_DOOR_1',
        Coords = vector3(-592.99, -1056.04, 22.36),
        Model = 'denis3d_catcafe_doorsA',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'UwU Café' },
        },
    },
    {
        Info = 'CATCAFE_TO_GARAGE_DOOR_2',
        Coords = vector3(-591.69, -1066.38, 22.34),
        Model = 'denis3d_catcafe_fridgedoors',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'UwU Café' },
        },
    },
    {
        Info = 'CATCAFE_TO_KITCHEN',
        Coords = vector3(-587.45, -1052.48, 22.36),
        Model = 'denis3d_catcafe_doorsB',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'UwU Café' },
        },
    },
    {
        Info = 'CATCAFE_TO_OFFICE',
        Coords = vector3(-572.51, -1057.37, 26.63),
        Model = 'sum_p_mp_yacht_door_02',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'UwU Café' },
        },
    },
    
    -- Vanilla Unicorn
    {
        Info = 'VANILLA_UNICORN_BACK',
        Coords = vector3(-591.69, -1066.38, 22.34),
        Model = 'ba_prop_door_club_edgy_generic',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Vanilla Unicorn' },
        },
    },
    {
        Info = 'VANILLA_UNICORN_OUTSIDE_1',
        Coords = vector3(95.52, -1285.32, 29.28),
        Model = 'ba_prop_door_club_glam_generic',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Vanilla Unicorn' },
        },
    },
    {
        Info = 'VANILLA_UNICORN_OUTSIDE_2',
        Coords = vector3(128.59, -1298.12, 29.26),
        Model = 'prop_strip_door_01',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'Vanilla Unicorn' },
        },
    },

    -- Rehab Center
    {
        Info = 'REHAB_CENTER_1',
        Coords = vector3(-1478.21, 882.42, 182.87),
        Model = 'prop_lrggate_01_l',
        Locked = 1,
        IsGate = true,
        CanDetcord = true,
        Connected = { 'REHAB_CENTER_2' },
        Access = {
            Job = { 'ems' },
            CitizenId = {},
            Business = {},
        },
    },
    {
        Info = 'REHAB_CENTER_2',
        Coords = vector3(-1477.28, 887.54, 182.82),
        Model = 'prop_lrggate_01_r',
        Locked = 1,
        IsGate = true,
        CanDetcord = true,
        Connected = { 'REHAB_CENTER_1' },
        Access = {
            Job = { 'ems' },
            CitizenId = {},
            Business = {},
        },
    },
    
    -- Lost MC
    {
        Info = 'LOST_MC_FRONT_DOOR',
        Coords = vector3(90.53, 3609.02, 40.73),
        Model = 190770132,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'The Lost MC' },
        },
    },
    {
        Info = 'LOST_MC_GARAGE_GATE',
        Coords = vector3(107.32, 3620.27, 40.27),
        Model = -822900180,
        Locked = 1,
        IsGate = true,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'The Lost MC' },
        },
    },
    {
        Info = 'LOST_MC_OFFICE_DOOR',
        Coords = vector3(97.67, 3601.12, 40.72),
        Model = -543490328,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'The Lost MC' },
        },
    },
    
    -- Los Santos Job Centre (BBV Makelaars)
    {
        Info = 'LSJC_OFFICE_01',
        Coords = vector3(-244.87, -915.11, 32.45),
        Model = 'ex_p_mp_door_apart_doorwhite01_s',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'BBV Makelaars' },
        },
    },
    {
        Info = 'LSJC_OFFICE_02',
        Coords = vector3(-246.85, -920.55, 32.45),
        Model = 'ex_p_mp_door_apart_doorwhite01_s',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { 'BBV Makelaars' },
        },
    },

    -- Town Hall
    {
        Info = 'TOWNHALL_ENTRANCE_FRONT_LEFT',
        Coords = vector3(-544.5583, -202.7798, 38.42064),
        Model = 'gabz_townhall_main_door_l',
        Locked = 0,
        IsGate = false,
        CanDetcord = true,
        Connected = { 'TOWNHALL_ENTRANCE_FRONT_RIGHT' },
        Access = {
            Job = { 'police', 'judge', 'lawyer', 'mayor' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'TOWNHALL_ENTRANCE_FRONT_RIGHT',
        Coords = vector3(-546.5197, -203.9119, 38.42064),
        Model = 'gabz_townhall_main_door_r',
        Locked = 0,
        IsGate = false,
        CanDetcord = true,
        Connected = { 'TOWNHALL_ENTRANCE_FRONT_LEFT' },
        Access = {
            Job = { 'police', 'judge', 'lawyer', 'mayor' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'TOWNHALL_OFFICE_1',
        Coords = vector3(-541.0229, -192.2024, 38.334),
        Model = 'gabz_townhall_door_office',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = { 'police', 'judge', 'lawyer', 'mayor' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'TOWNHALL_OFFICE_2',
        Coords = vector3(-536.2, -189.4187, 38.334),
        Model = 'gabz_townhall_door_office',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = { 'police', 'judge', 'lawyer', 'mayor' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'TOWNHALL_OFFICE_3',
        Coords = vector3(-531.3376, -186.6122, 38.334),
        Model = 'gabz_townhall_door_office',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = { 'police', 'judge', 'lawyer', 'mayor' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'TOWNHALL_OFFICE_4',
        Coords = vector3(-541.0101, -192.198, 43.46984),
        Model = 'gabz_townhall_door_office',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = { 'police', 'judge', 'lawyer', 'mayor' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'TOWNHALL_VOTINGROOM_1',
        Coords = vector3(-538.4105, -185.5889, 38.334),
        Model = 'gabz_townhall_door_office',
        Locked = 0,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = { 'police', 'judge', 'lawyer', 'mayor' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'TOWNHALL_VOTINGROOM_2',
        Coords = vector3(-532.4227, -182.1329, 38.334),
        Model = 'gabz_townhall_door_office',
        Locked = 0,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = { 'police', 'judge', 'lawyer', 'mayor' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'TOWNHALL_MAYORS_OFFICE',
        Coords = vector3(-536.1873, -189.4142, 43.46984),
        Model = 'gabz_townhall_door_office',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = { 'police', 'judge', 'lawyer', 'mayor' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'TOWNHALL_MAYORS_MEETINGROOM',
        Coords = vector3(-538.3984, -185.5834, 43.46984),
        Model = 'gabz_townhall_door_office',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = { 'police', 'judge', 'lawyer', 'mayor' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'TOWNHALL_HALLWAY_TO_COURTROOM_1',
        Coords = vector3(-562.1283, -202.5661, 38.43664),
        Model = 'gabz_townhall_double_door_slim',
        Locked = 0,
        IsGate = false,
        CanDetcord = true,
        Connected = { 'TOWNHALL_HALLWAY_TO_COURTROOM_2' },
        Access = {
            Job = { 'police', 'judge', 'lawyer', 'mayor' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'TOWNHALL_HALLWAY_TO_COURTROOM_2',
        Coords = vector3(-562.778, -201.4405, 38.43664),
        Model = 'gabz_townhall_double_door_slim',
        Locked = 0,
        IsGate = false,
        CanDetcord = true,
        Connected = { 'TOWNHALL_HALLWAY_TO_COURTROOM_1' },
        Access = {
            Job = { 'police', 'judge', 'lawyer', 'mayor' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'TOWNHALL_STAIRS_TO_COURTROOM_UPPER_1',
        Coords = vector3(-562.1256, -202.5645, 43.5755),
        Model = 'gabz_townhall_double_door_slim',
        Locked = 0,
        IsGate = false,
        CanDetcord = true,
        Connected = { 'TOWNHALL_STAIRS_TO_COURTROOM_UPPER_2' },
        Access = {
            Job = { 'police', 'judge', 'lawyer', 'mayor' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'TOWNHALL_STAIRS_TO_COURTROOM_UPPER_2',
        Coords = vector3(-562.7753, -201.4389, 43.5755),
        Model = 'gabz_townhall_double_door_slim',
        Locked = 0,
        IsGate = false,
        CanDetcord = true,
        Connected = { 'TOWNHALL_STAIRS_TO_COURTROOM_UPPER_1' },
        Access = {
            Job = { 'police', 'judge', 'lawyer', 'mayor' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'TOWNHALL_COURTROOM_TO_JUDGE_OFFICE',
        Coords = vector3(-582.5042, -207.4983, 38.32499),
        Model = 'gabz_townhall_door_office',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = { 'police', 'judge', 'lawyer', 'mayor' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'TOWNHALL_COURTROOM_TO_JURY_ROOM',
        Coords = vector3(-577.2459, -216.6084, 38.32499),
        Model = 'gabz_townhall_door_office',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = { 'police', 'judge', 'lawyer', 'mayor' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'TOWNHALL_COURTROOM_TO_EXIT_HALLWAY',
        Coords = vector3(-574.5858, -216.934, 38.32499),
        Model = 'gabz_townhall_door_office',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = { 'police', 'judge', 'lawyer', 'mayor' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'TOWNHALL_EXIT_HALLWAY_TO_CELLROOM',
        Coords = vector3(-562.6888, -231.6888, 34.37224),
        Model = 'gabz_townhall_door_office',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = { 'police', 'judge', 'lawyer', 'mayor' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'TOWNHALL_CELLROOM_CELL_01',
        Coords = vector3(-557.9441, -233.1107, 34.4771),
        Model = 'gabz_townhall_cell_door',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = { 'police', 'judge', 'lawyer', 'mayor' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'TOWNHALL_CELLROOM_CELL_02',
        Coords = vector3(-560.5424, -234.6103, 34.4771),
        Model = 'gabz_townhall_cell_door',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = { 'police', 'judge', 'lawyer', 'mayor' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'TOWNHALL_SIDE_ENTRANCE_LEFT',
        Coords = vector3(-567.4882, -236.2653, 34.3575),
        Model = 'gabz_townhall_door_side_l',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = { 'TOWNHALL_SIDE_ENTRANCE_RIGHT' },
        Access = {
            Job = { 'police', 'judge', 'lawyer', 'mayor' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'TOWNHALL_SIDE_ENTRANCE_RIGHT',
        Coords = vector3(-568.5511, -234.4239, 34.3575),
        Model = 'gabz_townhall_door_side_r',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = { 'TOWNHALL_SIDE_ENTRANCE_LEFT' },
        Access = {
            Job = { 'police', 'judge', 'lawyer', 'mayor' },
            CitizenId = {},
            Business = {},
        }
    },

    -- Prison
    {
        Info = 'PRISON_GATE_01',
        Coords = vector3(1844.9, 2604.8, 44.6),
        Model = 'prop_gate_prison_01',
        Locked = 1,
        IsGate = true,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = { 'judge', 'police' },
            CitizenId = {},
            Business = {},
        },
    },
    {
        Info = 'PRISON_GATE_02',
        Coords = vector3(1818.5, 2604.8, 44.6),
        Model = 'prop_gate_prison_01',
        Locked = 1,
        IsGate = true,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = { 'judge', 'police' },
            CitizenId = {},
            Business = {},
        },
    },
    {
        Info = 'PRISON_RECEPTION_01',
        Coords = vector3(1831.46, 2594.17, 46.01),
        Model = 'sanhje_Prison_recep_door02',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = { 'judge', 'police' },
            CitizenId = {},
            Business = {},
        },
    },
    {
        Info = 'PRISON_RECEPTION_02',
        Coords = vector3(1837.04, 2592.18, 46.01),
        Model = 'sanhje_Prison_recep_door02',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = { 'judge', 'police' },
            CitizenId = {},
            Business = {},
        },
    },
    {
        Info = 'PRISON_RECEPTION_03',
        Coords = vector3(1836.94, 2577.02, 46.01),
        Model = 'sanhje_Prison_recep_door01',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = { 'judge', 'police' },
            CitizenId = {},
            Business = {},
        },
    },
    {
        Info = 'PRISON_RECEPTION_04',
        Coords = vector3(1843.69, 2577.01, 46.01),
        Model = 'sanhje_Prison_recep_door01',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = { 'judge', 'police' },
            CitizenId = {},
            Business = {},
        },
    },
    {
        Info = 'PRISON_TOWER_DOOR_01',
        Coords = vector3(1820.89, 2477.05, 45.37),
        Model = 'v_ilev_gtdoor',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = { 'judge', 'police' },
            CitizenId = {},
            Business = {},
        },
    },
    {
        Info = 'PRISON_TOWER_DOOR_02',
        Coords = vector3(1760.03, 2413.54, 45.36),
        Model = 'v_ilev_gtdoor',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = { 'judge', 'police' },
            CitizenId = {},
            Business = {},
        },
    },
    {
        Info = 'PRISON_TOWER_DOOR_03',
        Coords = vector3(1659.27, 2398.14, 45.40),
        Model = 'v_ilev_gtdoor',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = { 'judge', 'police' },
            CitizenId = {},
            Business = {},
        },
    },
    {
        Info = 'PRISON_TOWER_DOOR_04',
        Coords = vector3(1544.10, 2470.89, 45.40),
        Model = 'v_ilev_gtdoor',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = { 'judge', 'police' },
            CitizenId = {},
            Business = {},
        },
    },
    {
        Info = 'PRISON_TOWER_DOOR_05',
        Coords = vector3(1538.32, 2585.37, 45.40),
        Model = 'v_ilev_gtdoor',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = { 'judge', 'police' },
            CitizenId = {},
            Business = {},
        },
    },
    {
        Info = 'PRISON_TOWER_DOOR_06',
        Coords = vector3(1572.69, 2678.35, 45.40),
        Model = 'v_ilev_gtdoor',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = { 'judge', 'police' },
            CitizenId = {},
            Business = {},
        },
    },
    {
        Info = 'PRISON_TOWER_DOOR_07',
        Coords = vector3(1650.71, 2754.75, 45.40),
        Model = 'v_ilev_gtdoor',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = { 'judge', 'police' },
            CitizenId = {},
            Business = {},
        },
    },
    {
        Info = 'PRISON_TOWER_DOOR_08',
        Coords = vector3(1772.37, 2759.32, 45.40),
        Model = 'v_ilev_gtdoor',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = { 'judge', 'police' },
            CitizenId = {},
            Business = {},
        },
    },
    {
        Info = 'PRISON_TOWER_DOOR_09',
        Coords = vector3(1845.23, 2699.18, 45.53),
        Model = 'v_ilev_gtdoor',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = { 'judge', 'police' },
            CitizenId = {},
            Business = {},
        },
    },
    {
        Info = 'PRISON_TOWER_DOOR_10',
        Coords = vector3(1820.32, 2621.43, 45.40),
        Model = 'v_ilev_gtdoor',
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = { 'judge', 'police' },
            CitizenId = {},
            Business = {},
        },
    },

    -- Jewelry
    {
        Info = 'JEWELRY_DOOR_LEFT',
        Coords = vector3(-631.9554, -236.3333, 38.20653),
        Model = 'p_jewel_door_l',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = { 'JEWELRY_DOOR_RIGHT' },
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'JEWELRY_DOOR_RIGHT',
        Coords = vector3(-630.4265, -238.4376, 38.20653),
        Model = 'p_jewel_door_r1',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = { 'JEWELRY_DOOR_LEFT' },
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {},
        }
    },
    
    -- Banks
    {
        Info = 'LEGION_SQUARE_BANK_GATE',
        Coords = vector3(149.89, -1047.29, 29.34),
        Model = 'v_ilev_gb_vaubar',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        CanLockpick = true,
        Connected = {},
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'BURTON_BANK_GATE',
        Coords = vector3(-351.19, -56.54, 49.01),
        Model = 'v_ilev_gb_vaubar',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        CanLockpick = true,
        Connected = {},
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'PINK_MOTEL_BANK_GATE',
        Coords = vector3(314.61, -285.82, 54.49),
        Model = 'v_ilev_gb_vaubar',
        Locked = 1,
        IsGate = false,
        CanLockpick = true,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'LIFEINVADER_BANK_GATE',
        Coords = vector3(-1207.37, -335.08, 37.75),
        Model = 'v_ilev_gb_vaubar',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        CanLockpick = true,
        Connected = {},
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'GREATOCEANHWY_BANK_GATE',
        Coords = vector3(-2956.04, 484.66, 15.67),
        Model = 'v_ilev_gb_vaubar',
        Locked = 1,
        CanLockpick = true,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'SANDYSHORES_BANK_GATE',
        Coords = vector3(1173.07, 2712.74, 38.06),
        Model = 'v_ilev_gb_vaubar',
        Locked = 1,
        IsGate = false,
        CanLockpick = true,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {},
        }
    },
    
    -- Humane Labs
    {
        Info = 'HUMANELABS_ONDERWATER',
        Coords = vector3(3525.23, 3702.40, 20.99),
        Model = 'v_ilev_bl_doorpool',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'HUMANELABS_GARAGE_DEUR',
        Coords = vector3(3620.97, 3751.71, 28.69),
        Model = 'v_ilev_bl_shutter2',
        Locked = 1,
        IsGate = true,
        CanDetcord = false,
        Connected = { 'HUMANELABS_GARAGE_DEUR_2' },
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'HUMANELABS_GARAGE_DEUR_2',
        Coords = vector3(3628.11, 3746.92, 28.69),
        Model = 'v_ilev_bl_shutter2',
        Locked = 1,
        IsGate = true,
        CanDetcord = false,
        Connected = { 'HUMANELABS_GARAGE_DEUR' },
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {},
        }
    },
    
    -- Bay City
    {
        Info = 'BAYCITY_STAFF_DOOR',
        Coords = vector3(-1305.95, -820.79, 17.15),
        Model = -222270721,
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'BAYCITY_VAULT_DOOR_INSIDE',
        Coords = vector3(-1307.53, -813.91, 17.15),
        Model = -1508355822,
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {},
        }
    },

    
    -- Bobcat Security
    {
        Info = 'BOBCAT_MAIN_1',
        Coords = vector3(883.29, -2257.94, 30.54),
        Model = -1259801187,
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = { 'BOBCAT_MAIN_2' },
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'BOBCAT_MAIN_2',
        Coords = vector3(881.01, -2257.83, 30.54),
        Model = -1563799200,
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = { 'BOBCAT_MAIN_1' },
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'BOBCAT_MAIN_3',
        Coords = vector3(881.79, -2264.25, 30.47),
        Model = 'v_ilev_cd_door2',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        CanLockpick = true,
        Connected = {},
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'BOBCAT_MAIN_4',
        Coords = vector3(879.86, -2267.73, 30.47),
        Model = 'v_ilev_ss_door03',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = { 'BOBCAT_MAIN_5' },
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'BOBCAT_MAIN_5',
        Coords = vector3(882.82, -2268.0, 30.47),
        Model = 'v_ilev_ss_door03',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = { 'BOBCAT_MAIN_4' },
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {},
        }
    },

    -- Yacht
    {
        Info = 'YACHT_VAULT_DOOR',
        Coords = vector3(-2071.77, -1018.71, 3.05),
        Model = 'ch_prop_ch_vault_d_door_01a',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {},
        }
    },

    -- Paleto
    {
        Info = 'PALETO_VAULT_DOOR',
        Coords = vector3(-100.61, 6464.7, 31.63),
        Model = 'ch_prop_ch_vault_d_door_01a',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {},
        }
    },
    {
        Info = 'PALETO_HALL_TO_SECURITY',
        Coords = vector3(-92.56, 6469.26, 31.65),
        Model = 'xm_prop_iaa_base_door_01',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = {},
        }
    },
    
    -- Secret Doctor
    {
        Info = 'SECRET_DOCTER_DOOR',
        Coords = vector3(570.9839, 2672.325, 41.0426),
        Model = 'doctor_doors2',
        Locked = 1,
        IsGate = false,
        CanDetcord = false,
        Connected = {},
        Access = {
            Job = { 'police', 'judge' },
            CitizenId = {},
            Business = { 'Onderwereld Dokter' },
        }
    },
    
    -- Business | Sakurai
    {
        Info = 'ROOSTER_BACK_DOOR_LEFT',
        Coords = vector3(-177.91, 313.41, 97.99),
        Model = 1507503102,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = { 'ROOSTER_BACK_DOOR_RIGHT' },
        Access = {
            Job = {},
            CitizenId = {},
            Business = { "Sakurai" },
        }
    },
    {
        Info = 'ROOSTER_BACK_DOOR_RIGHT',
        Coords = vector3(-177.93, 315.23, 97.99),
        Model = 1641293839,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = { 'ROOSTER_BACK_DOOR_LEFT' },
        Access = {
            Job = {},
            CitizenId = {},
            Business = { "Sakurai" },
        }
    },
    {
        Info = 'ROOSTERS_TO_BENCH',
        Coords = vector3(-162.62, 320.92, 98.87),
        Model = 1971752884,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { "Sakurai" },
        }
    },
    {
        Info = 'ROOSTERS_TO_DOWNSTAIRS',
        Coords = vector3(-171.69, 319.51, 93.76),
        Model = 1971752884,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { "Sakurai" },
        }
    },
    {
        Info = 'ROOSTERS_TO_OFFICE',
        Coords = vector3(-178.4, 306.44, 97.4),
        Model = 1971752884,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = {},
        Access = {
            Job = {},
            CitizenId = {},
            Business = { "Sakurai" },
        }
    },
    {
        Info = 'ROOSTERS_FRONT_LEFT',
        Coords = vector3(-150.6, 295.39, 98.87),
        Model = 1773345779,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = { 'ROOSTERS_FRONT_RIGHT' },
        Access = {
            Job = {},
            CitizenId = {},
            Business = { "Sakurai" },
        }
    },
    {
        Info = 'ROOSTERS_FRONT_RIGHT',
        Coords = vector3(-152.73, 295.59, 98.87),
        Model = -574290911,
        Locked = 1,
        IsGate = false,
        CanDetcord = true,
        Connected = { 'ROOSTERS_FRONT_LEFT' },
        Access = {
            Job = {},
            CitizenId = {},
            Business = { "Sakurai" },
        }
    },
    -- Casino
    {
        Info = "casino_main_1",
        Coords = vector3(927.37, 49.04, 81.10),
        Model = 'vw_prop_vw_casino_door_02a',
        Locked = 1, -- True
        IsGate = false,
        CanDetcord = true,
        Access = {
            Job = {},
            CitizenId = {},
            Business = {'Diamond Casino'}
        },
    },
    {
        Info = "casino_main_1",
        Coords = vector3(926.77, 48.19, 81.1),
        Model = 'vw_prop_vw_casino_door_02a',
        Locked = 1, -- True
        IsGate = false,
        CanDetcord = true,
        Access = {
            Job = {},
            CitizenId = {},
            Business = {'Diamond Casino'}
        },
    },
    {
        Info = "casino_main_2",
        Coords = vector3(925.91, 46.56, 81.1),
        Model = 'vw_prop_vw_casino_door_02a',
        Locked = 1, -- True
        IsGate = false,
        CanDetcord = true,
        Access = {
            Job = {},
            CitizenId = {},
            Business = {'Diamond Casino'}
        },
    },
    {
        Info = "casino_main_2",
        Coords = vector3(925.21, 45.69, 81.1),
        Model = 'vw_prop_vw_casino_door_02a',
        Locked = 1, -- True
        IsGate = false,
        CanDetcord = true,
        Access = {
            Job = {},
            CitizenId = {},
            Business = {'Diamond Casino'}
        },
    },
    {
        Info = "casino_main_3",
        Coords = vector3(924.43, 44.22, 81.1),
        Model = 'vw_prop_vw_casino_door_02a',
        Locked = 1, -- True
        IsGate = false,
        CanDetcord = true,
        Access = {
            Job = {},
            CitizenId = {},
            Business = {'Diamond Casino'}
        },
    },
    {
        Info = "casino_main_3",
        Coords = vector3(923.78, 43.3, 81.1),
        Model = 'vw_prop_vw_casino_door_02a',
        Locked = 1, -- True
        IsGate = false,
        CanDetcord = true,
        Access = {
            Job = {},
            CitizenId = {},
            Business = {'Diamond Casino'}
        },
    },
    {
        Info = "casino_man",
        Coords = vector3(1018.43, 66.63, 69.86),
        Model = 'vw_prop_vw_casino_door_01a',
        Locked = 1, -- True
        IsGate = false,
        CanDetcord = true,
        Access = {
            Job = {},
            CitizenId = {},
            Business = {'Diamond Casino'}
        },
    },
    {
        Info = "casino_man",
        Coords = vector3(1017.96, 65.93, 69.86),
        Model = 'vw_prop_vw_casino_door_01a',
        Locked = 1, -- True
        IsGate = false,
        CanDetcord = true,
        Access = {
            Job = {},
            CitizenId = {},
            Business = {'Diamond Casino'}
        },
    },
    {
        Info = "casino_gates_1",
        Coords = vector3(1000.84, 44.37, 71.06),
        Model = 'vw_vwint_01_gate_slide',
        Locked = 1, -- True
        IsGate = false,
        CanDetcord = true,
        Access = {
            Job = {},
            CitizenId = {},
            Business = {'Diamond Casino'}
        },
    },
    {
        Info = "casino_gates_2",
        Coords = vector3(1000.74, 44.93, 71.06),
        Model = 'vw_vwint_01_gate_slide',
        Locked = 1, -- True
        IsGate = false,
        CanDetcord = true,
        Access = {
            Job = {},
            CitizenId = {},
            Business = {'Diamond Casino'}
        },
    },

    {
        Info = "casino_hotel_service_1",
        Coords = vector3(900.5447, -65.38408, 21.15001),
        Model = -192278810,
        Locked = 1, -- True
        IsGate = false,
        CanDetcord = true,
        Access = {
            Job = {},
            CitizenId = {},
            Business = {'Diamond Casino'}
        },
    },

    {
        Info = "casino_hotel_service_2",
        Coords = vector3(901.5468, -63.7706, 21.15001),
        Model = -192278810,
        Locked = 1, -- True
        IsGate = false,
        CanDetcord = true,
        Access = {
            Job = {},
            CitizenId = {},
            Business = {'Diamond Casino'}
        },
    },

    {
        Info = "casino_hotel_service_3",
        Coords = vector3(883.7767, -50.52394, 21.14943),
        Model = -170420121,
        Locked = 1, -- True
        IsGate = false,
        CanDetcord = true,
        Access = {
            Job = {},
            CitizenId = {},
            Business = {'Diamond Casino'}
        },
    },

    {
        Info = "casino_hotel_service_4",
        Coords = vector3(882.7746, -52.13742, 21.14943),
        Model = 1090039464,
        Locked = 1, -- True
        IsGate = false,
        CanDetcord = true,
        Access = {
            Job = {},
            CitizenId = {},
            Business = {'Diamond Casino'}
        },
    },

}

Config.Elevators = {
    VBPD = {
        VBPD_Cells = {
            Locked = false,
            IdName = "VBPD_Cells",
            Name = 'Cells',
            Desc = 'You can dump the criminals here.',
            Coords = vector4(-1092.3, -848.39, 13.53, 306.71),
            Access = {
                Job = { 'police', 'ems', 'judge' },
                CitizenId = {},
                Business = {}
            },
        },
        VBPD_Hall = {
            Locked = false,
            IdName = "VBPD_Hall",
            Name = 'Ground Floor',
            Desc = 'The ground floor.',
            Coords = vector4(-1098.39, -829.8, 19.3, 307.55),
            Access = {
                Job = { 'police', 'ems', 'judge' },
                CitizenId = {},
                Business = {}
            },
        },
        VBPD_Garage = {
            Locked = false,
            IdName = "VBPD_Garage",
            Name = 'Garage',
            Desc = 'Here you can park your vehicle.',
            Coords = vector4(-1158.75, -857.02, 3.75, 304.43),
            Access = {
                Job = { 'police', 'ems', 'judge' },
                CitizenId = {},
                Business = {}
            },
        },
    },
    VICE_HOSPITAL = {
        VICE_HOSPITAL_Hospital = {
            Locked = false,
            IdName = "VICE_HOSPITAL_Hospital",
            Name = 'Ground Floor',
            Desc = 'The ground floor.',
            Coords = vector4(-798.2, -1249.99, 7.34, 49.83),
            Access = {
                Job = { 'police', 'ems', 'judge' },
                CitizenId = {},
                Business = {}
            },
        },
        VICE_HOSPITAL_Roof = {
            Locked = false,
            IdName = "VICE_HOSPITAL_Roof",
            Name = 'Roof',
            Desc = 'The roof, where there is a helipad.',
            Coords = vector4(-773.54, -1207.13, 51.15, 316.91),
            Access = {
                Job = { 'police', 'ems', 'judge' },
                CitizenId = {},
                Business = {}
            },
        },
    },
    -- CRUSADE_HOSP = {
    --     CRUSADE_HOSP_Hospital = {
    --         Locked = false,
    --         IdName = "CRUSADE_HOSP_Hospital",
    --         Name = 'Ground Floor',
    --         Desc = 'The ground floor.',
    --         Coords = vector4(346.23, -1410.0, 32.51, 51.41),
    --         Access = {
    --             Job = { 'police', 'ems', 'judge' },
    --             CitizenId = {},
    --             Business = {}
    --         },
    --     },
    --     CRUSADE_HOSP_Roof = {
    --         Locked = false,
    --         IdName = "CRUSADE_HOSP_Roof",
    --         Name = 'Roof',
    --         Desc = 'The roof, where there is a helipad.',
    --         Coords = vector4(342.43, -1425.77, 46.51, 136.39),
    --         Access = {
    --             Job = { 'police', 'ems', 'judge' },
    --             CitizenId = {},
    --             Business = {}
    --         },
    --     },
    --     CRUSADE_HOSP_Garage = {
    --         Locked = false,
    --         IdName = "CRUSADE_HOSP_Garage",
    --         Name = 'Garage',
    --         Desc = 'Here you can take a vehicle.',
    --         Coords = vector4(322.19, -1423.87, 29.92, 142.35),
    --         Access = {
    --             Job = { 'police', 'ems', 'judge' },
    --             CitizenId = {},
    --             Business = {}
    --         },
    --     },
    --     CRUSADE_HOSP_Morgue = {
    --         Locked = true,
    --         IdName = "CRUSADE_HOSP_Morgue",
    --         Name = 'Mortuary',
    --         Desc = 'Spooky scary skeleton..',
    --         Coords = vector4(279.59, -1349.47, 24.54, 322.82), 
    --         Access = {
    --             Job = { 'ems', 'police' },
    --             CitizenId = {},
    --             Business = {}
    --         },
    --     },
    -- },
    WEAZELNEWS = {
        WEAZELNEWS_Main = {
            Locked = false,
            IdName = "WEAZELNEWS_Main",
            Name = 'Ground Floor',
            Desc = 'The Ground Floor.',
            Coords = vector4(-576.21, -920.43, 23.78, 95.82),
            Access = {
                Job = { 'police', 'ems', 'judge' },
                CitizenId = {},
                Business = { 'Weazel News' }
            },
        },
        WEAZELNEWS_Offices = {
            Locked = false,
            IdName = "WEAZELNEWS_Offices",
            Name = 'Office Spaces',
            Desc = 'All I hear is click clack..',
            Coords = vector4(-571.99, -923.8, 30.32, 91.85),
            Access = {
                Job = { 'police', 'ems', 'judge' },
                CitizenId = {},
                Business = { 'Weazel News' }
            },
        },
        WEAZELNEWS_Roof = {
            Locked = false,
            IdName = "WEAZELNEWS_Roof",
            Name = 'Roof',
            Desc = 'Is it time for some helicopter shots?',
            Coords = vector4(-568.77, -927.64, 36.79, 89.07),
            Access = {
                Job = { 'police', 'ems', 'judge' },
                CitizenId = {},
                Business = { 'Weazel News' }
            },
        },
    },

    CASINO = {
        Casino_Casino = {
            Locked = false,
            IdName = "Casino_Casino",
            Name = 'Casino',
            Desc = 'Spend all your money bwo.',
            Coords = vector4(960.24, 43.23, 71.7, 276.64),
            Access = {
                Job = {},
                CitizenId = {},
                Business = { 'Diamond Casino' }
            },
        },
        Casino_Penthouse = {
            Locked = true,
            IdName = "Casino_Penthouse",
            Name = 'Penthouse',
            Desc = 'My house, My Penthouse!',
            Coords = vector4(983.05, 56.66, 116.16, 148.52), 
            Access = {
                Job = {},
                CitizenId = {},
                Business = { 'Diamond Casino' }
            },
        },
        Casino_Roof = {
            Locked = false,
            IdName = "Casino_Roof",
            Name = 'Rooftop',
            Desc = 'Oh is it cold outside?',
            Coords = vector4(964.86, 58.67, 112.55, 60.93), 
            Access = {
                Job = {},
                CitizenId = {},
                Business = { 'Diamond Casino' }
            },
        },
        Casino_Hotel = {
            Locked = false,
            IdName = "Casino_Hotel",
            Name = 'Hotel',
            Desc = 'I need a room for the night!',
            Coords = vector4(913.87, -54.54, 21.0, 148.61), 
            Access = {
                Job = {},
                CitizenId = {},
                Business = { 'Diamond Casino' }
            },
        },
        Casino_Office = {
            Locked = true,
            IdName = "Casino_Office",
            Name = 'Office',
            Desc = 'Managment please!',
            Coords = vector4(994.13, 56.1, 75.06, 238.48), 
            Access = {
                Job = {},
                CitizenId = {},
                Business = { 'Diamond Casino' }
            },
        }

    },
    RECYCLE_CENTRE = {
        RECYCLE_CENTRE_Inside = {
            Locked = false,
            IdName = "RECYCLE_CENTRE_Inside",
            Name = 'Recycle Center',
            Desc = 'Lovely recycling, never been so eager to clean up anything before.',
            Coords = vector4(992.48, -3097.82, -39.0, 270.2),
            Access = {
                Job = {},
                CitizenId = {},
                Business = {},
            },
        },
        RECYCLE_CENTRE_Outside = {
            Locked = false,
            IdName = "RECYCLE_CENTRE_Outside",
            Name = 'Outside',
            Desc = 'Where the birds are whistling. 🐦',
            Coords = vector4(55.81, 6472.03, 31.43, 227.18),
            Access = {
                Job = {},
                CitizenId = {},
                Business = {},
            },
        },
    },
}

Config.ElevatorZones = {
    CASINO = {
        [1] = {
            IdName = "Casino_Casino",
            Coords = vector3(960.14, 42.29, 71.7),
            Data = {
                Heading = 17.0,
                Length = 0.15,
                Width = 0.15,
                MinZ = 71.75,
                MaxZ = 72.05,
            },
        },
        [2] = {
            IdName = "Casino_Penthouse",
            Coords = vector3(982.47, 57.23, 116.16),
            Data = {
                Heading = 331.0,
                Length = 0.1,
                Width = 0.15,
                MinZ = 116.21,
                MaxZ = 116.56,
            },
        },
        [3] = {
            IdName = "Casino_Roof",
            Coords = vector3(964.49, 57.53, 112.55),
            Data = {
                Heading = 58.0,
                Length = 0.1,
                Width = 0.15,
                MinZ = 112.35,
                MaxZ = 112.75,
            },
        },
        [4] = {
            IdName = "Casino_Office",
            Coords = vector3(993.36, 55.53, 75.06),
            Data = {
                Heading = 328.0,
                Length = 0.15,
                Width = 0.05,
                MinZ = 75.11,
                MaxZ = 75.41,
            },
        },
        [5] = {
            IdName = "Casino_Hotel",
            Coords =  vector3(913.29, -54.07, 21.0),
            Data = {
                Heading = 330.0,
                Length = 0.2,
                Width = 0.2,
                MinZ = 21.0,
                MaxZ = 21.4,
            },
        },
    },
    VBPD = {
        [1] = {
            IdName = "VBPD_Cells",
            Coords = vector3(-1090.38, -847.92, 13.52),
            Data = {
                Heading = 40.0,
                Length = 0.2,
                Width = 0.2,
                MinZ = 13.52,
                MaxZ = 13.92,
            },
        },
        [2] = {
            IdName = "VBPD_Hall",
            Coords = vector3(-1096.52, -829.34, 19.3),
            Data = {
                Heading = 40.0,
                Length = 0.2,
                Width = 0.2,
                MinZ = 19.3,
                MaxZ = 19.7,
            },
        },
        [3] = {
            IdName = "VBPD_Garage",
            Coords = vector3(-1157.05, -857.08, 3.75),
            Data = {
                Heading = 35.0,
                Length = 0.4,
                Width = 0.2,
                MinZ = 3.6,
                MaxZ = 4.2,
            },
        },
    },
    VICE_HOSPITAL = {
        [1] = {
            IdName = "VICE_HOSPITAL_Roof",
            Coords = vector3(-775.6, -1207.0, 51.15),
            Data = {
                Heading = 49.0,
                Length = 0.2,
                Width = 0.2,
                MinZ = 51.3,
                MaxZ = 51.7, 
            },
        },
        [2] = {
            IdName = "VICE_HOSPITAL_Hospital",
            Coords = vector3(-798.45, -1251.76, 7.34),
            Data = {
                Heading = 48.0,
                Length = 0.2,
                Width = 0.2,
                MinZ = 7.49,
                MaxZ = 7.89, 
            },
        },
    },
    -- CRUSADE_HOSP = {
    --     [1] = {
    --         IdName = "CRUSADE_HOSP_Hospital",
    --         Coords = vector3(345.61, -1408.21, 32.51),
    --         Data = {
    --             Heading = 320,
    --             Length = 0.3,
    --             Width = 0.2,
    --             MinZ = 32.11,
    --             MaxZ = 33.36
    --         },
    --     },
    --     [2] = {
    --         IdName = "CRUSADE_HOSP_Roof",
    --         Coords = vector3(340.41, -1426.56, 46.51),
    --         Data = {
    --             Heading = 50,
    --             Length = 0.3,
    --             Width = 0.2,
    --             MinZ = 46.06,
    --             MaxZ = 47.41
    --         },
    --     },
    --     [3] = {
    --         IdName = "CRUSADE_HOSP_Garage",
    --         Coords = vector3(320.62, -1424.45, 29.92),
    --         Data = {
    --             Heading = 50,
    --             Length = 0.3,
    --             Width = 0.2,
    --             MinZ = 29.47,
    --             MaxZ = 30.82
    --         },
    --     },
    --     [4] = {
    --         IdName = "CRUSADE_HOSP_Morgue",
    --         Coords = vector3(278.29, -1348.76, 24.54),
    --         Data = {
    --             Heading = 50.0,
    --             Length = 0.25,
    --             Width = 0.05,
    --             MinZ = 24.54,
    --             MaxZ = 24.94,
    --         },
    --     },
    -- },
    WEAZELNEWS = {
        [1] = {
            IdName = "WEAZELNEWS_Main",
            Coords = vector3(-575.52, -919.21, 23.78),
            Data = {
                Heading = 0,
                Length = 0.25,
                Width = 0.15,
                MinZ = 23.78,
                MaxZ = 24.18
            },
        },
        [2] = {
            IdName = "WEAZELNEWS_Offices",
            Coords = vector3(-571.52, -922.64, 30.32),
            Data = {
                Heading = 0,
                Length = 0.25,
                Width = 0.15,
                MinZ = 30.32,
                MaxZ = 30.72
            },
        },
        [3] = {
            IdName = "WEAZELNEWS_Roof",
            Coords = vector3(-568.31, -927.12, 36.79),
            Data = {
                Heading = 0,
                Length = 0.5,
                Width = 0.5,
                MinZ = 36.84,
                MaxZ = 37.29
            },
        },
    },
    RECYCLE_CENTRE = {
        [1] = {
            IdName = "RECYCLE_CENTRE_Inside",
            Coords = vector3(992.1, -3097.81, -39.0),
            Data = {
                Length = 1.2,
                Width = 0.4,
                Heading = 0,
                MinZ = -40.0,
                MaxZ = -37.8
            },
        },
        [2] = {
            IdName = "RECYCLE_CENTRE_Outside",
            Coords = vector3(55.54, 6472.36, 31.43),
            Data = {
                Length = 4.8,
                Width = 0.8,
                Heading = 315,
                MinZ = 30.43,
                MaxZ = 34.43
            },
        },
    },
}