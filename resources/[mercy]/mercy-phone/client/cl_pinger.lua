--[[
    App: Pinger
]]

Pinger = {}
Pinger.Accepted = false

RegisterNUICallback("Pinger/SendPing", function(Data, Cb)
    local Success = CallbackModule.SendCallback("mercy-phone/server/pinger/do-ping-request", Data, GetEntityCoords(PlayerPedId()))
    Cb(Success)
end)

function Pinger.Render()
    exports['mercy-ui']:SendUIMessage("Phone", "RenderPingerApp", {
        HasVPN = exports['mercy-inventory']:HasEnoughOfItem('vpn', 1) or exports['mercy-inventory']:HasEnoughOfItem('darkmarketdeliveries', 1),
    })
end

RegisterNetEvent('mercy-phone/client/pinger/receive', function(Coords, Sender, Name)
    -- Reset Data
    Pinger.Accepted = false
    Pinger.Id = math.random(111111, 999999)

    PlaySound(-1, "Click_Fail", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)

    if exports['mercy-inventory']:HasEnoughOfItem('phone', 1) then
        exports['mercy-ui']:SendUIMessage('Phone', 'Notification', {
            Id = Pinger.Id,
            Title = "Ping!",
            Message = "You received a ping from " .. Name,
            Icon = "fas fa-map-pin",
            IconBgColor = "#4f5efc",
            IconColor = "white",
            Sticky = true,
            Duration = 10000,
            Buttons = {
                {
                    Icon = "fas fa-times-circle",
                    Event = "mercy-phone/client/pinger/answer-pinger",
                    EventData = { Declined = true, Sender = Sender, Coords = Coords },
                    Tooltip = "Reject",
                    Color = "#f2a365",
                    CloseOnClick = true,
                },
                {
                    Icon = "fas fa-check-circle",
                    Event = "mercy-phone/client/pinger/answer-pinger",
                    EventData = { Declined = false, Sender = Sender, Coords = Coords },
                    Tooltip = "Accept",
                    Color = "#2ecc71",
                    CloseOnClick = true,
                },
            }
        })
    end

    Citizen.SetTimeout(10000, function()
        if Pinger.Accepted == false then
            TriggerEvent('mercy-phone/client/pinger/answer-pinger', { Declined = true, Sender = Sender, Coords = Coords })
            TriggerEvent('mercy-phone/client/hide-notification', Pinger.Id)
        end
    end)
end)

RegisterNetEvent('mercy-phone/client/pinger/answer-pinger', function(Data)
    Pinger.Accepted = true
    TriggerServerEvent('mercy-phone/server/pinger/sender-message', Data.Sender, (Data.Declined and 'Ping was denied..' or 'Ping was accepted!'))

    if not Data.Declined then
        local Transition = 250
        local Blip = BlipModule.CreateBlip('phone-ping', Data.Coords, 'Ping!', 280, 0, false, 1.0)
        while Transition ~= 0 do
            Citizen.Wait(180 * 4)
            Transition = Transition - 1
            SetBlipAlpha(Blip, Transition)
            if Transition == 0 then
                SetBlipSprite(Blip, 2)
                BlipModule.RemoveBlip('phone-ping')
                return
            end
        end
        SetNewWaypoint(Coords.x, Coords.y)
    end
end)