local NearAction, ShowingScreen, ShowingInteraction = false, false, false

function InitCityZones() 
    Citizen.CreateThread(function()
        exports['mercy-ui']:AddEyeEntry("cityhall-options", {
            Type = 'Entity',
            EntityType = 'Ped',
            SpriteDistance = 5.0,
            Position = vector4(-540.29, -191.04, 37.20, 120.46),
            Model = 'a_f_y_business_04',
            Anim = {},
            Props = {},
            Options = {
                {
                    Name = 'grab_id_card',
                    Icon = 'fas fa-id-card',
                    Label = '($'..Config.IdPrice..') Identification',
                    EventType = 'Server',
                    EventName = 'mercy-cityhall/server/purchase-id',
                    EventParams = {},
                    Enabled = function(Entity)
                        return true
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("judge-gavel", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 4.0,
            ZoneData = {
                Center = vector3(-519.33, -175.63, 38.55),
                Length = 0.3,
                Width = 0.25,
                Data = {
                    debugPoly = false, -- Optional, shows the box zone (Default: false)
                    heading = 85.0,
                    minZ = 38.35,
                    maxZ = 38.75
                },
            },
            Options = {
                {
                    Name = 'judge_gavel',
                    Icon = 'fas fa-gavel',
                    Label = 'Gavel Hit',
                    EventType = 'Client',
                    EventName = 'mercy-cityhall/client/gavel-hit',
                    EventParams = {},
                    Enabled = function(Entity)
                        local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
                        if Player.Job.Name == 'judge' and Player.Job.Duty then
                            return true
                        else
                            return false
                        end
                    end,
                },
                {
                    Name = 'court_change_url',
                    Icon = 'far fa-file-code',
                    Label = 'Change URL',
                    EventType = 'Client',
                    EventName = 'mercy-assets/client/change-dui-url',
                    EventParams = 'court-screen',
                    Enabled = function(Entity)
                        local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
                        if Player.Job.Name == 'judge' and Player.Job.Duty then
                            return true
                        else
                            return false
                        end
                    end,
                }
            }
        })
        exports['mercy-ui']:AddEyeEntry("judge-check-in", {
            Type = 'Zone',
            SpriteDistance = 5.0,
            Distance = 4.0,
            ZoneData = {
                Center = vector3(-553.13, -192.78, 38.22),
                Length = 0.9,
                Width = 0.4,
                Data = {
                    debugPoly = false, -- Optional, shows the box zone (Default: false)
                    heading = 295.0,
                    minZ = 38.02,
                    maxZ = 38.62
                },
            },
            Options = {
                {
                    Name = 'judge_toggle_duty',
                    Icon = 'fas fa-toggle-on',
                    Label = 'Duty Options',
                    EventType = 'Client',
                    EventName = 'mercy-base/client/duty-menu',
                    EventParams = {},
                    Enabled = function(Entity)
                        local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
                        if Player.Job.Name == 'judge' then
                            return true
                        end
                    end,
                }
            }
        })
        exports['mercy-polyzone']:CreateBox({
            center = vector3(-524.76, -178.71, 38.22), 
            length = 20.9, 
            width = 20.9,
        }, {
            name = 'cityhall_court',
            minZ = 37.22,
            maxZ = 47.62,
            heading = 30.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
        exports['mercy-polyzone']:CreateBox({
            center = vector3(-536.02, -185.64, 38.22), 
            length =  1.7, 
            width = 2.3,
        }, {
            name = 'court_metaldetect_1',
            minZ = 37.22,
            maxZ = 39.62,
            heading = 30.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
        exports['mercy-polyzone']:CreateBox({
            center = vector3(-537.5, -186.46, 42.76), 
            length =  1.7, 
            width = 2.3,
        }, {
            name = 'court_metaldetect_2',
            minZ = 41.76,
            maxZ = 44.16,
            heading = 30.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
        exports['mercy-polyzone']:CreateBox({
            center = vector3(-550.33, -192.73, 38.22), 
            length =  1.1, 
            width = 1.9,
        }, {
            name = 'metaldetect_stuff',
            minZ = 37.22,
            maxZ = 39.22,
            heading = 30.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
        exports['mercy-polyzone']:CreateBox({
            center = vector3(-552.41, -193.83, 38.22), 
            length =  1.1, 
            width = 2.1,
        }, {
            name = 'public_mdw',
            minZ = 37.22,
            maxZ = 39.22,
            heading = 28.0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
    end)
end

RegisterNetEvent('mercy-polyzone/client/enter-polyzone', function(PolyData, Coords)
    if PolyData.name == 'metaldetect_stuff' then
        if not NearAction then
            NearAction = true
            if not ShowingInteraction then
                ShowingInteraction = true
                exports['mercy-ui']:SetInteraction('[E] Retrieve Stuff', 'primary')
            end
            Citizen.CreateThread(function()
                while NearAction do
                    Citizen.Wait(4)
                    if IsControlJustReleased(0, 38) then
                        exports['mercy-ui']:HideInteraction()
                        if exports['mercy-inventory']:CanOpenInventory() then
                            local MyStateId =  PlayerModule.GetPlayerData().CitizenId
                            EventsModule.TriggerServer('mercy-inventory/server/open-other-inventory', "cityhall-"..MyStateId, 'Stash', 45, 0.0)
                        end
                    end
                end
            end)
        end
    elseif PolyData.name == 'public_mdw' then
        if not NearAction then
            NearAction = true
            if not ShowingInteraction then
                ShowingInteraction = true
                exports['mercy-ui']:SetInteraction('[E] Public MDW', 'primary')
            end
            Citizen.CreateThread(function()
                while NearAction do
                    Citizen.Wait(4)
                    if IsControlJustReleased(0, 38) then
                        exports['mercy-ui']:HideInteraction()
                        TriggerEvent('mercy-mdw/client/open-MDW')
                    end
                end
            end)
        end
    elseif PolyData.name == 'cityhall_court' then
        if ShowingScreen then return end
        LoadCourtScreen(true)
        ShowingScreen = true
    elseif PolyData.name == 'court_metaldetect_1' or PolyData.name == 'court_metaldetect_2' then
        MetalScanPlayer()
    else
        return
    end
end)

RegisterNetEvent('mercy-polyzone/client/leave-polyzone', function(PolyData, Coords)
    if PolyData.name == 'metaldetect_stuff' or PolyData.name == 'public_mdw' then
        if NearAction then
            NearAction = false
            if ShowingInteraction then
                ShowingInteraction = false
                exports['mercy-ui']:HideInteraction()
            end
        end
    elseif PolyData.name == 'court_metaldetect_1' or PolyData.name == 'court_metaldetect_2' then
    elseif PolyData.name == 'cityhall_court' then
        if not ShowingScreen then return end
        LoadCourtScreen(false)
        ShowingScreen = false
        IsScanning = false
    else
        return
    end
end)