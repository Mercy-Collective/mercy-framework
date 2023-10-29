-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('mercy-vehicles/client/open-vehicle-menu', function()
    exports['mercy-ui']:SetNuiFocus(true, true)
    exports['mercy-ui']:SendUIMessage('Vehicle', 'OpenVehicleMenu', {
        Settings = CalculateSettings()
    })
end)

RegisterNetEvent('mercy-vehicles/client/switch-seat', function(SeatNumber, IsMenu)
    local Vehicle = CurrentVehicleData.Vehicle
    if IsVehicleSeatFree(Vehicle, SeatNumber) then
        TaskWarpPedIntoVehicle(PlayerPedId(), Vehicle, SeatNumber)
        if IsMenu then
            Wait(25)
            exports['mercy-ui']:SendUIMessage('Vehicle', 'RefreshData', {
                Settings = CalculateSettings()
            })
        end
    end
end)

RegisterNetEvent('mercy-vehicles/client/toggle-door-data', function(Data)
    local Vehicle = CurrentVehicleData.Vehicle
    local LockStatus = GetVehicleDoorLockStatus(Vehicle)
    if Vehicle == nil or Vehicle == 0 or Vehicle == -1 then
        local Entity, EntityType, EntityCoords = FunctionsModule.GetEntityPlayerIsLookingAt(8.0, 0.2, 286, PlayerPedId())
        if Entity and EntityType ~= 0 then
            if EntityType == 2 then
                Vehicle = Entity
            end
        end
    end
    if LockStatus == 1 or LockStatus == 0 then
        local TrunkAngle = GetVehicleDoorAngleRatio(Vehicle, Data.DoorNumber)
        if (TrunkAngle == 0) then
            VehicleModule.SetVehicleDoorOpen(Vehicle, Data.DoorNumber)
        else
            VehicleModule.SetVehicleDoorShut(Vehicle, Data.DoorNumber)
        end
        if Data.IsMenu then
            Wait(500)
            exports['mercy-ui']:SendUIMessage('Vehicle', 'RefreshData', {
                Settings = CalculateSettings()
            })
        end
    end
end)

RegisterNetEvent('mercy-vehicles/client/toggle-door', function(DoorNumber, IsMenu)
    local Vehicle = CurrentVehicleData.Vehicle
    local LockStatus = GetVehicleDoorLockStatus(Vehicle)
    if LockStatus == 1 or LockStatus == 0 then
        local DoorAngle = GetVehicleDoorAngleRatio(Vehicle, DoorNumber)
        if (DoorAngle == 0) then
            VehicleModule.SetVehicleDoorOpen(Vehicle, DoorNumber)
        else
            VehicleModule.SetVehicleDoorShut(Vehicle, DoorNumber)
        end
        if IsMenu then
            Wait(500)
            exports['mercy-ui']:SendUIMessage('Vehicle', 'RefreshData', {
                Settings = CalculateSettings()
            })
        end
    end
end)

RegisterNetEvent('mercy-vehicles/client/toggle-window', function(WindowNumber, IsMenu)
    local Vehicle = CurrentVehicleData.Vehicle
    if not IsVehicleWindowIntact(Vehicle, WindowNumber) then
        RollUpWindow(Vehicle, WindowNumber)
        if not IsVehicleWindowIntact(Vehicle, WindowNumber) then
            RollDownWindow(Vehicle, WindowNumber)
        end
    else
        RollDownWindow(Vehicle, WindowNumber)
    end
    if IsMenu then
        Wait(25)
        exports['mercy-ui']:SendUIMessage('Vehicle', 'RefreshData', {
            Settings = CalculateSettings()
        })
    end
end)

-- [ Functions ] --

function CalculateSettings()
    local Settings = {Seat = {}, Door = {}, Window = {}}
    local Vehicle = GetVehiclePedIsIn(PlayerPedId())
    if Vehicle ~= 0 and Vehicle ~= -1 then
        Settings.Seat.One = CheckSeat(Vehicle, -1)
        Settings.Seat.Two = CheckSeat(Vehicle, 0)
        Settings.Seat.Three = CheckSeat(Vehicle, 1)
        Settings.Seat.Four = CheckSeat(Vehicle, 2)
        Settings.CanControl = GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() and true or false
        if GetVehicleDoorAngleRatio(Vehicle, 0) ~= 0 then
            Settings.Door.One = true
        else
            Settings.Door.One = false
        end
        if GetVehicleDoorAngleRatio(Vehicle, 1) ~= 0 then
            Settings.Door.Two = true
        else
            Settings.Door.Two = false
        end
        if GetVehicleDoorAngleRatio(Vehicle, 2) ~= 0 then
            Settings.Door.Three = true
        else
            Settings.Door.Three = false
        end
        if GetVehicleDoorAngleRatio(Vehicle, 3) ~= 0 then
            Settings.Door.Four = true
        else
            Settings.Door.Four = false
        end
        if not IsVehicleWindowIntact(Vehicle, 0) then
            Settings.Window.One = true
        else
            Settings.Window.One = false
        end
        if not IsVehicleWindowIntact(Vehicle, 1) then
            Settings.Window.Two = true
        else
            Settings.Window.Two = false
        end
        if not IsVehicleWindowIntact(Vehicle, 2) then
            Settings.Window.Three = true
        else
            Settings.Window.Three = false
        end
        if not IsVehicleWindowIntact(Vehicle, 3) then
            Settings.Window.Four = true
        else
            Settings.Window.Four = false
        end
    end
    return Settings
end

function CheckSeat(Vehicle, DoorId)
    local SeatPed = GetPedInVehicleSeat(Vehicle, DoorId);
    if SeatPed ~= 0 then
        return false
    else
        return true
    end
end

-- [ NUI Callbacks ] --

RegisterNUICallback('Vehicle/Close', function(Data, Cb)
    exports['mercy-ui']:SetNuiFocus(false, false)
    Cb('Ok')
end)

RegisterNUICallback('Vehicle/Action', function(Data, Cb)
    if Data.Action == 'Seat' then
        TriggerEvent('mercy-vehicles/client/switch-seat', Data.Number, true)
    elseif Data.Action == 'Door' then
        TriggerEvent('mercy-vehicles/client/toggle-door', Data.Number, true)
    elseif Data.Action == 'Window' then
        TriggerEvent('mercy-vehicles/client/toggle-window', Data.Number, true)
    end
    Cb('Ok')
end)