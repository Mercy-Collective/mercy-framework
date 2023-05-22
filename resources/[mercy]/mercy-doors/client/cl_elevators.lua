-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('mercy-doors/client/open-elevator-menu', function(Data, Entity)
    if Config.Elevators[Data.ElevatorId] ~= nil then
        local MenuItems = {}
        for k, v in pairs(Config.Elevators[Data.ElevatorId]) do                                                                                         
            local Disabled, AtLocation = not HasAccessToElevator(v), false
            if Data.AtLocation == v.IdName then
                Disabled, AtLocation = true, true
            end
            local MenuData = {}     
            MenuData['Title'] = AtLocation and Disabled and v.Name..' (You are here!)' or v.Name
            MenuData['Desc'] = not AtLocation and Disabled and 'No Access!' or v.Desc
            MenuData['Data'] = { ['Event'] = 'mercy-doors/client/use-elevator', ['Type'] = 'Client', ['CurrentElevator'] = Data, ['ElevatorData'] = v }
            MenuData['Disabled'] = Disabled
            table.insert(MenuItems, MenuData)
        end
        exports['mercy-ui']:OpenContext({ ['MainMenuItems'] = MenuItems })
    end
end)

RegisterNetEvent('mercy-doors/client/use-elevator', function(Data)
    if Data.ElevatorData.Coords ~= nil then
        exports['mercy-ui']:ProgressBar('Waiting for elevator..', 3500, {['AnimName'] = 'idle_a', ['AnimDict'] = 'amb@world_human_hang_out_street@female_hold_arm@idle_a', ['AnimFlag'] = 8}, false, true, true, function(DidComplete)
            if DidComplete then
                ElevatorToCoords(Data.CurrentElevator.AtLocation, Data.ElevatorData.IdName, Data.ElevatorData.Coords)
            end
        end)
    end
end)

-- [ Functions ] --

function InitElevator()
    Citizen.CreateThread(function()
        for k, v in pairs(Config.ElevatorZones) do
            for Elevator, ElevatorData in pairs(Config.ElevatorZones[k]) do
                exports['mercy-ui']:AddEyeEntry("elevator_"..k..'-'..Elevator, {
                    Type = 'Zone',
                    SpriteDistance = 5.0,
                    Distance = 4.0,
                    ZoneData = {
                        Center = ElevatorData.Coords,
                        Length = ElevatorData.Data.Length,
                        Width = ElevatorData.Data.Width,
                        Data = {
                            debugPoly = false,
                            heading = ElevatorData.Data.Heading,
                            minZ = ElevatorData.Data.MinZ,
                            maxZ = ElevatorData.Data.MaxZ
                        },
                    },
                    Options = {
                        {
                            Name = 'elevator_option',
                            Icon = 'fas fa-chevron-circle-up',
                            Label = 'Elevator',
                            EventType = 'Client',
                            EventName = 'mercy-doors/client/open-elevator-menu',
                            EventParams = {ElevatorId = k, AtLocation = ElevatorData.IdName},
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

function HasAccessToElevator(ElevatorData)
    local PlayerData = PlayerModule.GetPlayerData()
    if ElevatorData ~= nil then
        for k, v in pairs(ElevatorData.Access.Job) do
            if PlayerData.Job.Name == v then
                return true
            end
        end
        for k, v in pairs(ElevatorData.Access.CitizenId) do
            if PlayerData.CitizenId == v then
                return true
            end
        end
        for k, v in pairs(ElevatorData.Access.Business) do
            if exports['mercy-business']:HasPlayerBusinessPermission(v, 'property_keys') then
                return true
            end
        end

        if not ElevatorData.Locked then
            return true
        end

        if #ElevatorData.Access.Job == 0 and #ElevatorData.Access.CitizenId == 0 and #ElevatorData.Access.Business == 0 then
            return true
        end
    end

    return false
end

function ElevatorToCoords(FromElevatorId, ToElevatorId, Coords)
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Citizen.Wait(1) end

    TriggerEvent('mercy-doors/client/on-elevator-leave', FromElevatorId)
    TriggerEvent('mercy-ui/client/play-sound', 'elevator', 0.2)
    NetworkFadeOutEntity(PlayerPedId(), true, true)
    Citizen.Wait(300)

    SetGameplayCamRelativeHeading(0.0)
    RequestCollisionAtCoord(Coords.x, Coords.y, Coords.z)
    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
        SetEntityCoords(PlayerPedId(), Coords.x + 0.0, Coords.y + 0.0, Coords.z + 0.0)
        Citizen.Wait(1)
    end

    TriggerEvent('mercy-doors/client/on-elevator-enter', ToElevatorId)
    SetEntityCoords(PlayerPedId(), Coords.x + 0.0, Coords.y + 0.0, Coords.z + 0.0)
    SetEntityHeading(PlayerPedId(), Coords.w)
    NetworkFadeInEntity(PlayerPedId(), true)

    Citizen.Wait(500)
    DoScreenFadeIn(500)
end

-- AddEventHandler('mercy-doors/client/on-elevator-enter', function(Entering)
--     print('Entering..', Entering)
-- end)

-- AddEventHandler('mercy-doors/client/on-elevator-leave', function(Leaving)
--     print('Leaving..', Leaving)
-- end)