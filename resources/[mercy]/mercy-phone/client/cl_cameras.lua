--[[
    App: Cameras
]]

Cameras = {}
Cameras.Owned = {}

function Cameras.Render()
    exports['mercy-ui']:SendUIMessage("Phone", "RenderCamerasApp", {
        Cameras = Cameras.Owned[PlayerModule.GetPlayerData().CitizenId] or {}
    })
end

RegisterNUICallback("Cameras/AddCamera", function(Data, Cb)
    local CitizenId = PlayerModule.GetPlayerData().CitizenId
    local PlayerJob = PlayerModule.GetPlayerData().Job
    if Cameras.Owned[CitizenId] == nil then Cameras.Owned[CitizenId] = {} end

    local CamData = CallbackModule.SendCallback("mercy-misc/server/gopros/does-exist", Data.CamId)
    if not CamData then Cb(false) return end
    if CamData.IsEncrypted and (PlayerJob.Name ~= 'police' or not PlayerJob.Duty) then Cb(false) return end

    table.insert(Cameras.Owned[CitizenId], CamData)

    exports['mercy-ui']:SendUIMessage("Phone", "RenderCamerasApp", {
        Cameras = Cameras.Owned[CitizenId] or {}
    })

    Cb(true)
end)

RegisterNUICallback("Cameras/ViewCamera", function(Data, Cb)
    TriggerEvent("mercy-misc/client/gopros/view-camera", Data)
    Cb('Ok')
end)

RegisterNUICallback("Cameras/DeleteCamera", function(Data, Cb)
    local CitizenId = PlayerModule.GetPlayerData().CitizenId
    for k, v in pairs(Cameras.Owned[CitizenId]) do
        if v.Id == Data.CamId then
            table.remove(Cameras.Owned[CitizenId], k)
        end
    end
    Cb('Ok')
end)