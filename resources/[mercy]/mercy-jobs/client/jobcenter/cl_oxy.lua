Jobs.Oxy = {
    TransportVehicle = nil,
    DeliverVehicle = nil,
}

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while CallbackModule == nil do Citizen.Wait(100) end
    local Coords = CallbackModule.SendCallback("mercy-jobs/server/oxy/get-pos", 'Supplier')
    exports['mercy-ui']:AddEyeEntry("oxy-supplier", {
        Type = 'Entity',
        EntityType = 'Ped',
        SpriteDistance = 5.0,
        Position = vector4(Coords.x, Coords.y, Coords.z, Coords.w),
        Model = 'u_m_m_streetart_01',
        Anim = {},
        Props = {},
        Options = {
            {
                Name = 'oxy_collect',
                Icon = 'fas fa-box',
                Label = 'Collect Package',
                EventType = 'Client',
                EventName = 'mercy-jobs/client/oxy/collect-package',
                EventParams = '',
                Enabled = function(Entity)
                    return exports['mercy-phone']:IsJobCenterTaskActive('oxy', 2) and (exports['mercy-inventory']:HasEnoughOfItem('vpn', 1) and exports['mercy-inventory']:HasEnoughOfItem('darkmarketdeliveries', 1))
                end,
            },
        }
    })
end)

-- [ Events ] --

RegisterNetEvent('mercy-vehicles/client/on-veh-lockpick', function(Vehicle, Plate)
    if not exports['mercy-phone']:IsJobCenterTaskActive('oxy', 1) then return end
    if GetEntityModel(Vehicle) ~= GetHashKey("bison") then return end

    TriggerEvent('mercy-phone/client/jobcenter/request-task-success', 1, true)
    Jobs.Oxy.TransportVehicle = Vehicle
end)

RegisterNetEvent('mercy-jobs/client/oxy/collect-package', function()
    if exports['mercy-phone']:IsJobCenterTaskActive('oxy', 2) then
        EventsModule.TriggerServer('mercy-inventory/server/add-item', "darkmarketpackage", 1, false, nil, true, false)
        TriggerEvent('mercy-phone/client/jobcenter/request-task-update', 2, 1)
        Jobs.Oxy.IgnoredCars = {}
    else
        exports['mercy-ui']:Notify("oxy-error", "I don't got no shit yo", "error")
    end
end)

RegisterNetEvent('mercy-phone/client/jobcenter/on-task-done', function(Job, FinishedTaskId, NextTaskId, Leader)
    if Job ~= 'oxy' then return end
    if Leader == PlayerModule.GetPlayerData().CitizenId then
        if FinishedTaskId == 1 then
            local Coords = CallbackModule.SendCallback("mercy-jobs/server/oxy/get-pos", 'Supplier')
            local CoordsTable = {
                { Coords = GetEntityCoords(PlayerPedId()) },
                { Coords = vector3(Coords.x, Coords.y, Coords.z) }
            }
            FunctionsModule.CreateCustomGpsRoute(CoordsTable, true)
        elseif NextTaskId == 3 then
            local Result = CallbackModule.SendCallback("mercy-jobs/server/oxy/get-random-oxy-loc", Leader)
            local CoordsTable = {
                { Coords = GetEntityCoords(PlayerPedId()) },
                { Coords = vector3(Result.Coords.x, Result.Coords.y, Result.Coords.z) }
            }
            FunctionsModule.CreateCustomGpsRoute(CoordsTable, true)
            Jobs.Oxy.SetupLocation(3, Result)
        elseif NextTaskId == 5 then
            local Result = CallbackModule.SendCallback("mercy-jobs/server/oxy/get-random-oxy-loc", Leader)
            local CoordsTable = {
                { Coords = GetEntityCoords(PlayerPedId()) },
                { Coords = vector3(Result.Coords.x, Result.Coords.y, Result.Coords.z) }
            }
            FunctionsModule.CreateCustomGpsRoute(CoordsTable, true)
            Jobs.Oxy.SetupLocation(5, Result)
        end
    end
end)

RegisterNetEvent('mercy-phone/client/jobcenter/job-tasks-done', function(Job, Leader)
    if Job ~= 'oxy' then return end
    FunctionsModule.ClearCustomGpsRoute()
    Jobs.Oxy.TransportVehicle = nil
    Jobs.Oxy.DeliverVehicle = nil
end)

RegisterNetEvent('mercy-phone/client/jobcenter/on-crash', function(Job)
    if Job ~= 'oxy' then return end
    FunctionsModule.ClearCustomGpsRoute()
    Jobs.Oxy.TransportVehicle = nil
    Jobs.Oxy.DeliverVehicle = nil
end)

