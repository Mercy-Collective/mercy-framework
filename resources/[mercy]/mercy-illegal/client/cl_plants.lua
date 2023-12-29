local MaterialHashes = {-461750719, 930824497, 581794674,  -2041329971,  -309121453,  -913351839,  -1885547121,  -1915425863,  -1833527165,  2128369009,  -124769592,  -840216541,  -2073312001,  627123000,  1333033863,  -1286696947,  -1942898710,  -1595148316,  435688960,  223086562,  1109728704}
local ActivePlants = {}

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            local PlayerCoords = GetEntityCoords(PlayerPedId())

            if Config.WeedPlants == nil then Config.WeedPlants = {} end

            for k, v in ipairs(Config.WeedPlants) do
                if k % 100 == 0 then
                    Citizen.Wait(0)
                end


                if #(PlayerCoords - vector3(v.Coords.X, v.Coords.Y, v.Coords.Z)) < 50.0 then
                    local CurrentStage = GetStageFromPlant(v.Stage)
                    local IsChanged = (ActivePlants[v.Id] and ActivePlants[v.Id].Stage ~= CurrentStage)

                    if IsChanged then RemovePlant(v.Id) end

                    if not ActivePlants[v.Id] or IsChanged then
                        local WeedPlant = CreatePlant(CurrentStage, v.Coords)
                        ActivePlants[v.Id] = {
                            Object = WeedPlant,
                            Stage = CurrentStage
                        }
                    end
                else
                    RemovePlant(v.Id)
                end
            end

            Citizen.Wait(3500)
        else
            Citizen.Wait(450)
        end
    end
end)

-- [ Events ] --

RegisterNetEvent('mercy-illegal/client/plants-action', function(Type, Data)
    if Type == 1 then
        Config.WeedPlants = Data
    elseif Type == 2 then
        Config.WeedPlants[#Config.WeedPlants + 1] = Data
    elseif Type == 3 then
        for k, v in ipairs(Config.WeedPlants) do
            if v.Id == Data.Id then
                Config.WeedPlants[k] = Data
                break
            end
        end
    elseif Type == 4 then
        for k, v in ipairs(Config.WeedPlants) do
            if v.Id == Data.Id then
                table.remove(Config.WeedPlants, k)
                RemovePlant(v.Id)
                break
            end
        end
    end
end)

RegisterNetEvent('mercy-items/client/used-seeds-female', function()
    Citizen.SetTimeout(500, function()
        local FoundPlace, PlayerCoords = false, GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 0.75, 0)
        local RayHandle = StartExpensiveSynchronousShapeTestLosProbe(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, PlayerCoords.x, PlayerCoords.y, PlayerCoords.z - 2, 1, 0, 4)
        local _, Hit, _, _, MaterialHash, _ = GetShapeTestResultIncludingMaterial(RayHandle)
        if Hit then
            for k, v in pairs(MaterialHashes) do
                if MaterialHash == v then
                    FoundPlace = true
                    exports['mercy-inventory']:SetBusyState(true)
                    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
                    exports['mercy-ui']:ProgressBar('Planting..', 5000, nil, nil, true, true, function(DidComplete)
                        if DidComplete then
                            local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', 'weed-seed-female', 1, false, true)
                            if DidRemove then
                                EventsModule.TriggerServer('mercy-illegal/server/plants-plant', vector3(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z - 0.97))
                            end
                            ClearPedTasks(PlayerPedId())
                        end
                        ClearPedTasks(PlayerPedId())
                        exports['mercy-inventory']:SetBusyState(false)
                    end)
                end
            end
            if not FoundPlace then
                TriggerEvent('mercy-ui/client/notify', "plant-error", "You can not place any plants here..", 'error')
            end
        else
            TriggerEvent('mercy-ui/client/notify', "plant-error", "You can not place any plants here..", 'error')
        end
    end)
end)

