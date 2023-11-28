local SupportedModels, SupportedGogglesModels = {[GetHashKey('mp_f_freemode_01')] = 4, [GetHashKey('mp_m_freemode_01')] = 7}, {[GetHashKey('mp_f_freemode_01')] = 115, [GetHashKey('mp_m_freemode_01')] = 116}
FunctionsModule, VehicleModule, CallbackModule, EventsModule = nil, nil, nil, nil
local UsingMegaPhone, FastfoodCombo, DoingFastfoodTimeout = false, 0, false
local HairTied, NightVisonActive, HairSyles, GogglesStyles = false, false, nil, nil
local CurrentBuffItems = {}
DoingBinoculars, DoingPDCamera, RemovingStress = false, false, false

AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
        'Callback',
        'Functions',
        'Events',
        'Vehicle',
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        VehicleModule = exports['mercy-base']:FetchModule('Vehicle')
    end)
end)

RegisterNetEvent('mercy-base/client/on-logout', function()
    RemovingStress = false
    DoingBinoculars = false
    DoingPDCamera = false
    DoingFastfoodTimeout = false
    HairTied, HairSyles = false, nil
    NightVisonActive, GogglesStyles = false, nil
end)

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            for k, v in pairs(CurrentBuffItems) do
                if CurrentBuffItems[k] - 1 > 0 then
                    CurrentBuffItems[k] = CurrentBuffItems[k] - 1
                else
                    CurrentBuffItems[k] = nil
                    TriggerClientEvent('mercy-items/client/do-food-buff', k, false)
                end
            end
            Citizen.Wait((1000 * 60) * 1)
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn and UsingMegaPhone then
            if not IsEntityPlayingAnim(PlayerPedId(), "amb@world_human_mobile_film_shocking@female@base", "base", 3) then
                FunctionsModule.RequestAnimDict("amb@world_human_mobile_film_shocking@female@base")
                TaskPlayAnim(PlayerPedId(), 'amb@world_human_mobile_film_shocking@female@base', 'base', 1.0, 1.0, GetAnimDuration('amb@world_human_mobile_film_shocking@female@base', 'base'), 49, 0, 0, 0, 0)
            end
            Citizen.Wait(1000)
        else
            Citizen.Wait(450)
        end
    end
end)

-- [ Events ] --

RegisterNetEvent('mercy-items/client/used-food', function(ItemData, PropName)
    Citizen.SetTimeout(450, function()
        exports['mercy-inventory']:SetBusyState(true)
        exports['mercy-ui']:ProgressBar('Eating..', 5000, {['AnimName'] = 'mp_player_int_eat_burger', ['AnimDict'] = 'mp_player_inteat@burger', ['AnimFlag'] = 49}, PropName, false, true, function(DidComplete)
            exports['mercy-inventory']:SetBusyState(false)
            if DidComplete then
                local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', ItemData.ItemName, 1, false, true)
                if DidRemove then
                    if Config.Fruits[ItemData.ItemName] ~= nil and Config.Fruits[ItemData.ItemName] then
                        EventsModule.TriggerServer('mercy-items/server/add-food', Config.Fruits[ItemData.ItemName]['Food'])
                        EventsModule.TriggerServer('mercy-items/server/add-water', Config.Fruits[ItemData.ItemName]['Water'])
                    else
                        EventsModule.TriggerServer('mercy-items/server/add-food', math.random(25, 30))
                    end
                    if Config.SpecialFood[ItemData.ItemName] ~= nil and Config.SpecialFood[ItemData.ItemName] then
                        DoSpecial(ItemData.ItemName)
                    end
                    if Config.BuffItems[ItemData.ItemName] ~= nil and Config.BuffItems[ItemData.ItemName] then
                        DoItemBuff(ItemData.ItemName)
                    end
                    if Config.FastFood[ItemData.ItemName] ~= nil and Config.FastFood[ItemData.ItemName] then
                        DoFastFoodShit()
                    end
                end
            end
        end)
    end)
end)