RegisterNetEvent('mercy-jobs/client/oxy/deliver-goods', function(Data, Entity)
    if not exports['mercy-inventory']:HasEnoughOfItem('darkmarketpackage', 1) then return end
    local CanDeliver = CallbackModule.SendCallback("mercy-jobs/server/oxy/can-deliver-package", NetworkGetNetworkIdFromEntity(Entity))
    if not CanDeliver then return exports['mercy-ui']:Notify("oxy", "The goods where already delivered..", "error") end

    local Ped = GetPedInVehicleSeat(Entity, -1)
    TaskVehicleDriveWander(Ped, Entity, 30.0, 786603)
    Citizen.SetTimeout(20000, function()
        SetEntityAsMissionEntity(Entity, true, true)
        DeletePed(Ped)
        DeleteVehicle(Entity)
    end)

    Jobs.Oxy.DeliverVehicle = nil

    EventsModule.TriggerServer("mercy-jobs/server/oxy/get-reward", NetworkGetNetworkIdFromEntity(Entity))
    if exports['mercy-phone']:IsJobCenterTaskActive('oxy', 4) then
        TriggerEvent('mercy-phone/client/jobcenter/request-task-update', 4, 1)
    elseif exports['mercy-phone']:IsJobCenterTaskActive('oxy', 6) then
        TriggerEvent('mercy-phone/client/jobcenter/request-task-update', 6, 1)
    end
end)

RegisterNetEvent('mercy-jobs/client/oxy/veh-drive-to-coord', function(NetId, Coords)
    while not NetworkDoesEntityExistWithNetworkId(NetId) do
        Citizen.Wait(300)
    end

    Citizen.SetTimeout(2000, function()
        local Vehicle = NetworkGetEntityFromNetworkId(NetId)
        local Ped = GetPedInVehicleSeat(Vehicle, -1)
        TaskVehicleDriveToCoord(Ped, Vehicle, Coords.x, Coords.y, Coords.z, 10.0, 1, GetEntityModel(Vehicle), 786603, 2.0, true)
    end)
end)

RegisterNetEvent('mercy-jobs/client/oxy/set-veh-data', function(NetId, Clear)
    if Clear then
        Jobs.Oxy.DeliverVehicle = nil
    else
        while not NetworkDoesEntityExistWithNetworkId(NetId) do
            Citizen.Wait(300)
        end

        local Vehicle = NetworkGetEntityFromNetworkId(NetId)
        Jobs.Oxy.DeliverVehicle = Vehicle

        Citizen.SetTimeout(20000, function()
            if Jobs.Oxy.DeliverVehicle == Vehicle then
                exports['mercy-ui']:Notify("oxy", "Yo you taking too long bro..", "error")
                Jobs.Oxy.DeliverVehicle = nil
                local Ped = GetPedInVehicleSeat(Vehicle, -1)
                TaskVehicleDriveWander(Ped, Vehicle, 30.0, 786603)
                Citizen.SetTimeout(20000, function()
                    SetEntityAsMissionEntity(Vehicle, true, true)
                    DeletePed(Ped)
                    DeleteVehicle(Vehicle)
                end)
            end
        end)
    end
end)

-- [ Functions ] --

function Jobs.Oxy.SetupLocation(TaskId, Location)
    Citizen.CreateThread(function()
        -- Check if near location
        while exports['mercy-phone']:IsJobCenterTaskActive('oxy', TaskId) do
            if #(GetEntityCoords(PlayerPedId()) - vector3(Location.Coords.x, Location.Coords.y, Location.Coords.z)) <= 20.0 then
                TriggerEvent('mercy-phone/client/jobcenter/request-task-success', TaskId, true)
            end
            Citizen.Wait(250)
        end

        local NotifiedNear = false
        local Wait = 50
        while exports['mercy-phone']:IsJobCenterTaskActive('oxy', (TaskId + 1)) do
            if #(GetEntityCoords(PlayerPedId()) - vector3(Location.Coords.x, Location.Coords.y, Location.Coords.z)) <= 20.0 then
                if not NotifiedNear then
                    Wait = 60000
                    NotifiedNear = true
                    exports['mercy-ui']:Notify("oxy", "Stay around here, don't be suspicous..", "success")
                    exports['mercy-assets']:SetDensity('Vehicle', 0.8)
                end

                if not Jobs.Oxy.DeliverVehicle then
                    local Random = math.random(1, 100)
                    if Random <= 75 then
                        EventsModule.TriggerServer('mercy-jobs/server/oxy/spawn-oxy')
                    end
                end
            elseif NotifiedNear then
                Wait = 50
                NotifiedNear = false
                exports['mercy-ui']:Notify("oxy", "You went too far away, please return..", "error")
                exports['mercy-assets']:SetDensity('Vehicle', 0.55)
            end

            Citizen.Wait(Wait)
        end
    end)
end

exports("GetOxyVehicle", function()
    return Jobs.Oxy.DeliverVehicle
end)