RegisterNetEvent('mercy-illegal/client/plants-pick-plant', function(Nothing, Entity)
    local PlantId = GetPlantId(Entity)
    local PlantData = GetPlantById(PlantId)
    if PlantData ~= nil then
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
        exports['mercy-ui']:ProgressBar('Harvesting Plant..', 5000, nil, nil, true, true, function(DidComplete)
            if DidComplete then
                TriggerServerEvent('mercy-illegal/server/do-plant-stuff', 'Harvest', PlantData.Id)
            end
            exports['mercy-inventory']:SetBusyState(false)
            ClearPedTasks(PlayerPedId())
        end)  
    else
        TriggerEvent('mercy-ui/client/notify', "plant-error", "An error occured!", 'error')
    end
end)

RegisterNetEvent('mercy-illegal/client/plants-water-plant', function(Data)
    exports['mercy-inventory']:SetBusyState(true)
    exports['mercy-ui']:ProgressBar('Watering..', 5000, {['AnimName'] = 'fire', ['AnimDict'] = 'weapon@w_sp_jerrycan', ['AnimFlag'] = 49}, nil, true, true, function(DidComplete)
        if DidComplete then
            local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', 'water', 1, false, true)
            if DidRemove then
                TriggerServerEvent('mercy-illegal/server/do-plant-stuff', 'Water', Data['PlantId'], math.random(40, 45))
            end
        end
        exports['mercy-inventory']:SetBusyState(false)
    end)
end)

RegisterNetEvent('mercy-illegal/client/plants-fertelize-plant', function(Data)
    exports['mercy-inventory']:SetBusyState(true)
    exports['mercy-ui']:ProgressBar('Fertilizing..', 5000, {['AnimName'] = 'fire', ['AnimDict'] = 'weapon@w_sp_jerrycan', ['AnimFlag'] = 49}, nil, true, true, function(DidComplete)
        if DidComplete then
            local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', 'fertilizer', 1, false, true)
            if DidRemove then
                TriggerServerEvent('mercy-illegal/server/do-plant-stuff', 'Fertilizer', Data['PlantId'], math.random(40, 45))
            end
        end
        exports['mercy-inventory']:SetBusyState(false)
    end)
end)

RegisterNetEvent('mercy-illegal/client/plants-add-male', function(Data)
    exports['mercy-inventory']:SetBusyState(true)
    exports['mercy-ui']:ProgressBar('Making Babies..', 2000, nil, nil, true, true, function(DidComplete)
        if DidComplete then
            local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', 'weed-seed-male', 1, false, true)
            if DidRemove then
                TriggerServerEvent('mercy-illegal/server/do-plant-stuff', 'Pregnant', Data['PlantId'])
            end
        end
        exports['mercy-inventory']:SetBusyState(false)
    end)
end)

RegisterNetEvent('mercy-illegal/client/plants-destroy', function(Nothing, Entity)
    local PlantId = GetPlantId(Entity)
    local PlantData = GetPlantById(PlantId)
    if PlantData ~= nil then
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
        exports['mercy-ui']:ProgressBar('Cutting Plant..', 5000, nil, nil, true, true, function(DidComplete)
            if DidComplete then
                TriggerServerEvent('mercy-illegal/server/do-plant-stuff', 'Destroy', PlantData.Id)
            end
            exports['mercy-inventory']:SetBusyState(false)
            ClearPedTasks(PlayerPedId())
        end)
    else
        TriggerEvent('mercy-ui/client/notify', "plant-error", "An error occured!", 'error')
    end
end)

RegisterNetEvent('mercy-illegal/client/plants-open-context', function(Nothing, Entity)
    local PlantId = GetPlantId(Entity)
    if PlantId and exports['mercy-inventory']:CanOpenInventory() then
        ShowPlantMenu(PlantId)
    end
end)

-- [ Functions ] --

