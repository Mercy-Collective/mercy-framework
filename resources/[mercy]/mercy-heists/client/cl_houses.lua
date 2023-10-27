local HouseRobberies = {
    CurrentHouse = nil,
    ForceEntered = false,
    HouseObject = nil,
    Offsets = nil,
    Inside = false,
    Stealing = false,
}

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    local ShowingInteraction = false
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            if HouseRobberies.CurrentHouse ~= nil and HouseRobberies.Inside and Config.Houses.Houses[HouseRobberies.CurrentHouse] ~= nil and HouseRobberies.Offsets ~= nil then

                -- Loot
                local HouseData = Config.Houses.Houses[HouseRobberies.CurrentHouse]
                local IsNear, Coords = false, GetEntityCoords(PlayerPedId())
                local ShellCoords = GetEntityCoords(HouseRobberies.HouseObject)
                for k, v in pairs(Config.Houses.Offsets[HouseData.Shell]) do
                    if #(vector3(v.Coords.x + ShellCoords.x, v.Coords.y + ShellCoords.y, v.Coords.z + ShellCoords.z) - Coords) <= 0.8 then
                        if not ShowingInteraction then ShowingInteraction = true exports['mercy-ui']:SetInteraction('[E] Search') end
                        IsNear = true
                        if IsControlJustReleased(0, 38) then
                            SearchForGoods(k)
                        end
                    end
                end

                -- Exit
                local TCoords = vector3(Config.Houses.Houses[HouseRobberies.CurrentHouse].Coords.x + HouseRobberies.Offsets['Exit'].x, Config.Houses.Houses[HouseRobberies.CurrentHouse].Coords.y + HouseRobberies.Offsets['Exit'].y, (Config.Houses.Houses[HouseRobberies.CurrentHouse].Coords.z - 35.0) + HouseRobberies.Offsets['Exit'].z)
                local Distance = #(Coords - TCoords)
                if Distance < 1.5 then
                    if not ShowingInteraction then ShowingInteraction = true exports['mercy-ui']:SetInteraction('[E] Leave') end
                    IsNear = true
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent('mercy-heists/client/houses-leave', HouseRobberies.CurrentHouse, (PlayerData.Job.Name == 'police' and PlayerData.Job.Duty))
                    end
                end
                if not IsNear then
                    if ShowingInteraction then ShowingInteraction = false exports['mercy-ui']:HideInteraction() end
                    Citizen.Wait(450)
                end
            end
            -- Outside Enter
            if HouseRobberies.CurrentHouse ~= nil and not HouseRobberies.Inside and Config.Houses.Houses[HouseRobberies.CurrentHouse] ~= nil then
                local HouseData = Config.Houses.Houses[HouseRobberies.CurrentHouse]

                local IsNear, Coords = false, GetEntityCoords(PlayerPedId())
                local TCoords = vector3(HouseData.Coords.x, HouseData.Coords.y, HouseData.Coords.z)
                local Distance = #(Coords - TCoords)
                if Distance < 1.5 and not HouseData.Locked then
                    if not ShowingInteraction then ShowingInteraction = true exports['mercy-ui']:SetInteraction('[E] Enter') end
                    IsNear = true
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent('mercy-heists/client/houses-enter', HouseRobberies.CurrentHouse)
                    end
                end
                if not IsNear then
                    if ShowingInteraction then ShowingInteraction = false exports['mercy-ui']:HideInteraction() end
                    Citizen.Wait(450)
                end
            end
            -- Police Enter
            if PlayerData then
                if PlayerData.Job ~= nil and PlayerData.Job.Name == 'police' and PlayerData.Job.Duty then
                    if not HouseRobberies.Inside and HouseRobberies.CurrentHouse == nil then
                        local IsNear, Coords = false, GetEntityCoords(PlayerPedId())
                        if Config.Houses.Houses ~= nil then
                            for k, v in pairs(Config.Houses.Houses) do
                                local TCoords = vector3(v.Coords.x, v.Coords.y, v.Coords.z )
                                local Distance = #(Coords - TCoords)
                                if Distance < 1.0 and not v.Available then
                                    if not ShowingInteraction then ShowingInteraction = true exports['mercy-ui']:SetInteraction('[E] Enter') end
                                    IsNear = true
                                    if IsControlJustReleased(0, 38) then
                                        TriggerEvent('mercy-heists/client/houses-enter', k, true)
                                    end
                                end
                            end
                            if not IsNear then
                                if ShowingInteraction then ShowingInteraction = false exports['mercy-ui']:HideInteraction() end
                                Citizen.Wait(450)
                            end
                        end
                    end
                end
           end
        else
            Citizen.Wait(450)
        end
    end
