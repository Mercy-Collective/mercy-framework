local Cuffing = false

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            if Config.Handcuffed or Config.Escorted then
                DisableAllControlActions(0)
                if Config.Escorted then
                    EnableControlAction(0, 1, true)
                    EnableControlAction(0, 2, true)
                    EnableControlAction(0, 38, true)
                    EnableControlAction(0, 245, true)
                    EnableControlAction(0, 249, true)
                    EnableControlAction(0, 322, true)
                elseif Config.Handcuffed then
                    EnableControlAction(0, 1, true)
                    EnableControlAction(0, 2, true)
                    EnableControlAction(0, 21, true)
                    EnableControlAction(0, 30, true)
                    EnableControlAction(0, 31, true)
                    EnableControlAction(0, 32, true)
                    EnableControlAction(0, 33, true)
                    EnableControlAction(0, 34, true)
                    EnableControlAction(0, 35, true)
                    EnableControlAction(0, 38, true)
                    EnableControlAction(0, 245, true)
                    EnableControlAction(0, 249, true)
                    EnableControlAction(0, 322, true)
                    if not exports['mercy-vehicles']:GetInTrunkState() then
                        if (not IsEntityPlayingAnim(PlayerPedId(), "mp_arresting", "idle", 3) and not IsEntityPlayingAnim(PlayerPedId(), "mp_arrest_paired", "crook_p2_back_right", 3)) and not exports['mercy-hospital']:IsDead() then
                            FunctionModule.RequestAnimDict("mp_arresting")
                            TaskPlayAnim(PlayerPedId(), "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
                        end
                    end
                end
            else
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            if Config.Handcuffed then
                if not IsEntityPlayingAnim(PlayerPedId(), "mp_arresting", "idle", 3 and not IsEntityPlayingAnim(PlayerPedId(), "mp_arrest_paired", "crook_p2_back_right", 3)) then
                    TaskPlayAnim(PlayerPedId(), "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
                else
                    Citizen.Wait(250)
                end
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- [ Events ] --

-- Cuffs

RegisterNetEvent('mercy-police/client/used-cuffs', function()
    Citizen.SetTimeout(650, function()
        local ClosestPlayer = PlayerModule.GetClosestPlayer(nil, 2.0)
        if Cuffing then return end
        if ClosestPlayer['ClosestPlayerPed'] == -1 and ClosestPlayer['ClosestServer'] == -1 then
            exports['mercy-ui']:Notify('interaction-error', "An error occured! (No one near!)", 'error')
            return
        end
        if not IsPedInAnyVehicle(ClosestPlayer['ClosestPlayerPed']) and not IsPedInAnyVehicle(PlayerPedId()) then
            EventsModule.TriggerServer('mercy-police/server/cuff-player', ClosestPlayer['ClosestServer'])
            Cuffing = true Citizen.SetTimeout(4500, function() Cuffing = false end)
        end
    end)
end)

RegisterNetEvent('mercy-police/client/getting-cuffed', function()
    if not Config.Handcuffed then
        local GoingToCuff = false
        if math.random(1, 100) >= 33 and math.random(1, 100) <= 66 then
            local Outcome = exports['mercy-ui']:StartSkillTest(1, { 5, 10 }, { 1000, 2000 }, true)
            if not Outcome then
                GoingToCuff = true
                exports['mercy-ui']:Notify("cuff-error", "Failed..", 'error')
            end
        else
            GoingToCuff = true
        end

        if GoingToCuff then
            Config.Handcuffed = true
            exports['mercy-ui']:Notify("cuff", "You are cuffed.")
            EventsModule.TriggerServer('mercy-police/server/set-player-cuffs', true)
            TriggerEvent('mercy-inventory/client/reset-weapon')
            ClearPedTasksImmediately(PlayerPedId())
        end
    else
        Config.Handcuffed, Config.Escorted = false, false
        DetachEntity(PlayerPedId(), true, false)
        ClearPedTasksImmediately(PlayerPedId())
        EventsModule.TriggerServer('mercy-police/server/set-player-cuffs', false)
        exports['mercy-ui']:Notify("cuff", "You have been uncuffed.")
    end
end)

RegisterNetEvent('mercy-police/client/do-cuff-anim', function(Type, Cuffer)
    FunctionModule.RequestAnimDict("mp_arresting")
    FunctionModule.RequestAnimDict("mp_arrest_paired")
    if Type == 'Cuff' then
        TaskPlayAnim(PlayerPedId(), "mp_arrest_paired", "cop_p2_back_right", 3.0, 3.0, -1, 48, 0, 0, 0, 0)
        Citizen.Wait(3500)
        TaskPlayAnim(PlayerPedId(), "mp_arrest_paired", "exit", 3.0, 3.0, -1, 48, 0, 0, 0, 0)
    elseif Type == 'Uncuff' then
        TaskPlayAnim(PlayerPedId(), "mp_arresting", "a_uncuff", 1.0, 1.0, 3000, 16, -1, 0,0, 0)
        Citizen.Wait(3000)
        StopAnimTask(PlayerPedId(), "mp_arresting", "a_uncuff", 1.0)
    elseif Type == 'Getcuff' then
        local CufferPed = GetPlayerPed(GetPlayerFromServerId(Cuffer))
        SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(CufferPed, 0.0, 0.45, 0.0))
        Citizen.Wait(100)
        SetEntityHeading(PlayerPedId(), GetEntityHeading(CufferPed))
        TaskPlayAnim(PlayerPedId(), "mp_arrest_paired", "crook_p2_back_right", 3.0, 3.0, -1, 32, 0, 0, 0, 0)
        Citizen.Wait(2500)
        ClearPedTasks(PlayerPedId())
    end
end)

RegisterNetEvent('mercy-police/client/set-cuff-state', function(Bool)
    Config.Handcuffed = Bool
end)

RegisterNetEvent('mercy-police/client/reset-cuffed', function()
    if Config.Handcuffed then
        EventsModule.TriggerServer('mercy-police/server/set-player-cuffs', false)
    end
end)

-- Escort

RegisterNetEvent('mercy-police/client/toggle-escort', function()
    local ClosestPlayer = PlayerModule.GetClosestPlayer(nil, 2.0)
    if ClosestPlayer['ClosestPlayerPed'] == -1 and ClosestPlayer['ClosestServer'] == -1 then
        exports['mercy-ui']:Notify('interaction-error', "An error occured! (No one near!)", 'error')
        return
    end
    if not IsPedInAnyVehicle(PlayerPedId()) then
        EventsModule.TriggerServer('mercy-police/server/escort-player', ClosestPlayer['ClosestServer'])
    end
end)

-- TODO: Check if this works

function IsClosestCuffed()
    local ClosestPlayer = PlayerModule.GetClosestPlayer(nil, 2.0)
    if ClosestPlayer['ClosestPlayerPed'] == -1 and ClosestPlayer['ClosestServer'] == -1 then
        return false
    end
    local IsCuffed = CallbackModule.SendCallback('mercy-police/server/get-player-cuffs', ClosestPlayer['ClosestServer'])
    return IsCuffed
end
exports('IsClosestCuffed', IsClosestCuffed)

local DragList = {}
function IsEscorting()
    return DragList[GetPlayerServerId(PlayerId())] or false
end
exports('IsEscorting', IsEscorting)

RegisterNetEvent('mercy-police/client/do-escort', function(Dragger)
    DragList[Dragger] = not DragList[Dragger]
    if not Config.Escorted then
        Config.Escorted = true
        local DraggerPed = GetPlayerPed(GetPlayerFromServerId(Dragger))
        SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(DraggerPed, 0.0, 0.45, 0.0))
        AttachEntityToEntity(PlayerPedId(), DraggerPed, 11816, 0.45, 0.45, 0.0, 0.0, 0.0, exports['mercy-hospital']:IsDead() and 270.0 or 0.0, false, false, false, false, 2, true)
    else
        Config.Escorted = false
        DetachEntity(PlayerPedId(), true, false)
    end
end)

