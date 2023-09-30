RegisterNUICallback('MDW/Profiles/GetProfiles', function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-mdw/server/get-profiles")
    Cb(Result)
end)

RegisterNUICallback('MDW/Profiles/CreateProfile', function(Data, Cb)
    EventsModule.TriggerServer('mercy-mdw/server/create-profile', Data)
    Cb('Ok')
end)

RegisterNUICallback('MDW/Profiles/UpdateProfile', function(Data, Cb)
    EventsModule.TriggerServer('mercy-mdw/server/update-profile', Data)
    Cb('Ok')
end)

RegisterNUICallback('MDW/Profiles/DeleteProfile', function(Data, Cb)
    EventsModule.TriggerServer('mercy-mdw/server/delete-profile', Data)
    Cb('Ok')
end)

RegisterNUICallback('MDW/Profiles/RequestProfile', function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-mdw/server/profiles/request-profile", Data)
    Cb(Result)
end)

RegisterNUICallback('MDW/Profiles/RequestData', function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-mdw/server/profiles/request-data", Data.CitizenId, Data.Id)
    Cb(Result)
end)

RegisterNUICallback('MDW/Profiles/AddTag', function(Data, Cb)
    EventsModule.TriggerServer('mercy-mdw/server/add-profile-tag', Data)
    Cb('Ok')
end)

RegisterNUICallback('MDW/Profiles/RemoveTag', function(Data, Cb)
    EventsModule.TriggerServer('mercy-mdw/server/remove-profile-tag', Data)
    Cb('Ok')
end)

RegisterNUICallback('MDW/Profiles/RemoveLicense', function(Data, Cb)
    EventsModule.TriggerServer('mercy-mdw/server/remove-profile-license', Data)
    Cb('Ok')
end)

RegisterNUICallback('MDW/Profiles/GetWarrents', function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-mdw/server/profiles/get-warrants")
    Cb(Result)
end)