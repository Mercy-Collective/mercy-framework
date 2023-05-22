EntityModule, FunctionsModule, BlipModule, PlayerModule, KeybindsModule, EventsModule, CallbackModule = nil, nil, nil, nil, nil, nil, nil
local RelationshipTypes = {"PLAYER","COP","MISSION2","MISSION3","MISSION4","MISSION5","MISSION6","MISSION7","MISSION8"}
local RadioStations = {
	'RADIO_01_CLASS_ROCK','RADIO_02_POP','RADIO_03_HIPHOP_NEW','RADIO_04_PUNK','RADIO_05_TALK_01','RADIO_06_COUNTRY','RADIO_07_DANCE_01','RADIO_08_MEXICAN','RADIO_09_HIPHOP_OLD',--[['RADIO_12_REGGAE',]]'RADIO_13_JAZZ','DLC_BATTLE_MIX4_CLUB_PRIV','DLC_BATTLE_MIX2_CLUB_PRIV','DLC_BATTLE_MIX1_CLUB_PRIV','RADIO_23_DLC_XM19_RADIO','RADIO_34_DLC_HEI4_KULT','RADIO_35_DLC_HEI4_MLR','RADIO_36_AUDIOPLAYER',
	'RADIO_14_DANCE_02','RADIO_15_MOTOWN','RADIO_20_THELAB','RADIO_16_SILVERLAKE','RADIO_17_FUNK','RADIO_18_90S_ROCK','RADIO_21_DLC_XM17','RADIO_11_TALK_02','RADIO_22_DLC_BATTLE_MIX1_RADIO','RADIO_23_DLC_BATTLE_MIX2_CLUB','RADIO_24_DLC_BATTLE_MIX3_CLUB','RADIO_25_DLC_BATTLE_MIX4_CLUB','RADIO_26_DLC_BATTLE_CLUB_WARMUP',
}

AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
		'Entity',
		'Functions',
		'Player',
		'Keybinds',
		'BlipManager',
		'Events',
		'Callback',
    }, function(Succeeded)
        if not Succeeded then return end
		EntityModule = exports['mercy-base']:FetchModule('Entity')
		FunctionsModule = exports['mercy-base']:FetchModule('Functions')
		BlipModule = exports['mercy-base']:FetchModule('BlipManager')
		PlayerModule = exports['mercy-base']:FetchModule('Player')
		KeybindsModule = exports['mercy-base']:FetchModule('Keybinds')
		EventsModule = exports['mercy-base']:FetchModule('Events')
		CallbackModule = exports['mercy-base']:FetchModule('Callback')
    end)
end)

function TacklePlayer()
    if not LocalPlayer.state.LoggedIn then return end
	if not PlayerModule.GetPlayerData().MetaData['Handcuffed'] and GetLastInputMethod(2) then
		if not IsPedInAnyVehicle(PlayerPedId()) and GetEntitySpeed(PlayerPedId()) > 2.5 then
			TryTackle()
		end
	end
end

RegisterNetEvent('mercy-base/client/on-login', function()
	KeybindsModule.Add('tackePlayer', 'Assets', 'Tackle a player', '', function(IsPressed)
		if not IsPressed then return end
		TacklePlayer()
	end)
	KeybindsModule.Add('Crouch', 'Assets', 'Toggle Crouch', 'LCONTROL', function(IsPressed)
		if not IsPressed then return end
		if GetVehiclePedIsIn(PlayerPedId()) ~= 0 then return end
		if IsPedRagdoll(PlayerPedId()) then return end

		Crouched = not Crouched
		if not Crouched then 
			TriggerEvent("mercy-assets/client/set-my-walkstyle")
		else
			RequestAnimSet("move_ped_crouched")
			while not HasAnimSetLoaded("move_ped_crouched") do Citizen.Wait(0) end
			SetPedMovementClipset(PlayerPedId(), "move_ped_crouched", 0.25)
		end 
	end)
	KeybindsModule.Add('EyeWink', 'Player', 'Wink', '', nil, 'mercy-menu/client/player-wink')
	KeybindsModule.Add('HandsUp', 'Player', 'Hands up', '', function(IsPressed)
		if not IsPressed then return end
		if not IsEntityPlayingAnim(PlayerPedId(), "missminuteman_1ig_2", "handsup_base", 1) then
			if not HasAnimDictLoaded("missminuteman_1ig_2") then
				RequestAnimDict("missminuteman_1ig_2")
				while not HasAnimDictLoaded("missminuteman_1ig_2") do Citizen.Wait(5) end
			end
			TaskPlayAnim(PlayerPedId(), "missminuteman_1ig_2", "handsup_base", 8.0, 8.0, -1, 50, 0, false, false, false)
		else
			StopAnimTask(PlayerPedId(), "missminuteman_1ig_2", "handsup_base", 1.0)
		end
	end)
	
	Citizen.SetTimeout(1500, function()
		TriggerEvent('mercy-assets/client/set-my-walkstyle')
		LoadPlayerRadioStations() 
		LoadPlayerRelations()
		LoadMapData() 
		AddBlips() 
		LoadMisc()
	end)
end)

