local _Ready = false
AddEventHandler('Modules/client/ready', function()
    if not _Ready then
        _Ready = true
        exports[GetCurrentResourceName()]:CreateModule("Peds", PedsModule)
    end
end)

PedsModule = {
    GetPeds = function(IgnoreList)
        local IgnoreList, Peds = IgnoreList ~= nil and IgnoreList or {}, {}
        local EntityEnumModule = exports[GetCurrentResourceName()]:FetchModule('Entity')
        for Ped in EntityEnumModule.EnumeratePeds() do
            local Found = false
            for k, v in pairs(IgnoreList) do
                if v == Ped then
                    Found = true
                end
            end
            if not Found then
                table.insert(Peds, Ped)
            end
        end
        return Peds
    end,
    GetPedsInArea = function(Coords, Radius)
        local Coords = Coords ~= nil and vector3(Coords.x, Coords.y, Coords.z) or GetEntityCoords(PlayerPedId())
        local PedsModule = exports[GetCurrentResourceName()]:FetchModule('Peds')
        local Peds, PedsInArea = VehicleModule.GetPeds(), {}
        for k, v in pairs(Peds) do
            local PedCoords = GetEntityCoords(v)
            local Distance = #(PedCoords - Coords)
            if Distance <= Radius then
                table.insert(PedsInArea, v)
            end
        end
        return PedsInArea
    end,
    GetClosestPed = function(Coords, IgnoreList)
        local IgnoreList = IgnoreList ~= nil and IgnoreList or {}
        local PedsModule = exports[GetCurrentResourceName()]:FetchModule('Peds')
        local ClosesPeds = PedsModule.GetPeds(IgnoreList)
        local ClosestDistance, ClosestPed, Coords = -1, -1, Coords ~= nil and vector3(Coords.x, Coords.y, Coords.z) or GetEntityCoords(PlayerPedId())
        for k, v in pairs(ClosesPeds) do
            local TargetCoords = GetEntityCoords(v)
            local Distance = #(Coords - TargetCoords)
            if ClosestDistance == -1 or ClosestDistance > Distance then
                ClosestPed = v
                ClosestDistance = Distance
            end
        end
        return ClosestPed, ClosestDistance
    end
}