local InsideBenchContainer = false

-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('mercy-polyzone/client/enter-polyzone', function(PolyData, Coords)
    if PolyData.name == 'crafting_bench' then
        if not InsideBenchContainer then
            InsideBenchContainer = true
        end
    else
        return
    end
end)

RegisterNetEvent('mercy-polyzone/client/leave-polyzone', function(PolyData, Coords)
    if PolyData.name == 'crafting_bench' then
        if InsideBenchContainer then
            InsideBenchContainer = false
        end
    else
        return
    end
end)

RegisterNetEvent('mercy-illegal/client/open-crafting-bench', function()
    if exports['mercy-inventory']:CanOpenInventory() then
        EventsModule.TriggerServer('mercy-inventory/server/open-other-inventory', 'Bench Crafting', 'Crafting', 0, 0, Config.BenchCrafting)
    end
end)

-- [ Functions ] --

function IsInsideBenchContainer()
    return InsideBenchContainer
end
exports("IsInsideBenchContainer", IsInsideBenchContainer)

-- function IsContainerWhitelisted()
--     local CitizenId = PlayerModule.GetPlayerData().CitizenId
--     for k, v in pairs(Config.ContainerWhitelist) do
--         if CitizenId == v then
--             return true
--         end
--     end
--     return false
-- end
-- exports("IsContainerWhitelisted", IsContainerWhitelisted)