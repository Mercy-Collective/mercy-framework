local NextMeleeAction, NextStabbingAction, NextShootingAction = GetCloudTimeAsInt(), GetCloudTimeAsInt(), GetCloudTimeAsInt()
local Evidence, EvidenceEnabled, CanCollect, CurrentStatusList = {}, false, true, {}

local StatusList = {
    ['fight'] = {Text = 'Red Hands', Show = true},
    ['redeyes'] = {Text = 'Red Eyes', Show = true},
    ['sweat'] = {Text = 'Body Sweat', Show = true},
    ['confused'] = {Text = 'Confused', Show = false},
    ['widepupils'] = {Text = 'Wide Pupils', Show = true},
    ['sworebody'] = {Text = 'Painful Body', Show = false},
    ['wellfed'] = {Text = 'Looks Well Fed', Show = true},
    ['huntbleed'] = {Text = 'Bloody Hands', Show = true},
    ['gasoline'] = {Text = 'Smells like Gasoline', Show = true},
    ['heavybreath'] = {Text = 'Labored Breathing', Show = false},
    ['chemicals'] = {Text = 'Smells of Chemicals', Show = false},
    ['weedsmell'] = {Text = 'Smells Like Marijuana', Show = true},
    ['gunpowder'] = {Text = 'Gunpowder Residue', Show = false},
    ['alcohol'] = {Text = 'Breath smells like Alcohol', Show = false},
    ['heavyalcohol'] = {Text = 'Breath smells very much like alcohol', Show = true},
    ['explosive'] = {Text = 'Traces of plastic and explosives residue', Show = false},
}

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn and PlayerData ~= nil and PlayerData.Job ~= nil then
            if PlayerData.Job.Name == 'police' and PlayerData.Job.Duty then
                if exports['mercy-items']:IsInPDCam() or (IsPlayerFreeAiming(PlayerId()) and GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("WEAPON_FLASHLIGHT")) then
                    if not EvidenceEnabled then
                        EvidenceEnabled = true
                        DoEvidenceLoop()
                    end
                else
                    if EvidenceEnabled then
                        EvidenceEnabled = false
                    end
                    Citizen.Wait(450)
                end
            else
                Citizen.Wait(450)
            end
        else
            Citizen.Wait(450)
        end
    end
end)

CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn and CurrentStatusList ~= nil then
            for k, v in pairs(CurrentStatusList) do
                if v.Time - 5 > 0 then
                    v.Time = v.Time - 5
                else
                    table.remove(CurrentStatusList, k)
                end
                TriggerServerEvent('mercy-police/server/evidence/set-status', CurrentStatusList)
            end
            Citizen.Wait(5000)
        else
            Citizen.Wait(450)
        end
    end
end)

-- [ Events ] --

AddEventHandler('gameEventTriggered', function(Name, Args)
    local IsSelfAttacker = (Args[2] == PlayerPedId() and true or false)
    local IsMeleeAttack = (Args[7] == GetHashKey('weapon_unarmed') and true or false)
    if Name == "CEventNetworkEntityDamage" and IsMeleeAttack and IsSelfAttacker and GetCloudTimeAsInt() > NextMeleeAction then
        local VictimIsPlayer = IsPedAPlayer(Args[1])
        if math.random(1, 100) < 30 then
            local StreetLabel = FunctionModule.GetStreetName()
            EventsModule.TriggerServer('mercy-ui/server/send-fighting-progress', StreetLabel, false)
            NextMeleeAction = GetCloudTimeAsInt() + 135
        end
    end
    if Name == "CEventNetworkEntityDamage" and IsPedArmed(PlayerPedId(), 1) and IsSelfAttacker and GetCloudTimeAsInt() > NextStabbingAction then
        local StreetLabel = FunctionModule.GetStreetName()
        if  math.random(1, 100) < 30 then
            EventsModule.TriggerServer('mercy-ui/server/send-fighting-progress', StreetLabel, true)
            NextStabbingAction = GetCloudTimeAsInt() + 135
        end
    end
    if Name == "CEventNetworkEntityDamage" and IsPedArmed(PlayerPedId(), 6) and not IsExemptWeapon(Args[7]) and IsSelfAttacker and GetCloudTimeAsInt() > NextShootingAction then
        local PlayerData = PlayerModule.GetPlayerData()
        if (PlayerData.Job.Name ~= 'police') or (PlayerData.Job.Name == 'police' and not PlayerData.Job.Duty) then -- Take the "not" out if you want police to get notify on duty. Leave "not" if you don't want police to notify on duty.
            local IsInVehicle, StreetLabel = IsPedInAnyVehicle(PlayerPedId()) or false, FunctionModule.GetStreetName()
            EventsModule.TriggerServer('mercy-ui/server/send-shooting-progress', StreetLabel, IsInVehicle, exports['mercy-vehicles']:GetVehicleDescription())
            NextShootingAction = GetCloudTimeAsInt() + 100 -- Change this for timer
        end
    end
end)

