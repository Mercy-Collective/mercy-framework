local GrappleWeapon, GrappleWeaponSilencer = GetHashKey('weapon_bullpupshotgun'), GetHashKey('COMPONENT_AT_AR_SUPP_02')
local ShowingInteraction, HoldingGrapple, DoingGrapple = false, false, false
local EventsModule, ActiveRopes = nil, {}

AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
        'Events',
    }, function(Succeeded)
        if not Succeeded then return end
        EventsModule = exports['mercy-base']:FetchModule('Events')
    end)
end)

-- [ Code ] --

-- [ Events ] --

RegisterNetEvent("mercy-threads/entered-vehicle", function() 
    if not HoldingGrapple then return end
    TriggerEvent('mercy-grapple/client/used-grapple', true)
end)

RegisterNetEvent('mercy-grapple/client/used-grapple', function(ForceRemove)
    local CurrentWeapon = GetSelectedPedWeapon(PlayerPedId())
    if CurrentWeapon == GrappleWeapon or HoldingGrapple or ForceRemove then
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
        RemoveAllPedWeapons(PlayerPedId(), true)
        if ShowingInteraction then 
            ShowingInteraction = false 
            exports['mercy-ui']:HideInteraction() 
        end 
        HoldingGrapple = false
        return
    end
    if IsPedInAnyVehicle(PlayerPedId()) then return end

    HoldingGrapple = true
    GiveWeaponToPed(PlayerPedId(), GrappleWeapon, 0, 0, 1)
    SetAmmoInClip(PlayerPedId(), GrappleWeapon, 0)
    SetPedAmmo(PlayerPedId(), GrappleWeapon, 0)
    SetPedWeaponTintIndex(PlayerPedId(), GrappleWeapon, 5)
    GiveWeaponComponentToPed(PlayerPedId(), GrappleWeapon, GrappleWeaponSilencer)

    Citizen.CreateThread(function()
        local PlayerPed = PlayerPedId()
        while HoldingGrapple do
            Citizen.Wait(5)
            local FreeAiming = IsPlayerFreeAiming(PlayerId())
            if FreeAiming then
                local Hit, Coords = RayCastGamePlayCamera(GetEntityCoords(PlayerPed), 50.0)
                if Hit == 1 or Coords ~= vector3(0, 0, 0) then
                    if not ShowingInteraction and HoldingGrapple then
                        ShowingInteraction = true
                        exports['mercy-ui']:SetInteraction('[E] Grapple!')
                    end
                    if IsControlJustPressed(0, 38) then
                        if not DoingGrapple then
                            EventsModule.TriggerServer('mercy-inventory/server/degen-item', exports['mercy-inventory']:GetSlotForItem('weapon_grapple'), 25.0)
                            DoingGrapple = true
                            DoGrappleToCoords(Coords)
                        end
                    end
                else
                    if ShowingInteraction then
                        ShowingInteraction = false
                        exports['mercy-ui']:HideInteraction()
                    end
                end
            else
                if ShowingInteraction then
                    ShowingInteraction = false
                    exports['mercy-ui']:HideInteraction()
                end
            end
        end
    end)
end)

RegisterNetEvent('mercy-grapple/client/do-rope', function(SourceServer, Type, RopeId, SourceId, EndCoords)
    if Type == 'Create' then
        local PlayerCoords, TPlayer = GetEntityCoords(PlayerPedId()), GetPlayerFromServerId(tonumber(SourceId))
        local TPlayerPed = GetPlayerPed(TPlayer)

        if SourceServer ~= GetPlayerServerId(PlayerId()) then
            if #(PlayerCoords - GetEntityCoords(TPlayerPed)) > 150.0 or #(PlayerCoords - GetEntityCoords(TPlayerPed)) == 0 then return end
        end

        ActiveRopes[RopeId] = AddRope(EndCoords.x, EndCoords.y, EndCoords.z, 0.0, 0.0, 0.0, 0.0, 5, 0.0, 0.0, 1.0, false, false, false, 5.0, false)
        Citizen.CreateThread(function ()
            while not ActiveRopes[RopeId] ~= nil do
                Citizen.Wait(0)
                PinRope(ActiveRopes[RopeId], TPlayerPed, EndCoords)
            end
        end)
    elseif Type == 'Delete' then
        if ActiveRopes[RopeId] == nil then return end

        local Rope = ActiveRopes[RopeId]
        DeleteChildRope(Rope)
        DeleteRope(Rope)
        ActiveRopes[RopeId] = nil
    end
end)

