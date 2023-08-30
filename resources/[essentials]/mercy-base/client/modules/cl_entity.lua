local IsPlacing, PlacingObject = false, nil

local EntityEnumerator = {
    __gc = function(Enum)
        if Enum.Destructor and Enum.Handle then
            Enum.Destructor(Enum.Handle)
        end
        Enum.Destructor = nil
        Enum.Handle = nil
    end
}

local _Ready = false
AddEventHandler('Modules/client/ready', function()
    if not _Ready then
        _Ready = true
        exports[GetCurrentResourceName()]:CreateModule("Entity", EntityModule)
    end
end)

EntityModule = {
    EnumerateObjects = function()
        return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
    end,
    EnumeratePeds = function()
        return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
    end,
    EnumerateVehicles = function()
        return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
    end,
    EnumeratePickups = function()
        return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
    end,
    CreateEntity = function(Model, Coords, Networked)
        local FunctionModule, HashEntity = exports[GetCurrentResourceName()]:FetchModule('Functions'), GetHashKey(Model)
        local LoadedEntity = FunctionModule.RequestModel(HashEntity)
        if LoadedEntity then
            return CreateObject(HashEntity, Coords, Networked ~= nil and Networked or false, false, false)
        else
            return false
        end
    end,
    DeleteEntity = function(Entity)
        if NetworkHasControlOfEntity(Entity) then
            DeleteEntity(Entity)
        else
            RequestSyncExecution("DeleteEntity", Entity)
        end
    end,
    IsPlacingEntity = function()
        return IsPlacing
    end,
    StopEntityPlacer = function()
        EntityModule.DeleteEntity(PlacingObject)
        IsPlacing, PlacingObject = false, nil
    end,
    DoEntityPlacer = function(Model, MaxDistance, StickToGround, PlayerHeading, ZMin, Cb)
        local CenterCoords = GetEntityCoords(PlayerPedId()) + (GetEntityForwardVector(PlayerPedId()) * 1.5)
        PlacingObject = EntityModule.CreateEntity(Model, CenterCoords, false)
        if PlacingObject ~= false then
            SetEntityCollision(PlacingObject, false)
            SetEntityAlpha(PlacingObject, 0.3, true)
            local ClosestHeading = GetClosestHeading(GetEntityHeading(PlayerPedId()))
            SetEntityHeading(PlacingObject, ClosestHeading)
            IsPlacing = true
            Citizen.CreateThread(function()
                while IsPlacing do
                    Citizen.Wait(4)
                    DisableControlAction(0, 24, true)
                    DisableControlAction(1, 38, true)
                    DisableControlAction(0, 44, true)
                    DisableControlAction(0, 142, true)
                    DisablePlayerFiring(PlayerPedId(), true)

                    if StickToGround and ZMin == nil then
                        PlaceObjectOnGroundProperly(PlacingObject)
                    end               

                    if PlayerHeading then
                        SetEntityHeading(PlacingObject, GetFinalRenderedCamRot(0).z)
                    end
                    
                    local _, Coords, _ = RayCastGamePlayCamera(10.0)
                    SetEntityCoords(PlacingObject, Coords.x, Coords.y, (ZMin ~= nil and Coords.z - ZMin or Coords.z))

                    if IsControlJustReleased(0, 180) then
                        local EntityHeading = GetEntityHeading(PlacingObject)
                        SetEntityHeading(PlacingObject, EntityHeading + 5.0)
                    end

                    if IsControlJustReleased(0, 181) then
                        local EntityHeading = GetEntityHeading(PlacingObject)
                        SetEntityHeading(PlacingObject, EntityHeading - 5.0)
                    end

                    if IsControlJustReleased(0, 177) then
                        EntityModule.DeleteEntity(PlacingObject)
                        IsPlacing, PlacingObject = false, nil
                        Cb(false)
                    end
                    
                    if IsControlJustReleased(0, 191) then
                        local EntityCoords, EntityHeading = GetEntityCoords(PlacingObject), GetEntityHeading(PlacingObject)
                        EntityModule.DeleteEntity(PlacingObject)
                        Cb(true, EntityCoords, EntityHeading)
                        IsPlacing, PlacingObject = false, nil
                    end

                    if PlacingObject ~= nil and #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(PlacingObject)) > MaxDistance then
                        EntityModule.DeleteEntity(PlacingObject)
                        IsPlacing, PlacingObject = false, nil
                        Cb(false)
                    end
                end
            end)
        else
            Cb(false)
        end
    end,
}

-- [ Functions ] --

function EnumerateEntities(InitFunc, MoveFunc, DisposeFunc)
    return coroutine.wrap(function()
        local Iter, Id = InitFunc()
        if not Id or Id == 0 then
            DisposeFunc(Iter)
            return
        end
        local Enum = {Handle = Iter, Destructor = DisposeFunc}
        setmetatable(Enum, EntityEnumerator)
        local Next = true
        repeat
            coroutine.yield(Id)
            Next, Id = MoveFunc(Iter)
        until not Next
        Enum.Destructor, Enum.Handle = nil, nil
        DisposeFunc(Iter)
    end)
end

function RayCastGamePlayCamera(Distance)
    local CameraRotation = GetGameplayCamRot()
    local CameraCoord = GetGameplayCamCoord()
    local Direction = RotationToDirection(CameraRotation)
    local Destination = {x = CameraCoord.x + Direction.x * Distance, y = CameraCoord.y + Direction.y * Distance, z = CameraCoord.z + Direction.z * Distance}
    local A, B, C, D, E = GetShapeTestResult(StartShapeTestRay(CameraCoord.x, CameraCoord.y, CameraCoord.z, Destination.x, Destination.y, Destination.z, -1, PlayerPedId(), 0))
    return B, C, E
end

function RotationToDirection(Rotation)
	local AdjustedRotation = {x = (math.pi / 180) * Rotation.x, y = (math.pi / 180) * Rotation.y, z = (math.pi / 180) * Rotation.z}
	local Direction = {x = -math.sin(AdjustedRotation.z) * math.abs(math.cos(AdjustedRotation.x)), y = math.cos(AdjustedRotation.z) * math.abs(math.cos(AdjustedRotation.x)), z = math.sin(AdjustedRotation.x)}
	return Direction
end

function GetClosestHeading(Heading)
    local PossibleHeadings = {0.0, 90.0, 180.0, 270.0}
    local Difference, ClosestHeading = 360.0, 0.0
    for k, v in pairs(PossibleHeadings) do
        if math.abs(Heading - v) < Difference then
            Difference = math.abs(Heading - v)
            ClosestHeading = v
        end
    end
    return ClosestHeading
end

