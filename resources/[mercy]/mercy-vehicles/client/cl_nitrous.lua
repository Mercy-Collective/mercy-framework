local FlameScale, PurgeSprayScale = 1.2, 0.8
local NitrousStages = {5.0, 3.0, 1.0, 0.5, 0.25}
local DoingNitrous, NitrousStage = false, 1
local NitrousType = 'Nitrous'
local VehicleParticles = {}
local ExhaustNames = {
    "exhaust",    "exhaust_2",  "exhaust_3",  "exhaust_4",
    "exhaust_5",  "exhaust_6",  "exhaust_7",  "exhaust_8",
    "exhaust_9",  "exhaust_10", "exhaust_11", "exhaust_12",
    "exhaust_13", "exhaust_14", "exhaust_15", "exhaust_16"
}

-- [ Threads ] --

CreateThread(function()
    while true do
        Wait(4)
        if LocalPlayer.state.LoggedIn and DoingNitrous then
            DisableControlAction(0, 75, true) -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle
        else
            Wait(450)
        end
    end
end)

-- [ Events ] --

RegisterNetEvent('mercy-items/client/used-nitrous', function()
    SetTimeout(450, function()
        local Vehicle = CurrentVehicleData.Vehicle
        local Plate = CurrentVehicleData.Plate
        if DoingNitrous then return end
        if Vehicle == 0 or Vehicle == -1 or not CurrentVehicleData.IsDriver or GetVehicleMeta(Vehicle, 'Nitrous') == nil then return end

        if IsGovVehicle(Vehicle) then
            exports['mercy-ui']:Notify('nitrous-error', "I don\'t think this vehicle should take some nitrous..", 'error')
            return
        end
        if not IsToggleModOn(Vehicle, 18) then
            exports['mercy-ui']:Notify('nitrous-error', "Looks like this vehicle doesn\'t even have a turbo installed..", 'error')
            return 
        end

        exports['mercy-inventory']:SetBusyState(true)
        exports['mercy-ui']:ProgressBar('Nitrous..', 3500, false, false, false, true, function(DidComplete)
            if DidComplete then
                local DidRemove = CallbackModule.SendCallback("mercy-base/server/remove-item", 'nitrous', 1, false, true)
                if DidRemove then
                    SetVehicleMeta(Vehicle, "Nitrous", 100.0)
                    EventsModule.TriggerServer('mercy-inventory/server/decay-item', 'nitrous', exports['mercy-inventory']:GetSlotForItem('nitrous', ''), 100.0)
                end
            end
            exports['mercy-inventory']:SetBusyState(false)
        end)
    end)
end)

RegisterNetEvent('mercy-vehicles/client/set-vehicle-flames', function(Veh, Bool)
    local Vehicle = NetToVeh(Veh)
    if Bool then
        CreateVehicleExhaustBackfire(Vehicle)
    else
        RemoveVehicleExhaustBackfire(Vehicle)
    end
end)

RegisterNetEvent('mercy-vehicles/client/set-vehicle-purge', function(Veh, Bool)
    local Vehicle = NetToVeh(Veh)
    if Bool then
        CreateVehiclePurgeSpray(Vehicle)
    else
        RemoveVehiclePurgeSpray(Vehicle)
    end
end)

RegisterNetEvent('mercy-vehicles/client/nitrous-usage', function(OnPress)
    if not OnPress then return end
    local Vehicle = CurrentVehicleData.Vehicle
    local Plate = CurrentVehicleData.Plate
    if Vehicle == 0 or Vehicle == -1 or not CurrentVehicleData.IsDriver then return end
    local Nitrous = GetVehicleMeta(Vehicle, 'Nitrous')
    if Nitrous ~= nil and Nitrous > 0 then
        if NitrousStage + 1 > #NitrousStages then
            NitrousStage = 1
        else
            NitrousStage = NitrousStage + 1
        end
        exports['mercy-ui']:Notify('nitrous', "Set nitrous usage to: "..NitrousStages[NitrousStage])
    end

end)

RegisterNetEvent('mercy-vehicles/client/nitrous-type', function(OnPress)
    if not OnPress then return end
    local Vehicle = CurrentVehicleData.Vehicle
    local Plate = CurrentVehicleData.Plate
    if Vehicle == 0 or Vehicle == -1 or not CurrentVehicleData.IsDriver then return end
    local Nitrous = GetVehicleMeta(Vehicle, 'Nitrous')
    if Nitrous ~= nil and Nitrous > 0 then
        if NitrousType == 'Nitrous' then
            NitrousType = 'Purge'
        else
            NitrousType = 'Nitrous'
        end
        exports['mercy-ui']:Notify('nitrous', "Set nitrous type to: "..NitrousType)
    end
end)