end)

-- [ Events ] --

RegisterNetEvent('mercy-phone/client/jobcenter/on-job-start', function(Job, Leader)
    if Job ~= 'houses' then return end
    if Leader ~= PlayerModule.GetPlayerData().CitizenId then return end

    HouseRobberies.CurrentHouse = GetAvailableHouse()

    EventsModule.TriggerServer('mercy-heists/server/housing/sync-house', 'SetHouseId', HouseRobberies.CurrentHouse)
    EventsModule.TriggerServer('mercy-heists/server/housing/sync-house', 'SetAvailable', HouseRobberies.CurrentHouse, false)
    local NearLocation = false
    Citizen.CreateThread(function()
        while not NearLocation do
            if HouseRobberies.CurrentHouse == nil then return end
            local Distance = #(GetEntityCoords(PlayerPedId()) - vector3(Config.Houses.Houses[HouseRobberies.CurrentHouse].Coords.x, Config.Houses.Houses[HouseRobberies.CurrentHouse].Coords.y, Config.Houses.Houses[HouseRobberies.CurrentHouse].Coords.z))
            if Distance < 20.0 then
                NearLocation = true
                TriggerEvent('mercy-phone/client/jobcenter/request-task-success', 1, true)
                StartMarkerThread()
            end
            Citizen.Wait(50)
        end
    end)
end)

function StartMarkerThread()
    while HouseRobberies.CurrentHouse ~= nil do
        Citizen.Wait(3)
        local Coords = GetEntityCoords(PlayerPedId())
        if HouseRobberies.CurrentHouse == nil then return end
        local Distance = #(Coords - vector3(Config.Houses.Houses[HouseRobberies.CurrentHouse].Coords.x, Config.Houses.Houses[HouseRobberies.CurrentHouse].Coords.y, Config.Houses.Houses[HouseRobberies.CurrentHouse].Coords.z))
        if Distance < 15.0 then
            DrawMarker(1, Config.Houses.Houses[HouseRobberies.CurrentHouse].Coords.x, Config.Houses.Houses[HouseRobberies.CurrentHouse].Coords.y, Config.Houses.Houses[HouseRobberies.CurrentHouse].Coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 255, false, false, false, true, false, false, false)
        end
    end
end

RegisterNetEvent('mercy-phone/client/jobcenter/on-task-done', function(Job, FinishedTaskId, NextTaskId, Leader)
    if Job ~= 'houses' then return end
    if FinishedTaskId ~= 2 then return end
    if Leader ~= PlayerModule.GetPlayerData().CitizenId then return end

    local NearHouse = true
    Citizen.CreateThread(function()
        while NearHouse do
            if not HouseRobberies.Inside then
                local Distance = #(GetEntityCoords(PlayerPedId()) - vector3(Config.Houses.Houses[HouseRobberies.CurrentHouse].Coords.x, Config.Houses.Houses[HouseRobberies.CurrentHouse].Coords.y, Config.Houses.Houses[HouseRobberies.CurrentHouse].Coords.z))
                if Distance > 20.0 then
                    NearHouse = false
                end
            end
            Citizen.Wait(50)
        end
        TriggerEvent('mercy-phone/client/jobcenter/request-task-success', 3, true)
    end)
end)

