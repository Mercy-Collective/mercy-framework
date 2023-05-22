local Lockpicking, Healing, TimerEnabled, InTackleCooldown, IsPointing, Crouched = false, false, false, false, false, false

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            if IsControlPressed(0, 29) and IsPedOnFoot(PlayerPedId()) then
                if not IsPointing then
                    StartPointing()
                end
                IsPointing = true
            else
                if IsPointing then
                    StopPointing()
                end
                IsPointing = false
            end
            if not IsPedOnFoot(PlayerPedId()) and IsPointing then
                IsPointing = false
                StopPointing()
            end
            if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) then
                if IsPedOnFoot(PlayerPedId()) and IsPointing then
                    local CamPitch = GetGameplayCamRelativePitch()
                    if CamPitch < -70.0 then
                        CamPitch = -70.0
                    elseif CamPitch > 42.0 then
                        CamPitch = 42.0
                    end
                    CamPitch = (CamPitch + 70.0) / 112.0
                    local CamHeading = GetGameplayCamRelativeHeading()
                    local CosCamHeading = Cos(CamHeading)
                    local SinCamHeading = Sin(CamHeading)
                    if CamHeading < -180.0 then
                        CamHeading = -180.0
                    elseif CamHeading > 180.0 then
                        CamHeading = 180.0
                    end
                    CamHeading = (CamHeading + 180.0) / 360.0
                    local Blocked, NN = 0, 0
                    local Coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), (CosCamHeading * -0.2) - (SinCamHeading * (0.4 * CamHeading + 0.3)), (SinCamHeading * -0.2) + (CosCamHeading * (0.4 * CamHeading + 0.3)), 0.6)
                    local RayCast = Cast_3dRayPointToPoint(Coords.x, Coords.y, Coords.z - 0.2, Coords.x, Coords.y, Coords.z + 0.2, 0.4, 95, PlayerPedId(), 7);
                    NN, Blocked = GetRaycastResult(RayCast)
                    Citizen.InvokeNative(0xD5BB4025AE449A4E, PlayerPedId(), "Pitch", CamPitch)
                    Citizen.InvokeNative(0xD5BB4025AE449A4E, PlayerPedId(), "Heading", CamHeading * -1.0 + 1.0)
                    Citizen.InvokeNative(0xB0A6CFD2C69C1088, PlayerPedId(), "isBlocked", Blocked)
                    Citizen.InvokeNative(0xB0A6CFD2C69C1088, PlayerPedId(), "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)
                else
                    Citizen.Wait(25)
                end
            else
                Citizen.Wait(50)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- [ Events ] --

RegisterNetEvent('mercy-assets/client/set-my-walkstyle', function()
    local WalkStyle = PlayerModule.GetPlayerData().MetaData['WalkingStyle']
    if WalkStyle == nil or WalkStyle == 'None' then ResetPedMovementClipset(PlayerPedId(), 0.25) return end

    RequestAnimSet(WalkStyle)
    while not HasAnimSetLoaded(WalkStyle) do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), WalkStyle, 0.25)
end)

RegisterNetEvent('mercy-assets/client/play-call-animation', function()
    FunctionsModule.RequestAnimDict("cellphone@")
    TaskPlayAnim(PlayerPedId(), 'cellphone@', 'cellphone_call_listen_base', 3.0, -1, -1, 49, 0, false, false, false)
    Citizen.Wait(3000)
    StopAnimTask(PlayerPedId(), 'cellphone@', 'cellphone_call_listen_base', 1.0)
end)

