local HasPlayerIdOpen = false

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            if IsControlJustPressed(0, 213) then
                if not HasPlayerIdOpen then
                    HasPlayerIdOpen = true
                end
            end
            if IsControlJustReleased(0, 213) then
                if HasPlayerIdOpen then
                    HasPlayerIdOpen = false
                end
            end
            if HasPlayerIdOpen then
                local Players = GetPlayersFromCoords(GetEntityCoords(PlayerPedId()), 10.0)
                for _, Player in pairs(Players) do
                    local PlayerId = GetPlayerServerId(Player)
                    local Ped = GetPlayerPed(Player)
                    local PlayerCoords = GetPedBoneCoords(Ped, 0x796e)
                    local CanSee = HasEntityClearLosToEntity(PlayerPedId(), Ped, 17)
                    local IsDucking = IsPedDucking(Ped)
                    local IsStealth = GetPedStealthMovement(Ped)
                    local IsDriveBy = IsPedDoingDriveby(Ped)
                    local IsInCover = IsPedInCover(Ped, true)
                    if IsDucking or IsStealth == 1 or IsDriveBy or IsInCover then CanSee = false end
                    if CanSee then
                        if NetworkIsPlayerTalking(Player) then
                            DrawText3D(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 0.5, PlayerId, {r = 255, g = 56, b = 47})
                        else
                            DrawText3D(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 0.5, PlayerId)
                        end
                    end
                end
            end
        else
           Citizen.Wait(450)
        end
    end
end)

-- [ Functions ] --

function GetPlayersFromCoords(Coords, Distance)
    local Players = GetPlayers()
    local ClosePlayers = {}
    if Coords == nil then
		Coords = GetEntityCoords(PlayerPedId())
    end
    if Distance == nil then
        Distance = 5.0
    end
    for _, Player in pairs(Players) do
		local Target = GetPlayerPed(Player)
		local TargetCoords = GetEntityCoords(Target)
		local Targetdistance = GetDistanceBetweenCoords(TargetCoords, Coords.x, Coords.y, Coords.z, true)
		if Targetdistance <= Distance then
			table.insert(ClosePlayers, Player)
		end
    end
    return ClosePlayers
end

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

function DrawText3D(X, Y, Z, Text, Color)
    local Color = Color or {r = 255, g = 255, b = 255}
    SetTextScale(0.0, 0.5)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(Color.r, Color.g, Color.b, 255)
    SetTextDropshadow(0, 0, 0, 0, 55)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(Text)
    SetDrawOrigin(X, Y, Z, 0)
    DrawText(0, 0)
end