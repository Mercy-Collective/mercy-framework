local HudInitialized, IsInVehicle, IsVehicleAircraft, HasCompass = false, false, false, false

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        if LocalPlayer.state.LoggedIn and not IsInVehicle then
            if (not HasCompass) and exports['mercy-inventory']:HasEnoughOfItem('pdwatch', 1) then
                HasCompass = true
                StartCompass()
                DisplayRadar(true)
            elseif HasCompass and (not exports['mercy-inventory']:HasEnoughOfItem('pdwatch', 1)) then
                HasCompass = false
                exports['mercy-ui']:SendUIMessage('Hud', 'SetCompassVisibility', {
                    Visible = false,
                })
                DisplayRadar(false)
            end
            Citizen.Wait(3000)
        else
            Citizen.Wait(1000)
        end
    end
end)

-- Stress

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            local Stress = Config.HudValues['Stress']['Value']
            local WaitTime = 50000 -- 50 Seconds
            if Stress ~= nil then
                if Stress >= 5 and Stress <= 25 then
                    WaitTime = 30000
                elseif Stress > 25 and Stress <= 45 then
                    WaitTime = 25000
                elseif Stress > 45 and Stress <= 65 then
                    WaitTime = 12500
                elseif Stress > 65 and Stress <= 85 then
                    WaitTime = 8500
                elseif Stress > 85 and Stress <= 100 then
                    WaitTime = 5500
                end
                if Stress >= 5 then
                    TriggerScreenblurFadeIn(1000.0)
                    Citizen.Wait(1100)
                    TriggerScreenblurFadeOut(1000.0)
                end
            end
            Citizen.Wait(WaitTime)
        else
            Citizen.Wait(450)
        end
    end
end)

RegisterCommand('removeblur', function()
    TriggerScreenblurFadeOut(1000.0)
end)

-- [ Events ] --

AddInitialize(function()
    SendUIMessage('Hud', 'InitializeHud', Config.HudValues)
    Citizen.SetTimeout(1000, function()
        RequestHudValues()
        HudInitialized = true
    end)
end)

RegisterNetEvent('mercy-ui/client/ui-reset', function()
    PreferencesModule.LoadPreference()
    SendUIMessage('Hud', 'SetAppVisiblity', {
        Visible = false,
    })
    CallbackModule.CreateCallback("mercy-preferences/client/get-preferences", function(Cb)
        Cb(PreferencesModule.GetPreferences())
    end)
    Citizen.SetTimeout(3250, function()
        SendUIMessage('Hud', 'SetAppVisiblity', {
            Visible = true,
        })
        if KeybindsModule.GetCustomizedKey("eyePeek") ~= 'L Alt' then
            exports['mercy-ui']:Notify("eye-error", "You've re-binded the peeking functionality, this WILL result in broken or poor functionality! (Default: Left Alt)", "error", 10000)
        end
    end)
    RequestHudValues()
end)

RegisterNetEvent("mercy-threads/exited-underwater", function() 
    SetAudioSubmixEffectRadioFx(0, 0)
    SetAudioSubmixEffectParamInt(0, 0, GetHashKey('enabled'), 0) 
    TriggerEvent('mercy-ui/client/set-hud-values', 'Oxy', 'Value', 0)
    TriggerEvent('mercy-ui/client/set-hud-values', 'Oxy', 'Show', false)
end)

RegisterNetEvent("mercy-threads/entered-underwater", function() 
    SetAudioSubmixEffectRadioFx(0, 0)
    SetAudioSubmixEffectParamInt(0, 0, GetHashKey('enabled'), 1)
    TriggerEvent('mercy-ui/client/set-hud-values', 'Oxy', 'Show', true)
    TriggerEvent('mercy-ui/client/set-hud-values', 'Oxy', 'Value', GetPlayerUnderwaterTimeRemaining(PlayerId()))

end)