-- [ Functions ] --

function DoGrappleToCoords(Coords)
    local RopeId = math.random(1111, 9999)
    local StartCoords, EndCoords = GetEntityCoords(PlayerPedId()), Coords
    local FromStartToDestination = EndCoords - StartCoords
    local Direction = FromStartToDestination / #FromStartToDestination
    local Length = #FromStartToDestination
    local Rotation = DirectionToRotation(-Direction * 1, 0.0) + vector3(90.0 * 1, 0.0, 0.0)

    TriggerServerEvent('mercy-grapple/server/do-rope', RopeId, Coords, 'Create')
    
    Citizen.CreateThread(function()
        local PlayerPed = PlayerPedId()
        local CurrentPosition = StartCoords
        local DistanceTraveled = 0.0
        while DoingGrapple do
            Citizen.Wait(4)
            local FwdPerFrame = Direction * 20.0 * GetFrameTime()
            DistanceTraveled = DistanceTraveled + #FwdPerFrame
            if DistanceTraveled > Length then
                DistanceTraveled = Length
                CurrentPosition = EndCoords
                DoingGrapple = false
            else
                CurrentPosition = CurrentPosition + FwdPerFrame
            end

            SetEntityCoords(PlayerPed, CurrentPosition)
            SetEntityRotation(PlayerPed, Rotation)

            if DistanceTraveled > 3 and HasEntityCollidedWithAnything(PlayerPed) == 1 then
               SetEntityCoords(PlayerPed, CurrentPosition - (Direction * 0.5))
               SetEntityRotation(PlayerPed, Rotation)
               DoingGrapple = false
               break
            end
        end
        TriggerServerEvent('mercy-grapple/server/do-rope', RopeId, vector3(0, 0, 0), 'Delete')
        if not exports['mercy-inventory']:HasEnoughOfItem('weapon_grapple', 1) then
            TriggerEvent('mercy-grapple/client/used-grapple', true)
        end
    end)
end

function PinRope(Rope, Ped, Coords)
    PinRopeVertex(Rope, 0, Coords)
    PinRopeVertex(Rope, GetRopeVertexCount(Rope) - 1, GetPedBoneCoords(Ped, 0x49D9, 0.0, 0.0, 0.0))
end

function RayCastGamePlayCamera(Coords, Distance)
    local CamRot, CamPos = GetGameplayCamRot(), GetGameplayCamCoord()
    local Direction = RotationToDirection(CamRot)
    local Destination = CamPos + (Direction * 55.0)
    local RayCast = StartShapeTestRay(CamPos, Destination, 17, -1, 0)
    local _, Hit, EndPos = GetShapeTestResult(RayCast)
    if Hit == 0 then 
        EndPos = Destination 
    end
    local CheckDistance = #(Coords - EndPos)
    if CheckDistance > Distance then
        Hit, EndPos = 0, vector3(0, 0, 0)
    end
    return Hit, EndPos
end

function RotationToDirection(Rotation)
    local RotX, RotZ = math.rad(Rotation.x), math.rad(Rotation.z)
    local CosOfRotX = math.abs(math.cos(RotX))
    return vector3(-math.sin(RotZ) * CosOfRotX, math.cos(RotZ) * CosOfRotX, math.sin(RotX))
end

function DirectionToRotation(Direction, Roll)
    local RotationPos = vector3(Direction.z, #vector2(Direction.x, Direction.y), 0.0)
    local CoordsX, CoordsY, CoordsZ = math.deg(math.atan2(RotationPos.x, RotationPos.y)), Roll, -math.deg(math.atan2(Direction.x, Direction.y))
    return vector3(CoordsX, CoordsY, CoordsZ)
end