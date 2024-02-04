local DoingPartsCheck, VehicleEffect = false, {}

Citizen.CreateThread(function()
    for k, v in pairs(Config.HayesZones) do
        exports['mercy-ui']:AddEyeEntry(v.name, {
            Type = 'Zone',
            SpriteDistance = 10.0,
            Distance = 1.5,
            ZoneData = {
                Center = v.center,
                Length = v.length,
                Width = v.width,
                Data = {
                    heading = v.heading,
                    minZ = v.minZ,
                    maxZ = v.maxZ
                },
            },
            Options = v.options
        })
    end
end)

function InitHayes()
    Config.VehicleParts = GetHayesConfig()
end

function GetHayesConfig()
    local Promise = promise:new()
    CallbackModule.TriggerCallback("mercy-business/server/hayes/get-parts", function(ConfigData)
        Promise:resolve(ConfigData)
    end)
    return Citizen.Await(Promise)
end

function IsHayes()
    if IsPlayerInBusiness("Hayes Repairs") then
        return true
    end
    
    if IsPlayerInBusiness("6STR. Tuner Shop") then
        return true
    end

    if IsPlayerInBusiness("Ottos Autos") then
        return true
    end

    return false
end
exports("IsHayes", IsHayes)

function GetTotalPercentage(Parts)
    local Retval = 0
    for k, v in pairs(Parts) do
        Retval = Retval + v
    end
    return (Retval / 600) * 100
end

RegisterNetEvent("mercy-threads/entered-vehicle", function() 
    local Vehicle = GetVehiclePedIsIn(PlayerPedId())
    local Plate = GetVehicleNumberPlateText(Vehicle)
    if Config.VehicleParts[Plate] == nil then
        return
    end

    DoingPartsCheck = true
    Citizen.CreateThread(function()
        while DoingPartsCheck do
            Citizen.Wait(4)
            if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() and GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId())) > 5 then 
                local Plate, Speed, Class = GetVehicleNumberPlateText(Vehicle), GetEntitySpeed(Vehicle), GetVehicleClass(Vehicle)

                -- Engine
                if Config.VehicleParts[Plate].Engine < 15.0 and IsVehicleEngineOn(Vehicle) then
                    if math.random(1, 100) < 35 then
                        SetVehicleEngineOn(Vehicle, false, true, true)
                        exports['mercy-ui']:Notify('hayes-error', "Vehicle engine stalled!", "error")
                    end
                end

                -- Brakes
                if Config.VehicleParts[Plate].Brakes < 15.0 then
                    local CurrentBrakes = GetVehicleHandlingFloat(Vehicle, 'CHandlingData', 'fBrakeForce')
                    if CurrentBrakes ~= 0 then
                        if VehicleEffect[Plate] == nil then VehicleEffect[Plate] = {} end
                        SetVehicleHandlingFloat(Vehicle, "CHandlingData", "fBrakeForce", 0.0)
                        VehicleEffect[Plate].Brakes = CurrentBrakes
                    end
                elseif Config.VehicleParts[Plate].Brakes >= 15.0 and VehicleEffect[Plate] ~= nil and VehicleEffect[Plate].Brakes ~= nil then
                    SetVehicleHandlingFloat(Vehicle, "CHandlingData", "fBrakeForce", VehicleEffect[Plate].Brakes)
                    VehicleEffect[Plate].Brakes = nil
                end

                -- Clutch
                if Config.VehicleParts[Plate].Clutch < 15.0 and VehicleEffect[Plate] ~= nil and not VehicleEffect[Plate].Clutch then
                    SetEntityMaxSpeed(Vehicle, 20.0)
                    VehicleEffect[Plate].Clutch = true
                elseif Config.VehicleParts[Plate].Clutch >= 15.0 and VehicleEffect[Plate] ~= nil and VehicleEffect[Plate].Clutch then
                    local MaxSpeed = GetVehicleHandlingFloat(Vehicle, "CHandlingData", "fInitialDriveMaxFlatVel")
                    SetEntityMaxSpeed(Vehicle, MaxSpeed)
                    VehicleEffect[Plate].Clutch = false
                end

                -- Axle
                if Config.VehicleParts[Plate].Axle < 15.0 then
                    local CurrentSteer = GetVehicleHandlingFloat(Vehicle, 'CHandlingData', 'fSteeringLock')
                    if CurrentBrakes ~= 0 then
                        if VehicleEffect[Plate] == nil then VehicleEffect[Plate] = {} end
                        SetVehicleHandlingFloat(Vehicle, "CHandlingData", "fSteeringLock", 20.0)
                        VehicleEffect[Plate].Axle = CurrentSteer
                    end
                elseif Config.VehicleParts[Plate].Axle >= 15.0 and VehicleEffect[Plate] ~= nil and VehicleEffect[Plate].Axle ~= nil then
                    SetVehicleHandlingFloat(Vehicle, "CHandlingData", "fSteeringLock", VehicleEffect[Plate].Axle)
                    VehicleEffect[Plate].Axle = nil
                end

                -- Fuel Injectors
                if Config.VehicleParts[Plate].FuelInjectors < 15.0 then
                    local CurrentFuel = exports['mercy-vehicles']:GetFuelRate(Plate)
                    exports['mercy-vehicles']:SetFuelRateOnVehicle(Plate, 5.0)
                elseif exports['mercy-vehicles']:GetFuelRate(Plate) > 1.0 then
                    exports['mercy-vehicles']:SetFuelRateOnVehicle(Plate, 1.0)
                end

                Citizen.Wait(7000 * 1.5)
            else
                Citizen.Wait(450)
            end
        end
    end)
