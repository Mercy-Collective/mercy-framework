EntityModule, FunctionsModule, BlipModule, PlayerModule, KeybindsModule, EventsModule, CallbackModule, LoggerModule = nil
Crouched, IsAdmin = false, false

AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
		'Entity',
		'Functions',
		'Player',
		'Keybinds',
		'BlipManager',
		'Events',
		'Callback',
		'Logger',
    }, function(Succeeded)
        if not Succeeded then return end
		EntityModule = exports['mercy-base']:FetchModule('Entity')
		FunctionsModule = exports['mercy-base']:FetchModule('Functions')
		BlipModule = exports['mercy-base']:FetchModule('BlipManager')
		PlayerModule = exports['mercy-base']:FetchModule('Player')
		KeybindsModule = exports['mercy-base']:FetchModule('Keybinds')
		EventsModule = exports['mercy-base']:FetchModule('Events')
		CallbackModule = exports['mercy-base']:FetchModule('Callback')
		LoggerModule = exports['mercy-base']:FetchModule('Logger')
    end)
end)

RegisterNetEvent('mercy-base/client/on-login', function()
	IsAdmin = PlayerModule.IsPlayerAdmin()
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

-- RegisterNetEvent('mercy-assets/client/set-map-zoom', function()
-- 	Citizen.CreateThread(function()
-- 		SetMapZoomDataLevel(0, 2.3, 0.9, 0.08, 0.0, 0.0)
-- 		SetMapZoomDataLevel(1, 2.6, 0.9, 0.08, 0.0, 0.0)
-- 		SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0)
-- 		SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0)
-- 		SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0)
-- 		SetRadarZoom(900) SetRadarZoom(950)
-- 		Citizen.SetTimeout(150, function()
-- 			SetRadarZoom(1100)
-- 		end)
-- 	end)
-- end)

-- [ Functions ] --

function TacklePlayer()
    if not LocalPlayer.state.LoggedIn then return end
	if not PlayerModule.GetPlayerData().MetaData['Handcuffed'] and GetLastInputMethod(2) then
		if not IsPedInAnyVehicle(PlayerPedId()) and GetEntitySpeed(PlayerPedId()) > 2.5 then
			TryTackle()
		end
	end
end

function RemoveLockpickChance(IsAdvanced)
    local ItemName = IsAdvanced and "advlockpick" or "lockpick"
    if math.random(1, 100) > (IsAdvanced and 50 or 25) then
		EventsModule.TriggerServer('mercy-inventory/server/degen-item', exports['mercy-inventory']:GetSlotForItem(ItemName), 5.0)
    end
end
exports("RemoveLockpickChance", RemoveLockpickChance)

Citizen.CreateThread(function()
	while not NetworkIsSessionStarted() do
		Citizen.Wait(100)
	end

	DisplayRadar(false)

	SetDiscordRichPresence()

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

function LoadMisc()
	-- Disable Dispatch Services
	for i = 1, 15 do EnableDispatchService(i, false) end

	SetPedConfigFlag(PlayerPedId(), 35, false) -- Use helmet

	-- Enable friendly attack
	for i = 0, 255 do
		if NetworkIsPlayerConnected(i) then
			if NetworkIsPlayerConnected(i) and GetPlayerPed(i) ~= nil then
				SetCanAttackFriendly(GetPlayerPed(i), true, true)
			end
		end
	end

    SetTrainTrackSpawnFrequency(3, 99999999999)
    SetTrainTrackSpawnFrequency(0, 120000000)
    SwitchTrainTrack(0, true)
    SetRandomTrains(true)
    SetRandomBoats(true)
    SetRandomBoatsInMp(true)
    SetGarbageTrucks(false)
    SetMaxWantedLevel(0)
    SetCreateRandomCops(0)
    DistantCopCarSirens(false)
    SetCreateRandomCopsOnScenarios(0)
    SetCreateRandomCopsNotOnScenarios(0)
	NetworkSetFriendlyFireOption(true)
	DisablePlayerVehicleRewards(PlayerId())
	SetDispatchCopsForPlayer(PlayerId(), false)
	SetBlipAlpha(GetNorthRadarBlip(), 0) -- disable north indicator blip

    SetDiscordRichPresenceAction(0, 'Discord', 'https://dsc.gg/mercy-coll')

	Config.SavedDuiData = CallbackModule.SendCallback('mercy-assets/server/get-dui-data')

	local MapTries = 0
	RequestStreamedTextureDict("squaremap", false)
	while not HasStreamedTextureDictLoaded("squaremap") do
		Wait(250)
		MapTries = MapTries + 1
		if MapTries > 50 then
			return print("Failed to load map textures, please report this to an admin. (No map asset found)")
		end
	end

	AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "squaremap", "radarmasksm")
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
	
    SetMapZoomDataLevel(0, 2.3, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(1, 2.6, 0.9, 0.08, 0.0, 0.0) 
    SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0) 
    SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0)

	Citizen.Wait(350)

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
	
	print("[ASSETS]: Init done!")
end