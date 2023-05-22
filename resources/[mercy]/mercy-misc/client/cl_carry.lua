local Carrying, Carried = false, false

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            if Carrying or Carried then
                if Carrying then
                    if not IsEntityPlayingAnim(PlayerPedId(), 'missfinale_c2mcs_1', 'fin_c2_mcs_1_camman', 3) then
                        TaskPlayAnim(PlayerPedId(), 'missfinale_c2mcs_1', 'fin_c2_mcs_1_camman', 8.0, -8.0, -1, 49, 0, false, false, false)
                    end
                    if IsControlJustPressed(0, 38) then
                        TriggerServerEvent('mercy-misc/server/stop-carry')
                        exports['mercy-ui']:HideInteraction()
                        ClearPedTasks(PlayerPedId())
                        Carrying = false
                    end
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

RegisterNetEvent('mercy-misc/client/try-carry', function()
    local ClosestPlayer = PlayerModule.GetClosestPlayer(nil, 2.0)
    if Carrying or Carried then return end
    if ClosestPlayer['ClosestPlayerPed'] == -1 and ClosestPlayer['ClosestServer'] == -1 then
        TriggerEvent('mercy-ui/client/notify', 'interaction-error', "An error occured! (No one near!)", 'error')
        return
    end
    if not IsPedInAnyVehicle(PlayerPedId()) and not IsPedInAnyVehicle(ClosestPlayer['ClosestPlayerPed']) then
        TriggerEvent('mercy-ui/client/notify', 'carry', "Press E to stop carrying.", 'primary', 10000)
        TriggerServerEvent('mercy-misc/server/carry-target', ClosestPlayer['ClosestServer'])
        exports['mercy-ui']:SetInteraction('[E] Drop', 'primary')
        RequestCarryAnims(false)
        Carrying = true
    end
end)

RegisterNetEvent('mercy-misc/client/getting-carried', function(Source)
    local TargetPed = GetPlayerPed(GetPlayerFromServerId(Source))
    AttachEntityToEntity(PlayerPedId(), TargetPed , 1, -0.68, -0.2, 0.94, 180.0, 180.0, 60.0, 1, 1, 0, 1, 0, 1)
    exports['mercy-inventory']:SetBusyState(true)
    TaskTurnPedToFaceEntity(PlayerPedId(), TargetPed, 1.0)
    SetPedKeepTask(PlayerPedId(), true)
    RequestCarryAnims(true)
    Carried = true
end)

RegisterNetEvent('mercy-misc/client/stop-carry', function()
    exports['mercy-inventory']:SetBusyState(false)
    DetachEntity(PlayerPedId(), true, false)
    ClearPedTasks(PlayerPedId())
    Carried, Carrying = false, false
end)

-- [ Functions ] --

function RequestCarryAnims(PlayCarried)
    FunctionsModule.RequestAnimDict('amb@world_human_bum_slumped@male@laying_on_left_side@base')
    FunctionsModule.RequestAnimDict('missfinale_c2mcs_1')
    FunctionsModule.RequestAnimDict('dead')
    if PlayCarried then
        TaskPlayAnim(PlayerPedId(), "dead", "dead_f", 8.0, 8.0, -1, 1, 0, 0, 0, 0)
        TaskPlayAnim(PlayerPedId(), "amb@world_human_bum_slumped@male@laying_on_left_side@base", "base", 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
    end
end