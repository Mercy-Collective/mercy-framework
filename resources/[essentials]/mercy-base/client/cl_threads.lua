-- [ Code ] --

local LastValues, CurrentTarget = {}, nil
local Events = {
    ['IsPedInAnyVehicle'] = {
        ['false'] = "mercy-threads/exited-vehicle",
        ['1'] = "mercy-threads/entered-vehicle",
    },
    ['IsTalking'] = {
        ['false'] = "mercy-threads/stopped-talking",
        ['1'] = "mercy-threads/started-talking",
    },
    ['IsPedSwimmingUnderWater'] = {
        ['false'] = "mercy-threads/exited-underwater",
        ['1'] = "mercy-threads/entered-underwater",
    },
    ['GetPedArmour'] = {
        ['false'] = "mercy-threads/change-armor",
        ['1'] = "mercy-threads/change-armor",
    },
    ['GetEntityHealth'] = {
        ['false'] = "mercy-threads/change-health",
        ['1'] = "mercy-threads/change-health",
    },
    ['GetPlayerUnderwaterTimeRemaining'] = {
        ['false'] = "mercy-threads/change-health",
        ['1'] = "mercy-threads/change-health",
    }
}

ThreadsModule = {
    Get = function(Native)
        return LastValues[Native] or false
    end,
    Set = function(Native, Value)
        if LastValues[Native] == nil then return end
        LastValues[Native] = Value
    end,
    GetAllValues = function()
        local PlayerPed = PlayerPedId()
        return {
            ['Health'] = GetEntityHealth(PlayerPed),
            ['Armor'] = GetPedArmour(PlayerPed),
            ['Food'] = GetPlayerFood(),
            ['Water'] = GetPlayerWater(),
            ['Stress'] = GetPlayerStress()
        }
    end
}

local _Ready = false
AddEventHandler('Modules/client/ready', function()
    if not _Ready then
        _Ready = true
        exports[GetCurrentResourceName()]:CreateModule("Threads", ThreadsModule)        
    end
end)

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(450)
        if LocalPlayer.state.LoggedIn then
            if PlayerPedId() ~= LastValues['PlayerPedId'] then LastValues['PlayerPedId'] = PlayerPedId() end
            if PlayerId() ~= LastValues['PlayerId'] then LastValues['PlayerId'] = PlayerId() end
            if LastValues['PlayerPedId'] ~= nil then
                if GetEntityHealth(LastValues['PlayerPedId']) ~= LastValues['GetEntityHealth'] then OnChange('GetEntityHealth', GetEntityHealth(LastValues['PlayerPedId'])) end
                if GetEntityMaxHealth(LastValues['PlayerPedId']) ~= LastValues['GetEntityMaxHealth'] then OnChange('GetEntityMaxHealth', GetEntityMaxHealth(LastValues['PlayerPedId'])) end
                if GetPedArmour(LastValues['PlayerPedId']) ~= LastValues['GetPedArmour'] then OnChange('GetPedArmour', GetPedArmour(LastValues['PlayerPedId'])) end
                if GetPlayerFood() ~= LastValues['GetPlayerFood'] then OnChange('GetPlayerFood', GetPlayerFood()) end
                if GetPlayerWater() ~= LastValues['GetPlayerWater'] then OnChange('GetPlayerWater', GetPlayerWater()) end
                if GetPlayerStress() ~= LastValues['GetPlayerStress'] then OnChange('GetPlayerStress', GetPlayerStress()) end
                if GetEntityAlpha(LastValues['PlayerPedId']) ~= LastValues['GetEntityAlpha'] then OnChange('GetEntityAlpha', GetEntityAlpha(LastValues['PlayerPedId'])) end
                if IsPedSwimmingUnderWater(LastValues['PlayerPedId']) ~= LastValues['IsPedSwimmingUnderWater'] then OnChange('IsPedSwimmingUnderWater', IsPedSwimmingUnderWater(LastValues['PlayerPedId'])) end
                if GetPlayerUnderwaterTimeRemaining(LastValues['PlayerId']) ~= LastValues['GetPlayerUnderwaterTimeRemaining'] then OnChange('GetPlayerUnderwaterTimeRemaining', GetPlayerUnderwaterTimeRemaining(LastValues['PlayerId'])) end
                if IsPedInAnyVehicle(LastValues['PlayerPedId']) ~= LastValues['IsPedInAnyVehicle'] then OnChange('IsPedInAnyVehicle', IsPedInAnyVehicle(LastValues['PlayerPedId'])) end
                if GetVehiclePedIsIn(LastValues['PlayerPedId']) ~= LastValues['GetVehiclePedIsIn'] then OnChange('GetVehiclePedIsIn', GetVehiclePedIsIn(LastValues['PlayerPedId'])) end
                if NetworkIsPlayerTalking(PlayerId()) ~= LastValues['IsTalking'] then OnChange('IsTalking', NetworkIsPlayerTalking(PlayerId())) end
                if GetEntitySpeed(LastValues['PlayerPedId']) ~= LastValues['GetEntitySpeedPlayer'] then OnChange('GetEntitySpeedPlayer', GetEntitySpeed(LastValues['PlayerPedId'])) end
                
                if LastValues['GetVehiclePedIsIn'] ~= 0 then
                    if GetEntitySpeed(LastValues['GetVehiclePedIsIn']) ~= LastValues['GetEntitySpeedVehicle'] then OnChange('GetEntitySpeedVehicle', GetEntitySpeed(LastValues['GetVehiclePedIsIn'])) end
                end
            end
        end
    end
