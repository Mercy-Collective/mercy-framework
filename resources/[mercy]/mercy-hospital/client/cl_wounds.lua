local SavedHealth, SavedBone, IsBleeding, OnOxy = 200, 0, false, false
local FallingHeight, IsFallingRagdoll = nil, false

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn and not Config.Dead then
            local Player = exports['mercy-base']:FetchModule('Player').GetPlayerData()
            if Player == nil then return end
            if Player.MetaData['Food'] == 0 then
                TriggerEvent('mercy-ui/client/notify', "hospital-consumption-error", 'You notice that you feel hungry.', 'error', 4500)
                local CurrentHealth = GetEntityHealth(PlayerPedId())
                local MinAmount = OnOxy and math.random(1, 2) or math.random(2, 3)
                SetEntityHealth(PlayerPedId(), (CurrentHealth - MinAmount))
            end
            if Player.MetaData['Water'] == 0 then
                TriggerEvent('mercy-ui/client/notify', "hospital-consumption-error", 'You notice that you feel thirsty.', 'error', 4500)
                local CurrentHealth = GetEntityHealth(PlayerPedId())
                local MinAmount = OnOxy and math.random(1, 2) or math.random(2, 3)
                SetEntityHealth(PlayerPedId(), (CurrentHealth - MinAmount))
            end
            Citizen.Wait(7500)
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn and not Config.Dead then
            for k, v in pairs(Shared.Weapons) do
                if HasPedBeenDamagedByWeapon(PlayerPedId(), GetHashKey(v.WeaponID), 0) and not IsBleeding then
                    ClearEntityLastDamageEntity(PlayerPedId())
                    IsBleeding = true
                end
            end
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn and not Config.Dead and IsBleeding then
            local DoBleed = false
            local IsRunning = IsPedRunning(PlayerPedId())

            if IsRunning then
                if math.random(1, 100) < 50 then
                    DoBleed = true
                    TriggerEvent('mercy-ui/client/notify', "hospital-blood", 'You notice blood oozing from your body the more you move.', 'error', 4500)
                end
            else
                if math.random(1, 100) < 20 then
                    DoBleed = true
                    TriggerEvent('mercy-ui/client/notify', "hospital-blood", 'You notice blood oozing from your body.', 'error', 4500)
                end
            end

            if DoBleed then
                local CurrentHealth = GetEntityHealth(PlayerPedId())
                local MinAmount = OnOxy and math.random(1, 2) or math.random(3, 6)
                SetEntityHealth(PlayerPedId(), (CurrentHealth - MinAmount))

                Citizen.CreateThread(function()
                    while IsPedRagdoll(PlayerPedId()) do
                        Citizen.Wait(10)
                    end
                    TriggerServerEvent("mercy-police/server/create-evidence", 'Blood')
                end)
            end

            Citizen.Wait(10000)
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn and not Config.Dead then
            local IsFalling, PedRagdoll = IsPedFalling(PlayerPedId()), IsPedRagdoll(PlayerPedId())
            if IsFalling then
                if FallingHeight == nil then FallingHeight = GetEntityCoords(PlayerPedId()).z end
                if PedRagdoll then IsFallingRagdoll = true end
            elseif not IsFalling and FallingHeight ~= nil then
                local CurrentHeight = GetEntityCoords(PlayerPedId()).z
                local DifferenceHeight = FallingHeight - CurrentHeight
                if IsFallingRagdoll then
                    if not exports['mercy-police']:IsStatusAlreadyActive('sworebody') then
                        TriggerEvent('mercy-police/client/evidence/set-status', 'sworebody', 210)
                    end
                end
                FallingHeight, IsFallingRagdoll = nil, false
            end
            Citizen.Wait(250)
        else
            Citizen.Wait(450)
        end
    end
end)

-- [ Events ] --

RegisterNetEvent("mercy-hospital/client/heal", function()
    TriggerEvent('mercy-hospital/client/clear-bleeding')
    TriggerEvent('mercy-hospital/client/clear-wounds')
    SetEntityHealth(PlayerPedId(), 200.0)
    SetPlayerSprint(PlayerId(), true)
    ClearPedBloodDamage(PlayerPedId())
end)

