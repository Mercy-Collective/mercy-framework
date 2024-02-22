PlayerModule, FunctionsModule, CallbackModule, EntityModule = nil, nil, nil, nil
CurrentDoor, Listening = nil, false

AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
        'Player',
        'Entity',
        'Functions',
        'Callback',
    }, function(Succeeded)
        if not Succeeded then return end
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        EntityModule = exports['mercy-base']:FetchModule("Entity")
    end)
end)

RegisterNetEvent('mercy-base/client/on-login', function()
    Citizen.SetTimeout(450, function()
        local Result = CallbackModule.SendCallback('mercy-doors/server/get-door-config')
        Config.Doors = Result

        Citizen.SetTimeout(200, function()
            TriggerEvent('mercy-doors/client/setup-doors')
            InitElevator()
            InitZones()
        end)
    end)
end)

-- [ Code ] --



-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn and (CurrentDoor ~= nil and (CurrentDoor == 16 or CurrentDoor == 17)) or CurrentDoor == nil and NearBollards ~= nil then
            if IsControlJustReleased(0, 38) then
                TriggerEvent('mercy-doors/client/press-special-door')
            end
        else
            Citizen.Wait(450)
        end 
    end
end)

-- [ Events ] --

RegisterNetEvent('mercy-doors/client/setup-doors', function()
    for k, v in pairs(Config.Doors) do
        if v.Disabled then
            goto SkipDoor
        end

        if not IsDoorRegisteredWithSystem(k) then
            AddDoorToSystem(k, type(v.Model) == 'string' and GetHashKey(v.Model) or v.Model, v.Coords, false, false, false)
        end
        if v.IsGate then
            DoorSystemSetAutomaticDistance(k, 8.0, false, true)
        end
        DoorSystemSetAutomaticRate(k, 1.0, false, false)
        DoorSystemSetDoorState(k, v.Locked, false, true)

        ::SkipDoor::
    end
end)

RegisterNetEvent('mercy-doors/client/press-special-door', function()
    if NearBollards ~= nil then
        local DoorId = GetDoorIdByInfo(NearBollards)
        if DoorId ~= 0 and HasDoorAccess(DoorId) then
            TriggerServerEvent('mercy-doors/server/toggle-locks', DoorId)
            PlaySoundFromEntity(-1, "Keycard_Success", PlayerPedId(), "DLC_HEISTS_BIOLAB_FINALE_SOUNDS", 1, 5.0)
        else
            TriggerEvent('mercy-ui/client/notify', "doors-error", "No access!", 'error')
            PlaySoundFromEntity(-1, "Keycard_Fail", PlayerPedId(), "DLC_HEISTS_BIOLAB_FINALE_SOUNDS", 1, 5.0)
        end
    end
end)

RegisterNetEvent('mercy-base/client/target-changed', function(Entity, EntityType, EntityCoords)
    if EntityType == nil or EntityType ~= 3 then
        CurrentDoor, Listening = nil, false
        return
    end
    local DoorId = GetTargetDoorId(Entity)
    if DoorId ~= CurrentDoor then Listening = false end
    Citizen.SetTimeout(20, function()
        if DoorId ~= nil then
            CurrentDoor = DoorId
            ListenForKeypress(CurrentDoor)
        end
    end)
end)

RegisterNetEvent('mercy-doors/client/sync-doors', function(DoorId, DoorData)
    Config.Doors[DoorId] = DoorData
    DoorSystemSetAutomaticRate(DoorId, 1.0, false, false)
    DoorSystemSetDoorState(DoorId, Config.Doors[DoorId].Locked, false, true)
    if DoorId ~= CurrentDoor then return end
    if Config.Doors[DoorId].IsGate then return end
    if #(GetEntityCoords(PlayerPedId()) - Config.Doors[DoorId].Coords) < 2.0 then
        local HasAccess = HasDoorAccess(DoorId)
        local DoorState = (Config.Doors[DoorId].Locked or Config.Doors[DoorId].Locked == 1) and true or false
        exports['mercy-ui']:SetInteraction((HasAccess and "[E] %s" or "%s"):format(DoorState and 'Locked' or 'Unlocked'), DoorState and 'error' or 'success', true)
    end
end)

