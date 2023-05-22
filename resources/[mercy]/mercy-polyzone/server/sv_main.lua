CommandsModule = {}

local _Ready = false
AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Commands',
    }, function(Succeeded)
        if not Succeeded then return end
        CommandsModule = exports['mercy-base']:FetchModule('Commands')
        _Ready = true
    end)
end)

Citizen.CreateThread(function() 
    while not _Ready do 
        Citizen.Wait(4) 
    end 

    CommandsModule.Add({"zonedebug", "polydebug"}, "Toggle PolyZone Debug", {}, false, function(source, args)
        TriggerClientEvent('mercy-polyzone/Client/toggle-debug', source)
    end, "admin")
end)

local eventPrefix = '__PolyZone__:'

function triggerZoneEvent(eventName, ...)
    TriggerClientEvent(eventPrefix .. eventName, -1, ...)
end

RegisterNetEvent("PolyZone:TriggerZoneEvent", triggerZoneEvent)
exports("TriggerZoneEvent", triggerZoneEvent)

RegisterNetEvent("polyzone:printPoly", function(zone)
    local src = source
    file = io.open('polyzone_created_zones.txt', "a")
    io.output(file)
    local output = parsePoly(zone)
    TriggerClientEvent('polyzone/client/copy-zone', src, output)
    io.write(output)
    io.close(file)
end)

RegisterNetEvent("polyzone:printCircle", function(zone)
    local src = source
    file = io.open('polyzone_created_zones.txt', "a")
    io.output(file)
    local output = parseCircle(zone)
    TriggerClientEvent('polyzone/client/copy-zone', src, output)
    io.write(output)
    io.close(file)
end)

RegisterNetEvent("polyzone:printBox", function(zone)
    local src = source
    file = io.open('polyzone_created_zones.txt', "a")
    io.output(file)
    local output = parseBox(zone)
    TriggerClientEvent('polyzone/client/copy-zone', src, output)
    io.write(output)
    io.close(file)
end)

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function printoutHeader(name)
    return "-- Name: " .. name .. "\n"
end

function parsePoly(zone)
    local printout = printoutHeader(zone.name)
    printout = printout .. "exports['mercy-polyzone']:CreatePoly(zone.name, {"
    for i=1, #zone.points do
        if i ~= #zone.points then
        printout = printout .. "  vector2(" .. tostring(zone.points[i].x) .. ", " .. tostring(zone.points[i].y) .."),\n"
        else
        printout = printout .. "  vector2(" .. tostring(zone.points[i].x) .. ", " .. tostring(zone.points[i].y) ..")\n"
        end
    end
    printout = printout .. "}, {\n  gridDivisions = 25"
    if zone.minZ then
        printout = printout .. ",\n  minZ = " .. tostring(round(zone.minZ, 2))
    end
    if zone.maxZ then
        printout = printout .. ",\n  maxZ = " .. tostring(round(zone.maxZ, 2))
    end
    printout = printout .. ",\n  debugPoly = false"  
    printout = printout .. "\n})\n\n"
    return printout
end

function parseCircle(zone)
    local printout = printoutHeader(zone.name)
    printout = printout .. "exports['mercy-polyzone']:CreateCircle("
    printout = printout .. "\"" .. zone.name .. "\", vector3(" .. tostring(round(zone.center.x, 2)) .. ", " .. tostring(round(zone.center.y, 2))  .. ", " .. tostring(round(zone.center.z, 2)) .."), "
    printout = printout .. tostring(zone.radius) .. ", "
    printout = printout .. "{\n  useZ = " .. tostring(zone.useZ) .. ",\n})\n\n"
    printout = printout .. ",\n  debugPoly = false" 
    return printout
end

function parseBox(zone)
    local printout = printoutHeader(zone.name)
    printout = printout .. "exports['mercy-polyzone']:CreateBox("
    printout = printout .. "\"" .. zone.name .. "\", vector3(" .. tostring(round(zone.center.x, 2)) .. ", " .. tostring(round(zone.center.y, 2))  .. ", " .. tostring(round(zone.center.z, 2)) .."), "
    printout = printout .. tostring(zone.length) .. ", "
    printout = printout .. tostring(zone.width) .. ", "
    
    printout = printout .. "{\n  heading = " .. zone.heading
    if zone.minZ then
        printout = printout .. ",\n  minZ = " .. tostring(round(zone.minZ, 2))
    end
    if zone.maxZ then
        printout = printout .. ",\n  maxZ = " .. tostring(round(zone.maxZ, 2))
    end
    printout = printout .. ", \n  debugPoly = false"  
    printout = printout .. "\n})\n\n"
    return printout
end