RegisterNetEvent("mercy-threads/on-change/GetEntityHealth", function(Value)
    local DidDamage, DamagedBone = GetPedLastDamageBone(PlayerPedId())
    if DamagedBone ~= 0 and DamagedBone ~= SavedBone and Value < SavedHealth then
        ClearPedLastDamageBone(PlayerPedId())
        ApplyBodyPartDamage(DamagedBone)
        SavedBone = DamagedBone
    end
    PlayerHealth = Value
end)

RegisterNetEvent("mercy-hospital/client/used-oxy", function()
    if OnOxy then TriggerEvent('mercy-ui/client/notify', "hospital-oxy", 'You\'re already on oxy..', 'error') return end
    exports['mercy-inventory']:SetBusyState(true)
    exports['mercy-ui']:ProgressBar('Popping Oxy ..', 2850, {['AnimName'] = 'pill', ['AnimDict'] = 'mp_suicide', ['AnimFlag'] = 49}, false, false, true, function(DidComplete)
        if DidComplete then
            local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', 'oxy', 1, false, true)
            if DidRemove then 
                OnOxy = true
                Citizen.SetTimeout(15000, function() 
                    OnOxy = false 
                end)
            end
        end
        exports['mercy-inventory']:SetBusyState(false)
    end)
end)

RegisterNetEvent('mercy-hospital/client/clear-wounds', function()
    ClearPedLastDamageBone(PlayerPedId())
    for k, v in pairs(Config.BodyHealth) do
        v.Health = 100.0
    end
end)

RegisterNetEvent('mercy-hospital/client/decrease-wounds', function()
    local RandomAdd = math.random(3, 6)
    for k, v in pairs(Config.BodyHealth) do
        if v.Health + RandomAdd > 100.0 then
            v.Health = 100.0
        else
            v.Health = v.Health + RandomAdd
        end
    end
end)

RegisterNetEvent('mercy-hospital/client/clear-bleeding', function()
    ClearEntityLastDamageEntity(PlayerPedId())
    ClearPedLastDamageBone(PlayerPedId())
    IsBleeding = false
end)

-- [ Functions ] --

function ApplyBodyPartDamage(BoneId)
    local BodyPart = Config.BodyParts[BoneId]
    if BodyPart ~= nil and BodyPart ~= 'NONE' then

        if BodyPart == 'LLEG' or BodyPart == 'RLEG' or BodyPart == 'LFOOT' or BodyPart == 'RFOOT' then
            if math.random(1, 100) < 3 then
                SetPedToRagdollWithFall(PlayerPedId(), 2500, 9000, 1, GetEntityForwardVector(PlayerPedId()), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
            end
        end

        if Config.BodyHealth[BodyPart] ~= nil then
            local RandomDecrease = math.random(3, 8)
            if Config.BodyHealth[BodyPart].Health - RandomDecrease > 0 then
                Config.BodyHealth[BodyPart].Health = Config.BodyHealth[BodyPart].Health - RandomDecrease
            else
                Config.BodyHealth[BodyPart].Health = 0
            end

            if Config.BodyHealth[BodyPart].Health < 100 then
                local CurrentHealth = GetEntityHealth(PlayerPedId())
                local MinAmount = OnOxy and math.random(1, 2) or math.random(2, 4)
                SetEntityHealth(PlayerPedId(), (CurrentHealth - MinAmount))
                TriggerEvent('mercy-ui/client/notify', "hospital-pain", 'You\'re '..Config.BodyHealth[BodyPart].Name..' feels painful.', 'error', 4500)
            end
        end
        
        Citizen.CreateThread(function()
            while IsPedRagdoll(PlayerPedId()) do
                Citizen.Wait(10)
            end
            TriggerServerEvent("mercy-police/server/create-evidence", 'Blood')
        end)

    end
end

function IsPlayerBleeding()
    return IsBleeding
end

exports('IsPlayerBleeding', IsPlayerBleeding)