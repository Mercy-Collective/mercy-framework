local CurrentPursuit, PursuitNumber = 'B', 1
local PursuitModes = {'B', 'A', 'S'}

-- [ Threads ] --

CreateThread(function()
    while KeybindsModule == nil do Wait(100) end

    KeybindsModule.Add('switchPursuit', 'Vehicle', 'Switch Pursuit Modes', '', function(OnPress)
        if not OnPress then return end
        local Vehicle = CurrentVehicleData.Vehicle
        if Vehicle == 0 or Vehicle == -1 or not CurrentVehicleData.IsDriver then return end
            
        if not IsPoliceVehicle(Vehicle) then 
            return 
        end

        if PursuitNumber + 1 > #PursuitModes then
            CurrentPursuit, PursuitNumber = 'B', 1
        else
            PursuitNumber = PursuitNumber + 1
            CurrentPursuit = PursuitModes[PursuitNumber]
        end

        TriggerEvent('mercy-ui/client/set-hud-values', 'PursuitMode', 'Value', CurrentPursuit)
        exports['mercy-ui']:Notify('pursuit', "Pursuit mode: "..CurrentPursuit:upper())
        SetPursuitMode(Vehicle)
    end)
end)

-- [ Events ] --

RegisterNetEvent("mercy-threads/entered-vehicle", function() 
    local Vehicle = CurrentVehicleData.Vehicle
    if not IsPoliceVehicle(Vehicle) or not IsThisAPursuitVehicle(Vehicle) then return end
    if Vehicle == 0 or Vehicle == -1 or not CurrentVehicleData.IsDriver then return end

    TriggerEvent('mercy-ui/client/set-hud-values', 'PursuitMode', 'Value', CurrentPursuit)
    TriggerEvent('mercy-ui/client/set-hud-values', 'PursuitMode', 'Show', true)
    SetPursuitMode(Vehicle)
end)

RegisterNetEvent("mercy-threads/exited-vehicle", function() 
    local Vehicle = CurrentVehicleData.Vehicle
    if Vehicle == 0 or Vehicle == -1 or not IsPoliceVehicle(Vehicle) or not IsThisAPursuitVehicle(Vehicle) then return end

    TriggerEvent('mercy-ui/client/set-hud-values', 'PursuitMode', 'Value', 'B')
    TriggerEvent('mercy-ui/client/set-hud-values', 'PursuitMode', 'Show', false)
    CurrentPursuit, PursuitNumber = 'B', 1
end)

-- [ Functions ] --

function SetPursuitMode(Vehicle)
    local PursuitData = IsThisAPursuitVehicle(Vehicle)
    if not PursuitData then return end

    local DriveInertia = GetVehicleHandlingFloat(Vehicle, 'CHandlingData', 'fDriveInertia')
    local DriveForce = GetVehicleHandlingFloat(Vehicle, 'CHandlingData', 'fInitialDriveForce')
    if PursuitData[CurrentPursuit].DriveForce ~= DriveForce then
        SetVehicleHandlingField(Vehicle, 'CHandlingData', 'fInitialDriveForce', PursuitData[CurrentPursuit].DriveForce)
    end
    if PursuitData[CurrentPursuit].DriveInertia ~= DriveInertia then
        SetVehicleHandlingField(Vehicle, 'CHandlingData', 'fDriveInertia', PursuitData[CurrentPursuit].DriveInertia)
    end
end

function IsThisAPursuitVehicle(Vehicle)
    local Model = GetEntityModel(Vehicle)
    local VehicleData = Shared.Vehicles[Model]
    local PursuitData = Config.PursuitVehicles[VehicleData.Vehicle]
    if PursuitData == nil then return false end
    return PursuitData
end