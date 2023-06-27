local AirstrikeRocket = GetHashKey("WEAPON_HEAVYSNIPER_MK2")
local AirstrikeStart = vector3(1691.01, 2593.8, 70.02)

local DoingEmergency = false
function ShootMeDaddy()
    local Count = 0
    repeat
        PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
        Count = Count + 1
        Citizen.Wait(400)
    until Count == 5
    Count = 0

    TriggerEvent('mercy-ui/client/play-sound', 'prison-airdefense', 0.4)

    Citizen.Wait(15000)

    repeat
        PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
        Count = Count + 1
        Citizen.Wait(200)
    until Count == 5
    
    local Distance = #(GetEntityCoords(PlayerPedId()) - vector3(1693.33, 2569.51, 45.55))
    if Distance >= 290 then return end

    FunctionsModule.RequestModel(AirstrikeRocket)
    RequestWeaponAsset(AirstrikeRocket, 31, 26)
    while not HasWeaponAssetLoaded(AirstrikeRocket) do Citizen.Wait(4) print('Loading rocket') end

    local EndCoords = GetPedBoneCoords(PlayerPedId(), 39317, 0, 0, 0) -- Solution From https://forum.cfx.re/t/bone-index/98730/6

    if EndCoords.z > 65.0 then
        ShootSingleBulletBetweenCoords(AirstrikeStart.x, AirstrikeStart.y, AirstrikeStart.z, EndCoords.x, EndCoords.y, EndCoords.z, 500, true, AirstrikeRocket, 0, true, false, 1500.0)
    end

    Citizen.SetTimeout(1000, function()
        DoingEmergency = false
    end)
end

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(7)
        if LocalPlayer.state.LoggedIn and not exports['mercy-hospital']:IsDead() then
            local Coords = GetEntityCoords(PlayerPedId())
            local Distance = #(Coords - vector3(1693.33, 2569.51, 45.55))
            if Distance < 290 then
                local Vehicle = GetVehiclePedIsIn(PlayerPedId())
                local VehicleType = GetVehicleClass(Vehicle)
                
                if GetPedInVehicleSeat(Vehicle, -1) ~= PlayerPedId() then goto SkipLoop end
                if (VehicleType == 15 or VehicleType == 16) and not DoingEmergency then
                    DoingEmergency = true
                    ShootMeDaddy()
                else
                    goto SkipLoop
                end
                ::SkipLoop::
            end
            Citizen.Wait(1000)
        else
            Citizen.Wait(450)
        end
    end
end)