local FrozenEntities        = { }
local EntityViewDistance    = 10
local EntityViewEnabled     = false
local EntityFreeAim         = false
local EntityPedView         = false
local EntityObjectView      = false
local EntityVehicleView     = false
local FreeAimEntity         = nil

local debugMode = true -- Set this to true to enable debug mode


-- Configurable values
local FreeAimInfoBoxX       = 0.60      -- X-axis (0.0 being left, 1.0 being right position of the screen)
local FreeAimInfoBoxY       = 0.02      -- Y-axis (0.0 being up, 1.0 being down position of the screen)
local useKph                = true      -- True to display KPH or false to display MPH


local CanEntityBeUsed = function(ped)
    if ped == PlayerPedId() then
        return false
    end
    return true
end

local RoundFloat = function(number, num)
    return math.floor(number*math.pow(10,num)+0.5) / math.pow(10,num)
end

local RoundVector3 = function(vector, num)
    return 'vector3('..RoundFloat(vector.x, num).. ', '..RoundFloat(vector.y, num).. ', '..RoundFloat(vector.z, num)..')'
end


local RelationshipTypes = { ['0'] = 'Companion', ['1'] = 'Respect', ['2'] = 'Like', ['3'] = 'Neutral', ['4'] = 'Dislike', ['5'] = 'Hate', ['255'] = 'Pedestrians' }
local GetPedRelationshipType = function(value)
    value = tostring(value)
    return RelationshipTypes[value] or "Unknown"
end