RegisterNetEvent('mercy-police/client/reset-escort', function()
    DetachEntity(PlayerPedId(), true, false)
    Config.Escorted = false
end)

-- Seat / UnSeat

RegisterNetEvent('mercy-police/client/try-seat', function()
    local Coords = GetEntityCoords(PlayerPedId())
    local EntityLookingAt = exports['mercy-base']:GetCurrentEntity()
    local EntityType, EntityCoords = GetEntityType(EntityLookingAt), GetEntityCoords(EntityLookingAt)
    local Distance = #(Coords - EntityCoords)
    local ClosestPlayer = PlayerModule.GetClosestPlayer(nil, 2.0)
	if EntityLookingAt ~= -1 and EntityType == 2 and Distance < 6.0 and AreAnyVehicleSeatsFree(EntityLookingAt) then 
        if ClosestPlayer['ClosestPlayerPed'] == -1 and ClosestPlayer['ClosestServer'] == -1 then
            exports['mercy-ui']:Notify('interaction-error', "An error occured! (No one near!)", 'error')
            return
        end
        local VehicleSeat = FindFirstVehicleSeat(EntityLookingAt, false, false, false)
        if VehicleSeat ~= false then
            local VehicleNet = NetworkGetNetworkIdFromEntity(EntityLookingAt)
            EventsModule.TriggerServer('mercy-police/server/set-in-vehicle', ClosestPlayer['ClosestServer'], VehicleNet, VehicleSeat)
        else
            exports['mercy-ui']:Notify('interaction-error', "An error occured! (No empty seats!)", 'error')
        end
    end
end)

