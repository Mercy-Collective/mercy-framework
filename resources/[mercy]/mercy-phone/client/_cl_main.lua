LoggerModule, FunctionsModule, EventsModule, KeybindsModule, CallbackModule, PlayerModule, BlipModule, PreferencesModule = nil, nil, nil, nil, nil, nil, nil, nil
_Ready, InPhone, InCamera, CurrentApp = false, false, false, 'home'
Phone = {}

AddEventHandler('Modules/client/ready', function()
    if not _Ready then
        _Ready = true
    end

    TriggerEvent('Modules/client/request-dependencies', {
        'Logger',
        'Functions',
        'Events',
        'Keybinds',
        'Callback',
        'Player',
        'BlipManager',
        'Preferences',
    }, function(Succeeded)
        if not Succeeded then return end

        LoggerModule = exports['mercy-base']:FetchModule("Logger")
        FunctionsModule = exports['mercy-base']:FetchModule("Functions")
        EventsModule = exports['mercy-base']:FetchModule("Events")
        KeybindsModule = exports['mercy-base']:FetchModule("Keybinds")
        CallbackModule = exports['mercy-base']:FetchModule("Callback")
        PlayerModule = exports['mercy-base']:FetchModule("Player")
        BlipModule = exports['mercy-base']:FetchModule("BlipManager")
        PreferencesModule = exports['mercy-base']:FetchModule("Preferences")
        Network.Ready()

        KeybindsModule.DisableControlAction(0, 199, true)
        CreateDependencies()
    end)
end)

RegisterNetEvent('mercy-base/client/on-login', function()
    Citizen.SetTimeout(350, function()
        exports['mercy-ui']:SendUIMessage('Phone', "SetPhoneNetwork", { Id = "None" })

        Contacts.InitKeybinds()
        Housing.OnPlayerLoad()

        local Tweets = CallbackModule.SendCallback("mercy-phone/server/twitter/get-tweets")
        local Posts = CallbackModule.SendCallback("mercy-phone/server/adverts/get-posts")
        local ContactsData = CallbackModule.SendCallback("mercy-phone/server/contacts/get-contacts")
        local Jobs = CallbackModule.SendCallback("mercy-phone/server/jobcenter/get-jobs")
        local FilteredJobs = FilterJobs(Jobs)

        Twitter.Tweets = Tweets ~= nil and Tweets or {}
        Adverts.Posts = Posts
        Contacts.Contacts = ContactsData
        JobCenter.Jobs = FilteredJobs

        exports['mercy-ui']:SendUIMessage("Phone", "SetPhonePlayerData", GetPhonePlayerData())
    end)
end)

RegisterNetEvent('mercy-ui/client/ui-reset', function()
    if InPhone then
        ClosePhone()
    end
end)

-- [ Code ] --

-- [ Functions ] --

function Phone.DoAnim(Hold, Call, Cancel)
    if Cancel then
        exports['mercy-assets']:RemoveProps("Phone")
        if IsEntityPlayingAnim(PlayerPedId(), "cellphone@", "cellphone_text_to_call", 3) then
            StopAnimTask(PlayerPedId(), "cellphone@", "cellphone_text_to_call", 1.0)
        else
            StopAnimTask(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 1.0)
        end
    elseif Hold then
        exports['mercy-assets']:AttachProp("Phone")
        FunctionsModule.RequestAnimDict("cellphone@")
        TaskPlayAnim(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 2.0, 3.0, -1, 49, 0, 0, 0, 0)
    elseif Call then
        exports['mercy-assets']:AttachProp("Phone")
        FunctionsModule.RequestAnimDict("cellphone@")
        Citizen.CreateThread(function() 
            while Contacts.CallId ~= nil do
                if not InPhone and not IsEntityPlayingAnim(PlayerPedId(), "cellphone@", "cellphone_text_to_call", 3) then
                    TaskPlayAnim(PlayerPedId(), "cellphone@", "cellphone_text_to_call", 3.0, -1, -1, 50, 0, false, false, false)
                end
                Citizen.Wait(3000)
            end
    
            exports['mercy-assets']:RemoveProps("Phone")
        end)
    end
