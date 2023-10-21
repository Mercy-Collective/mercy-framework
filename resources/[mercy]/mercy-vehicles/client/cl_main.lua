EntityModule, CallbackModule, FunctionsModule, BlipModule, PlayerModule, EventsModule, KeybindsModule, VehicleModule = nil, nil, nil, nil, nil, nil, nil, nil
local LimitSpeed, LastVehicle, LimiterEnabled = 0.0, nil, false
local Carrying, AttachedEntity = false, nil

AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
        'Entity',
        'Callback',
        'Functions',
        'Player',
        'Events',
        'Vehicle',
        'Keybinds',
        'BlipManager',
        'Logger',
    }, function(Succeeded)
        if not Succeeded then return end
        EntityModule = exports['mercy-base']:FetchModule('Entity')
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        KeybindsModule = exports['mercy-base']:FetchModule('Keybinds')
        VehicleModule = exports['mercy-base']:FetchModule('Vehicle')
        BlipModule = exports['mercy-base']:FetchModule('BlipManager')
        LoggerModule = exports['mercy-base']:FetchModule('Logger')

        CallbackModule.CreateCallback('mercy-vehicles/client/get-entity-player-is-looking-at', function(Cb)
            local Entity = exports['mercy-base']:FetchModule('Functions').GetEntityPlayerIsLookingAt(3.0, 0.2, 286, PlayerPedId())
            if GetEntityType(Entity) ~= 2 then Cb(false) end
            Cb(NetworkGetNetworkIdFromEntity(Entity))
        end)
    end)
end)


RegisterNetEvent('mercy-base/client/on-login', function()
    Citizen.SetTimeout(350, function()
        InitMain() 
        InitZones()
        InitNitrous() 
        InitSirens()
        InitGasStations()
        KeybindsModule.Add('toggleDriftMode', 'Vehicle', 'Toggle Drift Mode', '', false, 'mercy-vehicles/client/toggle-driftmode')
        -- Set Keys
        local Keys = CallbackModule.SendCallback('mercy-vehicles/server/get-keys')
        Config.VehicleKeys = Keys
    end)
end)

-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('mercy-vehicle/client/pickup-wheelchair', function()
    local PlayerPed = PlayerPedId()
    local PlayerCoords = GetEntityCoords(PlayerPed)

    local Vehicle = VehicleModule.GetClosestVehicle()
    if GetEntityModel(Vehicle['Vehicle']) == GetHashKey('wheelchair') then
        local WheelchairCoords = GetEntityCoords(Vehicle['Vehicle'])
        local Distance = #(PlayerCoords - WheelchairCoords)
        if Distance <= 1.6 then
            VehicleModule.DeleteVehicle(Vehicle['Vehicle'])
            EventsModule.TriggerServer('mercy-inventory/server/add-item', "wheelchair", 1, false, nil, true, false)
            exports['mercy-ui']:Notify('wheelchair-pickup', 'You picked up the wheelchair.', 'success', 3500)
        else
            exports['mercy-ui']:Notify('wheelchair-pickup', 'You are too far away from the wheelchair..', 'error', 3500)
        end
    else
        exports['mercy-ui']:Notify('wheelchair-pickup', 'There is no wheelchair nearby', 'error', 3500)
    end
end)

RegisterNetEvent("mercy-threads/exited-vehicle", function() 
    local Vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
    local VehicleClass = GetVehicleClass(Vehicle)

    if VehicleClass == 15 then
        ToggleHeliSubmix(false)
        SetAudioFlag("DisableFlightMusic", true)
    elseif VehicleClass == 8 then
        SetPedHelmet(PlayerPedId(), true)
    end

    if GetBeltStatus() then
        SetBeltStatus(false)
    end

    SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(Vehicle), true)
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(Vehicle), true)
    SetEntityAsMissionEntity(Vehicle, false, false)
    SetVehicleHasBeenOwnedByPlayer(Vehicle, true)
    NetworkRegisterEntityAsNetworked(Vehicle)
    
    CheckForSirenSound(Vehicle)
    DisplayRadar(false)
end)

RegisterNetEvent("mercy-threads/entered-vehicle", function()
    local Vehicle = GetVehiclePedIsIn(PlayerPedId())
    local Plate = GetVehicleNumberPlateText(Vehicle)

    DisplayRadar(true)
    TriggerEvent('mercy-assets/client/set-map-zoom')
end)

RegisterNetEvent('mercy-vehicles/client/try-flip-vehicle', function(Nothing, Entity)
    exports['mercy-ui']:ProgressBar('Flipping Vehicle..', 5000, {['AnimName'] = 'pushcar_offcliff_f', ['AnimDict'] = 'missfinale_c2ig_11', ['AnimFlag'] = 49}, false, true, true, function(DidComplete)
        if DidComplete then
            VehicleModule.SetVehicleOnGroundProperly(Entity)
        end
    end)
end)

