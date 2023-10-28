
function DrillMinigame()
    local Promise = promise:new()

    FunctionsModule.RequestAnimDict("anim@heists@fleeca_bank@drilling")
    TaskPlayAnim(PlayerPedId(), 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle' , 3.0, 3.0, -1, 1, 0, false, false, false)
    exports['mercy-assets']:AttachProp('Drill')

    exports['mercy-ui']:StartDrilling(function(Outcome)
        exports['mercy-assets']:RemoveProps()
        exports["mercy-inventory"]:SetBusyState(false)
        StopAnimTask(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)

        Promise:resolve(Outcome)
    end)

    if not IsWearingHandshoes() and math.random(1, 100) <= 85 then
        TriggerServerEvent("mercy-police/server/create-evidence", 'Fingerprint')
    end

    return Citizen.Await(Promise)
end
exports("DrillMinigame", DrillMinigame)