local StealingKeys, Lockpicking, LastCartheftAlert = false, false, nil

-- [ Threads ] --

CreateThread(function()
    while KeybindsModule == nil do Wait(100) end

    KeybindsModule.Add('toggleEngineOn', 'Vehicle', 'Turn Engine On', 'IOM_WHEEL_UP', false, 'mercy-vehicles/client/toggle-engine-on', false, "MOUSE_WHEEL")
    KeybindsModule.Add('toggleEngineOff', 'Vehicle', 'Turn Engine Off', 'IOM_WHEEL_DOWN', false, 'mercy-vehicles/client/toggle-engine-off', false, "MOUSE_WHEEL")
    KeybindsModule.Add('toggleLocks', 'Vehicle', 'Toggle Vehicle Locks', 'L', false, 'mercy-vehicles/client/toggle-locks', false)

    KeybindsModule.DisableControlAction(0, 332, true)
    KeybindsModule.DisableControlAction(0, 333, true)
    KeybindsModule.DisableControlAction(0, 14, true)
    KeybindsModule.DisableControlAction(0, 15, true)
    KeybindsModule.DisableControlAction(0, 16, true)
    KeybindsModule.DisableControlAction(0, 17, true)
    KeybindsModule.DisableControlAction(0, 81, true)
    KeybindsModule.DisableControlAction(0, 82, true)
    KeybindsModule.DisableControlAction(0, 99, true)
    KeybindsModule.DisableControlAction(0, 100, true)
    KeybindsModule.DisableControlAction(0, 115, true)
    KeybindsModule.DisableControlAction(0, 116, true)
end)

CreateThread(function()
    while true do
        Wait(4)
		if LocalPlayer.state.LoggedIn then
			local Vehicle = GetVehiclePedIsTryingToEnter(PlayerPedId())
			if Vehicle == -1 or Vehicle == 0 then goto Skip end

			if GetVehicleDoorLockStatus(Vehicle) == 7 then
				SetVehicleDoorsLocked(Vehicle, 2)
			end
	
			local TargetPed = GetPedInVehicleSeat(Vehicle, -1)
			if TargetPed == -1 or TargetPed == 0 then goto Skip end
			SetPedCanBeDraggedOut(TargetPed, false)

			::Skip::
		else
			Wait(450)
		end
    end
end)
                                     
CreateThread(function()
    while true do
        Wait(4)
        if LocalPlayer.state.LoggedIn then
            if CurrentVehicleData.Vehicle == 0 then
                Wait(150)
                return
            end

            local Vehicle = CurrentVehicleData.Vehicle
            if Vehicle == 0 or Vehicle == -1 then 
                Wait(150)
                return 
            end

            if CurrentVehicleData.IsDriver then
                if IsControlPressed(2, 75) and GetIsVehicleEngineRunning(Vehicle) then
                    if HasKeysToVehicle(CurrentVehicleData.Plate) then
                        TaskLeaveVehicle(PlayerPedId(), Vehicle, 0)
                        SetVehicleEngineOn(Vehicle, true, true, true)
                        Wait(95)
                        SetVehicleEngineOn(Vehicle, true, true, true)
                    else
                        TaskLeaveVehicle(PlayerPedId(), Vehicle, 0)
                    end
                end
            else
                Wait(450)
            end
        else
            Wait(450)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(4)
        if LocalPlayer.state.LoggedIn and not StealingKeys then
            if GetVehiclePedIsTryingToEnter(PlayerPedId()) ~= 0 and GetSeatPedIsTryingToEnter(PlayerPedId()) == -1 then
                local Vehicle = GetVehiclePedIsTryingToEnter(PlayerPedId())
                local Driver = GetPedInVehicleSeat(Vehicle, -1)
                if Driver ~= 0 and not IsPedAPlayer(Driver) and IsEntityDead(Driver) then
                    StealingKeys = true
                    exports['mercy-ui']:ProgressBar('Stealing keys..', 3000, false, false, false, false, function(DidComplete)
                        if DidComplete then
                            local Plate = GetVehicleNumberPlateText(Vehicle)
                            TriggerEvent('mercy-vehicles/client/on-veh-lockpick', Vehicle, Plate)
                            SetVehicleKeys(Plate, true)
                        end
                        StealingKeys = false
                    end)
                end
            end
        else
            Wait(450)
        end
    end
end)

-- [ Functions ] --

function HasKeysToVehicle(Plate)
    return Config.VehicleKeys[Plate] ~= nil and Config.VehicleKeys[Plate][PlayerModule.GetPlayerData().CitizenId]
