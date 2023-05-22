RegisterNUICallback('MDW/Evidence/CreateEvidence', function(Data, Cb)
    EventsModule.TriggerServer('mercy-mdw/server/evidence/create', Data)
    Cb('Ok')
end)

RegisterNUICallback('MDW/Evidence/UpdateEvidence', function(Data, Cb)
    EventsModule.TriggerServer('mercy-mdw/server/evidence/update', Data)
    Cb('Ok')
end)

RegisterNUICallback('MDW/Evidence/AssignEvidence', function(Data, Cb)
    EventsModule.TriggerServer('mercy-mdw/server/evidence/assign', Data)
    Cb('Ok')
end)

RegisterNUICallback('MDW/Evidence/DeleteEvidence', function(Data, Cb)
    EventsModule.TriggerServer('mercy-mdw/server/evidence/delete', Data)
    Cb('Ok')
end)

RegisterNUICallback('MDW/Evidence/GetEvidences', function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-mdw/server/evidence/get-all", Data)
    Cb(Result)
end)

RegisterNUICallback('MDW/Evidence/GetEvidenceData', function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-mdw/server/evidence/get-data", Data)
    Cb(Result)
end)