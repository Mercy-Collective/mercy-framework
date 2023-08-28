-- [ Events ] --

RegisterNetEvent('mercy-ui/client/send-emergency-alert', function(AlertData, ForBoth, SendLocation)
    local Player = PlayerModule.GetPlayerData()
    SendLocation = SendLocation == nil and true or SendLocation
    AlertData.AreaRadius = AlertData.AreaRadius ~= nil and AlertData.AreaRadius or 25.0

    if Player.Job ~= nil and (Player.Job.Name == 'police' or (ForBoth and Player.Job.Name == 'ems')) and Player.Job.Duty then
        if AlertData.AlertArea then AlertData.AlertCoords = vector3(AlertData.AlertCoords.x + math.random(-AlertData.AreaRadius, AlertData.AreaRadius), AlertData.AlertCoords.y + math.random(-AlertData.AreaRadius, AlertData.AreaRadius), AlertData.AlertCoords.z) end
        SendUIMessage('Police', 'SendAlert', {AlertType = AlertData.AlertType, AlertName = AlertData.AlertName, AlertCode = AlertData.AlertCode, AlertId = AlertData.AlertId, AlertTime = AlertData.AlertTime, AlertCoords = AlertData.AlertCoords, AlertItems = AlertData.AlertItems, SendLocation = SendLocation})
        if AlertData.AlertType == 'alert-panic' then
            EventsModule.TriggerServer('mercy-ui/server/play-sound-on-entity', '10-1314', GetPlayerServerId(PlayerId()), 3000, 15.0, nil, true)
        elseif AlertData.AlertType == 'alert-red' then
            EventsModule.TriggerServer('mercy-ui/server/play-sound-on-entity', 'HighPrioCrime', GetPlayerServerId(PlayerId()), 3000, 15.0, nil, true)
        else
            PlaySoundFrontend(-1, "Lose_1st", "GTAO_FM_Events_Soundset", true)
        end
        if SendLocation then
            AddTempBlip(AlertData.AlertId, AlertData.AlertCoords, AlertData.AlertCode..' - '..AlertData.AlertName, AlertData.AlertName, AlertData.AlertArea, AlertData.AreaRadius)
        end
    end
end)

RegisterNetEvent('mercy-ui/client/open-alerts-menu', function(OnPress)
    if not OnPress then return end
    if not LocalPlayer.state.LoggedIn then return end
    if (PlayerModule.GetPlayerData().Job.Name ~= 'police' and PlayerModule.GetPlayerData().Job.Name ~= 'ems') then return end
    if not PlayerModule.GetPlayerData().Job.Duty then return end
    
    SetNuiFocus(true, true)
    SetCursorLocation(0.973, 0.035)
    SendUIMessage('Police', 'OpenDispatch', {})
end)

RegisterNetEvent('mercy-ui/client/ui-reset', function()
    exports['mercy-ui']:SendUIMessage("Police", "CloseDispatch")
end)

-- [ Functions ] --

AddInitialize(function()
    KeybindsModule.Add("alertMenu", 'Services', 'Dispatch Menu', '', false, 'mercy-ui/client/open-alerts-menu')
end)

function AddTempBlip(AlertId, Coords, Text, Icon, Area, Radius)
    local Transition = 250
    local GeneratedBlipSprite = Config.AlertBlip[Icon] ~= nil and Config.AlertBlip[Icon] or 66
    local Blip = nil 
    if Area then Blip = BlipModule.CreateRadiusBlip('alert-'..AlertId, Coords, 1, Radius * 2) else Blip = BlipModule.CreateBlip('alert-'..AlertId, Coords, Text, GeneratedBlipSprite, 1, true, 1.0) end
    while Transition ~= 0 do
        Citizen.Wait(180 * 4)
        Transition = Transition - 1
        SetBlipAlpha(Blip, Transition)
        if Transition == 0 then
            SetBlipSprite(Blip, 2)
            BlipModule.RemoveBlip('alert-'..AlertId)
            return
        end
    end
end

RegisterNUICallback('Police/SetWaypoint', function(Data, Cb)
    SetNewWaypoint(Data.Coords.x, Data.Coords.y)
    PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    exports['mercy-ui']:Notify("police-waypoint", "Waypoint set.", "primary")
    Cb('Ok')
end)

RegisterNUICallback('Police/GetOnDutyPeople', function(Data, Cb)
    local Data = CallbackModule.SendCallback('mercy-ui/server/police/get-duty-people')
    Cb(Data)
end)

RegisterNUICallback('Police/GetDispatchData', function(Data, Cb)
    local Data = CallbackModule.SendCallback('mercy-ui/server/police/get-dispatch-data')
    local DispatchData = {
        VehTypes = Config.VehicleOperatingType,
        Data = Data,
    }
    Cb(DispatchData)
end)

RegisterNUICallback('Police/SetDispatchData', function(Data, Cb)
    
end)

RegisterNUICallback('Police/CloseDispatch', function(Data, Cb)
    SetNuiFocus(false, false)
    Cb('Ok')
end)