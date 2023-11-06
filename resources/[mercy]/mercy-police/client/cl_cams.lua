local InsideCam = false

RegisterNetEvent('mercy-police/client/show-camera-input', function()
	local PlayerData = PlayerModule.GetPlayerData()
    if PlayerData.Job.Name ~= "police" or not PlayerData.Job.Duty then return end

	if InsideCam then
		return exports['mercy-ui']:Notify('cam-error', 'You are already accessing a cam..', "error")
	end

	Wait(100)

	local Result = exports['mercy-ui']:CreateInput({
        { Label = 'Camera ID (1-' .. (#Config.SecurityCams - 1) .. ')', Icon = 'fas fa-camera', Name = 'CamId', Type = 'number' },
    })

    if Result then
        if Config.SecurityCams[tonumber(Result.CamId)] ~= nil then
			TriggerEvent('mercy-police/client/open-cam', tonumber(Result.CamId))
		else
			exports['mercy-ui']:Notify('cam-error', "This camera does not exist..", 'error')
		end
    end
end)

RegisterNetEvent("mercy-police/client/open-cam", function(CamId)
    local Coords = Config.SecurityCams[CamId]['Coords']
	CamId = tonumber(CamId)

	SetTimecycleModifier("heliGunCam")
	SetTimecycleModifierStrength(1.0)

	local Scaleform = RequestScaleformMovie("TRAFFIC_CAM")
	while not HasScaleformMovieLoaded(Scaleform) do
		Wait(0)
	end

	SecurityCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
	SetCamCoord(SecurityCam, Coords.x, Coords.y, (Coords.z + 1.2))
	SetCamRot(SecurityCam, -15.0, 0.0, Coords.w)
	SetCamFov(SecurityCam, 110.0)
	RenderScriptCams(true, false, 0, 1, 0)
	PushScaleformMovieFunction(Scaleform, "PLAY_CAM_MOVIE")
	SetFocusArea(Coords.x, Coords.y, Coords.z, 0.0, 0.0, 0.0)
	PopScaleformMovieFunctionVoid()

    InsideCam = true

	exports['mercy-ui']:SetInteraction('[ESC/BACKSPACE] Close Cam', 'error')
	exports['mercy-assets']:AttachProp('Tablet')
    FunctionModule.RequestAnimDict('amb@code_human_in_bus_passenger_idles@female@tablet@base')
    TaskPlayAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 3.0, 3.0, -1, 49, 0, 0, 0, 0)

	while InsideCam do
		SetCamCoord(SecurityCam, Coords.x, Coords.y, (Coords.z + 1.2))
		PushScaleformMovieFunction(Scaleform, "SET_ALT_FOV_HEADING")
		PushScaleformMovieFunctionParameterFloat(1.0)
		PushScaleformMovieFunctionParameterFloat(GetCamRot(SecurityCam, 2).z)
		PopScaleformMovieFunctionVoid()
		DrawScaleformMovieFullscreen(Scaleform, 255, 255, 255, 255)

		local CamRot = GetCamRot(SecurityCam, 2)
        
		if IsControlPressed(1, 108) or IsControlPressed(1, 174) then --N4 or Left Arrow
			SetCamRot(SecurityCam, CamRot.x, 0.0, CamRot.z + 0.7, 2)
		end

		if IsControlPressed(1, 107) or IsControlPressed(1, 175) then --N6 or Right Arrow
			SetCamRot(SecurityCam, CamRot.x, 0.0, CamRot.z - 0.7, 2)
		end

		if IsControlPressed(1, 61) or IsControlPressed(1, 188) then -- N8 or Up Arrow
			SetCamRot(SecurityCam, CamRot.x + 0.7, 0.0, CamRot.z, 2)
		end

		if IsControlPressed(1, 60) or IsControlPressed(1, 187) then -- N5 or Down Arrow
			SetCamRot(SecurityCam, CamRot.x - 0.7, 0.0, CamRot.z, 2)
		end

        local CamFov = GetCamFov(SecurityCam)
        if IsControlPressed(1, 241) then -- SCROLL UP
            if CamFov <= 20.0 then 
                CamFov = 20.0 
            end
            SetCamFov(SecurityCam, CamFov - 3.0)
        end

        if IsControlPressed(1, 242) then -- SCROLL DOWN
            if CamFov >= 90.0 then 
                CamFov = 90.0
            end
            SetCamFov(SecurityCam, CamFov + 3.0)
        end

		if IsControlJustPressed(1, 177) then -- ESC / Backspace
			InsideCam = false
		end

		Wait(1)
	end

	exports['mercy-ui']:HideInteraction()
	exports['mercy-assets']:RemoveProps()
	ClearPedTasks(PlayerPedId())
	ClearTimecycleModifier()
	ClearFocus()
	RenderScriptCams(false, false, 0, 1, 0)
	SetScaleformMovieAsNoLongerNeeded(Scaleform)
	DestroyCam(SecurityCam, true)
end)