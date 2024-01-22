-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(4)
    end


    CallbackModule.CreateCallback('mercy-phone/server/dark/get-items', function(Source, Cb)
        local DarkItems = {}
        for k, v in pairs(ServerConfig.DarkItems) do
            if not v.Hidden then
                table.insert(DarkItems, v)
            end
        end
        Cb(DarkItems)
    end)

    CallbackModule.CreateCallback('mercy-phone/server/dark/purchase', function(Source, Cb, Data)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.RemoveCrypto(Data.ItemData.Payment.Label:lower(), Data.ItemData.Payment.Amount, Data.ItemData.Payment.Label) then
            TriggerClientEvent('mercy-phone/client/dark/start-drop-off', Source, Data.ItemData.Name)
            TriggerClientEvent('mercy-phone/client/mails/send-mail', Source, {
                Sender = "Puppet Master",
                Subject = "Order",
                Content = "You know where to go.",
                Timestamp = os.date()
            })
            Cb({
                Success = true
            })
        else
           Cb({
               Success = false,
               FailMessage = "You don't have enough "..Data.ItemData.Payment.Label.." to purchase this item."
           })
        end
    end)
    
    CallbackModule.CreateCallback('mercy-phone/server/dark/get-drop-off-location', function(Source, Cb, Id)
        Cb(GetDropOffLocation(Id))
    end)

    EventsModule.RegisterServer("mercy-phone/server/dark/receive-drop-off", function(Source, Id)
        local Player = PlayerModule.GetPlayerBySource(Source)
        Player.Functions.AddItem(Id, 1, false, false, true)
    end)
end)

-- [ Functions ] --

function GetDropOffLocation(Id)
    for k, v in pairs(ServerConfig.DarkItems) do
        if v.Name == Id then
            return v.DropOffs[math.random(1, #v.DropOffs)]
        end
    end
    return false
end