end

function CreateDependencies()
    KeybindsModule.Add('openPhone', 'General', 'Phone', 'M', OpenPhone)
end

function OpenPhone(IsPressed)
    if not IsPressed then return end
    if not LocalPlayer.state.LoggedIn then return end
    if not exports['mercy-inventory']:HasEnoughOfItem('phone', 1) then return end
    local PlayerData = PlayerModule.GetPlayerData()
    
    if PlayerData.MetaData['Dead'] or PlayerData.MetaData['Handcuffed'] then return end

    InPhone = true
    exports['mercy-ui']:SetNuiFocus(true, true)
    exports['mercy-ui']:SendUIMessage("Phone", "SetPhonePlayerData", GetPhonePlayerData())
    exports['mercy-ui']:SendUIMessage('Phone', 'TogglePhone', {
        Open = true,
        HasVPN = exports['mercy-inventory']:HasEnoughOfItem('vpn', 1) or exports['mercy-inventory']:HasEnoughOfItem('darkmarketdeliveries', 1)
    })
    Phone.DoAnim(true, false, false)
end

function ClosePhone()
    Messages.Active = false
    exports['mercy-ui']:SetNuiFocus(false, false)
    exports['mercy-ui']:SendUIMessage('Phone', 'TogglePhone', { Open = false })
    if Contacts.CallId ~= nil then
        Phone.DoAnim(false, true, false)
    else
        Phone.DoAnim(false, false, true)
    end

    InPhone = false
end

function SetAppUnread(App, State)
    exports['mercy-ui']:SendUIMessage("Phone", "SetAppUnread", {
        App = App,
        State = State ~= nil and State or false
    })
end

function GetPhonePlayerData()
    local PlayerData = PlayerModule.GetPlayerData()
    local Retval = {}

    Retval.CharInfo = {}
    Retval.CharInfo.PhoneNumber = PlayerData.CharInfo.PhoneNumber
    Retval.CitizenId = PlayerData.CitizenId
    Retval.Source = PlayerData.Source

    return Retval
end

-- [ Events ] --

RegisterNetEvent('mercy-phone/client/open-phone', OpenPhone)
RegisterNetEvent('mercy-phone/client/close-phone', ClosePhone)
RegisterNetEvent('mercy-phone/client/do-anim', function(Hold, Call, Cancel)
    if Hold ~= 'InPhone' then Phone.DoAnim(Hold, Call, Cancel) return end

    if InPhone then
        Phone.DoAnim(true, false, false)
    else
        Phone.DoAnim(false, false, true)
    end
end)

RegisterNetEvent('mercy-phone/client/notification', function(Data)
    if not LocalPlayer.state.LoggedIn then return end
    if exports['mercy-inventory']:HasEnoughOfItem('phone', 1) then
        local Preferences = PreferencesModule.GetPreferences()
        if Data.Icon == "fab fa-twitter" and not Preferences.Phone.Notifications.Tweet then return end
        if Data.Icon == "fas fa-comment" and not Preferences.Phone.Notifications.SMS then return end
        if Data.Icon == "fas fa-envelope-open" and not Preferences.Phone.Notifications.Email then return end
        exports['mercy-ui']:SendUIMessage('Phone', 'Notification', Data)
    end
end)

RegisterNetEvent('mercy-phone/client/hide-notification', function(NotificationId)
    exports['mercy-ui']:SendUIMessage('Phone', 'HideNotification', NotificationId)
end)

RegisterNetEvent('mercy-phone/client/set-notification-text', function(NotificationId, Text)
    exports['mercy-ui']:SendUIMessage('Phone', 'SetNotificationText', {
        NotificationId = NotificationId,
        Text = Text
    })
end)

RegisterNetEvent('mercy-phone/client/set-notification-buttons', function(NotificationId, Buttons)
    exports['mercy-ui']:SendUIMessage('Phone', 'SetNotificationButtons', {
        NotificationId = NotificationId,
        Buttons = Buttons
    })
end)

