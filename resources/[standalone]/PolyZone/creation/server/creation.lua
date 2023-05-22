RegisterNetEvent("polyzone:printPoly")
AddEventHandler("polyzone:printPoly", function(zone)
  file = io.open('polyzone_created_zones.txt', "a")
  io.output(file)
  local output = parsePoly(zone)
  io.write(output)
  io.close(file)
end)

RegisterNetEvent("polyzone:printCircle")
AddEventHandler("polyzone:printCircle", function(zone)
  file = io.open('polyzone_created_zones.txt', "a")
  io.output(file)
  local output = parseCircle(zone)
  io.write(output)
  io.close(file)
end)

RegisterNetEvent("polyzone:printBox")
AddEventHandler("polyzone:printBox", function(zone)
  file = io.open('polyzone_created_zones.txt', "a")
  io.output(file)
  local output = parseBox(zone)
  io.write(output)
  io.close(file)
end)

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function printoutHeader(name)
  return "--Name: " .. name .. " | " .. os.date("!%Y-%m-%dT%H:%M:%SZ\n")
end

-- function parsePoly(zone)
--   if Config.ConfigFormatEnabled then
--     local printout = printoutHeader(zone.name)
--     printout = printout .. "points = {\n"
--     for i = 1, #zone.points do
--       if i ~= #zone.points then
--         printout = printout .. "  vector2(" .. tostring(zone.points[i].x) .. ", " .. tostring(zone.points[i].y) .."),\n"
--       else
--         printout = printout .. "  vector2(" .. tostring(zone.points[i].x) .. ", " .. tostring(zone.points[i].y) ..")\n"
--       end
--     end
--     printout = printout .. "},\nname = \"" .. zone.name .. "\",\n--minZ = " .. zone.minZ .. ",\n--maxZ = " .. zone.maxZ .. ",\n--debugPoly = true\n\n"
--     return printout
--   else
--     local printout = printoutHeader(zone.name)
--     printout = printout .. "PolyZone:Create({\n"
--     for i = 1, #zone.points do
--       if i ~= #zone.points then
--         printout = printout .. "  vector2(" .. tostring(zone.points[i].x) .. ", " .. tostring(zone.points[i].y) .."),\n"
--       else
--         printout = printout .. "  vector2(" .. tostring(zone.points[i].x) .. ", " .. tostring(zone.points[i].y) ..")\n"
--       end
--     end
--     printout = printout .. "}, {\n  name = \"" .. zone.name .. "\",\n  --minZ = " .. zone.minZ .. ",\n  --maxZ = " .. zone.maxZ .. "\n})\n\n"
--     return printout
--   end
-- end

-- function parseCircle(zone)
--   if Config.ConfigFormatEnabled then
--     local printout = printoutHeader(zone.name)
--     printout = printout .. "coords = "
--     printout = printout .. "vector3(" .. tostring(round(zone.center.x, 2)) .. ", " .. tostring(round(zone.center.y, 2))  .. ", " .. tostring(round(zone.center.z, 2)) .."),\n"
--     printout = printout .. "radius = " .. tostring(zone.radius) .. ",\n"
--     printout = printout .. "name = \"" .. zone.name .. "\",\nuseZ = " .. tostring(zone.useZ) .. ",\n--debugPoly = true\n\n"
--     return printout
--   else
--     local printout = printoutHeader(zone.name)
--     printout = printout .. "CircleZone:Create("
--     printout = printout .. "vector3(" .. tostring(round(zone.center.x, 2)) .. ", " .. tostring(round(zone.center.y, 2))  .. ", " .. tostring(round(zone.center.z, 2)) .."), "
--     printout = printout .. tostring(zone.radius) .. ", "
--     printout = printout .. "{\n  name = \"" .. zone.name .. "\",\n  useZ = " .. tostring(zone.useZ) .. ",\n  --debugPoly = true\n})\n\n"
--     return printout
--   end
-- end

-- function parseBox(zone)
--   if Config.ConfigFormatEnabled then
--     local printout = printoutHeader(zone.name)
--     printout = printout .. "coords = "
--     printout = printout .. "vector3(" .. tostring(round(zone.center.x, 2)) .. ", " .. tostring(round(zone.center.y, 2))  .. ", " .. tostring(round(zone.center.z, 2)) .."),\n"
--     printout = printout .. "length = " .. tostring(zone.length) .. ",\n"
--     printout = printout .. "width = " .. tostring(zone.width) .. ",\n"
--     printout = printout .. "name = \"" .. zone.name .. "\",\nheading = " .. zone.heading .. ",\n--debugPoly = true"
--     if zone.minZ then
--       printout = printout .. ",\nminZ = " .. tostring(round(zone.minZ, 2))
--     end
--     if zone.maxZ then
--       printout = printout .. ",\nmaxZ = " .. tostring(round(zone.maxZ, 2))
--     end
--     printout = printout .. "\n\n"
--     return printout
--   else
--     local printout = printoutHeader(zone.name)
--     printout = printout .. "BoxZone:Create("
--     printout = printout .. "vector3(" .. tostring(round(zone.center.x, 2)) .. ", " .. tostring(round(zone.center.y, 2))  .. ", " .. tostring(round(zone.center.z, 2)) .."), "
--     printout = printout .. tostring(zone.length) .. ", "
--     printout = printout .. tostring(zone.width) .. ", "
--     printout = printout .. "{\n  name = \"" .. zone.name .. "\",\n  heading = " .. zone.heading .. ",\n  --debugPoly = true"
--     if zone.minZ then
--       printout = printout .. ",\n  minZ = " .. tostring(round(zone.minZ, 2))
--     end
--     if zone.maxZ then
--       printout = printout .. ",\n  maxZ = " .. tostring(round(zone.maxZ, 2))
--     end
--     printout = printout .. "\n})\n\n"
--     return printout
--   end
-- end


function parsePoly(zone)
  local printout = printoutHeader(zone.name)
  printout = printout .. "exports['mercy-polyzone']:CreatePolyZone("..zone.name..", {"
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
  printout = printout .. "exports['mercy-polyzone']:CreateCircleZone("
  printout = printout .. "\"" .. zone.name .. "\", vector3(" .. tostring(round(zone.center.x, 2)) .. ", " .. tostring(round(zone.center.y, 2))  .. ", " .. tostring(round(zone.center.z, 2)) .."), "
  printout = printout .. tostring(zone.radius) .. ", "
  printout = printout .. "{\n  useZ = " .. tostring(zone.useZ) .. ",\n})\n\n"
  printout = printout .. ",\n  debugPoly = false" 
  return printout
end

function parseBox(zone)
  local printout = printoutHeader(zone.name)
  printout = printout .. "exports['mercy-polyzone']:CreateBoxZone("
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