RegisterNetEvent('mercy-ui/client/show-cash', function()
    SendUIMessage('Hud', 'ShowCurrentCash', PlayerModule.GetPlayerData().Money['Cash'])
end)

RegisterNetEvent("mercy-ui/client/money-change", function(Type, Amount, TotalBalance)
    SendUIMessage('Hud', 'ShowChangeMoney', {Type = Type, Amount = Amount, Cash = TotalBalance})
end)

RegisterNetEvent("mercy-threads/stopped-talking", function()
    SendUIMessage('Hud', 'ToggleComponentActive', {Type = 'Voice', Bool = false})
end)

RegisterNetEvent("mercy-threads/started-talking", function()
    if not exports['mercy-voice'] or exports['mercy-voice']:TalkingOnRadio() == nil then
        return print('Tried to enable voice hud component but mercy-voice export was not found.')
    end
    SendUIMessage('Hud', 'ToggleComponentActive', {Type = 'Voice', Bool = true, OnRadio = exports['mercy-voice']:TalkingOnRadio()})
end)

RegisterNetEvent("mercy-threads/on-change/GetPedArmour", function(Value)
    TriggerEvent('mercy-ui/client/set-hud-values', 'Armor', 'Value',  Value)
end)

RegisterNetEvent("mercy-threads/on-change/GetEntityHealth", function(Value)
    TriggerEvent('mercy-ui/client/set-hud-values', 'Health', 'Value',  Value)
end)

RegisterNetEvent("mercy-threads/on-change/GetPlayerFood", function(Value)
    TriggerEvent('mercy-ui/client/set-hud-values', 'Food', 'Value',  Value)
end)

RegisterNetEvent("mercy-threads/on-change/GetPlayerWater", function(Value)
    TriggerEvent('mercy-ui/client/set-hud-values', 'Water', 'Value',  Value)
end)

RegisterNetEvent("mercy-threads/on-change/GetPlayerStress", function(Value)
    TriggerEvent('mercy-ui/client/set-hud-values', 'Stress', 'Value',  Value)
end)

RegisterNetEvent("mercy-threads/on-change/GetPlayerUnderwaterTimeRemaining", function(Value)
    TriggerEvent('mercy-ui/client/set-hud-values', 'Oxy', 'Value',  Value)
end)

-- [ Events ] --

RegisterNetEvent('mercy-ui/client/set-hud-values', function(Type, SubType, Data)
    if not LocalPlayer.state.LoggedIn then return end
    if HudInitialized then
        if Config.HudValues[Type] ~= nil and Config.HudValues[Type][SubType] ~= nil then
            Config.HudValues[Type][SubType] = Data
            if SubType == 'Value' and Type ~= 'Water' and Type ~= 'Food' and Type ~= 'Oxy' then
                if type(Data) == 'number' then
                    if Data <= 0 and Config.HudValues[Type].Show then
                        Config.HudValues[Type].Show = false
                    elseif Data > 0 and not Config.HudValues[Type].Show then
                        Config.HudValues[Type].Show = true
                    end
                end
            end
        end
        Config.HudValues['Voice'].OnRadio = exports['mercy-ui']:RadioConnected()
        Config.HudValues['Health'].IsDead = exports['mercy-hospital']:IsDead()
        SendUIMessage('Hud', 'SetComponentValues', Config.HudValues)
        SendUIMessage('Hud', 'ToggleComponentVisibility', Config.HudValues)
    end
end)

RegisterNetEvent('mercy-ui/client/update-radio-values', function()
    Config.HudValues['Voice'].OnRadio = exports['mercy-ui']:RadioConnected()
    Config.HudValues['Health'].IsDead = exports['mercy-hospital']:IsDead()
    SendUIMessage('Hud', 'SetComponentValues', Config.HudValues)
end)

