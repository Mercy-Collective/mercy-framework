Config = Config or {}

Config.SavedDuiData, Config.DuiLinks = {}, {}

Config.Density = {
    ['Vehicle'] = 0.55,
    ['Parked'] = 0.80,
    ['Peds'] = 0.55,
    ['Scenarios'] = 0.55,
}

Config.Effects = {
	['Puke'] = {
		['Scale'] = 1.0,
		['Bone'] = 31086,
		['Anim'] = 'puking',
		['EffectDict'] = "scr_familyscenem",
		['EffectName'] = "scr_trev_puke",
	}
}

Config.DiscordSettings = {
    ['AppId'] = 1234,
    ['Text'] = 'Mercy Collective',
}

Config.BlacklistedScenarios = {
    ['TYPES'] = {
        "WORLD_VEHICLE_MILITARY_PLANES_SMALL",
        "WORLD_VEHICLE_MILITARY_PLANES_BIG",
    },
    ['GROUPS'] = {
        2017590552,
        2141866469,
        1409640232,
        GetHashKey('ng_planes'),
    }
}

Config.BlacklistedEntitys = {
	-- Vehicles
    [GetHashKey('SHAMAL')] = true,
    [GetHashKey('LUXOR')] = true,
    [GetHashKey('LUXOR2')] = true,
    [GetHashKey('JET')] = true,
    [GetHashKey('LAZER')] = true,
    [GetHashKey('BUZZARD')] = true,
    [GetHashKey('BUZZARD2')] = true,
    [GetHashKey('ANNIHILATOR')] = true,
    [GetHashKey('SAVAGE')] = true,
    [GetHashKey('TITAN')] = true,
    [GetHashKey('RHINO')] = true,
    [GetHashKey('POLICE')] = true,
    [GetHashKey('POLICE2')] = true,
    [GetHashKey('POLICE3')] = true,
    [GetHashKey('POLICE4')] = true,
    [GetHashKey('POLICEB')] = true,
    [GetHashKey('POLICET')] = true,
    [GetHashKey('SHERIFF')] = true,
    [GetHashKey('SHERIFF2')] = true,
    [GetHashKey('FIRETRUK')] = true,
    [GetHashKey('AMBULANCE')] = true,
    [GetHashKey('MULE')] = true,
    [GetHashKey('POLMAV')] = true,
    [GetHashKey('MAVERICK')] = true,
    [GetHashKey('BLIMP')] = true,
    [GetHashKey('CARGOBOB')] = true,   
    [GetHashKey('CARGOBOB2')] = true,   
    [GetHashKey('CARGOBOB3')] = true,   
    [GetHashKey('CARGOBOB4')] = true,
    [GetHashKey('BESRA')] = true,
    [GetHashKey('SWIFT')] = true,
    [GetHashKey('FROGGER')] = true,
    [GetHashKey('HYDRA')] = true,
	-- Peds
	[GetHashKey('s_m_y_ranger_01')] = true,
    [GetHashKey('s_m_y_sheriff_01')] = true,
    [GetHashKey('s_m_y_cop_01')] = true,
    [GetHashKey('s_f_y_sheriff_01')] = true,
    [GetHashKey('s_f_y_cop_01')] = true,
    [GetHashKey('s_m_y_hwaycop_01')] = true,
	[GetHashKey('g_m_y_lost_01')] = true,
    [GetHashKey('s_m_m_prisguard_01')] = true,
    [GetHashKey('s_m_y_prismuscl_01')] = true,
    [GetHashKey('u_m_y_prisoner_01')] = true,
    [GetHashKey('s_m_y_prisoner_01')] = true,
}

