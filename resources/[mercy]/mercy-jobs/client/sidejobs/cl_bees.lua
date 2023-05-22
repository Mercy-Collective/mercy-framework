local MaterialHashes = {-461750719, 930824497, 581794674,  -2041329971,  -309121453,  -913351839,  -1885547121,  -1915425863,  -1833527165,  2128369009,  -124769592,  -840216541,  -2073312001,  627123000,  1333033863,  -1286696947,  -1942898710,  -1595148316,  435688960,  223086562,  1109728704}
local ActiveHives, SetDeleteAll = {}, false

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            if Config.BeeHives == nil then Config.BeeHives = {} end
            for k, v in ipairs(Config.BeeHives) do
                if k % 100 == 0 then
                    Citizen.Wait(0)
                end

                if #(PlayerCoords - vector3(v.Coords.X, v.Coords.Y, v.Coords.Z)) < 50.0 and not SetDeleteAll then
                    local CurrentStage = GetStageFromHive(v.Stage)
                    local IsChanged = (ActiveHives[v.Id] and ActiveHives[v.Id].Stage ~= CurrentStage)

                    if IsChanged then RemoveHive(v.Id) end

                    if not ActiveHives[v.Id] or IsChanged then
                        local BeeHive = CreateHive(CurrentStage, v.Coords)
                        ActiveHives[v.Id] = {
                            Object = BeeHive,
                            Stage = CurrentStage
                        }
                    end
                else
                    RemoveHive(v.Id)
                end
            end

            if SetDeleteAll then
                SetDeleteAll = false
                Config.BeeHives = {}
            end
            Citizen.Wait(3500)
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while BlipModule == nil do Citizen.Wait(100) end

    Config.BeeHives = GetBeesConfig()
        
    exports['mercy-ui']:AddEyeEntry(GetHashKey("beehive"), {
        Type = 'Model',
        Model = 'beehive',
        SpriteDistance = 5.0,
        Options = {
            {
                Name = 'bees_check_hive',
                Icon = 'fas fa-dna',
                Label = 'Check Hive',
                EventType = 'Client',
                EventName = 'mercy-jobs/client/bees/open-context',
                EventParams = '',
                Enabled = function(Entity)
                    return true
                end,
            },
            {
                Name = 'bees_pickup_hive',
                Icon = 'fas fa-hand-holding',
                Label = 'Pickup Hive',
                EventType = 'Client',
                EventName = 'mercy-jobs/client/bees/hive-pickup',
                EventParams = '',
                Enabled = function(Entity)
                    return true
                end,
            }
        }
    })
    exports['mercy-ui']:AddEyeEntry(GetHashKey("beehive02"), {
        Type = 'Model',
        Model = 'beehive02',
        SpriteDistance = 5.0,
        Options = {
            {
                Name = 'bees_check_hive',
                Icon = 'fas fa-dna',
                Label = 'Check Hive',
                EventType = 'Client',
                EventName = 'mercy-jobs/client/bees/open-context',
                EventParams = '',
                Enabled = function(Entity)
                    return true
                end,
            },
            {
                Name = 'bees_pickup_hive',
                Icon = 'fas fa-hand-holding',
                Label = 'Pickup Hive',
                EventType = 'Client',
                EventName = 'mercy-jobs/client/bees/hive-pickup',
                EventParams = '',
                Enabled = function(Entity)
                    return true
                end,
            },
        }
    })
    exports['mercy-ui']:AddEyeEntry(GetHashKey("beehive03"), {
        Type = 'Model',
        Model = 'beehive03',
        SpriteDistance = 5.0,
        Options = {
            {
                Name = 'bees_check_hive',
                Icon = 'fas fa-dna',
                Label = 'Check Hive',
                EventType = 'Client',
                EventName = 'mercy-jobs/client/bees/open-context',
                EventParams = '',
                Enabled = function(Entity)
                    return true
                end,
            },
            {
                Name = 'bees_harvest_hive',
                Icon = 'fas fa-dna',
                Label = 'Harvest Hive',
                EventType = 'Client',
                EventName = 'mercy-jobs/client/bees/hive-harvest',
                EventParams = '',
                Enabled = function(Entity)
                    return true
                end,
            },
        }
    })
    exports['mercy-ui']:AddEyeEntry("bee-shop", {
        Type = 'Entity',
        EntityType = 'Ped',
        SpriteDistance = 10.0,
        Distance = 5.0,
        Position = vector4(1392.22, 2161.68, 96.70, 148.29),
        Model = 'a_f_y_vinewood_03',
        Anim = {},
        Props = {},
        Options = {
            {
                Name = 'bee_store',
                Icon = 'fas fa-circle',
                Label = 'Store',
                EventType = 'Client',
                EventName = 'mercy-stores/client/open-store',
                EventParams = 'Bees',
                Enabled = function(Entity)
                    return true
                end,
            }
        }
    })
    exports['mercy-polyzone']:CreateBox({
        center = vector3(1380.76, 2179.35, 101.63), 
        length = 69.0, 
        width = 65.0,
    }, {
        name = 'bee_hives',
        minZ = 85.83,
        maxZ = 102.43,
        heading = 0.0,
        hasMultipleZones = false,
        debugPoly = false,
    }, function() end, function() end)
    
    BlipModule.CreateBlip('bees', vector3(1388.53, 2179.55, 97.97), 'Bee Farm', 106, 0, false, 0.38)