function ShowPlantMenu(PlantId)
    local PlantData = GetPlantById(PlantId)
    if PlantData ~= nil then
        local MenuData = {}
        local PlantStage = GetStageFromPlant(PlantData.Stage)
        local HasWater = exports['mercy-inventory']:HasEnoughOfItem('water', 1)
        local HasFertilizer = exports['mercy-inventory']:HasEnoughOfItem('fertilizer', 1)
        local HasMaleSeed = exports['mercy-inventory']:HasEnoughOfItem('weed-seed-male', 1)

        MenuData[#MenuData + 1] = {
            ['Title'] = 'Weed Plant #'..PlantId,
            ['Desc'] = 'Health: '..PlantData.Health..'%; Water: '..PlantData.Water..'%; Fertilizer: '..PlantData.Fertilizer..'%; Pregnant: '..(PlantData.Pregnant == 'False' and 'No' or 'Yes'),
            ['Data'] = {['Event'] = '', ['Type'] = ''},
        }

        if PlantData.Water < 100 then
            MenuData[#MenuData + 1] = {
                ['Title'] = 'Add Water',
                ['Desc'] = 'Juice the plant up.',
                ['Data'] = {['Event'] = 'mercy-illegal/client/plants-water-plant', ['Type'] = 'Client', ['PlantId'] = PlantId},
                ['Disabled'] = not HasWater
            }
        end

        if PlantData.Fertilizer < 100 then
            MenuData[#MenuData + 1] = {
                ['Title'] = 'Add Fertilizer',
                ['Desc'] = 'Shit on this plant.',
                ['Data'] = {['Event'] = 'mercy-illegal/client/plants-fertelize-plant', ['Type'] = 'Client', ['PlantId'] = PlantId},
                ['Disabled'] = not HasFertilizer
            }
        end

        if (PlantData.Pregnant == 'False' and PlantStage <= 2) then -- Only add male in the 2 stages
            MenuData[#MenuData + 1] = {
                ['Title'] = 'Add Male Seed',
                ['Desc'] = 'Lets have babies?!',
                ['Data'] = {['Event'] = 'mercy-illegal/client/plants-add-male', ['Type'] = 'Client', ['PlantId'] = PlantId},
                ['Disabled'] = not HasMaleSeed
            }
        end

        exports['mercy-ui']:OpenContext({ ['MainMenuItems'] = MenuData })
    else
        TriggerEvent('mercy-ui/client/notify', "plant-error", "An error occured!", 'error')
    end
end

function InitPlants()
    Config.WeedPlants = GetPlantsConfig()
end

function GetPlantsConfig()
    local Config = CallbackModule.SendCallback('mercy-illegal/server/get-plants')
    return Config
end

function CreatePlant(Stage, Coords)
    local Model = Config.GrowthObjects[Stage]['Hash']
    local ModelLoaded = FunctionsModule.RequestModel(Model)
    if ModelLoaded then
        local PlantObject = CreateObject(Model, Coords.X, Coords.Y, Coords.Z + Config.GrowthObjects[Stage]['Z-Offset'], false, true, false)
        FreezeEntityPosition(PlantObject, true)
        SetEntityHeading(PlantObject, math.random(0, 360) + 0.0)
        return PlantObject
    end
end

function RemovePlant(PlantId)
    if ActivePlants[PlantId] ~= nil then
        DeleteObject(ActivePlants[PlantId]['Object'])
        ActivePlants[PlantId] = nil
    end
end

function IsPlantPickable(Entity)
    local PlantId = GetPlantId(Entity)
    local PlantData = GetPlantById(PlantId)
    if PlantData and type(PlantData.Stage) == 'number' then
        if PlantData.Stage >= 100 then
            return true
        else
            return false
        end
    else
        return false
    end
end

function GetPlantId(Entity)
    for k, v in pairs(ActivePlants) do
        if v['Object'] == Entity then
            return k
        end
    end
    return false
end

function GetPlantById(PlantId)
    for k, v in pairs(Config.WeedPlants) do
        if v.Id == PlantId then
            return v
        end
    end
    return false
end

function GetStageFromPlant(Stage)
    if Stage > 80 then
        return 5
    elseif Stage > 60 then
        return 4
    elseif Stage > 40 then
        return 3
    elseif Stage > 20 then
        return 2
    else
        return 1
    end
end

AddEventHandler('onResourceStop', function(ResourceName)
    if ResourceName == GetCurrentResourceName() then
        RemoveAllPlants()
    end
end)

function RemoveAllPlants()
    for k, v in pairs(ActivePlants) do
        RemovePlant(k) 
    end
    ActivePlants = {}
end

exports("IsPlantPickable", IsPlantPickable)