Config.PropList = {
	['Megaphone'] = {
		["Model"] = "prop_megaphone_01",
    	["Bone"] = 28422,
    	["X"] = 0.04,
    	["Y"] = -0.01,
    	["Z"] = 0.0,
    	["XR"] = 22.0,
    	["YR"] = -4.0,
    	["ZR"] = 87.0,
    	["VertexIndex"] = 0
	},
	['Walkie'] = {
		["Model"] = "prop_cs_hand_radio",
    	["Bone"] = 28422,
    	["X"] = 0.0,
    	["Y"] = 0.0,
    	["Z"] = 0.0,
    	["XR"] = 0.0,
    	["YR"] = 0.0,
    	["ZR"] = 0.0,
    	["VertexIndex"] = 0
	},
	['Phone'] = {
		["Model"] = "prop_npc_phone_02",
		["Bone"] = 28422,
		["X"] = 0.0,
		["Y"] = 0.0,
		["Z"] = 0.0,
		["XR"] = 0.0,
		["YR"] = 0.0,
		["ZR"] = 0.0,
    	["VertexIndex"] = 0
	},
	-- ['Box'] = {
	-- 	["Model"] = "prop_cs_cardbox_01",
	-- 	["Bone"] = 57005,
	-- 	['X'] = 0.05,
	-- 	['Y'] = 0.1,
	-- 	['Z'] = -0.3,
	-- 	['XR'] = 300.0,
	-- 	['YR'] = 250.0,
	-- 	['ZR'] = 20.0,
    -- 	["VertexIndex"] = 0
	-- },
	['Drill'] = {
		["Model"] = "hei_prop_heist_drill",
		["Bone"] = 57005,
		['X'] = 0.14,
		['Y'] = 0.0,
		['Z'] = -0.01,
		['XR'] = 90.0,
		['YR'] = -90.0,
		['ZR'] = 180.0,
		["VertexIndex"] = 0
	},
	['Duffel'] = {
		["Model"] = "xm_prop_x17_bag_01a",
		["Bone"] = 28422,
		['X'] = 0.27,
		['Y'] = 0.15,
		['Z'] = 0.05,
		['XR'] = 35.0,
		['YR'] = -125.0,
		['ZR'] = 50.0,
		["VertexIndex"] = 0
	},
	['Trash'] = {
		["Model"] = "prop_cs_rub_binbag_01",
		["Bone"] = 57005,
		['X'] = 0.12,
		['Y'] = 0.0,
		['Z'] = -0.05,
		['XR'] = 220.0,
		['YR'] = 120.0,
		['ZR'] = 0.0,
    	["VertexIndex"] = 0
	},
	['Boombox'] = {
		["Model"] = "prop_boombox_01",
		["Bone"] = 1,
		['X'] = 1,
		['Y'] = 1,
		['Z'] = 1,
		['XR'] = 1,
		['YR'] = 1,
		['ZR'] = 1,
    	["VertexIndex"] = 0
	},
	['Pills'] = {
		["Model"] = "prop_cs_pills",
		["Bone"] = 1,
		['X'] = 1,
		['Y'] = 1,
		['Z'] = 1,
		['XR'] = 1,
		['YR'] = 1,
		['ZR'] = 1,
    	["VertexIndex"] = 0
	},
	['ShoppingBag'] = {
		["Model"] = "prop_shopping_bags01",
		["Bone"] = 28422,
		['X'] = 0.05,
		['Y'] = 0.0,
		['Z'] = 0.0,
		['XR'] = 35.0,
		['YR'] = -125.0,
		['ZR'] = 0.0,
    	["VertexIndex"] = 0
	},
	['CrackPipe'] = {
		["Model"] = "prop_cs_crackpipe",
		["Bone"] = 28422,
		['X'] = 0.0,
		['Y'] = 0.05,
		['Z'] = 0.0,
		['XR'] = 135.0,
		['YR'] = -100.0,
		['ZR'] = 0.0,
    	["VertexIndex"] = 0
	},
	['Bong'] = {
		["Model"] = "prop_bong_01",
		["Bone"] = 18905,
		['X'] = 0.11,
		['Y'] = -0.23,
		['Z'] = 0.01,
		['XR'] = -90.0,
		['YR'] = 0.0,
		['ZR'] = 0.0,
    	["VertexIndex"] = 0
	},
	['HealthPack'] = {
		["Model"] = "prop_ld_health_pack",
		["Bone"] = 18905,
		['X'] = 0.15,
		['Y'] = 0.08,
		['Z'] = 0.1,
		['XR'] = 180.0,
		['YR'] = 220.0,
		['ZR'] = 0.0,
    	["VertexIndex"] = 0
	},
	['ReporterCam'] = {
		["Model"] = "prop_v_cam_01",
		["Bone"] = 57005,
		['X'] = 0.13,
		['Y'] = 0.25,
		['Z'] = -0.03,
		['XR'] = -85.0,
		['YR'] = 0.0,
		['ZR'] = -80.0,
    	["VertexIndex"] = 0
	},
	['ReporterMic'] = {
		["Model"] = "p_ing_microphonel_01",
		["Bone"] = 18905,
		['X'] = 0.1,
		['Y'] = 0.05,
		['Z'] = 0.0,
		['XR'] = -85.0,
		['YR'] = -80.0,
		['ZR'] = -80.0,
    	["VertexIndex"] = 0
	},
	['BriefCase'] = {
		["Model"] = "prop_security_case_01",
		["Bone"] = 57005,
		['X'] = 0.1,
		['Y'] = 0.0,
		['Z'] = 0.0,
		['XR'] = 0.0,
		['YR'] = 280.0,
		['ZR'] = 53.0,
    	["VertexIndex"] = 0
	},
	['GunCase'] = {
		["Model"] = "prop_box_guncase_01a",
		["Bone"] = 28422,
		['X'] = 0.18,
		['Y'] = 0.05,
		['Z'] = 0.0,
		['XR'] = 215.0,
		['YR'] = -175.0,
		['ZR'] = 100.0,
    	["VertexIndex"] = 0
	},
	['DarkmarketBox'] = {
		["Model"] = "prop_idol_case_01",
		["Bone"] = 28422,
		['X'] = 0.01,
		['Y'] = -0.02,
		['Z'] = -0.22,
		['XR'] = 0.0,
		['YR'] = 0.0,
		['ZR'] = 0.0,
    	["VertexIndex"] = 0
	},
	['StolenTv'] = {
		["Model"] = "prop_tv_flat_02",
		["Bone"] = 57005,
		['X'] = 0.15,
		['Y'] = 0.10,
		['Z'] = -0.20,
		['XR'] = -50.0,
		['YR'] = 250.0,
		['ZR'] = 10.0,
    	["VertexIndex"] = 0
	},
	['StolenPc'] = {
		["Model"] = "prop_dyn_pc_02",
		["Bone"] = 57005,
		['X'] = 0.15,
		['Y'] = 0.10,
		['Z'] = -0.22,
		['XR'] = -80.0,
		['YR'] = -15.0,
		['ZR'] = -60.0,
    	["VertexIndex"] = 0
	},
	['StolenMicro'] = {
		["Model"] = "prop_microwave_1",
		["Bone"] = 57005,
		['X'] = 0.30,
		['Y'] = 0.15,
		['Z'] = -0.20,
		['XR'] = -50.0,
		['YR'] = 250.0,
		['ZR'] = 10.0,
    	["VertexIndex"] = 0
	},
	['Laplet'] = {
		["Model"] = "hei_prop_dlc_tablet",
		["Bone"] = 60309,
		['X'] = 0.03,
		['Y'] = 0.002,
		['Z'] = -0.0,
		['XR'] = 0.0,
		['YR'] = 160.0,
		['ZR'] = 0.0,
    	["VertexIndex"] = 0
	},
	['FishingRod'] = {
		["Model"] = "prop_fishing_rod_01",
		["Bone"] = 60309,
		["X"] = 0.0,
		["Y"] = 0.0,
		["Z"] = 0.0,
		["XR"] = 0.0,
		["YR"] = 0.0,
		["ZR"] = 0.0,
    	["VertexIndex"] = 0
	},
	['TrashBag'] = {
		["Model"] = "prop_rub_binbag_sd_01",
		["Bone"] = 57005,
		["X"] = 0.45,
		["Y"] = -0.15,
		["Z"] = -0.2,
		["XR"] = 220.0,
		["YR"] = 120.0,
		["ZR"] = 0.0,
    	["VertexIndex"] = 0
	},
	['Pickaxe'] = {
		["Model"] = "prop_tool_pickaxe",
		["Bone"] = 57005,
		['X'] = 0.09,
		['Y'] = 0.03,
		['Z'] = -0.02,
		['XR'] = -78.0,
		['YR'] = 13.0,
		['ZR'] = 345.0,
    	["VertexIndex"] = 0
	},
	['Spray'] = {
		["Model"] = "prop_cs_spray_can",
		["Bone"] = 4089,
		['X'] = 0.0,
		['Y'] = 0.0,
		['Z'] = 0.035,
		['XR'] = 0.0,
		['YR'] = 100.0,
		['ZR'] = 0.0,
    	["VertexIndex"] = 0
	},
	['Scanner'] = {
		["Model"] = "metaldetector",
    	["Bone"] = 18905,
		['X'] = 0.13,
		['Y'] = 0.03,
		['Z'] = -0.03,
		['XR'] = -150.0,
		['YR'] = -10.0,
		['ZR'] = -10.0,
    	["VertexIndex"] = 0
	},
	['Clipboard'] = {
		["Model"] = "p_amb_clipboard_01",
    	["Bone"] = 18905,
		['X'] = 0.10,
		['Y'] = 0.02,
		['Z'] = 0.08,
		['XR'] = -80.0,
		['YR'] = 0.0,
		['ZR'] = 0.0,
    	["VertexIndex"] = 0
	},
	['WateringCan'] = {
		["Model"] = "prop_wateringcan",
    	["Bone"] = 57005,
    	["X"] = 0.32,
    	["Y"] = -0.07,
    	["Z"] = -0.1,
    	["XR"] = 211.5,
    	["YR"] = 65.5,
    	["ZR"] = 2.57,
    	["VertexIndex"] = 0
	},
	['SprayCan'] = {
		["Model"] = "ng_proc_spraycan01b",
    	["Bone"] = 57005,
    	["X"] = 0.072,
    	["Y"] = 0.041,
    	["Z"] = -0.06,
    	["XR"] = 33.0,
    	["YR"] = 38.0,
    	["ZR"] = 0.0,
    	["VertexIndex"] = 0
	},
	['ChargerNozzle'] = {
		["Model"] = "electric_nozzle",
    	["Bone"] = 18905,
    	["X"] = 0.24,
    	["Y"] = 0.10,
    	["Z"] = -0.052,
    	["XR"] = -45.0,
    	["YR"] = 120.0,
    	["ZR"] = 75.00,
    	["VertexIndex"] = 0
	},
	['FuelNozzle'] = {
		["Model"] = "prop_cs_fuel_nozle",
    	["Bone"] = 18905,
    	["X"] = 0.11,
    	["Y"] = 0.0,
    	["Z"] = 0.03,
    	["XR"] = -262.15,
    	["YR"] = 53.43,
    	["ZR"] = 162.29,
    	["VertexIndex"] = 0
	},
	['GoldPan'] = {
		["Model"] = "v_res_r_silvrtray",
    	["Bone"] = 14201,
    	["X"] = 0.6,
    	["Y"] = 0.1,
    	["Z"] = 0.2,
    	["XR"] = 60.0,
    	["YR"] = 90.0,
    	["ZR"] = 180.0,
    	["VertexIndex"] = 0
	},
	['Lawnchair'] = {
		["Model"] = "prop_skid_chair_02",
    	["Bone"] = 0,
    	["X"] = 0.0,
    	["Y"] = -0.12,
    	["Z"] = -0.16,
    	["XR"] = 5.0,
    	["YR"] = -1.0,
    	["ZR"] = -187.0,
    	["VertexIndex"] = 0
	},
	['PdBadge'] = {
		["Model"] = "prop_fib_badge",
    	["Bone"] = 28422,
    	["X"] = 0.0,
    	["Y"] = 0.0,
    	["Z"] = 0.0,
    	["XR"] = 0.0,
    	["YR"] = 0.0,
    	["ZR"] = 0.0,
    	["VertexIndex"] = 0
	},
	['HeistBag'] = {
		["Model"] = "prop_cs_heist_bag_02",
    	["Bone"] = 57005,
    	["X"] = -0.005,
    	["Y"] = 0.0,
    	["Z"] = -0.16,
    	["XR"] = 250.0,
    	["YR"] = -30.0,
    	["ZR"] = 0.0,
    	["VertexIndex"] = 0
	},
	['Box'] = {
		["Model"] = "hei_prop_heist_box",
    	["Bone"] = 60309,
		['X'] = 0.025,
		['Y'] = 0.08,
		['Z'] = 0.255,
		['XR'] = -145.0,
		['YR'] = 290.0,
		['ZR'] = 0.0,
    	["VertexIndex"] = 0
	},
	-- Food
	['Apple'] = {
		["Model"] = "ng_proc_food_aple2a",
    	["Bone"] = 18905,
		['X'] = 0.15,
		['Y'] = 0.09,
		['Z'] = 0.09,
		['XR'] = 180.0,
		['YR'] = 0.0,
		['ZR'] = -50.0,
    	["VertexIndex"] = 0
	},
	['Banana'] = {
		["Model"] = "ng_proc_food_nana1a",
    	["Bone"] = 18905,
		['X'] = 0.16,
		['Y'] = 0.02,
		['Z'] = 0.04,
		['XR'] = 160.0,
		['YR'] = 0.0,
		['ZR'] = -50.0,
    	["VertexIndex"] = 0
	},
	['Bread'] = {
		["Model"] = "prop_sandwich_01",
    	["Bone"] = 18905,
		['X'] = 0.13,
		['Y'] = 0.05,
		['Z'] = 0.02,
		['XR'] = -50.0,
		['YR'] = 16.0,
		['ZR'] = 60.0,
    	["VertexIndex"] = 0
	},
	['Chocolate'] = {
		["Model"] = "prop_choc_meto",
    	["Bone"] = 18905,
		['X'] = 0.13,
		['Y'] = 0.05,
		['Z'] = 0.02,
		['XR'] = -50.0,
		['YR'] = 16.0,
		['ZR'] = 60.0,
    	["VertexIndex"] = 0
	},
	['Donut'] = {
		["Model"] = "prop_amb_donut",
    	["Bone"] = 18905,
		['X'] = 0.13,
		['Y'] = 0.05,
		['Z'] = 0.02,
		['XR'] = -50.0,
		['YR'] = 16.0,
		['ZR'] = 60.0,
    	["VertexIndex"] = 0
	},
	['Taco'] = {
		["Model"] = "prop_taco_01",
    	["Bone"] = 18905,
		['X'] = 0.13,
		['Y'] = 0.07,
		['Z'] = 0.02,
		['XR'] = 160.0,
		['YR'] = 0.0,
		['ZR'] = -50.0,
    	["VertexIndex"] = 0
	},
	['Chips'] = {
		["Model"] = "ng_proc_food_chips01b",
    	["Bone"] = 18905,
		['X'] = 0.20,
		['Y'] = 0.07,
		['Z'] = 0.02,
		['XR'] = 220.0,
		['YR'] = 0.0,
		['ZR'] = -160.0,
    	["VertexIndex"] = 0
	},
	['Hamburger'] = {
		["Model"] = "prop_cs_burger_01",
    	["Bone"] = 18905,
		['X'] = 0.13,
		['Y'] = 0.07,
		['Z'] = 0.02,
		['XR'] = 120.0,
		['YR'] = 16.0,
		['ZR'] = 60.0,
    	["VertexIndex"] = 0
	},
	['MacnCheese'] = {
		["Model"] = "v_res_fa_potnoodle",
    	["Bone"] = 18905,
		['X'] = 0.13,
		['Y'] = 0.07,
		['Z'] = 0.02,
		['XR'] = 160.0,
		['YR'] = 0.0,
		['ZR'] = -160.0,
    	["VertexIndex"] = 0
	},
	['Fries'] = {
		["Model"] = "prop_food_bs_chips",
    	["Bone"] = 18905,
		['X'] = 0.12,
		['Y'] = 0.04,
		['Z'] = 0.05,
		['XR'] = 130.0,
		['YR'] = 8.0,
		['ZR'] = 200.0,
    	["VertexIndex"] = 0
	},
	-- Drinks
	['Water'] = {
		["Model"] = "prop_ld_flow_bottle",
    	["Bone"] = 28422,
		['X'] = 0.0,
		['Y'] = 0.0,
		['Z'] = 0.0,
		['XR'] = 0.0,
		['YR'] = 0.0,
		['ZR'] = 0.0,
    	["VertexIndex"] = 0
	},
	['Cup'] = {
		["Model"] = "prop_cs_paper_cup",
    	["Bone"] = 28422,
		['X'] = 0.0,
		['Y'] = 0.0,
		['Z'] = 0.0,
		['XR'] = 0.0,
		['YR'] = 0.0,
		['ZR'] = 0.0,
    	["VertexIndex"] = 0
	},
	['BSCup'] = {
		["Model"] = "prop_cs_bs_cup",
    	["Bone"] = 28422,
		['X'] = 0.0,
		['Y'] = 0.0,
		['Z'] = 0.0,
		['XR'] = 0.0,
		['YR'] = 0.0,
		['ZR'] = 0.0,
    	["VertexIndex"] = 0
	},
	['BSCoffee'] = {
		["Model"] = "prop_food_bs_coffee",
    	["Bone"] = 28422,
		['X'] = 0.0,
		['Y'] = 0.0,
		['Z'] = 0.0,
		['XR'] = 0.0,
		['YR'] = 0.0,
		['ZR'] = 0.0,
    	["VertexIndex"] = 0
	},
	['Cola'] = {
		["Model"] = "prop_ecola_can",
    	["Bone"] = 28422,
		['X'] = 0.0,
		['Y'] = 0.0,
		['Z'] = 0.0,
		['XR'] = 0.0,
		['YR'] = 0.0,
		['ZR'] = 0.0,
    	["VertexIndex"] = 0
	},
	['Tea'] = {
		["Model"] = "prop_mug_02",
    	["Bone"] = 28422,
		['X'] = 0.0,
		['Y'] = 0.0,
		['Z'] = 0.0,
		['XR'] = 0.0,
		['YR'] = 0.0,
		['ZR'] = 0.0,
    	["VertexIndex"] = 0
	},
	['Coffee'] = {
		["Model"] = "prop_mug_02",
    	["Bone"] = 28422,
		['X'] = 0.0,
		['Y'] = 0.0,
		['Z'] = 0.0,
		['XR'] = 0.0,
		['YR'] = 0.0,
		['ZR'] = 0.0,
    	["VertexIndex"] = 0
	},
	['Cocktail'] = {
		["Model"] = "prop_cocktail",
    	["Bone"] = 28422,
		['X'] = 0.0,
		['Y'] = 0.0,
		['Z'] = -0.1,
		['XR'] = 0.0,
		['YR'] = 0.0,
		['ZR'] = 0.0,
    	["VertexIndex"] = 0
	},
}

