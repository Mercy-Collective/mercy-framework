local WeaponHolstered, DidDisable, CanFire = true, true, true
local PoliceHolsterData = {['HolsterProp'] = nil}

-- [ Threads ] --

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		if LocalPlayer.state.LoggedIn then
			if CanFire then
				if DidDisable then 
					DidDisable = false
					EnableControlAction(0, 25, true)
					DisablePlayerFiring(PlayerId(), false)
				end
			else
				DisableControlAction(0, 25, true)
				DisablePlayerFiring(PlayerId(), true)
				if not DidDisable then 
					DidDisable = true
				end
			end
		end
	end
end)

-- [ Events ] --

RegisterNetEvent('mercy-assets/client/reset-holster', function()
	if not WeaponHolstered then
		CanFire, WeaponHolstered = true, true
	end
end)

-- [ Functions ] --

function DoHolsterAnim()
	Citizen.CreateThread(function()
		FunctionsModule.RequestAnimDict("reaction@intimidation@1h")
		FunctionsModule.RequestAnimDict("reaction@intimidation@cop@unarmed")
		if WeaponHolstered then
			if IsPlayerPolice() then
				CanFire = false
				TaskPlayAnim(PlayerPedId(), "reaction@intimidation@cop@unarmed", "intro", 2.0, 2.0, -1, 49, 0, false, false, false)  
				Citizen.Wait(600)
				ClearPedTasks(PlayerPedId())
				WeaponHolstered, CanFire = false, true
			else
				CanFire = false
				TaskPlayAnim(PlayerPedId(), "reaction@intimidation@1h", "intro", 2.0, 2.0, -1, 49, 0, false, false, false)
				Citizen.Wait(1200)
				ClearPedTasks(PlayerPedId())
				WeaponHolstered, CanFire = false, true
			end
		else
			if IsPlayerPolice() then
				CanFire = false
				TaskPlayAnim(PlayerPedId(), "reaction@intimidation@cop@unarmed", "intro", 2.0, 2.0, -1, 49, 0, false, false, false)
				Citizen.Wait(600)
				ClearPedTasks(PlayerPedId())
				WeaponHolstered, CanFire = true, true
			else
				CanFire = false
				local AnimLength = GetAnimDuration("reaction@intimidation@1h", "outro") * 1000
				TaskPlayAnim(PlayerPedId(), "reaction@intimidation@1h", "outro", 2.0, 2.0, -1, 49, 0, false, false, false)
				Citizen.Wait(AnimLength - 1800)
				ClearPedTasks(PlayerPedId())
				WeaponHolstered, CanFire = true, true
			end
		end
	end)
end
exports('DoHolsterAnim', DoHolsterAnim)

function IsPlayerPolice()
	local PlayerJob = PlayerModule.GetPlayerData().Job
	if PlayerJob.Name == 'police' and PlayerJob.Duty then
		return true
	else
		return false
	end
end

function GetPlayerGender()
    return PlayerModule.GetPlayerData().CharInfo.Gender 
end