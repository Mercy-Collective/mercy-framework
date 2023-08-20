local PayPhones = {
    "p_phonebox_01b_s",
    "prop_phonebox_01a",
    "prop_phonebox_01b",
    "prop_phonebox_01c",
    "prop_phonebox_02",
    "prop_phonebox_03",
    "prop_phonebox_04",
    "ch_chint02_phonebox001",
    "sf_prop_sf_phonebox_01b_s",
    "sf_prop_sf_phonebox_01b_straight",
}

local CallingFromPayphone, PayphoneCoords = false, false

Citizen.CreateThread(function()
    for k, v in pairs(PayPhones) do
        exports['mercy-ui']:AddEyeEntry(GetHashKey(v), {
            Type = 'Model',
            Model = v,
            SpriteDistance = 5.0,
            Distance = 1.5,
            Options = {
                {
                    Name = 'call_payphone',
                    Icon = 'fas fa-phone-alt',
                    Label = 'Call Someone ($ 150.00)',
                    EventType = 'Client',
                    EventName = 'mercy-misc/client/payphones/call',
                    EventParams = { Costs = 150, Caller = 'Payphone', Phone = "69" .. tostring(Shared.RandomInt(9)) },
                    Enabled = function(Entity)
                        return true
                    end,
                },
            }
        })
    end
end)

RegisterNetEvent("mercy-misc/client/payphones/call", function(Data, Entity)
    PayphoneCoords = GetEntityCoords(Entity)

    local Result = exports['mercy-ui']:CreateInput({
        { Label = 'Phone Number', Icon = 'fas fa-phone', Name = 'Phone' },
    })

    if Result and Result.Phone then
        Result.Phone = Result.Phone:gsub("%(", ""):gsub("%)", ""):gsub("%-", "") -- Remove all symbols
        if #Result.Phone < 10 then
            return exports['mercy-ui']:Notify("invalid-phone", "Invalid phone number..", 'error')
        elseif #Result.Phone > 10 then
            return exports['mercy-ui']:Notify("invalid-phone", "Invalid phone number..", 'error')
        end
        local CashRemoved = CallbackModule.SendCallback("mercy-base/server/remove-cash", Data.Costs)
        if not CashRemoved then
            return exports['mercy-ui']:Notify("no-money-payphone", "Not enough money..", 'error')
        end
        
        CallingFromPayphone = true
        EventsModule.TriggerServer("mercy-phone/server/dial-payphone", {
            Phone = Result.Phone,
            CallerName = Data.Caller,
            CallingFrom = Data.Phone,
        })
    end
end)

RegisterNetEvent("mercy-phone/client/set-call-data", function(Data)
    if not PayphoneCoords then return end

    if not Data then
        CallingFromPayphone = false
        return
    end

    CallingFromPayphone = Data.Payphone

    Citizen.CreateThread(function()
        if not PayphoneCoords then return end
        while CallingFromPayphone and #(GetEntityCoords(PlayerPedId()) - PayphoneCoords) <= 3.0 do Citizen.Wait(500) end
        if not PayphoneCoords then return end
        if #(GetEntityCoords(PlayerPedId()) - PayphoneCoords) > 3.0 then
            exports['mercy-ui']:Notify("too-far-phone", "You are going too far away..", 'error')
            TriggerEvent('mercy-phone/client/calling/answer-call', { Declined = true, CallName = 'Payphone', IsPayphone = true, Id = Data.Id })
            ClearPedTasks(PlayerPedId())
        end
        PayphoneCoords = false
    end)
end)