RegisterNetEvent("mercy-threads/entered-vehicle", function() 
    local Vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
    local WaypointDistance = nil; 
    if IsWaypointActive() then 
        WaypointDistance = (#(GetEntityCoords(PlayerPedId()) - GetBlipCoords(GetFirstBlipInfoId(8))) / 1000) 
    end
    IsInVehicle = true

    -- Fuel Alert
    Citizen.CreateThread(function()
        while IsInVehicle and not IsThisModelABicycle(GetEntityModel(Vehicle))  do
            local FuelLevel = exports['mercy-vehicles']:GetVehicleMeta(Vehicle, 'Fuel')
            local IsElectric = exports['mercy-vehicles']:IsElectricVehicle(Vehicle)
            if FuelLevel > 0 and FuelLevel <= 10 then
                exports['mercy-ui']:Notify("hud-fuel", (IsElectric and "Battery" or "Fuel") .." low.", "error")
                PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1) Citizen.Wait(200)
                PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1) Citizen.Wait(200)
                PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
            end
            Citizen.Wait(15000)
        end
    end)

    -- Update veh
    Citizen.CreateThread(function()
        local ShowingVehicleHud = false
        while IsInVehicle do
            if GetIsVehicleEngineRunning(Vehicle) then
                if not ShowingVehicleHud then
                    local Preferences = PreferencesModule.GetPreferences()
                    if not Preferences.Hud.Compass then return end
                    if not HasCompass then
                        HasCompass = true
                        StartCompass()
                    end
                    ShowingVehicleHud = true
                    DisplayRadar(ShowingVehicleHud)
                    exports['mercy-ui']:SendUIMessage('Hud', 'SetVehicleHud', {Bool = ShowingVehicleHud, Aircraft = IsPedInAnyHeli(PlayerPedId()) or IsPedInAnyPlane(PlayerPedId()), Waypoint = WaypointDistance ~= nil and WaypointDistance or 0})
                end
                
                local Plate, VehicleClass, HasBelt = GetVehicleNumberPlateText(Vehicle), GetVehicleClass(Vehicle), exports['mercy-vehicles']:GetBeltStatus()
                local SpeedValue = GetEntitySpeed(Vehicle)
                local WaypointDistance = nil; 
                if IsWaypointActive() then WaypointDistance = (#(GetEntityCoords(PlayerPedId()) - GetBlipCoords(GetFirstBlipInfoId(8))) / 1000) end
                local RPM = GetVehicleCurrentRpm(Vehicle); if RPM - 0.2 > 0.0 then RPM = RPM - 0.2 end

                if VehicleClass == 13 or VehicleClass == 8 or GetEntityModel(Vehicle) == GetHashKey('polbike') then HasBelt = true end
                exports['mercy-ui']:SendUIMessage('Hud', 'UpdateVehicleHud', {
                    Speed = GetVehicleCurrentRpm(Vehicle),
                    -- RPM = RPM, -- Todo
                    Mph = math.ceil(SpeedValue * 2.236936),
                    Fuel = exports['mercy-vehicles']:GetVehicleMeta(Vehicle, 'Fuel'),
                    Belt = HasBelt,
                    IsAircraft = IsPedInAnyHeli(PlayerPedId()) or IsPedInAnyPlane(PlayerPedId()),
                    Altitude = math.floor(GetEntityHeightAboveGround(Vehicle) * 2.28084),
                    -- BrokenEngine = GetVehicleEngineHealth(Vehicle) < 400.0, -- Todo: Add
                    Waypoint = WaypointDistance ~= nil and WaypointDistance or 0,
                })

                TriggerEvent('mercy-ui/client/set-hud-values', 'Nos', 'Value', exports['mercy-vehicles']:GetVehicleMeta(Vehicle, 'Nitrous'))
                TriggerEvent('mercy-ui/client/set-hud-values', 'Harness', 'Value', exports['mercy-vehicles']:GetVehicleMeta(Vehicle, 'Harness'))
            else
                if ShowingVehicleHud then
                    HasCompass = false
                    ShowingVehicleHud = false
                    exports['mercy-ui']:SendUIMessage('Hud', 'SetVehicleHud', {Bool = ShowingVehicleHud})
                    DisplayRadar(ShowingVehicleHud)
                end
                Citizen.Wait(250)
            end

            Citizen.Wait(75)
        end
    end)
end)

