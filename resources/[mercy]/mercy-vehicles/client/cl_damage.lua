local CurrentMotorDamage, CurrentBodyDamage, InVehicle = 0, 0, false
local CurrentBodyEject, InEjectVehicle = 0, false
local HasBelt, HasHarness = false, false

-- [ Code ] --


-- [ Threads ] --

-- Belt

Citizen.CreateThread(function()
    while KeybindsModule == nil do Citizen.Wait(10) end

    KeybindsModule.Add('toggleBelt', 'Vehicle', 'Toggle Belt', 'B', function(OnPress)
        if not OnPress then return end
        
        local Vehicle = GetVehiclePedIsIn(PlayerPedId())
        local VehicleClass = GetVehicleClass(Vehicle)
        local HarnessLevel = exports['mercy-vehicles']:GetVehicleMeta(Vehicle, "Harness")

        if Vehicle == 0 then return end

        if VehicleClass ~= 8 and VehicleClass ~= 13 and VehicleClass ~= 14 and GetEntityModel(Vehicle) ~= GetHashKey('polbike') then
            if HarnessLevel and HarnessLevel > 0.0 then
                local Text = HasHarness and "Taking off harness" or "Putting on harness"
                local Duration = HasHarness and 2000 or 5000

                exports['mercy-ui']:ProgressBar(Text, Duration, false, false, false, false, function(DidComplete)
                    if DidComplete then
                        if Vehicle == 0 or Vehicle == -1 then return end

                        local CurrentHarnessLevel = exports['mercy-vehicles']:GetVehicleMeta(Vehicle, "Harness")
                        SetVehicleMeta(Vehicle, "Harness", CurrentHarnessLevel - 1.0)
        
                        HasHarness, HasBelt = not HasHarness, false
                        TriggerEvent('mercy-ui/client/play-sound', HasHarness and 'vehicle.on' or 'vehicle.off', 0.45)
                    end
                end)
            else
                HasBelt = not HasBelt
                TriggerEvent('mercy-ui/client/play-sound', HasBelt and 'vehicle.on' or 'vehicle.off', 0.45)
            end
        end
    end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            if Vehicle == 0 or Vehicle == -1 or not HasHarness then goto SkipLoop end

            DisableControlAction(0, 75, true)
            if IsDisabledControlJustReleased(1, 75) then
                exports['mercy-ui']:Notify('unbuckle-harness', "Maybe unbuckle your harness?", "error")
            end

            ::SkipLoop::
        else
            Citizen.Wait(750)
        end
    end
end)

-- Engine / Body

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            if IsPedInAnyVehicle(PlayerPedId()) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
                local Vehicle = GetVehiclePedIsIn(PlayerPedId())
                local VehicleClass = GetVehicleClass(Vehicle)
                local CurrentMotor, CurrentBody = GetVehicleEngineHealth(Vehicle), GetVehicleBodyHealth(Vehicle)
                if not InVehicle then
                    InVehicle = true
                    CurrentBodyDamage = GetVehicleBodyHealth(Vehicle)
                    CurrentMotorDamage = GetVehicleEngineHealth(Vehicle)
                    if CurrentMotorDamage <= Config.EngineSafeGuard then
                        SetVehicleUndriveable(Vehicle, true)
                    else
                        SetVehicleUndriveable(Vehicle, false)
                    end
                end
                if CurrentBody < CurrentBodyDamage or CurrentBody > CurrentBodyDamage and CurrentBody ~= CurrentBodyDamage then
                    if CurrentBody < Config.BodySafeGuard then
                        SetVehicleBodyHealth(Vehicle, Config.BodySafeGuard)
                        CurrentBodyDamage = Config.BodySafeGuard
                    else
                        if (CurrentBodyDamage - CurrentBody) > 45.0 and VehicleClass ~= 15 and VehicleClass ~= 13 then
                            EventsModule.TriggerServer('mercy-business/server/hayes/do-parts-damage', GetVehicleNumberPlateText(Vehicle), GetEntityModel(Vehicle), 'Body')
                        end
                        CurrentBodyDamage = CurrentBody
                    end
                end
                if CurrentMotor < CurrentMotorDamage or CurrentMotor > CurrentMotorDamage and CurrentMotor ~= CurrentMotorDamage then
                    if CurrentMotor < Config.EngineSafeGuard then
                        SetVehicleEngineHealth(Vehicle, Config.EngineSafeGuard)
                        SetVehicleUndriveable(Vehicle, true)
                        CurrentMotorDamage = Config.EngineSafeGuard
                    else
                        if (CurrentMotorDamage - CurrentMotor) > 45.0 and VehicleClass ~= 15 and VehicleClass ~= 13 then
                            SetVehicleEngineHealth(Vehicle, CurrentMotor - 25.0)
                            SetVehicleUndriveable(Vehicle, true)
                            SetVehicleEngineOn(Vehicle, false, true, true)
                            exports['mercy-ui']:Notify('vehicle-engine', "Vehicle engine stalled..", 'error')
                            EventsModule.TriggerServer('mercy-business/server/hayes/do-parts-damage', GetVehicleNumberPlateText(Vehicle), GetEntityModel(Vehicle), 'Engine')
                            if CurrentHarnessLevel then
                                SetVehicleMeta(Vehicle, "Harness", CurrentHarnessLevel - 1.5)
                                Citizen.SetTimeout(1000, function()
                                    SetVehicleUndriveable(Vehicle, false)
                                end)
                            end
                        end
                        CurrentMotorDamage = CurrentMotor
                    end
                end
                if InVehicle and CurrentMotor <= Config.EngineSafeGuard then
                    SetVehicleUndriveable(Vehicle, true)
                    Citizen.Wait(150)
                end
                Citizen.Wait(250)
            else
                InVehicle, CurrentMotorDamage, CurrentBodyDamage = false, 0, 0
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- Wheels & Ejecting

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            if IsPedInAnyVehicle(PlayerPedId()) then
                local Vehicle = GetVehiclePedIsIn(PlayerPedId())
                local VehicleClass = GetVehicleClass(Vehicle)
                local CurrentVehicleSpeed, CurrentBody = GetEntitySpeed(Vehicle) * 2.236936, GetVehicleBodyHealth(Vehicle)
                if not InEjectVehicle then
                    InEjectVehicle = true
                    CurrentBodyEject = GetVehicleBodyHealth(Vehicle)
                end
                if CurrentBody < CurrentBodyEject or CurrentBody > CurrentBodyEject and CurrentBody ~= CurrentBodyEject then
                    if not HasHarness and math.ceil(CurrentBodyEject - CurrentBody) > 35.0 then
                        if CurrentHarnessLevel then SetVehicleMeta(Vehicle, "Harness", CurrentHarnessLevel - 1.0) end
                        if (not HasBelt and CurrentVehicleSpeed > math.random(60, 80)) or (HasBelt and CurrentVehicleSpeed > math.random(100, 120)) then
                            if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() and VehicleClass ~= 15 and VehicleClass ~= 16 then
                                DoWheelDamage(Vehicle)
                            end
                            EjectFromVehicle(Vehicle, GetEntityVelocity(Vehicle))  
                        end
                    end
                    CurrentBodyEject = CurrentBody
                end
            else
                if InEjectVehicle then
                    InEjectVehicle, CurrentBodyEject = false, 0
                end
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- Flipping

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(4)
--         if LocalPlayer.state.LoggedIn and IsPedInAnyVehicle(PlayerPedId()) then
--             local Vehicle = GetVehiclePedIsIn(PlayerPedId())
--             if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() then
--                 local VehicleRoll = GetEntityRoll(Vehicle)
-- 				if (VehicleRoll > 75.0 or VehicleRoll < -75.0) and GetEntitySpeed(Vehicle) < 3.0 then
-- 					DisableControlAction(2, 59, true)
-- 					DisableControlAction(2, 60, true)
-- 				end
--             else
--                 Citizen.Wait(450)
--             end
--         else
--             Citizen.Wait(450)
--         end
--     end
-- end)

-- [ Functions ] --

function EjectFromVehicle(Vehicle, Velocity)
    local Coords = GetOffsetFromEntityInWorldCoords(Vehicle, 1.0, 0.0, 1.0)
    local EjectSpeed = math.ceil(GetEntitySpeed(PlayerPedId()) * 8)
    SetEntityCoords(PlayerPedId(), Coords)
    SetPedToRagdoll(PlayerPedId(), 5511, 5511, 0, 0, 0, 0)
    SetEntityVelocity(PlayerPedId(), Velocity.x * 4, Velocity.y * 4, Velocity.z * 4)
end

function DoWheelDamage(Vehicle)
    local Wheels = {0, 1, 4, 5}
    for i = 1, math.random(4) do
        local Wheel = math.random(#Wheels)
        VehicleModule.SetVehicleTyreBurst(Vehicle, Wheels[Wheel], true, 1000.0)
        table.remove(Wheels, Wheel)
    end
end

function GetBeltStatus()
    return HasBelt or HasHarness
end
exports('GetBeltStatus', GetBeltStatus)