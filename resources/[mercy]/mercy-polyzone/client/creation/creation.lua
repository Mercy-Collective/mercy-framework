lastCreatedZoneType = nil
lastCreatedZone = nil
createdZoneType = nil
createdZone = nil
drawZone = false

RegisterNetEvent("polyzone:pzcreate")
AddEventHandler("polyzone:pzcreate", function(zoneType, name)
    if createdZone ~= nil then
        exports['mercy-ui']:Notify('polyzone-creation', 'A shape is already being created!', 'error')
        return
    end
    
    if zoneType == 'poly' then
        polyStart(name)
    elseif zoneType == "circle" then
        local radius = tonumber(GetUserInput("Enter radius:"))
        if radius == nil then
            exports['mercy-ui']:Notify('polyzone-creation', 'CircleZone requires a radius (must be a number)!', 'error')
            return
        end
        circleStart(name, radius)
    elseif zoneType == "box" then
        local length = tonumber(GetUserInput("Enter length:"))
        if length == nil or length < 0.0 then
            exports['mercy-ui']:Notify('polyzone-creation', 'BoxZone requires a length (must be a positive number)!', 'error')
            return
        end
        local width = tonumber(GetUserInput("Enter width:"))
        if width == nil or width < 0.0 then
            exports['mercy-ui']:Notify('polyzone-creation', 'BoxZone requires a width (must be a positive number)!', 'error')
            return
        end
        
        boxStart(name, 0, length, width)
    else
        return
    end
    createdZoneType = zoneType
    drawZone = true
    drawThread()
end)

RegisterNetEvent("polyzone:pzfinish")
AddEventHandler("polyzone:pzfinish", function()
    if createdZone == nil then
        return
    end

    if createdZoneType == 'poly' then
        polyFinish()
    elseif createdZoneType == "circle" then
        circleFinish()
    elseif createdZoneType == "box" then
        boxFinish()
    end

    exports['mercy-ui']:Notify('polyzone-creation', 'PolyZone finished!', 'success')

    lastCreatedZoneType = createdZoneType
    lastCreatedZone = createdZone

    drawZone = false
    createdZone = nil
    createdZoneType = nil
end)

RegisterNetEvent("polyzone:pzlast")
AddEventHandler("polyzone:pzlast", function()
    if createdZone ~= nil or lastCreatedZone == nil then
        return
    end
    if lastCreatedZoneType == 'poly' then
        exports['mercy-ui']:Notify('polyzone-creation', 'This only supports BoxZone and CircleZone for now..', 'error')
    end

    local name = GetUserInput("Enter name (or leave empty to reuse last zone's name):")
    if name == nil then
        return
    elseif name == "" then
        name = lastCreatedZone.name
    end
    createdZoneType = lastCreatedZoneType
    if createdZoneType == 'box' then
        local minHeight, maxHeight
        if lastCreatedZone.minZ then
            minHeight = lastCreatedZone.center.z - lastCreatedZone.minZ
        end
        if lastCreatedZone.maxZ then
            maxHeight = lastCreatedZone.maxZ - lastCreatedZone.center.z
        end
        boxStart(name, lastCreatedZone.offsetRot, lastCreatedZone.length, lastCreatedZone.width, minHeight, maxHeight)
    elseif createdZoneType == 'circle' then
        circleStart(name, lastCreatedZone.radius, lastCreatedZone.useZ)
    end
    drawZone = true
    drawThread()
end)

RegisterNetEvent("polyzone:pzcancel")
AddEventHandler("polyzone:pzcancel", function()
    if createdZone == nil then
        return
    end

    exports['mercy-ui']:Notify('polyzone-creation', 'PolyZone canceled!', 'error')

    drawZone = false
    createdZone = nil
    createdZoneType = nil
    isCreatingPolyZone = false
end)

RegisterNetEvent("polyzone/client/copy-zone", function(output)
	SendNUIMessage({
		polyzonecreation = output
	})
end)

-- Drawing
function drawThread()
    Citizen.CreateThread(function()
        while drawZone do
            if createdZone then
                createdZone:draw()
            end
            Wait(0)
        end
    end)
end
