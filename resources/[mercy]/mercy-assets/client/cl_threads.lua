local ResetCounter, JumpDisabled = 0, false
local PickupList = {
    `PICKUP_WEAPON_ADVANCEDRIFLE`,
    `PICKUP_WEAPON_APPISTOL`,
    `PICKUP_WEAPON_ASSAULTRIFLE`,
    `PICKUP_WEAPON_ASSAULTRIFLE_MK2`,
    `PICKUP_WEAPON_ASSAULTSHOTGUN`,
    `PICKUP_WEAPON_ASSAULTSMG`,
    `PICKUP_WEAPON_AUTOSHOTGUN`,
    `PICKUP_WEAPON_BAT`,
    `PICKUP_WEAPON_BATTLEAXE`,
    `PICKUP_WEAPON_BOTTLE`,
    `PICKUP_WEAPON_BULLPUPRIFLE`,
    `PICKUP_WEAPON_BULLPUPRIFLE_MK2`,
    `PICKUP_WEAPON_BULLPUPSHOTGUN`,
    `PICKUP_WEAPON_CARBINERIFLE`,
    `PICKUP_WEAPON_CARBINERIFLE_MK2`,
    `PICKUP_WEAPON_COMBATMG`,
    `PICKUP_WEAPON_COMBATMG_MK2`,
    `PICKUP_WEAPON_COMBATPDW`,
    `PICKUP_WEAPON_COMBATPISTOL`,
    `PICKUP_WEAPON_COMPACTLAUNCHER`,
    `PICKUP_WEAPON_COMPACTRIFLE`,
    `PICKUP_WEAPON_CROWBAR`,
    `PICKUP_WEAPON_DAGGER`,
    `PICKUP_WEAPON_DBSHOTGUN`,
    `PICKUP_WEAPON_DOUBLEACTION`,
    `PICKUP_WEAPON_FIREWORK`,
    `PICKUP_WEAPON_FLAREGUN`,
    `PICKUP_WEAPON_FLASHLIGHT`,
    `PICKUP_WEAPON_GRENADE`,
    `PICKUP_WEAPON_GRENADELAUNCHER`,
    `PICKUP_WEAPON_GUSENBERG`,
    `PICKUP_WEAPON_GolfClub`,
    `PICKUP_WEAPON_HAMMER`,
    `PICKUP_WEAPON_HATCHET`,
    `PICKUP_WEAPON_HEAVYPISTOL`,
    `PICKUP_WEAPON_HEAVYSHOTGUN`,
    `PICKUP_WEAPON_HEAVYSNIPER`,
    `PICKUP_WEAPON_HEAVYSNIPER_MK2`,
    `PICKUP_WEAPON_HOMINGLAUNCHER`,
    `PICKUP_WEAPON_KNIFE`,
    `PICKUP_WEAPON_KNUCKLE`,
    `PICKUP_WEAPON_MACHETE`,
    `PICKUP_WEAPON_MACHINEPISTOL`,
    `PICKUP_WEAPON_MARKSMANPISTOL`,
    `PICKUP_WEAPON_MARKSMANRIFLE`,
    `PICKUP_WEAPON_MARKSMANRIFLE_MK2`,
    `PICKUP_WEAPON_MG`,
    `PICKUP_WEAPON_MICROSMG`,
    `PICKUP_WEAPON_MINIGUN`,
    `PICKUP_WEAPON_MINISMG`,
    `PICKUP_WEAPON_MOLOTOV`,
    `PICKUP_WEAPON_MUSKET`,
    `PICKUP_WEAPON_NIGHTSTICK`,
    `PICKUP_WEAPON_PETROLCAN`,
    `PICKUP_WEAPON_PIPEBOMB`,
    `PICKUP_WEAPON_PISTOL`,
    `PICKUP_WEAPON_PISTOL50`,
    `PICKUP_WEAPON_PISTOL_MK2`,
    `PICKUP_WEAPON_POOLCUE`,
    `PICKUP_WEAPON_PROXMINE`,
    `PICKUP_WEAPON_PUMPSHOTGUN`,
    `PICKUP_WEAPON_PUMPSHOTGUN_MK2`,
    `PICKUP_WEAPON_RAILGUN`,
    `PICKUP_WEAPON_RAYCARBINE`,
    `PICKUP_WEAPON_RAYMINIGUN`,
    `PICKUP_WEAPON_RAYPISTOL`,
    `PICKUP_WEAPON_REVOLVER`,
    `PICKUP_WEAPON_REVOLVER_MK2`,
    `PICKUP_WEAPON_RPG`,
    `PICKUP_WEAPON_SAWNOFFSHOTGUN`,
    `PICKUP_WEAPON_SMG`,
    `PICKUP_WEAPON_SMG_MK2`,
    `PICKUP_WEAPON_SMOKEGRENADE`,
    `PICKUP_WEAPON_SNIPERRIFLE`,
    `PICKUP_WEAPON_SNSPISTOL`,
    `PICKUP_WEAPON_SNSPISTOL_MK2`,
    `PICKUP_WEAPON_SPECIALCARBINE`,
    `PICKUP_WEAPON_SPECIALCARBINE_MK2`,
    `PICKUP_WEAPON_STICKYBOMB`,
    `PICKUP_WEAPON_STONE_HATCHET`,
    `PICKUP_WEAPON_STUNGUN`,
    `PICKUP_WEAPON_SWITCHBLADE`,
    `PICKUP_WEAPON_VINTAGEPISTOL`,
    `PICKUP_WEAPON_WRENCH`
}

