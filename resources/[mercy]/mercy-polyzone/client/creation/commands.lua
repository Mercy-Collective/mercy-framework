RegisterCommand("pzcreate", function(src, args)
    local zoneType = args[1]
    if zoneType == nil then
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0},
            multiline = true,
            args = {"Me", "Please add zone type to create (poly, circle, box)!"}
        })
        return
    end

    if zoneType ~= 'poly' and zoneType ~= 'circle' and zoneType ~= 'box' then
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0},
            multiline = true,
            args = {"Me", "Zone type must be one of: poly, circle, box"}
        })
        return
    end

    local name = nil
    if #args >= 2 then
        name = args[2]
    else
        name = GetUserInput("Enter name of zone:")
    end

    if name == nil or name == "" then
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0},
            multiline = true,
            args = {"Me", "Please add a name!"}
        })
        return
    end

    TriggerEvent("polyzone:pzcreate", zoneType, name, args)
end, false)

RegisterCommand("pzadd", function(src, args)
    TriggerEvent("polyzone:pzadd")
end, false)

RegisterCommand("pzundo", function(src, args)
    TriggerEvent("polyzone:pzundo")
end, false)

RegisterCommand("pzfinish", function(src, args)
    TriggerEvent("polyzone:pzfinish")
end, false)

RegisterCommand("pzlast", function(src, args)
    TriggerEvent("polyzone:pzlast")
end, false)

RegisterCommand("pzcancel", function(src, args)
    TriggerEvent("polyzone:pzcancel")
end, false)

RegisterCommand("pzcomboinfo", function (src, args)
    TriggerEvent("polyzone:pzcomboinfo")
end, false)