RegisterNetEvent("mercy-threads/exited-vehicle", function() 
    IsInVehicle = false
    if (not exports['mercy-inventory']:HasEnoughOfItem('pdwatch', 1)) then
        HasCompass = false
        exports['mercy-ui']:SendUIMessage('Hud', 'SetCompassVisibility', {
            Visible = false,
        })
    end

    local Vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
    exports['mercy-ui']:SendUIMessage('Hud', 'SetVehicleHud', {Bool = false})
    TriggerEvent('mercy-ui/client/set-hud-values', 'Nos', 'Value', 0)
    TriggerEvent('mercy-ui/client/set-hud-values', 'Harness', 'Value', 0)
    DisplayRadar(false)
end)

RegisterNetEvent('mercy-preferences/client/update', function(PreferencesData)
    if not exports['mercy-inventory'] then return end
    exports['mercy-ui']:SendUIMessage('Hud', 'SetHudPreferences', {
        Prefs = PreferencesData.Hud,
        Values = Config.HudValues,
        InCar = GetVehiclePedIsIn(PlayerPedId()) ~= 0,
        HasWatch = exports['mercy-inventory']:HasEnoughOfItem('pdwatch', 1),
    })
end)

-- [ Functions ] --

function RequestHudValues()
    local ValuesData = ThreadsModule.GetAllValues()
    Citizen.SetTimeout(250, function()
        TriggerEvent('mercy-ui/client/set-hud-values', 'Health', 'Value',  ValuesData['Health'])
        TriggerEvent('mercy-ui/client/set-hud-values', 'Armor', 'Value',  ValuesData['Armor'])
        TriggerEvent('mercy-ui/client/set-hud-values', 'Food', 'Value',  ValuesData['Food'])
        TriggerEvent('mercy-ui/client/set-hud-values', 'Water', 'Value',  ValuesData['Water'])
        TriggerEvent('mercy-ui/client/set-hud-values', 'Stress', 'Value',  ValuesData['Stress'])
    end)
end

function StartCompass()
    if not HasCompass then return end

    exports['mercy-ui']:SendUIMessage('Hud', 'SetCompassVisibility', {
        Visible = true,
    })

    Citizen.CreateThread(function()
        local LastUpdate = GetGameTimer()
        local StreetLocation = ''
        local Area = ''

        while HasCompass do
            Citizen.Wait(10)

            if GetGameTimer() > LastUpdate then
                LastUpdate = GetGameTimer() + 500

                local Pos = GetEntityCoords(PlayerPedId(), true)
                local StreetHash, IntersectionHash = GetStreetNameAtCoord(Pos.x, Pos.y, Pos.z, StreetHash, IntersectionHash)
                local StreetName = GetStreetNameFromHashKey(StreetHash)
                local IntersectionName = GetStreetNameFromHashKey(IntersectionHash)
                local Zone = tostring(GetNameOfZone(Pos))
                Area = GetLabelText(Zone)
    
                if IntersectionName ~= nil and IntersectionName ~= "" then
                    StreetLocation = StreetName .. " [" .. IntersectionName .. "]"
                elseif StreetName ~= nil and StreetName ~= "" then
                    StreetLocation = StreetName
                else
                    StreetLocation = ""
                end
            end

            exports['mercy-ui']:SendUIMessage('Hud', 'SetCompassDirection', {
                Direction = math.floor(-GetFinalRenderedCamRot(0).z % 360),
                Street = StreetLocation,
                Area = Area,
            })
        end
    end)
end