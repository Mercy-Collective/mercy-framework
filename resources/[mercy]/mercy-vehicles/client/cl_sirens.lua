local HornSoundId, SirenSoundId = nil, nil

-- [ Threads ] --

CreateThread(function()
    while true do
        Wait(4)
        if LocalPlayer.state.LoggedIn then
            if CurrentVehicleData.Vehicle == nil or not CurrentVehicleData.InVeh then
                Wait(450)
                return 
            end
            if CurrentVehicleData.Class == 18 and CurrentVehicleData.IsDriver then
                DisableControlAction(0, 85, true)
                DisableControlAction(0, 86, true)
            else
                Wait(450)
            end
        else
            Wait(450)
        end
    end
end)

-- [ Events ] --

RegisterNetEvent('mercy-vehicles/client/sirens-horn', function(OnPress)
    local Vehicle = CurrentVehicleData.Vehicle
    if Vehicle == 0 or Vehicle == -1 then return end
    if CurrentVehicleData.Class ~= 18 then return end
    if not CurrentVehicleData.IsDriver then return end
    if OnPress then
        if HornSoundId ~= nil then return end
        HornSoundId = GetSoundId()
        PlaySoundFromEntity(HornSoundId, "SIRENS_AIRHORN", Vehicle, false, true, false)
    else
        if HornSoundId == nil then return end
        StopSound(HornSoundId)
        ReleaseSoundId(HornSoundId)
        HornSoundId = nil
    end
end)

RegisterNetEvent('mercy-vehicles/client/toggle-lights', function(OnPress)
    if not OnPress then return end
    if CurrentVehicleData.InVeh then
        local Vehicle = CurrentVehicleData.Vehicle
        if CurrentVehicleData.Class == 18 and CurrentVehicleData.IsDriver then
            if IsVehicleSirenOn(Vehicle) then
                SetVehicleSiren(Vehicle, false)
                if SirenSoundId ~= nil then
                    StopSound(SirenSoundId)
                    ReleaseSoundId(SirenSoundId)
                    SirenSoundId = nil
                end
            else
                SetVehicleSiren(Vehicle, true)
            end
            SetVehicleHasMutedSirens(Vehicle, true)
            SetVehicleAutoRepairDisabled(Vehicle, true)
            PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
            TriggerServerEvent('mercy-vehicles/server/mute-default-sirens', VehToNet(Vehicle))
        end
    end
end)

RegisterNetEvent('mercy-vehicles/client/toggle-sirens', function(OnPress)
    if not OnPress then return end
    if not CurrentVehicleData.InVeh then return end

    local Vehicle = CurrentVehicleData.Vehicle
    local SirenSound = Shared.Vehicles[GetEntityModel(Vehicle)] ~= nil and Shared.Vehicles[GetEntityModel(Vehicle)]['Siren'] or 'VEHICLES_HORNS_SIREN_1'
    if CurrentVehicleData.Class == 18 and CurrentVehicleData.IsDriver then
        if IsVehicleSirenOn(Vehicle) then
            if SirenSoundId == nil then
                SirenSoundId = GetSoundId()
                PlaySoundFromEntity(SirenSoundId, SirenSound, Vehicle, false, true, false)
            else
                StopSound(SirenSoundId)
                ReleaseSoundId(SirenSoundId)
                SirenSoundId = nil
            end
            PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
        end
    end
end)

RegisterNetEvent('mercy-vehicles/client/mute-default-sirens', function(NetVeh)
    local Vehicle = NetToVeh(NetVeh)
    if Vehicle == 0 or Vehicle == -1 then return end

    SetVehicleAutoRepairDisabled(Vehicle, true)
    SetVehicleHasMutedSirens(Vehicle, true)
end)

-- [ Functions ] --

function InitSirens()
    KeybindsModule.Add('toggleLights', 'Vehicle', 'Toggle Emergency Lights', 'Q', false, 'mercy-vehicles/client/toggle-lights')
    KeybindsModule.Add('toggleSirens', 'Vehicle', 'Toggle Emergency Sirens', 'LCONTROL', false, 'mercy-vehicles/client/toggle-sirens')
end

function CheckForSirenSound(Vehicle)
    if GetVehicleClass(Vehicle) ~= 18 or SirenSoundId == nil then return end

    StopSound(SirenSoundId)
    ReleaseSoundId(SirenSoundId)
    SirenSoundId = nil
end