local InVehicle, SirenSoundId, HornSoundId = false, nil, nil

function CanUseEmergencyLights(IsPressed)
    if not IsPressed then
        return false
    end

    if not InVehicle then
        return false
    end

    local Vehicle = GetVehiclePedIsIn(PlayerPedId())
    if GetVehicleClass(Vehicle) ~= 18 and not IsGovVehicle(Vehicle) then
        return false
    end

    return GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId()
end

function SetSirenCycle(Vehicle, Cycle)
    local SirenSound = Config.SirenData[GetEntityModel(Vehicle)].SirenSounds[Cycle]
    if not SirenSound then
        return exports['mercy-ui']:Notify("no-siren", "This vehicle does not have this siren tone..", "error")
    end

    if IsVehicleSirenOn(Vehicle) then
        if SirenSoundId then
            StopSound(SirenSoundId)
            ReleaseSoundId(SirenSoundId)
            SirenSoundId = nil
        end
    
        SirenSoundId = GetSoundId()
        PlaySoundFromEntity(SirenSoundId, SirenSound, Vehicle, false, true, false)
        PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    end
end

function UsesCustomHorn(Vehicle)
    for Veh, Sound in pairs(Config.CustomHorns) do
        if GetEntityModel(Vehicle) == GetHashKey(Veh) then
            return true, Sound
        end
    end
    return false
end

function InitSirens()
    KeybindsModule.Add('toggleLights', 'Vehicle', 'Toggle Emergency Lights', 'Q', function(IsPressed)
        if not CanUseEmergencyLights(IsPressed) then
            return
        end
    
        local Vehicle = GetVehiclePedIsIn(PlayerPedId())
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
        TriggerServerEvent('mercy-vehicles/server/mute-sirens', NetworkGetNetworkIdFromEntity(Vehicle))
    end)

    KeybindsModule.Add('toggleSirens', 'Vehicle', 'Toggle Emergency Sirens', '', function(IsPressed)
        if not CanUseEmergencyLights(IsPressed) then
            return
        end
    
        local Vehicle = GetVehiclePedIsIn(PlayerPedId())
        local SirenSound = Config.SirenData[GetEntityModel(Vehicle)] and Config.SirenData[GetEntityModel(Vehicle)].SirenSounds[1] or 'VEHICLES_HORNS_SIREN_1'
        
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
    end)

    KeybindsModule.Add('primaryTone', 'Vehicle', 'Primary Siren Tone', '', function(IsPressed)
        if not CanUseEmergencyLights(IsPressed) then
            return
        end
    
        local Vehicle = GetVehiclePedIsIn(PlayerPedId())
        SetSirenCycle(Vehicle, 1)
    end)

    KeybindsModule.Add('secondaryTone', 'Vehicle', 'Secondary Siren Tone', '', function(IsPressed)
        if not CanUseEmergencyLights(IsPressed) then
            return
        end
    
        local Vehicle = GetVehiclePedIsIn(PlayerPedId())
        SetSirenCycle(Vehicle, 2)
    end)

    KeybindsModule.Add('thirdTone', 'Vehicle', 'Third Siren Tone', '', function(IsPressed)
        if not CanUseEmergencyLights(IsPressed) then
            return
        end
    
        local Vehicle = GetVehiclePedIsIn(PlayerPedId())
        SetSirenCycle(Vehicle, 3)
    end)
end

RegisterNetEvent("mercy-threads/entered-vehicle", function()
    local Vehicle = GetVehiclePedIsIn(PlayerPedId())
    if GetVehicleClass(Vehicle) ~= 18 and not IsGovVehicle(Vehicle) then return end
    if Config.SirenData[GetEntityModel(Vehicle)] == nil then return end

    InVehicle = true

    Citizen.CreateThread(function()
        while InVehicle do
            DisableControlAction(0, 85, true)
            DisableControlAction(0, 86, true)

            if IsDisabledControlJustPressed(0, 86) then
                local Vehicle = GetVehiclePedIsIn(PlayerPedId())
                if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() then
                    if HornSoundId == nil then
                        local IsCustom, Sound = UsesCustomHorn(Vehicle)
                        if IsCustom then
                            HornSoundId = GetSoundId()
                            PlaySoundFromEntity(HornSoundId, Sound, Vehicle, false, true, false)
                        else
                            HornSoundId = GetSoundId()
                            PlaySoundFromEntity(HornSoundId, "SIRENS_AIRHORN", Vehicle, false, true, false)
                        end
                    end
                end
            end

            if IsDisabledControlJustReleased(0, 86) then
                local Vehicle = GetVehiclePedIsIn(PlayerPedId())
                if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() then
                    if HornSoundId ~= nil then
                        StopSound(HornSoundId)
                        ReleaseSoundId(HornSoundId)
                        HornSoundId = nil
                    end
                end
            end

            Citizen.Wait(4)
        end
    end)
end)

RegisterNetEvent("mercy-threads/exited-vehicle", function()
    InVehicle = false
end)

RegisterNetEvent("mercy-vehicles/client/mute-sirens", function(NetVeh)
    local Vehicle = NetworkGetEntityFromNetworkId(NetVeh)
    if Vehicle == 0 or Vehicle == -1 then return end

    SetVehicleAutoRepairDisabled(Vehicle, true)
    SetVehicleHasMutedSirens(Vehicle, true)
end)

RegisterNetEvent("onPlayerJoining", function(ServerId)
    Citizen.Wait(100)
    local Ped = GetPlayerPed(GetPlayerFromServerId(ServerId))
    if Ped == 0 or Ped == -1 then return end

    local Vehicle = GetVehiclePedIsIn(Ped, false)
    if Vehicle == 0 or Vehicle == -1 then return end

    if not IsGovVehicle(Vehicle) then return end

    SetVehicleHasMutedSirens(Vehicle, true)
    SetVehicleAutoRepairDisabled(Vehicle, true)
end)