RegisterNetEvent('mercy-police/client/open-police-evidence', function()
    Citizen.SetTimeout(450, function()
        local Data = {{Name = 'EviId', Label = 'Evidence Number', Icon = 'fas fa-sort-numeric-up-alt'}}
        local EvidenceInput = exports['mercy-ui']:CreateInput(Data)
        if EvidenceInput['EviId'] then
            if exports['mercy-inventory']:CanOpenInventory() then
                EventsModule.TriggerServer('mercy-inventory/server/open-other-inventory', "evidence_"..EvidenceInput['EviId'], 'Stash', 30, 250.0)
            end
        else
            TriggerEvent('mercy-ui/client/notify', 'evidence-error', "An error occured! (You can\'t leave this empty)", 'error')
        end
    end)
end)

RegisterNetEvent('mercy-police/client/try-status-self', function()
    exports['mercy-ui']:ProgressBar('Checking Status..', 3000, false, false, false, true, function(DidComplete)
        if DidComplete then
            TriggerServerEvent('mercy-police/server/get-target-status', GetPlayerServerId(PlayerId()))
        end
        ClearPedTasks(PlayerPedId())
    end)
end)


RegisterNetEvent('mercy-police/client/try-status', function()
    local ClosestPlayer = PlayerModule.GetClosestPlayer(nil, 2.0)
    if ClosestPlayer['ClosestPlayerPed'] == -1 and ClosestPlayer['ClosestServer'] == -1 then
        TriggerEvent('mercy-ui/client/notify', 'evidence-error', "An error occured! (No one near!)", 'error')
        return
    end
    exports['mercy-ui']:ProgressBar('Checking Status..', 3000, false, false, false, true, function(DidComplete)
        if DidComplete then
            TriggerServerEvent('mercy-police/server/get-target-status', ClosestPlayer['ClosestServer'])
        end
        ClearPedTasks(PlayerPedId())
    end)
end)

RegisterNetEvent('mercy-police/client/try-finger-test', function()
    local ClosestPlayer = PlayerModule.GetClosestPlayer(nil, 2.0)
    if ClosestPlayer['ClosestPlayerPed'] == -1 and ClosestPlayer['ClosestServer'] == -1 then
        TriggerEvent('mercy-ui/client/notify', 'evidence-error', "An error occured! (No one near!)", 'error')
        return
    end
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_STAND_MOBILE", 0, 1)
    exports['mercy-ui']:ProgressBar('Finger Scanning..', 5000, false, false, false, true, function(DidComplete)
        if DidComplete then
            TriggerServerEvent('mercy-police/server/finger-result', ClosestPlayer['ClosestServer'])
        end
        ClearPedTasks(PlayerPedId())
    end)
end)

RegisterNetEvent('mercy-police/client/try-gsr-test', function()
    local ClosestPlayer = PlayerModule.GetClosestPlayer(nil, 2.0)
    if ClosestPlayer['ClosestPlayerPed'] == -1 and ClosestPlayer['ClosestServer'] == -1 then
        TriggerEvent('mercy-ui/client/notify', 'evidence-error', "An error occured! (No one near!)", 'error')
        return
    end
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_STAND_MOBILE", 0, 1)
    exports['mercy-ui']:ProgressBar('GSR Testing..', 5000, false, false, false, true, function(DidComplete)
        if DidComplete then
            TriggerServerEvent('mercy-police/server/gsr-result', ClosestPlayer['ClosestServer'])
        end
        ClearPedTasks(PlayerPedId())
    end)
end)