-- [ Functions ] --

function ListenForKeypress(DoorId)
    if not Listening then
        Listening = true
        Citizen.CreateThread(function()
            local CurrentDoorId, LockState = DoorId, nil
            local Distance = Config.Doors[CurrentDoorId].IsGate and 8.0 or 2.0
            local CurrentDoorLockState = ((Config.Doors[CurrentDoorId].Locked or Config.Doors[CurrentDoorId].Locked == 1) and true or false)
            local HasAccess, IsHidden = HasDoorAccess(CurrentDoorId), Config.Doors[CurrentDoorId].IsGate
            while Listening do
                Citizen.Wait(4)
                -- print(CurrentDoorId)
                if CurrentDoorLockState ~= LockState and not IsHidden then
                    if #(GetEntityCoords(PlayerPedId()) - Config.Doors[CurrentDoorId].Coords) < Distance then
                        LockState = CurrentDoorLockState
                        exports['mercy-ui']:SetInteraction((HasAccess and "[E] %s" or "%s"):format(LockState and 'Locked' or 'Unlocked'), LockState and 'error' or 'success')
                    end
                end
                if IsControlJustReleased(0, 38) then
                    local HasAccess = HasDoorAccess(CurrentDoorId)
                    if HasAccess and #(GetEntityCoords(PlayerPedId()) - Config.Doors[CurrentDoorId].Coords) < Distance then
                        if CurrentDoorId ~= 'MRPD_BOLLARDS_01' and CurrentDoorId ~= 'MRPD_BOLLARDS_02' then
                            -- Toggle Locks
                            TriggerServerEvent('mercy-doors/server/toggle-locks', CurrentDoorId)
                            if Config.Doors[CurrentDoorId].Connected ~= nil and next(Config.Doors[CurrentDoorId].Connected) then
                                for k, v in pairs(Config.Doors[CurrentDoorId].Connected) do
                                    local ConnectedDoorId = GetDoorIdByInfo(v)
                                    TriggerServerEvent('mercy-doors/server/toggle-locks', ConnectedDoorId)
                                end
                            end
                            -- Play Sound
                            if Config.Doors[CurrentDoorId].IsGate then
                                PlaySoundFromEntity(-1, "Keycard_Success", PlayerPedId(), "DLC_HEISTS_BIOLAB_FINALE_SOUNDS", 1, 5.0)
                            else
                                TriggerEvent('mercy-assets/client/play-door-animation')
                                TriggerEvent('mercy-ui/client/play-sound', 'door-lock', 0.55)
                            end
                        end
                    end
                end
            end
            Citizen.Wait(35)
            exports["mercy-ui"]:HideInteraction()
        end)
    end 
end


function GetTargetDoorId(Entity)
    local ActiveDoors = DoorSystemGetActive()
    for _, ActiveDoor in pairs(ActiveDoors) do
        if ActiveDoor[2] == Entity then
            return ActiveDoor[1]
        end
    end
end

function GetDoorIdByInfo(Info)
    for k, v in pairs(Config.Doors) do
        if v.Info == Info then
            return k
        end
    end
end

function HasDoorAccess(DoorId)
    local PlayerData = PlayerModule.GetPlayerData()
    if Config.Doors[DoorId] ~= nil then
        for k, v in pairs(Config.Doors[DoorId]['Access']['Job']) do
            if PlayerData.Job.Name == v then
                return true
            end
        end
        for k, v in pairs(Config.Doors[DoorId]['Access']['CitizenId']) do
            if PlayerData.CitizenId == v then
                return true
            end
        end
        for k, v in pairs(Config.Doors[DoorId]['Access']['Business']) do
            if exports['mercy-business']:HasPlayerBusinessPermission(v, 'property_keys') then
                return true
            end
        end
        if Config.Doors[DoorId]['Access']['Item'] == nil then return false end
        for k, v in pairs(Config.Doors[DoorId]['Access']['Item']) do
            if exports['mercy-inventory']:HasEnoughOfItem(v, 1) then
                return true
            end
        end
    end
    return false
end

function nearDoor()
    if CurrentDoor == nil then
        return false 
    else
        return true
    end
end

exports('nearDoor', nearDoor)