end
exports('HasKeysToVehicle', HasKeysToVehicle)

function SetVehicleKeys(Plate, Bool, CitizenId)
    local CitizenId = CitizenId ~= nil and CitizenId or false
    TriggerServerEvent('mercy-vehicles/server/set-keys', Plate, Bool, CitizenId)
end
exports("SetVehicleKeys", SetVehicleKeys)

function LoopAnimation(Bool, AnimDict, AnimName)
    Lockpicking = Bool
    if not Lockpicking then return end

    FunctionsModule.RequestAnimDict(AnimDict)
    CreateThread(function()
        while Lockpicking do
            Wait(4)
            TaskPlayAnim(PlayerPedId(), AnimDict, AnimName, 3.0, 3.0, -1, 16, 0, false, false, false)
            Wait(1000)
        end
        StopAnimTask(PlayerPedId(), AnimDict, AnimName, 1.0)
    end)
end

-- [ Events ] --

RegisterNetEvent("mercy-threads/entered-vehicle", function() 
    local Vehicle = GetVehiclePedIsIn(PlayerPedId())
    local Plate = GetVehicleNumberPlateText(Vehicle)
    local VehicleClass = GetVehicleClass(Vehicle)

    if VehicleClass == 15 then
        ToggleHeliSubmix(true)
        SetAudioFlag("DisableFlightMusic", true)
    elseif VehicleClass == 8 or GetEntityModel(Vehicle) == GetHashKey('polbike') or GetEntityModel(Vehicle) == GetHashKey('wheelchair') then
        SetPedHelmet(PlayerPedId(), false)
    end

    if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() then
        SetVehRadioStation(Vehicle, "OFF")
        SetVehicleRadioEnabled(Vehicle, true)
    end

    if HasKeysToVehicle(Plate) then 
        SetVehicleUndriveable(Vehicle, false)
        return 
    end

    CreateThread(function()
        while not HasKeysToVehicle(Plate) do
            if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() and GetIsVehicleEngineRunning(Vehicle) then
                SetVehicleEngineOn(Vehicle, false, false, true)
                SetVehicleUndriveable(Vehicle, true)
            end
            Wait(250)
        end

        SetTimeout(500, function()
            SetVehicleUndriveable(Vehicle, false)
        end)
    end)
end)

RegisterNetEvent("mercy-threads/exited-vehicle", function() 
    local Vehicle = GetVehiclePedIsIn(PlayerPedId())
    local VehicleClass = GetVehicleClass(Vehicle)

    if VehicleClass == 15 then
        ToggleHeliSubmix(false)
        SetAudioFlag("DisableFlightMusic", false)
    end
end)