RegisterNetEvent('mercy-items/client/used-water', function(ItemData, PropName)
    Citizen.SetTimeout(450, function()
        exports['mercy-inventory']:SetBusyState(true)
        exports['mercy-ui']:ProgressBar('Drinking..', 5000, {['AnimName'] = 'idle_c', ['AnimDict'] = 'amb@world_human_drinking@coffee@male@idle_a', ['AnimFlag'] = 49}, PropName, false, true, function(DidComplete)
            if DidComplete then
                local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', ItemData.ItemName, 1, false, true)
                if DidRemove then
                    EventsModule.TriggerServer('mercy-items/server/add-water', math.random(25, 30))
                    if Config.SpecialWater[ItemData.ItemName] ~= nil and Config.SpecialWater[ItemData.ItemName] then
                        DoSpecial(ItemData.ItemName)
                    end
                    if Config.BuffItems[ItemData.ItemName] ~= nil and Config.BuffItems[ItemData.ItemName] then
                        DoItemBuff(ItemData.ItemName)
                    end
                end
            end
            exports['mercy-inventory']:SetBusyState(false)
        end)
    end)
end)

RegisterNetEvent('mercy-items/client/used-bandage', function(IsIfak)
    Citizen.SetTimeout(450, function()
        exports['mercy-inventory']:SetBusyState(true)
        exports['mercy-ui']:ProgressBar(IsIfak and 'Applying Ifak..' or 'Healing..', 3000, {['AnimName'] = 'idle_c', ['AnimDict'] = 'amb@world_human_clipboard@male@idle_a', ['AnimFlag'] = 49}, nil, false, true, function(DidComplete)
            if DidComplete then
                local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', IsIfak and 'ifak' or 'bandage', 1, false, true)
                if DidRemove then
                    Citizen.SetTimeout(1500, function()
                        for i = 1, 6 do
                            Citizen.Wait(3500)
                            local CurrentHealth = GetEntityHealth(PlayerPedId())
                            local NewHealth = CurrentHealth + 4 > 200 and 200 or CurrentHealth + 4
                            SetEntityHealth(PlayerPedId(), NewHealth)

                        end
                        if IsIfak then
                            TriggerEvent('mercy-hospital/client/clear-wounds')
                            if exports['mercy-hospital']:IsPlayerBleeding() then
                                TriggerEvent('mercy-hospital/client/clear-bleeding')
                            end
                        else
                            TriggerEvent('mercy-hospital/client/decrease-wounds')
                            if exports['mercy-hospital']:IsPlayerBleeding() then
                                TriggerEvent('mercy-hospital/client/clear-bleeding')
                            end
                        end
                    end)
                end
            end
            exports['mercy-inventory']:SetBusyState(false)
        end)
    end)
end)

RegisterNetEvent('mercy-items/client/used-chest-armor', function(ItemName)
    Citizen.SetTimeout(450, function()
        exports['mercy-inventory']:SetBusyState(true)
        exports['mercy-ui']:ProgressBar('Armor..', 5000, {['AnimName'] = 'idle_c', ['AnimDict'] = 'amb@world_human_clipboard@male@idle_a', ['AnimFlag'] = 49}, nil, false, true, function(DidComplete)
            if DidComplete then
                local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', ItemName, 1, false, true)
                if DidRemove then
                    local CurrentArmor = GetPedArmour(PlayerPedId())
                    local NewArmor = CurrentArmor + 75 > 100 and 100 or CurrentArmor + 75
                    SetPedArmour(PlayerPedId(), NewArmor)
                end
                TriggerEvent('mercy-hospital/client/save-vitals')
            end
            exports['mercy-inventory']:SetBusyState(false)
        end)
    end)
end)

