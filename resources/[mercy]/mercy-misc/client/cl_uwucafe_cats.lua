-- Cats
local Peds = {}
local NearbyPeds = {}

local Cats = {
    { Coords = vector3(-577.14, -1069.22, 22.99), Heading = 0, AnimDict = "creatures@cat@amb@world_cat_sleeping_ground@base", AnimName = "base", Interactable = true, Frozen = true },
    { Coords = vector3(-586.85, -1064.68, 23.35), Heading = 0, AnimDict = "creatures@cat@amb@world_cat_sleeping_ground@base", AnimName = "base", Interactable = true, Frozen = true },
    { Coords = vector3(-576.49, -1054.94, 22.42), Heading = 350.0, AnimDict = "creatures@cat@amb@world_cat_sleeping_ground@base", AnimName = "base", Interactable = true, Frozen = true },
    { Coords = vector3(-582.07, -1055.92, 22.43), Heading = 250.0, AnimDict = "creatures@cat@amb@world_cat_sleeping_ground@base", AnimName = "base", Interactable = true, Frozen = true },
    { Coords = vector3(-583.32, -1069.32, 22.99), Heading = 90.0, AnimDict = "creatures@cat@amb@world_cat_sleeping_ground@base", AnimName = "base", Interactable = true, Frozen = true },
    { Coords = vector3(-584.33, -1062.76, 23.40), Heading = 223.0, AnimDict = "creatures@cat@amb@world_cat_sleeping_ground@base", AnimName = "base", Interactable = true, Frozen = true, },
    { Coords = vector3(-575.53, -1049.41, 23.53), Heading = 90.0, AnimDict = "creatures@cat@amb@world_cat_sleeping_ground@base", AnimName = "base", Interactable = true, Frozen = true, },

    { Coords = vector3(-584.71, -1054.55, 23.10), Heading = 280.0, AnimDict = "creatures@cat@amb@world_cat_sleeping_ledge@base", AnimName = "base", Interactable = false, Frozen = true },
    { Coords = vector3(-576.78, -1057.52, 25.15), Heading = 0.0, AnimDict = "creatures@cat@amb@world_cat_sleeping_ledge@base", AnimName = "base", Interactable = false, Frozen = true },
    { Coords = vector3(-583.55, -1048.88, 25.50), Heading = 240.0, AnimDict = "creatures@cat@amb@world_cat_sleeping_ledge@base", AnimName = "base", Interactable = false, Frozen = true },
    { Coords = vector3(-595.29, -1055.54, 22.43), Heading = 180.0, AnimDict = "creatures@cat@amb@world_cat_sleeping_ledge@base", AnimName = "base", Interactable = false, Frozen = true },
    { Coords = vector3(-587.4, -1059.6, 23.3),    Heading = 180.0, AnimDict = "creatures@cat@amb@world_cat_sleeping_ledge@base", AnimName = "base", Interactable = false, Frozen = true },
    { Coords = vector3(-571.65, -1057.26, 22.54), Heading = 90.0, AnimDict = "creatures@cat@move", AnimName = "gallop", Interactable = false, Frozen = true },
}

Citizen.CreateThread(function()
    for k, v in pairs(Cats) do
        if v.Interactable then
            exports['mercy-ui']:AddEyeEntry("uwu_cat_" .. k, {
                Type = 'Zone',
                SpriteDistance = 10.0,
                Distance = 1.75,
                ZoneData = {
                    Center = vector3(v.Coords.x, v.Coords.y, v.Coords.z - 0.9),
                    Length = 0.7,
                    Width = 0.7,
                    Data = {
                        heading = 0,
                        minZ = v.Coords.z - 1.5,
                        maxZ = v.Coords.z - 0.5
                    },
                },
                Options = {
                    {
                        Name = 'pay_payment',
                        Icon = 'fas fa-paw-claws',
                        Label = 'Tickle Kitty',
                        EventType = 'Client',
                        EventName = 'mercy-misc/client/foodchain/uwu/pat',
                        EventParams = {},
                        Enabled = function(Entity)
                            -- local ClockedInEmployees = CallbackModule.SendCallback("mercy-business/server/get-clocked-in-employees", "UwU Café")
                            -- return #ClockedInEmployees >= 1
                            return true
                        end,
                    },
                }
            })
        end
    end

    PlaceCats()
end)

