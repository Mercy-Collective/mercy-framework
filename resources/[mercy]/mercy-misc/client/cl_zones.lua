function InitMiscZones()
    Citizen.CreateThread(function()
        for i = 1, 3 do
            exports['mercy-ui']:AddEyeEntry(GetHashKey("prop_yoga_mat_0"..i), {
                Type = 'Model',
                Model = "prop_yoga_mat_0"..i,
                SpriteDistance = 9.5,
                Options = {
                    {
                        Name = 'doing_yoga',
                        Icon = 'fas fa-male',
                        Label = 'Yoga',
                        EventType = 'Client',
                        EventName = 'mercy-misc/client/do-yoga',
                        EventParams = '',
                        Enabled = function(Entity)
                            return true
                        end,
                    },
                }
            })
        end
    end)
end