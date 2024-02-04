-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('mercy-heists/client/stores-steal-register', function(Data, Entity)
    local EntityCoords = GetEntityCoords(Entity)
    local RegisterId = GetRegisterIdByCoords(EntityCoords)
    local Secure = CallbackModule.SendCallback('mercy-police/server/can-rob')
    if Secure then return exports['mercy-ui']:Notify("heists-error", "Secure active!", "error") end
    if RegisterId == nil then
        TriggerEvent('mercy-ui/client/notify', "storerob-error", "Something went wrong! (Try Again!)", 'error')
        return
    end
    if exports['mercy-police']:GetTotalOndutyCops() < Config.StoreCops then
        TriggerEvent('mercy-ui/client/notify', "storerob-error", "You can\'t do this right now..", 'error')
        return
    end
    local CanRob = CallbackModule.SendCallback('mercy-heists/server/stores/register-robbable', RegisterId)
    if CanRob then
        if math.random(1, 100) > 75 then
            local StreetLabel = FunctionsModule.GetStreetName()
            EventsModule.TriggerServer('mercy-ui/server/send-store-rob', StreetLabel)
        end
        EventsModule.TriggerServer('mercy-ui/server/set-stress', 'Add', math.random(1, 3))
        TriggerServerEvent('mercy-heists/server/stores/set-state', RegisterId, 'Busy', true)
        TriggerEvent('mercy-assets/client/lockpick-animation', true)
        if not IsWearingHandshoes() and math.random(1, 100) > 75 then
            TriggerServerEvent("mercy-police/server/create-evidence", 'Fingerprint')
        end

        local Outcome = exports['mercy-ui']:StartSkillTest(6, { 7, 10 }, { 1500, 3000 }, false)
        TriggerEvent('mercy-assets/client/lockpick-animation', false)
        if Outcome then
            TriggerServerEvent('mercy-heists/server/stores/set-state', RegisterId, 'Robbed', true)
            EventsModule.TriggerServer('mercy-heists/server/stores/receive-money')
        else
            TriggerServerEvent('mercy-heists/server/stores/set-state', RegisterId, 'Busy', false)
            TriggerEvent('mercy-ui/client/notify', "storerob-error", "Failed attempt..", 'error')
        end
    else
        TriggerEvent('mercy-ui/client/notify', "storerob-error", "Something went wrong!", 'error')
    end
end)

RegisterNetEvent('mercy-heists/client/stores-inspect-register', function(Data, Entity)
    local EntityCoords = GetEntityCoords(Entity)
    local RegisterId = GetRegisterIdByCoords(EntityCoords)
    if RegisterId == nil then return end
    local Robbable = CallbackModule.SendCallback('mercy-heists/server/stores/register-robbable', RegisterId)
    if not Robbable then
        TriggerEvent('mercy-ui/client/notify', "storerob-register", "Looks like a smashed register..", 'error')
    else
        TriggerEvent('mercy-ui/client/notify', "storerob-register", "It's just a register bwo..", 'success')
    end
end)

-- [ Functions ] --

function GetRegisterIdByCoords(Coords)
    for k, v in pairs(Config.Registers) do
        local Distance = #(Coords - v['Coords'])
        if Distance < 1.3 then
            return k
        end
    end
    return nil
end

exports("GetRegisterIdByCoords", GetRegisterIdByCoords)