RegisterNetEvent('mercy-misc/client/foodchain/uwu/pat', function()
    FunctionsModule.RequestAnimDict("creatures@cat@amb@world_cat_sleeping_ground@exit")
    FunctionsModule.RequestAnimDict("creatures@cat@amb@world_cat_sleeping_ground@enter")

    local Coords = GetEntityCoords(PlayerPedId())
    for k,v in pairs(NearbyPeds) do
        local CatCoords = GetEntityCoords(v)
        local Distance = #(Coords - CatCoords)

        if Distance < 2 then
            TaskTurnPedToFaceEntity(PlayerPedId(), v, 1200)
            Citizen.Wait(1200)
            if CatCoords.z < 22 then
                TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
            elseif CatCoords.z > 22 then
                TriggerEvent('mercy-animations/client/play-animation', "mechanic4")
            end

            FreezeEntityPosition(PlayerPedId(), true)
            Citizen.Wait(1000)
            TaskPlayAnim(v, "creatures@cat@amb@world_cat_sleeping_ground@exit", "exit", 2.0, 200.0, 0.3, 8, 0.2, 0, 0, 0)
            Citizen.Wait(4000)
            RemoveAnimDict("creatures@cat@amb@world_cat_sleeping_ground@exit")
            FreezeEntityPosition(v, false)
            TaskTurnPedToFaceEntity(v, PlayerPedId(), 1000)
            Citizen.Wait(1000)
            FreezeEntityPosition(v, true)
            Citizen.Wait(1500)

            if math.random(1,2) == 2 then
                FunctionsModule.RequestAnimDict("creatures@cat@player_action@")
                TaskPlayAnim(v, "creatures@cat@player_action@", "action_a", 2.0, 200.0, 0.3, 8, 0.2, 0, 0, 0)
            end

            Citizen.Wait(4000)

            EventsModule.TriggerServer('mercy-ui/server/set-stress', 'Remove', 100)

            FreezeEntityPosition(PlayerPedId(), false)
            SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + math.random(3, 5))

            if CatCoords.z < 22 then
                TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
                Citizen.Wait(2800)
                ClearPedTasksImmediately(PlayerPedId())
            else
                TriggerEvent('mercy-animations/client/clear-animation')
            end
            PettingCat = false

            Citizen.Wait(3000)
            TaskPlayAnim(v, "creatures@cat@amb@world_cat_sleeping_ground@enter", "enter", 2.0, 200.0, 0.3, 2, 0.2, 0, 0, 0)
            SetEntityCoords(v, CatCoords.x, CatCoords.y, CatCoords.z-0.23, 0, 0, 0, true)
            break
        end
    end
end)

function PlaceCats()
    while true do
        Citizen.Wait(100)

        local Coords = GetEntityCoords(PlayerPedId())
        for k, v in pairs(Cats) do
            local Dist = #(Coords - v.Coords)

            if Dist < 40.0 and not Peds[k] then
                local ped = NearPed(v.Coords, v.Heading, v.AnimDict, v.AnimName, v.Frozen)
                Peds[k] = {ped = ped}
            end

            if Dist >= 40.0 and Peds[k] then
                DeletePed(Peds[k].ped)
                Peds[k] = nil
            end
        end
    end
end

function NearPed(Coords, Heading, AnimDict, AnimName, Frozen)
    FunctionsModule.RequestModel(GetHashKey("a_c_cat_01"))

    local x, y, z = table.unpack(Coords)
    local ped = CreatePed(5, GetHashKey("a_c_cat_01"), x, y, z - 1, Heading, false, true)

    table.insert(NearbyPeds, ped)

    if Frozen then FreezeEntityPosition(ped, true)  end
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    if AnimDict and AnimName then 
        FunctionsModule.RequestAnimDict(AnimDict) 
        TaskPlayAnim(ped, AnimDict, AnimName, 8.0, 0, -1, 1, 0, 0, 0) 
    end
    SetModelAsNoLongerNeeded("a_c_cat_01")
    return ped
end


AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for k, v in pairs(Peds) do
            DeletePed(v.ped)
        end
    end
end)