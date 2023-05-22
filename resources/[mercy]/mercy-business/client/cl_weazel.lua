local HasNewsCam, HasNewsMic = false, false
local CameraCam, CameraScaleform = false, false
local Microphone = false

Citizen.CreateThread(function()
    exports['mercy-ui']:AddEyeEntry("news-grab-equipment", {
        Type = 'Zone',
        SpriteDistance = 10.0,
        Distance = 1.0,
        ZoneData = {
            Center = vector3(-594.17, -929.23, 23.78),
            Length = 3.0,
            Width = 1.0,
            Data = {
                heading = 0,
                minZ = 23.53,
                maxZ = 23.98
            },
        },
        Options = {
            {
                Name = 'grab_camera',
                Icon = 'fas fa-camera',
                Label = 'Buy Camera ($ 100.00)',
                EventType = 'Server',
                EventName = 'mercy-business/server/news/purchase-camera',
                EventParams = {},
                Enabled = function(Entity)
                    if exports['mercy-business']:HasPlayerBusinessPermission('Weazel News', 'property_keys') then
                        return true
                    end
                end,
            },
            {
                Name = 'grab_mic',
                Icon = 'fas fa-microphone',
                Label = 'Buy Microphone ($ 100.00)',
                EventType = 'Server',
                EventName = 'mercy-business/server/news/purchase-mic',
                EventParams = {},
                Enabled = function(Entity)
                    if exports['mercy-business']:HasPlayerBusinessPermission('Weazel News', 'property_keys') then
                        return true
                    end
                end,
            },
        }
    })
end)

-- [ Events ] --

RegisterNetEvent("mercy-items/client/used-newscam", function()
    local FovMax, FovMin = 70.0, 5.0
    local ZoomSpeed = 10.0
    local SpeedLR, SpeedUD = 8.0, 8.0
    local CameraFov = (FovMax+FovMin)/2

    HasNewsCam = not HasNewsCam
    if not HasNewsCam then return end

    Citizen.CreateThread(function()
        FunctionsModule.RequestModel("prop_v_cam_01")
        FunctionsModule.RequestAnimDict("missfinale_c2mcs_1")

        local CamCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, -5.0)
        local Camera = CreateObjectNoOffset(GetHashKey("prop_v_cam_01"), CamCoords.x, CamCoords.y, CamCoords.z, true, true, false)
        Citizen.Wait(100)
        SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(Camera), true)
        NetworkSetNetworkIdDynamic(NetworkGetNetworkIdFromEntity(Camera), true)
        SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(Camera), false)
        AttachEntityToEntity(Camera, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
        TaskPlayAnim(PlayerPedId(), "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 1.0, -1, -1, 50, 0, 0, 0, 0)

        SetTimecycleModifier("default")
        SetTimecycleModifierStrength(0.3)
        CameraScaleform = RequestScaleformMovie("security_camera")
        while not HasScaleformMovieLoaded(CameraScaleform) do Citizen.Wait(10) end
        CameraCam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
        AttachCamToEntity(CameraCam, PlayerPedId(), 0.0, 0.0, 1.0, true)
        SetCamRot(CameraCam, 2.0, 1.0, GetEntityHeading(PlayerPedId()))
        SetCamFov(CameraCam, CameraFov)
        RenderScriptCams(true, false, 0, 1, 0)
        PushScaleformMovieFunction(CameraScaleform, "SET_CAM_LOGO")
        PopScaleformMovieFunctionVoid()
        while HasNewsCam do
            if not IsEntityPlayingAnim(PlayerPedId(), "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 3) then
                TaskPlayAnim(PlayerPedId(), "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 1.0, -1, -1, 50, 0, 0, 0, 0)
            end
            DisablePlayerFiring(PlayerId(), true)
            DisableControlAction(0, 25, true)
			DisableControlAction(0, 44, true)
			DisableControlAction(0, 37, true)
            local RightAxisX = GetDisabledControlNormal(0, 220)
            local RightAxisY = GetDisabledControlNormal(0, 221)
            local Rotation = GetCamRot(CameraCam, 2)

            if RightAxisX ~= 0.0 or RightAxisY ~= 0.0 then
                local ZoomValue = (1.0 / (FovMax - FovMin)) * (CameraFov - FovMin)
                SetCamRot(CameraCam, math.max(math.min(20.0, Rotation.x + RightAxisY * -1.0 * (SpeedLR) * (ZoomValue+0.1)), -89.5), 0.0, Rotation.z + RightAxisX * -1.0 * (SpeedUD) * (ZoomValue + 0.1), 2)
                -- SetEntityRotation(PlayerPedId(), 0, 0, new_z, 2, true)
            end

            local CurrentFov = GetCamFov(CameraCam)
            if IsControlJustPressed(0,241) then CameraFov = math.max(CameraFov - ZoomSpeed, FovMin) end
            if IsControlJustPressed(0,242) then CameraFov = math.min(CameraFov + ZoomSpeed, FovMax) end
            if math.abs(CameraFov - CurrentFov) < 0.1 then CameraFov = CurrentFov end
            SetCamFov(CameraCam, CurrentFov + (CameraFov - CurrentFov) * 0.05)
            DrawScaleformMovieFullscreen(CameraScaleform, 255, 255, 255, 255)
            local CamHeading = GetGameplayCamRelativeHeading()
            local CamPitch = GetGameplayCamRelativePitch()
            if CamPitch < -70.0 then
                CamPitch = -70.0
            elseif CamPitch > 42.0 then
                CamPitch = 42.0
            end
            CamPitch = (CamPitch + 70.0) / 112.0
            
            if CamHeading < -180.0 then
                CamHeading = -180.0
            elseif CamHeading > 180.0 then
                CamHeading = 180.0
            end
            CamHeading = (CamHeading + 180.0) / 360.0
            SetTaskMoveNetworkSignalFloat(PlayerPedId(), "Pitch", CamPitch)
            SetTaskMoveNetworkSignalFloat(PlayerPedId(), "Heading", CamHeading * -1.0 + 1.0)
            Citizen.Wait(4)
        end
        ClearTimecycleModifier()
        RenderScriptCams(false, false, 0, 1, 0)
        SetScaleformMovieAsNoLongerNeeded(CameraScaleform)
        DestroyCam(CameraCam, false)
        SetNightvision(false)
        SetSeethrough(false)
        DeleteObject(Camera)
        StopAnimTask(PlayerPedId(), "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 1.0)
    end)
end)

RegisterNetEvent("mercy-items/client/used-newsmic", function()
    HasNewsMic = not HasNewsMic
    if not HasNewsMic then
        DeleteObject(Microphone)
        return
    end
    FunctionsModule.RequestModel("p_ing_microphonel_01")
    local MicCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, -5.0)
    Microphone = CreateObject(GetHashKey("p_ing_microphonel_01"), MicCoords.x, MicCoords.y, MicCoords.z, 1, 1, 1)
    Citizen.Wait(100)
    SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(Microphone), true)
    NetworkSetNetworkIdDynamic(NetworkGetNetworkIdFromEntity(Microphone), true)
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(Microphone), false)
    AttachEntityToEntity(Microphone, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.055, 0.05, 0.0, 240.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
end)