local HasScoreboardOpen = false
-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            if IsControlJustPressed(0, 213) or IsDisabledControlJustPressed(0, 213) then -- Home Key
                if not HasScoreboardOpen then
                    HasScoreboardOpen = true
                end
            end
            if IsControlJustReleased(0, 213) or IsDisabledControlJustReleased(0, 213) then
                HasScoreboardOpen = false
            end
            if HasScoreboardOpen then
                local Players = GetPlayersFromCoords(GetEntityCoords(PlayerPedId()), 10.0)
                for _, Player in pairs(Players) do
                    local PlayerId = GetPlayerServerId(Player)
                    local PlayerPed = GetPlayerPed(Player)
                    local PlayerCoords = GetPedBoneCoords(PlayerPed, 0x796e)
                    local CanSee = HasEntityClearLosToEntity(PlayerPedId(), PlayerPed, 17)
                    local IsDucking = IsPedDucking(PlayerPed)
                    local IsStealth = GetPedStealthMovement(PlayerPed)
                    local IsDriveBy = IsPedDoingDriveby(PlayerPed)
                    local IsInCover = IsPedInCover(PlayerPed, true)
                    if IsDucking or IsStealth == 1 or IsDriveBy or IsInCover then CanSee = false end
                    if CanSee then
                        DrawText3D(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 0.5, PlayerId)
                    end
                end
            end
        else
           Citizen.Wait(1000)
        end
    end
end)

-- [ Functions ] --

function GetPlayers()
    local Players = {}
    for _, Player in ipairs(GetActivePlayers()) do
        local Ped = GetPlayerPed(Player)
        if DoesEntityExist(Ped) then
            table.insert(Players, Player)
        end
    end
    return Players
end

function GetPlayersFromCoords(Coords, Distance)
    local players = GetPlayers()
    local closePlayers = {}
    if coords == nil then
        coords = GetEntityCoords(PlayerPedId())
    end
    if distance == nil then
        distance = 5.0
    end
    for _, player in pairs(players) do
        local target = GetPlayerPed(player)
        local targetCoords = GetEntityCoords(target)
        local targetdistance = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)
        if (IsEntityVisible(target) or IsAdmin) and targetdistance <= distance then
            table.insert(closePlayers, player)
        end
    end
    return closePlayers
end

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end