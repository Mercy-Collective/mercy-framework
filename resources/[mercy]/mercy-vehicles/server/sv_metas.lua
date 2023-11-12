-- [ Events ] --

RegisterNetEvent("mercy-vehicles/server/load-veh-meta", function(NetId, Data)
    local Vehicle = NetworkGetEntityFromNetworkId(NetId)
    local Meta = Entity(Vehicle).state.meta

    -- Set meta firsttime
    if Meta == nil then
        Entity(Vehicle).state:set('meta', Config.DefaultMeta, true)
        return
    end

    if Data == nil then
        return
    end
    -- Update
    Entity(Vehicle).state:set('meta', Data, true)
end)

RegisterNetEvent("mercy-vehicles/server/set-veh-meta", function(NetId, Key, Value)
    local Vehicle = NetworkGetEntityFromNetworkId(NetId)
    local Meta = Entity(Vehicle).state.meta
    if Meta == nil then
        Entity(Vehicle).state:set('meta', Config.DefaultMeta, true)
        return
    end

    if Value == nil then
        return
    end
    
    Meta[Key] = Value
    Entity(Vehicle).state:set('meta', Meta, true)
end)
