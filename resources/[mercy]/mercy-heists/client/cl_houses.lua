
local CurrentRobbingHouse, ShowingInteraction, ForceEntered = nil, false, false
local HouseObject, Offsets, InsideHouse, Stealing = nil, nil, false, false
Colours = {
    r = 255,
    g = 255,
    b = 255,
}

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            if CurrentRobbingHouse ~= nil and InsideHouse and Config.Houses.Houses[CurrentRobbingHouse] ~= nil and Offsets ~= nil then

                -- Loot
                local HouseData = Config.Houses.Houses[CurrentRobbingHouse]
                local IsNear, Coords = false, GetEntityCoords(PlayerPedId())
                local ShellCoords = GetEntityCoords(HouseObject)
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
                local TCoords = vector3(Config.Houses.Houses[CurrentRobbingHouse].Coords.x + Offsets['Exit'].x, Config.Houses.Houses[CurrentRobbingHouse].Coords.y + Offsets['Exit'].y, (Config.Houses.Houses[CurrentRobbingHouse].Coords.z - 35.0) + Offsets['Exit'].z)
                local Distance = #(Coords - TCoords)
                if Distance < 1.5 then
                    if not ShowingInteraction then ShowingInteraction = true exports['mercy-ui']:SetInteraction('[E] Leave') end
                    IsNear = true
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent('mercy-heists/client/houses-leave', CurrentRobbingHouse, (PlayerData.Job.Name == 'police' and PlayerData.Job.Duty))
                    end
                end
                if not IsNear then
                    if ShowingInteraction then ShowingInteraction = false exports['mercy-ui']:HideInteraction() end
                    Citizen.Wait(450)
                end
            end
            -- Outside Enter
            if CurrentRobbingHouse ~= nil and not InsideHouse and Config.Houses.Houses[CurrentRobbingHouse] ~= nil then
                local HouseData = Config.Houses.Houses[CurrentRobbingHouse]

                local IsNear, Coords = false, GetEntityCoords(PlayerPedId())
                local TCoords = vector3(HouseData.Coords.x, HouseData.Coords.y, HouseData.Coords.z)
                local Distance = #(Coords - TCoords)
                if Distance < 1.5 and not HouseData.Locked then
                    if not ShowingInteraction then ShowingInteraction = true exports['mercy-ui']:SetInteraction('[E] Enter') end
                    IsNear = true
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent('mercy-heists/client/houses-enter', CurrentRobbingHouse)
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
                    if not InsideHouse and CurrentRobbingHouse == nil then
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

    CurrentRobbingHouse = GetAvailableHouse()
    EventsModule.TriggerServer('mercy-heists/server/housing/sync-house', 'SetHouseId', CurrentRobbingHouse)
    EventsModule.TriggerServer('mercy-heists/server/housing/sync-house', 'SetAvailable', CurrentRobbingHouse, false)
    local NearLocation = false
    Citizen.CreateThread(function()
        while not NearLocation do
            local Distance = #(GetEntityCoords(PlayerPedId()) - vector3(Config.Houses.Houses[CurrentRobbingHouse].Coords.x, Config.Houses.Houses[CurrentRobbingHouse].Coords.y, Config.Houses.Houses[CurrentRobbingHouse].Coords.z))
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
    while CurrentRobbingHouse ~= nil do
        Citizen.Wait(3)
        local Coords = GetEntityCoords(PlayerPedId())
        local Distance = #(Coords - vector3(Config.Houses.Houses[CurrentRobbingHouse].Coords.x, Config.Houses.Houses[CurrentRobbingHouse].Coords.y, Config.Houses.Houses[CurrentRobbingHouse].Coords.z))
        if Distance < 15.0 then
            DrawMarker(1, Config.Houses.Houses[CurrentRobbingHouse].Coords.x, Config.Houses.Houses[CurrentRobbingHouse].Coords.y, Config.Houses.Houses[CurrentRobbingHouse].Coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 255, false, false, false, true, false, false, false)
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
            if not InsideHouse then
                local Distance = #(GetEntityCoords(PlayerPedId()) - vector3(Config.Houses.Houses[CurrentRobbingHouse].Coords.x, Config.Houses.Houses[CurrentRobbingHouse].Coords.y, Config.Houses.Houses[CurrentRobbingHouse].Coords.z))
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
    EventsModule.TriggerServer('mercy-heists/server/housing/reset-house', CurrentRobbingHouse, false)
end)