DisableSeatShuff = true

-- [ Threads ] --

-- Disabled Keys
Citizen.CreateThread(function()
	while true do
		DisableControlAction(0, 36, true) -- INPUT_DUCK
		Citizen.Wait(4)
	end
end)

-- ViewCam Set
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            if GetFollowPedCamViewMode() == 1 or GetFollowPedCamViewMode() == 2 or GetFollowPedCamViewMode() == 3  then
                SetFollowPedCamViewMode(4)
            end
			if GetFollowVehicleCamViewMode() == 2 or GetFollowVehicleCamViewMode() == 2 then
				SetFollowVehicleCamViewMode(4)
			end
            Citizen.Wait(165)
		else
			Citizen.Wait(450)
        end
    end
end)

-- Idle Cam Remove
Citizen.CreateThread(function()
    while true do
		Citizen.Wait(4)
		if LocalPlayer.state.LoggedIn then
			InvalidateIdleCam()
			N_0x9e4cfff989258472()
			Citizen.Wait(10000)
		else
			Citizen.Wait(450)
		end
    end 
end)

-- Air Control
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
		if LocalPlayer.state.LoggedIn then
        	local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        	if DoesEntityExist(Vehicle) and not IsEntityDead(Vehicle) then
        	    local Model = GetEntityModel(Vehicle)
        	    if not IsThisModelABoat(Model) and not IsThisModelAHeli(Model) and not IsThisModelAPlane(Model) and not IsThisModelABike(Model) and IsEntityInAir(Vehicle) then
        	        DisableControlAction(0, 59)
        	        DisableControlAction(0, 60)
        	    end
        	end
		end
    end
end)

-- Health Regen
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
            Citizen.Wait(30)
        else
            Citizen.Wait(450)
        end
    end
end)

-- Blacklist
Citizen.CreateThread(function()
    while true do
		Citizen.Wait(4)
		if LocalPlayer.state.LoggedIn then
			for _, sctyp in next, Config.BlacklistedScenarios['TYPES'] do
				SetScenarioTypeEnabled(sctyp, false)
			end
			for _, scgrp in next, Config.BlacklistedScenarios['GROUPS'] do
				SetScenarioGroupEnabled(scgrp, false)
			end
			Citizen.Wait(10000)
		else
			Citizen.Wait(450)
		end
    end
end)

-- Stop Melee When Weapon is in hand
Citizen.CreateThread(function()
	while true do
	   	Citizen.Wait(4)
	   	if LocalPlayer.state.LoggedIn and GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey("WEAPON_UNARMED") then
			if IsPedArmed(PlayerPedId(), 6) or IsPlayerFreeAiming(PlayerId()) then
				DisableControlAction(1, 140, true)
				DisableControlAction(1, 141, true)
				DisableControlAction(1, 142, true)
				DisableControlAction(0, 140, true)
				DisableControlAction(0, 141, true)
				DisableControlAction(0, 142, true)
			else
				Citizen.Wait(100)
			end
	   	else
			Citizen.Wait(450)
	   	end
	end
end)

-- Hud Components
Citizen.CreateThread(function()
 	while true do
		Citizen.Wait(4)
		if LocalPlayer.state.LoggedIn then
			SetPedSuffersCriticalHits(PlayerPedId(), false)
			HideHudComponentThisFrame(1)
			HideHudComponentThisFrame(2)
			HideHudComponentThisFrame(3)
			HideHudComponentThisFrame(4)
			HideHudComponentThisFrame(7)
			HideHudComponentThisFrame(9)
			HideHudComponentThisFrame(13)
			HideHudComponentThisFrame(14)
			HideHudComponentThisFrame(17)
			HideHudComponentThisFrame(19)
			HideHudComponentThisFrame(20)
			HideHudComponentThisFrame(21)
			HideHudComponentThisFrame(22)
			DisplayAmmoThisFrame(true)
		else
			Citizen.Wait(450)
		end
 	end
end) 

