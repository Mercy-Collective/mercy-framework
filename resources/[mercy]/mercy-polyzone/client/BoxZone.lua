PolyZone = PolyZone or {}
BoxZone = {}
BoxZones = {}
-- Inherits from PolyZone
setmetatable(BoxZone, { __index = PolyZone })

-- Utility functions
local rad, cos, sin = math.rad, math.cos, math.sin
function PolyZone.rotate(origin, point, theta)
    if theta == 0 then return point end

    local p = point - origin
    local pX, pY = p.x, p.y
    theta = rad(theta)
    local cosTheta = cos(theta)
    local sinTheta = sin(theta)
    local x = pX * cosTheta - pY * sinTheta
    local y = pX * sinTheta + pY * cosTheta
    return vector2(x, y) + origin
end

local function _calculateScaleAndOffset(options)
    -- Scale and offset tables are both formatted as {forward, back, left, right, up, down}
    -- or if symmetrical {forward/back, left/right, up/down}
    local scale = options.scale or {1.0, 1.0, 1.0, 1.0, 1.0, 1.0}
    local offset = options.offset or {0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
    assert(#scale == 3 or #scale == 6, "Scale must be of length 3 or 6")
    assert(#offset == 3 or #offset == 6, "Offset must be of length 3 or 6")
    if #scale == 3 then
        scale = {scale[1], scale[1], scale[2], scale[2], scale[3], scale[3]}
    end
    if #offset == 3 then
        offset = {offset[1], offset[1], offset[2], offset[2], offset[3], offset[3]}
    end
    local minOffset = vector3(offset[3], offset[2], offset[6])
    local maxOffset = vector3(offset[4], offset[1], offset[5])
    local minScale = vector3(scale[3], scale[2], scale[6])
    local maxScale = vector3(scale[4], scale[1], scale[5])
    return minOffset, maxOffset, minScale, maxScale
end

local function _calculatePoints(center, length, width, minScale, maxScale, minOffset, maxOffset)
    local halfLength, halfWidth = length / 2, width / 2
    local min = vector3(-halfWidth, -halfLength, 0.0)
    local max = vector3(halfWidth, halfLength, 0.0)

    min = min * minScale - minOffset
    max = max * maxScale + maxOffset

    if (type(center) == 'table') then center.xy = vector2(center.x, center.y) end -- Typescript compatible

    -- Box vertices
    local p1 = center.xy + vector2(min.x, min.y)
    local p2 = center.xy + vector2(max.x, min.y)
    local p3 = center.xy + vector2(max.x, max.y)
    local p4 = center.xy + vector2(min.x, max.y)
    return {p1, p2, p3, p4}
end

-- Debug drawing functions
function BoxZone:TransformPoint(point)
    -- Overriding TransformPoint function to take into account rotation and position offset
    return PolyZone.rotate(self.startPos, point, self.offsetRot) + self.offsetPos
end


-- Initialization functions
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

function BoxZone:new(center, length, width, options, onEnter, onLeave)
    local minOffset, maxOffset, minScale, maxScale = _calculateScaleAndOffset(options)
    local scaleZ, offsetZ = {minScale.z, maxScale.z}, {minOffset.z, maxOffset.z}

    local points = _calculatePoints(center, length, width, minScale, maxScale, minOffset, maxOffset)

    -- Box Zones don't use the grid optimization because they are already rectangles/cubes
    options.useGrid = false
    local zone = PolyZone:new(points, options)
    zone.center = center
    zone.length = length
    zone.width = width
    zone.startPos = center.xy
    zone.offsetPos = vector2(0.0, 0.0)
    zone.offsetRot = options.heading or 0.0
    zone.minScale, zone.maxScale = minScale, maxScale
    zone.minOffset, zone.maxOffset = minOffset, maxOffset
    zone.scaleZ, zone.offsetZ = scaleZ, offsetZ
    zone.isBoxZone = true
    zone.extra = options.extra

    setmetatable(zone, self)
    self.__index = self

    return zone
end

function BoxZone:Create(isMultiple, faces, options, onEnter, onLeave)
    if options.name == nil then print(('A Box Zone was created from ^3%s^7, but there was no ^3`name`^7 property, automatic destroying is not possible.'):format(GetInvokingResource())) end
    if isMultiple then
        for k, v in pairs(faces) do
            if options.name and BoxZones[options.name] ~= nil and BoxZones[options.name][k] then
                BoxZones[options.name][k]:destroy()
                BoxZones[options.name][k] = nil
            end
            
            if BoxZones[options.name] == nil then BoxZones[options.name] = {} end
            
            options.minZ = v.minZ
            options.maxZ = v.maxZ
            options.heading = v.heading
            options.extra = v.data

            local zone = BoxZone:new(v.center, v.length, v.width, options, onEnter, onLeave)
            zone:onPlayerInOut(onEnter, onLeave)
            _initDebug(zone, options)

            if options.name then BoxZones[options.name][k] = zone end
        end
    else
        if options.name and BoxZones[options.name] then
            BoxZones[options.name]:destroy()
            BoxZones[options.name] = nil
        end

        if options.name and BoxZones[options.name] == nil then BoxZones[options.name] = {} end

        local zone = BoxZone:new(faces.center, faces.length, faces.width, options, onEnter, onLeave)
        if onEnter ~= nil then zone:onPlayerInOut(onEnter, onLeave) end
        _initDebug(zone, options)

        if options.name then BoxZones[options.name] = zone end
        return zone
    end
end

function CreateBox(faces, options, onEnter, onLeave)
    if isDebug then
        print('---------------------------------')
        print('Creating BoxZone.. Data:')
        print('Options: ' .. json.encode(options))
        print('Multiple Zones: ' .. tostring(options.hasMultipleZones))
        if options.hasMultipleZones then
            print('Zones (' .. #faces .. '): ')
            for zone, points in pairs(faces) do
                print('    Zone ' .. zone .. ':')
                print('    Corners: ' .. json.encode(points))
                print(' ')
            end
        else
            print('Corners: ' .. json.encode(faces))
        end
        print('Done creating boxzone, nice.')
        print('---------------------------------')
    end
    return BoxZone:Create(options.hasMultipleZones, faces, options, onEnter, onLeave)
end

-- Helper functions
function BoxZone:isPointInside(point)
    if self.destroyed then
        print("[PolyZone] Warning: Called isPointInside on destroyed zone {name=" .. self.name .. "}")
        return false 
    end

    local startPos = self.startPos
    local actualPos = point.xy - self.offsetPos
    if #(actualPos - startPos) > self.boundingRadius then
        return false
    end

    local rotatedPoint = PolyZone.rotate(startPos, actualPos, -self.offsetRot)
    local pX, pY, pZ = rotatedPoint.x, rotatedPoint.y, point.z
    local min, max = self.min, self.max
    local minX, minY, maxX, maxY = min.x, min.y, max.x, max.y
    local minZ, maxZ = self.minZ, self.maxZ
    if pX < minX or pX > maxX or pY < minY or pY > maxY then
        return false
    end
    if (minZ and pZ < minZ) or (maxZ and pZ > maxZ) then
        return false
    end
    return true
end

function BoxZone:getHeading()
    return self.offsetRot
end

function BoxZone:setHeading(heading)
    if not heading then
        return
    end
    self.offsetRot = heading
end

function BoxZone:setCenter(center)
    if not center or center == self.center then
        return
    end
    self.center = center
    self.startPos = center.xy
    self.points = _calculatePoints(self.center, self.length, self.width, self.minScale, self.maxScale, self.minOffset, self.maxOffset)
end

function BoxZone:getLength()
    return self.length
end

function BoxZone:setLength(length)
    if not length or length == self.length then
        return
    end
    self.length = length
    self.points = _calculatePoints(self.center, self.length, self.width, self.minScale, self.maxScale, self.minOffset, self.maxOffset)
end

function BoxZone:getWidth()
    return self.width
end

function BoxZone:setWidth(width)
    if not width or width == self.width then
        return
    end
    self.width = width
    self.points = _calculatePoints(self.center, self.length, self.width, self.minScale, self.maxScale, self.minOffset, self.maxOffset)
end

function DebugBoxZones()
    if isDebug then
        for k, v in pairs(BoxZones) do
            if #v > 0 then
                for _, box in pairs(v) do
                    _initDebug(box, {
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