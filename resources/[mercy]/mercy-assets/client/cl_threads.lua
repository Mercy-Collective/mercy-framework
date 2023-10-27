local ResetCounter, JumpDisabled = 0, false

-- [ Code ] --

-- [ Functions ] --

-- Disable Weapon Drops
local PedIndex = {}

function SetWeaponDrops()
    local handle, ped = FindFirstPed()
    local finished = false
    repeat 
        if not IsEntityDead(ped) then
            PedIndex[ped] = {}
        end
        finished, ped = FindNextPed(handle)
    until not finished
    EndFindPed(handle)

    for peds,_ in pairs(PedIndex) do
        if peds ~= nil then
            SetPedDropsWeaponsWhenDead(peds, false) 
        end
    end
end

-- [ Threads ] --

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
            Citizen.Wait(250)
        else
            Citizen.Wait(5000)
        end
    end
end)


-- ViewCam Set
Citizen.CreateThread(function()
    while true do
        if LocalPlayer.state.LoggedIn then
			if not IsPedInAnyVehicle(PlayerPedId()) then
                local EntitySpeed = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId())) * 2.236936
                if EntitySpeed <= 45 then
                    SetRadarZoom(835)
                elseif EntitySpeed <= 60 then
                    SetRadarZoom(1100)
                end
            end

            -- Lock cam viewset
            if --[[GetFollowPedCamViewMode() == 1 or]] GetFollowPedCamViewMode() == 2 or GetFollowPedCamViewMode() == 3 then
                SetFollowPedCamViewMode(4)
            end

            if GetFollowVehicleCamViewMode() == 2 or GetFollowVehicleCamViewMode() == 2 then
                SetFollowVehicleCamViewMode(4)
            end

			-- Disable idle cam
			InvalidateIdleCam()
			InvalidateVehicleIdleCam()

			-- Disable health regen
			SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)

            -- Disable combat walk
            if not GetPedConfigFlag(PlayerPedId(), 78, 1) then
                SetPedUsingActionMode(PlayerPedId(), false, -1, 0)
            end

            -- Disable weapon drops
            SetWeaponDrops()
		else
			Citizen.Wait(2000)
        end

		Citizen.Wait(500)
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
                local Roll = GetEntityRoll(Vehicle)
                if (not IsThisModelABoat(Model) and not IsThisModelAHeli(Model) and not IsThisModelAPlane(Model) and not IsThisModelABike(Model) and IsEntityInAir(Vehicle)) or (Roll > 75.0 or Roll < -75.0) and GetEntitySpeed(Vehicle) < 2 then
                    DisableControlAction(0, 59)
                    DisableControlAction(0, 60)
                end
            end
		end
    end
end)

-- Hud Components
Citizen.CreateThread(function()
 	while true do
		Citizen.Wait(4)
		if LocalPlayer.state.LoggedIn then
			-- Weapon Damage Modifiers
			SetPedSuffersCriticalHits(PlayerPedId(), false)

			-- Hud Components
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

			-- Disable combat peeking
			if IsPedInCover(PlayerPedId(), 0) and not IsPedAimingFromCover(PlayerPedId()) then
				DisablePlayerFiring(PlayerPedId(), true)
			end

			local WeaponHash = GetSelectedPedWeapon(PlayerPedId())

			-- Stop Melee when Weapon Equipped
			if IsPedArmed(PlayerPedId(), 6) and WeaponHash ~= GetHashKey("WEAPON_UNARMED") then
				DisableControlAction(1, 140, true)
				DisableControlAction(1, 141, true)
				DisableControlAction(1, 142, true)
				DisableControlAction(0, 140, true)
				DisableControlAction(0, 141, true)
				DisableControlAction(0, 142, true)
			end
						
			-- Disable some stuff
			DisableControlAction(0, 36, true) -- INPUT_DUCK
			SetPlayerTargetingMode(3) -- Force Free Aim
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
            RemoveVehiclesFromGeneratorsInArea(441.8465 - 500.0, -987.99 - 500.0, 30.68 -500.0, 441.8465 + 500.0, -987.99 + 500.0, 30.68 + 500.0) -- MRPD
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

-- Blacklist
-- Citizen.CreateThread(function()
--     while true do
-- 		Citizen.Wait(4)
-- 		if LocalPlayer.state.LoggedIn then
-- 			for _, sctyp in next, Config.BlacklistedScenarios['TYPES'] do
-- 				SetScenarioTypeEnabled(sctyp, false)
-- 			end
-- 			for _, scgrp in next, Config.BlacklistedScenarios['GROUPS'] do
-- 				SetScenarioGroupEnabled(scgrp, false)
-- 			end
-- 			Citizen.Wait(10000)
-- 		else
-- 			Citizen.Wait(450)
-- 		end
--     end
-- end)

-- Look at player talking
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
			Citizen.Wait(1000)
		end
		Citizen.Wait(500)
	end
end)

-- Remove Health + Armor Bar
Citizen.CreateThread(function()
    local Minimap = RequestScaleformMovie("minimap")
    while true do
        Citizen.Wait(4)
        BeginScaleformMovieMethod(Minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end
end)