-- Disable Vehicle Rewards
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		if LocalPlayer.state.LoggedIn then
			DisablePlayerVehicleRewards(PlayerId())
			ClearAreaOfPeds(113.74, -1286.62, 28.26, 18.0) -- Police
			ClearAreaOfPeds(1777.77, 2496.55, 45.82, 20.0) -- Jail
			RemoveVehiclesFromGeneratorsInArea(441.8465 - 500.0, -987.99 - 500.0, 30.68 -500.0, 441.8465 + 500.0, -987.99 + 500.0, 30.68 + 500.0)
		else
			Citizen.Wait(450)
		end
	end
end)

-- Disable Seat Shuff
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
		if LocalPlayer.state.LoggedIn then
			if IsPedInAnyVehicle(PlayerPedId(), false) and DisableSeatShuff then
				if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), false, 0) == PlayerPedId() then
					if GetIsTaskActive(PlayerPedId(), 165) then
						SetPedIntoVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId()), 0)
					end
				end
			end
		else
			Citizen.Wait(450)
		end
    end
end)

-- Disable Weapon Pickup
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		if LocalPlayer.state.LoggedIn then
    		for _, HashKey in pairs(PickupList) do
        		ToggleUsePickupsForPlayer(PlayerId(), HashKey, false)
    		end
		else
			Citizen.Wait(450)
		end
	end
end)

-- Infinite Ammo Fire Extinguisher
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if not LocalPlayer.state.LoggedIn then return end
		local Weapon = GetSelectedPedWeapon(PlayerPedId())
		if Weapon ~= GetHashKey('weapon_fireextinguisher') then SetPedInfiniteAmmo(PlayerPedId(), false, Weapon) goto SkipLoop end
		SetPedInfiniteAmmo(PlayerPedId(), true, Weapon)
		::SkipLoop::
    end
end)

-- Disable 'Combat Walk' after Combat
Citizen.CreateThread( function()
	while true do
		Citizen.Wait(4)
		if LocalPlayer.state.LoggedIn then
			if not GetPedConfigFlag(PlayerPedId(), 78, 1) then
				SetPedUsingActionMode(PlayerPedId(), false, -1, 0)
			end
		else
			Citizen.Wait(450)
		end
    end
end)

-- Discord
Citizen.CreateThread(function()
	while true do
		if NetworkIsSessionStarted() then
			SetDiscordRichPresence()
			return
		end
		Citizen.Wait(500)
	end
end)

-- Disable Blind Firing
Citizen.CreateThread(function()
    while true do
        if IsPedInCover(PlayerPedId(), 0) and not IsPedAimingFromCover(PlayerPedId()) then
            DisablePlayerFiring(PlayerPedId(), true)
        end
        Citizen.Wait(4)
    end
end)

-- Disable Double Jump
Citizen.CreateThread( function()
	while true do
		Citizen.Wait(4)
		if LocalPlayer.state.LoggedIn then
	  		if JumpDisabled and ResetCounter > 0 and IsPedJumping(PlayerPedId()) then
				SetPedToRagdoll(PlayerPedId(), 1000, 1000, 3, 0, 0, 0)
				ResetCounter = 0
	  		end
	  		if not JumpDisabled and IsPedJumping(PlayerPedId()) then
				JumpDisabled = true
				ResetCounter = 10
				Citizen.Wait(1200)
	  		end
			if ResetCounter > 0 then
				ResetCounter = ResetCounter - 1
			else
				if JumpDisabled then
					ResetCounter = 0
					JumpDisabled = false
				end
	  		end
			Citizen.Wait(90)
		else
			Citizen.Wait(450)
		end
	end
end)

-- Make ped look at ped who talks
Citizen.CreateThread(function()
	while true do
		if LocalPlayer.state.LoggedIn then
			local onlinePlayers = GetActivePlayers()
			local playerPed = PlayerPedId()
			for i=1, #onlinePlayers do
				if onlinePlayers[i] ~= PlayerId() and NetworkIsPlayerActive(onlinePlayers[i]) then
					if MumbleIsPlayerTalking(onlinePlayers[i]) then
						local targetPed = GetPlayerPed(onlinePlayers[i])
						if #(GetEntityCoords(targetPed) - GetEntityCoords(playerPed)) < 20 then
							TaskLookAtEntity(playerPed, targetPed, 3000, 2048, 3)
						end
					end
				end
			end
		else
			Wait(1000)
		end
		Wait(500)
	end
end)
