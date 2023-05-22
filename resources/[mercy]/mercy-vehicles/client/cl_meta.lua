function LoadVehicleMeta(Vehicle, Data)
    TriggerServerEvent("mercy-vehicles/server/load-veh-meta", VehToNet(Vehicle), Data)
end

function SetVehicleMeta(Vehicle, Key, Value)
    TriggerServerEvent("mercy-vehicles/server/set-veh-meta", VehToNet(Vehicle), Key, Value)
end

function GetVehicleMeta(Vehicle, Key)
    local Meta = Entity(Vehicle).state.meta
    if Meta == nil then
        LoadVehicleMeta(Vehicle)
        return Config.DefaultMeta[Key]
    end

    if Key == nil then return Meta end
    return Meta[Key]
end

exports("LoadVehicleMeta", LoadVehicleMeta)
exports("SetVehicleMeta", SetVehicleMeta)
exports("GetVehicleMeta", GetVehicleMeta)