Config.AttachBackProps = {
	-- Type 1 is weapon, Type 2 is illegal item
	-- Type 1
	{
		Type = 1,
		Id = 'weapon_paintball',
		Name = 'Paintball Gun',
		Model = 'w_pi_paintball',
		PropCoords = {
			Z = 0.0,
			RX = 0.0,
			RY = 0.0,
			RZ = 0.0,
		}
	},
	{
		Type = 1,
		Id = 'weapon_sniperrifle2',
		Name = 'Hunting Rifle',
		Model = 'w_sr_huntingrifle',
		PropCoords = {
			Z = 0.0,
			RX = 0.0,
			RY = 0.0,
			RZ = 0.0,
		}
	},
	{
		Type = 1,
		Id = 'weapon_empgun',
		Name = 'EMP Gun',
		Model = 'w_ar_empgun',
		PropCoords = {
			Z = 0.0,
			RX = 0.0,
			RY = 0.0,
			RZ = 0.0,
		}
	},
	{
		Type = 1,
		Id = 'weapon_remington',
		Name = 'Remington',
		Model = 'w_sg_remington',
		PropCoords = {
			Z = 0.0,
			RX = 0.0,
			RY = 0.0,
			RZ = 0.0,
		}
	},
	{
		Type = 1,
		Id = 'weapon_rubberslug',
		Name = 'Remington Rubber',
		Model = 'w_sg_rubberslug',
		PropCoords = {
			Z = 0.0,
			RX = 0.0,
			RY = 0.0,
			RZ = 0.0,
		}
	},
	{
		Type = 1,
		Id = 'weapon_m4',
		Name = 'M4',
		Model = 'w_ar_M4',
		PropCoords = {
			Z = 0.0,
			RX = 0.0,
			RY = 0.0,
			RZ = 0.0,
		}
	},
	{
		Type = 1,
		Id = 'weapon_scar',
		Name = 'Scar',
		Model = 'w_ar_scar',
		PropCoords = {
			Z = 0.0,
			RX = 0.0,
			RY = 0.0,
			RZ = 0.0,
		}
	},
	{
		Type = 1,
		Id = 'weapon_ak47',
		Name = 'AK47',
		Model = 'w_ar_ak47',
		PropCoords = {
			Z = 0.0,
			RX = 0.0,
			RY = 0.0,
			RZ = 0.0,
		}
	},
	{
		Type = 1,
		Id = 'weapon_ak74',
		Name = 'AK74',
		Model = 'w_ar_ak74',
		PropCoords = {
			Z = 0.0,
			RX = 0.0,
			RY = 0.0,
			RZ = 0.0,
		}
	},
	{
		Type = 1,
		Id = 'weapon_groza',
		Name = 'Groza',
		Model = 'w_ar_groza',
		PropCoords = {
			Z = 0.0,
			RX = 0.0,
			RY = 0.0,
			RZ = 0.0,
		}
	},
	{
		Type = 1,
		Id = 'weapon_m70',
		Name = 'M70',
		Model = 'W_AR_M70',
		PropCoords = {
			Z = 0.0,
			RX = 0.0,
			RY = 0.0,
			RZ = 0.0,
		}
	},
	{
		Type = 1,
		Id = 'weapon_rpk',
		Name = 'RPK',
		Model = 'w_mg_rpk',
		PropCoords = {
			Z = -0.15,
			RX = 0.0,
			RY = 180.0,
			RZ = 0.0,
		}
	},
	{
		Type = 1,
		Id = 'weapon_draco',
		Name = 'Draco',
		Model = 'w_ar_draco',
		PropCoords = {
			Z = 0.0,
			RX = 0.0,
			RY = 0.0,
			RZ = 0.0,
		}
	},
	{
		Type = 1,
		Id = 'weapon_mp5',
		Name = 'MP5',
		Model = 'w_sb_mp5',
		PropCoords = {
			Z = 0.0,
			RX = 0.0,
			RY = 0.0,
			RZ = 0.0,
		}
	},
	{
		Type = 1,
		Id = 'weapon_mpx',
		Name = 'Sig MPX',
		Model = 'w_sb_mpx',
		PropCoords = {
			Z = 0.02,
			RX = 0.0,
			RY = 0.0,
			RZ = 0.0,
		}
	},
	{
		Type = 1,
		Id = 'weapon_mac10',
		Name = 'Mac10',
		Model = 'w_sb_mac10',
		PropCoords = {
			Z = 0.0,
			RX = 0.0,
			RY = 0.0,
			RZ = 0.0,
		}
	},
	{
		Type = 1,
		Id = 'weapon_uzi',
		Name = 'UZI',
		Model = 'w_sb_uzi',
		PropCoords = {
			Z = 0.0,
			RX = 0.0,
			RY = 0.0,
			RZ = 0.0,
		}
	},
	-- Type 2
	{
		Type = 2,
		Id = 'weed-branch',
		Name = 'Weed Plant',
		Model = 'bkr_prop_weed_drying_02a',
		PropCoords = {
			Z = 0.3,
			RX = 0.0,
			RY = 90.0,
			RZ = 0.0,
		}
	},
	{
		Type = 2,
		Id = 'markedbills',
		Name = 'Bank Bag',
		Model = 'prop_money_bag_01',
		PropCoords = {
			Z = -0.4,
			RX = 0.0,
			RY = 90.0,
			RZ = 0.0,
		}
	},
	-- Type 3
	{
		Type = 3,
		Id = 'hunting-carcass-one',
		Name = 'Bank Bag',
		Model = 'hunting_pelt_01_a',
		PropCoords = {
			X = 0.0,
			Y = -0.10,
			Z = -0.0,
			RX = 0.0,
			RY = 0.0,
			RZ = 0.0,
		},
		PropExtra = {
			DisableRun = true,
			Dict = 'anim@heists@box_carry@',
			Anim = 'idle',
		}
	},
	{
		Type = 3,
		Id = 'hunting-carcass-two',
		Name = 'Bank Bag',
		Model = 'hunting_pelt_01_a',
		PropCoords = {
			X = 0.0,
			Y = -0.10,
			Z = -0.0,
			RX = 0.0,
			RY = 0.0,
			RZ = 0.0,
		},
		PropExtra = {
			DisableRun = true,
			Dict = 'anim@heists@box_carry@',
			Anim = 'idle',
		}
	},
	{
		Type = 3,
		Id = 'hunting-carcass-three',
		Name = 'Bank Bag',
		Model = 'hunting_pelt_01_a',
		PropCoords = {
			X = 0.0,
			Y = -0.10,
			Z = -0.0,
			RX = 0.0,
			RY = 0.0,
			RZ = 0.0,
		},
		PropExtra = {
			DisableRun = true,
			Dict = 'anim@heists@box_carry@',
			Anim = 'idle',
		}
	},
	{
		Type = 3,
		Id = 'hunting-carcass-four',
		Name = 'Bank Bag',
		Model = 'hunting_pelt_01_a',
		PropCoords = {
			X = 0.0,
			Y = -0.10,
			Z = -0.0,
			RX = 0.0,
			RY = 0.0,
			RZ = 0.0,
		},
		PropExtra = {
			DisableRun = true,
			Dict = 'anim@heists@box_carry@',
			Anim = 'idle',
		}
	},
	{
		Type = 3,
		Id = 'darkmarketpackage',
		Name = 'Dark Market Package',
		Model = 'prop_idol_case_01',
		PropCoords = {
            X = 0.01,
            Y = -0.02,
            Z = -0.22,
            RX = 0.0,
            RY = 0.0,
            RZ = 0.0,
		},
		PropExtra = {
			DisableRun = true,
			Dict = 'anim@heists@box_carry@',
			Anim = 'idle',
		}
	},
	{
		Type = 3,
		Id = 'weapon_machete',
		Name = 'Machete',
		Model = 'w_me_machette_lr',
		PropCoords = {
            X = 0.0,
            Y = 0.0,
            Z = 0.4,
            RX = 5.0,
            RY = 45.0,
            RZ = 0.0,
		},
	},
	-- Type 4
	{
		Type = 4,
		Id = 'wingsuit',
		Name = 'Wingsuit',
		Model = 'np_wingsuit_closed',
		PropCoords = {
            X = 0.1,
            Y = -0.15,
            Z = 0.0,
            RX = 0.0,
            RY = 90.0,
            RZ = 0.0,
		},
	},
	{
		Type = 4,
		Id = 'wingsuit_b',
		Name = 'Wingsuit B',
		Model = 'np_wingsuit_b_closed',
		PropCoords = {
            X = 0.1,
            Y = -0.15,
            Z = 0.0,
            RX = 0.0,
            RY = 90.0,
            RZ = 0.0,
		},
	},
	{
		Type = 4,
		Id = 'wingsuit_c',
		Name = 'Wingsuit C',
		Model = 'np_wingsuit_b_closed',
		PropCoords = {
            X = 0.1,
            Y = -0.15,
            Z = 0.0,
            RX = 0.0,
            RY = 90.0,
            RZ = 0.0,
		},
	},
	{
		Type = 4,
		Id = 'weapon_katana',
		Name = 'Katana',
		Model = 'katana_sheath',
		PropCoords = {
            X = 0.0,
            Y = 0.0,
            Z = 0.51,
            RX = 225.0,
            RY = 8.0,
            RZ = 90.0,
		},
	},
}