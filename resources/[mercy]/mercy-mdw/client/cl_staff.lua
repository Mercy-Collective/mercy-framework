RegisterNUICallback('MDW/Staff/GetStaffProfiles', function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-mdw/server/get-staff-profiles")
    Cb(Result)
end)

RegisterNUICallback('MDW/Staff/CreateStaffProfile', function(Data, Cb)
    EventsModule.TriggerServer('mercy-mdw/server/create-staff-profile', Data)
    Cb('Ok')
end)

RegisterNUICallback('MDW/Staff/UpdateStaffProfile', function(Data, Cb)
    EventsModule.TriggerServer('mercy-mdw/server/update-staff-profile', Data)
    Cb('Ok')
end)

RegisterNUICallback('MDW/Staff/DeleteStaffProfile', function(Data, Cb)
    EventsModule.TriggerServer('mercy-mdw/server/delete-staff-profile', Data)
    Cb('Ok')
end)

RegisterNUICallback('MDW/Staff/AddTag', function(Data, Cb)
    EventsModule.TriggerServer('mercy-mdw/server/add-staff-profile-tag', Data)
    Cb('Ok')
end)

RegisterNUICallback('MDW/Staff/RemoveTag', function(Data, Cb)
    EventsModule.TriggerServer('mercy-mdw/server/remove-staff-profile-tag', Data)
    Cb('Ok')
end)

RegisterNUICallback('MDW/Staff/RequestProfile', function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-mdw/server/staff/request-profile", Data)
    Cb(Result)
end)