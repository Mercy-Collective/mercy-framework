local PaidForFuel = {}

CreateThread(function() 
    while not _Ready do 
        Wait(100) 
    end 

    CallbackModule.CreateCallback('mercy-vehicles/server/fuel/is-bill-paid', function(Source, Cb, Plate)
        if PaidForFuel[Plate] == nil then
            PaidForFuel[Plate] = false
        end
        Cb(PaidForFuel[Plate])
    end)
end)

-- [ Events ] --

RegisterNetEvent("mercy-vehicles/server/fuel/send-bill", function(Plate, Cid, Amount, IsElectric)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    local TargetPlayer = PlayerModule.GetPlayerByStateId(Cid)
    if not TargetPlayer then return end

    local NotifId = math.random(11111111, 99999999)
    TriggerClientEvent('mercy-phone/client/notification', TargetPlayer.PlayerData.Source, {
        Id = NotifId,
        Title = (IsElectric and "Charge" or "Fuel").." Payment Request",
        Message = "Plate: "..Plate..' - '..(IsElectric and 'Percentage: ' or 'Liters: ')..Amount,
        Icon = IsElectric and "fas fa-charging-station" or "fas fa-gas-pump",
        IconBgColor = "#4f5efc",
        IconColor = "white",
        Sticky = true,
        Duration = 30000,
        Buttons = {
            {
                Icon = "fas fa-times-circle",
                Event = "mercy-vehicles/server/fuel/decline-pay-request",
                EventType = "Server",
                EventData = {
                    ['NotifId'] = NotifId,
                },
                Tooltip = "Decline",
                Color = "#f2a365",
                CloseOnClick = true,
            },
            {
                Icon = "fas fa-check-circle",
                Event = "mercy-vehicles/server/fuel/accept-pay-request",
                EventType = "Server",
                EventData = {
                    ['NotifId'] = NotifId,
                    ['Source'] = TargetPlayer.PlayerData.Source,
                    ['Plate'] = Plate,
                    ['Amount'] = Amount,
                    ['Electric'] = IsElectric,
                },
                Tooltip = "Pay",
                Color = "#2ecc71",
                CloseOnClick = true,
            },
        },
    })
end)

RegisterNetEvent("mercy-vehicles/server/fuel/set-paid-state", function(Plate)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    PaidForFuel[Plate] = false
end)

RegisterNetEvent("mercy-vehicles/server/fuel/accept-pay-request", function(Data)
    local Player = PlayerModule.GetPlayerBySource(Data.Source)
    TriggerClientEvent('mercy-phone/client/hide-notification', Data.Source, Data['NotifId'])
    if Player then
        local Amount = Data.Electric and math.floor(FunctionsModule.GetTaxPrice((Data.Amount * Config.ChargePrice), "Gas")) or math.floor(FunctionsModule.GetTaxPrice((Data.Amount * Config.FuelPrice), "Gas"))
        local Type = Data.Electric and "charge" or "fuel"
        if Player.Functions.RemoveMoney('Bank', Amount) then
            PaidForFuel[Data.Plate] = true
        else
            Player.Functions.Notify('not-money', 'You do not have enough money to pay for the '..Type..'..', 'error')
        end
    end
end)

RegisterNetEvent("mercy-vehicles/server/fuel/decline-pay-request", function(Data)
    TriggerClientEvent('mercy-phone/client/hide-notification', Data.Source, Data['NotifId'])
end)