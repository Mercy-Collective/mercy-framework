Jobs.Fishing = {
    CurrentFishingSpot = vector3(0, 0, 0),
    HasRodAnim = false,
    CanSell = true,
}

local ItemBuffs = {
    ['Fishdish'] = false
}

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while CallbackModule == nil do Citizen.Wait(100) end

    Jobs.Fishing.CurrentFishingSpot = CallbackModule.SendCallback("mercy-jobs/server/fishing/get-current-spot")
    Citizen.SetTimeout(1500, function()
        BlipModule.CreateBlip('fishing-spot', Jobs.Fishing.CurrentFishingSpot, 'Fishing Spot', 540, 26, false, 0.43)
        BlipModule.CreateBlip('fishing-sell', vector3(-1847.07, -1191.11, 14.32), 'Fishing Sales', 356, 26, false, 0.43)
    end)

    exports['mercy-ui']:AddEyeEntry("fishing-sells", {
        Type = 'Entity',
        EntityType = 'Ped',
        SpriteDistance = 5.0,
        Position = vector4(-1847.07, -1191.11, 13.35, 149.79),
        Model = 'csb_chef',
        Anim = {},
        Props = {},
        Options = {
            {
                Name = 'fishing_sell',
                Icon = 'fas fa-dollar-sign',
                Label = 'Sell',
                EventType = 'Client',
                EventName = 'mercy-jobs/client/fishing/try-sell',
                EventParams = {},
                Enabled = function(Entity)
                    return true
                end,
            }
        }
    })
end)

-- [ Events ] --

RegisterNetEvent('mercy-items/client/do-food-buff', function(Item, Bool)
    if not ItemBuffs[Item] then
        ItemBuffs[Item] = Bool
    end
end)

RegisterNetEvent('mercy-jobs/client/fishing/try-sell', function()
    if not Jobs.Fishing.CanSell then return end

    EventsModule.TriggerServer('mercy-jobs/server/fishing-sell') 
    Jobs.Fishing.CanSell = false
    Citizen.SetTimeout(10000, function()
        Jobs.Fishing.CanSell = true
    end)
end)

RegisterNetEvent('mercy-jobs/client/fishing/set-fishing-spot', function(FishingCoords)
    Jobs.Fishing.CurrentFishingSpot = FishingCoords
    while BlipModule == nil do Citizen.Wait(100) end
    BlipModule.CreateBlip('fishing-spot', Jobs.Fishing.CurrentFishingSpot, 'Fishing Spot', 540, 26, false, 0.43)
end)

RegisterNetEvent('mercy-items/client/used/fishing-rod', function()
    if not NearFishingZone() then
        exports['mercy-ui']:Notify("fisning-error", "Not a fishing spot..", 'error')
        return
    end

    if Jobs.Fishing.HasRodAnim then
        exports['mercy-ui']:Notify('fishing-holding', "Idiot, you are already holding a fishing rod..", "error")
        return
    end

    if IsPedInAnyVehicle(PlayerPedId()) then
        exports['mercy-ui']:Notify('fishing-car', "Do we fish in vehicles these days?", "error")
        return
    end

    SetRodAnimation(true)

    Citizen.SetTimeout(math.random(15000, 65000), function()
        local SkillTimes = 1
        local CalculatedFish = CalculateFish()
        
        if CalculatedFish == false then
            SetRodAnimation(false)
            exports['mercy-ui']:Notify("fisning-error", "No fish was hooked...", 'error')
            return
        end

        if CalculatedFish == 'Big' or CalculatedFish == 'Special' then SkillTimes = 4 end

        exports['mercy-ui']:Notify("fishing-fish", "A little nibble...", 'primary')

        local Outcome = exports['mercy-ui']:StartSkillTest(SkillTimes, { 10, 15 }, { 3500, 5500 }, false)
        SetRodAnimation(false)
        if not Outcome then
            exports['mercy-ui']:Notify("fisning-error", "It got away!!!!!!!", 'error')
            return
        end

        if exports['mercy-phone']:IsJobCenterTaskActive('fishing', 3) then
            TriggerEvent('mercy-phone/client/jobcenter/request-task-update', 3, 1)
        end
        EventsModule.TriggerServer('mercy-jobs/server/fishing-receive-goods', CalculatedFish)
    end)
end)


RegisterNetEvent('mercy-phone/client/jobcenter/on-job-start', function(Job, Leader)
    if Job ~= 'fishing' then return end

    if Leader == PlayerModule.GetPlayerData().CitizenId then
        Citizen.CreateThread(function()
            while true do
                if #(Config.MeetupPoints['fishing'] - GetEntityCoords(PlayerPedId())) < 10.0 then
                    TriggerEvent('mercy-phone/client/jobcenter/request-task-success', 1, true)
                    break
                end

                Citizen.Wait(1000)
            end
        end)
    end
end)

RegisterNetEvent('mercy-phone/client/jobcenter/on-task-done', function(Job, FinishedTaskId, NextTaskId, Leader)
    if Job ~= 'fishing' then return end

    if Leader == PlayerModule.GetPlayerData().CitizenId then
        if NextTaskId == 2 then -- Go to the fishing spot
            Citizen.CreateThread(function()
                while true do
                    if NearFishingZone() then
                        TriggerEvent('mercy-phone/client/jobcenter/request-task-success', 2, true)
                        break
                    end
    
                    Citizen.Wait(1000)
                end
            end)
        elseif NextTaskId == 4 then -- Go tell them the spot is good
            Citizen.CreateThread(function()
                while true do
                    if #(Config.MeetupPoints['fishing'] - GetEntityCoords(PlayerPedId())) < 10.0 then
                        TriggerEvent('mercy-phone/client/jobcenter/request-task-success', 4, true)
                        break
                    end
    
                    Citizen.Wait(1000)
                end
            end)
        end
    end
end)

-- [ Functions ] --

function SetRodAnimation(Bool)
    Jobs.Fishing.HasRodAnim = Bool
    if not Jobs.Fishing.HasRodAnim then return end

    exports['mercy-assets']:AttachProp('FishingRod')
    FunctionsModule.RequestAnimDict('amb@world_human_stand_fishing@idle_a')

    Citizen.CreateThread(function()
        while Jobs.Fishing.HasRodAnim do
            if not IsEntityPlayingAnim(PlayerPedId(), "amb@world_human_stand_fishing@idle_a", "idle_b", 3) then
                TaskPlayAnim(PlayerPedId(), "amb@world_human_stand_fishing@idle_a", "idle_b", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
            end
            Citizen.Wait(500)
        end
        StopAnimTask(PlayerPedId(), "amb@world_human_stand_fishing@idle_a", "idle_b", 1.0)
        exports['mercy-assets']:RemoveProps()
    end)
end

function CalculateFish()
    local RandomInt = math.random(1, 120)
    if RandomInt > 0 and RandomInt <= 15 then
        return 'Big'
    elseif RandomInt > 15 and RandomInt <= 110 then
        return 'Small'
    elseif RandomInt > 112 and RandomInt <= 115 then
        return 'Special'
    else
        return false
    end 
end

function NearFishingZone()
    local Coords = GetEntityCoords(PlayerPedId())
    local Distance = #(Coords - Jobs.Fishing.CurrentFishingSpot)
    if Distance < 65.0 then
        return true
    end
    return false
end
exports("NearFishingZone", NearFishingZone)