RegisterNetEvent('mercy-items/client/used-megaphone', function()
    Citizen.SetTimeout(1000, function()
        if not UsingMegaPhone then
            UsingMegaPhone = true
            exports['mercy-assets']:AttachProp('Megaphone')
            FunctionsModule.RequestAnimDict("amb@world_human_mobile_film_shocking@female@base")
            TaskPlayAnim(PlayerPedId(), 'amb@world_human_mobile_film_shocking@female@base', 'base', 1.0, 1.0, GetAnimDuration('amb@world_human_mobile_film_shocking@female@base', 'base'), 49, 0, 0, 0, 0)
            TriggerServerEvent("mercy-voice/server/transmission-state", 'Megaphone', true)
            TriggerEvent('mercy-voice/client/proximity-override', "Megaphone", 3, 15.0, 2)
        else
            UsingMegaPhone = false
            exports['mercy-assets']:RemoveProps('Megaphone')
            StopAnimTask(PlayerPedId(), 'amb@world_human_mobile_film_shocking@female@base', 'base', 1.0)
            TriggerServerEvent("mercy-voice/server/transmission-state", 'Megaphone', false)
            TriggerEvent('mercy-voice/client/proximity-override', "Megaphone", 3, -1, -1)
        end
    end)
end)

RegisterNetEvent('mercy-items/client/used-lawnchair', function()
    Citizen.SetTimeout(450, function()
        if IsEntityPlayingAnim(PlayerPedId(), "timetable@ron@ig_3_couch", "base", 3) then
            TriggerEvent('mercy-animations/client/clear-animation')
        else
            TriggerEvent('mercy-animations/client/play-animation', 'lawnchair')
            exports['mercy-assets']:AttachProp('Lawnchair')
        end
    end)
end)

RegisterNetEvent('mercy-items/client/used-wheelchair', function()
    Citizen.SetTimeout(450, function()
        if not IsPedInAnyVehicle(PlayerPedId()) then
            exports['mercy-inventory']:SetBusyState(true)
            exports['mercy-ui']:ProgressBar('Wheelchair..', 1000, {}, nil, false, true, function(DidComplete)
                if DidComplete then
                    exports['mercy-inventory']:SetBusyState(false)
                    local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', 'wheelchair', 1, false, true)
                    if DidRemove then
                        local PlayerCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 0.75, 0) GetEntityCoords(PlayerPedId())
                        local VehicleCoords = { ['X'] = PlayerCoords.x, ['Y'] = PlayerCoords.y, ['Z'] = PlayerCoords.z, ['Heading'] = GetEntityHeading(PlayerPedId()) }
                        local Vehicle = VehicleModule.SpawnVehicle('wheelchair', VehicleCoords, nil, false)
                        if Vehicle ~= nil then
                            Citizen.SetTimeout(500, function()
                                local Plate = GetVehicleNumberPlateText(Vehicle['Vehicle'])
                                exports['mercy-vehicles']:SetVehicleKeys(Plate, true, false)
                                exports['mercy-vehicles']:SetFuelLevel(Vehicle['Vehicle'], 100)
                            end)
                        end
                    end
                else
                    exports['mercy-inventory']:SetBusyState(false)
                end
            end)
        else
            exports['mercy-ui']:Notify("item-error", "Failed attempt..", 'error')
        end
    end)
end)

RegisterNetEvent('mercy-items/client/used-present', function()
    Citizen.SetTimeout(450, function()
        exports['mercy-inventory']:SetBusyState(true)
        exports['mercy-ui']:ProgressBar('Unwrapping..', 5000, false, false, false, true, function(DidComplete)
            exports['mercy-inventory']:SetBusyState(false)
            if DidComplete then
                local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', 'present', 1, false, true)
                if DidRemove then
                    EventsModule.TriggerServer('mercy-items/server/receive-present-items')
                end
            end
        end)
    end)
end)

