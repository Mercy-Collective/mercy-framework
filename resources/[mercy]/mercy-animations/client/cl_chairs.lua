local SittingInChair, GoingUp, PrevCoords = false, false, vector3(0, 0, 0)

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn and SittingInChair then
            if IsControlJustReleased(0, 73) then
                TriggerEvent('mercy-animations/client/clear-chair')
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- [ Events ] --

RegisterNetEvent('mercy-animations/client/sit-chair', function(Data, Entity)
    if SittingInChair then return end
    if Data.Type == 'Entity' then
        local EntityCoords, Offset = GetEntityCoords(Entity), Config.Chairs[Data.Id].ZOffset
        PrevCoords, SittingInChair = GetEntityCoords(PlayerPedId()), true
        TaskStartScenarioAtPosition(PlayerPedId(), 'PROP_HUMAN_SEAT_CHAIR_MP_PLAYER', EntityCoords.x, EntityCoords.y, EntityCoords.z + Offset, GetEntityHeading(Entity) + 180.0, 0, true, true)
    elseif Data.Type == 'Poly' then
        local Coords, ZCoords, Heading = Data.Coords, Data.ZCoord, Data.Heading
        PrevCoords, SittingInChair = GetEntityCoords(PlayerPedId()), true
        TaskStartScenarioAtPosition(PlayerPedId(), 'PROP_HUMAN_SEAT_CHAIR_MP_PLAYER', Coords.x, Coords.y, ZCoords, Heading, 0, true, true)
    end
end)

RegisterNetEvent('mercy-animations/client/clear-chair', function()
    if not SittingInChair or GoingUp then return end
    GoingUp = true
    ClearPedTasks(PlayerPedId())
    Citizen.SetTimeout(850, function()
        SetEntityCoords(PlayerPedId(), PrevCoords.x, PrevCoords.y, PrevCoords.z - 0.5)
        PrevCoords, GoingUp, SittingInChair = vector3(0, 0, 0), false, false
    end)
end)

RegisterNetEvent('mercy-animations/client/reset-chair', function()
    PrevCoords, GoingUp, SittingInChair = vector3(0, 0, 0), false, false
end)

-- [ Functions ] --

function InitChairs()
    Citizen.CreateThread(function()
        for k, v in pairs(Config.Chairs) do
            if v.Type == 'Entity' then
                exports['mercy-ui']:AddEyeEntry(GetHashKey(v.Model), {
                    Type = 'Model',
                    Model = v.Model,
                    SpriteDistance = 1.7,
                    Options = {
                        {
                            Name = 'chair_sit',
                            Icon = 'fas fa-chair',
                            Label = 'Sit',
                            EventType = 'Client',
                            EventName = 'mercy-animations/client/sit-chair',
                            EventParams = {Type = 'Entity', Id = k},
                            Enabled = function(Entity)
                                return true
                            end,
                        }
                    }
                })
            elseif v.Type == 'Poly' then
                exports['mercy-ui']:AddEyeEntry("chair_"..k, {
                    Type = 'Zone',
                    SpriteDistance = 2.0,
                    Distance = 1.7,
                    State = false,
                    ZoneData = {
                        Center = v.Coords,
                        Length = v.Data.Length,
                        Width = v.Data.Width,
                        Data = {
                            debugPoly = false,
                            heading = v.Data.Heading,
                            minZ = v.Data.MinZ,
                            maxZ = v.Data.MaxZ
                        },
                    },
                    Options = {
                        {
                            Name = 'chair_option',
                            Icon = 'fas fa-chair',
                            Label = 'Sit',
                            EventType = 'Client',
                            EventName = 'mercy-animations/client/sit-chair',
                            EventParams = { Type = 'Poly', Coords = v.Coords, ZCoord = v.Data.MinZ, Heading = v.Heading },
                            Enabled = function(Entity)
                                return true
                            end,
                        }
                    }
                })
            end
        end
    end)
end