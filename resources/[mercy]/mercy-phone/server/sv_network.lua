-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(4)
    end

    CallbackModule.CreateCallback('mercy-phone/server/network/get-network-zones', function(Source, Cb)
        Cb(ServerConfig.Networks)
    end)

    CallbackModule.CreateCallback('mercy-phone/server/network/get-nearest-networks', function(Source, Cb, Zone)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local PlayerCoords = GetEntityCoords(GetPlayerPed(Source))
        if Zone == nil then
            Cb({})
            return
        end
        local Dist = #(vector2(PlayerCoords.x, PlayerCoords.y) - ServerConfig.Networks[Zone][1])
        local NetworksList = {}
        if Dist < 15.0 then
            table.insert(NetworksList, ServerConfig.Networks[Zone].extraData)
            Cb(NetworksList)
        else
            Cb({})
        end
    end)

    CallbackModule.CreateCallback('mercy-phone/server/network/connect-to-network', function(Source, Cb, Data)
        local Player = PlayerModule.GetPlayerBySource(Source)
        -- Data.Data, Data.Selected
        if Data.Data.password:lower() == Data.Selected.Password:lower() then
            Cb({true, Data.Selected.Network})
        else
            Cb({false})
        end
    end)
end)