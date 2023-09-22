local BaitLastPlaced, BaitLocation, CanSell = 0, nil, true
local HuntingLocation = vector3(-584.46, 4749.62, 212.64)

local ItemBuffs = {
    ['Beefdish'] = false
}

local HuntingAnimals = {
    {['Animal'] = 'Pig',            ['Model'] = GetHashKey('a_c_pig'),        ['Illegal'] = false},
    {['Animal'] = 'Cow',            ['Model'] = GetHashKey('a_c_cow'),        ['Illegal'] = false},
    {['Animal'] = 'Boar',           ['Model'] = GetHashKey('a_c_boar'),       ['Illegal'] = false},
    {['Animal'] = 'Deer',           ['Model'] = GetHashKey('a_c_deer'),       ['Illegal'] = false},
    {['Animal'] = 'Coyote',         ['Model'] = GetHashKey('a_c_coyote'),     ['Illegal'] = false},
    {['Animal'] = 'Mountain-Lion',  ['Model'] = GetHashKey('a_c_mtlion'),     ['Illegal'] = true},
    {['Animal'] = 'Retriever',      ['Model'] = GetHashKey('a_c_retriever'),  ['Illegal'] = true},
    {['Animal'] = 'Rottweiler',     ['Model'] = GetHashKey('a_c_rottweiler'), ['Illegal'] = true},
}

DecorRegister("HuntingSpawn", 2)
DecorRegister("HuntingIllegal", 2)

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            if not InsideHuntingZone() then
                if IsPedArmed(PlayerPedId(), 6) then
                    local Weapon = GetSelectedPedWeapon(PlayerPedId())
                    if Weapon == GetHashKey('weapon_sniperrifle2') then
                        TriggerEvent('mercy-inventory/client/reset-weapon')
                    end
                end
            end
            Citizen.Wait(2500)
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while BlipModule == nil do Citizen.Wait(100) end

    BlipModule.CreateBlip('hunting', HuntingLocation, 'Hunting Area', 141, 26, false, 0.43)
    BlipModule.CreateBlip('hunting-sales', vector3(569.4, 2796.63, 42.02), 'Hunting Sales', 442, 26, false, 0.43)
    BlipModule.CreateRadiusBlip('hunting-area', HuntingLocation, 0, 700.0)
    exports['mercy-ui']:AddEyeEntry("hunting-sells", {
        Type = 'Entity',
        EntityType = 'Ped',
        SpriteDistance = 5.0,
        Position = vector4(569.25, 2796.69, 41.35, 270.65),
        Model = 'csb_chef',
        Anim = {},
        Props = {},
        Options = {
            {
                Name = 'hunting_sell',
                Icon = 'fas fa-dollar-sign',
                Label = 'Sell',
                EventType = 'Client',
                EventName = 'mercy-jobs/client/hunting/sell',
                EventParams = {},
                Enabled = function(Entity)
                    return true
                end,
            }
        }
    })
end)

-- [ Events ] --

RegisterNetEvent('mercy-items/client/do-food-buff', function(Item, Bool)
    if not ItemBuffs[Item] then
        ItemBuffs[Item] = Bool
    end
end)

RegisterNetEvent('mercy-jobs/client/hunting/sell', function()
    if not CanSell then return end

    EventsModule.TriggerServer('mercy-jobs/server/hunting/sell') CanSell = false
    Citizen.SetTimeout(10000, function()
        CanSell = true
    end)
end)

RegisterNetEvent('mercy-items/client/used-hunting-bait', function()
    if InsideHuntingZone() then
        if BaitLastPlaced == 0 or GetGameTimer() > (BaitLastPlaced + (60000 * 10)) then
            ClearPedTasks(PlayerPedId())
            TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
            exports['mercy-inventory']:SetBusyState(true)
            exports['mercy-ui']:ProgressBar('Placing Bait..', 5000, false, false, true, true, function(DidComplete)
                if DidComplete then
                    local DidRemove = CallbackModule.SendCallback("mercy-base/server/remove-item", 'hunting-bait', 1, false, true)
                    if DidRemove then
                        BaitLocation = GetEntityCoords(PlayerPedId())
                        BaitLastPlaced = GetGameTimer()
                        ClearPedTasks(PlayerPedId())
                        BaitDown()
                    end
                end
                exports['mercy-inventory']:SetBusyState(false)
            end)
        else
            TriggerEvent('mercy-ui/client/notify', "hunting-error", "Your nose can\'t take it yet..", 'error')
        end
    else
        TriggerEvent('mercy-ui/client/notify', "hunting-error", "You are not in hunting area..", 'error')
    end
end)