RegisterNetEvent('mercy-items/client/used-toolbox', function()
    Citizen.SetTimeout(450, function()
        local Entity, EntityType, EntityCoords = FunctionsModule.GetEntityPlayerIsLookingAt(3.0, 0.2, 286, PlayerPedId())
        if EntityType == 2 then
            VehicleModule.SetVehicleDoorOpen(Entity, 4)
            local Outcome = exports['mercy-ui']:StartSkillTest(1, { 1, 5 }, { 12000, 18000 }, false)
            if Outcome then
                local CurrentEngineHealth = GetVehicleEngineHealth(Entity)
                local NewEngineHealth = CurrentEngineHealth + 250.0 < 1000.0 and CurrentEngineHealth + 250.0 or 1000.0
                SetVehicleEngineHealth(Entity, NewEngineHealth)
            else
                TriggerEvent('mercy-ui/client/notify', "item-error", "Failed attempt..", 'error')
            end
            SetVehicleDoorShut(Entity, 4, false)
        else
            TriggerEvent('mercy-ui/client/notify', "item-error", "No vehicle found..", 'error')
        end
    end)
end)

RegisterNetEvent('mercy-items/client/used-tirekit', function()
    Citizen.SetTimeout(450, function()
        local Entity, EntityType, EntityCoords = FunctionsModule.GetEntityPlayerIsLookingAt(3.0, 0.2, 286, PlayerPedId())
        if EntityType == 2 then
            local Outcome = exports['mercy-ui']:StartSkillTest(1, { 1, 5 }, { 12000, 18000 }, false)
            if Outcome then
                for i = 0, 7, 1 do
                    if i == 6 then
                        VehicleModule.SetTyreHealth(Entity, 45, 1000.0) -- 6 wheels car
                        VehicleModule.SetVehicleTyreFixed(Entity, 45) -- 6 wheels car
                    elseif i == 7 then
                        VehicleModule.SetTyreHealth(Entity, 47, 1000.0) -- 6 wheels car
                        VehicleModule.SetVehicleTyreFixed(Entity, 47) -- 6 wheels car
                    else
                        VehicleModule.SetTyreHealth(Entity, i, 1000.0)
                        VehicleModule.SetVehicleTyreFixed(Entity, i)
                    end
                end
            else
                TriggerEvent('mercy-ui/client/notify', "item-error", "Failed attempt..", 'error')
            end
        else
            TriggerEvent('mercy-ui/client/notify', "item-error", "No vehicle found..", 'error')
        end
    end)
end)

RegisterNetEvent('mercy-items/client/used-carpolish', function()
    Citizen.SetTimeout(450, function()
        local Entity, EntityType, EntityCoords = FunctionsModule.GetEntityPlayerIsLookingAt(3.0, 0.2, 286, PlayerPedId())
        if Entity == 0 or Entity == -1 or EntityType ~= 2 then 
            TriggerEvent('mercy-ui/client/notify', "item-error", "No vehicle found..", 'error') 
            return 
        end
        exports['mercy-inventory']:SetBusyState(true)
        TriggerEvent('mercy-animations/client/play-animation', 'cleaning')
        exports['mercy-ui']:ProgressBar('Cleaning Vehicle..', 6500, false, false, false, true, function(DidComplete)
            if DidComplete then
                local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', 'car-polish', 1, false, true)
                if DidRemove then
                    VehicleModule.SetVehicleDirtLevel(Entity, 0.0)
                end
            end
            TriggerEvent('mercy-animations/client/clear-animation')
            exports['mercy-inventory']:SetBusyState(false)
        end)
    end)
end)