RegisterNetEvent('mercy-vehicles/client/nitrous', function(OnPress)
    if OnPress then
        local Vehicle = CurrentVehicleData.Vehicle
        local Plate = CurrentVehicleData.Plate
        if Vehicle == 0 or Vehicle == -1 or not CurrentVehicleData.IsDriver then return end
        local NitrousLevel = GetVehicleMeta(Vehicle, 'Nitrous')
        if NitrousLevel ~= nil and NitrousLevel > 0 then
            DoingNitrous = true
            if NitrousType == 'Nitrous' then
                SetVehicleBoostActive(Vehicle, true)
                TriggerServerEvent('mercy-vehicles/server/set-vehicle-flames', VehToNet(Vehicle), true)
            elseif NitrousType == 'Purge' then
                TriggerServerEvent('mercy-vehicles/server/set-vehicle-purge', VehToNet(Vehicle), true)
            end
            DoNitrousLoop(Vehicle, Plate)
        end
    else
        if DoingNitrous then
            local Vehicle = CurrentVehicleData.Vehicle
            local Plate = CurrentVehicleData.Plate
            DoingNitrous = false
            if NitrousType == 'Nitrous' then
                SetVehicleBoostActive(Vehicle, false)
                SetVehicleEnginePowerMultiplier(Vehicle, 1.0)
                SetVehicleEngineTorqueMultiplier(Vehicle, 1.0)
                TriggerServerEvent('mercy-vehicles/server/set-vehicle-flames', VehToNet(Vehicle), false)
                SetTimeout(100, function()
                    TriggerServerEvent('mercy-vehicles/server/set-vehicle-purge', VehToNet(Vehicle), true)
                    Wait(1500)
                    TriggerServerEvent('mercy-vehicles/server/set-vehicle-purge', VehToNet(Vehicle), false)
                end)
            elseif NitrousType == 'Purge' then
                TriggerServerEvent('mercy-vehicles/server/set-vehicle-purge', VehToNet(Vehicle), false)
            end
        end
    end
end)

RegisterNetEvent("mercy-threads/exited-vehicle", function()
    if DoingNitrous then
        DoingNitrous = false
        local Vehicle = CurrentVehicleData.Vehicle
        local Plate = CurrentVehicleData.Plate
        if NitrousType == 'Nitrous' then
            SetVehicleBoostActive(Vehicle, false)
            SetVehicleEnginePowerMultiplier(Vehicle, 1.0)
            SetVehicleEngineTorqueMultiplier(Vehicle, 1.0)
            TriggerServerEvent('mercy-vehicles/server/set-vehicle-flames', VehToNet(Vehicle), false)
            SetTimeout(100, function()
                TriggerServerEvent('mercy-vehicles/server/set-vehicle-purge', VehToNet(Vehicle), true)
                Wait(1500)
                TriggerServerEvent('mercy-vehicles/server/set-vehicle-purge', VehToNet(Vehicle), false)
            end)
        elseif NitrousType == 'Purge' then
            TriggerServerEvent('mercy-vehicles/server/set-vehicle-purge', VehToNet(Vehicle), false)
        end
    end
end)

-- [ Functions ] --

-- Nitrous Loop

function DoNitrousLoop(Vehicle, Plate)
    CreateThread(function()
        while DoingNitrous do
            Wait(4)
            local NewNitrous = GetVehicleMeta(Vehicle, 'Nitrous') - NitrousStages[NitrousStage]
            if NewNitrous > 0 then
                if NitrousType == 'Nitrous' then
                    local CurrentSpeed, MaximumSpeed = GetEntitySpeed(Vehicle), GetVehicleModelMaxSpeed(GetEntityModel(Vehicle))
                    local Multiplier = NitrousStages[NitrousStage] * MaximumSpeed / CurrentSpeed                      
                    SetVehicleEnginePowerMultiplier(Vehicle, Multiplier)
                    SetVehicleEngineTorqueMultiplier(Vehicle, Multiplier)
                end
                SetVehicleMeta(Vehicle, "Nitrous", NewNitrous)
                TriggerEvent('mercy-ui/client/set-hud-values', 'Nos', 'Value', NewNitrous)
            else
                DoingNitrous = false
                SetVehicleMeta(Vehicle, "Nitrous", 0)
                TriggerEvent('mercy-ui/client/set-hud-values', 'Nos', 'Value', 0)
                if NitrousType == 'Nitrous' then
                    SetVehicleBoostActive(Vehicle, false)
                    SetVehicleEnginePowerMultiplier(Vehicle, 1.0)
                    SetVehicleEngineTorqueMultiplier(Vehicle, 1.0)
                    TriggerServerEvent('mercy-vehicles/server/set-vehicle-flames', VehToNet(Vehicle), false)
                    SetTimeout(100, function()
                        TriggerServerEvent('mercy-vehicles/server/set-vehicle-purge', VehToNet(Vehicle), true)
                        Wait(1500)
                        TriggerServerEvent('mercy-vehicles/server/set-vehicle-purge', VehToNet(Vehicle), false)
                    end)
                elseif NitrousType == 'Purge' then
                    TriggerServerEvent('mercy-vehicles/server/set-vehicle-purge', VehToNet(Vehicle), false)
                end
            end
            Wait(1000)
        end
    end)
