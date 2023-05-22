local NearBank, ShowingInteraction = false, false

-- [ Code ] --

-- [ Functions ] --

function InitZones()
    Citizen.CreateThread(function()
        for k, v in pairs(Config.BankLocations) do
            exports['mercy-polyzone']:CreateBox({
                center = v['Coords'], 
                length = v['Data']['Length'], 
                width = v['Data']['Width'],
            }, {
                name = 'banking'..k,
                minZ = v['Data']['MinZ'],
                maxZ = v['Data']['MaxZ'],
                heading = v['Heading'],
                hasMultipleZones = false,
                debugPoly = false,
            }, function() end, function() end)
        end
        exports['mercy-ui']:AddEyeEntry(GetHashKey("prop_fleeca_atm"), {
            Type = 'Model',
            Model = 'prop_fleeca_atm',
            SpriteDistance = 2.0,
            Options = {
                {
                    Name = 'open_atm',
                    Icon = 'fas fa-dollar-sign',
                    Label = 'Atm',
                    EventType = 'Client',
                    EventName = 'mercy-financials/client/open-banking',
                    EventParams = false,
                    Enabled = function(Entity)
                        return true
                    end,
                },
            }
        })
        for i = 1, 3 do
            exports['mercy-ui']:AddEyeEntry(GetHashKey("prop_atm_0"..i), {
                Type = 'Model',
                Model = 'prop_atm_0'..i,
                SpriteDistance = 2.0,
                Options = {
                    {
                        Name = 'open_atm',
                        Icon = 'fas fa-dollar-sign',
                        Label = 'Atm',
                        EventType = 'Client',
                        EventName = 'mercy-financials/client/open-banking',
                        EventParams = false,
                        Enabled = function(Entity)
                            return true
                        end,
                    },
                }
            })
        end
        
    end)
end

-- [ Events ] --

RegisterNetEvent('mercy-polyzone/client/enter-polyzone', function(PolyData, Coords)
    local PolyName = string.sub(PolyData.name, 1, 7)
    if PolyName == 'banking' then
        if not NearBank then
            NearBank = true

            if not ShowingInteraction then
                ShowingInteraction = true
                exports['mercy-ui']:SetInteraction('[E] Bank', 'primary')
            end
            Citizen.CreateThread(function()
                while NearBank do
                    Citizen.Wait(4)
                    if IsControlJustReleased(0, 38) then
                        exports['mercy-ui']:HideInteraction()
                        TriggerEvent('mercy-financials/client/open-banking', true)
                    end
                end
            end)

        end
    end
end)

RegisterNetEvent('mercy-polyzone/client/leave-polyzone', function(PolyData, Coords)
    local PolyName = string.sub(PolyData.name, 1, 7)
    if PolyName == 'banking' then
        if NearBank then
            NearBank = false
            if ShowingInteraction then
                ShowingInteraction = false
                exports['mercy-ui']:HideInteraction()
            end
        end
    end
end)