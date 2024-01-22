local CreatedBarricades = {}
local SpeedZones = {}

-- [ Code ] --

-- [ Threads ] --

CreateThread(function()
    while true do
        local Coords = GetEntityCoords(PlayerPedId())
        for k, v in pairs(Config.Barricades) do
            -- Only process 100 per frame.
            if k % 100 == 0 then
                Citizen.Wait(0)
            end

            if #(Coords - v.Coords) < 200.0 then
                if not CreatedBarricades[v.Id] then
                    local BarricadeObject = CreateBarricade(v.Model, v.Coords, v.Rotation)
                    if v.Static then
                        FreezeEntityPosition(BarricadeObject, true)
                    end

                    if v.Traffic then
                        CreateSpeedZone(v.Id, v.Coords)
                    end

                    CreatedBarricades[v.Id] = BarricadeObject
                end
            elseif CreatedBarricades[v.Id] then
                DeleteObject(CreatedBarricades[v.Id])
                DeleteSpeedZone(v.Id)
                CreatedBarricades[v.Id] = nil
            end
        end

        Citizen.Wait(2000)
    end
end)

function CreateBarricade(Model, Coords, Heading)
    if not FunctionModule.RequestModel(Model) then return end

    local BarricadeObject = CreateObject(Model, Coords.x, Coords.y, Coords.z, false, false, false)
    SetEntityHeading(BarricadeObject, Heading + 0.0)
    PlaceObjectOnGroundProperly(BarricadeObject)

    return BarricadeObject
end

function CreateSpeedZone(Id, Coords)
    if SpeedZones[Id] ~= nil then
        DeleteSpeedZone(Id)
    end

    local Node = AddRoadNodeSpeedZone(Coords.x, Coords.y, Coords.z, 4.0, 0.0, false)
    SpeedZones[Id] = Node
end

function DeleteSpeedZone(Id)
    RemoveRoadNodeSpeedZone(SpeedZones[Id])
    SpeedZones[Id] = nil
end

RegisterNetEvent("mercy-police/client/open-barricademenu", function(Props, ClosestData)
    local PlayerData = PlayerModule.GetPlayerData()
    if (PlayerData.Job.Name ~= 'police' and PlayerData.Job.Name ~= 'ems') or not PlayerData.Job.Duty then
        return
    end

    local MenuItems = {}
    for k, v in pairs(Props) do
        table.insert(MenuItems, {
            Title = v.Label,
            Desc = v.Desc,
            Data = { Event = 'mercy-police/client/place-barricade', Type = 'Client', Prop = v.Prop },
        })
    end

    if ClosestData and next(ClosestData) ~= nil and PlayerData.Job.HighCommand then
        table.insert(MenuItems, {
            Icon = "info-circle",
            Title = "Prop Info (" .. ClosestData.Label .. ")",
            Desc = "Barricade Id: " .. ClosestData.Id .. ";<br/>Placed by: " .. ClosestData.PlacedBy .. ";<br/>Placed on: " .. ClosestData.PlacedAt .. ";",
            Disabled = true,
        })
    end

    exports['mercy-ui']:OpenContext({ ['MainMenuItems'] = MenuItems }) 
end)

RegisterNetEvent("mercy-police/client/place-barricade", function(Data)
    local PlayerData = PlayerModule.GetPlayerData()
    if (PlayerData.Job.Name ~= 'police' and PlayerData.Job.Name ~= 'ems') or not PlayerData.Job.Duty then
        return
    end

    if Data.Prop == "delete_closest" then
        EventsModule.TriggerServer("mercy-police/server/delete-barricade")
        return
    end

	EntityModule.DoEntityPlacer(Data.Prop, 10.0, true, true, nil, function(DidPlace, Coords, Heading)
		if not DidPlace then
            return exports['mercy-ui']:Notify("object-error", "You stopped placing the object, or something went wrong..", "error")
        end

        exports['mercy-ui']:ProgressBar('Placing object...', 1500, {
            ['AnimName'] = "plant_floor", 
            ['AnimDict'] = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", 
            ['AnimFlag'] = 49,
        }, nil, true, false, function(DidComplete)
            exports['mercy-inventory']:SetBusyState(false)
            ClearPedTasks(PlayerPedId())
                    
            if not DidComplete then return end

            EventsModule.TriggerServer("mercy-police/server/place-barricade", Data.Prop, Coords, Heading)
        end)

    end)
end)

RegisterNetEvent("mercy-police/client/set-prop-data", function(Type, BarricadeId, Data)
    if not LocalPlayer.state.LoggedIn then return end

    if Type == "Add" then
        table.insert(Config.Barricades, Data)
    elseif Type == "Remove" then
        for k, v in pairs(Config.Barricades) do
            if v.Id == BarricadeId then
                table.remove(Config.Barricades, k)
                break
            end
        end

        if CreatedBarricades[BarricadeId] and DoesEntityExist(CreatedBarricades[BarricadeId]) then
            DeleteSpeedZone(BarricadeId)
            DeleteObject(CreatedBarricades[BarricadeId])
            CreatedBarricades[BarricadeId] = nil
        end
    end
end)

exports("IsEntityLookingAtBarricade", function()
    local Entity, EntityType, EntityCoords = FunctionModule.GetEntityPlayerIsLookingAt(3.0, 0.2, 286, PlayerPedId())
    if not Entity or EntityType == 0 then
        return false, nil
    end

    for BarricadeId, Object in pairs(CreatedBarricades) do
        if Object == Entity then
            return true, BarricadeId
        end
    end

    return false, nil
end)