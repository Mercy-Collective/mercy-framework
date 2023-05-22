-- [ Code ] --

-- [ Events ] --

RegisterNetEvent("mc-admin/client/send-report", function(ReportData)
    if not HasReport() then
        exports['mercy-ui']:Notify("report-sent", Lang:t('info.report_sent'), 'success')
        Config.Reports[#Config.Reports + 1] = ReportData
        TriggerServerEvent('mc-admin/server/sync-chat-data', 'Reports', Config.Reports, 1500)
        ToggleMenu(true)
    else
        exports['mercy-ui']:Notify("report_already", Lang:t('info.report_already', { chatcommand = Config.Commands['ReportChat'], chatcommandclose = Config.Commands['ReportClose'] }), 'error')
    end
end)

RegisterNetEvent("mc-admin/client/close-report", function()
    if HasReport() then
        local ReportId = GetPlayerReportFromName()
        if ReportId then
            local Success, ServerId = DeleteReport(Config.Reports[ReportId]['Id'])
            if Success then
                exports['mercy-ui']:Notify("report-closed-self", Lang:t('info.report_closed_self'), 'success')
            end
        end
    else
        exports['mercy-ui']:Notify("report-not-open", Lang:t('info.report_not', { chatcommand = Config.Commands['ReportNew'] }), 'error')
    end
end)

RegisterNetEvent("mc-admin/client/reply-report", function(Message, Time)
    if HasReport() then
        local ReportId = GetPlayerReportFromName()
        if ReportId then
            local Success = AddReportMessage(Config.Reports[ReportId]['Id'], Message, Time)
            if Success then
                exports['mercy-ui']:Notify("reply-success", Lang:t('info.report_reply_success'), 'success')
            else
                exports['mercy-ui']:Notify("reply-error", Lang:t('info.report_reply_error'), 'error')
            end
        end
    else
        exports['mercy-ui']:Notify("report_not", Lang:t('info.report_not', { chatcommand = Config.Commands['ReportNew'] }), 'error')
    end
end)

RegisterNetEvent('mc-admin/client/sync-chat-data', function(Type, Data, UpdateDelay)
    if not PlayerModule.IsPlayerAdmin() then return end
    if Type == 'Staffchat' then Config.StaffChat = Data else Config.Reports = Data end
    if UpdateDelay then
        SetTimeout(UpdateDelay, function()
            SendNUIMessage({
                Action = 'UpdateChats',
                Staffchat = Type == 'Staffchat' and Config.StaffChat or false,
                Reports = Type == 'Reports' and Config.Reports or false,
            })
        end)
    else
        SendNUIMessage({
            Action = 'UpdateChats',
            Staffchat = Type == 'Staffchat' and Config.StaffChat or false,
            Reports = Type == 'Reports' and Config.Reports or false,
        })
    end
end)