RegisterNetEvent('mercy-police/client/evidence/set-status', function(StatusName, Time)
    if Time > 0 and StatusList[StatusName] ~= nil and not IsStatusAlreadyActive(StatusName) then
        if CurrentStatusList == nil then CurrentStatusList = {} end
        table.insert(CurrentStatusList, {
            Status = StatusName,
            Text = StatusList[StatusName].Text,
            Time = Time
        })
        if StatusList[StatusName].Show then
            TriggerEvent('mercy-chat/client/post-message', 'Status', StatusList[StatusName].Text, 'warning')
        end
    end
    TriggerServerEvent('mercy-police/server/evidence/set-status', CurrentStatusList)
end)

RegisterNetEvent('mercy-items/client/used-evidence', function()
    if EvidenceEnabled then 
        if CanCollect then -- Prevent Spam
            CanCollect = false
            local ClosestEvidence = GetClosestEvidence()
            if ClosestEvidence ~= false then
                EventsModule.TriggerServer('mercy-police/server/receive-evidence', ClosestEvidence)
            end
        end
    else
        TriggerEvent('mercy-ui/client/notify', 'evidence-error', "An error occured! (You can\'t use this in this state)", 'error')
    end
end)

RegisterNetEvent('mercy-police/client/set-evidence', function(EvidenceId, EvidenceData)
    Evidence[EvidenceId] = EvidenceData
end)

RegisterNetEvent('mercy-police/client/can-collect-again', function()
    CanCollect = true
end)

-- [ Functions ] --

function DoEvidenceLoop()
    Citizen.CreateThread(function()
        while EvidenceEnabled do
            Citizen.Wait(3)
            local NearEvidence = false
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            for k, v in pairs(Evidence) do
                if Evidence[k] ~= nil then
                    if v['Coords'] ~= nil then
                        local Distance = #(PlayerCoords - v['Coords'])
                        if Distance < 15.0 then
                            NearEvidence = true
                            if v['Type'] == 'Blood' then
                                DrawMarker(28, v['Coords'].x, v['Coords'].y, v['Coords'].z, 0, 0, 0, 0, 0, 0, 0.1, 0.1, 0.1, 202, 22, 22, 141, 0, 0, 0, 0)
                            elseif v['Type'] == 'Fingerprint' then
                                DrawMarker(21, v['Coords'].x, v['Coords'].y, v['Coords'].z, 0, 0, 0, 0, 0, 0, 0.1, 0.1, 0.1, 14, 227, 60, 91, 0, 0, 0, 0)
                            elseif v['Type'] == 'Bullet' then
                                DrawMarker(41, v['Coords'].x, v['Coords'].y, v['Coords'].z, 0, 0, 0, 0, 0, 0, 0.1, 0.1, 0.1, 242, 152, 7, 141, 0, 0, 0, 0)
                            end
                            DrawText3D(v['Coords'].x, v['Coords'].y, v['Coords'].z, k)
                        end
                    end
                end
            end
            if not NearEvidence then
                Citizen.Wait(450)
            end
        end
    end)
end

function GetClosestEvidence()
    local ReturnData, Count = {}, 0
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    for k, v in pairs(Evidence) do
        local Distance = #(PlayerCoords - v['Coords'])
        if Distance < 2.5 and Count < 6 then
            Count = Count + 1
            table.insert(ReturnData, v)
        end
    end
    if Count <= 6 then
        return ReturnData
    else
        return false
    end
end

function IsExemptWeapon(Weapon)
	for k, v in pairs(Config.ExemptWeapons) do
	    if GetHashKey(v) == Weapon then		
	    	return true
	    end
	end
    return false
end

function IsStatusAlreadyActive(StatusName)
    for k, v in pairs(CurrentStatusList) do
        if v.Status == StatusName then
            return true
        end
    end
    return false
end
exports('IsStatusAlreadyActive', IsStatusAlreadyActive)

function DrawText3D(X, Y, Z, Text)
    local OnScreen, _X, _Y = World3dToScreen2d(X, Y, Z)
    local PX, PY, PZ = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.28, 0.28)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 245)
    SetTextOutline(true)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(Text)
    DrawText(_X, _Y)
end