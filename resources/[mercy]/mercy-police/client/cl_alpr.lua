local AlprVisible = false
local AlprLocked = false
local FwdData = { Plate = "NONE", Speed = "000" }
local BwdData = { Plate = "NONE", Speed = "000" }

RegisterNetEvent('mercy-base/client/on-logout', function()
	AlprVisible = false
    exports['mercy-ui']:SendUIMessage("ALPR", "SetVisibility", { Visible = AlprVisible})
end)

RegisterNetEvent("mercy-threads/entered-vehicle", function()
    local Vehicle = GetVehiclePedIsIn(PlayerPedId())

    if AlprVisible then
        if not exports['mercy-vehicles']:IsGovVehicle(Vehicle) then 
            AlprVisible = false
            return 
        end

        FwdData = { Plate = "NONE", Speed = "000" }
        BwdData = { Plate = "NONE", Speed = "000" }
        StartAlpr()

        exports['mercy-ui']:SendUIMessage("ALPR", "SetVisibility", { Visible = true })
    end
end)

RegisterNetEvent("mercy-threads/exited-vehicle", function()
    local Vehicle = GetVehiclePedIsIn(PlayerPedId(), true)

    exports['mercy-ui']:SendUIMessage("ALPR", "SetVisibility", { Visible = false })
end)

function InitAlpr()
    KeybindsModule.Add('enableAlpr', 'Services', 'Toggle ALPR', '', function(IsPressed)
        if not IsPressed then return end
        local Vehicle = GetVehiclePedIsIn(PlayerPedId())
        if Vehicle == 0 then return end
        if not exports['mercy-vehicles']:IsGovVehicle(Vehicle) then return end

        AlprVisible = not AlprVisible
        if AlprVisible then
            StartAlpr()
        end

        exports['mercy-ui']:SendUIMessage("ALPR", "SetVisibility", { Visible = AlprVisible })
    end, function()end)

    KeybindsModule.Add('lockAlpr', 'Services', 'Lock ALPR', '', function(IsPressed)
        if not IsPressed then return end
        if not AlprVisible then return end
        local Vehicle = GetVehiclePedIsIn(PlayerPedId())
        if Vehicle == 0 then return end
        if not exports['mercy-vehicles']:IsGovVehicle(Vehicle) then return end

        AlprLocked = not AlprLocked

        if AlprLocked then
            exports['mercy-ui']:Notify("police-alpr", "ALPR Locked!", "error")
        else
            exports['mercy-ui']:Notify("police-alpr", "ALPR Unlocked!", "success")
        end
    end, function()end)
end

function Round(Num)
    return tonumber(string.format("%.0f", Num))
end