RegisterNetEvent('mercy-items/client/used-hunting-knife', function()
    local EntityLookingAt = exports['mercy-base']:GetCurrentEntity()
    if EntityLookingAt == nil then return end

    local MyAnimal, EntityType = EntityLookingAt, GetEntityType(EntityLookingAt)
    local IsAnimal = GetPedType(MyAnimal) == 28
    --local IsHuman = GetPedType(MyAnimal) == 4 or GetPedType(MyAnimal) == 5

    if EntityType ~= 1 then return end
    if IsAnimal and IsPedDeadOrDying(MyAnimal) then
        local AnimalName = GetAnimalName(MyAnimal)
        local BaitAnimal = DecorExistOn(MyAnimal, "HuntingSpawn") and DecorGetBool(MyAnimal, "HuntingSpawn")
        local IllegalAnimal = DecorExistOn(MyAnimal, "HuntingIllegal") and DecorGetBool(MyAnimal, "HuntingIllegal")
        TaskTurnPedToFaceEntity(PlayerPedId(), MyAnimal, -1)
        Citizen.Wait(1500)
        ClearPedTasksImmediately(PlayerPedId())
        TriggerEvent('mercy-inventory/client/reset-weapon')
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
        exports['mercy-ui']:ProgressBar('Skinning..', 5000, false, false, true, true, function(DidComplete)
            if DidComplete then
                if not DoesEntityExist(MyAnimal) then return end
                EntityModule.DeleteEntity(MyAnimal)
                --if IsHuman then
                --    -- Add human goods fucking creep
                --else
                    EventsModule.TriggerServer('mercy-jobs/server/hunting/receive-goods', AnimalName, BaitAnimal, IllegalAnimal, ItemBuffs['Beefdish'])
                --end
                if not exports['mercy-police']:IsStatusAlreadyActive('huntbleed') then
                    TriggerEvent('mercy-police/client/evidence/set-status', 'huntbleed', 300)
                end
            else
                TriggerEvent('mercy-ui/client/notify', "hunting-error", "Preparing Cancelled!", 'error')
            end
            ClearPedTasks(PlayerPedId())
        end)
    else
        TriggerEvent('mercy-ui/client/notify', "hunting-error", "No animal found!", 'error')
    end

end)

-- [ Functions ] --

function BaitDown()
    Citizen.CreateThread(function()
        if BaitLocation ~= nil then
            local SpawnCoords = GetAnimalSpawnCoords(BaitLocation)
            local RandomAnimal = HuntingAnimals[math.random(1, #HuntingAnimals)]
            Citizen.SetTimeout(math.random(15000, 60000), function()
                local LoadedProp = FunctionsModule.RequestModel(RandomAnimal['Model'])
                if LoadedProp then
                    local SpawnedAnimal = CreatePed(28, RandomAnimal['Model'], SpawnCoords.x, SpawnCoords.y, SpawnCoords.z, true, true, true)
                    DecorSetBool(SpawnedAnimal, "HuntingSpawn", true)
                    DecorSetBool(spawnedAnimal, "HuntingIllegal", RandomAnimal['Illegal'])
        
                    if RandomAnimal['Illegal'] and math.random(55) < 15 then
                        local StreetLabel = FunctionsModule.GetStreetName()
                        EventsModule.TriggerServer('mercy-ui/server/send-hunting-illegal', StreetLabel)
                    end
    
                    TaskGoStraightToCoord(SpawnedAnimal, BaitLocation, 20.0, -1, 0.0, 0.0)
                    Citizen.CreateThread(function()
                        local Finished = false
                        while not Finished and not IsPedDeadOrDying(SpawnedAnimal) and not IsPedFleeing(SpawnedAnimal) do
                            Citizen.Wait(0)
                            local AnimalCoords = GetEntityCoords(SpawnedAnimal)
                            if #(BaitLocation - AnimalCoords) < 1.5 then
                                ClearPedTasks(SpawnedAnimal)
                                Citizen.Wait(350)
                                TaskStartScenarioInPlace(SpawnedAnimal, "WORLD_DEER_GRAZING", 0, true)
                                Citizen.SetTimeout(7500, function()
                                    ClearPedTasks(SpawnedAnimal)
                                    TaskSmartFleePed(SpawnedAnimal, PlayerPedId(), 10.0, -1)
                                    Finished, BaitLocation = true, nil
                                end)
                            end
                            if #(AnimalCoords - GetEntityCoords(PlayerPedId())) < 15.0 then
                                ClearPedTasks(SpawnedAnimal)
                                TaskSmartFleePed(SpawnedAnimal, PlayerPedId(), 600.0, -1)
                                Finished, BaitLocation = true, nil
                            end
                            if IsPedDeadOrDying(SpawnedAnimal) then
                                ClearPedTasks(SpawnedAnimal)
                                TaskSmartFleePed(SpawnedAnimal, PlayerPedId(), 600.0, -1)
                                Finished, BaitLocation = true, nil
                            end
                        end
                    end)
                end
            end)
        end
    end)
end

function GetAnimalSpawnCoords(Coords)
    local RandomX = math.random(-50, 50)
    local RandomY = math.random(-50, 50)
    local NewCoords = vector3(Coords.x + RandomX, Coords.y + RandomY, Coords.z)
    local Nothing, ResultZ = GetGroundZAndNormalFor_3dCoord(NewCoords.x, NewCoords.y, 1023.9)
    return vector3(NewCoords.x, NewCoords.y, ResultZ)
end

function InsideHuntingZone()
    local Coords = GetEntityCoords(PlayerPedId())
    local Distance = #(Coords - HuntingLocation)
    if Distance < 700.0 then
        return true
    else
        return false
    end
end

function GetAnimalName(Ped)
    local AnimalHash = GetEntityModel(Ped)
    local AnimalDNA = "Unknown-Animal"
    for k, v in pairs(HuntingAnimals) do
        if v['Model'] == AnimalHash then
            AnimalDNA = v['Animal']
        end
    end
    return AnimalDNA
end

exports("InsideHuntingZone", InsideHuntingZone)