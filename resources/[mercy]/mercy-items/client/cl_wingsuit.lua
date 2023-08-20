local Wingsuiting = false
local usedSuperBoost = false
local superBoostActive = false

local WingsuitObject = nil

-- [ Events ] --

RegisterNetEvent("mercy-items/client/used-wingsuit", function(WingsuitType)
    if Wingsuiting then return end
    local Ped = PlayerPedId()
    local Veh = GetVehiclePedIsIn(Ped, false)
    if Veh ~= 0 then return end
    if GetEntityHeightAboveGround(Ped) < 3 then 
        exports['mercy-ui']:Notify('close-ground', 'You are too close to the ground or standing on a flat surface!', 'error')
        return 
    end
    Wingsuiting = true
    usedSuperBoost = false
    local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', WingsuitType, 1, false, true)
    if DidRemove then
        local WingsuitName = "np_"..WingsuitType.."_open"
        if FunctionsModule.RequestModel(WingsuitName) then
            local PedCoords = GetEntityCoords(PlayerPedId())
            WingsuitObject = CreateObject(GetHashKey(WingsuitName), 1.0, 1.0, 1.0, 1, 1, 0)
            AttachEntityToEntity(WingsuitObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 24817), 0.1, -0.15, 0.0, 0.0, 90.0, 0.0, true, true, false, true, 2, true)
            Citizen.CreateThread(function()
                SetPlayerParachuteModelOverride(PlayerId(), `p_parachute1_mp_s`)
                SetPedParachuteTintIndex(Ped, 6)
                GiveWeaponToPed(Ped, -72657034, 1, 0, 1)
            end)

            Citizen.CreateThread(function()
                while not IsPedInParachuteFreeFall(Ped) do
                  Wait(0)
                end
                while (GetEntityHeightAboveGround(Ped) > 1) and (GetPedParachuteState(PlayerPedId()) < 1) do
                  Wait(500)
                end
                DeleteObject(WingsuitObject)
                TriggerEvent('mercy-assets/client/attach-items')
                Wingsuiting = false
            end)

            Citizen.CreateThread(function()
                while not IsPedInParachuteFreeFall(Ped) do
                  Wait(0)
                end
                while (GetEntityHeightAboveGround(Ped) > 1) and (GetPedParachuteState(PlayerPedId()) < 1) do
                    if IsControlPressed(0, 8) and (not SuperBoostActive) then -- W
                        ApplyForceToEntity(Ped, 1, 0.0, 30.0, 2.5, 0.0, 0.0, 0.0, 0, true, false, false, false, true)
                    elseif IsControlPressed(0, 32) and (not SuperBoostActive) then
                        ApplyForceToEntity(Ped, 1, 0.0, 80.0, 75.0, 0.0, 0.0, -75.0, 0, true, false, false, false, true)
                    end
                    if IsControlPressed(0, 22) and (not usedSuperBoost) then -- Spacebar
                        usedSuperBoost = true
                        Citizen.CreateThread(function()
                            SuperBoostActive = true
                            while SuperBoostActive do
                                ApplyForceToEntity(Ped, 1, 0.0, 200.0, 400.0, 0.0, 0.0, -300.0, 0, true, false, false, false, true)
                                Wait(0)
                            end
                        end)
                        Citizen.CreateThread(function()
                            Wait(1500)
                            SuperBoostActive = false
                        end)
                    end
                    Wait(0)
                end
            end)
        else
            exports['mercy-ui']:Notify('wingsuit-model', 'Failed to enable wingsuit!', 'error')
            Wingsuiting = false
        end
    end
end)

local isDead = false
RegisterNetEvent("mercy-hospital/client/on-player-death", function()
    isDead = not isDead
    if not isDead then return end
    Wingsuiting = false
    usedSuperBoost = false
    DeleteObject(WingsuitObject)
end)