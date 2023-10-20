-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('mercy-police/client/update-service-blips', function(BlipData)
    local ServerId =  GetPlayerServerId(PlayerId())

    if not LocalPlayer.state.LoggedIn then return end
    if PlayerData == nil or PlayerData == false or PlayerData.Job == nil then return end
    if PlayerData.Job.Name ~= 'ems' and PlayerData.Job.Name ~= 'police' then return end

    for k, v in pairs(BlipData) do
        if tonumber(v.ServerId) ~= tonumber(ServerId) then
            local BlipId = 'duty-player-'..v.ServerId
            local Color = v.Color ~= nil and v.Color or 55
            local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            local VehicleClass = GetVehicleClass(Vehicle)
            if Vehicle ~= 0 and Vehicle ~= -1 then
                if VehicleClass == 14 then -- Boat
                    BlipModule.CreateBlip(BlipId, v.Coords, v.Callsign..' - '..v.Name, 427, Color, false, 1.0, nil, 7, nil, true)
                elseif VehicleClass == 15 then -- Helicopter
                    BlipModule.CreateBlip(BlipId, v.Coords, v.Callsign..' - '..v.Name, 43, Color, false, 1.0, nil, 7, nil, true)
                elseif VehicleClass == 16 then -- Plane
                    BlipModule.CreateBlip(BlipId, v.Coords, v.Callsign..' - '..v.Name, 423, Color, false, 1.0, nil, 7, nil, true)
                else -- Car
                    BlipModule.CreateBlip(BlipId, v.Coords, v.Callsign..' - '..v.Name, 56, Color, false, 1.0, nil, 7, nil, true)
                end
            else
                BlipModule.CreateBlip(BlipId, v.Coords, v.Callsign..' - '..v.Name, 1, Color, false, 1.0, nil, 7, nil, true)
            end
        end
    end
end)

RegisterNetEvent('mercy-police/client/clear-service-blips', function()
    if not LocalPlayer.state.LoggedIn then return end
    RemoveAllJobBlips()
end)

RegisterNetEvent('mercy-police/client/remove-service-blip', function(ServerId)
    if not LocalPlayer.state.LoggedIn then return end
    if PlayerData == nil or PlayerData == false or PlayerData.Job == nil then return end
    if PlayerData.Job.Name ~= 'ems' and PlayerData.Job.Name ~= 'police' then return end

    local BlipId = 'duty-player-'..ServerId
    if BlipModule.GetBlipById(BlipId) ~= false then
        BlipModule.RemoveBlip(BlipId)
    end
end)

-- [ Functions ] --

function RemoveAllJobBlips()
    local BlipData = BlipModule.GetAllBlipsData('Blips')
    for k, v in pairs(BlipData) do
        local BlipName = string.sub(k, 1, 11)
        if BlipName == 'duty-player' then
            BlipModule.RemoveBlip(k)
        end
    end
end
exports('RemoveAllJobBlips', RemoveAllJobBlips)