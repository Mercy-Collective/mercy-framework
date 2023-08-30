local NearCheckIn, NearHeliPad, NearGarage, ShowingInteraction = false, false, false, false

function InitHospitalZones()
    Citizen.CreateThread(function()
        exports['mercy-ui']:AddEyeEntry("medic_sign_in", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 4.0,
            ZoneData = {
                Center = vector3(-812.35, -1236.75, 7.34),
                Length = 0.4,
                Width = 0.6,
                Data = {
                    debugPoly = false, -- Optional, shows the box zone (Default: false)
                    heading = 321.0,
                    minZ = 6.99,
                    maxZ = 7.19, 
                },
            },
            Options = {
                {

                    Name = 'medic_sign_in',
                    Icon = 'fas fa-toggle-on',
                    Label = 'Duty Options',
                    EventType = 'Client',
                    EventName = 'mercy-base/client/duty-menu',
                    EventParams = {},
                    Enabled = function(Entity)
                        local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
                        if Player.Job.Name == 'ems' then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
          
        exports['mercy-ui']:AddEyeEntry("medic_scanner", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 2.0,
            ZoneData = {
                Center = vector3(-802.89, -1205.26, 7.34),
                Length = 0.8,
                Width = 0.8,
                Data = {
                    debugPoly = false, -- Optional, shows the box zone (Default: false)
                    heading = 320.0,
                    minZ = 7.39,
                    maxZ = 8.39, 
                },
            },
            Options = {
                {

                    Name = 'medic_scanner',
                    Icon = 'fas fa-binoculars',
                    Label = 'Blood Scanner',
                    EventType = 'Client',
                    EventName = 'mercy-hospital/client/scan-blood',
                    EventParams = {},
                    Enabled = function(Entity)
                        local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
                        if Player.Job.Name == 'ems' and Player.Job.Duty then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })

        exports['mercy-ui']:AddEyeEntry("medic_locker", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 2.0,
            ZoneData = {
                Center = vector3(-820.29, -1243.28, 7.34),
                Length = 0.2,
                Width = 2.0,
                Data = {
                    debugPoly = false, -- Optional, shows the box zone (Default: false)
                    heading = 320,
                    minZ = 6.0,
                    maxZ = 9.0,
                },
            },
            Options = {
                {
                    Name = 'medic_locker',
                    Icon = 'fas fa-shopping-basket',
                    Label = 'EMS Locker',
                    EventType = 'Client',
                    EventName = 'mercy-hospital/client/open-ems-store',
                    EventParams = {},
                    Enabled = function(Entity)
                        local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
                        if Player.Job.Name == 'ems' and Player.Job.Duty then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-polyzone']:CreateBox({
            center = vector3(-817.73, -1236.52, 7.34), 
            length = 2.2, 
            width = 1.6,
        }, {
            name = 'hospital_check_in',
            minZ = 4.94,
            maxZ = 8.94, 
            heading = 319.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end) 
        exports['mercy-polyzone']:CreateBox({
            center = vector3(-791.24, -1191.72, 53.03), 
            length = 12.6, 
            width = 12.6,
        }, {
            name = 'hospital_helipad',
            minZ = 52.03,
            maxZ = 54.03,
            heading = 75.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
        exports['mercy-polyzone']:CreateBox({
            center = vector3(-842.91, -1234.1, 6.93), 
            length = 9.4, 
            width = 5.0,
        }, {
            name = 'hospital_garage',
            minZ = 5.93,
            maxZ = 9.93, 
            heading = 49.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
    end)
end

RegisterNetEvent('mercy-polyzone/client/enter-polyzone', function(PolyData, Coords)
    if PolyData.name == 'hospital_check_in' then
        if not NearCheckIn then
            NearCheckIn = true
            if not ShowingInteraction then
                ShowingInteraction = true
                exports['mercy-ui']:SetInteraction('[E] Check-In', 'primary')
            end
            Citizen.CreateThread(function()
                while NearCheckIn do
                    Citizen.Wait(4)
                    if IsControlJustReleased(0, 38) then
                        exports['mercy-ui']:HideInteraction()
                        TriggerEvent('mercy-hospital/client/try-send-to-bed', false)
                    end
                end
            end)
        end
    elseif PolyData.name == 'hospital_helipad' then
        NearHeliPad = true
        if not ShowingInteraction then
            ShowingInteraction = true
            exports['mercy-ui']:SetInteraction('Helipad', 'primary')
        end
    elseif PolyData.name == 'hospital_garage' then
        NearGarage = true
        if not ShowingInteraction then
            ShowingInteraction = true
            exports['mercy-ui']:SetInteraction('Parking', 'primary')
        end
    else
        return
    end
end)

RegisterNetEvent('mercy-polyzone/client/leave-polyzone', function(PolyData, Coords)
    if PolyData.name == 'hospital_check_in' then
        if NearCheckIn then
            NearCheckIn = false
            if ShowingInteraction then
                ShowingInteraction = false
                exports['mercy-ui']:HideInteraction()
            end
        end
    elseif PolyData.name == 'hospital_helipad' then
        NearHeliPad = false
        if ShowingInteraction then
            ShowingInteraction = false
            exports['mercy-ui']:HideInteraction()
        end
    elseif PolyData.name == 'hospital_garage' then
        NearGarage = false
        if ShowingInteraction then
            ShowingInteraction = false
            exports['mercy-ui']:HideInteraction()
        end
    else
        return
    end
end)

function IsNearHeliPad()
    return NearHeliPad
end

function IsNearGarage()
    return NearGarage
end

exports('IsNearGarage', IsNearGarage)
exports('IsNearHeliPad', IsNearHeliPad)