RegisterNetEvent('mercy-police/client/set-in-vehicle', function(VehNet, VehicleSeat)
	local Vehicle = NetworkGetEntityFromNetworkId(VehNet)

    if Config.Escorted or Config.Handcuffed then
        DetachEntity(PlayerPedId(), true, false)
        ClearPedTasks(PlayerPedId())
        Config.Escorted = false  
    end

    Citizen.SetTimeout(100, function()
        TaskWarpPedIntoVehicle(PlayerPedId(), Vehicle, VehicleSeat)
    end)
end)

RegisterNetEvent('mercy-police/client/try-unseat', function()
    local Coords = GetEntityCoords(PlayerPedId())
    local EntityLookingAt = exports['mercy-base']:GetCurrentEntity()
    local EntityType, EntityCoords = GetEntityType(EntityLookingAt), GetEntityCoords(EntityLookingAt)
    local Distance = #(Coords - EntityCoords)
	if EntityLookingAt ~= -1 and EntityType == 2 and Distance < 6.0 then 
        local VehicleSeat = FindFirstVehicleSeat(EntityLookingAt, true, false, true)
        if VehicleSeat == false then
            exports['mercy-ui']:Notify('interaction-error', "An error occured! (Vehicle is empty!)", 'error')
            return
        end
	    local TargetPed = GetPedInVehicleSeat(EntityLookingAt, VehicleSeat)
	    local TargetPlayer = NetworkGetPlayerIndexFromPed(TargetPed)
        if TargetPlayer > 0 then
            local TargetServerId, VehicleNet = GetPlayerServerId(TargetPlayer), NetworkGetNetworkIdFromEntity(EntityLookingAt)
            EventsModule.TriggerServer('mercy-police/server/set-out-of-vehicle', TargetServerId, VehicleNet)
        end
    end
end)

RegisterNetEvent('mercy-police/client/set-out-of-vehicle', function(VehNet)
	local Vehicle = NetworkGetEntityFromNetworkId(VehNet)
    TaskLeaveVehicle(PlayerPedId(), Vehicle, 16)
end)

-- Search
 
RegisterNetEvent('mercy-police/client/search-closest', function(IsPolice)
    local ClosestPlayer = PlayerModule.GetClosestPlayer(nil, 2.0)

    if ClosestPlayer['ClosestPlayerPed'] == -1 and ClosestPlayer['ClosestServer'] == -1 then
        exports['mercy-ui']:Notify('interaction-error', "An error occured! (No one near!)", 'error')
        return
    end

    if not IsPedInAnyVehicle(ClosestPlayer['ClosestPlayerPed']) and not IsPedInAnyVehicle(PlayerPedId()) then
        local CanDoIt = false
        if IsPolice then CanDoIt = true goto Skip end
        if IsEntityPlayingAnim(ClosestPlayer['ClosestPlayerPed'], "missminuteman_1ig_2", "handsup_base", 3) or IsEntityPlayingAnim(ClosestPlayer['ClosestPlayerPed'], "mp_arresting", "idle", 3) or exports['mercy-hospital']:IsTargetDead(ClosestPlayer['ClosestServer']) then
            CanDoIt = true 
        end
 
        ::Skip::
        
        if CanDoIt then
            local TargetCitizenId = PlayerModule.GetPlayerCitizenIdBySource(ClosestPlayer['ClosestServer'])
            if TargetCitizenId == false then 
                return 
            end

            if IsPolice then
                EventsModule.TriggerServer('mercy-inventory/server/open-other-inventory', TargetCitizenId, 'Player', 45, 250.0)
            else
                exports['mercy-inventory']:SetBusyState(true)
                exports['mercy-ui']:ProgressBar('Stealing..', 5000, {['AnimName'] = 'robbery_action_b', ['AnimDict'] = 'random@shop_robbery', ['AnimFlag'] = 18}, false, false, true, function(DidComplete)
                    exports['mercy-inventory']:SetBusyState(false)
                    if DidComplete then
                        EventsModule.TriggerServer('mercy-inventory/server/steal-money', ClosestPlayer['ClosestServer'])
                        EventsModule.TriggerServer('mercy-inventory/server/open-other-inventory', TargetCitizenId, 'Player', 45, 250.0)
                    end
                end)
            end
        end
    end
end)