RegisterNetEvent('mercy-phone/client/jobcenter/on-crash', function(Job, Leader)
    if Job ~= 'houses' then return end
    if InsideHouse then TriggerEvent('mercy-heists/client/houses-leave', CurrentRobbingHouse, false, true) end
    EventsModule.TriggerServer('mercy-heists/server/housing/reset-house', CurrentRobbingHouse, true)
    if CurrentRobbingHouse ~= nil then CurrentRobbingHouse = nil end
    FunctionsModule.ClearCustomGpsRoute()
end)

RegisterNetEvent('mercy-items/client/used-lockpick', function(IsAdvanced)
    if not exports['mercy-phone']:IsJobCenterTaskActive('houses', 2) then return end
    if InsideHouse or CurrentRobbingHouse == nil or IsPedInAnyVehicle(PlayerPedId()) then return end
    if Config.Houses.Houses[CurrentRobbingHouse] == nil and not Config.Houses.Houses[CurrentRobbingHouse].Locked then return end

    local HouseData = Config.Houses.Houses[CurrentRobbingHouse]

    if #(GetEntityCoords(PlayerPedId()) - vector3(HouseData.Coords.x, HouseData.Coords.y, HouseData.Coords.z)) > 1.5 then
        return
    end

    TriggerEvent('mercy-ui/client/play-sound', 'lockpick', 0.7)
    TriggerEvent('mercy-assets/client/lockpick-animation', true)
    local Outcome = exports['mercy-ui']:StartSkillTest(math.random(5, 8), IsAdvanced and { 1, 2 } or { 5, 10 }, IsAdvanced and { 6000, 12000 } or { 1500, 3000 }, true)
    TriggerEvent('mercy-assets/client/lockpick-animation', false)
    if Outcome then
        EventsModule.TriggerServer('mercy-heists/server/housing/sync-house', 'SetLocked', CurrentRobbingHouse, false)
        TriggerServerEvent('mercy-heists/client/housing/on-first-enter', CurrentRobbingHouse)
        TriggerEvent('mercy-phone/client/jobcenter/request-task-success', 2, true)
        TriggerEvent('mercy-heists/client/houses-enter', CurrentRobbingHouse)
    else
        TriggerEvent('mercy-ui/client/notify', 'housesr-error', "Failed attempt..", 'error')
    end
end)

RegisterNetEvent('mercy-heists/client/houses/disable-alarm', function()
    TriggerEvent('mercy-animations/client/play-animation', 'code')
    local Outcome = exports['mercy-ui']:StartSkillTest(math.random(5, 8), { 5, 10 }, { 1500, 3000 }, true)
    TriggerEvent('mercy-animations/client/clear-animation')
    if Outcome then
        EventsModule.TriggerServer('mercy-heists/server/housing/sync-house', 'SetAlarm', CurrentRobbingHouse, false)
    else
        TriggerEvent('mercy-ui/client/notify', 'housesr-error', "Failed attempt..", 'error')
    end
end)

RegisterNetEvent('mercy-heists/client/houses-enter', function(HouseId, SetId)
    if InsideHouse then return end
    if SetId then CurrentRobbingHouse = HouseId ForceEntered = true end
    InsideHouse = true

    DoScreenFadeOut(250)
    TriggerEvent('mercy-assets/client/play-door-animation')
    TriggerEvent('mercy-ui/client/play-sound', 'door-open', 0.75)
    while not IsScreenFadedOut() do Citizen.Wait(1) end

    local HouseCoords = vector3(Config.Houses.Houses[HouseId].Coords.x, Config.Houses.Houses[HouseId].Coords.y, Config.Houses.Houses[HouseId].Coords.z - 35.0)
    local Interior = exports['mercy-interiors']:CreateInterior(Config.Houses.Houses[HouseId].Shell, HouseCoords, true)
    if Interior then
        HouseObject, Offsets = Interior[1], Interior[2]
    
        SetEntityCoords(PlayerPedId(),Config.Houses.Houses[HouseId].Coords.x + Offsets['Exit'].x, Config.Houses.Houses[HouseId].Coords.y + Offsets['Exit'].y, (Config.Houses.Houses[HouseId].Coords.z - 35.0) + Offsets['Exit'].z)
        exports['mercy-ui']:SetInteraction('[E] Leave')
    
        DoScreenFadeIn(250)
        TriggerEvent('mercy-ui/client/play-sound', 'door-close', 0.45)
    else
        exports['mercy-ui']:Notify("housesr-error", "Failed to load interior..", "error")
        SetEntityCoords(PlayerPedId(), Config.Houses.Houses[HouseId].Coords.x, Config.Houses.Houses[HouseId].Coords.y, Config.Houses.Houses[HouseId].Coords.z)
        InsideHouse = false

        exports['mercy-ui']:HideInteraction()

        DoScreenFadeIn(250)
        TriggerEvent('mercy-ui/client/play-sound', 'door-close', 0.45)
    end
end)