end)

RegisterNetEvent("mercy-threads/exited-vehicle", function() 
    DoingPartsCheck = false
end)

RegisterNetEvent("mercy-business/client/hayes/sync-parts", function(Plate, Parts)
    Config.VehicleParts[Plate] = Parts
end)

RegisterNetEvent("mercy-business/client/hayes/check-vehicle", function(Data, Entity)
    local Plate = GetVehicleNumberPlateText(Entity)
    if Config.VehicleParts[Plate] == nil then
        return exports['mercy-ui']:Notify("hayes-error", "You see very few screws and are amazed that this vehicle moves forward..", "error")
    end

    local VehicleData = Shared.Vehicles[GetEntityModel(Entity)]
    if VehicleData == nil then
        return exports['mercy-ui']:Notify("hayes-error", "This vehicle can't be checked..", "error")
    end
    
    local MenuItems = {}
    MenuItems[#MenuItems + 1] = {
        ['CloseMenu'] = false,
        ['Title'] = VehicleData.Name .. " | " .. Plate,
        ['Desc'] = "Class: " .. VehicleData.Class .. " | Total percentage: " .. Round(GetTotalPercentage(Config.VehicleParts[Plate]), 2) .. "%",
        ['Data'] = { ['Event'] = '', ['Type'] = 'Client'},
    }

    MenuItems[#MenuItems + 1] = {
        ['Title'] = "Vehicle Diagnostics",
        ['Desc'] = "Check the condition of the parts.",
        ['Data'] = { ['Event'] = '', ['Type'] = 'Client'},
        ['SecondMenu'] = {}
    }

    if IsPlayerInBusiness("6STR. Tuner Shop") then
        MenuItems[#MenuItems + 1] = {
            ['Title'] = "Vehicle Options",
            ['Desc'] = "Mount a racing harness or nitrous bottle..",
            ['Data'] = { ['Event'] = '', ['Type'] = 'Client'},
            ['SecondMenu'] = {
                {
                    ['CloseMenu'] = true,
                    ['Disabled'] = false,
                    ['Title'] = 'Race harness',
                    ['Desc'] = "Current Condition: " .. Round(exports['mercy-vehicles']:GetVehicleMeta(Entity, 'Harness'), 2) .. '%',
                    ['Data'] = { ['Event'] = "mercy-business/client/hayes/mount-misc", ['Type'] = "Client", ['Misc'] = "Harness", ['Vehicle'] = Entity },
                },
                {
                    ['CloseMenu'] = true,
                    ['Disabled'] = not IsToggleModOn(Entity, 18),
                    ['Title'] = 'Nitrous Bottle',
                    ['Desc'] = "Current Condition: " .. Round(exports['mercy-vehicles']:GetVehicleMeta(Entity, 'Nitrous'), 2) .. '%',
                    ['Data'] = { ['Event'] = "mercy-business/client/hayes/mount-misc", ['Type'] = "Client", ['Misc'] = "Nitrous", ['Vehicle'] = Entity },
                },
            }
        }
    end

    for PartName, PartValue in pairs(Config.VehicleParts[Plate]) do
        table.insert(MenuItems[2].SecondMenu, {
            ['CloseMenu'] = false,
            ['Title'] = 'Vehicle ' .. PartName,
            ['Desc'] = "Current Condition: " .. Round(PartValue, 2) .. '%',
            ['Data'] = { Event = "", Type = "Client" },
        })
    end

    exports['mercy-ui']:OpenContext({
        ['MainMenuItems'] = MenuItems,
    })
end)

