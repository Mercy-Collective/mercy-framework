-- [ Code ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(4)
    end

    CallbackModule.CreateCallback('mercy-heists/server/banktruck/can-rob-truck', function(Source, Cb, NetId)
        if TruckStates[NetId] ~= nil then
            if not TruckStates[NetId].Robbed then
                Cb(true)
            else
                Cb(false)
            end
        else
            Cb(true)
        end
    end)

    EventsModule.RegisterServer("mercy-heists/server/banktruck/receive-goods", function(Source)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local Random = math.random(1,100)
        if Random >= 1 and Random <= 30 then
            local Info = {Worth = math.random(5500, 8500)}
            Player.Functions.AddItem('markedbills', 1, false, Info, true)
        elseif Random >= 31 and Random <= 50 then
            Player.Functions.AddItem('rolexwatch', math.random(3, 11), false, false, true)
        elseif Random >= 51 and Random <= 80 then 
            Player.Functions.AddItem('2ctchain', math.random(6, 20), false, false, true)
        elseif Random == 91 or Random == 98 or Random == 85 or Random == 65 then
            Player.Functions.AddItem('goldbar', math.random(1, 2), false, false, true)
        elseif Random == 26 or Random == 52 then 
            Player.Functions.AddItem('yellow-card', 1, false, false, true)
        end
    end)

    EventsModule.RegisterServer("mercy-heists/server/banktruck/set-truck-state", function(Source, NetId, Bool)
        TruckStates[NetId] = {}
        TruckStates[NetId].Robbed = Bool
        if Bool then
            TriggerClientEvent('mercy-heists/client/banktruck/setup', Source, NetId)
            Citizen.SetTimeout((1000 * 60) * Config.ResetTimes['Banktruck'], function() -- 30 Mins
                TruckStates[NetId] = nil
                TriggerClientEvent('mercy-heists/client/banktruck/remove-truck', Source, NetId)
            end)
        end
    end)
end)