local DrawTitle = function(text, width, height)
    SetTextScale(0.50, 0.50)
    SetTextFont(4)
    SetTextDropshadow(1.0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextColour(255, 255, 255, 215)
    SetTextJustification(0)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(0.5, 0.02)
    DrawRect(0.425+(width/2), 0.01+(height/2), width, height, 11, 11, 11, 200)
end

local RotationToDirection = function(rotation)
	local adjustedRotation = {
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction = {
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

local RayCastGamePlayCamera = function(distance)
    -- Checks to see if the Gameplay Cam is Rendering or another is rendering (no clip functionality)
    local currentRenderingCam = false
    if not IsGameplayCamRendering() then
        currentRenderingCam = GetRenderingCam()
    end

    local cameraRotation = not currentRenderingCam and GetGameplayCamRot() or GetCamRot(currentRenderingCam, 2)
    local cameraCoord = not currentRenderingCam and GetGameplayCamCoord() or GetCamCoord(currentRenderingCam)
	local direction = RotationToDirection(cameraRotation)
	local destination =	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local _, b, c, _, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
	return b, c, e
end

local DrawEntityBoundingBox = function(entity, color)
    local model = GetEntityModel(entity)
    local min, max = GetModelDimensions(model)
    local rightVector, forwardVector, upVector, position = GetEntityMatrix(entity)

    -- Calculate size
    local dim =	{
		x = 0.5*(max.x - min.x),
		y = 0.5*(max.y - min.y),
		z = 0.5*(max.z - min.z)
	}

    local FUR = {
		x = position.x + dim.y*rightVector.x + dim.x*forwardVector.x + dim.z*upVector.x,
		y = position.y + dim.y*rightVector.y + dim.x*forwardVector.y + dim.z*upVector.y,
		z = 0
    }

    local _, FUR_z = GetGroundZFor_3dCoord(FUR.x, FUR.y, 1000.0, 0)
    FUR.z = FUR_z
    FUR.z = FUR.z + 2 * dim.z

    local BLL = {
        x = position.x - dim.y*rightVector.x - dim.x*forwardVector.x - dim.z*upVector.x,
        y = position.y - dim.y*rightVector.y - dim.x*forwardVector.y - dim.z*upVector.y,
        z = 0
    }
    local _, BLL_z = GetGroundZFor_3dCoord(FUR.x, FUR.y, 1000.0, 0)
    BLL.z = BLL_z

    -- DEBUG
    local edge1 = BLL
    local edge5 = FUR

    local edge2 = {
        x = edge1.x + 2 * dim.y*rightVector.x,
        y = edge1.y + 2 * dim.y*rightVector.y,
        z = edge1.z + 2 * dim.y*rightVector.z
    }

    local edge3 = {
        x = edge2.x + 2 * dim.z*upVector.x,
        y = edge2.y + 2 * dim.z*upVector.y,
        z = edge2.z + 2 * dim.z*upVector.z
    }

    local edge4 = {
        x = edge1.x + 2 * dim.z*upVector.x,
        y = edge1.y + 2 * dim.z*upVector.y,
        z = edge1.z + 2 * dim.z*upVector.z
    }

    local edge6 = {
        x = edge5.x - 2 * dim.y*rightVector.x,
        y = edge5.y - 2 * dim.y*rightVector.y,
        z = edge5.z - 2 * dim.y*rightVector.z
    }

    local edge7 = {
        x = edge6.x - 2 * dim.z*upVector.x,
        y = edge6.y - 2 * dim.z*upVector.y,
        z = edge6.z - 2 * dim.z*upVector.z
    }

    local edge8 = {
        x = edge5.x - 2 * dim.z*upVector.x,
        y = edge5.y - 2 * dim.z*upVector.y,
        z = edge5.z - 2 * dim.z*upVector.z
    }
    color = (color == nil and {r = 255, g = 255, b = 255, a = 255} or color)
    DrawLine(edge1.x, edge1.y, edge1.z, edge2.x, edge2.y, edge2.z, color.r, color.g, color.b, color.a)
    DrawLine(edge1.x, edge1.y, edge1.z, edge4.x, edge4.y, edge4.z, color.r, color.g, color.b, color.a)
    DrawLine(edge2.x, edge2.y, edge2.z, edge3.x, edge3.y, edge3.z, color.r, color.g, color.b, color.a)
    DrawLine(edge3.x, edge3.y, edge3.z, edge4.x, edge4.y, edge4.z, color.r, color.g, color.b, color.a)
    DrawLine(edge5.x, edge5.y, edge5.z, edge6.x, edge6.y, edge6.z, color.r, color.g, color.b, color.a)
    DrawLine(edge5.x, edge5.y, edge5.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
    DrawLine(edge6.x, edge6.y, edge6.z, edge7.x, edge7.y, edge7.z, color.r, color.g, color.b, color.a)
    DrawLine(edge7.x, edge7.y, edge7.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
    DrawLine(edge1.x, edge1.y, edge1.z, edge7.x, edge7.y, edge7.z, color.r, color.g, color.b, color.a)
    DrawLine(edge2.x, edge2.y, edge2.z, edge8.x, edge8.y, edge8.z, color.r, color.g, color.b, color.a)
    DrawLine(edge3.x, edge3.y, edge3.z, edge5.x, edge5.y, edge5.z, color.r, color.g, color.b, color.a)
    DrawLine(edge4.x, edge4.y, edge4.z, edge6.x, edge6.y, edge6.z, color.r, color.g, color.b, color.a)
end

local GetEntityInfo = function(entity)
    local playerCoords  = GetEntityCoords(PlayerPedId())
    local entityType    = GetEntityType(entity)
    local entityHash    = GetEntityModel(entity)
    local entityName    = Entities[entityHash] or Lang:t("info.obj_unknown")
    local entityData    = {'~y~'..Lang:t("info.entity_view_info"),'',Lang:t("info.model_hash")..' ~y~'..entityHash,' ',Lang:t("info.ent_id")..' ~y~'..entity,Lang:t("info.obj_name")..' ~y~'.. entityName,Lang:t("info.net_id")..' ~y~'..(NetworkGetEntityIsNetworked(entity) and NetworkGetNetworkIdFromEntity(entity) or Lang:t("info.net_id_not_registered")),Lang:t("info.ent_owner")..' ~y~'..GetPlayerServerId(NetworkGetEntityOwner(entity)),' '}

    if entityType == 1 then
        local pedRelationshipGroup = GetPedRelationshipGroupHash(entity)
        entityData[#entityData+1] = Lang:t("info.cur_health")..' ~y~'..GetEntityHealth(entity)
        entityData[#entityData+1] = Lang:t("info.max_health")..' ~y~'..GetPedMaxHealth(entity)
        entityData[#entityData+1] = Lang:t("info.armour")..' ~y~'..GetPedArmour(entity)
        entityData[#entityData+1] = Lang:t("info.rel_group")..' ~y~'.. (Entities[pedRelationshipGroup] or Lang:t("info.rel_group_custom"))
        entityData[#entityData+1] = Lang:t("info.rel_to_player")..' ~y~'..GetPedRelationshipType(GetRelationshipBetweenPeds(pedRelationshipGroup, PlayerPedId()))
    elseif entityType == 2 then
        entityData[#entityData+1] = Lang:t("info.veh_rpm")..' ~y~'..RoundFloat(GetVehicleCurrentRpm(entity), 2)
        entityData[#entityData+1] = (useKph and Lang:t("info.veh_speed_kph") or Lang:t("info.veh_speed_mph"))..' ~y~'..RoundFloat((GetEntitySpeed(entity)*(useKph and 3.6 or 2.23694)), 0)
        entityData[#entityData+1] = Lang:t("info.veh_cur_gear")..' ~y~'..GetVehicleCurrentGear(entity)
        entityData[#entityData+1] = Lang:t("info.veh_acceleration")..' ~y~'..RoundFloat(GetVehicleAcceleration(entity), 2)
        entityData[#entityData+1] = Lang:t("info.body_health")..' ~y~'..GetVehicleBodyHealth(entity)
        entityData[#entityData+1] = Lang:t("info.eng_health")..' ~y~'..GetVehicleEngineHealth(entity)
    elseif entityType == 3 then
        entityData[#entityData+1] = Lang:t("info.cur_health")..' ~y~'..GetEntityHealth(entity)
    end
    local entityCoords = GetEntityCoords(entity)

    entityData[#entityData+1] = ' '
    entityData[#entityData+1] = Lang:t("info.dist_to_obj")..' ~y~'.. RoundFloat(#(playerCoords-entityCoords), 2)
    entityData[#entityData+1] = Lang:t("info.obj_heading")..' ~y~'.. RoundFloat(GetEntityHeading(entity), 2)
    entityData[#entityData+1] = Lang:t("info.obj_coords")..' ~y~'.. RoundVector3(entityCoords, 2)
    entityData[#entityData+1] = Lang:t("info.obj_rot")..' ~y~'.. RoundVector3(GetEntityRotation(entity), 2)
    entityData[#entityData+1] = Lang:t("info.obj_velocity")..' ~y~'.. RoundVector3(GetEntityVelocity(entity), 2)

    return entityData
end

local DrawEntityViewText = function(entity)
    local data              = GetEntityInfo(entity)
    local count             = #data

    local posX              = FreeAimInfoBoxX
    local posY              = FreeAimInfoBoxY
    local titleSpacing      = 0.03
    local textSpacing       = 0.022
    local titeLeftMargin    = 0.05
    local paddingTop        = 0.02
    local paddingLeft       = 0.005
    local rectWidth         = 0.18
    local heightOfContent   = (((count) * textSpacing)+titleSpacing)/count
    local rectHeight        = ((count-1) * heightOfContent)+paddingTop

    DrawRect(posX+(rectWidth/2), posY+((rectHeight/2)-posY/2), rectWidth, rectHeight, 11, 11, 11, 200)

    for k, v in ipairs(data) do
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextDropshadow(1.0, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 255)
        SetTextColour(255, 255, 255, 215)
        SetTextJustification(1)
        BeginTextCommandDisplayText("STRING")
        AddTextComponentSubstringPlayerName(v)
        if k == 1 then
            SetTextScale(0.50, 0.50)
            EndTextCommandDisplayText(posX+titeLeftMargin, posY)
            posY = posY + titleSpacing
        else
            SetTextScale(0.35, 0.35)
            EndTextCommandDisplayText(posX+paddingLeft, posY)
            posY = posY + textSpacing
        end
    end
end

local DrawEntityViewTextInWorld = function(entity, coords)
    local onScreen, posX, posY = World3dToScreen2d(coords.x, coords.y, coords.z)
    if onScreen then
        local data = GetEntityInfo(entity)
        local count = #data
        local textOffsetY   = 0.015
        local leftPadding   = 0.005
        local topPadding    = 0.01
        local botPadding    = 0.02
        local offSetCount   = (((count-2) * textOffsetY))/count
        local rectWidth     = 0.12
        local rectHeight    = ((count) * offSetCount)+botPadding

        DrawRect(posX, posY, rectWidth, rectHeight, 11, 11, 11, 200)

        for k, v in ipairs(data) do
            if k ~= 1 and k ~= 2 then
                SetTextScale(0.25, 0.25)
                SetTextFont(4)
                SetTextDropshadow(1.0, 0, 0, 0, 255)
                SetTextEdge(1, 0, 0, 0, 255)
                SetTextColour(255, 255, 255, 215)
                SetTextJustification(1)
                BeginTextCommandDisplayText("STRING")
                AddTextComponentSubstringPlayerName(v)
                EndTextCommandDisplayText(posX-rectWidth/2+leftPadding, posY-rectHeight/2+topPadding)
                posY = posY + textOffsetY
            end
        end
    end
end

local GetVehicle = function(playerCoords)
    local handle, vehicle = FindFirstVehicle()
    local success
    local rveh = nil
    repeat
        if vehicle ~= FreeAimEntity then
            local pos = GetEntityCoords(vehicle)
            local distance = #(playerCoords-pos)
            if distance < EntityViewDistance and distance > 5.0 then
                DrawEntityBoundingBox(vehicle)
            elseif distance < 5.0 then
                rveh = vehicle
                DrawEntityViewTextInWorld(vehicle, pos)
            end
        end
        success, vehicle = FindNextVehicle(handle)
    until not success
    EndFindVehicle(handle)
    return rveh
end

local GetObject = function(playerCoords)
    local handle, object = FindFirstObject()
    local success
    local robject = nil
    repeat
        if object ~= FreeAimEntity then
            local pos = GetEntityCoords(object)
            local distance = #(playerCoords-pos)
            if distance < EntityViewDistance and distance > 5.0 then
                DrawEntityBoundingBox(object)
            elseif distance < 5.0 then
                robject = object
                DrawEntityViewTextInWorld(object, pos)
            end
        end
        success, object = FindNextObject(handle)
    until not success
    EndFindObject(handle)
    return robject
end

local GetNPC = function(playerCoords)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    repeat
        if ped ~= FreeAimEntity then
            local pos = GetEntityCoords(ped)
            local distance = #(playerCoords-pos)
            if CanEntityBeUsed(ped) then
                if distance < EntityViewDistance and distance > 5.0 then
                    DrawEntityBoundingBox(ped)
                elseif distance < 5.0 then
                    rped = ped
                    DrawEntityViewTextInWorld(ped, pos)
                end
            end
        end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
    return rped
end

ToggleEntityFreeView = function()
    EntityFreeAim = not EntityFreeAim
    if EntityFreeAim and not EntityViewEnabled then
        RunEntityViewThread()
    end
end

ToggleEntityObjectView = function()
    EntityObjectView = not EntityObjectView
    if EntityObjectView and not EntityViewEnabled then
        RunEntityViewThread()
    end
end

ToggleEntityVehicleView = function()
    EntityVehicleView = not EntityVehicleView
    if EntityVehicleView and not EntityViewEnabled then
        RunEntityViewThread()
    end
end

ToggleEntityPedView = function()
    EntityPedView = not EntityPedView
    if EntityPedView and not EntityViewEnabled then
        RunEntityViewThread()
    end
end

GetCurrentEntityViewDistance = function()
    return EntityViewDistance / 5
end

SetEntityViewDistance = function(data)
    EntityViewDistance = tonumber(data)
end

GetFreeAimEntity = function()
    return FreeAimEntity
end

RunEntityViewThread = function()
    EntityViewEnabled = true
    Citizen.CreateThread(function()
        while EntityViewEnabled do
            Citizen.Wait(0)
            local playerPed     = PlayerPedId()
            local playerCoords  = GetEntityCoords(playerPed)

            if EntityPedView then
                GetNPC(playerCoords)
            end

            if EntityObjectView then
                GetObject(playerCoords)
            end

            if EntityVehicleView then
                GetVehicle(playerCoords)
            end

            if EntityFreeAim then
                DrawTitle("~y~"..Lang:t("info.entity_view_title").."~w~\n\n[~y~E~w~] - "..Lang:t("info.entity_freeaim_delete").."~w~\n[~y~G~w~] - "..Lang:t("info.entity_freeaim_freeze"), 0.15, 0.14)
                local color = {r = 255, g = 255, b = 255, a = 200}
                local position = GetEntityCoords(playerPed)
                local hit, coords, entity = RayCastGamePlayCamera(1000.0)
                -- If entity is found then verify entity
                if hit and (IsEntityAVehicle(entity) or IsEntityAPed(entity) or IsEntityAnObject(entity)) then
                    color = {r = 0, g = 255, b = 0, a = 200}
                    FreeAimEntity = entity
                    DrawEntityBoundingBox(entity, color)
                    DrawEntityViewText(entity)

                    if IsControlJustReleased(0, 47) then -- Freeze entities
                        if FrozenEntities[entity] then
                            FrozenEntities[entity] = not FrozenEntities[entity]
                        else
                            FrozenEntities[entity] = true
                        end

                        FreezeEntityPosition(entity, FrozenEntities[entity])
                        exports['mercy-ui']:Notify('frozen-action', Lang:t("info.you_have")..(FrozenEntities[entity] and Lang:t("info.entity_frozen") or Lang:t("info.entity_unfrozen")).. Lang:t("info.freeaim_entity"), (FrozenEntities[entity] and 'success' or 'error'))
                    end


                    if debugMode then
                        local modelHash = GetEntityModel(entity)
                        local entityCoords = GetEntityCoords(entity)
                        local randomID = "RNDMDOORID" ..math.random(100000, 999999)
                        local coordsText = string.format("Info = %s\n Coords =  %s\n Model = %s", '"'.. randomID ..'",', RoundVector3(entityCoords, 2) ..',', modelHash..',')
                        if IsControlJustReleased(0, 38) then -- Change to 38 for E key
                            CopyToClipboard(coordsText)
                        end
                    end
                else
                    FreeAimEntity = nil
                end

                DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, color.r, color.g, color.b, color.a)
            end

            if EntityPedView == false and EntityObjectView == false and EntityVehicleView == false and EntityFreeAim == false then
                EntityViewEnabled = false
            end
        end
    end)
end

local showCoords = false
local vehicleDevMode = false

local function Draw2DText(content, font, colour, scale, x, y)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(colour[1],colour[2],colour[3], 255)
    BeginTextCommandDisplayText("STRING")
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    AddTextComponentSubstringPlayerName(content)
    EndTextCommandDisplayText(x, y)
end

Round = function(value, numDecimalPlaces)
    if not numDecimalPlaces then return math.floor(value + 0.5) end
    local power = 10 ^ numDecimalPlaces
    return math.floor((value * power) + 0.5) / (power)
end

function ToggleShowCoordinates()
    local x = 0.4
    local y = 0.025
    showCoords = not showCoords
    CreateThread(function()
        while showCoords do
            local coords = GetEntityCoords(PlayerPedId())
            local heading = GetEntityHeading(PlayerPedId())
            local c = {}
            c.x = Round(coords.x, 2)
            c.y = Round(coords.y, 2)
            c.z = Round(coords.z, 2)
            heading = Round(heading, 2)
            Wait(0)
            Draw2DText(string.format('~w~'..Lang:t("info.ped_coords") .. '~b~ vector4(~w~%s~b~, ~w~%s~b~, ~w~%s~b~, ~w~%s~b~)', c.x, c.y, c.z, heading), 4, {66, 182, 245}, 0.4, x + 0.0, y + 0.0)
        end
    end)
end

function ToggleVehicleDeveloperMode()
    local x = 0.4
    local y = 0.888
    vehicleDevMode = not vehicleDevMode
    CreateThread(function()
        while vehicleDevMode do
            local ped = PlayerPedId()
            Wait(0)
            if IsPedInAnyVehicle(ped, false) then
                local vehicle = GetVehiclePedIsIn(ped, false)
                local netID = VehToNet(vehicle)
                local hash = GetEntityModel(vehicle)
                local modelName = GetLabelText(GetDisplayNameFromVehicleModel(hash))
                local eHealth = GetVehicleEngineHealth(vehicle)
                local bHealth = GetVehicleBodyHealth(vehicle)
                Draw2DText(Lang:t("info.vehicle_dev_data"), 4, {66, 182, 245}, 0.4, x + 0.0, y + 0.0)
                Draw2DText(string.format(Lang:t("info.ent_id") .. '~b~%s~s~ | ' .. Lang:t("info.net_id") .. '~b~%s~s~', vehicle, netID), 4, {255, 255, 255}, 0.4, x + 0.0, y + 0.025)
                Draw2DText(string.format(Lang:t("info.model") .. '~b~%s~s~ | ' .. Lang:t("info.hash") .. '~b~%s~s~', modelName, hash), 4, {255, 255, 255}, 0.4, x + 0.0, y + 0.050)
                Draw2DText(string.format(Lang:t("info.eng_health") .. '~b~%s~s~ | ' .. Lang:t("info.body_health") .. '~b~%s~s~', Round(eHealth, 2), Round(bHealth, 2)), 4, {255, 255, 255}, 0.4, x + 0.0, y + 0.075)
            end
        end
    end)
end


function CopyToClipboard(text)

    SendNUIMessage({
        Action = 'copyToClipboard',
        String = text
    })
end