end)

-- [ Events ] --

RegisterNetEvent('mercy-jobs/client/bees/action', function(Type, Data)
    if Type == 1 then
        Config.BeeHives = Data
    end
    if Type == 2 then
        Config.BeeHives[#Config.BeeHives + 1] = Data
    end
    if Type == 3 then
        for k, v in ipairs(Config.BeeHives) do
            if v.Id == Data.Id then
                Config.BeeHives[k] = Data
                break
            end
        end
    end
    if Type == 4 then
        for k, v in ipairs(Config.BeeHives) do
            if v.Id == Data.Id then
                table.remove(Config.BeeHives, k)
                RemoveHive(v.Id)
                break
            end
        end
    end
end)

RegisterNetEvent('mercy-jobs/client/bees-place-hive', function()
    Citizen.SetTimeout(450, function()
        EntityModule.DoEntityPlacer('beehive', 15.0, true, true, nil, function(DidPlace, Coords, Heading)
            if DidPlace then
                local FoundPlace = false
                local RayHandle = StartExpensiveSynchronousShapeTestLosProbe(Coords.x, Coords.y, Coords.z, Coords.x, Coords.y, Coords.z - 2, 1, 0, 4)
                local _, Hit, _, _, MaterialHash, _ = GetShapeTestResultIncludingMaterial(RayHandle)
                if Hit then
                    for k, v in pairs(MaterialHashes) do
                        if MaterialHash == v then
                            FoundPlace = true
                            local DidRemove = CallbackModule.SendCallback("mercy-base/server/remove-item", 'beehive', 1, false, true)
                            if DidRemove then
                                EventsModule.TriggerServer('mercy-jobs/server/bees/place', Coords, Heading)
                            end
                        end
                    end
                else
                    TriggerEvent('mercy-ui/client/notify', "bees-error", "You can not place any hives here..", 'error')
                end
            else
                exports['mercy-ui']:Notify("bees-error", "You stopped placing the hive or an error occured..", "error")
            end
        end)
    end)
end)

RegisterNetEvent('mercy-jobs/client/bees/add-queen', function(Data)
    exports['mercy-inventory']:SetBusyState(true)
    exports['mercy-ui']:ProgressBar('Adding Mlady..', 2000, nil, nil, true, true, function(DidComplete)
        if DidComplete then
            local DidRemove = CallbackModule.SendCallback("mercy-base/server/remove-item", 'bee-queen', 1, false, true)
            if DidRemove then
                TriggerServerEvent('mercy-jobs/server/bees/do-stuff', 'Queen', Data.HiveId)
            end
        end
        exports['mercy-inventory']:SetBusyState(false)
    end)
end)

RegisterNetEvent('mercy-jobs/client/bees/hive-pickup', function(Nothing, Entity)
    local HiveId = GetHiveId(Entity)
    local HiveData = GetHiveById(HiveId)
    if HiveData ~= nil then
        exports['mercy-ui']:ProgressBar('Grabbing Beehive..', 5000, nil, nil, true, true, function(DidComplete)
            if DidComplete then
                TriggerServerEvent('mercy-jobs/server/bees/do-stuff', 'Destroy', HiveData.Id)
            end
            exports['mercy-inventory']:SetBusyState(false)
            ClearPedTasks(PlayerPedId())
        end) 
    else
        TriggerEvent('mercy-ui/client/notify', "bees-error", "An error occured!", 'error')
    end
end)

RegisterNetEvent('mercy-jobs/client/bees/hive-harvest', function(Nothing, Entity)
    local HiveId = GetHiveId(Entity)
    local HiveData = GetHiveById(HiveId)
    if HiveData ~= nil then
        exports['mercy-ui']:ProgressBar('Harvesting Beehive..', 5000, nil, nil, true, true, function(DidComplete)
            if DidComplete then
                TriggerServerEvent('mercy-jobs/server/bees/do-stuff', 'Harvest', HiveData.Id)
            end
            exports['mercy-inventory']:SetBusyState(false)
            ClearPedTasks(PlayerPedId())
        end) 
    else
        TriggerEvent('mercy-ui/client/notify', "bees-error", "An error occured!", 'error')
    end
end)

RegisterNetEvent('mercy-jobs/client/bees/open-context', function(Nothing, Entity)
    local HiveId = GetHiveId(Entity)
    if HiveId and exports['mercy-inventory']:CanOpenInventory() then
        ShowHiveMenu(HiveId)
    end
end)

-- [ Functions ] --

function ShowHiveMenu(HiveId)
    local HiveData = GetHiveById(HiveId)
    if HiveData ~= nil then
        local MenuData = {}
        local HiveStage = GetStageFromHive(HiveData.Stage)

        local HasQueen = exports['mercy-inventory']:HasEnoughOfItem('bee-queen', 1)

        MenuData[#MenuData + 1] = {
            ['Title'] = 'Beehive #'..HiveId,
            ['Desc'] = 'Queen: '..tostring(HiveData.Queen)..'; Progression: '..HiveData.Stage..'%',
            ['Data'] = {['Event'] = '', ['Type'] = ''},
        }

        if not HiveData.Queen then
            MenuData[#MenuData + 1] = {
                ['Title'] = 'Add Queen',
                ['Desc'] = 'Mlady..',
                ['Data'] = {['Event'] = 'mercy-jobs/client/bees/add-queen', ['Type'] = 'Client', ['HiveId'] = HiveId},
                ['Disabled'] = not HasQueen
            }
        end

        exports['mercy-ui']:OpenContext({ ['MainMenuItems'] = MenuData })
    else
        TriggerEvent('mercy-ui/client/notify', "bees-error", "An error occured!", 'error')
    end
end

function CreateHive(Stage, Coords)
    local Model = Config.HiveObjects[Stage].Hash
    if FunctionsModule.RequestModel(Model) then
        local HiveObject = CreateObject(Model, Coords.X, Coords.Y, Coords.Z, false, true, false)
        FreezeEntityPosition(HiveObject, true)
        SetEntityHeading(HiveObject, Coords.H + 0.0)
        return HiveObject
    end
end

function RemoveHive(HiveId)
    if ActiveHives[HiveId] == nil then return end

    DeleteObject(ActiveHives[HiveId].Object)
    ActiveHives[HiveId] = nil
end

function GetHiveId(Entity)
    for k, v in pairs(ActiveHives) do
        if v.Object == Entity then
            return k
        end
    end
    return false
end

function GetHiveById(HiveId)
    for k, v in pairs(Config.BeeHives) do
        if v.Id == HiveId then
            return v
        end
    end
    return false
end

function GetStageFromHive(Stage)
    if Stage < 30 then
        return 1
    elseif Stage >= 30 and Stage <= 99 then
        return 2
    elseif Stage > 99 and Stage <= 100 then
        return 3
    end
end

function GetBeesConfig()
    local Data = CallbackModule.SendCallback("mercy-jobs/server/bees/get-config")
    return Data
end