function StartAlpr()
    local LastForwardScan = "NONE"
    local LastBackwardScan = "NONE"
    
    Citizen.CreateThread(function()
        local Vehicle = GetVehiclePedIsIn(PlayerPedId())
        while AlprVisible and GetVehiclePedIsIn(PlayerPedId()) == Vehicle do
            local VehiclePos = GetEntityCoords(Vehicle)

            FwdData = { Plate = "NONE", PlateText = "NONE", Speed = "000" }
            BwdData = { Plate = "NONE", PlateText = "NONE", Speed = "000" }

            if not AlprLocked then
                -- Forward
                local ForwardPosition = GetOffsetFromEntityInWorldCoords(Vehicle, 0.0, 35.0, 0.0)
                local ForwardPos = { x = ForwardPosition.x, y = ForwardPosition.y, z = ForwardPosition.z }
                local _, ForwardZ = GetGroundZFor_3dCoord( ForwardPos.x, ForwardPos.y, ForwardPos.z + 500.0 )
    
                if (ForwardPos.z < ForwardZ and not (ForwardZ > VehiclePos.z + 1.0)) then 
                    ForwardPos.z = ForwardZ + 0.5
                end 
    
                local PackedForwardPos = vector3(ForwardPos.x, ForwardPos.y, ForwardPos.z)
                local ForwardVehicle = GetVehicleInDirectionSphere(Vehicle, VehiclePos, PackedForwardPos)
    
                if DoesEntityExist(ForwardVehicle) and IsEntityAVehicle(ForwardVehicle) then
                    local ForwardSpeed = tostring(Round(GetEntitySpeed(ForwardVehicle) * 2.236936))
                    if #ForwardSpeed == 2 then
                        ForwardSpeed = "0" .. ForwardSpeed
                    elseif #ForwardSpeed == 1 then
                        ForwardSpeed = "00" .. ForwardSpeed
                    end

                    local ForwardPlate = GetVehicleNumberPlateText(ForwardVehicle)
                    if LastForwardScan ~= ForwardPlate then
                        local Result = CallbackModule.SendCallback("mercy-police/server/is-plate-flagged", ForwardPlate)
                        if Result then
                            if Result.Flagged == 1 then
                                LastForwardScan = ForwardPlate
                                ForwardPlate  = ForwardPlate .. ' (F)'
                                PlaySoundFrontend(-1, "Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
                                Citizen.Wait(100)
                                PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
                                Citizen.Wait(100)
                                PlaySoundFrontend(-1, "Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
                                Citizen.Wait(100)
                                PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
                                exports['mercy-ui']:Notify("police-alpr-front", "Forward vehicle seems to be flagged in the system!", "error")
                            end
                        end
                    end
    
                    FwdData = {
                        Plate = GetVehicleNumberPlateText(ForwardVehicle),
                        PlateText = ForwardPlate,
                        Speed = ForwardSpeed
                    }
                else 
                    LastForwardScan = "NONE"
                end
                
                -- Backward
                local BackwardPosition = GetOffsetFromEntityInWorldCoords(Vehicle, 0.0, -35.0, 0.0)
                local BackwardPos = { x = BackwardPosition.x, y = BackwardPosition.y, z = BackwardPosition.z }
                local _, BackwardZ = GetGroundZFor_3dCoord( BackwardPos.x, BackwardPos.y, BackwardPos.z + 500.0 )
    
                if (BackwardPos.z < BackwardZ and not (BackwardZ > VehiclePos.z + 1.0)) then 
                    BackwardPos.z = BackwardZ + 0.5
                end 
    
                local PackedBackwardPos = vector3(BackwardPos.x, BackwardPos.y, BackwardPos.z)
                local BackwardVehicle = GetVehicleInDirectionSphere(Vehicle, VehiclePos, PackedBackwardPos)
    
                if DoesEntityExist(BackwardVehicle) and IsEntityAVehicle(BackwardVehicle) then
                    local BackwardSpeed = tostring(Round(GetEntitySpeed(BackwardVehicle) * 2.236936))
                    if #BackwardSpeed == 2 then
                        BackwardSpeed = "0" .. BackwardSpeed
                    elseif #BackwardSpeed == 1 then
                        BackwardSpeed = "00" .. BackwardSpeed
                    end

                    local BackwardPlate = GetVehicleNumberPlateText(BackwardVehicle)
                    if LastBackwardScan ~= BackwardPlate then
                        local Result = CallbackModule.SendCallback("mercy-police/server/is-plate-flagged", BackwardPlate)
                        if Result then 
                            if Result.Flagged == 1 then
                                LastBackwardScan = BackwardPlate
                                BackwardPlate  = BackwardPlate .. ' (F)'
                                PlaySoundFrontend(-1, "Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
                                Citizen.Wait(100)
                                PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
                                Citizen.Wait(100)
                                PlaySoundFrontend(-1, "Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
                                Citizen.Wait(100)
                                PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
                                exports['mercy-ui']:Notify("police-alpr-front", "Backward vehicle seems to be flagged in the system!", "error")
                            end
                        end
                    end
    
                    BwdData = {
                        Plate = GetVehicleNumberPlateText(BackwardVehicle),
                        PlateText = BackwardPlate,
                        Speed = BackwardSpeed
                    }
                else 
                    LastBackwardScan = "NONE"
                end
    
                exports['mercy-ui']:SendUIMessage("ALPR", "SetValues", {
                    SpeedFwd = FwdData.Speed,
                    PlateFwd = FwdData.PlateText,
                    SpeedBwd = BwdData.Speed,
                    PlateBwd = BwdData.PlateText,
                })
            end

            Citizen.Wait(300)
        end
    end)
end

function GetVehicleInDirectionSphere(Entity, CoordFrom, CoordTo)
    local RayHandle = StartShapeTestCapsule(CoordFrom.x, CoordFrom.y, CoordFrom.z, CoordTo.x, CoordTo.y, CoordTo.z, 2.0, 10, Entity, 7)
    local _, _, _, _, Vehicle = GetShapeTestResult(RayHandle)
    return Vehicle
end