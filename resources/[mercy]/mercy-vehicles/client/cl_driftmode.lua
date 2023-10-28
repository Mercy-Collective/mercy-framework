local DriftMode = false
local VehicleClassWhitelist = {0, 1, 2, 3, 4, 5, 6, 7, 9}
local HandleMods = {
	{"fInitialDragCoeff", 90.22},
	{"fDriveInertia", 0.31},
	{"fSteeringLock", 22},
	{"fTractionCurveMax", -1.1},
	{"fTractionCurveMin", -0.4},
	{"fTractionCurveLateral", 2.5},
	{"fLowSpeedTractionLossMult", -0.57}
}
local ToggledDriftMode = false

-- [ Threads ] --

-- CreateThread( function()
-- 	while true do
-- 		Wait(200)
-- 		if IsPedInAnyVehicle(PlayerPedId()) then
-- 			local Veh = GetVehiclePedIsIn(PlayerPedId(), false)
-- 			if (GetPedInVehicleSeat(Veh, -1) == PlayerPedId()) then	
-- 				-- Drift Car  
-- 				if GetVehicleHandlingFloat(Veh, "CHandlingData", "fDriveBiasFront") ~= 1 and IsVehicleOnAllWheels(Veh) and DriftMode and IsVehicleClassWhitelisted(GetVehicleClass(Veh)) then
-- 					if not ToggledDriftMode then
--                         ToggleDrift(Veh)
--                     end
-- 				end
-- 				if GetVehicleHandlingFloat(Veh, "CHandlingData", "fInitialDragCoeff") < 90 then
-- 					SetVehicleEnginePowerMultiplier(Veh, 0.0)
-- 				else
-- 					if GetVehicleHandlingFloat(Veh, "CHandlingData", "fDriveBiasFront") == 0.0 then
-- 						SetVehicleEnginePowerMultiplier(Veh, 190.0)
-- 					else
-- 						SetVehicleEnginePowerMultiplier(Veh, 100.0)
-- 					end
-- 				end

-- 			end
-- 		end
-- 	end
-- end)

-- [ Events ] --

function ToggleDrift(Veh)
	local Modifier = 1
	-- if GetVehicleHandlingFloat(Veh, "CHandlingData", "fInitialDragCoeff") > 90 then
	-- 	DriftMode = false
	-- else 
	-- 	DriftMode = true
	-- end
	DriftMode = not DriftMode
	if not DriftMode then
		Modifier = -1
	end
	for index, value in ipairs(HandleMods) do
		SetVehicleHandlingFloat(Veh, "CHandlingData", value[1], GetVehicleHandlingFloat(Veh, "CHandlingData", value[1]) + value[2] * Modifier)
	end
	-- Toggle Drift Mode
	local VehSpeed = GetEntitySpeed(Veh)
	if VehSpeed <= 1 then 
        exports['mercy-ui']:ProgressBar('Toggling drift mode..', 2000, false, false, true, false, function(DidComplete)
            if DidComplete then
				if not DriftMode then
					ToggledDriftMode = false
					exports['mercy-ui']:Notify('drift-mode-en', 'Vehicle is in standard mode!', 'error')
					TriggerEvent('mercy-ui/client/set-hud-values', 'DriftMode', 'Show', false)
				else
					ToggledDriftMode = true
					exports['mercy-ui']:Notify('drift-mode-en', 'Enjoy driving sideways!', 'success')
					TriggerEvent('mercy-ui/client/set-hud-values', 'DriftMode', 'Show', true)
				end    
			else
				exports['mercy-ui']:Notify('drift-mode-en', 'Cancelled..', 'error')
			end
        end)
	else
		exports['mercy-ui']:Notify('drift-mode-en', 'You can only toggle drift mode when the vehicle is stationary!', 'error')
	end
end

RegisterNetEvent("mercy-vehicles/client/toggle-driftmode", function(Pressed)
    if not Pressed then return end
    if not CurrentVehicleData.InVeh then return end
    if not CurrentVehicleData.IsDriver then return end

    ToggleDrift(CurrentVehicleData.Vehicle)
end)

-- [ Functions ] --

function IsVehicleClassWhitelisted(VehicleClass)
	for index, value in ipairs(VehicleClassWhitelist) do
		if value == VehicleClass then
			return true
		end
	end
	return false
end
