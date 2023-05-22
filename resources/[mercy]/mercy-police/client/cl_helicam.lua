if not Config.EnableHelicam then return end

local EnabledSpotlights = {}
local HeliCam = nil
local HasHeliCamera = false
local FovMax = 110
local FovMin = 7.5
local CurrentFov = (FovMin + FovMax) * 0.5

-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('mercy-police/client/helicam/sync-spotlight', function(Type, NetId, State, Coords)
    if Type == 1 then
        if EnabledSpotlights[NetId] then
            EnabledSpotlights[NetId].State = State
        end
    elseif Type == 2 then
        if EnabledSpotlights[NetId] then
            EnabledSpotlights[NetId].Coords = Coords
        end
    elseif Type == 3 then
        if State then
            EnabledSpotlights[NetId] = {
                State = State,
                Coords = Coords,
            }
        else
            EnabledSpotlights[NetId] = nil 
        end
    end

    DoSpotlightsLoop()
end)

-- [ Functions ] --

function InitHelicam()
    KeybindsModule.Add('enableHelicam', 'Heli', 'Cam', '', function(IsPressed)
    if not IsPressed then return end
        if not HasHelicam() then return end
        ToggleHeliCamera(not HasHeliCamera)
    end, function()end)
    
    KeybindsModule.Add('heliSpotlight', 'Heli', 'Spotlight', '', function(IsPressed)
        if not IsPressed then return end
        if not HasHelicam() then return end
        if not HasHeliCamera then return end
        local NetId = VehToNet(GetVehiclePedIsIn(PlayerPedId()))

        if EnabledSpotlights[NetId] == nil then
            EnabledSpotlights[NetId] = {
                State = true,
                Coords = {
                    Coords = GetCamCoord(HeliCam),
                    Directions = RotAnglesToVec(GetCamRot(HeliCam, 2)),
                }
            }
            TriggerServerEvent('mercy-police/server/helicam/sync-spotlight', 3, NetId, EnabledSpotlights[NetId].State, EnabledSpotlights[NetId].Coords)
        else
            EnabledSpotlights[NetId].State = not EnabledSpotlights[NetId].State
            TriggerServerEvent('mercy-police/server/helicam/sync-spotlight', 1, NetId, EnabledSpotlights[NetId].State, EnabledSpotlights[NetId].Coords)
        end

    end, function()end)
end

function HasHelicam()
    local Heli = GetVehiclePedIsIn(PlayerPedId())
    if Heli <= 0 then return false end
    if not DoesEntityExist(Heli) then return false end
    return Config.CameraHelicopters[GetEntityModel(Heli)]
end

