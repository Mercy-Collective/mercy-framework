local Dancing, FunctionsModule = false, nil

RegisterNetEvent('mercy-base/client/on-login', function()
	Citizen.SetTimeout(500, function()
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
	end)
end)

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            if Dancing then
                if IsControlJustReleased(0, 73) then
                    TriggerEvent('mercy-dances/client/clear-dance')
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

RegisterNetEvent('mercy-dances/client/clear-dance', function()
    ClearPedTasks(PlayerPedId())
    Dancing = false
end)

RegisterNetEvent('mercy-dances/client/dance', function(DanceNumber)
    local TotalAnims = #Config.Dances
    if DanceNumber == -1 then
        DanceNumber = math.random(TotalAnims)
        print('Random Dance', DanceNumber)
    end
    if DanceNumber > TotalAnims or DanceNumber <= 0 then return end
    if not Config.Dances[DanceNumber]['Disabled'] then
        Dancing = true
        FunctionsModule.RequestAnimDict(Config.Dances[DanceNumber]['Dict'])
        TaskPlayAnim(PlayerPedId(), Config.Dances[DanceNumber]['Dict'], Config.Dances[DanceNumber]['Anim'], 3.0, 3.0, -1, 1, 0, 0, 0, 0)
    end
end)