-- Face Wear

RegisterNetEvent('mercy-police/client/scan-plate', function(Nothing, Entity)
    local EntityType = GetEntityType(Entity) 
    if EntityType ~= 2 or exports['mercy-vehicles']:IsGovVehicle(Entity) then
        PlaySoundFromEntity(-1, "Keycard_Fail", PlayerPedId(), "DLC_HEISTS_BIOLAB_FINALE_SOUNDS", 1, 5.0)
        return
    end
    local Plate = GetVehicleNumberPlateText(Entity)
    local VehicleData = CallbackModule.SendCallback("mercy-police/server/get-vehicle-data", Plate)
    if not VehicleData then
        PlaySoundFromEntity(-1, "Keycard_Fail", PlayerPedId(), "DLC_HEISTS_BIOLAB_FINALE_SOUNDS", 1, 5.0)
        exports['mercy-ui']:Notify('not-found-veh-scan', 'Nothing found..', 'error')
        return
    end
    TriggerEvent('mercy-chat/client/post-message', 'Search Result - '..VehicleData.Plate, 'Owner: '..VehicleData.Owner..'<br>State ID: '..VehicleData.CitizenId..'<br>Vin: '..((VehicleData.Vin == "false" or VehicleData.Vin == false) and 'Not found..' or VehicleData.Vin)..'<br>Model: '..VehicleData.Model..'<br>Flagged: '..(VehicleData.Flagged == 1 and 'Yes' or 'No')..(VehicleData.Flagged == 1 and ('<br>Flag Reason: ' .. VehicleData.FlagReason) or ''), 'error')
    PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", false)
end)

RegisterNetEvent('mercy-police/client/remove-face-wear', function()
    local ClosestPlayer = PlayerModule.GetClosestPlayer(nil, 2.0)
    if ClosestPlayer['ClosestPlayerPed'] == -1 and ClosestPlayer['ClosestServer'] == -1 then
        exports['mercy-ui']:Notify('interaction-error', "An error occured! (No one near!)", 'error')
        return
    end
    if not IsPedInAnyVehicle(ClosestPlayer['ClosestPlayerPed']) and not IsPedInAnyVehicle(PlayerPedId()) then
        EventsModule.TriggerServer('mercy-police/server/remove-face-wear', ClosestPlayer['ClosestServer'])
    end
end)

RegisterNetEvent('mercy-police/client/try-seize', function()
    local ClosestPlayer = PlayerModule.GetClosestPlayer(nil, 2.0)
    if ClosestPlayer['ClosestPlayerPed'] == -1 and ClosestPlayer['ClosestServer'] == -1 then
        exports['mercy-ui']:Notify('interaction-error', "An error occured! (No one near!)", 'error')
        return
    end
    if not IsPedInAnyVehicle(ClosestPlayer['ClosestPlayerPed']) and not IsPedInAnyVehicle(PlayerPedId()) then
        EventsModule.TriggerServer('mercy-police/server/seize-possesions', ClosestPlayer['ClosestServer'])
    end
end)

-- [ Functions ] --

function FindFirstVehicleSeat(Vehicle, CheckFull, StartAtFront, CheckDriver)
    local Model = GetEntityModel(Vehicle)
	local MumberOfSeats = GetVehicleModelNumberOfSeats(Model)
	local ActualNumberOfSeats = MumberOfSeats - 2
	local StringValue = ActualNumberOfSeats
	local Iterator, LoopCount = -1, 0
	if CheckDriver then LoopCount = -1 end
	if StartAtFront then
		Iterator = 1
		LoopCount = ActualNumberOfSeats
		if CheckDriver then
			StringValue = -1
		else
			StringValue = 0
		end
	end
	for i = StringValue, LoopCount, Iterator do
		if CheckFull then
			if not IsVehicleSeatFree(Vehicle, i) then
				return i
			end
		else
			if IsVehicleSeatFree(Vehicle, i) then
				return i
			end
		end
	end
    return false
end