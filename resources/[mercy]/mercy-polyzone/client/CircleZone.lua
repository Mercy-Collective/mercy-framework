CircleZone = {}
CircleZones = {}
-- Inherits from PolyZone
setmetatable(CircleZone, { __index = PolyZone })

function CircleZone:draw()
    local center = self.center
    local debugColor = self.debugColor
    local r, g, b = debugColor[1], debugColor[2], debugColor[3]
    if self.useZ then
        local radius = self.radius
        DrawMarker(28, center.x, center.y, center.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, radius, radius, radius, r, g, b, 48, false, false, 2, nil, nil, false)
    else
        local diameter = self.diameter
        DrawMarker(1, center.x, center.y, -200.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, diameter, diameter, 400.0, r, g, b, 96, false, false, 2, nil, nil, false)
    end
end


local function _initDebug(zone, options)
    if options.debugBlip then zone:addDebugBlip() end
    if not isDebug then
        return
    end
    
    Citizen.CreateThread(function()
        while isDebug and not zone.destroyed do
            zone:draw()
            Citizen.Wait(0)
        end
    end)
end

function CircleZone:new(center, radius, options, onEnter, onLeave)
    options = options or {}
    local zone = {
        name = tostring(options.name) or nil,
        center = center,
        radius = radius + 0.0,
        diameter = radius * 2.0,
        useZ = options.useZ or false,
        data = options.data or {},
        isCircleZone = true,
        debugColor = options.debugColor or { 0, 255, 0 }

    }
    if zone.useZ then
        assert(type(zone.center) == "vector3", "Center must be vector3 if useZ is true {center=" .. center .. "}")
    end
    setmetatable(zone, self)
    self.__index = self
    return zone
end

function CircleZone:Create(center, radius, options, onEnter, onLeave)
    if options.name == nil then print(('A Circle Zone was created from ^3%s^7, but there was no ^3`name`^7 property, automatic destroying is not possible.'):format(GetInvokingResource())) end

    if options.name and CircleZones[options.name] then
        CircleZones[options.name]:destroy()
        CircleZones[options.name] = nil
    end

    if options.name and CircleZones[options.name] == nil then CircleZones[options.name] = {} end

    local zone = CircleZone:new(center, radius, options, onEnter, onLeave)
    if onEnter ~= nil then zone:onPlayerInOut(onEnter, onLeave) end
    _initDebug(zone, options)

    if options.name then CircleZones[options.name] = zone end
    return zone

end

function CreateCircle(center, radius, options, onEnter, onLeave)
    if isDebug then
        print('---------------------------------')
        print('Creating CircleZone.. Data:')
        print('Center: ' .. json.encode(center))
        print('Radius: ' .. radius)
        print('Options: ' .. json.encode(options))
        print('Done creating circlezone, nice.')
        print('---------------------------------')
    end
    return CircleZone:Create(center, radius, options, onEnter, onLeave)
end
exports('CreateCircle', CreateCircle)

function CircleZone:isPointInside(point)
    if self.destroyed then
        print("[PolyZone] Warning: Called isPointInside on destroyed zone {name=" .. self.name .. "}")
        return false
    end

    local center = self.center
    local radius = self.radius

    if self.useZ then
        return #(point - center) < radius
    else
        return #(point.xy - center.xy) < radius
    end
end

function CircleZone:getRadius()
    return self.radius
end

function CircleZone:setRadius(radius)
    if not radius or radius == self.radius then
        return
    end
    self.radius = radius
    self.diameter = radius * 2.0
end

function CircleZone:getCenter()
    return self.center
end

function CircleZone:setCenter(center)
    if not center or center == self.center then
        return
    end
    self.center = center
end

function DoesCircleZoneExist(name)
    return CircleZones[name] ~= nil
end
exports('DoesCircleZoneExist', DoesCircleZoneExist)

function DebugCircleZones()
    if isDebug then
        for k, v in pairs(CircleZones) do
            if #v > 0 then
                for _, circle in pairs(v) do
                    _initDebug(circle, {
                        debugBlip = false
                    })
                end
            else
                _initDebug(v, {
                    debugBlip = false
                })
            end
        end
    end
end

function RemoveCircleZone(name)
    if CircleZones[name] ~= nil then
        if #CircleZones[name] > 0 then
            for _, circle in pairs(CircleZones[name]) do
                circle:destroy()
            end
        else
            CircleZones[name]:destroy()
        end
        CircleZones[name] = nil
    end
end
exports('RemoveCircleZone', RemoveCircleZone)