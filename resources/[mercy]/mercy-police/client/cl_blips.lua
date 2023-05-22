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
            if BlipModule.GetBlipById(BlipId) == false then
                BlipModule.CreateBlip('duty-player-'..v.ServerId, v.Coords, v.Callsign..' - '..v.Name, 480, Color, false, 0.75, nil, 7)
            else
                BlipModule.SetBlipCoords(BlipId, v.Coords)
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