local MessagesCount = 0

-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('mercy-misc/client/me', function(Source, Text)
    local Alpha = 600
    MessagesCount = MessagesCount + 1
    local MessageCount = MessagesCount + 0.1
    local Distance = 0.1
    
    local Ped = GetPlayerPed(GetPlayerFromServerId(Source))

    while Alpha > 0 do
        Alpha = Alpha - 1

        local Pos = GetEntityCoords(Ped)
        if GetVehiclePedIsUsing(Ped) ~= 0 then
            Pos = GetPedBoneCoords(Ped, 0x4B2)
            Distance = 0.2
        end

        local OutputAlpha = Alpha

        if OutputAlpha > 255 then OutputAlpha = 255 end
        DrawMeText(Pos.x, Pos.y, Pos.z + (Distance * (MessageCount - 1)), Text, OutputAlpha)
        Citizen.Wait(1)
    end
    MessagesCount = MessagesCount - 1
end)

-- [ Functions ] --

function DrawMeText(X, Y, Z, Text, Alpha)
    local OnScreen, _X, _Y = World3dToScreen2d(X, Y, Z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    if Alpha > 255 then Alpha = 255 end

    if OnScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 155)
        SetTextEdge(1, 0, 0, 0, 250)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(Text)
        SetTextColour(255, 255, 255, Alpha)
        DrawText(_X,_Y)

        local factor = (string.len(Text)) / 250
        if Alpha < 115 then
            DrawRect(_X,_Y+0.0125, 0.015+ factor, 0.03, 11, 1, 11, Alpha)
        else
            DrawRect(_X,_Y+0.0125, 0.015+ factor, 0.03, 11, 1, 11, 115)
        end
    end
end