RegisterNetEvent("mercy-business/client/hayes/mount-part", function(Item, Type, Class)
    if IsPedInAnyVehicle(PlayerPedId()) then
        return exports['mercy-ui']:Notify("hayes-error", "You cannot mount a vehicle part from here..", "error")
    end
    local Entity, EntityType, EntityCoords = FunctionsModule.GetEntityPlayerIsLookingAt(4.0, 0.2, 286, PlayerPedId())
    if Entity == nil or Entity <= 0 or EntityType == nil or EntityType ~= 2 or Shared.Vehicles[GetEntityModel(Entity)] == nil then return exports['mercy-ui']:Notify("hayes-error", "Looks like this part does not fit on this vehicle..", "error") end

    local Model = GetEntityModel(Entity)
    local VehicleData = Shared.Vehicles[GetEntityModel(Entity)]


    if VehicleData.Class ~= Class then
        return exports['mercy-ui']:Notify("hayes-error", "Looks like this part does not fit on this vehicle..", "error")
    end

    local Animation = {}
    if Type ~= 'Brakes' and Type ~= 'Axle' then
        Animation = {
            ['AnimDict'] = "mini@repair",
            ['AnimName'] = "fixing_a_player",
            ['AnimFlag'] = 16,
        }
    else
        TriggerEvent('mercy-animations/client/play-animation', "welding")
    end

    exports["mercy-inventory"]:SetBusyState(true)
    exports['mercy-ui']:ProgressBar('Repairing..', 12500, Animation, false, true, true, function(DidComplete)
        ClearPedTasks(PlayerPedId())
        exports["mercy-inventory"]:SetBusyState(false)
        if Animation['AnimDict'] then StopAnimTask(PlayerPedId(), Animation['AnimDict'], Animation['AnimName'], 1.0) end
        if DidComplete then
            local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', Item, 1, nil, true, Class)
            if DidRemove then
                local Plate = GetVehicleNumberPlateText(Entity)
                EventsModule.TriggerServer('mercy-business/server/hayes/repair-part', Plate, Type)
            else
                exports['mercy-ui']:Notify("hayes-error", "So where did the vehicle part go?", "error")
            end
        end
    end)
end)

RegisterNetEvent("mercy-business/client/hayes/mount-misc", function(Data)
    local Item = exports['mercy-inventory']:GetItemByName(Data.Misc:lower())
    if not Item then
        return exports['mercy-ui']:Notify("hayes-error", "You are missing an item..", "error")
    end

    if Data.Misc == "Nitrous" and not IsToggleModOn(Data.Vehicle, 18) then
        return exports['mercy-ui']:Notify("hayes-error", "This vehicle does not have a Turbo to install the nitro bottle on..", "error")
    end

    TriggerEvent('mercy-animations/client/play-animation', "welding")
    exports["mercy-inventory"]:SetBusyState(true)
    exports['mercy-ui']:ProgressBar('Repairing..', 12500, false, false, true, true, function(DidComplete)
        ClearPedTasks(PlayerPedId())
        exports["mercy-inventory"]:SetBusyState(false)
        if DidComplete then
            local NewPercentage = CallbackModule.SendCallback("mercy-business/server/hayes/get-new-percentage", Data.Misc, Item.CreateDate, Item.Slot, NetworkGetNetworkIdFromEntity(Data.Vehicle))
            exports['mercy-ui']:Notify("hayes-error", "Harness repaired to " .. Round(NewPercentage, 2) .. "%")
        end
    end)
end)

RegisterNetEvent("mercy-business/client/hayes/stash", function(Data)
    if not exports['mercy-business']:HasPlayerBusinessPermission(Data.Business, 'stash_access') then
        return exports['mercy-ui']:Notify("hayes-error", "No access..", "error")
    end

    if exports['mercy-inventory']:CanOpenInventory() then
        EventsModule.TriggerServer('mercy-inventory/server/open-other-inventory', Data.Name .. '_stash', 'Stash', 55, 1300)
    end
end)

RegisterNetEvent("mercy-business/client/hayes/craft", function(Data)
    if not exports['mercy-business']:HasPlayerBusinessPermission(Data.Business, 'craft_access') then
        return exports['mercy-ui']:Notify("hayes-error", "No access..", "error")
    end

    if exports['mercy-inventory']:CanOpenInventory() then
        EventsModule.TriggerServer('mercy-inventory/server/open-other-inventory', (Data.Business == '6STR. Tuner Shop' and 'Tuner' or Data.Business == 'Ottos Autos' and 'Ottos' or 'Hayes')..' Crafting', 'Crafting', 0, 0, Config.HayesCrafting)
    end
end)