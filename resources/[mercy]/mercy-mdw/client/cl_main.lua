EventsModule, CallbackModule, FunctionsModule, PlayerModule = nil, nil, nil, nil

local _Ready = false
AddEventHandler('Modules/client/ready', function()
    if not _Ready then
        _Ready = true
    end
    TriggerEvent('Modules/client/request-dependencies', {
        'Player',
        'Events',
        'Callback',
        'Functions',
    }, function(Succeeded)
        if not Succeeded then return end
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
    end)
end)

-- [ Code ] --

RegisterNetEvent('mercy-ui/client/ui-reset', function()
    exports['mercy-ui']:SendUIMessage("Mdw", "CloseMdw")
end)

-- [ Events ] --

RegisterNetEvent('mercy-mdw/client/open-MDW', function(Data)
    local IsPublic = false
    if Data == nil or Data.Type == nil then IsPublic = true end
    exports['mercy-assets']:AttachProp('Laplet')
    FunctionsModule.RequestAnimDict('amb@code_human_in_bus_passenger_idles@female@tablet@base')
    TaskPlayAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
    Citizen.SetTimeout(50, function()
        exports['mercy-ui']:SetNuiFocus(true, true)
        exports['mercy-ui']:SendUIMessage('Mdw', 'OpenMobileData', {
            ['CitizenId'] = PlayerModule.GetPlayerData().CitizenId,
            ['IsPublic'] = IsPublic
        })
    end)
end)

-- [ NUI Callbacks ] --

RegisterNUICallback('MDW/Close', function(Data, Cb)
    StopAnimTask(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 1.0)
    exports['mercy-ui']:SetNuiFocus(false, false)
    exports['mercy-assets']:RemoveProps('Laplet')
    Cb('Ok')
end)

RegisterNUICallback('MDW/Main/GetUser', function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-mdw/server/get-user", Data.CitizenId)
    Cb(Result)
end)

-- Dashboard
RegisterNUICallback('MDW/Dashboard/CreateAnnouncement', function(Data, Cb)
    EventsModule.TriggerServer('mercy-mdw/server/dashboard-create-announcement', Data)
    Cb('Ok')
end)

RegisterNUICallback('MDW/Announcements/GetAnnouncements', function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-mdw/server/dashboard/get-announcements")
    Cb(Result)
end)