RegisterNetEvent('mercy-base/client/on-logout', function()
	TriggerEvent('mercy-assets/client/toggle-items', true)
	TriggerEvent('mercy-assets/client/reset-holster')
end)

-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('mercy-assets/client/shuffle-seat', function()
    if IsPedInAnyVehicle(PlayerPedId()) then
        DisableSeatShuff = false
        Citizen.Wait(5000)
        DisableSeatShuff = true
    else
        CancelEvent()
    end
end)

RegisterNetEvent('mercy-assets/client/set-map-zoom', function()
	Citizen.CreateThread(function()
		SetMapZoomDataLevel(0, 2.3, 0.9, 0.08, 0.0, 0.0)
		SetMapZoomDataLevel(1, 2.6, 0.9, 0.08, 0.0, 0.0)
		SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0)
		SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0)
		SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0)
		SetRadarZoom(900) SetRadarZoom(950)
		Citizen.SetTimeout(150, function()
			SetRadarZoom(1100)
		end)
	end)
end)

-- [ Functions ] --

function LoadMapData()
	RequestStreamedTextureDict("squaremap", false)
	while not HasStreamedTextureDictLoaded("squaremap") do
		Wait(100)
	end

	AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "squaremap", "radarmasksm")

	Citizen.Wait(100)

	RequestStreamedTextureDict("minimap_0_0", false)
	RequestStreamedTextureDict("minimap_0_1", false)
	RequestStreamedTextureDict("minimap_1_0", false)
	RequestStreamedTextureDict("minimap_1_1", false)
	RequestStreamedTextureDict("minimap_2_0", false)
	RequestStreamedTextureDict("minimap_2_1", false)
	RequestStreamedTextureDict("minimap_lod_128", false)
	RequestStreamedTextureDict("minimap_sea_0_0", false)
	RequestStreamedTextureDict("minimap_sea_0_1", false)
	RequestStreamedTextureDict("minimap_sea_1_0", false)
	RequestStreamedTextureDict("minimap_sea_2_0", false)
	RequestStreamedTextureDict("minimap_sea_2_1", false)

	Citizen.Wait(100)
	
	Citizen.CreateThread(function()
		SetMapZoomDataLevel(0, 2.3, 0.9, 0.08, 0.0, 0.0)
		SetMapZoomDataLevel(1, 2.6, 0.9, 0.08, 0.0, 0.0) 
		SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0) 
		SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0)
		SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0)
	end)

	Citizen.Wait(100)

	Citizen.SetTimeout(250, function()
		Citizen.CreateThread(function()
			local Minimap = RequestScaleformMovie("minimap")
			while not HasScaleformMovieLoaded(Minimap) do
				Citizen.Wait(0)
			end
			SetMinimapComponentPosition("minimap", "L", "B", -0.0045, -0.025, 0.150, 0.18888)
			SetMinimapComponentPosition("minimap_mask", "L", "B", 0.020, 0.022, 0.111, 0.159)
			SetMinimapComponentPosition("minimap_blur", "L", "B", -0.03, -0.002, 0.266, 0.237)
			SetMinimapClipType(0)
			SetRadarBigmapEnabled(true, false)
			Citizen.Wait(250)
			SetRadarBigmapEnabled(false, false)
			SetRadarZoom(1100)
			DisplayRadar(false)
		end)
	end)
end

