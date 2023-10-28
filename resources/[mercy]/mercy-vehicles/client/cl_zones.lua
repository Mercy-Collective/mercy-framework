function InitZones()
    CreateThread(function()
        exports['mercy-ui']:AddEyeEntry(GetHashKey("wheelchair"), {
            Type = 'Model',
            Model = 'wheelchair',
            SpriteDistance = 3.2,
            Options = {
                {
                    Name = 'pickup',
                    Icon = 'fas fa-wheelchair',
                    Label = 'Pickup',
                    EventType = 'Client',
                    EventName = 'mercy-vehicle/client/pickup-wheelchair',
                    EventParams = false,
                    Enabled = function(Entity)
                        return true
                    end,
                },
            }
        })
    end)
end