local TrunkCam = nil

-- [ Events ] --

RegisterNetEvent('mercy-vehicles/client/get-in-trunk', function(Data, Entity)
    if Data.Forced then 
        local TargetEntity, EntityType, TargetCoords = FunctionsModule.GetEntityPlayerIsLookingAt(1.0, 0.2, 286, PlayerPedId())
        if EntityType == 2 then Entity = TargetEntity end
    end

    local LockStatus = GetVehicleDoorLockStatus(Entity)
    if LockStatus ~= 0 and LockStatus ~= 1 and LockStatus ~= 4 then return exports['mercy-ui']:Notify("enter-trunk", "Vehicle is locked..", "error") end
    if (not GetIsDoorValid(Entity, 5)) or Config.DisabledTrunk[GetEntityModel(Entity)] then return exports['mercy-ui']:Notify("enter-trunk", "The vehicles does not have a trunk!", "error") end
    if GetVehicleDoorAngleRatio(Entity, 5) == 0 then return exports['mercy-ui']:Notify("enter-trunk", "The trunk is closed!", "error") end

    local IsEmpty = CallbackModule.SendCallback("mercy-vehicles/server/is-trunk-empty", GetVehicleNumberPlateText(Entity))
    if not IsEmpty then return exports['mercy-ui']:Notify("enter-trunk", "There is already someone in the trunk..", "error") end

    StartTrunkLoop(Entity)
    TriggerServerEvent('mercy-vehicles/server/set-trunk-occupied', GetVehicleNumberPlateText(Entity), true)
end)

-- [ Functions ] --

function StartTrunkLoop(Vehicle)
    FunctionsModule.RequestAnimDict("mp_common_miss")
    
    local MinDimension, MaxDimension = GetModelDimensions(GetEntityModel(Vehicle))
    
    local ZOffset = MaxDimension.z
    if ZOffset > 1.4 then ZOffset = 1.4 - (MaxDimension.z - 1.4) end
    
    AttachEntityToEntity(PlayerPedId(), Vehicle, 0, -0.1, (MinDimension.y + 0.85), (ZOffset - 0.87), 0, 0, 40.0, 1, 1, 1, 1, 1, 1)
    ClearPedTasks(PlayerPedId())

    -- Cam
    TrunkCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(TrunkCam, GetEntityCoords(PlayerPedId()))
    SetCamRot(TrunkCam, 0.0, 0.0, 0.0)
    SetCamActive(TrunkCam, true)
    RenderScriptCams(true, false, 0, true, true)
    SetCamCoord(TrunkCam, GetEntityCoords(PlayerPedId()))
    AttachCamToEntity(TrunkCam, PlayerPedId(), 0.0, -2.5, 1.5, true)
    SetCamFov(TrunkCam, 80.0)

    
    if not PlayerModule.GetPlayerData().MetaData['Handcuffed'] then
        exports['mercy-ui']:SetInteraction("[G] Open/Close, [F] Climb Out")
    else
        exports['mercy-ui']:SetInteraction("[F] Climb Out")
    end
    
    CreateThread(function()
        local InTrunk = true
        while InTrunk do
            local PlayerPed = PlayerPedId()
            SetCamRot(TrunkCam, -20.0, 0.0, GetEntityHeading(PlayerPed) - 15.0)
            
            if not IsEntityPlayingAnim(PlayerPed, "mp_common_miss", "dead_ped_idle", 3) then
                TaskPlayAnim(PlayerPed, "mp_common_miss", "dead_ped_idle", 8.0, 8.0, -1, 2, 999.0, 0, 0, 0)
            end

            if IsEntityDead(PlayerPed) then
                InTrunk = false
            end
            
            if not DoesEntityExist(Vehicle) then
                InTrunk = false
            end
            
            if not PlayerModule.GetPlayerData().MetaData['Handcuffed'] then
                if IsControlJustReleased(0, 47) then
                    if (GetVehicleDoorAngleRatio(Vehicle, 5) == 0) then
                        VehicleModule.SetVehicleDoorOpen(Vehicle, 5)
                    else
                        VehicleModule.SetVehicleDoorShut(Vehicle, 5)
                    end
                end
            end

            if IsDisabledControlJustReleased(0, 23) then
                if GetVehicleDoorAngleRatio(Vehicle, 5) > 0.0 then
                    InTrunk = false
                else
                    exports['mercy-ui']:Notify("enter-trunk", "The trunk is closed!", "error")
                end
            end
            
            Wait(4)
        end
        
        exports['mercy-ui']:HideInteraction()
        
        if DoesCamExist(TrunkCam) then
            RenderScriptCams(false, false, 0, 1, 0)
            DestroyCam(TrunkCam, false)
        end

        StopAnimTask(PlayerPed, "mp_common_miss", "dead_ped_idle", 1.0)

        DetachEntity(PlayerPed)
        if DoesEntityExist(Vehicle) then
        	local DropPosition = GetOffsetFromEntityInWorldCoords(Vehicle, 0.0, MinDimension.y - 0.5, 0.0)
	        SetEntityCoords(PlayerPed, DropPosition.x, DropPosition.y, DropPosition.z)
            TriggerServerEvent('mercy-vehicles/server/set-trunk-occupied', GetVehicleNumberPlateText(Vehicle), false)
	    end
    end)
end

function GetTrunkOffset(Entity)
    local MinDimension, MaxDimension = GetModelDimensions(GetEntityModel(Entity))
    return GetOffsetFromEntityInWorldCoords(Entity, 0.0, MinDimension.y - 0.5, 0.0)
end

function GetInTrunkState()
    return DoesCamExist(TrunkCam)
end
exports('GetInTrunkState', GetInTrunkState)