RegisterNetEvent('mercy-phone/client/jobcenter/job-tasks-done', function(Job, Leader)
    if Job ~= 'houses' then return end
    if Leader ~= PlayerModule.GetPlayerData().CitizenId then return end
    EventsModule.TriggerServer('mercy-heists/server/housing/reset-house', HouseRobberies.CurrentHouse, false)
end)

RegisterNetEvent('mercy-phone/client/jobcenter/on-crash', function(Job, Leader)
    if Job ~= 'houses' then return end
    if HouseRobberies.Inside then TriggerEvent('mercy-heists/client/houses-leave', HouseRobberies.CurrentHouse, false, true) end
    EventsModule.TriggerServer('mercy-heists/server/housing/reset-house', HouseRobberies.CurrentHouse, true)
    if HouseRobberies.CurrentHouse ~= nil then HouseRobberies.CurrentHouse = nil end
    FunctionsModule.ClearCustomGpsRoute()
end)

RegisterNetEvent('mercy-items/client/used-lockpick', function(IsAdvanced)
    if not exports['mercy-phone']:IsJobCenterTaskActive('houses', 2) then return end
    if HouseRobberies.Inside or HouseRobberies.CurrentHouse == nil or IsPedInAnyVehicle(PlayerPedId()) then return end
    if Config.Houses.Houses[HouseRobberies.CurrentHouse] == nil and not Config.Houses.Houses[HouseRobberies.CurrentHouse].Locked then return end

    local HouseData = Config.Houses.Houses[HouseRobberies.CurrentHouse]

    if #(GetEntityCoords(PlayerPedId()) - vector3(HouseData.Coords.x, HouseData.Coords.y, HouseData.Coords.z)) > 1.5 then
        return
    end

    TriggerEvent('mercy-ui/client/play-sound', 'lockpick', 0.7)
    TriggerEvent('mercy-assets/client/lockpick-animation', true)
    local Outcome = exports['mercy-ui']:StartSkillTest(math.random(5, 8), IsAdvanced and { 1, 2 } or { 5, 10 }, IsAdvanced and { 6000, 12000 } or { 1500, 3000 }, true)
    TriggerEvent('mercy-assets/client/lockpick-animation', false)
    if Outcome then
        EventsModule.TriggerServer('mercy-heists/server/housing/sync-house', 'SetLocked', HouseRobberies.CurrentHouse, false)
        TriggerServerEvent('mercy-heists/client/housing/on-first-enter', HouseRobberies.CurrentHouse)
        TriggerEvent('mercy-phone/client/jobcenter/request-task-success', 2, true)
        TriggerEvent('mercy-heists/client/houses-enter', HouseRobberies.CurrentHouse)
    else
        exports['mercy-assets']:RemoveLockpickChance(IsAdvanced)
        TriggerEvent('mercy-ui/client/notify', 'housesr-error', "Failed attempt..", 'error')
    end
end)

RegisterNetEvent('mercy-heists/client/houses/disable-alarm', function()
    TriggerEvent('mercy-animations/client/play-animation', 'code')
    local Outcome = exports['mercy-ui']:StartSkillTest(math.random(5, 8), { 5, 10 }, { 1500, 3000 }, true)
    TriggerEvent('mercy-animations/client/clear-animation')
    if Outcome then
        EventsModule.TriggerServer('mercy-heists/server/housing/sync-house', 'SetAlarm', HouseRobberies.CurrentHouse, false)
    else
        TriggerEvent('mercy-ui/client/notify', 'housesr-error', "Failed attempt..", 'error')
    end
end)