end

-- Flames

function CreateVehicleExhaustBackfire(Vehicle)
    CreateThread(function()
        local Plate = CurrentVehicleData.Plate
        if Vehicle ~= -1 and Plate ~= nil then
            if VehicleParticles[Plate] == nil then VehicleParticles[Plate] = {} end
            for k, v in pairs(ExhaustNames) do
                if GetEntityBoneIndexByName(Vehicle, v) ~= -1 then
                    SetPtfxAssetNextCall('veh_xs_vehicle_mods')
                    Citizen.InvokeNative(0x6C38AF3693A69A91, 'veh_xs_vehicle_mods')
                    table.insert(VehicleParticles[Plate], StartNetworkedParticleFxLoopedOnEntityBone('veh_nitrous', Vehicle, 0.0, -0.02, 0.0, 0.0, 0.0, 0.0, GetEntityBoneIndexByName(Vehicle, v), FlameScale, 0.0, 0.0, 0.0))
                end
            end
        end
    end)
end

function RemoveVehicleExhaustBackfire(Vehicle)
    CreateThread(function()
        local Plate = CurrentVehicleData.Plate
        if Vehicle ~= -1 and Plate ~= nil then
            if VehicleParticles[Plate] ~= nil then
                for k, v in pairs(VehicleParticles[Plate]) do
                    StopParticleFxLooped(v, 1)
                end
                VehicleParticles[Plate] = {}
            end
        end
    end)
end

-- Spray

function CreateVehicleSpray(Vehicle, X, Y, Z, XRot, YRot, ZRot)
    UseParticleFxAssetNextCall('core')
    return StartParticleFxLoopedOnEntity('ent_sht_steam', Vehicle, X, Y, Z, XRot, YRot, ZRot, PurgeSprayScale, false, false, false)
end

function CreateVehiclePurgeSpray(Vehicle)
    CreateThread(function()
        local Plate = CurrentVehicleData.Plate
        if Vehicle ~= -1 and Plate ~= nil then
            local Position = GetWorldPositionOfEntityBone(Vehicle, GetEntityBoneIndexByName(Vehicle, 'bonnet'))
            local OffSets = GetOffsetFromEntityGivenWorldCoords(Vehicle, Position.x, Position.y, Position.z)
            if VehicleParticles[Plate] == nil then VehicleParticles[Plate] = {} end
            table.insert(VehicleParticles[Plate], CreateVehicleSpray(Vehicle, OffSets.x - 0.5, OffSets.y + 0.05, OffSets.z, 40.0, -40.0, 0.0))
            table.insert(VehicleParticles[Plate], CreateVehicleSpray(Vehicle, OffSets.x + 0.5, OffSets.y + 0.05, OffSets.z, 40.0, 40.0, 0.0))
        end
    end)
end

function RemoveVehiclePurgeSpray(Vehicle)
    CreateThread(function()
        local Plate = CurrentVehicleData.Plate
        if Vehicle ~= -1 and Plate ~= nil then
            if VehicleParticles[Plate] ~= nil then
                for k, v in pairs(VehicleParticles[Plate]) do
                    StopParticleFxLooped(v, 1)
                end
                VehicleParticles[Plate] = {}
            end
        end
    end)
end

function InitNitrous()
    RequestNamedPtfxAsset('core')
    RequestNamedPtfxAsset('veh_xs_vehicle_mods')

    KeybindsModule.Add('useNitrous', 'Vehicle', 'Use Nitrous', '', false, 'mercy-vehicles/client/nitrous')
    KeybindsModule.Add('setNitrous', 'Vehicle', 'Set Nitrous Usage', '', false, 'mercy-vehicles/client/nitrous-usage')
    KeybindsModule.Add('swapNitrousMode', 'Vehicle', 'Set Nitrous Type', '', false, 'mercy-vehicles/client/nitrous-type')
end