RegisterNetEvent("mercy-items/client/use-hairtie", function()
    local HairValue = SupportedModels[GetEntityModel(PlayerPedId())]
    if HairValue == nil then return end
    Citizen.SetTimeout(750, function()
        TriggerEvent('mercy-animations/client/play-animation', 'hairtie')
        Citizen.SetTimeout(1700, function()
            if not HairTied then
                local HairDraw, HairTexture, HairPallete = GetPedDrawableVariation(PlayerPedId(), 2), GetPedTextureVariation(PlayerPedId(), 2), GetPedPaletteVariation(PlayerPedId(), 2)
                SetPedComponentVariation(PlayerPedId(), 2, HairValue, HairTexture, HairPallete)
                HairTied, HairSyles = true, {HairDraw, HairTexture, HairPallete}
            else
                SetPedComponentVariation(PlayerPedId(), 2, HairSyles[1], HairSyles[2], HairSyles[3])
                HairTied, HairSyles = false, nil
            end
        end)
    end)
end)

local UsingHairspray = false
RegisterNetEvent("mercy-items/client/use-hairspray", function()
    if UsingHairspray then return end
    UsingHairspray = true
    Citizen.SetTimeout(750, function()
        exports['mercy-assets']:AttachProp('Spray')
        TriggerEvent('mercy-animations/client/play-animation', 'hairtie')
        Citizen.SetTimeout(800, function()
            TriggerEvent('mercy-ui/client/play-sound', 'spray', 0.55)
            Citizen.Wait(900)
            exports['mercy-assets']:RemoveProps('Spray')
            TriggerEvent('mercy-clothing/client/set-hair-color', math.random(1, 56))
            UsingHairspray = false
        end)
    end)
end)

RegisterNetEvent("mercy-items/client/use-nightvison", function()
    local GogglesValue = SupportedGogglesModels[GetEntityModel(PlayerPedId())]
    if GogglesValue == nil then return end
    Citizen.SetTimeout(750, function()
        TriggerEvent('mercy-animations/client/play-animation', 'hairtie')
        Citizen.SetTimeout(1000, function()
            NightVisonActive = not NightVisonActive
            SetNightvision(NightVisonActive)
            if NightVisonActive then
                GogglesStyles = {Prop = GetPedPropIndex(PlayerPedId(), 0), Texture = GetPedPropTextureIndex(PlayerPedId(), 0)}
                SetPedPropIndex(PlayerPedId(), 0, GogglesValue, 0, true)
            else
                ClearPedProp(PlayerPedId(), 0)
                SetPedPropIndex(PlayerPedId(), 0, GogglesStyles.Prop, GogglesStyles.Texture, true)
                GogglesStyles = nil
            end
        end)
    end)
end)

-- [ Functions ] --

function DoSpecial(ItemName)
    Citizen.CreateThread(function()
        if ItemName == 'heartstopper' or ItemName == 'moneyshot' then
            EventsModule.TriggerServer('mercy-items/server/add-food', math.random(5, 16))
            if not exports['mercy-police']:IsStatusAlreadyActive('wellfed') then
                TriggerEvent('mercy-police/client/evidence/set-status', 'wellfed', 210)
            end
        elseif ItemName == 'milkshake' or ItemName == 'slushy' then
            EventsModule.TriggerServer('mercy-ui/server/set-stress', 'Remove', math.random(10, 20))
        end
    end)
end

function DoItemBuff(ItemName)
    if CurrentBuffItems[ItemName] ~= nil then
        CurrentBuffItems[ItemName] = 30
        TriggerEvent('mercy-items/client/do-food-buff', ItemName, true)
    else
        -- Print Buff is already active
    end
end

function DoFastFoodShit()
    local Puking = exports['mercy-assets']:IsPuking()
    if not Puking then
        FastfoodCombo = FastfoodCombo + 1
        if FastfoodCombo >= 3 and not Puking then

            TriggerServerEvent('mercy-assets/server/toggle-effect', GetPlayerServerId(PlayerId()), 'Puke', 5000, true)
        end
        if FastfoodCombo > 0 and not DoingFastfoodTimeout then
            DoingFastfoodTimeout = true
            Citizen.SetTimeout(20000, function()
                FastfoodCombo, DoingFastfoodTimeout = 0, false
            end)
        end
    end
end