function LoadPlayerRelations()
	Citizen.CreateThread(function()
		for k, v in pairs(RelationshipTypes) do
			if v == "COP" then
				SetRelationshipBetweenGroups(3, GetHashKey('PLAYER'), GetHashKey(v))
				SetRelationshipBetweenGroups(3, GetHashKey(v), GetHashKey('PLAYER'))
				SetRelationshipBetweenGroups(0, GetHashKey('MISSION2'), GetHashKey(v))
				SetRelationshipBetweenGroups(0, GetHashKey(v), GetHashKey('MISSION2'))
			else
				SetRelationshipBetweenGroups(0, GetHashKey('PLAYER'), GetHashKey(v))
				SetRelationshipBetweenGroups(0, GetHashKey(v), GetHashKey('PLAYER'))
				SetRelationshipBetweenGroups(0, GetHashKey('MISSION2'), GetHashKey(v))
				SetRelationshipBetweenGroups(0, GetHashKey(v), GetHashKey('MISSION2'))
			end  
			SetRelationshipBetweenGroups(5, GetHashKey(v), GetHashKey('MISSION8'))
		end
		SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_HILLBILLY"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_BALLAS"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_MEXICAN"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_FAMILY"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_MARABUNTE"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_SALVA"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(1, GetHashKey("GANG_1"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(1, GetHashKey("GANG_2"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(1, GetHashKey("GANG_9"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(1, GetHashKey("GANG_10"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(1, GetHashKey("FIREMAN"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(1, GetHashKey("MEDIC"), GetHashKey('PLAYER'))
		SetRelationshipBetweenGroups(1, GetHashKey("COP"), GetHashKey('PLAYER'))
	end)
end

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

local function starts_with(str, start)
    return str:sub(1, #start) == start
end

Citizen.CreateThread(function()
    local settingsFile = LoadResourceFile(GetCurrentResourceName(), "misc/visualsettings.dat")
    local lines = stringsplit(settingsFile, "\n")
    for k,v in ipairs(lines) do
        if not starts_with(v, '#') and not starts_with(v, '//') and (v ~= "" or v ~= " ") and #v > 1 then
            v = v:gsub("%s+", " ")
            local setting = stringsplit(v, " ")
            if setting[1] ~= nil and setting[2] ~= nil and tonumber(setting[2]) ~= nil then
                if setting[1] ~= 'weather.CycleDuration' then	
                    Citizen.InvokeNative(GetHashKey('SET_VISUAL_SETTING_FLOAT') & 0xFFFFFFFF, setting[1], tonumber(setting[2])+.0)
                end
            end
        end
    end
end)

function LoadPlayerRadioStations()
	Citizen.CreateThread(function()
		for k, v in pairs(RadioStations) do
			SetRadioStationIsVisible(v, false)
		end
	end)
end

function LoadMisc()
	Citizen.CreateThread(function()
		for i = 1, 15 do
			EnableDispatchService(i, false)
		end
	
		for i = 0, 255 do
			if NetworkIsPlayerConnected(i) then
				if NetworkIsPlayerConnected(i) and GetPlayerPed(i) ~= nil then
					SetCanAttackFriendly(GetPlayerPed(i), true, true)
				end
			end
		end

		SetPedConfigFlag(PlayerPedId(), 184, true)
		SetPedConfigFlag(PlayerPedId(), 35, false)
	
		SetTrainTrackSpawnFrequency(3, 99999999999)
		SetTrainTrackSpawnFrequency(0, 120000000)
		SwitchTrainTrack(0, true)
		SetRandomTrains(true)
	
		SetRandomBoats(0.5)
		SetGarbageTrucks(0.3)
	
		SetMaxWantedLevel(0)
		SetCreateRandomCops(0)
		DistantCopCarSirens(false)
		SetCreateRandomCopsOnScenarios(0)
		SetCreateRandomCopsNotOnScenarios(0)

		NetworkSetFriendlyFireOption(true)
		DisablePlayerVehicleRewards(PlayerId())
		SetDispatchCopsForPlayer(PlayerId(), false)
		SetBlipAlpha(Citizen.InvokeNative(0x3F0CF9CB7E589B88), 0)
		local DuiData = CallbackModule.SendCallback('mercy-assets/server/get-dui-data')
		Config.SavedDuiData = DuiData
	end)
end

function SetDiscordRichPresence()
	local ServerId = GetPlayerServerId(PlayerId())
	SetDiscordAppId(Config.DiscordSettings['AppId'])
	SetDiscordRichPresenceAsset('main')
	SetDiscordRichPresenceAssetText(Config.DiscordSettings['Text'])
	SetDiscordRichPresenceAssetSmall('main')
	SetDiscordRichPresenceAssetSmallText('Server ID: '..ServerId)
end