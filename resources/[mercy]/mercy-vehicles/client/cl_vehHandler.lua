local currentVehicle = 0
local currentVehicleIdentifier = nil
local modifiedVehicles = {}
local slipperySurfaceMaterial = {
    [9] = "ROCK",
    [10] = "ROCK_MOSSY",
    [11] = "STONE",
    [17] = "SANDSTONE_BRITTLE",
    [18] = "SAND_LOOSE",
    [19] = "SAND_COMPACT",
    [20] = "SAND_WET",
    [21] = "SAND_TRACK",
    [22] = "SAND_UNDERWATER",
    [23] = "SAND_DRY_DEEP",
    [24] = "SAND_WET_DEEP",
    [31] = "GRAVEL_SMALL",
    [32] = "GRAVEL_LARGE",
    [33] = "GRAVEL_DEEP",
    [34] = "GRAVEL_TRAIN_TRACK",
    [35] = "DIRT_TRACK",
    [36] = "MUD_HARD",
    [37] = "MUD_POTHOLE",
    [38] = "MUD_SOFT",
    [39] = "MUD_UNDERWATER",
    [40] = "MUD_DEEP",
    [41] = "MARSH",
    [42] = "MARSH_DEEP",
    [43] = "SOIL",
    [44] = "CLAY_HARD",
    [45] = "CLAY_SOFT",
    [46] = "GRASS_LONG",
    [47] = "GRASS",
    [48] = "GRASS_SHORT",
    [55] = "METAL_SOLID_SMALL",   -- Train Track
}

-- [ Threads ] --

CreateThread(function()
    local currentMaterial = 0
    local isOffroad = false
    local offroadTicks = 0
    while true do
        Wait(500)
        if currentVehicle ~= 0 then
            local surfaceMaterialIndex = GetVehicleWheelSurfaceMaterial(currentVehicle, 1)
            local isSlippery = slipperySurfaceMaterial[surfaceMaterialIndex]

            if isSlippery and offroadTicks < 5 then
                offroadTicks = offroadTicks + 1
            elseif not isSlippery and offroadTicks >= 1 then
                offroadTicks = offroadTicks - 1
            end

            if isSlippery and not isOffroad and offroadTicks > 3 then
                isOffroad = true
                toggleOffroadState(true)
            elseif isOffroad and offroadTicks < 3 then
                isOffroad = false
                toggleOffroadState(false)
            end
        end
    end
end)

-- [ Functions ] --

function getVehicleHandling(pVehicleIdentifier, pCurrentVehicleHandle, pHandling)
    if pVehicleIdentifier and pHandling then
        if modifiedVehicles[pVehicleIdentifier] ~= nil and modifiedVehicles[pVehicleIdentifier][pHandling] ~= nil then
            return true, modifiedVehicles[pVehicleIdentifier][pHandling]
        else
            return false, GetVehicleHandlingFloat(pCurrentVehicleHandle, "CHandlingData", pHandling)
        end
    end
end

function setVehicleHandling(pVehicleIdentifier, pCurrentVehicleHandle, pHandling, pFactor)
    local isModified, fValue = getVehicleHandling(pVehicleIdentifier, pCurrentVehicleHandle, pHandling)
    if not isModified then
        fValue = (fValue * pFactor)
    end
    modifiedVehicles[pVehicleIdentifier][pHandling] = fValue
    SetVehicleHandlingFloat(pCurrentVehicleHandle, "CHandlingData", pHandling, fValue)
end

