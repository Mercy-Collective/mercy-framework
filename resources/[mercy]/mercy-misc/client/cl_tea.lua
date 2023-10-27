local TeaZones = {
    vector4(-1428.94, -455.92, 35.90, 50.0), -- Hayes Repairs
    vector4(-586.91, -1061.92, 22.54, 270.0), -- UwU Cafe
    vector4(355.42, -1414.57, 32.51, 140.0), -- Crusade Hospital
    vector4(811.31, -764.41, 27.0, 0.0), -- Maldinis Pizza
    vector4(-580.9, -211.25, 38.53, 390.0), -- City Hall
}

function InitTea()
    for k, v in pairs(TeaZones) do
        exports['mercy-ui']:AddEyeEntry("tea_kettle_" .. k, {
            Type = 'Zone',
            SpriteDistance = 10.0,
            Distance = 1.5,
            State = false,
            ZoneData = {
                Center = vector3(v.x, v.y, v.z),
                Length = 0.8,
                Width = 0.6,
                Data = {
                    heading = v.w,
                    minZ = v.z - 0.3,
                    maxZ = v.z + 0.3
                },
            },
            Options = {
                {
                    Name = 'kettle',
                    Icon = 'fas fa-mug-hot',
                    Label = 'Put the boiler on',
                    EventType = 'Client',
                    EventName = 'mercy-misc/client/make-tea',
                    EventParams = { Coords = vector3(v.x, v.y, v.z) },
                    Enabled = function(Entity)
                        return true
                    end,
                }
            }
        })
    end
end

RegisterNetEvent("mercy-misc/client/make-tea", function(Data, Entity)
    local HasWater = exports['mercy-inventory']:HasEnoughOfItem('water', 1)
    if not HasWater then
        return exports['mercy-ui']:Notify("tea-water", "You need water for the boiler.")
    end

    TaskTurnPedToFaceCoord(PlayerPedId(), Data.Coords, 1000)
    Citizen.Wait(1000)

    exports['mercy-inventory']:SetBusyState(true)
    exports['mercy-ui']:ProgressBar('Making a cup of tea...', 30000, {
        ['AnimDict'] = 'anim@amb@business@coc@coc_unpack_cut@',
        ['AnimName'] = 'fullcut_cycle_v6_cokecutter',
        ['AnimFlag'] = 0,
    }, false, true, false, function(DidComplete)
        exports['mercy-inventory']:SetBusyState(false)
        StopAnimTask(PlayerPedId(), "anim@amb@business@coc@coc_unpack_cut@", "fullcut_cycle_v6_cokecutter", 1.0)
        if DidComplete then
            EventsModule.TriggerServer("mercy-misc/server/get-tea")
        end
    end)
end)

local IsDrinkingTea = false
RegisterNetEvent("mercy-misc/client/used-tea", function()
    if IsDrinkingTea then return end
    IsDrinkingTea = true

    local Drinks = 4

    local Removed = CallbackModule.SendCallback("mercy-base/server/remove-item", 'mugoftea', 1)
    if not Removed then return end

    exports['mercy-ui']:Notify("take-tea", "Use E to sip tea")
    exports['mercy-assets']:AttachProp('Tea')

    while not HasAnimDictLoaded("amb@world_human_drinking@coffee@male@idle_a") do
        RequestAnimDict("amb@world_human_drinking@coffee@male@idle_a")
        Citizen.Wait(0)
    end

    Citizen.CreateThread(function()
        while IsDrinkingTea do
            if not IsEntityPlayingAnim(PlayerPedId(), "amb@world_human_drinking@coffee@male@idle_a", "idle_c", 3) then
                TaskPlayAnim(PlayerPedId(), "amb@world_human_drinking@coffee@male@idle_a", "idle_c", 1.0, 0.1, -1, 49, 0, 0, 0, 0)
            end

            -- Sip
            if IsControlJustPressed(0, 38) then -- E
                if Drinks <= 0 then
                    exports['mercy-ui']:Notify("empty-tea", "Cup of tea is empty..")
                    goto Skip
                end

                Drinks = Drinks - 1
                TaskPlayAnim(PlayerPedId(), "amb@world_human_drinking@coffee@male@idle_a", "idle_b", 1.0, 0.1, -1, 50, 0, 0, 0, 0)
                TriggerServerEvent("mercy-base/server/set-meta-data", "Water", PlayerModule.GetPlayerData().MetaData.Water + 5)

                ::Skip::

                Citizen.Wait(5500)
            end

            -- Cancel
            if IsControlJustPressed(0, 73) then -- X
                IsDrinkingTea = false
            end

            Citizen.Wait(4)
        end

        StopAnimTask(PlayerPedId(), "amb@world_human_drinking@coffee@male@idle_a", "idle_c", 1.0)
        exports['mercy-assets']:RemoveProps()
    end)
end)