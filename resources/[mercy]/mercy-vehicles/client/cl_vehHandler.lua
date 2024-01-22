local CurrentVehIdentifier = nil

local ModifiedVehicles = {}
local SlipperySurfaceMaterial = {
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

local IsOffroad = false
local OffroadTicks = 0

-- [ Threads ] --

CreateThread(function()
    while true do
        Wait(500)
        if LocalPlayer.state.LoggedIn then
            if CurrentVehicleData.Vehicle ~= 0 then
                local surfaceMaterialIndex = GetVehicleWheelSurfaceMaterial(CurrentVehicleData.Vehicle, 1)
                local IsSlippery = SlipperySurfaceMaterial[surfaceMaterialIndex]

                if IsSlippery and OffroadTicks < 5 then
                    OffroadTicks = OffroadTicks + 1
                elseif not IsSlippery and OffroadTicks >= 1 then
                    OffroadTicks = OffroadTicks - 1
                end

                if IsSlippery and not IsOffroad and OffroadTicks > 3 then
                    IsOffroad = true
                    ToggleOffroadState(true)
                elseif IsOffroad and OffroadTicks < 3 then
                    IsOffroad = false
                    ToggleOffroadState(false)
                end
            end
        else
            Wait(500)
        end
    end
end)

-- [ Functions ] --

function GetVehicleHandling(pVehicleIdentifier, pCurrentVehicleHandle, pHandling)
    if pVehicleIdentifier and pHandling then
        if ModifiedVehicles[pVehicleIdentifier] ~= nil and ModifiedVehicles[pVehicleIdentifier][pHandling] ~= nil then
            return true, ModifiedVehicles[pVehicleIdentifier][pHandling]
        else
            return false, GetVehicleHandlingFloat(pCurrentVehicleHandle, "CHandlingData", pHandling)
        end
    end
end

function SetVehicleHandling(pVehicleIdentifier, pCurrentVehicleHandle, pHandling, pFactor)
    local isModified, fValue = GetVehicleHandling(pVehicleIdentifier, pCurrentVehicleHandle, pHandling)
    if not isModified then
        fValue = (fValue * pFactor)
    end
    ModifiedVehicles[pVehicleIdentifier][pHandling] = fValue
    SetVehicleHandlingFloat(pCurrentVehicleHandle, "CHandlingData", pHandling, fValue)
end

function ProcessVehicleHandling(pCurrentVehicle)
    local vehicleIdentifier = GetVehiclePedIsIn(PlayerPedId()) --TODO: This should call the server and grab the vehicle identifier.

    if not vehicleIdentifier then
        vehicleIdentifier = GetVehiclePlate(pCurrentVehicle)

        NetworkRegisterEntityAsNetworked(pCurrentVehicle)
        local netid = NetworkGetNetworkIdFromEntity(pCurrentVehicle)
        SetNetworkIdCanMigrate(pCurrentVehicle, true)
        SetNetworkIdExistsOnAllMachines(pCurrentVehicle, true)
    end

    if not vehicleIdentifier or vehicleIdentifier == "" then return end

    CurrentVehIdentifier = vehicleIdentifier
    SetVehiclePetrolTankHealth(pCurrentVehicle, 4000.0)
    SetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fWeaponDamageMult", 5.500000)
    SetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fDeformationDamageMult", 1.000000)

    local isModified, fSteeringLock = GetVehicleHandling(vehicleIdentifier, pCurrentVehicle, "fSteeringLock")
    if not isModified then
        fSteeringLock = math.ceil((fSteeringLock * 0.6)) + 0.1
    end

    if not ModifiedVehicles[vehicleIdentifier] then
        ModifiedVehicles[vehicleIdentifier] = {}
    end

    ModifiedVehicles[vehicleIdentifier]["fSteeringLock"] = fSteeringLock
    SetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fSteeringLock", fSteeringLock)

    if IsThisModelABike(GetEntityModel(pCurrentVehicle)) then
        SetVehicleHandling(vehicleIdentifier, pCurrentVehicle, "fTractionCurveMin", 0.6)
        SetVehicleHandling(vehicleIdentifier, pCurrentVehicle, "fTractionCurveMax", 0.6) 
        SetVehicleHandling(vehicleIdentifier, pCurrentVehicle, "fInitialDriveForce", 2.2)
        SetVehicleHandling(vehicleIdentifier, pCurrentVehicle, "fBrakeForce", 1.4)
        SetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fSuspensionReboundDamp", 5.000000)
        SetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fSuspensionCompDamp", 5.000000)
        SetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fSuspensionForce", 22.000000)
        SetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fCollisionDamageMult", 2.500000)
        SetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fEngineDamageMult", 0.120000)
    else
        SetVehicleHandling(vehicleIdentifier, pCurrentVehicle, "fTractionCurveMin", 1.0)
        SetVehicleHandling(vehicleIdentifier, pCurrentVehicle, "fBrakeForce", 0.5)
        SetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fEngineDamageMult", 0.250000)
        SetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fCollisionDamageMult", 2.900000)
    end

    ModifiedVehicles[vehicleIdentifier].fInitialDriveMaxFlatVel = GetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fInitialDriveMaxFlatVel")
    ModifiedVehicles[vehicleIdentifier].fTractionLossMult = GetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fTractionLossMult")
    ModifiedVehicles[vehicleIdentifier].fLowSpeedTractionLossMult = GetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fLowSpeedTractionLossMult")
    ModifiedVehicles[vehicleIdentifier].fDriveBiasFront = GetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fDriveBiasFront")
    ModifiedVehicles[vehicleIdentifier].fDriveInertia = GetVehicleHandlingFloat(pCurrentVehicle, "CHandlingData", "fDriveInertia")

    SetVehicleHasBeenOwnedByPlayer(pCurrentVehicle, true)
end

function ToggleOffroadState(pState)
    local vehClass = GetVehicleClass(CurrentVehicleData.Vehicle)
    if CurrentVehIdentifier ~= nil and (vehClass ~= 9 and vehClass ~= 8) then
        local isAWD = (ModifiedVehicles[CurrentVehIdentifier].fDriveBiasFront > 0 and ModifiedVehicles[CurrentVehIdentifier].fDriveBiasFront < 1)
        local lowSpeedTractionFactor = isAWD and 1.5 or 1.5
        local tractionFactor = isAWD and 0.8 or 0.9

        SetVehicleHandlingFloat(CurrentVehicleData.Vehicle, "CHandlingData", "fTractionLossMult", ModifiedVehicles[CurrentVehIdentifier].fTractionLossMult * (pState and 1.5 or 1.0))
        SetVehicleHandlingFloat(CurrentVehicleData.Vehicle, "CHandlingData", "fTractionCurveMin",
        ModifiedVehicles[CurrentVehIdentifier].fTractionCurveMin * (pState and tractionFactor or 1.0))
        SetVehicleHandlingFloat(CurrentVehicleData.Vehicle, "CHandlingData", "fLowSpeedTractionLossMult",
        ModifiedVehicles[CurrentVehIdentifier].fLowSpeedTractionLossMult * (pState and lowSpeedTractionFactor or 1.0))
    end
end

-- [ Events ] --

RegisterNetEvent("mercy-threads/entered-vehicle", function()
    CurrentVehicleData.Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

    SetPedConfigFlag(PlayerPedId(), 35, false)

    if CurrentVehicleData.IsDriver then
        ProcessVehicleHandling(CurrentVehicleData.Vehicle)
    end
end)

RegisterNetEvent("mercy-threads/exited-vehicle", function()
    OffroadTicks = 0
    CurrentVehIdentifier = nil

    ToggleOffroadState(false)
end)

AddEventHandler("baseevents:vehicleChangedSeat", function(pCurrentVehicle, pCurrentSeat, previousSeat)
    if pCurrentSeat == -1 then
        ProcessVehicleHandling(pCurrentVehicle)
    end
end)
