local minZ, maxZ = nil, nil
isCreatingPolyZone = false
HasEditingLastPositionToggled = false

function GetEditingLastPointStatus()
    return HasEditingLastPositionToggled
end

function GetCreationStatus()
    return isCreatingPolyZone
end

local function handleInput(center)
    local rot = GetGameplayCamRot(2)
    center = handleArrowInput(center, rot.z)
    return center
end

function polyStart(name)
    local coords = GetEntityCoords(PlayerPedId())
    createdZone = PolyZone:Create(false, {vector2(coords.x, coords.y)}, {name = tostring(name), useGrid=false})
    isCreatingPolyZone = true
    Citizen.CreateThread(function()
        while createdZone do
            -- Have to convert the point to a vector3 prior to calling handleInput,
            -- then convert it back to vector2 afterwards
            lastPoint = createdZone.points[#createdZone.points]
            lastPoint = vector3(lastPoint.x, lastPoint.y, 0.0)
            lastPoint = handleInput(lastPoint)
            createdZone.points[#createdZone.points] = lastPoint.xy
            Wait(0)
        end
    end)
    minZ, maxZ = coords.z, coords.z
end

function polyFinish()
    isCreatingPolyZone = false
    HasEditingLastPositionToggled = false
    TriggerServerEvent("polyzone:printPoly",
        {name=createdZone.name, points=createdZone.points, minZ=math.floor(minZ), maxZ=math.floor(maxZ) + 5})
end

RegisterNetEvent("polyzone:pzadd")
AddEventHandler("polyzone:pzadd", function()
    if createdZone == nil or createdZoneType ~= 'poly' then
        return
    end

    local coords = GetEntityCoords(PlayerPedId())

    if (coords.z > maxZ) then
        maxZ = coords.z
    end

    if (coords.z < minZ) then
        minZ = coords.z
    end

    createdZone.points[#createdZone.points + 1] = vector2(coords.x, coords.y)
end)

RegisterNetEvent("polyzone:ToggleEditLastPoint")
AddEventHandler("polyzone:ToggleEditLastPoint", function(value)
    if createdZone == nil or createdZoneType ~= 'poly' then return end
    HasEditingLastPositionToggled = not HasEditingLastPositionToggled
end)

RegisterNetEvent("polyzone:pzundo")
AddEventHandler("polyzone:pzundo", function()
    if createdZone == nil or createdZoneType ~= 'poly' then
        return
    end

    createdZone.points[#createdZone.points] = nil
    if #createdZone.points == 0 then
        TriggerEvent("polyzone:pzcancel")
    end
end)