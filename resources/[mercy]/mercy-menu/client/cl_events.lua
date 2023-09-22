local CurrentExpression = nil

-- [ Code ] --

-- [ Events] --

RegisterNetEvent('mercy-menu/client/walkstyle-clear', function()
    ResetPedMovementClipset(PlayerPedId(), 0.25)
    TriggerServerEvent('mercy-menu/server/set-walkstyle', 'None')
end)

RegisterNetEvent('mercy-menu/client/walkstyle', function(WalkStyle)
    RequestAnimSet(WalkStyle)
    while not HasAnimSetLoaded(WalkStyle) do Citizen.Wait(0) end
    SetPedMovementClipset(PlayerPedId(), WalkStyle, true)
    TriggerServerEvent('mercy-menu/server/set-walkstyle', WalkStyle)
end)

RegisterNetEvent("mercy-menu/client/expression", function(Expression)
    SetFacialIdleAnimOverride(PlayerPedId(), Expression, 0)
    CurrentExpression = Expression
end)

RegisterNetEvent("mercy-menu/client/expression-clear", function()
    CurrentExpression = nil
    ClearFacialIdleAnimOverride(PlayerPedId())
end)

RegisterNetEvent('mercy-menu/client/player-wink', function(IsPress)
    if IsPress then
        SetFacialIdleAnimOverride(PlayerPedId(), "pose_aiming_1", 0)
    else
        if CurrentExpression == nil then
            ClearFacialIdleAnimOverride(PlayerPedId())
        else
            SetFacialIdleAnimOverride(PlayerPedId(), CurrentExpression, 0)
        end
    end
end)

RegisterNetEvent('mercy-menu/client/send-panic-button', function(Type)
    local StreetLabel = exports['mercy-base']:FetchModule('Functions').GetStreetName()
    EventsModule.TriggerServer('mercy-ui/server/send-panic-button', StreetLabel, Type)
end)

RegisterNetEvent('mercy-menu/client/park-heli', function(Entity)
    local VehicleModule = exports['mercy-base']:FetchModule('Vehicle')
    VehicleModule.DeleteVehicle(Entity)
end)