

RegisterNetEvent('mercy-hospital/client/heal-player', function()
    local ClosestPlayer = PlayerModule.GetClosestPlayer(nil, 2.0)
    if not exports['mercy-inventory']:HasEnoughOfItem('ifak', 1) then 
        TriggerEvent('mercy-ui/client/notify', 'hospital-interaction-error', "An error occured! (You have no ifaks!)", 'error')
        return 
    end
    if ClosestPlayer['ClosestPlayerPed'] == -1 and ClosestPlayer['ClosestServer'] == -1 then
        TriggerEvent('mercy-ui/client/notify', 'hospital-interaction-error', "An error occured! (No one near!)", 'error')
        return
    end
    if not IsPedInAnyVehicle(ClosestPlayer['ClosestPlayerPed']) and not IsPedInAnyVehicle(PlayerPedId()) then
        TriggerEvent('mercy-assets/client/heal-animation', true)
        exports['mercy-ui']:ProgressBar('Healing..', 3000, false, false, false, true, function(DidComplete)
            if DidComplete then
                EventsModule.TriggerServer('mercy-hospital/server/heal-player', ClosestPlayer['ClosestServer'])
                local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', 'ifak', 1, false, true)
            end
            TriggerEvent('mercy-assets/client/heal-animation', false)
        end)
    end
end)

RegisterNetEvent('mercy-hospital/client/revive-player', function()
    local ClosestPlayer = PlayerModule.GetClosestPlayer(nil, 2.0)
    if not exports['mercy-inventory']:HasEnoughOfItem('ifak', 1) then 
        TriggerEvent('mercy-ui/client/notify', 'hospital-interaction-error', "An error occured! (You have no ifaks!)", 'error')
        return 
    end
    if ClosestPlayer['ClosestPlayerPed'] == -1 and ClosestPlayer['ClosestServer'] == -1 then
        TriggerEvent('mercy-ui/client/notify', 'hospital-interaction-error', "An error occured! (No one near!)", 'error')
        return
    end
    if not IsPedInAnyVehicle(ClosestPlayer['ClosestPlayerPed']) and not IsPedInAnyVehicle(PlayerPedId()) then
        TriggerEvent('mercy-assets/client/heal-animation', true)
        exports['mercy-ui']:ProgressBar('Reviving..', 4500, false, false, false, true, function(DidComplete)
            if DidComplete then
                EventsModule.TriggerServer('mercy-hospital/server/revive-player', ClosestPlayer['ClosestServer'])
                local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', 'ifak', 1, false, true)
            end
            TriggerEvent('mercy-assets/client/heal-animation', false)
        end)
    end
end)

RegisterNetEvent('mercy-hospital/client/take-blood', function()
    local ClosestPlayer = PlayerModule.GetClosestPlayer(nil, 2.0)
    if ClosestPlayer['ClosestPlayerPed'] == -1 and ClosestPlayer['ClosestServer'] == -1 then
        TriggerEvent('mercy-ui/client/notify', 'hospital-interaction-error', "An error occured! (No one near!)", 'error')
        return
    end
    if not IsPedInAnyVehicle(ClosestPlayer['ClosestPlayerPed']) and not IsPedInAnyVehicle(PlayerPedId()) then
        TriggerEvent('mercy-assets/client/heal-animation', true)
        exports['mercy-ui']:ProgressBar('Taking Blood..', 4500, false, false, false, true, function(DidComplete)
            if DidComplete then
                EventsModule.TriggerServer('mercy-hospital/server/take-blood', ClosestPlayer['ClosestServer'])
            end
            TriggerEvent('mercy-assets/client/heal-animation', false)
        end)
    end
end)

RegisterNetEvent("mercy-hospital/client/scan-blood", function()
    local Samples = CallbackModule.SendCallback('mercy-hospital/server/get-samples', 'blood-sample')
    if not Samples then 
        TriggerEvent('mercy-ui/client/notify', 'hospital-interaction-error', "An error occured! (You have no blood samples!)", 'error')
        return 
    end

    local SampleItems = {
        {
            ['Title'] = 'Scan Blood Sample',
            ['Desc'] = 'Choose a blood sample to scan',
            ['Data'] = {['Event'] = '', ['Type'] = ''},
        }
    }

    for SampleId, SampleData in pairs(Samples) do
        SampleItems[#SampleItems + 1] = {
            ['Title'] = 'Sample #'..SampleData.Info.Blood,
            ['Desc'] = 'Click to start blood scan',
            ['Data'] = {['Event'] = 'mercy-hospital/client/start-blood-scan', ['Type'] = 'Client', ['BloodData'] = SampleData.Info},
        }
    end
    if #SampleItems > 0 then 
        exports['mercy-ui']:OpenContext({
            ['MainMenuItems'] = SampleItems,
        })
    else
        TriggerEvent('mercy-ui/client/notify', 'hospital-interaction-error', "An error occured! (You have no blood samples!)", 'error')
    end
end)

RegisterNetEvent("mercy-hospital/client/start-blood-scan", function(Data)
    exports['mercy-ui']:ProgressBar('Scanning blood..', 14000, false, false, false, true, function(DidComplete)
        if DidComplete then
            EventsModule.TriggerServer('mercy-hospital/server/receive-result', Data['BloodData'])
        end
    end)
end)

RegisterNetEvent('mercy-hospital/client/stomach-pump', function()
    local ClosestPlayer = PlayerModule.GetClosestPlayer(nil, 2.0)
    if ClosestPlayer['ClosestPlayerPed'] == -1 and ClosestPlayer['ClosestServer'] == -1 then
        TriggerEvent('mercy-ui/client/notify', 'hospital-interaction-error', "An error occured! (No one near!)", 'error')
        return
    end
    if not IsPedInAnyVehicle(ClosestPlayer['ClosestPlayerPed']) and not IsPedInAnyVehicle(PlayerPedId()) then
        -- Pump pump pump pump
        TriggerEvent('mercy-assets/client/heal-animation', true)
        exports['mercy-ui']:ProgressBar('Pumping out stomach..', 12000, false, false, false, true, function(DidComplete)
            if DidComplete then
    
            end
            TriggerEvent('mercy-assets/client/heal-animation', false)
        end)
    end
end)