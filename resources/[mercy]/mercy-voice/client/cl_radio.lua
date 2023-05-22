
RadioChannels, IsTalkingOnRadio, RadioVolume, RadioClickVolume, CurrentChannel, CurrentRadioId = {}, false, 0.5, 0.1, nil, 0

-- [ Events ] --

RegisterNetEvent("mercy-voice/client/radio-connect", function(RadioId, Subscribers)
    if RadioChannels[RadioId] then return end

    local Channel = RadioChannel:New(RadioId)
    for _, Subscriber in pairs(Subscribers) do
        Channel:AddSubscriber(Subscriber)
    end

    RadioChannels[RadioId] = Channel
    CurrentRadioId = RadioId

    SetRadioChannel(RadioId)

    if Config.Debug then print( ('[Radio] Connected | ID %s'):format(RadioId) ) end
end)

RegisterNetEvent("mercy-voice/client/radio-disconnect", function(RadioId)
    if not RadioChannels[RadioId] then return end

    CurrentRadioId = 0
    RadioChannels[RadioId] = nil

    if Config.Debug then print( ('[Radio] Disconnected | ID %s'):format(RadioId) ) end
end)

RegisterNetEvent("mercy-voice/client/radio-added", function(RadioId, ServerId)
    if not RadioChannels[RadioId] then return end

    local Channel = RadioChannels[RadioId]

    if not Channel:SubscriberExists(ServerId) then
        Channel:AddSubscriber(ServerId)

        if IsTalkingOnRadio and CurrentChannel.Id == RadioId then
            AddPlayerToTargetList(ServerId, "Radio", true)
        end
        if Config.Debug then print( ('[Radio] Subscriber Added | Radio ID: %s | Player: %s'):format(RadioId, ServerId) ) end
    end
end)

RegisterNetEvent("mercy-voice/client/radio-removed", function(RadioId, ServerId)
    if not RadioChannels[RadioId] then return end

    local Channel = RadioChannels[RadioId]

    if Channel:SubscriberExists(ServerId) then
        Channel:RemoveSubscriber(ServerId)

        if IsTalkingOnRadio and CurrentChannel.Id == RadioId then
            RemovePlayerFromTargetList(ServerId, "Radio", true, true)
        end

        if Config.Debug then print( ('[Radio] Subscriber Added | Radio ID: %s | Player: %s'):format(RadioId, ServerId) ) end
    end
end)

RegisterNetEvent('mercy-hospital/client/on-player-death', function()
    if IsTalkingOnRadio then StopRadioTransmission(true) end
end)

RegisterNetEvent('mercy-preferences/client/update', function(PreferencesData)
    SetRadioVolume((PreferencesData.Voice.RadioVolume + 0.0) / 100)
    RadioClickVolume = (PreferencesData.Voice.RadioClickVolume + 0.0) / 100
end)

-- [ Functions ] --

function SetRadioVolume(Volume)
    if Volume > 0 and Volume < 1.0 then
        RadioVolume = Volume
        UpdateContextVolume("Radio", Volume)
        if Config.Debug then print( ('[Radio] Volume Changed | Current: %s'):format(Volume) ) end
    end
end

function SetRadioChannel(RadioId)
    CurrentChannel = RadioChannels[RadioId]
    if Config.Debug then print( ('[Radio] Channel Changed | Radio ID: %s'):format(RadioId) ) end
end

function StartRadioTransmission()
    local PlayerData = PlayerModule.GetPlayerData()
    if exports['mercy-ui']:IsRadioOn() and CurrentChannel ~= nil and CurrentRadioId > 0 and not PlayerData.MetaData['Dead'] and not PlayerData.MetaData['Handcuffed'] then
        if not IsTalkingOnRadio then
            IsTalkingOnRadio = true
            AddGroupToTargetList(CurrentChannel.Subscribers, "Radio")
            SetPlayerTalkingOverride(PlayerId(), true)
            PlayRadioClick(true)
            StartRadioTask()
            if Config.Debug then print( ('[Radio] Transmission | Sending: %s | Radio ID: %s'):format(IsTalkingOnRadio, CurrentChannel.Id)) end
        end
        if RadioTimeout then
            RadioTimeout:resolve(false)
        end
    end
end

function StopRadioTransmission(Forced)
    local PlayerData = PlayerModule.GetPlayerData()
    if not exports['mercy-ui']:IsRadioOn() or CurrentRadioId <= 0 then return end
    if not (PlayerData.MetaData['Dead'] and not PlayerData.MetaData['Handcuffed']) or Forced then
        if IsTalkingOnRadio or not RadioTimeout then 
            RadioTimeout = TimeOut(300):next(function(Continue)
                RadioTimeout = nil
                if Forced ~= true and not Continue then return end
                IsTalkingOnRadio = false
                RemoveGroupFromTargetList(CurrentChannel.Subscribers, "Radio")
                SetPlayerTalkingOverride(PlayerId(), false)
                PlayRadioClick(false)
                if Config.Debug then print( ('[Radio] Transmission | Sending: %s | Radio ID: %s'):format( IsTalkingOnRadio, CurrentChannel.Id) ) end
            end)
            return RadioTimeout
        end
    end
end

function StartRadioTask()
    Citizen.CreateThread(function()
        FunctionsModule.RequestAnimDict("random@arrests")
        while IsTalkingOnRadio do
            Citizen.Wait(4)
            if not IsEntityPlayingAnim(PlayerPedId(), "random@arrests", "generic_radio_chatter", 3) then
                TaskPlayAnim(PlayerPedId(), "random@arrests", "generic_radio_chatter", 8.0, 0.0, -1, 49, 0, false, false, false)
            end
            for i = 0, 2 do
                SetControlNormal(i, 249, 1.0)
            end
        end
        StopAnimTask(PlayerPedId(), "random@arrests", "generic_radio_chatter", 3.0)
    end)
end

function PlayRadioClick(Bool)
    local Preferences = PreferencesModule.GetPreferences()
    if not Preferences.Voice.RadioClicksOut then return end
    if Bool then
        TriggerEvent('mercy-ui/client/play-sound', 'radio-01-on', RadioClickVolume)
    else
        TriggerEvent('mercy-ui/client/play-sound', 'radio-01-off', RadioClickVolume)
    end
end

function LoadRadio()
    RegisterModuleContext("Radio", 2)
    UpdateContextVolume("Radio", 0.5)
end

exports("TalkingOnRadio", function()
    return IsTalkingOnRadio
end)