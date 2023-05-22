local Throttles = {}
local _Ready = false
AddEventHandler('Modules/client/ready', function()
    if not _Ready then
        _Ready = true
        exports[GetCurrentResourceName()]:CreateModule("Functions", FunctionsModule)
    end
end)

FunctionsModule = {
    GetEntityPlayerIsLookingAt = function(Distance, Radius, Flag, Ignore)
        local Distance = Distance or 3.0
        local InVehicle = IsPedInAnyVehicle(PlayerPedId())
        local OriginCoords = GetPedBoneCoords(PlayerPedId(), 31086)
        local ForwardVectors = GetForwardVector(GetGameplayCamRot(2))
        local ForwardCoords = OriginCoords + (ForwardVectors * (InVehicle and Distance + 1.5 or Distance))
        if ForwardVectors then 
            local _, Hit, TargetCoords, _, TargetEntity = RayCast(OriginCoords, ForwardCoords, Flag or 286, Ignore, Radius or 0.2)
            if Hit and TargetEntity ~= 0 then 
                local EntityType = GetEntityType(TargetEntity)
                return TargetEntity, EntityType, TargetCoords, Hit
            end
        end
    end,
    CalculateZCoords = function(CoordX, CoordY, CoordZ)
        local SafeCoords, NewCoordsZ = GetGroundZFor_3dCoord(CoordX, CoordY, CoordZ, false)
        if SafeCoords then
            return NewCoordsZ + 0.35
        else
            return CoordZ
        end
    end,
    GetStreetName = function(Coords, Type) 
        local Coords = Coords ~= nil and Coords or GetEntityCoords(PlayerPedId())
        local Street1, Street2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, Coords.x, Coords.y, Coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
        local FirstStreetLabel = GetStreetNameFromHashKey(Street1)
        local SecondStreetLabel = GetStreetNameFromHashKey(Street2)
        if Type ~= 'Single' and SecondStreetLabel ~= nil and SecondStreetLabel ~= "" then 
            FirstStreetLabel = FirstStreetLabel .. " " .. SecondStreetLabel
        end
        return FirstStreetLabel
    end,
    GetCoords = function() 
        local Coords = GetEntityCoords(PlayerPedId())
        local Heading = GetEntityHeading(PlayerPedId())
        return {['X'] = Coords.x, ['Y'] = Coords.y, ['Z'] = Coords.z, ['Heading'] = Heading}
    end,  
    RequestModel = function(Model)
        local Request = 0
        RequestModel(Model)
        while not HasModelLoaded(Model) and Request < 50 do
            Citizen.Wait(100)
            Request = Request + 1
        end
        if Request == 50 then
            return false
        else
            return true
        end
    end,
    RequestAnimDict = function(AnimDict)
        local Request = 0
        RequestAnimDict(AnimDict)
        while not HasAnimDictLoaded(AnimDict) and Request < 25 do
            Citizen.Wait(100)
            Request = Request + 1
        end
        if Request == 25 then
            return false
        else
            return true
        end
    end,
    CreateCustomGpsRoute = function(CoordsTable, Follow)
        ClearGpsMultiRoute()
        StartGpsMultiRoute(6, true, true)
        for k, v in pairs(CoordsTable) do
            AddPointToGpsMultiRoute(v.Coords.x, v.Coords.y, v.Coords.z)
        end
        SetGpsMultiRouteRender(true)
    end,
    ClearCustomGpsRoute = function()
        ClearGpsMultiRoute()
    end,
    DeepCopyTable = function(Obj)
        if type(Obj) ~= 'table' then return Obj end
        local res = {}
        
        for k, v in pairs(Obj) do
            res[FunctionsModule.DeepCopyTable(k)] = FunctionsModule.DeepCopyTable(v)
        end

        return res
    end,
    GetTaxPrice = function(Price, Type)
        if Shared.Tax[Type] == nil then return Price end
        return math.floor(Price + ((Price / 100) * Shared.Tax[Type])) 
    end,
    EncryptString = function(String)
        return (String:gsub('.', function (C)
            return string.format('%02X', string.byte(C))
        end))
    end,
    DecryptString = function(String)
        return (String:gsub('..', function(CC)
            return string.char(tonumber(CC, 16))
        end))
    end,
    RoundDecimal = function(Number, Decimals)
        return tonumber(string.format("%." .. (Decimals or 0) .. "f", Number))
    end,
    Throttled = function(Name, Time)
        if not Throttles[Name] then
            Throttles[Name] = true
            Citizen.SetTimeout(Time or 500, function() Throttles[Name] = false end)
            return false
        end
        return true
    end,
}

-- [ Functions ] --

function GetForwardVector(Rotation)
    local Rotations = (math.pi / 180.0) * Rotation
    return vector3(-math.sin(Rotations.z) * math.abs(math.cos(Rotations.x)), math.cos(Rotations.z) * math.abs(math.cos(Rotations.x)), math.sin(Rotations.x))
end

function RayCast(Origin, Target, Options, IgnoreEntity, Radius)
    local Handle = StartShapeTestSweptSphere(Origin.x, Origin.y, Origin.z, Target.x, Target.y, Target.z, Radius, Options, IgnoreEntity, 0)
    return GetShapeTestResult(Handle)
end

-- ClearGpsCustomRoute()

-- -- Start a new route
-- StartGpsMultiRoute(13, false, true)

-- -- Add the points
-- AddPointToGpsCustomRoute(node.coords.x, node.coords.y, node.coords.z)
-- AddPointToGpsCustomRoute(cNode.coords.x, cNode.coords.y, cNode.coords.z)

-- -- Set the route to render
-- SetGpsCustomRouteRender(true, 8, 8)

-- SetTimeout(1 * 60 * 1000, function()
--   ClearGpsCustomRoute()
-- end)