RegisterNetEvent('mercy-preferences/client/update', function(PreferencesData)
    if next(PreferencesData) == nil then return print("Preferences is empty") end
    exports['mercy-ui']:SendUIMessage("Phone", "SetPhonePreferences", {
        Preferences = PreferencesData.Phone,
    })
end)

RegisterNetEvent('mercy-inventory/client/update-player', function()
    Citizen.SetTimeout(100, function()
        if not exports['mercy-inventory']:HasEnoughOfItem('phone', 1) then
            TriggerEvent('mercy-phone/client/close-phone')
            TriggerEvent('mercy-phone/client/call-force-disconnect')
        end
    end)
end)

-- NUI Callbacks

RegisterNUICallback("Notifications/ButtonClick", function(Data, Cb)
    if Data.EventType:lower() == 'client' then
        TriggerEvent(Data.Event, json.decode(Data.Data))
    else
        TriggerServerEvent(Data.Event, json.decode(Data.Data))
    end
    Cb('Ok')
end)

RegisterNUICallback("ClosePhone", function(Data, Cb)
    ClosePhone()
    Cb('Ok')
end)

RegisterNUICallback("AppClick", function(Data, Cb)
    local App = Data.App:lower()
    CurrentApp = App
    if App ~= 'messages' or App == 'Home' then
        Messages.Active = false 
    end
    if App == 'details' then
        Details.Render()
    elseif App == 'contacts' then
        Contacts.Render()
    elseif App == 'calls' then
        Calls.Render()
    elseif App == 'messages' then
        Messages.Render()
    elseif App == 'pinger' then
        Pinger.Render()
    elseif App == 'mails' then
        Mails.Render()
    elseif App == 'advert' then
        Adverts.Render()
    elseif App == 'twitter' then
        Twitter.Render()
    elseif App == 'garage' then
        Garage.Render()
    elseif App == 'debt' then
        Debt.Render()
    elseif App == 'documents' then
        Documents.Render()
    elseif App == 'housing' then
        Housing.Render()
    elseif App == 'crypto' then
        Crypto.Render()
    elseif App == 'jobcenter' then
        JobCenter.Render()
    elseif App == 'employment' then
        Employment.Render()
    -- elseif App == 'sportsback' then
        -- SportsBack.Render()
    elseif App == 'dark' then
        Dark.Render()
    elseif App == 'calculator' then
        Calculator.Render()
    elseif App == 'cameras' then
        Cameras.Render()
    end
    
    Cb('Ok')
end)

RegisterNUICallback("SelfieMode", function(Data, Cb)
    ClosePhone()
    InCamera = true

    DestroyMobilePhone()
    Citizen.Wait(0) -- dunno why, but if it doesn't wait, it doesn't work?
    CreateMobilePhone(0)
    CellCamActivate(true, true)
    CellCamDisableThisFrame(true)

    Citizen.CreateThread(function()
        while InCamera do
            if IsControlJustPressed(0, 177) then
                InCamera = false
                
                DestroyMobilePhone()
                Citizen.Wait(0) -- dunno why, but if it doesn't wait, it doesn't work?
                CellCamDisableThisFrame(false)
                CellCamActivate(false, false)
            end
            
            Citizen.Wait(0)
        end
    end)

    -- Little workaround, because disabling the 199 and 200 key does not work (199 = P / 200 = ESC (pause menu alternate))
    local DisablePause = true
    Citizen.CreateThread(function()
        while DisablePause do
            SetPauseMenuActive(false)
            
            if IsControlJustPressed(0, 177) then
                Citizen.SetTimeout(500, function()
                    DisablePause = false
                end)
            end
            
            Citizen.Wait(0)
        end
    end)

    Cb('Ok')
end)

-- Loops

Citizen.CreateThread(function()
    while true do
        if LocalPlayer.state.LoggedIn and InPhone then
            local Hour, Minutes = exports['mercy-weathersync']:GetCurrentTime()
            exports['mercy-ui']:SendUIMessage("Phone", "SetPhoneTime", (Hour <= 9 and "0" .. Hour or Hour) .. ':' .. (Minutes <= 9 and "0" .. Minutes or Minutes))
        else
            Citizen.Wait(1000)
        end

        Citizen.Wait(2000)
    end
end)