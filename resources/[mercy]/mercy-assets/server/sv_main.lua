CallbackModule, CommandsModule = nil, nil, nil
local BlockedModels = {}

-- [ Code ] --

local _Ready = false
AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Callback',
        'Commands',
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        CommandsModule = exports['mercy-base']:FetchModule('Commands')
        _Ready = true
    end)
end)

-- [ Code ] --

Citizen.CreateThread(function() 
    while not _Ready do 
        Citizen.Wait(4) 
    end 

    -- [ Commands ] --

    CommandsModule.Add("shuff", "Shuff your ass", {}, false, function(source, args)
        TriggerClientEvent('mercy-assets/client/shuffle-seat', source)
    end)

    CommandsModule.Add("duty", "Duty Menu", {}, false, function(source, args)
        TriggerClientEvent('mercy-base/client/duty-menu', source)
    end, "admin")
    
    CallbackModule.CreateCallback('mercy-assets/server/get-dui-data', function(Source, Cb)
        Cb(Config.SavedDuiData)
    end)
end)

-- [ Threads ] --

-- Anti Peds / Vehs / Props
Citizen.CreateThread(function()
    for _, Entities in pairs(Config.BlacklistedEntitys) do
        table.insert(BlockedModels, Entities)
    end
end)

AddEventHandler("entityCreating", function(Entity)
    for _, Hash in pairs(BlockedModels) do
        if Hash and GetEntityModel(Entity) == Hash then
            CancelEvent()
            break
        end
    end
end)

-- [ Events ] --

RegisterNetEvent("mercy-assets/server/tackle-player", function(PlayerId)
    TriggerClientEvent("mercy-assets/client/get-tackled", PlayerId)
end)

RegisterNetEvent("mercy-assets/server/set-dui-url", function(DuiId, URL)
    TriggerClientEvent('mercy-assets/client/set-dui-url', -1, DuiId, URL)
end)

RegisterNetEvent('mercy-assets/server/set-dui-data', function(DuiId, DuiData)
    Config.SavedDuiData[DuiId] = DuiData
    TriggerClientEvent('mercy-assets/client/set-dui-data', -1, DuiId, Config.SavedDuiData[DuiId])
end)

RegisterNetEvent("mercy-assets/server/toggle-effect", function(TargetId, Effect, Bool)
    TriggerClientEvent("mercy-assets/client/toggle-effect", -1, TargetId, Effect, nil, Bool)
end)