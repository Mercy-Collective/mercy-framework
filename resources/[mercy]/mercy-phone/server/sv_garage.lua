-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(4)
    end

    CallbackModule.CreateCallback('mercy-phone/server/get-garage-data', function(Source, Cb)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local GarageData = {}
        DatabaseModule.Execute('SELECT * FROM player_vehicles WHERE citizenid = ?', {
            Player.PlayerData.CitizenId
        }, function(GarageData)
            if GarageData[1] ~= nil then 
                Cb(GarageData)
            else
                Cb({})
            end
        end)
    end)
end)