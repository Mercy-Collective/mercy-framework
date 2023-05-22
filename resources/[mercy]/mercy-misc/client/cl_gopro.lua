local GoProCam, ActiveGoPros, ActiveVehGoPros = false, {}, {}

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            local PlayerCoords = GetEntityCoords(PlayerPedId())

            if Config.GoPros == nil then Config.GoPros = {} end

            for k, v in ipairs(Config.GoPros) do
                if k % 100 == 0 then
                    Citizen.Wait(0)
                end

                if not v.IsVehicle then
                    if #(PlayerCoords - vector3(v.Coords.X, v.Coords.Y, v.Coords.Z)) < 50.0 then
                        local Entity = CreateGoPro(v.Coords)
                        if Entity then
                            ActiveGoPros[v.Id] = {
                                Object = Entity,
                            }
                        end
                    else
                        RemoveGoPro(v.Id)
                    end
                else
                    if not DoesEntityExist(v.Vehicle) then
                        RemoveVehGoPro(v.Id)
                    else
                        local Entity = CreateVehGoPro(v.Vehicle)
                        if Entity then
                            ActiveVehGoPros[v.Id] = {
                                Object = Entity,
                            }
                        end
                    end
                end
            end

            Citizen.Wait(3500)
        else
            Citizen.Wait(450)
        end
    end
end)

-- [ Events ] --

RegisterNetEvent("mercy-misc/client/gopros/view-camera", function(Data)
    local CameraData = GetGoProById(Data.CamId)
    if not CameraData then return exports['mercy-ui']:Notify("gopro-error", "Cam does not exist?", "error") end

    local PlayerJob = PlayerModule.GetPlayerData().Job
    if CameraData.IsEncrypted and (PlayerJob.Name ~= 'police' or not PlayerJob.Duty) then return exports['mercy-ui']:Notify("gopro-error", "You can't connect to this GoPro..", "error") end

    exports['mercy-inventory']:SetBusyState(true)

    if CameraData.Blurred then
        SetTimecycleModifier("CAMERA_secuirity_FUZZ")
        SetTimecycleModifierStrength(1.5)
    else
        SetTimecycleModifier("heliGunCam")
        SetTimecycleModifierStrength(1.0)
    end

    if GoProCam then
        DestroyCam(GoProCam, true)
        InsideCam, GoProCam = false, nil
        exports['mercy-ui']:HideInteraction()
    end

    GoProCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    if CameraData.IsVehicle then
        local VehicleCoords = GetEntityCoords(CameraData.Vehicle)
        SetCamCoord(GoProCam, VehicleCoords.x, VehicleCoords.y, VehicleCoords.z)
        SetFocusArea(VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, 0.0, 0.0, 0.0)
        local VehOffset = GetOffsetFromEntityGivenWorldCoords(CameraData.Vehicle, VehicleCoords.x, VehicleCoords.y, VehicleCoords.z)
        AttachCamToEntity(GoProCam, CameraData.Vehicle, VehOffset.x, VehOffset.y - 0.5, VehOffset.z + 0.7, true)
    else
        SetCamCoord(GoProCam, CameraData.Coords.X, CameraData.Coords.Y, CameraData.Coords.Z)
        SetFocusArea(CameraData.Coords.X, CameraData.Coords.Y, CameraData.Coords.Z, 0.0, 0.0, 0.0)
        SetCamRot(GoProCam, -15.0, 0.0, CameraData.Coords.H + 180)
    end
    SetCamFov(GoProCam, 110.0)
    SetCamActive(GoProCam, true)
    RenderScriptCams(true, false, 0, 1, 0)
    InsideCam = true

    exports['mercy-ui']:SetInteraction('[ESC] Close', 'error')

    Citizen.CreateThread(function()
        local DisablePause = true
        Citizen.CreateThread(function()
            while DisablePause do
                SetPauseMenuActive(false)
                
                if IsControlJustPressed(0, 177) then
                    Citizen.SetTimeout(500, function()
                        DisablePause = false
                    end)
                end
                
                Citizen.Wait(0)
            end
        end)
    end)
    
    while InsideCam do
        DisableControlAction(0, 30, true) 
        DisableControlAction(0, 36, true) 
        DisableControlAction(0, 31, true) 
        DisableControlAction(0, 36, true) 
        DisableControlAction(0, 21, true) 
        DisableControlAction(0, 75, true) 
        DisableControlAction(27, 75, true)

        local CamRot = GetCamRot(GoProCam, 2)
        if CameraData.IsVehicle then
            SetCamRot(GoProCam, -15.0, 0.0, GetEntityHeading(CameraData.Vehicle))
        end
        SetCamCoord(GoProCam, CameraData.Coords.X, CameraData.Coords.Y, CameraData.Coords.Z)

        if IsControlJustPressed(1, 177) then
            DestroyCam(GoProCam, true)
            InsideCam, GoProCam = false, nil
            exports['mercy-ui']:HideInteraction()
            exports['mercy-inventory']:SetBusyState(false)
        end

        Citizen.Wait(4)
    end

    ClearFocus()
    ClearTimecycleModifier()
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(GoProCam, false)
    SetNightvision(false)
    SetSeethrough(false)    
end)

