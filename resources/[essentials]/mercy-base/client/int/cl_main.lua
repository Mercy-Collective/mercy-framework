local Spawned = false
local _Ready = false

-- [ Code ] --

-- [ Threads ] --

CreateThread(function()
	if _Ready then return end
    TriggerEvent('Modules/client/ready')
	_Ready = true
	while true do
		Citizen.Wait(4)
		if NetworkIsSessionStarted() and not Spawned then
			Spawned = true
			SetTimeout(500, function()
				TriggerEvent('mercy-base/client/player-spawned')
				TriggerServerEvent('mercy-base/server/load-token')
				TriggerServerEvent('mercy-base/server/load-user')
				exports.spawnmanager:setAutoSpawn(false)
			end)
		else
			Wait(450)
		end
	end
end)

-- [ Functions ] --

function RequestSyncExecution(Native, Entity, ...)
    if DoesEntityExist(Entity) then
        TriggerServerEvent('mercy-base/server/sync-request', Native, GetPlayerServerId(NetworkGetEntityOwner(Entity)), NetworkGetNetworkIdFromEntity(Entity), ...)
    end
end

-- [ Events ] --

RegisterNetEvent("mercy-base/client/on-login", function()
	LocalPlayer.state:set('LoggedIn', true, false)
end)

RegisterNetEvent("mercy-base/client/on-logout", function()
	LocalPlayer.state:set('LoggedIn', false, false)
end)

RegisterNetEvent("mercy-base/client/sync-execute", function(Native, NetId, ...)
	local VehicleModule = exports['mercy-base']:FetchModule('Vehicle')
	local EntityModule = exports['mercy-base']:FetchModule('Entity')
    local Entity = NetworkGetEntityFromNetworkId(NetId)
    if DoesEntityExist(Entity) then
        if VehicleModule[Native] ~= nil then
            VehicleModule[Native](Entity, ...)
        elseif EntityModule[Native] ~= nil then
            EntityModule[Native](Entity, ...)
        end
    end
end)

AddEventHandler('onResourceStart', function()
	if not _Ready then return end
	TriggerEvent('Modules/client/ready')
end)

AddEventHandler('onResourceStop', function()
	if not _Ready then return end
	LocalPlayer.state:set('LoggedIn', false, false)
end)

RegisterNetEvent('mercy-base/client/command-gotocoords', function(Coords)
	SetEntityCoords(PlayerPedId(), Coords.x, Coords.y, Coords.z)
end)

RegisterNetEvent('mercy-admin/client/command-go-to-marker', function(Coords)
	Citizen.CreateThread(function()
		local Success = false
		local BlipFound, Success = false, false
		local Blip, BlipIterator = GetFirstBlipInfoId(8), GetBlipInfoIdIterator()

		local Entity = PlayerPedId()
		if IsPedInAnyVehicle(Entity, false) then
			Entity = GetVehiclePedIsUsing(Entity)
		end

		while DoesBlipExist(Blip) do
			if GetBlipInfoIdType(Blip) == 4 then
				CoordsX, CoordsY, CoordsZ = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, Blip, Citizen.ReturnResultAnyway(), Citizen.ResultAsVector())) --GetBlipInfoIdCoord(blip)
				BlipFound = true
				break
			end
			Blip = GetNextBlipInfoId(BlipIterator)
		end

		if BlipFound then
			local GroundFound = false
			for i = 0, 1000, 1 do
				SetEntityCoordsNoOffset(Entity, CoordsX, CoordsY, ToFloat(i), false, false, false)
				SetEntityRotation(Entity, 0, 0, 0, 0 ,0)
				SetEntityHeading(Entity, GetEntityHeading(Entity))
				Citizen.Wait(0)
				if GetGroundZFor_3dCoord(CoordsX, CoordsY, ToFloat(i), CoordsZ, false) then --GetGroundZFor3dCoord(cx, cy, i, 0, 0) GetGroundZFor_3dCoord(cx, cy, i)
					CoordsZ = ToFloat(i)
					GroundFound = true
					break
				end
			end
			if not GroundFound then
				CoordsZ = -300.0
			end
			Success = true
		end

		if success then
			SetEntityCoordsNoOffset(Entity, CoordsX, CoordsY, CoordsZ, false, false, true)
			if IsPedSittingInAnyVehicle(PlayerPedId()) then
				if GetPedInVehicleSeat(GetVehiclePedIsUsing(PlayerPedId()), -1) == PlayerPedId() then
					SetVehicleOnGroundProperly(GetVehiclePedIsUsing(PlayerPedId()))
				end
			end
		end
	end)
end)

RegisterNetEvent('mercy-base/client/duty-menu', function()
	local src = source
	local PlayerModule = exports['mercy-base']:FetchModule('Player')
	local Player = PlayerModule.GetPlayerData()
	if Player ~= nil then
		exports['mercy-ui']:OpenContext({
			['MainMenuItems'] = {
				{
					['Title'] = Player.Job.Label,
					['Desc'] = 'Go on or off duty.',
					['Data'] = {['Event'] = '', ['Type'] = ''},
					['SecondMenu'] = {
						{
							['Title'] = 'Go On Duty',
							['Desc'] = 'Use this to go on duty as ' .. Player.Job.Label,
							['Data'] = {['Event'] = 'mercy-base/server/set-duty', ['Type'] = 'Server', ['State'] = true},
							['CloseMenu'] = true,
						},
						{
							['Title'] = 'Go Off Duty',
							['Desc'] = 'Use this to go off duty.',
							['Data'] = {['Event'] = 'mercy-base/server/set-duty', ['Type'] = 'Server', ['State'] = false},
							['CloseMenu'] = true,
						}
					}
				}
			}
		})
	else
		exports['mercy-ui']:Notify("player-error", "Something went wrong..", "error")
	end
end)

RegisterNUICallback("NUIBlock", function(data)
	local EventsModule = exports['mercy-base']:FetchModule('Events')
	EventsModule.TriggerServer('mercy-base/server/check-nui')
end)

RegisterNetEvent('Modules/client/ready')