RegisterNetEvent('mercy-heists/client/houses-leave', function(HouseId, IsPolice, Forced)
    if not InsideHouse then return end
    if HouseId == nil then return end
    if IsPolice and ForceEntered then CurrentRobbingHouse = nil ForceEntered = false end
    
    DoScreenFadeOut(250)
    TriggerEvent('mercy-assets/client/play-door-animation')
    TriggerEvent('mercy-ui/client/play-sound', 'door-open', 0.75)
    while not IsScreenFadedOut() do Citizen.Wait(1) end
    
    exports['mercy-interiors']:DespawnInterior(HouseObject)
    HouseObject, Offsets = nil, nil
    
    SetEntityCoords(PlayerPedId(), Config.Houses.Houses[HouseId].Coords.x, Config.Houses.Houses[HouseId].Coords.y, Config.Houses.Houses[HouseId].Coords.z)
    if not Forced then exports['mercy-ui']:SetInteraction('[E] Enter') end
    InsideHouse = false

    DoScreenFadeIn(250)
    TriggerEvent('mercy-ui/client/play-sound', 'door-close', 0.45)
end)

RegisterNetEvent('mercy-heists/client/housing/sync-house', function(Type, HouseId, Extra, ExtraTwo)
    if Type == 'SetHouseId' then
        CurrentRobbingHouse = HouseId
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
        Config.Houses.Houses[HouseId].AlarmActive = Extra
    elseif Type == 'SetLocker' then
        Config.Houses.Houses[HouseId].Loot[Extra] = ExtraTwo
    elseif Type == 'Reset' then
        Config.Houses.Houses[HouseId] = Extra
    elseif Type == 'ResetCurrent' then
        if InsideHouse then TriggerEvent('mercy-heists/client/houses-leave', CurrentRobbingHouse, false, true) end
        if CurrentRobbingHouse ~= nil then CurrentRobbingHouse = nil end
        FunctionsModule.ClearCustomGpsRoute()
    end
end)

RegisterNetEvent('mercy-heists/client/houses-send-alarm-beep', function(Sound, HouseId)
    if CurrentRobbingHouse == nil then return end
    if CurrentRobbingHouse ~= HouseId or not InsideHouse then return end
    TriggerEvent('mercy-ui/client/play-sound', Sound, 0.35)
end)

RegisterNetEvent('mercy-heists/client/houses-send-alarm', function()
    if math.random(1, 100) <= 100 then
        local StreetLabel = FunctionsModule.GetStreetName()
        TriggerServerEvent('mercy-ui/server/send-houses-rob', StreetLabel)
    end
end)

RegisterNetEvent('mercy-heists/client/error-reset', function()
    if CurrentRobbingHouse == nil then return end
    if InsideHouse then 
        TriggerEvent('mercy-heists/client/houses-leave', CurrentRobbingHouse, false, true) 
    end
    FunctionsModule.ClearCustomGpsRoute()
    CurrentRobbingHouse = nil
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
    if CurrentRobbingHouse == nil then return false end
    if Config.Houses.Houses[CurrentRobbingHouse] == nil then return false end
    return Config.Houses.Houses[CurrentRobbingHouse].AlarmActive
end
exports('CanDisableAlarm', CanDisableAlarm)

function SearchForGoods(GoodsKey)
    if Stealing then return end 
    local HouseData = Config.Houses.Houses[CurrentRobbingHouse]
    if not HouseData.Loot[GoodsKey] then
        Stealing = true
        HouseData.Loot[GoodsKey] = true
        local LootData = Config.Houses.Offsets[HouseData.Shell][GoodsKey]
        exports['mercy-ui']:ProgressBar('Searching..', 4000, {['AnimName'] = 'ex03_dingy_search_case_a_michael', ['AnimDict'] = 'missexile3', ['AnimFlag'] = 1}, false, false, false, function(DidComplete)
            if DidComplete then
                EventsModule.TriggerServer('mercy-heists/server/housing/sync-house', 'SetLocker', CurrentRobbingHouse, GoodsKey, true)
                EventsModule.TriggerServer('mercy-heists/server/housing/receive-goods', LootData.Type)
                Stealing = false
            else
                Stealing = false
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
