PreferencesModule = {
    LoadPreference = function()
        local Preferences = {}

        local KVPValue = GetResourceKvpString("mercy-preferences")
        if KVPValue and KVPValue ~= '[]' then
            Preferences = json.decode(KVPValue)
            LoggerModule.Success("Preferences", "Preferences loaded!")
        end

        for PreferenceId, DefaultValue in pairs(Config.DefaultPreferences) do
            if Preferences[PreferenceId] == nil then
                LoggerModule.Error("Preferences", "No preferences found, setting default for "..PreferenceId.."!")
                Preferences[PreferenceId] = DefaultValue 
            end
            Config.MyPreferences[PreferenceId] = Preferences[PreferenceId]
        end

        SetResourceKvp("mercy-preferences", json.encode(Config.MyPreferences))
        TriggerEvent('mercy-preferences/client/update', Config.MyPreferences)
    end,
    SetPreferenceById = function(Id, Value)
        Config.MyPreferences[Id] = Value
        SetResourceKvp("mercy-preferences", json.encode(Config.MyPreferences))
        TriggerEvent('mercy-preferences/client/update', Config.MyPreferences)
    end,
    GetPreferences = function()
        return Config.MyPreferences
    end,
    GetPreferenceById = function(Id)
        return Config.MyPreferences[Id] or false
    end,
}

AddEventHandler('Modules/client/ready', function()
    exports['mercy-base']:CreateModule("Preferences", PreferencesModule, true)
end)

RegisterNetEvent('mercy-ui/client/preferences/toggle-visibility', function(Visibility)
    exports['mercy-ui']:SendUIMessage("Preferences", "ToggleVisibility", {
        Bool = Visibility,
        Preferences = Config.MyPreferences,
    })
    SetNuiFocus(Visibility, Visibility)
end)

RegisterNetEvent('mercy-ui/client/ui-reset', function()
    TriggerEvent('mercy-ui/client/preferences/toggle-visibility', false)
end)

RegisterNUICallback("Preferences/SavePreferences", function(Data, Cb)
    local Preferences = Config.MyPreferences
    if Preferences == nil then LoggerModule.Error("Preferences/SetPreference", ("Type '%s' does not exist!"):format(Data.Type)) end
    Config.MyPreferences = Data.PreferenceData
    SetResourceKvp("mercy-preferences", json.encode(Config.MyPreferences))
    TriggerEvent('mercy-preferences/client/update', Config.MyPreferences)
    exports['mercy-ui']:Notify("Preferences", "Preferences saved!", "success", 5000)
    Cb('Ok')
end)

RegisterNUICallback("Preferences/ToggleVisibity", function(Data, Cb)
    TriggerEvent("mercy-ui/client/preferences/toggle-visibility", Data.Bool)
    Cb('Ok')
end)

local EmoteBindsControls = {
    { KeyCode = 289, KeyName = 'F2' },
    { KeyCode = 170, KeyName = 'F3' },
    { KeyCode = 166, KeyName = 'F5' },
    { KeyCode = 167, KeyName = 'F6' },
    { KeyCode = 168, KeyName = 'F7' },
    { KeyCode = 56,  KeyName = 'F9' },
    { KeyCode = 57,  KeyName = 'F10' },
    { KeyCode = 344, KeyName = 'F11' },
}

Citizen.CreateThread(function()
    local Cooldown = GetGameTimer()
    while true do
        if LocalPlayer.state.LoggedIn then
            for k, v in pairs(EmoteBindsControls) do
                if Cooldown <= GetGameTimer() then
                    if IsControlJustReleased(0, v.KeyCode) then
                        if #PreferencesModule.GetPreferences().EmoteBinds[v.KeyName] ~= 0 then
                            Cooldown = GetGameTimer() + 3000
                            TriggerEvent('mercy-animations/client/play-animation', PreferencesModule.GetPreferences().EmoteBinds[v.KeyName])
                        end
                    end
                end
            end
        else
            Citizen.Wait(1000)
        end

        Citizen.Wait(4)
    end
end)