RegisterNetEvent('mercy-items/client/used-lockpick', function(IsAdvanced, isBank)
    local InVehicle = IsPedInAnyVehicle(PlayerPedId())
    local Entity, EntityType, EntityCoords = FunctionsModule.GetEntityPlayerIsLookingAt(4.0, 0.2, 286, PlayerPedId())

    if InVehicle then 
        Entity = GetVehiclePedIsIn(PlayerPedId()) 
        EntityType = GetEntityType(Entity) 
        EntityCoords = GetEntityCoords(Entity) 
    end

    if Entity == 0 or Entity == -1 or EntityType ~= 2 then return end

    local Plate = GetVehicleNumberPlateText(Entity)
    if HasKeysToVehicle(Plate) then return end

    if GetVehicleClass(Entity) == 18 then
        return exports['mercy-ui']:Notify('stronger-device', "You need a stronger device to do this..", "error")
    end

    if LastCartheftAlert ~= Entity then
        EventsModule.TriggerServer('mercy-ui/server/send-stealing-vehicle', FunctionsModule.GetStreetName(), GetVehicleDescription(Entity))
        LastCartheftAlert = Entity
        SetTimeout(60000 * 5, function() -- 5 min
            if LastCartheftAlert == Entity then
                LastCartheftAlert = false
            end
        end)
    end

    if InVehicle then
        TriggerEvent('mercy-vehicles/client/on-start-lockpick', Entity, Plate)
        EventsModule.TriggerServer('mercy-ui/server/play-sound-in-distance', {['Position'] = {[1] = EntityCoords.x, [2] = EntityCoords.y, [3] = EntityCoords.z}, ['Distance'] = 5.0, ['MaxDistance'] = 0.20, ['Name'] = 'lockpick', ['Volume'] = 0.7, ['Type'] = 'Spatial'})
        LoopAnimation(true, 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer')
        local Outcome = exports['mercy-ui']:StartSkillTest(math.random(5, 8), IsAdvanced and { 1, 2 } or { 5, 10 }, IsAdvanced and { 6000, 12000 } or { 1500, 3000 }, true)
        LoopAnimation(false)
        if not Outcome then
            exports['mercy-ui']:Notify('keys-error', "Failed attempt..", 'error')
            exports['mercy-assets']:RemoveLockpickChance(IsAdvanced)
            return
        end

        TriggerEvent('mercy-vehicles/client/on-veh-lockpick', Entity, Plate)
        exports['mercy-ui']:Notify('keys', "Vehicle Lockpicked.", 'success')
        SetVehicleKeys(Plate, true)
    else
        if GetVehicleDoorLockStatus(Entity) ~= 2 then return end

        TriggerEvent('mercy-vehicles/client/on-start-lockpick', Entity, Plate)
        EventsModule.TriggerServer('mercy-ui/server/play-sound-in-distance', {['Position'] = {[1] = EntityCoords.x, [2] = EntityCoords.y, [3] = EntityCoords.z}, ['Distance'] = 5.0, ['MaxDistance'] = 0.20, ['Name'] = 'lockpick', ['Volume'] = 0.7, ['Type'] = 'Spatial'})
        LoopAnimation(true, "veh@break_in@0h@p_m_one@", "low_force_entry_ds")
        local Outcome = exports['mercy-ui']:StartSkillTest(math.random(5, 8), IsAdvanced and { 1, 2 } or { 5, 10 }, IsAdvanced and { 6000, 12000 } or { 1500, 3000 }, true)
        LoopAnimation(false)
        if not Outcome then
            exports['mercy-ui']:Notify('keys-error', "Failed attempt..", 'error')
            exports['mercy-assets']:RemoveLockpickChance(IsAdvanced)
            return
        end

        EventsModule.TriggerServer('mercy-ui/server/play-sound-in-distance', {['Position'] = {[1] = EntityCoords.x, [2] = EntityCoords.y, [3] = EntityCoords.z}, ['Distance'] = 12.0, ['MaxDistance'] = 0.20, ['Name'] = 'car-unlock', ['Volume'] = 1.0, ['Type'] = 'Spatial'})
        TriggerEvent('mercy-vehicles/client/on-veh-lockpick', Entity, Plate)
        exports['mercy-ui']:Notify('keys', "Unlocked.", 'success')
        VehicleModule.SetVehicleDoorsLocked(Entity, 1)
    end
end)

RegisterNetEvent("mercy-vehicles/client/set-veh-keys", function(Plate, Keyholders)
    Config.VehicleKeys[Plate] = Keyholders
end)

RegisterNetEvent('mercy-vehicles/client/give-keys', function()
    local IsInVehicle = IsPedInAnyVehicle(PlayerPedId())
    local Entity, EntityType, EntityCoords = FunctionsModule.GetEntityPlayerIsLookingAt(4.0, 0.2, 286, PlayerPedId())

    if IsInVehicle then 
        Entity = GetVehiclePedIsIn(PlayerPedId()) 
        EntityType = GetEntityType(Entity) 
        EntityCoords = GetEntityCoords(Entity) 
    end

    if Entity == 0 or Entity == -1 or EntityType ~= 2 then return end

    if IsInVehicle and GetPedInVehicleSeat(Entity, -1) ~= PlayerPedId() then
	local Plate = GetVehicleNumberPlateText(Entity)
    	if not HasKeysToVehicle(Plate) then return end
	
        local TargetServer = GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(Entity, -1)))
        if TargetServer ~= GetPlayerServerId(PlayerId()) then
            SetVehicleKeys(Plate, true, PlayerModule.GetPlayerCitizenIdBySource(TargetServer))
            exports['mercy-ui']:Notify('keys-error', "You gave the keys.", 'success')
        end
    else
        local ClosestPlayer = PlayerModule.GetClosestPlayer(nil, 2.0)
	local Vehicle = VehicleModule.GetClosestVehicle()
        local clostestPlate = GetVehicleNumberPlateText(Vehicle['Vehicle'])
        if ClosestPlayer['ClosestPlayerPed'] == -1 and ClosestPlayer['ClosestServer'] == -1 then
            exports['mercy-ui']:Notify('keys-error', "An error occured! (No one near!)", 'error')
            return
        end

        SetVehicleKeys(clostestPlate, true, PlayerModule.GetPlayerCitizenIdBySource(ClosestPlayer['ClosestServer']))
        exports['mercy-ui']:Notify('keys-error', "You gave the keys.", 'success')
    end
end)

