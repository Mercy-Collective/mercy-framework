RegisterNUICallback('MDW/Reports/GetReports', function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-mdw/server/get-reports")
    Cb(Result)
end)

RegisterNUICallback("MDW/Reports/UpdateReport", function(Data, Cb)
    EventsModule.TriggerServer("mercy-mdw/server/reports/update-report", Data)
    Cb('Ok')
end)

RegisterNUICallback("MDW/Reports/CreateReport", function(Data, Cb)
    EventsModule.TriggerServer("mercy-mdw/server/reports/create-report", Data)
    Cb('Ok')
end)

RegisterNUICallback("MDW/Reports/GetReportData", function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-mdw/server/reports/get-data", Data)
    Cb(Result)
end)

-- Tags
RegisterNUICallback("MDW/Reports/AddTags", function(Data, Cb)
    EventsModule.TriggerServer("mercy-mdw/server/reports/add-tag", Data)
    Cb('Ok')
end)

RegisterNUICallback("MDW/Reports/RemoveTag", function(Data, Cb)
    EventsModule.TriggerServer("mercy-mdw/server/reports/remove-tag", Data)
    Cb('Ok')
end)

-- Scums
RegisterNUICallback('MDW/Reports/AddCriminalScum', function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-mdw/server/reports/add-criminal-scum", Data)
    Cb(Result)
end)

RegisterNUICallback('MDW/Reports/DeleteCriminalScum', function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-mdw/server/reports/delete-criminal-scum", Data)
    Cb(Result)
end)

RegisterNUICallback('MDW/Reports/SaveScumCharges', function(Data, Cb)
    EventsModule.TriggerServer("mercy-mdw/server/reports/save-scum-charges", Data)
    Cb('Ok')
end)

RegisterNUICallback('MDW/Reports/GetScumData', function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-mdw/server/reports/get-scum-data", Data)
    Cb(Result)
end)

RegisterNUICallback('MDW/Reports/SaveScumData', function(Data, Cb)
    EventsModule.TriggerServer("mercy-mdw/server/reports/save-scum-data", Data)
    Cb('Ok')
end)

RegisterNUICallback('MDW/Reports/SetReduction', function(Data, Cb)
    EventsModule.TriggerServer("mercy-mdw/server/reports/set-reduction", Data)
    Cb('Ok')
end)

-- Other
RegisterNUICallback('MDW/Reports/AssignOfficers', function(Data, Cb)
    EventsModule.TriggerServer("mercy-mdw/server/reports/assign-officers", Data)
    Cb('Ok')
end)

RegisterNUICallback('MDW/Reports/RemoveOfficer', function(Data, Cb)
    EventsModule.TriggerServer("mercy-mdw/server/reports/remove-officer", Data)
    Cb('Ok')
end)

RegisterNUICallback('MDW/Reports/RemoveEvidence', function(Data, Cb)
    EventsModule.TriggerServer("mercy-mdw/server/reports/remove-evidence", Data)
    Cb('Ok')
end)

RegisterNUICallback('MDW/Reports/SearchScum', function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-mdw/server/reports/search-scum", Data)
    Cb(Result)
end)

RegisterNUICallback('MDW/Reports/Delete', function(Data, Cb)
    EventsModule.TriggerServer("mercy-mdw/server/reports/delete", Data)
    Cb('Ok')
end)