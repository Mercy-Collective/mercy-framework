local CurrentlyPanning = false

local PanConfigs = {
    ['goldpan-s'] = { Streak = 1, Multiplier = 1 },
    ['goldpan-m'] = { Streak = 2, Multiplier = 2 },
    ['goldpan-l'] = { Streak = 3, Multiplier = 3 },
}

RegisterNetEvent("mercy-items/client/used/gold-pan", function(Item)
    if CurrentlyPanning then return end
    if GetVehiclePedIsIn(PlayerPedId()) ~= 0 then return end
    if not IsEntityInWater(PlayerPedId()) then return end
    if IsPedSwimming(PlayerPedId()) or IsPedSwimmingUnderWater(PlayerPedId()) then return end

    local Result = exports['mercy-ui']:StartSkillTest(PanConfigs[Item.ItemName].Streak, { 10, 25 }, { 1500, 4500 }, false)
    if not Result then return end

    CurrentlyPanning = true
    Citizen.SetTimeout(16000, function()
        CurrentlyPanning = false
    end)

    EventsModule.TriggerServer('mercy-inventory/server/degen-item', Item.Slot, 2)

    local AnimDict, AnimName = 'amb@world_human_bum_wash@male@high@idle_a', 'idle_a'
    FunctionsModule.RequestAnimDict(AnimDict)
    TaskPlayAnim(PlayerPedId(), AnimDict, AnimName, 1.0, -1.0, -1, 1, false, false, false)

    Citizen.Wait(800)
    exports['mercy-assets']:AttachProp("GoldPan")
    Citizen.Wait(7000)
    StopAnimTask(PlayerPedId(), AnimDict, AnimName, 1.0)
    exports['mercy-assets']:RemoveProps()
    EventsModule.TriggerServer("mercy-misc/server/goldpanning/get-loot", PanConfigs[Item.ItemName].Multiplier)
end)