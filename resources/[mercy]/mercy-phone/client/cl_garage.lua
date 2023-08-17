--[[
    App: Garage
]]

Garage = {}

function Garage.Render()
    local Data = CallbackModule.SendCallback("mercy-phone/server/get-garage-data")
    local PlayerData = PlayerModule.GetPlayerData()
    
    for k, v in pairs(Data) do
        local SharedData = Shared.Vehicles[GetHashKey(v.vehicle)]
        v.Label = SharedData ~= nil and SharedData['Model'] .. ' ' .. SharedData['Name'] or GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle))
        v.Type = SharedData ~= nil and SharedData['Type'] or 'Car'
    end

    exports['mercy-ui']:SendUIMessage("Phone", "RenderGarageApp", {
        Vehicles = Data,
    })
end

RegisterNUICallback("Garage/TrackVehicle", function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-vehicles/server/get-vehicle-position", Data.Plate)
    if Result then
        SetWaypointOff()
        Citizen.SetTimeout(500, function()
            SetNewWaypoint(Result[1].x, Result[1].y)
            exports['mercy-ui']:Notify('found', Result[2], "success")
        end)
    else
        exports['mercy-ui']:Notify('not-found', "Can\'t find vehicle..", "error")
    end
    Cb('Ok')
end)