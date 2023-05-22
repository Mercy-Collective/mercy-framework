RegisterNUICallback('MDW/Properties/GetProperties', function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-mdw/server/properties/get")
    Cb(Result)
end)

RegisterNUICallback('MDW/Properties/LocateProperty', function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-mdw/server/properties/get-data", Data)
    if not Result then return end
    Result.coords = json.decode(Result.coords)
    SetNewWaypoint(Result.coords.Enter.X, Result.coords.Enter.Y)
    Cb('Ok')
end)