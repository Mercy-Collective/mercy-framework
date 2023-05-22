local IsSpectating = false
local LastCoords = vector3(0.0, 0.0, 0.0)
Spectate = {}

-- [ Code ] --

function ToggleSpectate(TargetSource)
    if TargetSource == Spectate.CurrentTarget then IsSpectating = false return
    elseif IsSpectating then IsSpectating = false return end
    IsSpectating = true

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
        Citizen.Wait(1)
    end
    
    NetworkSetInSpectatorMode(true, Ped)

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
    end)
end