function processVehicleHandling(pCurrentVehicle)
    local vehicleIdentifier = GetVehiclePedIsIn(PlayerPedId()) --TODO: This should call the server and grab the vehicle identifier.

    if not vehicleIdentifier then
        vehicleIdentifier = GetVehiclePlate(pCurrentVehicle)

        NetworkRegisterEntityAsNetworked(pCurrentVehicle)
        local netid = NetworkGetNetworkIdFromEntity(pCurrentVehicle)
        SetNetworkIdCanMigrate(pCurrentVehicle, true)
        SetNetworkIdExistsOnAllMachines(pCurrentVehicle, true)
    end

    if not vehicleIdentifier or vehicleIdentifier == "" then return end

    currentVehicleIdentifier = vehicleIdentifier
    SetVehiclePetrolTankHealth(pCurrentVehicle, 4000.0)
    SetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fWeaponDamageMult", 5.500000)
    SetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fDeformationDamageMult", 1.000000)

    local isModified, fSteeringLock = getVehicleHandling(vehicleIdentifier, pCurrentVehicle, "fSteeringLock")
    if not isModified then
        fSteeringLock = math.ceil((fSteeringLock * 0.6)) + 0.1
    end

    if not modifiedVehicles[vehicleIdentifier] then
        modifiedVehicles[vehicleIdentifier] = {}
    end

    modifiedVehicles[vehicleIdentifier]["fSteeringLock"] = fSteeringLock
    SetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fSteeringLock", fSteeringLock)

    if IsThisModelABike(GetEntityModel(pCurrentVehicle)) then
        setVehicleHandling(vehicleIdentifier, pCurrentVehicle, "fTractionCurveMin", 0.6)
        setVehicleHandling(vehicleIdentifier, pCurrentVehicle, "fTractionCurveMax", 0.6) 
        setVehicleHandling(vehicleIdentifier, pCurrentVehicle, "fInitialDriveForce", 2.2)
        setVehicleHandling(vehicleIdentifier, pCurrentVehicle, "fBrakeForce", 1.4)
        SetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fSuspensionReboundDamp", 5.000000)
        SetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fSuspensionCompDamp", 5.000000)
        SetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fSuspensionForce", 22.000000)
        SetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fCollisionDamageMult", 2.500000)
        SetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fEngineDamageMult", 0.120000)
    else
        setVehicleHandling(vehicleIdentifier, pCurrentVehicle, "fTractionCurveMin", 1.0)
        setVehicleHandling(vehicleIdentifier, pCurrentVehicle, "fBrakeForce", 0.5)
        SetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fEngineDamageMult", 0.250000)
        SetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fCollisionDamageMult", 2.900000)
    end

    modifiedVehicles[vehicleIdentifier].fInitialDriveMaxFlatVel = GetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fInitialDriveMaxFlatVel")
    modifiedVehicles[vehicleIdentifier].fTractionLossMult = GetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fTractionLossMult")
    modifiedVehicles[vehicleIdentifier].fLowSpeedTractionLossMult = GetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fLowSpeedTractionLossMult")
    modifiedVehicles[vehicleIdentifier].fDriveBiasFront = GetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fDriveBiasFront")
    modifiedVehicles[vehicleIdentifier].fDriveInertia = GetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fDriveInertia")

    -- print("fTractionLoss", modifiedVehicles[currentVehicleIdentifier].fTractionLossMult)
    -- print("fTractionCurveMin", modifiedVehicles[currentVehicleIdentifier].fTractionCurveMin)
    -- print("fLowSpeedTractionLossMult", modifiedVehicles[currentVehicleIdentifier].fLowSpeedTractionLossMult)

    SetVehicleHasBeenOwnedByPlayer(pCurrentVehicle, true)
end

function toggleOffroadState(pState)
    local vehClass = GetVehicleClass(currentVehicle)
    if currentVehicleIdentifier ~= nil and (vehClass ~= 9 and vehClass ~= 8) then
        local isAWD = (modifiedVehicles[currentVehicleIdentifier].fDriveBiasFront > 0 and modifiedVehicles[currentVehicleIdentifier].fDriveBiasFront < 1)
        local lowSpeedTractionFactor = isAWD and 1.5 or 1.5
        local tractionFactor = isAWD and 0.8 or 0.9

        -- print("fTractionLoss", modifiedVehicles[currentVehicleIdentifier].fTractionLossMult * (pState and 1.5 or 1.0))
        -- print("fTractionCurveMin", modifiedVehicles[currentVehicleIdentifier].fTractionCurveMin * (pState and tractionFactor or 1.0))
        -- print("fLowSpeedTractionLossMult", modifiedVehicles[currentVehicleIdentifier].fLowSpeedTractionLossMult * (pState and lowSpeedTractionFactor or 1.0))

        SetVehicleHandlingFloat(currentVehicle, "CHandlingData", "fTractionLossMult", modifiedVehicles[currentVehicleIdentifier].fTractionLossMult * (pState and 1.5 or 1.0))
        SetVehicleHandlingFloat(currentVehicle, "CHandlingData", "fTractionCurveMin",
        modifiedVehicles[currentVehicleIdentifier].fTractionCurveMin * (pState and tractionFactor or 1.0))
        SetVehicleHandlingFloat(currentVehicle, "CHandlingData", "fLowSpeedTractionLossMult",
        modifiedVehicles[currentVehicleIdentifier].fLowSpeedTractionLossMult * (pState and lowSpeedTractionFactor or 1.0))
    end
end

AddEventHandler("baseevents:enteredVehicle", function(pCurrentVehicle, currentSeat, vehicleDisplayName)
    currentVehicle = pCurrentVehicle

    SetPedConfigFlag(PlayerPedId(), 35, false)

    local vehicleClass = GetVehicleClass(pCurrentVehicle)
    if vehicleClass == 15 or vehicleClass == 16 then
        SetAudioSubmixEffectParamInt(0, 0, `enabled`, 1)
    end

    if currentSeat == -1 then
        processVehicleHandling(pCurrentVehicle)
    end
end)

AddEventHandler("baseevents:leftVehicle", function(pCurrentVehicle, pCurrentSeat, vehicleDisplayName)
    currentVehicle = 0
    offroadTicks = 0
    currentVehicleIdentifier = nil

    SetAudioSubmixEffectParamInt(0, 0, `enabled`, 0)
    toggleOffroadState(false)
end)

AddEventHandler("baseevents:vehicleChangedSeat", function(pCurrentVehicle, pCurrentSeat, previousSeat)
    if pCurrentSeat == -1 then
        processVehicleHandling(pCurrentVehicle)
    end
end)
