PressingTime, Doingtimer = 5, false

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(4)
        if NetworkIsPlayerActive(PlayerId()) then  
            if LocalPlayer.state.LoggedIn then    
                if IsEntityDead(PlayerPedId()) and not Config.Dead then
                    PressingTime, Doingtimer = 5, false
                    Config.Dead, Config.Timer = true, 60
                    EventsModule.TriggerServer('mercy-hospital/server/set-dead-state', true)
                    TriggerEvent('mercy-hospital/client/do-dead-on-player', false)
                else
                    Citizen.Wait(200)
                end
            else
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then    
            if Config.Dead or Config.InHospitalBed then
                EnableControlAction(0, 1, true)
                EnableControlAction(0, 2, true)
                EnableControlAction(0, 38, true)
                EnableControlAction(0, 245, true)
                EnableControlAction(0, 288, true)
                EnableControlAction(0, 322, true)
                if (Config.Dead and Config.Timer > 0) and not Config.InHospitalBed then
                    DrawScreenText(0.5, 0.91, true, 'DEAD ~r~'..Config.Timer..'~s~ SECONDS REMAINING')
                elseif (Config.Dead and Config.Timer <= 0) and not Config.InHospitalBed then
                    DrawScreenText(0.5, 0.91, true, 'HOLD ~r~E~s~ ('..PressingTime..') TO ~r~RESPAWN~s~ OR WAIT FOR ~r~EMS~s~')
                end
            else
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- [ Events ] --

RegisterNetEvent('mercy-hospital/client/do-dead-on-player', function(Forced)
    TriggerEvent('mercy-phone/client/call-force-disconnect')
    TriggerEvent('mercy-grapple/client/used-grapple', true)
    TriggerEvent('mercy-inventory/client/force-close')
    TriggerEvent('mercy-inventory/client/reset-weapon')
    TriggerEvent('mercy-animations/client/reset-chair')
    TriggerEvent('mercy-police/client/reset-escort')
    TriggerEvent('mercy-phone/client/close-phone')

    TriggerEvent('mercy-hospital/client/on-player-death')

    if not Forced then
        while GetEntitySpeed(PlayerPedId()) > 0.7 do
            Citizen.Wait(10)
        end
    end
    local Coords = GetEntityCoords(PlayerPedId())
    NetworkResurrectLocalPlayer(Coords.x, Coords.y, Coords.z + 0.5, GetEntityHeading(PlayerPedId()), true, false)
    Citizen.Wait(50)
    ClearPedTasks(PlayerPedId())
    SetEntityHealth(PlayerPedId(), 200.0)
    SetEntityInvincible(PlayerPedId(), true)
    Citizen.Wait(450)
    FunctionModule.RequestAnimDict("missarmenian2")
    FunctionModule.RequestAnimDict("veh@low@front_ps@idle_duck")
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        TaskPlayAnim(PlayerPedId(), "veh@low@front_ps@idle_duck", "sit", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
    else
        TaskPlayAnim(PlayerPedId(), "missarmenian2", 'drunk_loop', 1.0, 1.0, -1, 1, 0, 0, 0, 0)
    end
    DoPlayerDeathTimer()
    DoPlayerAnimationLoop()
    Citizen.SetTimeout(1500, function()
        local StreetLabel = FunctionModule.GetStreetName()
        EventsModule.TriggerServer('mercy-ui/server/send-civ-injured', StreetLabel)
    end)
end)

RegisterNetEvent('mercy-hospital/client/revive', function(UseAnim)
    local UsingAnim = UseAnim ~= nil and UseAnim or false
    if Config.Dead then
        local Coords = GetEntityCoords(PlayerPedId())
        NetworkResurrectLocalPlayer(Coords.x, Coords.y, Coords.z + 0.05, GetEntityHeading(PlayerPedId()), true, false)
    end
    if UsingAnim then
        TriggerEvent('mercy-hospital/client/revive-anim')
    else
        ClearPedTasks(PlayerPedId())
    end
    SetPlayerSprint(PlayerId(), true)
    ClearPedBloodDamage(PlayerPedId())
    SetEntityHealth(PlayerPedId(), 200.0)
    SetEntityInvincible(PlayerPedId(), false)
    TriggerEvent('mercy-police/client/reset-escort')
    TriggerEvent('mercy-hospital/client/clear-wounds')
    TriggerEvent('mercy-hospital/client/clear-bleeding')
    EventsModule.TriggerServer('mercy-hospital/server/set-dead-state', false)
    PressingTime, Doingtimer = 5, false
    Config.InHospitalBed = false
    Config.Dead = false
end)

RegisterNetEvent('mercy-hospital/client/revive-anim', function()
    ClearPedTasks(PlayerPedId())
    Citizen.SetTimeout(250, function()
        FunctionModule.RequestAnimDict("random@crash_rescue@help_victim_up")
        TaskPlayAnim(PlayerPedId(), "random@crash_rescue@help_victim_up", "helping_victim_to_feet_victim", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
        Citizen.Wait(1850)
        ClearPedTasks(PlayerPedId())
        TriggerEvent('mercy-assets/client/set-my-walkstyle')
    end)
end)

-- [ Functions ] --

function IsDead()
    return Config.Dead
end
exports('IsDead', IsDead)

function IsTargetDead(ServerId)
    local IsDead = CallbackModule.SendCallback('mercy-hospital/server/is-serverid-dead', ServerId)
    return IsDead
end
exports('IsTargetDead', IsTargetDead)

function DoPlayerAnimationLoop()
    Citizen.CreateThread(function()
        while (Config.Dead and not Config.InHospitalBed) do
            Citizen.Wait(4)
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                if not IsEntityPlayingAnim(PlayerPedId(), "veh@low@front_ps@idle_duck", "sit", 3) then
                    TaskPlayAnim(PlayerPedId(), "veh@low@front_ps@idle_duck", "sit", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                else
                    Citizen.Wait(200)
                end
            else
                if not IsEntityPlayingAnim(PlayerPedId(), "missarmenian2", 'drunk_loop', 3) then
                    TaskPlayAnim(PlayerPedId(), "missarmenian2", 'drunk_loop', 1.0, 1.0, -1, 1, 0, 0, 0, 0)
                else
                    Citizen.Wait(200)
                end
            end
        end
        ClearPedTasks(PlayerPedId())
    end)
end

function DoPlayerDeathTimer()
    if Doingtimer then return end
    Doingtimer = true
    Citizen.CreateThread(function()
        while Doingtimer do
            Citizen.Wait(4)
            if Config.Timer > 0 then
                Config.Timer = Config.Timer - 1
                Citizen.Wait(1000)
            elseif Config.Timer <= 0 then
                if IsControlPressed(0, 38) then
                    if PressingTime > 0 then PressingTime = PressingTime - 1 end
                    Citizen.Wait(1000)
                    if PressingTime <= 0 then
                        if exports['mercy-police']:IsInJailZone() and exports['mercy-police']:IsInJail() then
                            TriggerEvent('mercy-hospital/client/revive', true)
                        else
                            TriggerEvent('mercy-hospital/client/try-send-to-bed', true)
                        end
                        Citizen.Wait(500)
                    end
                else
                    if PressingTime ~= 5 then PressingTime = 5 end
                end
            end
        end
    end)
end