function ToggleHeliCamera(Bool)
    HasHeliCamera = Bool
    if not HasHeliCamera then return end

    CurrentFov = (FovMin + FovMax) * 0.5

    SetTimecycleModifier("heliGunCam")
    SetTimecycleModifierStrength(0.3)

    local ScaleForm = RequestScaleformMovie("HELI_CAM")
	while not HasScaleformMovieLoaded(ScaleForm) do
		Citizen.Wait(1)
	end

    PushScaleformMovieFunction(ScaleForm, "SET_CAM_LOGO")
    PushScaleformMovieFunctionParameterInt(1)
    PopScaleformMovieFunctionVoid()

    local Heli = GetVehiclePedIsIn(PlayerPedId())
    HeliCam = CreateCam('DEFAULT_SCRIPTED_FLY_CAMERA', true)
    AttachCamToEntity(HeliCam, Heli, -0.5, 2.3, -1.3, true)
    SetCamRot(HeliCam, 0.0, 0.0, GetEntityHeading(PlayerPedId()))
    SetCamFov(HeliCam, CurrentFov)
    RenderScriptCams(true, false, 0, 1, 0)

    DisplayRadar(false)
    exports['mercy-ui']:SendUIMessage('Hud', 'SetAppVisiblity', { Visible = false })
    exports['mercy-ui']:SendUIMessage('HeliCam', 'SetAppVisiblity', { Visible = true })

    Citizen.CreateThread(function()
        local LastUpdate = GetGameTimer() - 500
        local LastSpotlight = GetGameTimer() - 100
        local StreetLocation = ''
        local Zone = ''

        while HasHeliCamera and GetVehiclePedIsIn(PlayerPedId()) ~= 0 do
            Citizen.Wait(4)
            local Zoomvalue = (1.0 / (FovMax - FovMin)) * (CurrentFov - FovMin)

            HandleZoom(HeliCam, CurrentFov)
            CheckInputRotation(HeliCam, Zoomvalue)

            PushScaleformMovieFunction(ScaleForm, "SET_ALT_FOV_HEADING")
            PushScaleformMovieFunctionParameterFloat(GetEntityCoords(Heli).z)
            PushScaleformMovieFunctionParameterFloat(Zoomvalue)
            PushScaleformMovieFunctionParameterFloat(GetCamRot(HeliCam, 2).z)
            PopScaleformMovieFunctionVoid()
            DrawScaleformMovieFullscreen(ScaleForm, 255, 255, 255, 255)
            
            if GetGameTimer() > (LastUpdate + 500) then
                LastUpdate = GetGameTimer()

                local Pos = GetEntityCoords(PlayerPedId(), true)
                local StreetHash, IntersectionHash = GetStreetNameAtCoord(Pos.x, Pos.y, Pos.z, StreetHash, IntersectionHash)
                local StreetName = GetStreetNameFromHashKey(StreetHash)
                local IntersectionName = GetStreetNameFromHashKey(IntersectionHash)
                local Zone = tostring(GetNameOfZone(Pos))
                Zone = GetLabelText(Zone)
    
                if IntersectionName ~= nil and IntersectionName ~= "" then
                    StreetLocation = StreetName .. " [" .. IntersectionName .. "]"
                elseif StreetName ~= nil and StreetName ~= "" then
                    StreetLocation = StreetName
                else
                    StreetLocation = ""
                end

                exports['mercy-ui']:SendUIMessage('HeliCam', 'SetData', {
                    Zone = Zone,
                    Street = StreetLocation,
                })

                CheckForPlateScan()
            end
            
            if GetGameTimer() > (LastSpotlight + 150) then
                if EnabledSpotlights[VehToNet(Heli)] and EnabledSpotlights[VehToNet(Heli)].State then
                    local NetId = VehToNet(Heli)
                    EnabledSpotlights[NetId].Coords = {
                        Coords = GetCamCoord(HeliCam),
                        Directions = RotAnglesToVec(GetCamRot(HeliCam, 2)),
                    }
                    TriggerServerEvent('mercy-police/server/helicam/sync-spotlight', 2, NetId, EnabledSpotlights[NetId].State, EnabledSpotlights[NetId].Coords)
                end
            end
            SetPauseMenuActive(false)
            if IsControlJustPressed(0, 177) then
                Citizen.SetTimeout(100, function()
                    HasHeliCamera = false
                    SetPauseMenuActive(false)
                end)
            end
        end

        HasHeliCamera = false

        RenderScriptCams(false, false, 1, true, true)
        SetCamActive(HeliCam, false)
        SetFocusEntity(PlayerPedId())
        DestroyCam(HeliCam, true)
        ClearPedTasks(PlayerPedId())
        ClearTimecycleModifier()

        Citizen.SetTimeout(200, function()
            if EnabledSpotlights[VehToNet(Heli)] then
                TriggerServerEvent('mercy-police/server/helicam/sync-spotlight', 3, VehToNet(Heli), false, EnabledSpotlights[VehToNet(Heli)].Coords)
            end
        end)

        DisplayRadar(true)
        exports['mercy-ui']:SendUIMessage('Hud', 'SetAppVisiblity', { Visible = true })
        exports['mercy-ui']:SendUIMessage('HeliCam', 'SetAppVisiblity', { Visible = false })
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

function RotAnglesToVec(CamRot)
	local z = math.rad(CamRot.z)
	local x = math.rad(CamRot.x)
	local num = math.abs(math.cos(x))
	return vector3(-math.sin(z)*num, math.cos(z)*num, math.sin(x))
end

local LastPlateScan = nil
function CheckForPlateScan()
    local CamCoords = GetCamCoord(HeliCam)
	local ForwardVector = RotAnglesToVec(GetCamRot(HeliCam, 2))
	local RaycastHandle = CastRayPointToPoint(CamCoords, CamCoords + (ForwardVector * 200.0), 10, GetVehiclePedIsIn(PlayerPedId()), 0)
	local _, _, _, _, EntityHit = GetRaycastResult(RaycastHandle)

	if EntityHit > 0 and IsEntityAVehicle(EntityHit) then
        LastPlateScan = EntityHit
        exports['mercy-ui']:SendUIMessage('HeliCam', 'ScanPlate', {
            Cancel = false,
            Plate = GetVehicleNumberPlateText(EntityHit)
        })
    elseif LastPlateScan ~= nil then
        LastPlateScan = nil
        exports['mercy-ui']:SendUIMessage('HeliCam', 'ScanPlate', {
            Cancel = true,
        })
	end
end

function GetEnabledSpotlights()
    local Retval = 0
    for k, v in pairs(EnabledSpotlights) do
        if v.State then
            Retval = Retval + 1
        end
    end

    return Retval
end

local IsLoopActive = false
function DoSpotlightsLoop()
    if IsLoopActive then return end
    IsLoopActive = true

    Citizen.CreateThread(function()
        local LastCheck = GetGameTimer() - 1000
        while IsLoopActive do
            -- Stop loop if there are no spotlights enabled
            if GetGameTimer() > (LastCheck + 1000) then
                if GetEnabledSpotlights() == 0 then
                    IsLoopActive = false
                end
            end

            for k, v in pairs(EnabledSpotlights) do
                DrawSpotLightWithShadow(v.Coords.Coords.x, v.Coords.Coords.y, (v.Coords.Coords.z - 1.5), v.Coords.Directions.x, v.Coords.Directions.y, v.Coords.Directions.z, 255, 255, 255, 200.0, 10.0, 0.5, 5.0, 10.0, k)
            end

            Citizen.Wait(1)
        end
    end)
end