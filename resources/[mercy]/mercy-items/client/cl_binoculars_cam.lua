-- [ Events ] --

RegisterNetEvent("mercy-items/client/used-binoculars", function()
    if IsPedInAnyVehicle(PlayerPedId()) then return end
    Citizen.SetTimeout(500, function()
        if DoingBinoculars then
            ToggleBinoculars(false)
        else
            ToggleBinoculars(true)
        end
    end)
end)

RegisterNetEvent("mercy-items/client/use-camera", function()
    if IsPedInAnyVehicle(PlayerPedId()) then return end
    Citizen.SetTimeout(500, function()
        if DoingPDCamera then
            TogglePDCamera(false)
        else
            TogglePDCamera(true)
        end
    end)
end)


-- Binoculars

local FovMin, FovMax = 30.0, 150.0
local CurrentFov = (FovMin + FovMax) * 0.5

function ToggleBinoculars(Bool)
    DoingBinoculars = Bool
    if not DoingBinoculars then return end

    CurrentFov = (FovMin + FovMax) * 0.5

    SetTimecycleModifier("heliGunCam")
    SetTimecycleModifierStrength(0.15)

    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_BINOCULARS", 0, 1)

    Citizen.Wait(2000)

    local ScaleForm = RequestScaleformMovie("BINOCULARS")
	while not HasScaleformMovieLoaded(ScaleForm) do
		Citizen.Wait(10)
	end

    local BinocularsCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    AttachCamToEntity(BinocularsCam, PlayerPedId(), 0.0,0.0,1.0, true)
    SetCamRot(BinocularsCam, 0.0, 0.0, GetEntityHeading(PlayerPedId()))
    SetCamFov(BinocularsCam, CurrentFov)
    RenderScriptCams(true, false, 0, 1, 0)
    PushScaleformMovieFunction(ScaleForm, "SET_CAM_LOGO")
    PushScaleformMovieFunctionParameterInt(0)
    PopScaleformMovieFunctionVoid()

    Citizen.CreateThread(function()
        while DoingBinoculars do
            Citizen.Wait(4)
            local Zoomvalue = (1.0 / (FovMax - FovMin)) * (CurrentFov - FovMin)

            HandleZoom(BinocularsCam, CurrentFov)
            CheckInputRotation(BinocularsCam, Zoomvalue)
            DrawScaleformMovieFullscreen(ScaleForm, 255, 255, 255, 255)

            SetPauseMenuActive(false)
            if IsControlJustPressed(0, 177) then
                Citizen.SetTimeout(50, function()
                    DoingBinoculars = false
                    SetPauseMenuActive(false)
                end)
            end
        end
        RenderScriptCams(false, false, 1, true, true)
        SetCamActive(BinocularsCam, false)
        SetFocusEntity(PlayerPedId())
        DestroyCam(BinocularsCam, true)
        ClearPedTasks(PlayerPedId())
        ClearTimecycleModifier()
    end)
end

function CheckInputRotation(Camera, Zoomvalue)
	local RightAxisX, RightAxisY = GetDisabledControlNormal(0, 220), GetDisabledControlNormal(0, 221)
	local Rotation = GetCamRot(Camera, 2)
	if RightAxisX ~= 0 or RightAxisY ~= 0 then
		NewX, NewZ = math.max(math.min(20.0, Rotation.x + RightAxisY * -1.0 * 8.0 * (Zoomvalue + 0.1)), -89.5), Rotation.z + RightAxisX * -1.0 * 8.0 * (Zoomvalue + 0.1)
		SetCamRot(Camera, NewX, 0.0, NewZ, 2)
	end
end

function HandleZoom(Camera, Fov)
    local Fov, CurrentCFov = Fov, GetCamFov(Camera)
	if IsControlJustPressed(0, 241) then CurrentFov = math.max(Fov - 10.0, FovMin) end
	if IsControlJustPressed(0, 242) then CurrentFov = math.min(Fov + 10.0, FovMax) end

    if CurrentFov >= FovMax then Fov = FovMax end
    if CurrentFov <= FovMin then Fov = FovMin end

	SetCamFov(Camera, CurrentFov + (CurrentFov - CurrentCFov) * 0.05)
end

-- PD Camera

local PDCamFovMin, PDCamFovMax = 10.0, 40.0
function TogglePDCamera(Bool)
    DoingPDCamera = Bool
    if not DoingPDCamera then return end

    CurrentFov = (PDCamFovMin + PDCamFovMax) * 0.5

    SetTimecycleModifier("default")
    SetTimecycleModifierStrength(0.3)

    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_PAPARAZZI", 0, 1)

    Citizen.Wait(2000)

    local ScaleForm = RequestScaleformMovie("security_cam")
	while not HasScaleformMovieLoaded(ScaleForm) do
		Citizen.Wait(10)
	end

    local PDCam = CreateCam('DEFAULT_SCRIPTED_FLY_CAMERA', true)
    AttachCamToEntity(PDCam, PlayerPedId(), 0.0, 0.0, 1.0, true)
    SetCamRot(PDCam, 0.0, 0.0, GetEntityHeading(PlayerPedId()))
    SetCamFov(PDCam, CurrentFov)
    RenderScriptCams(true, false, 0, 1, 0)

    Citizen.CreateThread(function()
        local LastUpdate = GetGameTimer() - 1000
        while DoingPDCamera do
            Citizen.Wait(4)
            local Zoomvalue = (1.0 / (PDCamFovMax - PDCamFovMin)) * (CurrentFov - PDCamFovMin)

            HandleZoom(PDCam, CurrentFov)
            CheckInputRotation(PDCam, Zoomvalue)
            DrawScaleformMovieFullscreen(ScaleForm, 255, 255, 255, 255)

            if GetGameTimer() > (LastUpdate + 1000) then
                LastUpdate = GetGameTimer()
                local Hours, Minutes = exports['mercy-weathersync']:GetCurrentTime()
                local Coords = GetEntityCoords(PlayerPedId())
                local Zone = GetNameOfZone(Coords.x, Coords.y, Coords.z)

                PushScaleformMovieFunction(ScaleForm, "SET_LOCATION")
                PushScaleformMovieFunctionParameterString(GetLabelText(Zone))
                PopScaleformMovieFunctionVoid()
                PushScaleformMovieFunction(ScaleForm, "SET_DETAILS")
                PushScaleformMovieFunctionParameterString(FunctionsModule.GetStreetName(), 'Both')
                PopScaleformMovieFunctionVoid()
                PushScaleformMovieFunction(ScaleForm, "SET_TIME")
                PushScaleformMovieFunctionParameterString(Hours)
                PushScaleformMovieFunctionParameterString(Minutes)
                PopScaleformMovieFunctionVoid()
            end

            SetPauseMenuActive(false)
            if IsControlJustPressed(0, 177) then
                Citizen.SetTimeout(100, function()
                    DoingPDCamera = false
                    SetPauseMenuActive(false)
                end)
            end
        end
        RenderScriptCams(false, false, 1, true, true)
        SetCamActive(PDCam, false)
        SetFocusEntity(PlayerPedId())
        DestroyCam(PDCam, true)
        ClearPedTasks(PlayerPedId())
        ClearTimecycleModifier()
    end)
end

exports("IsInPDCam", function()
    return DoingPDCamera
end)