local IsSpectating = false
local LastCoords = vector3(0.0, 0.0, 0.0)

-- [ Code ] --

function Spectate.Toggle(TargetSource)
    if TargetSource == Spectate.CurrentTarget then IsSpectating = false return
    elseif IsSpectating then IsSpectating = false return end

    if TargetSource == GetPlayerServerId(PlayerId()) then 
        IsSpectating = false 
        exports['mercy-ui']:Notify('spectate-self', 'You can\'t spectate yourself!', 'error')
        return 
    end

    IsSpectating = true
    Spectate.CurrentTarget = TargetSource
    LastCoords = GetEntityCoords(PlayerPedId())
    
    SetEntityVisible(PlayerPedId(), false, false)
    FreezeEntityPosition(PlayerPedId(), true)

    local Result = CallbackModule.SendCallback('mc-admin/server/get-spectate-data', TargetSource)
    if Result == nil then IsSpectating = false return end
    SetEntityCoords(PlayerPedId(), Result.x, Result.y, Result.z)
    Citizen.Wait(100)
    local Ped = GetPlayerPed(GetPlayerFromServerId(Result.ServerId))
    if not DoesEntityExist(Ped) then return print("NO PED EXIST ):") end

    while Ped == PlayerPedId() do -- Ped is the same as the player
        Ped = GetPlayerPed(GetPlayerFromServerId(Result.ServerId))
        IsSpectating = false
        Spectate.CurrentTarget = nil
        Citizen.Wait(1)
    end
    
    NetworkSetInSpectatorMode(true, Ped)

    exports['mercy-ui']:Notify('spectate-toggled', 'Enabled spectate..', 'success')
    Citizen.CreateThread(function()
        while IsSpectating do
            if Ped == PlayerPedId() then Ped = GetPlayerPed(GetPlayerFromServerId(Result.ServerId)) end -- Ped is the same as the player.
            local Coords = GetEntityCoords(Ped)
            SetEntityCoords(PlayerPedId(), Coords.x, Coords.y, Coords.z + 11.0)
            Citizen.Wait(4)
        end
        
        -- Entity
        NetworkSetInSpectatorMode(false, Ped)
        SetEntityVisible(PlayerPedId(), true, true)
        SetEntityCoords(PlayerPedId(), LastCoords.x, LastCoords.y, LastCoords.z - 0.5)
        FreezeEntityPosition(PlayerPedId(), false)
        Spectate.CurrentTarget = nil

        exports['mercy-ui']:Notify('spectate-toggled', 'Disabled spectate..', 'error')
    end)
end