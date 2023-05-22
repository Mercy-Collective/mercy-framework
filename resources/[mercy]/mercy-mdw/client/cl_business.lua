RegisterNUICallback('MDW/Businesses/GetBusinesses', function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-mdw/server/businesses/get")
    Cb(Result)
end)

RegisterNUICallback('MDW/Businesses/GetEmployees', function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-mdw/server/businesses/get-employees", Data)
    Cb(Result)
end)