end)

-- Eye Target
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            local PlayerPed = PlayerPedId()
            local Entity, EntityType, EntityCoords = FunctionsModule.GetEntityPlayerIsLookingAt(8.0, 0.2, 286, PlayerPedId())
            if Entity and EntityType ~= 0 then
                if Entity ~= CurrentTarget then
                    CurrentTarget = Entity
                    TriggerEvent('mercy-base/client/target-changed', CurrentTarget, EntityType, EntityCoords)
                end
            elseif CurrentTarget then
                CurrentTarget = nil
                TriggerEvent('mercy-base/client/target-changed', CurrentTarget)
            end
            Citizen.Wait(250)
        else
            Citizen.Wait(450)
        end
    end
end)

-- Hunger / Thirst
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            Citizen.Wait((1000 * 60) * 8) -- 8 mins
            TriggerServerEvent('mercy-base/server/reduce-player-food-water')
        else
            Citizen.Wait(5000)
        end
    end
end)

-- Paycheck
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            Citizen.Wait((1000 * 60) * 10) -- 10 mins
            EventsModule.TriggerServer('mercy-base/server/receive-paycheck')
        end
    end
end)

-- Position
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		if LocalPlayer.state.LoggedIn then
			Citizen.Wait(1000 * 10) -- 10 seconds
            EventsModule.TriggerServer('mercy-base/server/save-position', GetEntityCoords(PlayerPedId()))
		else
			Citizen.Wait(5000)
		end
	end
end)

-- Damage on low food
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		if LocalPlayer.state.LoggedIn then
            local PlayerData = PlayerModule.GetPlayerData()
            if PlayerData == nil then return end
			if PlayerData.MetaData["Food"] <= 1 or PlayerData.MetaData["Water"] <= 1 then
				if not PlayerData.MetaData["Dead"] then
					local CurrentHealth = GetEntityHealth(PlayerPedId())
					SetEntityHealth(PlayerPedId(), CurrentHealth - math.random(5, 10))
				end
			end
			Citizen.Wait(math.random(4500, 5500))
		else
			Citizen.Wait(450)
		end
	end
end)

-- [ Functions ] --

function OnChange(Native, Value)
    LastValues[Native] = Value
    TriggerEvent(('mercy-threads/on-change/%s'):format(Native), Value)
    if Events[Native] and Events[Native][tostring(Value)] then
        TriggerEvent(Events[Native][tostring(Value)], Value)
    end
end

function GetPlayerFood()
    if PlayerModule.GetPlayerData().MetaData == nil then return 0 end
    return PlayerModule.GetPlayerData().MetaData['Food'] or 100.0
end

function GetPlayerWater()
    if PlayerModule.GetPlayerData().MetaData == nil then return 0 end
    return PlayerModule.GetPlayerData().MetaData['Water'] or 100.0
end

function GetPlayerStress()
    if PlayerModule.GetPlayerData().MetaData == nil then return 0 end
    return PlayerModule.GetPlayerData().MetaData['Stress'] or 0.0
end

exports('GetCurrentEntity', function()
    return CurrentTarget
end)