RegisterNetEvent('mercy-misc/client/use-gopro', function(IsEncrypted)
    EntityModule.DoEntityPlacer('prop_spycam', 4.5, false, true, nil, function(DidPlace, Coords, Heading)
        if not DidPlace then return exports['mercy-ui']:Notify("GoPro-error", "You stopped placing the GoPro or an error occured..", "error") end
        local DidRemove = CallbackModule.SendCallback("mercy-base/server/remove-item", IsEncrypted and 'gopropd' or 'gopro', 1, false, true)
        if DidRemove then
            local IsVehicle = false
            local Vehicle = VehicleModule.GetClosestVehicle()
            if Vehicle['Distance'] <= 2.0 then
                IsVehicle = true
            end
            EventsModule.TriggerServer('mercy-misc/server/gopro-place', Coords, Heading, IsEncrypted, IsVehicle, Vehicle['Vehicle'])
        end
    end)
end)

RegisterNetEvent('mercy-misc/client/gopro-action', function(Type, Data)
    if Type == 1 then -- Change Full Data
        Config.GoPros = Data
    end
    if Type == 2 then -- Add New
        Config.GoPros[#Config.GoPros + 1] = Data
    end
    if Type == 3 then -- Update
        for k, v in ipairs(Config.GoPros) do
            if v.Id == Data.Id then
                Config.GoPros[k] = Data
                break
            end
        end
    end
    if Type == 4 then -- Remove
        for k, v in ipairs(Config.GoPros) do
            if v.Id == Data.Id then
                table.remove(Config.GoPros, k)
                RemoveGoPro(v.Id)
                break
            end
        end
    end
end)

RegisterNetEvent('mercy-misc/client/gopro-blurcamera', function(Data, Entity)
    local GoPro = GetGoProId(Entity)
    local Outcome = exports['mercy-ui']:StartSkillTest(1, { 1, 5 }, { 12000, 18000 }, false)
    if Outcome then
        TriggerServerEvent("mercy-misc/server/gopro-action", GoPro, "SetBlurred", true)
        exports['mercy-ui']:Notify("gopro-error", "Smudged camera!", "success")
    else
        exports['mercy-ui']:Notify("gopro-error", "Failed..", "error")
    end
end)

-- [ Functions ] --

function CreateGoPro(Coords)
    local GoProObject = EntityModule.CreateEntity("prop_spycam", Coords.X, Coords.Y, Coords.Z, true)
    if GoProObject then
        FreezeEntityPosition(GoProObject, true)
        SetEntityHeading(GoProObject, Coords.H + 0.0)
        SetEntityCollision(GoProObject, false, false)
        return GoProObject
    else
        return false
    end
end

function CreateVehGoPro(Vehicle)
    local VehCoords = GetEntityCoords(Vehicle)
    local VehHeading = GetEntityHeading(Vehicle)
    local GoProObject = EntityModule.CreateEntity("prop_spycam", VehCoords.x, VehCoords.y, VehCoords.z, true)
    if GoProObject then
        local VehOffset = GetOffsetFromEntityGivenWorldCoords(Vehicle, VehCoords.x, VehCoords.y, VehCoords.z)
        SetEntityCollision(GoProObject, false, false)
        AttachEntityToEntity(GoProObject, Vehicle, 0, VehOffset.x, VehOffset.y - 0.5, VehOffset.z + 0.7, -180.0, 0, 0.0, 1, 1, 1, 1, 1, 1)
        return GoProObject
    else
        return false
    end
end

function RemoveVehGoPro(GoProId)
    if ActiveVehGoPros[GoProId] ~= nil then
        SetEntityAsMissionEntity(ActiveVehGoPros[GoProId]['Object'], true, true)
        EntityModule.DeleteEntity(ActiveVehGoPros[GoProId]['Object'])
        DeleteObject(ActiveVehGoPros[GoProId]['Object'])
        for k, v in pairs(Config.GoPros) do
            if tonumber(v.Id) == tonumber(GoProId) then
                table.remove(Config.GoPros, k)
                break
            end
        end
        ActiveVehGoPros[GoProId] = nil
    end
end

function RemoveGoPro(GoProId)
    if ActiveGoPros[GoProId] ~= nil then
        SetEntityAsMissionEntity(ActiveGoPros[GoProId]['Object'], true, true)
        EntityModule.DeleteEntity(ActiveGoPros[GoProId]['Object'])
        DeleteObject(ActiveGoPros[GoProId]['Object'])
        ActiveGoPros[GoProId] = nil
    end
end

function GetGoProId(Entity)
    for k, v in pairs(ActiveGoPros) do
        if v['Object'] == Entity then
            return k
        end
    end
    return false
end

function GetGoProById(GoProId)
    for k, v in pairs(Config.GoPros) do
        if tonumber(v.Id) == tonumber(GoProId) then
            return v
        end
    end
    return false
end

function InitGoPros()
    -- Get gopro config from server.
    exports['mercy-ui']:AddEyeEntry(GetHashKey("prop_spycam"), {
        Type = 'Model',
        Model = 'prop_spycam',
        SpriteDistance = 5.0,
        Options = {
            {
                Name = 'cam_blur_action',
                Icon = 'fas fa-fingerprint',
                Label = 'Smudge',
                EventType = 'Client',
                EventName = 'mercy-misc/client/gopro-blurcamera',
                EventParams = '',
                Enabled = function(Entity)
                    return (not exports['mercy-misc']:IsGoProBlurred(Entity))
                end,
            },
        }
    })
end

exports("IsGoProBlurred", function(Entity)
    local GoProId = GetGoProId(Entity)
    if not GoProId then return true end -- not true = false :)

    local GoProData = GetGoProById(GoProId)
    if not GoProData then return true end -- not true = false :)

    return GoProData.Blurred
end)