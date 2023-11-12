local NearGasStation, GasStationClass, HasFuelNozzle, HasChargerNozzle, FuelRates, InVehicle, Fueling, Rope = false, false, false, false, {}, false, false, nil

local Pumps = { "prop_gas_pump_1a", "prop_gas_pump_1b", "prop_gas_pump_1c", "prop_gas_pump_1d", "prop_gas_pump_old2", "prop_gas_pump_old3", "prop_vintage_pump" }
local Chargers = { "electric_charger", }

-- [ Events ] --

RegisterNetEvent("mercy-threads/entered-vehicle", function() 
    local Vehicle = GetVehiclePedIsIn(PlayerPedId())
    local Plate = GetVehicleNumberPlateText(Vehicle)
    InVehicle = true

    CreateThread(function()
        while InVehicle do
            if not IsVehicleEngineOn(Vehicle) then
                goto Skip
            end

            if CurrentVehicleData.IsDriver then
                local FuelLevel = GetVehicleMeta(Vehicle, 'Fuel')
                if FuelLevel ~= 0 then
                    if GetEntitySpeed(Vehicle) > 3 then
                        local NewLevel = tonumber(FuelLevel) - (0.3 * (FuelRates[CurrentVehicleData.Plate] or 1.0))
                        -- print("Fuel - Current: " .. FuelLevel .. " | New: " .. NewLevel .. " | Rate: " .. (FuelRates[CurrentVehicleData.Plate] or 1.0))
                        SetFuelLevel(Vehicle, tonumber(NewLevel))
                        Wait(12500)
                    end
                end
            end
            ::Skip::
            Wait(1000)
        end
    end)
end)

RegisterNetEvent("mercy-threads/exited-vehicle", function() 
    InVehicle = false
end)

-- Electric

RegisterNetEvent("mercy-vehicles/client/fuel/use-charger", function()
    local MenuItems = {
        {
            ['Title'] = 'Electric Charger',
            ['Desc'] = 'Select the charge type you want to use',
            ['Data'] = {['Event'] = '', ['Type'] = ''},
        },
        {
            ['Title'] = 'Fast Charge',
            ['Desc'] = 'Price per KWH: $' ..Config.ChargePrice..',-',
            ['Data'] = {['Event'] = 'mercy-vehicles/client/fuel/grab-charger-hose', ['Type'] = 'Client'}
        },
    }
    exports['mercy-ui']:OpenContext({ ['MainMenuItems'] = MenuItems })
end)

