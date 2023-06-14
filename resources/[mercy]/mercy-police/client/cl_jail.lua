InJail, PrisonJob, TaskBlip = false, { Task = false, Info = '', Data = {} }, nil

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        if LocalPlayer.state.LoggedIn and InJail then
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local Distance = #(PlayerCoords - Config.JailCoords)
            if Distance > 195.0 then
                DoScreenFadeOut(1)
                Citizen.SetTimeout(250, function()
                    local RandomSpawn = Config.JailSpawns[math.random(1, #Config.JailSpawns)]
                    SetEntityCoords(PlayerPedId(), RandomSpawn.x, RandomSpawn.y, RandomSpawn.z)
                    SetEntityHeading(PlayerPedId(), RandomSpawn.w)
                    Citizen.Wait(400)
                    DoScreenFadeIn(500)
                    TriggerEvent('mercy-ui/client/notify', "jail-error", "Hmm I don\'t think you can leave yet..", 'error')
                end)
            end
        else
           Citizen.Wait(500)
        end
        Citizen.Wait(1000)
    end
end)

-- [ Events ] --

RegisterNetEvent("mercy-police/client/change-task", function()
    local MenuItems = {}
    for k, v in pairs(Config.PrisonTasks) do
        MenuItems[#MenuItems + 1] = {
            ['Title'] = v.Task,
            ['Desc'] = v.Info,
            ['Data'] = {
                ['Event'] = 'mercy-police/client/set-current-task',
                ['Type'] = 'Client',
                ['Task'] = k,
            }
        }
    end
    exports['mercy-ui']:OpenContext({ ['MainMenuItems'] = MenuItems, ['Width'] = '35vh', }) 
end)

RegisterNetEvent("mercy-police/client/set-current-task", function(Data)
    PrisonJob = { Task = Config.PrisonTasks[Data.Task].Task, Info = Config.PrisonTasks[Data.Task].Info, Data = {} }
    
    if DoesBlipExist(TaskBlip) then RemoveBlip(TaskBlip) end
    if PrisonJob.Task == 'None' then
        CreateTaskBlip(205, 16, 'Chill Spot', vector3(1756.03, 2546.06, 45.55))
        Citizen.CreateThread(function()
            while PrisonJob.Task == 'None' do
                if #(GetEntityCoords(PlayerPedId()) - vector3(1756.03, 2546.06, 45.55)) < 10.0 then
                    ReduceJailTime(1)
                end
                Citizen.Wait((1000 * 60) * 5) -- 5 Minutes
            end
        end)
    end
end)

RegisterNetEvent('mercy-police/client/enter-jail', function(Time, Parole, Forced)
    local Player = PlayerModule.GetPlayerData()
    EventsModule.TriggerServer('mercy-inventory/server/move-items-to-stash', 'player-'..Player.CitizenId, 'jail-'..Player.CitizenId)
    InJail = true
    if not Forced then
        EventsModule.TriggerServer('mercy-police/server/set-in-jail', Time, Parole)
    else
        TriggerEvent('mercy-ui/client/play-sound', 'jail-door', 0.5)
    end
    TriggerEvent('mercy-assets/client/attach-items')
    local RandomSpawn = Config.JailSpawns[math.random(1, #Config.JailSpawns)]
    SetEntityCoords(PlayerPedId(), RandomSpawn.x, RandomSpawn.y, RandomSpawn.z)
    SetEntityHeading(PlayerPedId(), RandomSpawn.w)
    Citizen.Wait(2000)
    DoScreenFadeIn(1000)
end)

RegisterNetEvent('mercy-police/client/leave-jail', function()
    ResetJail()
    Citizen.SetTimeout(50, function()
        TriggerEvent('mercy-ui/client/play-sound', 'jail-cell', 0.5)
        EventsModule.TriggerServer('mercy-police/server/set-in-jail', 0)
        DoScreenFadeOut(1000)
        Citizen.Wait(1000)
        SetEntityCoords(PlayerPedId(), 1841.69, 2590.94, 46.01, 0, 0, 0, false)
        SetEntityHeading(PlayerPedId(), 189.05)
        Citizen.Wait(2000)
        DoScreenFadeIn(1000)
    end)
end)

RegisterNetEvent('mercy-police/client/check-jail-time', function()
    local JailTime = PlayerModule.GetPlayerData().MetaData['Jail']
    if JailTime > 0 then
        TriggerEvent('mercy-chat/client/post-message', "Jail - DOC", 'You have '..JailTime..' month(s) remaining.', 'warning')
    else
        TriggerEvent('mercy-police/client/leave-jail')
    end
end)

RegisterNetEvent('mercy-police/client/open-jail-craft', function()
    if exports['mercy-inventory']:CanOpenInventory() then
        Citizen.SetTimeout(450, function()
            EventsModule.TriggerServer('mercy-inventory/server/open-other-inventory', 'Jail Crafting', 'Crafting', 0, 0, Config.JailCrafting)
        end)
    end
end)

RegisterNetEvent('mercy-police/client/go-to-jail-sleep', function()
    EventsModule.TriggerServer("mercy-ui/server/characters/send-to-character-screen")
end)

RegisterNetEvent('mercy-police/client/escape-jail', function()
    TriggerEvent('mercy-ui/client/notify', "jail-jebait", "Haha you tried!!", 'error')
    TriggerEvent('mercy-ui/client/play-sound', 'rickroll', 0.5)
end)

RegisterNetEvent('mercy-police/client/jail-tap-slushy', function()
    exports['mercy-inventory']:SetBusyState(true)
    exports['mercy-ui']:ProgressBar('Making a god slushy..', 5000, {['AnimName'] = 'idle_a', ['AnimDict'] = 'amb@world_human_hang_out_street@female_hold_arm@idle_a', ['AnimFlag'] = 8}, false, true, true, function(DidComplete)
        if DidComplete then
            ClearPedTasks(PlayerPedId())
            EventsModule.TriggerServer("mercy-police/server/receive-jail-item", 'slushy')
        else
            ClearPedTasks(PlayerPedId())
        end
        exports['mercy-inventory']:SetBusyState(false)
    end)
end)

RegisterNetEvent('mercy-police/client/jail-take-plate', function()
    EventsModule.TriggerServer("mercy-police/server/receive-jail-item", 'jailfood')
end)

-- Prison Job

RegisterNetEvent('mercy-police/client/do-prison-task', function(Data)
    local MyPos = GetEntityCoords(PlayerPedId())
    if Data.Task == 'Scrapyard' then
        if Data.Job == 'StackBricks' then
            TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_MEDIC_TIME_OF_DEATH", 0, true)
            exports['mercy-inventory']:SetBusyState(true)
            exports['mercy-ui']:ProgressBar('Inspecting stones..', 10000, false, false, true, true, function(DidComplete)
                if DidComplete then
                    ClearPedTasks(PlayerPedId())
                    ReduceJailTime(1)
                else
                    ClearPedTasks(PlayerPedId())
                end
                exports['mercy-inventory']:SetBusyState(false)
            end)
        elseif Data.Job == 'SortScrap' then
            if PrisonJob.Data.HasScraps then
                return exports['mercy-ui']:Notify('alr-box-trash', "You already have a box with trash..", "error")
            end
            TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CONST_DRILL", 0, true)
            exports['mercy-inventory']:SetBusyState(true)
            exports['mercy-ui']:ProgressBar('Sorting trash..', 20000, false, false, true, true, function(DidComplete)
                if DidComplete then
                    ClearPedTasks(PlayerPedId())
                    exports['mercy-ui']:Notify('has-box-trash', "You filled the box with trash, bring the box to the delivery point.")
                    CreateTaskBlip(50, 16, 'Delivery Point', vector3(1720.44, 2566.67, 45.55))
                    TriggerEvent('mercy-animations/client/play-animation', "box")
                    exports['mercy-assets']:AttachProp("Box")
                    PrisonJob.Data.HasScraps = true
    
                    -- if math.random(1, 100) >= 25 and math.random(1, 100) <= 30 then
                    --     EventsModule.TriggerServer("mercy-police/server/receive-jail-item", 'burnerphone')
                    --     exports['mercy-ui']:Notify('has-box-trash', "You found a weird phone..", "error")
                    -- end
                else
                    ClearPedTasks(PlayerPedId())
                end
                exports['mercy-inventory']:SetBusyState(false)
            end)
        elseif Data.Job == 'DeliverScrap' then
            if not PrisonJob.Data.HasScraps then
                return exports['mercy-ui']:Notify('alr-not-box-trash', "You don't have a box with trash..", "error")
            end
            exports['mercy-assets']:RemoveProps()
            exports['mercy-inventory']:SetBusyState(true)
            exports['mercy-ui']:ProgressBar('Delivering box..', 5000, {['AnimName'] = 'base', ['AnimDict'] = 'missfam4', ['AnimFlag'] = 8}, "Clipboard", true, true, function(DidComplete)
                if DidComplete then
                    ClearPedTasks(PlayerPedId())
                    PrisonJob.Data.HasScraps = false
                    ReduceJailTime(2)
                    if DoesBlipExist(TaskBlip) then RemoveBlip(TaskBlip) end
                else
                    ClearPedTasks(PlayerPedId())
                    if DoesBlipExist(TaskBlip) then RemoveBlip(TaskBlip) end
                end
                exports['mercy-inventory']:SetBusyState(false)
            end)
        end
    elseif Data.Task == 'Kitchen' then
        if Data.Job == 'SortKitchen' then
            exports['mercy-ui']:ProgressBar('Sorting..', 20000, {['AnimName'] = 'ex03_dingy_search_case_a_michael', ['AnimDict'] = 'missexile3', ['AnimFlag'] = 8}, false, true, true, function(DidComplete)
                if DidComplete then
                    ClearPedTasks(PlayerPedId())
                    ReduceJailTime(2)
                else
                    ClearPedTasks(PlayerPedId())
                end
                exports['mercy-inventory']:SetBusyState(false)
            end)
        elseif Data.Job == 'CleanTable' then
            exports['mercy-ui']:ProgressBar('Cleaning table..', 10000, {['AnimName'] = 'base', ['AnimDict'] = 'timetable@maid@cleaning_surface@base', ['AnimFlag'] = 8}, false, true, true, function(DidComplete)
                if DidComplete then
                    ClearPedTasks(PlayerPedId())
                    ReduceJailTime(1)
                else
                    ClearPedTasks(PlayerPedId())
                end
                exports['mercy-inventory']:SetBusyState(false)
            end)
        end
    end
end)

RegisterNetEvent("mercy-police/client/show-prison-job-info", function()
    if not PrisonJob or PrisonJob.Task == false then
        return exports['mercy-ui']:Notify('no-tasks', "You are not doing any tasks..", "error")
    end

    exports['mercy-ui']:HideInteraction()
    Citizen.SetTimeout(500, function()
        exports['mercy-ui']:SetInteraction('Task: ' .. PrisonJob.Task .. ' - ' .. PrisonJob.Info)
        Citizen.Wait(5000)
        exports['mercy-ui']:HideInteraction()
    end)
end)

-- [ Functions ] --

function ReduceJailTime(Reduction)
    if math.random(1, 100) >= 75 then return end

    local JailTime = PlayerModule.GetPlayerData().MetaData['Jail']
    if JailTime - Reduction > 1 then
        exports['mercy-ui']:Notify('reduction-received', "Penalty reduction received. " .. JailTime - Reduction .. " month(s) remaining.", nil, 7000)
        EventsModule.TriggerServer('mercy-police/server/reduce-jail-time', Reduction)
    end
end

function CreateTaskBlip(Sprite, Color, Text, Coords)
    if DoesBlipExist(TaskBlip) then
        RemoveBlip(TaskBlip)
    end

    TaskBlip = AddBlipForCoord(Coords.x, Coords.y, Coords.z)
    SetBlipSprite(TaskBlip, Sprite)
    SetBlipColour(TaskBlip, Color)
    SetBlipScale(TaskBlip, 0.7)
    SetBlipAsShortRange(TaskBlip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(Text)
    EndTextCommandSetBlipName(TaskBlip)
end

function ResetJail()
    InJail = false
    exports["mercy-ui"]:HideInteraction()
    PrisonJob = { Task = false, Info = '', Data = {} }
    -- PrisonJob = { Job = 'Electric', Info = 'Find Electric boxes and fix them.', Percent = 0, Entity = 0 }
    if DoesBlipExist(TaskBlip) then
        RemoveBlip(TaskBlip)
    end
end

function GetPrisonJob()
    return PrisonJob
end
exports("GetPrisonJob", GetPrisonJob)

function IsInJail()
    return InJail
end
exports("IsInJail", IsInJail)