RegisterNetEvent('mercy-heists/client/houses-enter', function(HouseId, SetId)
    if HouseRobberies.Inside then return end
    if SetId then 
        HouseRobberies.CurrentHouse = HouseId 
        HouseRobberies.ForceEntered = true 
    end
    HouseRobberies.Inside = true

    DoScreenFadeOut(250)
    TriggerEvent('mercy-assets/client/play-door-animation')
    TriggerEvent('mercy-ui/client/play-sound', 'door-open', 0.75)
    while not IsScreenFadedOut() do Citizen.Wait(1) end

    local HouseCoords = vector3(Config.Houses.Houses[HouseId].Coords.x, Config.Houses.Houses[HouseId].Coords.y, Config.Houses.Houses[HouseId].Coords.z - 35.0)
    local Interior = exports['mercy-interiors']:CreateInterior(Config.Houses.Houses[HouseId].Shell, HouseCoords, true)
    if Interior then
        HouseRobberies.HouseObject, HouseRobberies.Offsets = Interior[1], Interior[2]
    
        SetEntityCoords(PlayerPedId(),Config.Houses.Houses[HouseId].Coords.x + HouseRobberies.Offsets['Exit'].x, Config.Houses.Houses[HouseId].Coords.y + HouseRobberies.Offsets['Exit'].y, (Config.Houses.Houses[HouseId].Coords.z - 35.0) + HouseRobberies.Offsets['Exit'].z)
        exports['mercy-ui']:SetInteraction('[E] Leave')
    
        DoScreenFadeIn(250)
        TriggerEvent('mercy-ui/client/play-sound', 'door-close', 0.45)
    else
        exports['mercy-ui']:Notify("housesr-error", "Failed to load interior..", "error")
        SetEntityCoords(PlayerPedId(), Config.Houses.Houses[HouseId].Coords.x, Config.Houses.Houses[HouseId].Coords.y, Config.Houses.Houses[HouseId].Coords.z)
        HouseRobberies.Inside = false

        exports['mercy-ui']:HideInteraction()

        DoScreenFadeIn(250)
        TriggerEvent('mercy-ui/client/play-sound', 'door-close', 0.45)
    end
end)

RegisterNetEvent('mercy-heists/client/houses-leave', function(HouseId, IsPolice, Forced)
    if not HouseRobberies.Inside then return end
    if HouseId == nil then return end
    if IsPolice and HouseRobberies.ForceEntered then 
        HouseRobberies.CurrentHouse = nil 
        HouseRobberies.ForceEntered = false 
    end
    
    DoScreenFadeOut(250)
    TriggerEvent('mercy-assets/client/play-door-animation')
    TriggerEvent('mercy-ui/client/play-sound', 'door-open', 0.75)
    while not IsScreenFadedOut() do Citizen.Wait(1) end
    
    exports['mercy-interiors']:DespawnInterior(HouseRobberies.HouseObject)
    HouseRobberies.HouseObject, HouseRobberies.Offsets = nil, nil
    
    SetEntityCoords(PlayerPedId(), Config.Houses.Houses[HouseId].Coords.x, Config.Houses.Houses[HouseId].Coords.y, Config.Houses.Houses[HouseId].Coords.z)
    if not Forced then exports['mercy-ui']:SetInteraction('[E] Enter') end
    HouseRobberies.Inside = false

    DoScreenFadeIn(250)
    TriggerEvent('mercy-ui/client/play-sound', 'door-close', 0.45)
end)

RegisterNetEvent('mercy-heists/client/housing/sync-house', function(Type, HouseId, Extra, ExtraTwo)
    if Type == 'SetHouseId' then
        HouseRobberies.CurrentHouse = HouseId
        local CoordsTable = {
            { Coords = GetEntityCoords(PlayerPedId()) },
            { Coords = Config.Houses.Houses[HouseId].Coords }
        }
        FunctionsModule.CreateCustomGpsRoute(CoordsTable, true)
    elseif Type == 'SetLocked' then
        Config.Houses.Houses[HouseId].Locked = Extra
    elseif Type == 'SetAvailable' then
        Config.Houses.Houses[HouseId].Available = Extra
    elseif Type == 'SetAlarm' then
        Config.Houses.Houses[HouseId].Alarm = Extra
    elseif Type == 'SetLocker' then
        Config.Houses.Houses[HouseId].Loot[Extra] = ExtraTwo
    elseif Type == 'Reset' then
        Config.Houses.Houses[HouseId] = Extra
    elseif Type == 'ResetCurrent' then
        if HouseRobberies.Inside then TriggerEvent('mercy-heists/client/houses-leave', HouseRobberies.CurrentHouse, false, true) end
        if HouseRobberies.CurrentHouse ~= nil then HouseRobberies.CurrentHouse = nil end
        FunctionsModule.ClearCustomGpsRoute()
    end
end)

