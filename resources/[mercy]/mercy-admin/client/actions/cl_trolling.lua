local DRUNK_ANIM_SET = "move_m@drunk@verydrunk"
local DRUNK_DRIVING_EFFECTS = { 1, 7, 8, 23, 4, 5, }
local attackAnimalHashes = { GetHashKey("a_c_chimp"), GetHashKey("a_c_rottweiler"), GetHashKey("a_c_coyote") }
local animalGroupHash = GetHashKey("Animal")
local playerGroupHash = GetHashKey("PLAYER")
local DrunkPlayers = {}

-- [ Troll Commands ] --

-- [ Events ] --

RegisterNetEvent('mc-admin/client/fling-player', function()
    FlingPlayer()
end)

RegisterNetEvent("mc-admin/client/drunk", function()
    drunkThread()
end)

RegisterNetEvent("mc-admin/client/animal-attack", function()
    startWildAttack()
end)

RegisterNetEvent("mc-admin/client/set-fire", function()
    local playerPed = PlayerPedId()
    StartEntityFire(playerPed)
end)

-- [ Functions ] --

-- Drunk

local function getRandomDrunkCarTask()
    math.randomseed(GetGameTimer())
    return DRUNK_DRIVING_EFFECTS[math.random(#DRUNK_DRIVING_EFFECTS)]
end

function drunkThread()
    local playerPed = PlayerPedId()
    local Player = PlayerModule.GetPlayerData()
    if not DrunkPlayers[Player.CitizenId] then
        DrunkPlayers[Player.CitizenId] = true
        local isDrunk = true

        RequestAnimSet(DRUNK_ANIM_SET)
        while not HasAnimSetLoaded(DRUNK_ANIM_SET) do Wait(5) end

        SetPedMovementClipset(playerPed, DRUNK_ANIM_SET)
        ShakeGameplayCam("DRUNK_SHAKE", 3.0)
        SetPedIsDrunk(playerPed, true)
        SetTransitionTimecycleModifier("spectator5", 10.00)

        -- Random Veh Action
        CreateThread(function()
            while isDrunk do
                local vehPedIsIn = GetVehiclePedIsIn(playerPed)
                local isPedInVehicleAndDriving = (vehPedIsIn ~= 0) and (GetPedInVehicleSeat(vehPedIsIn, -1) == playerPed)

                if isPedInVehicleAndDriving then
                    local randomTask = getRandomDrunkCarTask()
                    TaskVehicleTempAction(playerPed, vehPedIsIn, randomTask, 500)
                end

                Wait(5000)
            end
        end)

        Wait(30 * 1000) -- 30 secs
        DrunkPlayers[Player.CitizenId] = false
        isDrunk = false
        SetTransitionTimecycleModifier("default", 10.00)
        StopGameplayCamShaking(true)
        ResetPedMovementClipset(playerPed)
        RemoveAnimSet(DRUNK_ANIM_SET)
    end
end

-- Wild attack

function startWildAttack()
    local playerPed = PlayerPedId()
    local animalHash = attackAnimalHashes[math.random(#attackAnimalHashes)]
    local coordsBehindPlayer = GetOffsetFromEntityInWorldCoords(playerPed, 100, -15.0, 0)
    local playerHeading = GetEntityHeading(playerPed)
    local belowGround, groundZ, vec3OnFloor = GetGroundZAndNormalFor_3dCoord(coordsBehindPlayer.x, coordsBehindPlayer.y, coordsBehindPlayer.z)

    RequestModel(animalHash)
    while not HasModelLoaded(animalHash) do Wait(5) end
    SetModelAsNoLongerNeeded(animalHash)
    local animalPed = CreatePed(1, animalHash, coordsBehindPlayer.x, coordsBehindPlayer.y, groundZ, playerHeading, true, false)
    SetPedFleeAttributes(animalPed, 0, 0)
    SetPedRelationshipGroupHash(animalPed, animalGroupHash)
    TaskSetBlockingOfNonTemporaryEvents(animalPed, true)
    TaskCombatHatedTargetsAroundPed(animalPed, 30.0, 0)
    ClearPedTasks(animalPed)
    TaskPutPedDirectlyIntoMelee(animalPed, playerPed, 0.0, -1.0, 0.0, 0)
    SetRelationshipBetweenGroups(5, animalGroupHash, playerGroupHash)
    SetRelationshipBetweenGroups(5, playerGroupHash, animalGroupHash)
end

function FlingPlayer()
    local Ped = PlayerPedId()
    if GetVehiclePedIsUsing(Ped) ~= 0 then
        ApplyForceToEntity(GetVehiclePedIsUsing(Ped), 1, 0.0, 0.0, 100000.0, 1.0, 0.0, 0.0, 1, false, true, false, false)
    else
        ApplyForceToEntity(Ped, 1, 9500.0, 3.0, 7100.0, 1.0, 0.0, 0.0, 1, false, true, false, false)
    end
end