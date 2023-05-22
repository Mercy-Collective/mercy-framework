local ResetCounter, JumpDisabled = 0, false
local PickupList = {GetHashKey('PICKUP_AMMO_BULLET_MP'),GetHashKey('PICKUP_AMMO_FIREWORK'),GetHashKey('PICKUP_AMMO_FLAREGUN'),GetHashKey('PICKUP_AMMO_GRENADELAUNCHER'),GetHashKey('PICKUP_AMMO_GRENADELAUNCHER_MP'),GetHashKey('PICKUP_AMMO_HOMINGLAUNCHER'),GetHashKey('PICKUP_AMMO_MG'),GetHashKey('PICKUP_AMMO_MINIGUN'),GetHashKey('PICKUP_AMMO_MISSILE_MP'),GetHashKey('PICKUP_AMMO_PISTOL'),GetHashKey('PICKUP_AMMO_RIFLE'),GetHashKey('PICKUP_AMMO_RPG'),GetHashKey('PICKUP_AMMO_SHOTGUN'),GetHashKey('PICKUP_AMMO_SMG'),GetHashKey('PICKUP_AMMO_SNIPER'),GetHashKey('PICKUP_ARMOUR_STANDARD'),GetHashKey('PICKUP_CAMERA'),GetHashKey('PICKUP_CUSTOM_SCRIPT'),GetHashKey('PICKUP_GANG_ATTACK_MONEY'),GetHashKey('PICKUP_HEALTH_SNACK'),GetHashKey('PICKUP_HEALTH_STANDARD'),GetHashKey('PICKUP_MONEY_CASE'),GetHashKey('PICKUP_MONEY_DEP_BAG'),GetHashKey('PICKUP_MONEY_MED_BAG'),GetHashKey('PICKUP_MONEY_PAPER_BAG'),GetHashKey('PICKUP_MONEY_SECURITY_CASE'),GetHashKey('PICKUP_MONEY_PURSE'),GetHashKey('PICKUP_MONEY_VARIABLE'),GetHashKey('PICKUP_MONEY_WALLET'),GetHashKey('PICKUP_PARACHUTE'),
	GetHashKey('PICKUP_PORTABLE_CRATE_FIXED_INCAR'),GetHashKey('PICKUP_PORTABLE_CRATE_UNFIXED'),GetHashKey('PICKUP_PORTABLE_CRATE_UNFIXED_INCAR'),GetHashKey('PICKUP_PORTABLE_CRATE_UNFIXED_INCAR_SMALL'),GetHashKey('PICKUP_PORTABLE_CRATE_UNFIXED_LOW_GLOW'),
	GetHashKey('PICKUP_PORTABLE_DLC_VEHICLE_PACKAGE'),GetHashKey('PICKUP_PORTABLE_PACKAGE'),GetHashKey('PICKUP_SUBMARINE'),GetHashKey('PICKUP_VEHICLE_ARMOUR_STANDARD'),GetHashKey('PICKUP_VEHICLE_CUSTOM_SCRIPT'),GetHashKey('PICKUP_VEHICLE_CUSTOM_SCRIPT_LOW_GLOW'),GetHashKey('PICKUP_VEHICLE_HEALTH_STANDARD'),GetHashKey('PICKUP_VEHICLE_HEALTH_STANDARD_LOW_GLOW'),GetHashKey('PICKUP_VEHICLE_MONEY_VARIABLE'),GetHashKey('PICKUP_VEHICLE_WEAPON_APPISTOL'),GetHashKey('PICKUP_VEHICLE_WEAPON_ASSAULTSMG'),GetHashKey('PICKUP_VEHICLE_WEAPON_COMBATPISTOL'),GetHashKey('PICKUP_VEHICLE_WEAPON_GRENADE'),GetHashKey('PICKUP_VEHICLE_WEAPON_MICROSMG'),GetHashKey('PICKUP_VEHICLE_WEAPON_MOLOTOV'),GetHashKey('PICKUP_VEHICLE_WEAPON_PISTOL'),GetHashKey('PICKUP_VEHICLE_WEAPON_PISTOL50'),
	GetHashKey('PICKUP_VEHICLE_WEAPON_SAWNOFF'),GetHashKey('PICKUP_VEHICLE_WEAPON_SMG'),GetHashKey('PICKUP_VEHICLE_WEAPON_SMOKEGRENADE'),GetHashKey('PICKUP_VEHICLE_WEAPON_STICKYBOMB'),GetHashKey('PICKUP_WEAPON_ADVANCEDRIFLE'),GetHashKey('PICKUP_WEAPON_APPISTOL'),GetHashKey('PICKUP_WEAPON_ASSAULTRIFLE'),GetHashKey('PICKUP_WEAPON_ASSAULTSHOTGUN'),GetHashKey('PICKUP_WEAPON_ASSAULTSMG'),GetHashKey('PICKUP_WEAPON_AUTOSHOTGUN'),GetHashKey('PICKUP_WEAPON_BAT'),GetHashKey('PICKUP_WEAPON_BATTLEAXE'),GetHashKey('PICKUP_WEAPON_BOTTLE'),GetHashKey('PICKUP_WEAPON_BULLPUPRIFLE'),GetHashKey('PICKUP_WEAPON_BULLPUPSHOTGUN'),GetHashKey('PICKUP_WEAPON_CARBINERIFLE'),
	GetHashKey('PICKUP_WEAPON_COMBATMG'),GetHashKey('PICKUP_WEAPON_COMBATPDW'),GetHashKey('PICKUP_WEAPON_COMBATPISTOL'),GetHashKey('PICKUP_WEAPON_COMPACTLAUNCHER'),GetHashKey('PICKUP_WEAPON_COMPACTRIFLE'),GetHashKey('PICKUP_WEAPON_CROWBAR'),GetHashKey('PICKUP_WEAPON_DAGGER'),GetHashKey('PICKUP_WEAPON_DBSHOTGUN'),GetHashKey('PICKUP_WEAPON_FIREWORK'),GetHashKey('PICKUP_WEAPON_FLAREGUN'),GetHashKey('PICKUP_WEAPON_FLASHLIGHT'),GetHashKey('PICKUP_WEAPON_GRENADE'),GetHashKey('PICKUP_WEAPON_GRENADELAUNCHER'),GetHashKey('PICKUP_WEAPON_GUSENBERG'),GetHashKey('PICKUP_WEAPON_GOLFCLUB'),GetHashKey('PICKUP_WEAPON_HAMMER'),GetHashKey('PICKUP_WEAPON_HATCHET'),GetHashKey('PICKUP_WEAPON_HEAVYPISTOL'),GetHashKey('PICKUP_WEAPON_HEAVYSHOTGUN'),GetHashKey('PICKUP_WEAPON_HEAVYSNIPER'),
	GetHashKey('PICKUP_WEAPON_HOMINGLAUNCHER'),GetHashKey('PICKUP_WEAPON_KNIFE'),GetHashKey('PICKUP_WEAPON_KNUCKLE'),GetHashKey('PICKUP_WEAPON_MACHETE'),GetHashKey('PICKUP_WEAPON_MACHINEPISTOL'),GetHashKey('PICKUP_WEAPON_MARKSMANPISTOL'),GetHashKey('PICKUP_WEAPON_MARKSMANRIFLE'),GetHashKey('PICKUP_WEAPON_MG'),GetHashKey('PICKUP_WEAPON_MICROSMG'),GetHashKey('PICKUP_WEAPON_MINIGUN'),GetHashKey('PICKUP_WEAPON_MINISMG'),GetHashKey('PICKUP_WEAPON_MOLOTOV'),GetHashKey('PICKUP_WEAPON_MUSKET'),GetHashKey('PICKUP_WEAPON_NIGHTSTICK'),
	GetHashKey('PICKUP_WEAPON_PETROLCAN'),GetHashKey('PICKUP_WEAPON_PIPEBOMB'),GetHashKey('PICKUP_WEAPON_PISTOL'),GetHashKey('PICKUP_WEAPON_PISTOL50'),GetHashKey('PICKUP_WEAPON_POOLCUE'),GetHashKey('PICKUP_WEAPON_PROXMINE'),GetHashKey('PICKUP_WEAPON_PUMPSHOTGUN'),GetHashKey('PICKUP_WEAPON_RAILGUN'),GetHashKey('PICKUP_WEAPON_REVOLVER'),GetHashKey('PICKUP_WEAPON_RPG'),GetHashKey('PICKUP_WEAPON_SAWNOFFSHOTGUN'),GetHashKey('PICKUP_WEAPON_SMG'),GetHashKey('PICKUP_WEAPON_SMOKEGRENADE'),GetHashKey('PICKUP_WEAPON_SNIPERRIFLE'),
	GetHashKey('PICKUP_WEAPON_SNSPISTOL'),GetHashKey('PICKUP_WEAPON_SPECIALCARBINE'),GetHashKey('PICKUP_WEAPON_STICKYBOMB'),GetHashKey('PICKUP_WEAPON_STUNGUN'),GetHashKey('PICKUP_WEAPON_SWITCHBLADE'),GetHashKey('PICKUP_WEAPON_VINTAGEPISTOL'),GetHashKey('PICKUP_WEAPON_WRENCH'),
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
			local PlayerCoords = GetEntityCoords(PlayerPedId(), false)
			for a = 1, #PickupList do
				if IsPickupWithinRadius(PickupList[a], PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, 200.0) then
					RemoveAllPickupsOfType(PickupList[a])
				else
					Citizen.Wait(5)
				end
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