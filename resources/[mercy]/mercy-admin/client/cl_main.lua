Group, FunctionsModule, CallbackModule, EventsModule, PlayerModule, VehicleModule, KeybindsModule, BlipModule = nil, nil, nil, nil, nil, nil, nil
DevMode = false

AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
        'Functions',
        'Callback',
        'Events',
        'Player',
        'Vehicle',
        'Keybinds',
        'BlipManager',
    }, function(Succeeded)
        if not Succeeded then return end

        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        VehicleModule = exports['mercy-base']:FetchModule('Vehicle')
        KeybindsModule = exports['mercy-base']:FetchModule('Keybinds')
        BlipModule = exports['mercy-base']:FetchModule('BlipManager')
    end)
end)


RegisterNetEvent('mercy-base/client/on-login', function()
    Group = CallbackModule.SendCallback('mc-adminmenu/server/get-permission')
    Citizen.Wait(500)
    InitAdminMenu()
    -- exports[GetCurrentResourceName()]:CreateLog('Logged In', 'Player Logged In')
end)

RegisterNetEvent('mercy-base/client/on-logout', function()
    Group = CallbackModule.SendCallback('mc-adminmenu/server/get-permission')
    -- exports[GetCurrentResourceName()]:CreateLog('Logged Out', 'Player Logged Out')
end)

-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('mc-admin/client/try-open-menu', function(IsPressed)
    if not IsPressed then return end
    if not LocalPlayer.state.LoggedIn then return end
    if not PlayerModule.IsPlayerAdmin() then return end
    if not CanBind() then return end 
    ToggleMenu(false)
end)

RegisterNetEvent("mc-admin/client/reset-menu", function()
    if not PlayerModule.IsPlayerAdmin() then return end
    ResetMenuKvp()
    TriggerEvent('mc-admin/client/force-close')
end)

RegisterNetEvent("mc-admin/client/force-close", function()
    SendNUIMessage({ Action = 'Close', })
end)

RegisterNetEvent("mc-admin/client/toggle-debug", function()
    if not PlayerModule.IsPlayerAdmin() then return end
    Config.Settings['Debug'] = not Config.Settings['Debug']
    local Msg = Config.Settings['Debug'] and Lang:t('commands.enabled') or Lang:t('commands.disabled')
    local EnabledType = Config.Settings['Debug'] and 'success' or 'error'
    exports['mercy-ui']:Notify("debug-toggled", 'Debug '..Msg, EnabledType)
end)

RegisterNetEvent("mercy-admin/client/toggle-devmode", function(Bool)
    DevMode = Bool
    TriggerEvent('mercy-ui/client/set-hud-values', 'DevMode', 'Show', Bool)
end)

RegisterNetEvent("mercy-admin/client/toggle-noclip", function(IsPressed)
    if not IsPressed then return end
    if not DevMode then return end
    if not PlayerModule.IsPlayerAdmin() then return end
    SendNUIMessage({
        Action = "SetItemEnabled",
        Name = 'noclip',
        State = not noClipEnabled
    })
    toggleFreecam(not noClipEnabled)
end)

RegisterNetEvent("mc-admin/client/do-perms-action", function(Action, CommandId, Group)
    DoPermsAction(Action, CommandId, Group)
end)

-- [ NUI Callbacks ] --

RegisterNUICallback('ToggleKVP', function(Data, Cb)
    SetKvp(Data.Type, Data.Id, Data.Toggle)
    Cb('Ok')
end)

RegisterNUICallback("UnbanPlayer", function(Data, Cb)
    TriggerServerEvent('mc-admin/server/unban-player', Data.PData.BanId)
    SetTimeout(500, function()
        ToggleMenu(true)
    end)
    Cb('Ok')
end)

RegisterNUICallback('GetCharData', function(Data, Cb)
    local PlayerData = CallbackModule.SendCallback('mc-admin/server/get-player-data', Data.Identifier)
    Cb(PlayerData)
end)

RegisterNUICallback("Close", function(Data, Cb)
   SetNuiFocus(false, false)
   Cb('Ok')
end)

RegisterNUICallback("DevMode", function(Data, Cb)
    local Bool = Data.Toggle
    ToggleDevMode(Bool)
    Cb('Ok')
end)

RegisterNUICallback("GetDateDifference", function(Data, Cb)
    local FBans, CAmount = CallbackModule.SendCallback('mc-admin/server/get-date-difference', Data.BanList, Data.CType)
    Cb({
        Bans = FBans, 
        Amount = CAmount,
    })
end)

RegisterNUICallback('TriggerAction', function(Data, Cb) 
    if not PlayerModule.IsPlayerAdmin() then return end
    if Data.EventType == nil then Data.EventType = 'Client' end
    if Data.Event ~= nil and Data.EventType ~= nil then
        if Data.EventType == 'Client' then
            TriggerEvent(Data.Event, Data.Result)
        else
            TriggerServerEvent(Data.Event, Data.Result)
        end
    end
    Cb('Ok')
end)

RegisterNUICallback("DeleteReport", function(Data, Cb)
    if not PlayerModule.IsPlayerAdmin() then return end
    local Success, ServerId = DeleteReport(Data.Report['Id'])
    if Success then
        TriggerServerEvent('mc-admin/server/send-chat-report', ServerId, Lang:t('info.report_closed', { chatcommand = Config.Commands['ReportNew'] }))
    end
    Cb("Ok")
end)

RegisterNUICallback('SendChatsMessage', function(Data, Cb)
    local ChatChannel = Data.ChatChannel
    local ChatTime = Data.ChatTime
    local ChatMessage = Data.ChatMessage
    if ChatChannel == 'Staffchat' then
        Config.StaffChat[#Config.StaffChat + 1] = {
            ['Message'] = ChatMessage,
            ['Time'] = ChatTime,
            ['Sender'] = PlayerModule.GetPlayerData().Name,
        }
        TriggerServerEvent('mc-admin/server/sync-chat-data', ChatChannel, Config.StaffChat, 0)
    else
        local Report = GetReportIdFromId(Data.ReportId)
        if Report then -- Check if report exists
            if Config.Reports[Report] ~= nil then
                Config.Reports[Report]['Chats'][#Config.Reports[Report]['Chats'] + 1] = {
                    ['Message'] = ChatMessage,
                    ['Time'] = ChatTime,
                    ['Sender'] = PlayerModule.GetPlayerData().Name,
                }
                TriggerServerEvent('mc-admin/server/send-chat-report', Config.Reports[Report]['ServerId'], '[ADMIN] '..PlayerModule.GetPlayerData().Name..': '..ChatMessage)
                TriggerServerEvent('mc-admin/server/sync-chat-data', ChatChannel, Config.Reports, 0)
            end
        end
    end
    Cb("Ok")
end)