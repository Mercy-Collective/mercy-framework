ActiveSprays = {}
local SprayObject = nil
local AlphaStages = {
    [1] = 104,
    [2] = 156,
    [3] = 208,
    [4] = 255,
}
local CurrentAlpha = 0
local DoingProgress = false

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            local PlayerCoords = GetEntityCoords(PlayerPedId())

            if Config.Sprays == nil then Config.Sprays = {} end

            for k, v in ipairs(Config.Sprays) do
                if k % 100 == 0 then
                    Citizen.Wait(0)
                end

                if #(PlayerCoords - vector3(v.Coords.X, v.Coords.Y, v.Coords.Z)) <= 50.0 then
                    if not ActiveSprays[v.Id] then
                        local Entity = CreateSpray(v.Coords, v.Type, v.Id)
                        ActiveSprays[v.Id] = {
                            Object = Entity,
                        }
                    end
                else
                    RemoveSpray(v.Id)
                end
            end

            Citizen.Wait(3500)
        else
            Citizen.Wait(450)
        end
    end
end)

-- [ Events ] --

RegisterNetEvent("mercy-misc/client/sprays/use", function(Item, Type)
    EntityModule.DoEntityPlacer(Type, 4.5, false, false, nil, function(DidPlace, Coords, Heading)
        if not DidPlace then
            return exports['mercy-ui']:Notify("spray-error", "You stopped placing the spray, or something went wrong..", "error")
        end

        local DidRemove = CallbackModule.SendCallback("mercy-base/server/remove-item", Item, 1, false, true)
        if DidRemove then
            local NewId = #Config.Sprays + 1
            exports['mercy-ui']:AddEyeEntry("spray-"..NewId, {
                Type = 'Model',
                Model = Type, 
                SpriteDistance = 10.0,
                Distance = 5.0,
                Options = {
                    {
                        Name = 'spray-removal',
                        Icon = 'fas fa-trash',
                        Label = "Remove Spray",
                        EventType = 'Server',
                        EventName = 'mercy-misc/server/sprays/try-remove',
                        EventParams = {
                            Id = NewId,
                        },
                        Enabled = function(Entity)
                            return exports['mercy-inventory']:HasEnoughOfItem('scrubbingcloth', 1)
                        end,
                    },
                }
            })
            EventsModule.TriggerServer('mercy-misc/server/spray-place', Coords, Heading, Type)
        end
    end)
end)

RegisterNetEvent("mercy-misc/client/sprays/remove", function(Id)
    exports['mercy-inventory']:SetBusyState(true)
    TriggerEvent('mercy-animations/client/play-animation', 'cleaning')
    exports['mercy-ui']:ProgressBar('Scrubbing of paint...', math.random(12000, 16000), false, false, true, true, function(DidComplete)
        if DidComplete then
            TriggerServerEvent('mercy-misc/server/sprays/remove', Id)
            exports['mercy-ui']:Notify("spray-started", "You have finished scrubbing of the paint!", "success")
        else
            exports['mercy-ui']:Notify("spray-stopped", "You stopped scrubbing of the paint!", "error")
        end
        TriggerEvent('mercy-animations/client/clear-animation')
        exports['mercy-inventory']:SetBusyState(false)
    end) 
end)

RegisterNetEvent("mercy-misc/client/sync-sprays", function(Data, Remove, Id)
    if Remove ~= nil and Remove then
        RemoveSpray(Data.Id)
        Config.Sprays[Id] = nil
    else
        Config.Sprays[#Config.Sprays + 1] = Data
    end
end)

-- [ Functions ] --

function CreateSpray(Coords, Type, Id)
    SprayObject = EntityModule.CreateEntity(Type, vector3(Coords.X, Coords.Y, Coords.Z), true)
    if SprayObject then
        FreezeEntityPosition(SprayObject, true)
        SetEntityHeading(SprayObject, Coords.H + 0.0)
        return SprayObject
    else
        return false
    end
end

RegisterNetEvent("mercy-misc/client/done-placing-spray", function(Id)
    while SprayObject == nil do
        Wait(100)
    end
    StartProgressPaint(SprayObject, Id)
    StartDrawingPaint(SprayObject, Id)
end)

function StartProgressPaint(SprayObject, Id)
    SetEntityAlpha(SprayObject, 0, false)
    DoingProgress = true
    exports['mercy-inventory']:SetBusyState(true)
    exports['mercy-assets']:AttachProp('SprayCan')
    exports['mercy-ui']:ProgressBar('Spraying...', 25000, {
        ['AnimName'] = 'weed_spraybottle_stand_spraying_01_inspector', 
        ['AnimDict'] = 'anim@amb@business@weed@weed_inspecting_lo_med_hi@', 
        ['AnimFlag'] = 16
    }, nil, true, false, function(DidComplete)
        DoingProgress = false
        exports['mercy-inventory']:SetBusyState(false)
        exports['mercy-assets']:RemoveProps()
        ClearPedTasks(PlayerPedId())
        SetTimeout(1000, function()
            ClearPedTasksImmediately(PlayerPedId())
        end)
        if DidComplete then
            exports['mercy-ui']:Notify("spray-started", "You have finished spraying the object!", "success")
        else
            exports['mercy-ui']:Notify("spray-stopped", "You stopped spraying the object!", "error")
        end
    end) 
end

function StartDrawingPaint(SprayObject)
    while DoingProgress do
        SprayEffects()
        CurrentAlpha = CurrentAlpha + 1
        SetEntityAlpha(SprayObject, AlphaStages[CurrentAlpha], false)
        TaskTurnPedToFaceEntity(PlayerPedId(), SprayObject, -1)
        if CurrentAlpha == 4 then
            break
        end
        Wait(6250)
    end
    SetEntityAlpha(SprayObject, 255, false)
    CurrentAlpha = 0
end

function RemoveSpray(SprayId)
    if ActiveSprays[SprayId] then
        EntityModule.DeleteEntity(ActiveSprays[SprayId]['Object'])
        ActiveSprays[SprayId] = nil
    end
end

function SprayEffects()
    local dict = "scr_recartheft"
    local name = "scr_wheel_burnout"
    local ped = PlayerPedId()
    local fwd = GetEntityForwardVector(ped)
    local coords = GetEntityCoords(ped) + fwd * 0.5 + vector3(0.0, 0.0, -0.5)

	RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do
        Citizen.Wait(0)
	end

	local pointers = {}
    local color = {255, 255, 255}
    local heading = GetEntityHeading(ped)
    UseParticleFxAssetNextCall(dict)
    SetParticleFxNonLoopedColour(color[1] / 255, color[2] / 255, color[3] / 255)
    SetParticleFxNonLoopedAlpha(1.0)
    local ptr = StartNetworkedParticleFxNonLoopedAtCoord( name, coords.x, coords.y, coords.z + 2.0, 0.0, 0.0, heading, 0.7, 0.0, 0.0, 0.0 )
    RemoveNamedPtfxAsset(dict)
end