RegisterNetEvent("mercy-vehicles/client/fuel/grab-charger-hose", function()
    HasChargerNozzle = true
    FunctionsModule.RequestAnimDict("anim@am_hold_up@male")
    TaskPlayAnim(PlayerPedId(), "anim@am_hold_up@male", "shoplift_high", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
    TriggerEvent("mercy-ui/client/play-sound", "pickupnozzle", 0.4)
    Wait(300)
    StopAnimTask(PlayerPedId(), "anim@am_hold_up@male", "shoplift_high", 1.0)
    exports['mercy-assets']:AttachProp('ChargerNozzle')
    local ElectricNozzle = exports['mercy-assets']:GetSpecificProp('ChargerNozzle')
    if not ElectricNozzle then return end
    local Charger, ChargerCoords = GetClosestPump(true)
    RopeLoadTextures()
    while not RopeAreTexturesLoaded() do Wait(0) RopeLoadTextures() end
    while not Charger do Wait(0) end
    Rope = AddRope(ChargerCoords.x, ChargerCoords.y, ChargerCoords.z, 0.0, 0.0, 0.0, 3.0, 1, 1000.0, 0.0, 1.0, false, false, false, 1.0, true)
    while not Rope do Wait(0) end
    ActivatePhysics(Rope)
    Wait(100)
    local NozzlePos = GetEntityCoords(ElectricNozzle)
    NozzlePos = GetOffsetFromEntityInWorldCoords(ElectricNozzle, -0.005, 0.185, -0.05)
    AttachEntitiesToRope(Rope, Charger, ElectricNozzle, ChargerCoords.x, ChargerCoords.y, ChargerCoords.z + 1.76, NozzlePos.x, NozzlePos.y, NozzlePos.z, 5.0, false, false, nil, nil)
    CreateThread(function()
        while HasChargerNozzle do
            if not exports['mercy-assets']:GetSpecificPropStatus('ChargerNozzle') then
                exports['mercy-assets']:AttachProp('ChargerNozzle')
            end
            Wait(100)
        end
    end)
end)

RegisterNetEvent("mercy-vehicles/client/fuel/return-charger-hose", function()
    FunctionsModule.RequestAnimDict("anim@am_hold_up@male")
    TaskPlayAnim(PlayerPedId(), "anim@am_hold_up@male", "shoplift_high", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
    TriggerEvent("mercy-ui/client/play-sound", "putbacknozzle", 0.4)
    Wait(300)
    RopeUnloadTextures()
    DeleteRope(Rope)
    Rope = nil
    HasChargerNozzle = false
    exports['mercy-assets']:RemoveProps()
end)

-- Fueling

RegisterNetEvent("mercy-vehicles/client/fuel/use-pump", function()
    local MenuItems = {
        {
            ['Title'] = 'Gas Pump',
            ['Desc'] = 'Select the type of fuel you want to use',
            ['Data'] = {['Event'] = '', ['Type'] = ''},
        },
        {
            ['Title'] = 'Regular',
            ['Desc'] = 'Octane: 95 | Price per liter: $' ..Config.FuelPrice..',-',
            ['Data'] = {['Event'] = 'mercy-vehicles/client/fuel/grab-fuel-hose', ['Type'] = 'Client'}
        }
    }
    exports['mercy-ui']:OpenContext({ ['MainMenuItems'] = MenuItems })
end)


RegisterNetEvent("mercy-vehicles/client/fuel/grab-fuel-hose", function()
    HasFuelNozzle = true
    FunctionsModule.RequestAnimDict("anim@am_hold_up@male")
    TaskPlayAnim(PlayerPedId(), "anim@am_hold_up@male", "shoplift_high", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
    TriggerEvent("mercy-ui/client/play-sound", "pickupnozzle", 0.4)
    Wait(300)    
    exports['mercy-assets']:AttachProp('FuelNozzle')
    local FuelNozzle = exports['mercy-assets']:GetSpecificProp('FuelNozzle')
    if not FuelNozzle then return end
    local Pump, PumpCoords = GetClosestPump()
    RopeLoadTextures()
    while not RopeAreTexturesLoaded() do Wait(0) RopeLoadTextures() end
    while not Pump do Wait(0) end
    Rope = AddRope(PumpCoords.x, PumpCoords.y, PumpCoords.z, 0.0, 0.0, 0.0, 3.0, 1, 1000.0, 0.0, 1.0, false, false, false, 1.0, true)
    while not Rope do Wait(0) end
    ActivatePhysics(Rope)
    Wait(100)
    local NozzlePos = GetEntityCoords(FuelNozzle)
    NozzlePos = GetOffsetFromEntityInWorldCoords(FuelNozzle, -0.005, 0.185, -0.05)
    AttachEntitiesToRope(Rope, Pump, FuelNozzle, PumpCoords.x, PumpCoords.y, PumpCoords.z + 1.0, NozzlePos.x, NozzlePos.y, NozzlePos.z, 5.0, false, false, nil, nil)
    CreateThread(function()
        while HasFuelNozzle do
            if not exports['mercy-assets']:GetSpecificPropStatus('FuelNozzle') then
                exports['mercy-assets']:AttachProp('FuelNozzle')
            end
            Wait(100)
        end
    end)
end)

RegisterNetEvent("mercy-vehicles/client/fuel/return-fuel-hose", function()
    FunctionsModule.RequestAnimDict("anim@am_hold_up@male")
    TaskPlayAnim(PlayerPedId(), "anim@am_hold_up@male", "shoplift_high", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
    TriggerEvent("mercy-ui/client/play-sound", "putbacknozzle", 0.4)
    Wait(300)
    RopeUnloadTextures()
    DeleteRope(Rope)
    Rope = nil
    HasFuelNozzle = false
    exports['mercy-assets']:RemoveProps()
end)

RegisterNetEvent("mercy-vehicles/client/fuel/refuel-veh", function()
    if not NearGasStation or (not HasFuelNozzle and not HasChargerNozzle) then return end

    local IsElectricVeh = false
    local Entity, EntityType, EntityCoords = FunctionsModule.GetEntityPlayerIsLookingAt(4.0, 0.2, 286, PlayerPedId())
    if Entity <= 0 or EntityType ~= 2 then return end

    if IsElectricVehicle(Entity) then
        IsElectricVeh = true
    end

    local FuelLevel = GetVehicleFuelLevel(Entity)
    if (100 - FuelLevel) < 5 then
        if not IsElectricVeh then
            exports['mercy-ui']:Notify('tank-full', "Fuel tank is already at full capacity..", "error") 
        else
            exports['mercy-ui']:Notify('tank-full', "Vehicle is fully charged..", "error") 
        end
        return 
    end

    local IsBillPaid = CallbackModule.SendCallback("mercy-vehicles/server/fuel/is-bill-paid", GetVehicleNumberPlateText(Entity))

    local Description = IsElectricVeh and "Charge Level: " .. math.ceil(100 - FuelLevel) .. "% | Total Costs: $" .. math.floor(FunctionsModule.GetTaxPrice(((100 - FuelLevel) * Config.ChargePrice), "Gas")) or "Fuel Level: " .. math.ceil(100 - FuelLevel) .. " | Total Costs: $" .. math.floor(FunctionsModule.GetTaxPrice(((100 - FuelLevel) * Config.FuelPrice), "Gas"))

    local MenuItems = {
        {
            ['Title'] = (IsElectricVeh and "Recharge" or "Refuel")..' Vehicle',
            ['Desc'] = Description,
            ['Data'] = {['Event'] = '', ['Type'] = ''},
        },
        {
            ['Title'] = "<i style='width: 2.0vh;' class='fas fa-gas-pump'></i> Start "..(IsElectricVeh and "Charging" or "Refueling"),
            ['Disabled'] = not IsBillPaid,
            ['Data'] = {['Event'] = 'mercy-vehicles/client/fuel/start-refuel', ['Type'] = 'Client', ['Amount'] = 100 - FuelLevel, ['IsElectric'] = IsElectricVeh}
        },
        {
            ['Title'] = "<i style='width: 2.0vh;' class='fas fa-credit-card'></i> Send Bill",
            ['Disabled'] = IsBillPaid,
            ['Data'] = {['Event'] = 'mercy-vehicles/client/fuel/send-bill', ['Type'] = 'Client', ['SelfServe'] = false, ['IsElectric'] = IsElectricVeh}
        },
        {
            ['Title'] = "<i style='width: 2.0vh;' class='fas fa-portrait'></i> Self-service",
            ['Disabled'] = IsBillPaid,
            ['Data'] = {['Event'] = 'mercy-vehicles/client/fuel/send-bill', ['Type'] = 'Client', ['SelfServe'] = true, ['IsElectric'] = IsElectricVeh}
        },
    }
    exports['mercy-ui']:OpenContext({ ['MainMenuItems'] = MenuItems })
end)

RegisterNetEvent("mercy-vehicles/client/fuel/send-bill", function(Data)
    local Entity, EntityType, EntityCoords = FunctionsModule.GetEntityPlayerIsLookingAt(4.0, 0.2, 286, PlayerPedId())
    if Entity <= 0 or EntityType ~= 2 then return end

    local FuelLevel = GetVehicleFuelLevel(Entity)
    if 100 - FuelLevel < 5 then 
        if not Data['IsElectric'] then
            exports['mercy-ui']:Notify('tank-full', "Fuel tank is already at full capacity..", "error") 
        else
            exports['mercy-ui']:Notify('tank-full', "Vehicle is fully charged..", "error") 
        end
        return
    end

    local Plate = GetVehicleNumberPlateText(Entity)
    local Amount = 100 - FuelLevel

    if Data['SelfServe'] then
        TriggerServerEvent('mercy-vehicles/server/fuel/send-bill', Plate, PlayerModule.GetPlayerData().CitizenId, Amount, Data['IsElectric'])
    else
        SetTimeout(250, function()
            local Result = exports['mercy-ui']:CreateInput({
                { Label = 'StateId', Icon = 'fas fa-user', Name = 'Cid' },
            })
            if Result and Result.Cid then
                TriggerServerEvent('mercy-vehicles/server/fuel/send-bill', Plate, Result.Cid, Amount, Data['IsElectric'])
            end
        end)
    end
end)

RegisterNetEvent("mercy-vehicles/client/fuel/start-refuel", function(Data)
    local Entity, EntityType, EntityCoords = FunctionsModule.GetEntityPlayerIsLookingAt(4.0, 0.2, 286, PlayerPedId())
    if Entity <= 0 or EntityType ~= 2 then return end

    Fueling = true
    CreateThread(function()
        while Fueling and not Data.IsElectric do
            if IsVehicleEngineOn(Entity) then
                AddExplosion(GetEntityCoords(Entity), EXPLOSION_CAR, 4.0, true, false, 20.0)
                EventsModule.TriggerServer('mercy-ui/server/send-explosion', FunctionsModule.GetStreetName())
                exports['mercy-ui']:Notify('fuel-error', "Refueling the vehicle with engine on is not a good idea..", 'error')
            end
            Wait(250)
        end
    end)

    local Prop = nil
    if Data.IsElectric then
        TriggerEvent('mercy-vehicles/client/fuel/return-charger-hose')
        Wait(300)
        local NozzleHash = GetHashKey("electric_nozzle")
        if FunctionsModule.RequestModel(NozzleHash) then
            Prop = CreateObject(NozzleHash, 0, 0, 0, true, false, false)
            AttachEntityToEntity(Prop, Entity, GetEntityBoneIndexByName(Entity, "indicator_lr"), -0.1, 0.5, 0.0, 0.0, 0.0, -90.0, true, true, false, true, 1, true)
        end
    else
        TriggerEvent('mercy-vehicles/client/fuel/return-fuel-hose')
        Wait(300)
        local NozzleHash = GetHashKey("prop_cs_fuel_nozle")
        if FunctionsModule.RequestModel(NozzleHash) then
            Prop = CreateObject(NozzleHash, 0, 0, 0, true, false, false)
            AttachEntityToEntity(Prop, Entity, GetEntityBoneIndexByName(Entity, "indicator_lr"), -0.1, 0.5, 0.0, 0.0, 0.0, -90.0, true, true, false, true, 1, true)
        end
    end
    Wait(300)
    TriggerEvent('mercy-ui/client/notify', 'is-fueling', Data.IsElectric and "Vehicle is currently recharging and will be ready in "..math.ceil((500 * Data.Amount) / 1000).." seconds." or "Vehicle is currently refueling and will be ready in "..math.ceil(((500 * Data.Amount) / 1000)).." seconds.", 'success', 4000)

    Wait(500 * Data.Amount)

    Fueling = false
    DeleteEntity(Prop)
    if Data.IsElectric then
        TriggerEvent('mercy-vehicles/client/fuel/grab-charger-hose')
    else
        TriggerEvent('mercy-vehicles/client/fuel/grab-fuel-hose')
    end
    local Plate = GetVehicleNumberPlateText(Entity)
    SetFuelLevel(Entity, 100.0)
    TriggerEvent('mercy-ui/client/notify', 'fueled', Data.IsElectric and "Recharged Vehicle" or "Refueled Vehicle", 'success', 4000)
    TriggerServerEvent("mercy-vehicles/server/fuel/set-paid-state", Plate)
end)

-- [ Functions ] --

function InitGasStations()
    CreateThread(function()
        for k, v in pairs(Config.GasStations) do
            if v.blip then
                BlipModule.CreateBlip('gasstation-'..k, v.center, 'Gas Station', 361, 6, false, 0.38)
            end

            exports['mercy-polyzone']:CreateBox({ center = v.center, length = v.length, width = v.width, data = v.data }, {
                name = 'gas-station-'..k,
                heading = v.heading,
                minZ = v.minZ, maxZ = v.maxZ,
                IsMultiple = false, debugPoly = false,
            }, function(IsInside, Zone, Point)
                if Zone.data and Zone.data.vehicleClass then
                    GasStationClass = Zone.data.vehicleClass
                else
                    GasStationClass = false
                end
            end)
        end
        for i, j in pairs(Config.Chargers) do
            FunctionsModule.RequestModel('electric_charger')
            j.Charger = CreateObject('electric_charger',  j.Coords.x,  j.Coords.y,  j.Coords.z, false, true, true)
            SetEntityHeading(j.Charger, j.Coords.w - 180)
            FreezeEntityPosition(j.Charger, 1)
            BlipModule.CreateBlip('charger-'..i, j.Coords, 'Charger', 620 , 5, false, 0.38)
            
            local Offset = GetOffsetFromEntityInWorldCoords(j.Charger, 0.0, -3.0, 0.0)
            exports['mercy-polyzone']:CreateBox({ center = Offset, length = 6.0, width = 6.0}, {
                name = 'charger-'..i,
                heading = j.Coords.w,
                minZ = j.Coords.z - 1.0, maxZ = j.Coords + 1.0,
                IsMultiple = false, debugPoly = false,
            }, function(IsInside, Zone, Point)
            end)
        end
    end)

    for k, v in pairs(Chargers) do
        exports['mercy-ui']:AddEyeEntry(GetHashKey(v), {
            Type = 'Model',
            Model = v,
            SpriteDistance = 10.0,
            Options = {
                {
                    Name = "use_charger",
                    Icon = 'fas fa-charging-station',
                    Label = "Use Charger",
                    EventType = "Client",
                    EventName = "mercy-vehicles/client/fuel/use-charger",
                    EventParams = {},
                    Enabled = function(Entity)
                        return NearGasStation and not HasChargerNozzle
                    end,
                },
                {
                    Name = "return_hose",
                    Icon = 'fas fa-hand-holding',
                    Label = "Return Charger",
                    EventType = "Client",
                    EventName = "mercy-vehicles/client/fuel/return-charger-hose",
                    EventParams = {},
                    Enabled = function(Entity)
                        return NearGasStation and HasChargerNozzle
                    end,
                }
            }
        })
    end

    for k, v in pairs(Pumps) do
        exports['mercy-ui']:AddEyeEntry(GetHashKey(v), {
            Type = 'Model',
            Model = v,
            SpriteDistance = 10.0,
            Options = {
                {
                    Name = "use_pump",
                    Icon = 'fas fa-gas-pump',
                    Label = "Use Pump",
                    EventType = "Client",
                    EventName = "mercy-vehicles/client/fuel/use-pump",
                    EventParams = {},
                    Enabled = function(Entity)
                        return NearGasStation and not HasFuelNozzle
                    end,
                },
                {
                    Name = "return_hose",
                    Icon = 'fas fa-hand-holding',
                    Label = "Return Hose",
                    EventType = "Client",
                    EventName = "mercy-vehicles/client/fuel/return-fuel-hose",
                    EventParams = {},
                    Enabled = function(Entity)
                        return NearGasStation and HasFuelNozzle
                    end,
                }
            }
        })
    end
end

RegisterNetEvent('mercy-polyzone/client/enter-polyzone', function(PolyData, Coords)
    if string.match(PolyData.name, "charger") or string.match(PolyData.name, "gas") then
        NearGasStation = true
    end
end)

RegisterNetEvent('mercy-polyzone/client/leave-polyzone', function(PolyData, Coords)
    if string.match(PolyData.name, "charger") or string.match(PolyData.name, "gas") then
        NearGasStation = false
        if HasFuelNozzle or HasChargerNozzle then
            HasFuelNozzle = false
            HasChargerNozzle = false
            exports['mercy-assets']:RemoveProps()
            RopeUnloadTextures()
            DeleteRope(Rope)
            Rope = nil
        end
    end
end)

function SetFuelLevel(Vehicle, Amount)
    if Amount == nil then Amount = 100 end
    if Amount < 0 then Amount = 0 end
    if Amount > 100 then Amount = 100 end
    VehicleModule.SetVehicleFuelLevel(Vehicle, Amount + 0.0)
    SetVehicleMeta(Vehicle, 'Fuel', Amount + 0.0)
end
exports("SetFuelLevel", SetFuelLevel)

function GetFuelRate(Plate)
    return FuelRates[Plate] or 1.0
end
exports("GetFuelRate", GetFuelRate)

function SetFuelRateOnVehicle(Plate, Rate)
    FuelRates[Plate] = Rate
end
exports("SetFuelRateOnVehicle", SetFuelRateOnVehicle)

function CanRefuel()
    local ClosestVehicle = GetClosestVehicle(GetEntityCoords(PlayerPedId()).x, GetEntityCoords(PlayerPedId()).y, GetEntityCoords(PlayerPedId()).z, 3.0, 0, 70)
    return not Fueling and NearGasStation and (HasFuelNozzle and not IsElectricVehicle(ClosestVehicle) or HasChargerNozzle and IsElectricVehicle(ClosestVehicle))
end
exports("CanRefuel", CanRefuel)

function GetClosestPump(Electric)
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    if Electric then
        local Charger = nil
        local ChargerCoords = nil
        for k, v in pairs(Chargers) do
            Charger = GetClosestObjectOfType(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, 3.0, GetHashKey(v), true, true, true)
            ChargerCoords = GetEntityCoords(Charger)
        end
        return Charger, ChargerCoords
    else
        local Pump = nil
        local PumpCoords = nil
        local Tries = 0
        for k, v in pairs(Pumps) do
            Pump = GetClosestObjectOfType(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, 3.0, GetHashKey(v), true, true, true)
            PumpCoords = GetEntityCoords(Pump)
            if PumpCoords.x ~= 0.0 and PumpCoords.y ~= 0.0 and PumpCoords.z ~= 0.0 then
                break
            end
        end
        return Pump, PumpCoords
    end
    return false
end
exports("GetClosestPump", GetClosestPump)

function CanRefuelAircraft(Entity)
    return NearGasStation and GetVehicleClass(Entity) == GasStationClass
end
exports("CanRefuelAircraft", CanRefuelAircraft)

function IsElectricVehicle(Entity)
    local Model = GetEntityModel(Entity)
    for k, v in pairs(Config.ElectricVehicles) do
        if Model == GetHashKey(v) then
            return true
        end
    end
    return false
end
exports("IsElectricVehicle", IsElectricVehicle)