RegisterNetEvent('mercy-heists/client/houses-send-alarm-beep', function(Sound, HouseId)
    if HouseRobberies.CurrentHouse == nil then return end
    if HouseRobberies.CurrentHouse ~= HouseId or not HouseRobberies.Inside then return end
    TriggerEvent('mercy-ui/client/play-sound', Sound, 0.35)
end)

RegisterNetEvent('mercy-heists/client/houses-send-alarm', function()
    if math.random(1, 100) <= 100 then
        local StreetLabel = FunctionsModule.GetStreetName()
        EventsModule.TriggerServer('mercy-ui/server/send-houses-rob', StreetLabel)
    end
end)

RegisterNetEvent('mercy-heists/client/error-reset', function()
    if HouseRobberies.CurrentHouse == nil then return end
    if HouseRobberies.Inside then 
        TriggerEvent('mercy-heists/client/houses-leave', HouseRobberies.CurrentHouse, false, true) 
    end
    FunctionsModule.ClearCustomGpsRoute()
    HouseRobberies.CurrentHouse = nil
end)

-- [ Functions ] --

function GetAvailableHouse()
    local RandomHouses = {}
    for k, v in pairs(Config.Houses.Houses) do
        if v.Available then
            table.insert(RandomHouses, k)
        end
    end
    if #RandomHouses == 0 then return false end
    return RandomHouses[math.random(1, #RandomHouses)]
end

function CanDisableAlarm()
    if HouseRobberies.CurrentHouse == nil then return false end
    if Config.Houses.Houses[HouseRobberies.CurrentHouse] == nil then return false end
    return Config.Houses.Houses[HouseRobberies.CurrentHouse].Alarm
end
exports('CanDisableAlarm', CanDisableAlarm)

function SearchForGoods(GoodsKey)
    if HouseRobberies.Stealing then return end 
    local HouseData = Config.Houses.Houses[HouseRobberies.CurrentHouse]
    if not HouseData.Loot[GoodsKey] then
        HouseRobberies.Stealing = true
        HouseData.Loot[GoodsKey] = true
        local LootData = Config.Houses.Offsets[HouseData.Shell][GoodsKey]
        exports['mercy-ui']:ProgressBar('Searching..', 4000, {['AnimName'] = 'ex03_dingy_search_case_a_michael', ['AnimDict'] = 'missexile3', ['AnimFlag'] = 1}, false, false, false, function(DidComplete)
            if DidComplete then
                EventsModule.TriggerServer('mercy-heists/server/housing/sync-house', 'SetLocker', HouseRobberies.CurrentHouse, GoodsKey, true)
                EventsModule.TriggerServer('mercy-heists/server/housing/receive-goods', LootData.Type)
                HouseRobberies.Stealing = false
            else
                HouseRobberies.Stealing = false
                HouseData.Loot[GoodsKey] = false
            end
        end)
    end
end

function InitHouses()
    exports['mercy-ui']:AddEyeEntry(GetHashKey("v_res_tre_alarmbox"), {
        Type = 'Model',
        Model = 'v_res_tre_alarmbox',
        SpriteDistance = 2.2,
        Options = {
            {
                Name = 'house_alarm',
                Icon = 'fas fa-dna',
                Label = 'Disable Alarm',
                EventType = 'Client',
                EventName = 'mercy-heists/client/houses/disable-alarm',
                EventParams = '',
                Enabled = function(Entity)
                    if exports['mercy-heists']:CanDisableAlarm() then
                        return true
                    else
                        return false
                    end
                end,
            }
        }
    })
end