RegisterNetEvent('mercy-assets/client/play-door-animation', function()
    if not IsPedInAnyVehicle(PlayerPedId()) then
        FunctionsModule.RequestAnimDict("anim@heists@keycard@")
        TaskPlayAnim(PlayerPedId(), "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 48, 0, 0, 0, 0)
        Citizen.Wait(500)
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNetEvent('mercy-assets/client/play-cash-animation', function()
    if not IsPedInAnyVehicle(PlayerPedId()) then
        FunctionsModule.RequestAnimDict("friends@laf@ig_5")
        TaskPlayAnim(PlayerPedId(), 'friends@laf@ig_5', 'nephew', 5.0, 1.0, 5.0, 49, 0, 0, 0, 0)
        Citizen.Wait(1500)
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNetEvent('mercy-assets/client/dice-animation', function()
    if not IsPedInAnyVehicle(PlayerPedId()) then
        FunctionsModule.RequestAnimDict("anim@mp_player_intcelebrationmale@wank")
        TaskPlayAnim(PlayerPedId(), "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
        Citizen.Wait(1500)
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNetEvent('mercy-assets/client/lockpick-animation', function(Bool)
    Lockpicking = Bool
    FunctionsModule.RequestAnimDict("veh@break_in@0h@p_m_one@")
    if Bool then
        Citizen.CreateThread(function()
            while Lockpicking do
                Citizen.Wait(4)
                TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds" ,3.0, 3.0, -1, 16, 0, false, false, false)
                Citizen.Wait(1000)
            end
            StopAnimTask(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0)
        end)
    end
end)

RegisterNetEvent('mercy-assets/client/heal-animation', function(Bool)
    Healing = Bool
    FunctionsModule.RequestAnimDict("weapons@first_person@aim_rng@generic@projectile@thermal_charge@")
    if Bool then
        Citizen.CreateThread(function()
            while Healing do
                Citizen.Wait(4)
                TaskPlayAnim(PlayerPedId(), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor" ,3.0, 3.0, -1, 16, 0, false, false, false)
                Citizen.Wait(2000)
            end
            StopAnimTask(PlayerPedId(), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor", 1.0)
        end)
    end
end)

RegisterNetEvent('mercy-assets/client/animation-tackle', function()
	if not PlayerModule.GetPlayerData().MetaData['Handcuffed'] and not IsPedRagdoll(PlayerPedId()) then
        FunctionsModule.RequestAnimDict("swimming@first_person@diving")
		if IsEntityPlayingAnim(PlayerPedId(), "swimming@first_person@diving", "dive_run_fwd_-45_loop", 3) then
			ClearPedSecondaryTask(PlayerPedId())
		else
			TaskPlayAnim(PlayerPedId(), "swimming@first_person@diving", "dive_run_fwd_-45_loop", 8.0, -8, -1, 49, 0, 0, 0, 0)
			local SecCount = 3
			while SecCount > 0 do
				Citizen.Wait(100)
				SecCount = SecCount - 1
			end
			ClearPedSecondaryTask(PlayerPedId())
			SetPedToRagdoll(PlayerPedId(), 150, 150, 0, 0, 0, 0)
		end
	end
end)

RegisterNetEvent('mercy-assets/client/get-tackled', function()
    if not InTackleCooldown then
        TimerEnabled, InTackleCooldown = true, true
        SetPedToRagdoll(PlayerPedId(), math.random(3500,5000), math.random(3500,5000), 0, 0, 0, 0)
        Citizen.SetTimeout(10000, function()
            TimerEnabled, InTackleCooldown = false, false
        end)
    end 
end)

-- [ Functions ] --

function TryTackle()
    if not TimerEnabled then
        local ClosestPlayer = PlayerModule.GetClosestPlayer(nil, 2.0)
        if ClosestPlayer['ClosestPlayerPed'] ~= -1 and ClosestPlayer['ClosestServer'] ~= -1 then
            local PlayerHeading = GetEntityHeading(PlayerPedId())
            local PlayerCoords = GetEntityCoords(PlayerPedId(), true) 
            local TargetCoords = GetEntityCoords(ClosestPlayer['ClosestPlayerPed'], true) 
            local HeadingToTarget = (math.atan2(
                TargetCoords.y - PlayerCoords.y,
                TargetCoords.x - PlayerCoords.x
            ) * 180 / math.pi) - 90  
            local Diff = math.abs(((PlayerHeading - HeadingToTarget) + 180) % 360 - 180)  
            if Diff < 40 then
                TimerEnabled = true
                TriggerServerEvent('mercy-assets/server/tackle-player', ClosestPlayer['ClosestServer'])
                TriggerEvent("mercy-assets/client/animation-tackle")
                Citizen.SetTimeout(6000, function()
                    TimerEnabled = false
                end)
                return
            end
        end
        TimerEnabled = true
        SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
        Citizen.SetTimeout(1000, function()
            TimerEnabled = false
        end)
    end
end

function StartPointing()
    FunctionsModule.RequestAnimDict("anim@mp_point")
    SetPedCurrentWeaponVisible(PlayerPedId(), 0, 1, 1, 1)
    SetPedConfigFlag(PlayerPedId(), 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, PlayerPedId(), "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
end

function StopPointing()
    Citizen.InvokeNative(0xD01015C7316AE176, PlayerPedId(), "Stop")
    if not IsPedInjured(PlayerPedId()) then
        ClearPedSecondaryTask(PlayerPedId())
    end
    if not IsPedInAnyVehicle(PlayerPedId(), 1) then
        SetPedCurrentWeaponVisible(PlayerPedId(), 1, 1, 1, 1)
    end
    SetPedConfigFlag(PlayerPedId(), 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end