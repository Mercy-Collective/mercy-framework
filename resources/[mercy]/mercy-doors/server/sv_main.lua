CallbackModule = nil

local _Ready = false
AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Callback',
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        _Ready = true
    end)
end)

-- [ Code ] --

Citizen.CreateThread(function() 
    while not _Ready do 
        Citizen.Wait(4) 
    end 

    -- [ Callbacks ] --

    CallbackModule.CreateCallback('mercy-doors/server/get-door-config', function(Source, Cb)
        Cb(Config.Doors)
    end)
end)

-- [ Events ] --

RegisterNetEvent("mercy-doors/server/set-citizenid", function(DoorId, CitizenId)
    table.insert(Config.Doors[DoorId].Access.CitizenId, CitizenId)
    TriggerClientEvent('mercy-doors/client/sync-doors', -1, DoorId, Config.Doors[DoorId])
end)

RegisterNetEvent("mercy-doors/server/set-locks", function(DoorId, Bool)
    Config.Doors[DoorId].Locked = Bool
    TriggerClientEvent('mercy-doors/client/sync-doors', -1, DoorId, Config.Doors[DoorId])
end)

RegisterNetEvent("mercy-doors/server/toggle-locks", function(DoorId)
    if DoorId == nil then return end
    if Config.Doors[DoorId] == nil then return end
    Config.Doors[DoorId].Locked = not Config.Doors[DoorId].Locked
    TriggerClientEvent('mercy-doors/client/sync-doors', -1, DoorId, Config.Doors[DoorId])
end)

