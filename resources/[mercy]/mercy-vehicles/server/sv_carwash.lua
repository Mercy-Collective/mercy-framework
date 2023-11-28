CreateThread(function()
    while not _Ready do
        Wait(450)
    end

    CallbackModule.CreateCallback("mercy-carwash/server/do-payment", function(Source, Cb)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if not Player then return Cb(false) end
        Cb(Player.Functions.RemoveMoney(Config.CarwashSettings['Account'], Config.CarwashSettings['Cost']))
    end)
end)

-- [ Events ] --

RegisterNetEvent('mercy-carwash/server/do-sync', function(VehNet, UseProps)
    local src = source
    TriggerClientEvent('mercy-carwash/client/do-sync', -1, VehNet, src, UseProps)
end)