RegisterNetEvent('mercy-vehicles/client/toggle-door', function(State, DoorId)
    local Vehicle = GetVehiclePedIsIn(PlayerPedId())
    if State == 'open' then
        VehicleModule.SetVehicleDoorOpen(Vehicle, DoorId)
    elseif State == 'close' then
        VehicleModule.SetVehicleDoorShut(Vehicle, DoorId)
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		if LocalPlayer.state.LoggedIn then
			if Carrying then
				if IsControlJustReleased(0, 38) then
					DetachEntity(AttachedEntity, nil, nil)
					SetVehicleOnGroundProperly(AttachedEntity)
					Carrying, AttachedEntity = false, nil
					Citizen.Wait(150)
					ClearPedTasks(PlayerPedId())
					exports['mercy-ui']:HideInteraction()
				end
				if IsEntityDead(PlayerPedId()) then
					DetachEntity(AttachedEntity, nil, nil)
					SetVehicleOnGroundProperly(AttachedEntity)
					Carrying, AttachedEntity = false, nil
					Citizen.Wait(150)
					ClearPedTasks(PlayerPedId())
					exports['mercy-ui']:HideInteraction()
				end
			else
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		if LocalPlayer.state.LoggedIn then
			if Carrying then
				if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) then
					FunctionsModule.RequestAnimDict("anim@heists@box_carry@")
					TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 2.0, 2.0, -1, 51, 0, false, false, false)
				else
					Citizen.Wait(50)
				end
			else
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('mercy-vehicles/client/carry-bicycle', function(Nothing, Entity)
	if not Carrying then
		local PlayerBone = GetPedBoneIndex(PlayerPedId(), 0xE5F3)
		NetworkRequestControlOfEntity(Entity)
		exports['mercy-ui']:SetInteraction('[E] Drop', 'primary')
		AttachEntityToEntity(Entity, PlayerPedId(), PlayerBone, 0.0, 0.24, 0.10, 340.0, 330.0, 330.0, true, true, false, true, 1, true)
		FunctionsModule.RequestAnimDict("anim@heists@box_carry@")
		TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 2.0, 2.0, -1, 51, 0, false, false, false)
		AttachedEntity = Entity
		Carrying = true
	else
		exports['mercy-ui']:Notify('in-hands','You have something in your hands..', 'error', 5500)
	end
end)

-- [ Functions ] --

function InitMain()
    KeybindsModule.Add('toggleHorn', 'Vehicle', 'Emergency Horn', 'E', false, 'mercy-vehicles/client/sirens-horn')
    KeybindsModule.Add("speedLimiter", "Vehicle", "Limiter", '', function(IsPressed)
        if not IsPressed then return end
        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(PlayerPedId()) then
            local Vehicle = GetVehiclePedIsIn(PlayerPedId())
            if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() then
                LimitSpeed = GetEntitySpeed(Vehicle)
                if LimiterEnabled then
                    LimiterEnabled = false
                    LastVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                    SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), GetVehicleHandlingFloat(GetVehiclePedIsIn(PlayerPedId(), false), "CHandlingData", "fInitialDriveMaxFlatVel"))
                    exports['mercy-ui']:Notify('limiter-disabled', "Limiter disabled", 'error')
                else
                    LimiterEnabled = true
                    LastVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                    SetEntityMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), LimitSpeed)
                    exports['mercy-ui']:Notify('limiter-set', "Limiter set on " .. tostring(math.floor(LimitSpeed * 2.236936)) .. "mp/h")
                end
            end
        end
    end)
end

function HasOverdueDebts(Plate)
	local Debts = CallbackModule.SendCallback("mercy-phone/server/get-overdue-debts", "Vehicle")
	for k, v in pairs(Debts) do
        local DecodedData = json.decode(v.data)
		if DecodedData.Plate == Plate then
			return true
		end
	end
	return false
end

function IsPoliceVehicle(Vehicle)
    for k, v in pairs(Config.PoliceVehicles) do
        if GetEntityModel(Vehicle) == GetHashKey(v) then
            return true
        end
    end
    return false
end
exports('IsPoliceVehicle', IsPoliceVehicle)

function IsEmsVehicle(Vehicle)
    for k, v in pairs(Config.EmsVehicles) do
        if GetEntityModel(Vehicle) == GetHashKey(v) then
            return true
        end
    end
    return false
end
exports('IsEmsVehicle', IsEmsVehicle)

function GetVehicleDescription(Vehicle)
    if Vehicle == nil then Vehicle = GetVehiclePedIsIn(PlayerPedId()) end
    if DoesEntityExist(Vehicle) then
        local Plate = GetVehicleNumberPlateText(Vehicle)
        local VehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(Vehicle))
        local VehicleColorOne, VehicleColorTwo = GetVehicleColours(Vehicle)
        if math.random(1, 100) > 25 then Plate = 'Unknown' end
        return {
            [1] = {
                ['Icon'] = '<i class="fas fa-car"></i>', 
                ['Text'] = VehicleName..'; <i class="fas fa-closed-captioning"></i> '..Plate
            },
            [2] = {
                ['Icon'] = '<i class="fas fa-palette"></i>', 
                ['Text'] = (Shared.VehicleColors[VehicleColorOne] or 'Unknown')..'; '..(Shared.VehicleColors[VehicleColorTwo] or 'Unknown')
            },
        }
    end
end
exports("GetVehicleDescription", GetVehicleDescription)

function ToggleHeliSubmix(Bool)
    if Bool then
        SetAudioSubmixEffectRadioFx(0, 0)
        SetAudioSubmixEffectParamInt(0, 0, GetHashKey('enabled'), 1)
        SetAudioSubmixEffectParamFloat(0, 0, GetHashKey('freq_low'), 100.0)
        SetAudioSubmixEffectParamFloat(0, 0, GetHashKey('freq_hi'), 5000.0)
        SetAudioSubmixEffectParamFloat(0, 0, GetHashKey('rm_mod_freq'), 300.0)
        SetAudioSubmixEffectParamFloat(0, 0, GetHashKey('rm_mix'), 0.1)
        SetAudioSubmixEffectParamFloat(0, 0, GetHashKey('fudge'), 4.0)
        SetAudioSubmixEffectParamFloat(0, 0, GetHashKey('o_freq_lo'), 300.0)
        SetAudioSubmixEffectParamFloat(0, 0, GetHashKey('o_freq_hi'), 5000.0)
    else
        SetAudioSubmixEffectParamInt(0, 0, GetHashKey('enabled'), 0)
    end
end