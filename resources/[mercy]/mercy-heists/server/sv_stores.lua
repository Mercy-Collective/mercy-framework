-- [ Code ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(4)
    end

    CallbackModule.CreateCallback('mercy-heists/server/stores/register-robbable', function(Source, Cb, RegisterId)
        if Config.Registers[RegisterId] ~= nil then
            if Config.Registers[RegisterId]['Robbed'] then
                Cb(false)
            else
                Cb(true)
            end
        else
            Cb(false)
        end
    end)

    EventsModule.RegisterServer("mercy-heists/server/stores/receive-money", function(Source)    
        local Player = PlayerModule.GetPlayerBySource(Source)
        Player.Functions.AddMoney('Cash', math.random(250, 450), "Store-Robbery")
        Player.Functions.AddItem('cash-rolls', math.random(5, 15), false, false, true)
    end)
end)

-- [ Events ] --

RegisterNetEvent("mercy-heists/server/stores/set-state", function(RegisterId, Type, Bool)
    Config.Registers[RegisterId][Type] = Bool

    if Type == 'Robbed' then -- Reset
        SetTimeout((1000 * 60) * Config.ResetTimes['Stores'], function() -- 10 minutes
            Config.Registers[RegisterId]['Robbed'] = false
        end)
    end
end)