RegisterNetEvent('mercy-vehicles/client/get-keys', function()
    local IsInVehicle = IsPedInAnyVehicle(PlayerPedId())
    local Entity, EntityType, EntityCoords = FunctionsModule.GetEntityPlayerIsLookingAt(4.0, 0.2, 286, PlayerPedId())

    if IsInVehicle then 
        Entity = GetVehiclePedIsIn(PlayerPedId()) 
        EntityType = GetEntityType(Entity) 
        EntityCoords = GetEntityCoords(Entity) 
    end

    if Entity == 0 or Entity == -1 or EntityType ~= 2 then return end

    local Plate = GetVehicleNumberPlateText(Entity)
    SetVehicleKeys(Plate, true, PlayerModule.GetPlayerCitizenIdBySource(GetPlayerServerId(PlayerId())))
    TriggerEvent('mercy-vehicles/client/on-veh-lockpick', Entity, Plate)
    exports['mercy-ui']:Notify('keys-error', "You got the keys.", 'success')
end)

RegisterNetEvent('mercy-vehicles/client/toggle-engine-on', function(OnPress)
    if not OnPress then return end

    local Vehicle = GetVehiclePedIsIn(PlayerPedId())
    if Vehicle <= 0 or GetPedInVehicleSeat(Vehicle, -1) ~= PlayerPedId() then return end

    local Plate = GetVehicleNumberPlateText(Vehicle)
    if HasKeysToVehicle(Plate) then
        SetVehicleEngineOn(Vehicle, true, false, true)
    end
end)

RegisterNetEvent('mercy-vehicles/client/toggle-engine-off', function(OnPress)
    if not OnPress then return end

    local Vehicle = GetVehiclePedIsIn(PlayerPedId())
    if Vehicle <= 0 or GetPedInVehicleSeat(Vehicle, -1) ~= PlayerPedId() then return end

    local Plate = GetVehicleNumberPlateText(Vehicle)
    if HasKeysToVehicle(Plate) then
        SetVehicleEngineOn(Vehicle, false, false, true)
    end
end)

RegisterNetEvent('mercy-vehicles/client/toggle-locks', function(OnPress)
    if not OnPress then return end

    local InVehicle = IsPedInAnyVehicle(PlayerPedId())
    local Entity, EntityType, EntityCoords = FunctionsModule.GetEntityPlayerIsLookingAt(4.0, 0.2, 286, PlayerPedId())

    if InVehicle then 
        Entity = GetVehiclePedIsIn(PlayerPedId()) 
        EntityType = GetEntityType(Entity) 
        EntityCoords = GetEntityCoords(Entity) 
    end

    if Entity == 0 or Entity == -1 or EntityType ~= 2 then return end

    local Plate = GetVehicleNumberPlateText(Entity)
    if not HasKeysToVehicle(Plate) then return end

    local Distance = #(GetEntityCoords(PlayerPedId()) - EntityCoords)
    if Distance > 1.1 then return end

    if GetVehicleDoorLockStatus(Entity) == 1 then
        VehicleModule.SetVehicleDoorsLocked(Entity, 2)
        ClearPedTasks(PlayerPedId())
        exports['mercy-ui']:Notify('keys', "Vehicle Locked.", 'error')
        EventsModule.TriggerServer('mercy-ui/server/play-sound-in-distance', {['Position'] = {[1] = EntityCoords.x, [2] = EntityCoords.y, [3] = EntityCoords.z}, ['Distance'] = 12.0, ['MaxDistance'] = 0.20, ['Name'] = 'car-lock', ['Volume'] = 1.0, ['Type'] = 'Spatial'})
    else
        VehicleModule.SetVehicleDoorsLocked(Entity, 1)
        ClearPedTasks(PlayerPedId())
        exports['mercy-ui']:Notify('keys', "Vehicle Unlocked.", 'success')
        EventsModule.TriggerServer('mercy-ui/server/play-sound-in-distance', {['Position'] = {[1] = EntityCoords.x, [2] = EntityCoords.y, [3] = EntityCoords.z}, ['Distance'] = 12.0, ['MaxDistance'] = 0.20, ['Name'] = 'car-unlock', ['Volume'] = 1.0, ['Type'] = 'Spatial'})
    end

    FunctionsModule.RequestAnimDict("anim@heists@keycard@")
    TaskPlayAnim(PlayerPedId(), "anim@heists@keycard@", "exit", 8.0, 1.0, -1, 48, 0, 0, 0, 0)
    Wait(500)
    StopAnimTask(PlayerPedId(), "anim@heists@keycard@", "exit", 1.0)
end)
