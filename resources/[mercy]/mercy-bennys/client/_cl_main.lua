PlayerModule, CallbackModule, LoggerModule, FunctionsModule, VehicleModule, BlipManager, EventsModule = nil, nil, nil, nil, nil, nil, nil

local _Ready, AlreadyDoing, IsInBennysZone = false, false, false

VehicleMods, CurrentBennyZone, CurrentRespray = {}, nil, nil
InVehicle, InBennys, IsAdmin, CurrentWheelfitmentIndex = false, false, false, 0

AddEventHandler('Modules/client/ready', function()
    if not _Ready then
        _Ready = true
        
        exports['mercy-polyzone']:CreateBox(Config.Zones, {
            name = "bennys",
            hasMultipleZones = true,
            debugPoly = true,
        })
    end

    TriggerEvent('Modules/client/request-dependencies', {
        'Player',
        'Callback',
        'Logger',
        'Functions',
        'Vehicle',
        'BlipManager',
        'Events',
    }, function(Succeeded)
        if not Succeeded then return end
        PlayerModule = exports['mercy-base']:FetchModule("Player")
        CallbackModule = exports['mercy-base']:FetchModule("Callback")
        LoggerModule = exports['mercy-base']:FetchModule("Logger")
        FunctionsModule = exports['mercy-base']:FetchModule("Functions")
        VehicleModule = exports['mercy-base']:FetchModule("Vehicle")
        BlipManager = exports['mercy-base']:FetchModule("BlipManager")
        EventsModule = exports['mercy-base']:FetchModule("Events")
    end)
end)

RegisterNetEvent('mercy-base/client/on-login', function()
    Citizen.SetTimeout(350, function()
        for k, v in pairs(Config.Zones) do
            if v.ShowBlip then
                BlipManager.CreateBlip('bennys-'..k, v.center, 'Benny\'s Original Motorworks', 446, 0, false, 0.48)
            end
        end
    end)
end)

-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('mercy-ui/client/ui-reset', function()
    if IsInBennysZone then
        CloseBennys()
    end
end)

-- RegisterNetEvent("baseevents:enteredVehicle")
-- AddEventHandler("baseevents:enteredVehicle", function(Vehicle, Seat, DisplayName, NetId)
--     InVehicle = true

--     Citizen.CreateThread(function()
--         while InVehicle do

--             if not InBennys then
--                 local WheelFitment = exports['mercy-vehicles']:GetVehicleMeta(Vehicle, 'WheelFitment')
--                 if WheelFitment then
--                     if WheelFitment.FLRotation ~= nil then SetVehicleWheelYRotation(Vehicle, 0, WheelFitment.FLRotation) end
--                     if WheelFitment.FRRotation ~= nil then SetVehicleWheelYRotation(Vehicle, 1, WheelFitment.FRRotation) end
--                     if WheelFitment.RLRotation ~= nil then SetVehicleWheelYRotation(Vehicle, 2, WheelFitment.RLRotation) end
--                     if WheelFitment.RRRotation ~= nil then SetVehicleWheelYRotation(Vehicle, 3, WheelFitment.RRRotation) end
--                 end
--             else
--                 Citizen.Wait(250)
--             end

--             Citizen.Wait(4)
--         end
--     end)
-- end)

-- RegisterNetEvent("baseevents:leftVehicle")
-- AddEventHandler("baseevents:leftVehicle", function(Vehicle, Seat, DisplayName, NetId)
--     InVehicle = false
-- end)

RegisterNetEvent('mercy-polyzone/client/enter-polyzone', function(PolyData, Coords)
    if PolyData.name == 'bennys' then
        CurrentBennyZone = PolyData
        table.insert(CurrentBennyZone, Config.Zones[PolyData.id])
        IsInBennysZone = true
        
        Citizen.CreateThread(function()
            local ShowingInteraction = false
            while IsInBennysZone do
                
                local Vehicle = GetVehiclePedIsUsing(PlayerPedId())
                if Vehicle ~= 0 then
                    if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() then
                        if not ShowingInteraction then
                            exports['mercy-ui']:SetInteraction("Benny's")
                            ShowingInteraction = true
                        end
                    else
                        if ShowingInteraction then
                            ShowingInteraction = false
                            exports['mercy-ui']:HideInteraction()
                        end
                    end
                else
                    if ShowingInteraction then
                        ShowingInteraction = false
                        exports['mercy-ui']:HideInteraction()
                    end
                end

                Citizen.Wait(1000)
            end
        end)
    end
end)

RegisterNetEvent('mercy-polyzone/client/leave-polyzone', function(PolyData, Coords)
    if PolyData.name == 'bennys' then
        exports['mercy-ui']:HideInteraction()
        CurrentBennyZone = nil
        IsInBennysZone = false
    end
end)

RegisterNetEvent('mercy-bennys/client/open-bennys', function(Admin)
    if not Admin and not CanOpenBennys(CurrentBennyZone.extra.Authorized) then return exports['mercy-ui']:Notify("bennys-use-err", "You can't use this Benny's.", "error") end
   
    local Vehicle = GetVehiclePedIsUsing(PlayerPedId())
    InBennys, IsAdmin = true, Admin
    if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() then
        PlaySoundFrontend(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)

        VehicleMods = VehicleModule.GetVehicleMods(Vehicle)
    
        if CurrentBennyZone ~= nil then
            SetEntityHeading(Vehicle, CurrentBennyZone.extra ~= nil and CurrentBennyZone.extra.Heading or CurrentBennyZone.offsetRot)
        end
        FreezeEntityPosition(Vehicle, true)
        SetNuiFocusKeepInput(true)
        SetNuiFocus(true, false)

        Citizen.CreateThread(function()
            while InBennys do
                DisableControlAction(0, 75, true)
                Citizen.Wait(4)
            end
        end)

        BuildMenu(Vehicle)
    else
        exports['mercy-ui']:Notify("bennys-error", "You must be the driver to use Benny's.", "error")
    end
end)

-- [ Functions ] --
function Round(Value, Decimals)
    return Decimals and math.floor((Value * 10 ^ Decimals) + 0.5) / (10 ^ Decimals) or math.floor(Value + 0.5)
end

function GetModPrice(Name, ModIndex)
    local Price = nil
    if ModIndex ~= nil and type(Config.Prices[Name]) == 'table' then
        Price = Config.Prices[Name][ModIndex] ~= nil and Config.Prices[Name][ModIndex] or Config.Prices[Name][#Config.Prices[Name]]
    elseif Config.Prices[Name] then
        Price = Config.Prices[Name]
    end

    return (Price ~= nil and Price or nil)
end

function GetIsInBennysZone()
    return IsInBennysZone
end

function CloseBennys(Data, Cb)
    InBennys, IsAdmin = false, false
    local Vehicle = GetVehiclePedIsUsing(PlayerPedId())
    FreezeEntityPosition(Vehicle, false)
    SetNuiFocusKeepInput(false)
    SetNuiFocus(false, false)
    SendNUIMessage({
        Action = 'SetVisibility',
        Bool = false,
    })
    if Cb then Cb('Ok') end
end

function CanOpenBennys(Authorized)
    if not Authorized then return true end

    if Authorized.Job then
        local MyJob = PlayerModule.GetPlayerData().Job.Name
        for k, Job in pairs(Authorized.Job) do
            if Job == MyJob then
                return true
            end
        end
    end

    if Authorized.Business then
        for k, Business in pairs(Authorized.Business) do
            if exports['mercy-business']:IsPlayerInBusiness(Business) then
                return true
            end
        end
    end

    return false
end

-- [ NUI Callbacks ] --

RegisterNUICallback("CloseBennys", CloseBennys)

RegisterNUICallback("PlaySoundFrontend", function(Data, Cb)
    PlaySoundFrontend(-1, Data.Name, Data.Set, true)
end)

RegisterNUICallback('PreviewUpgrade', function(Data, Cb)
    if Data.Menu == "WheelFitment" then
        CurrentWheelfitmentIndex = Data.Index
        return
    end

    local MenuItem = Menu.GetMenu(Data.Menu)
    if MenuItem == nil then return end

    if Data.Menu == 'ResprayMenu' then
        if Data.Index == 1 then
            CurrentRespray = 'Primary'
        elseif Data.Index == 2 then
            CurrentRespray = 'Secondary'
        elseif Data.Index == 3 then
            CurrentRespray = 'Pearlescent'
        elseif Data.Index == 4 then
            CurrentRespray = 'WheelColor'
        elseif Data.Index == 5 then
            CurrentRespray = 'Dashboard'
        elseif Data.Index == 6 then
            CurrentRespray = 'Interior'
        end
    end

    MenuItem = MenuItem.Items[Data.Index]
    if MenuItem == nil then return end
    
    if MenuItem.Data == nil then return end
    if MenuItem.Data.ModType == nil then return end
    if MenuItem.Data.ModIndex == nil then return end
    
    local Vehicle = GetVehiclePedIsIn(PlayerPedId())
    local ModType = MenuItem.Data.ModType
    local ModIndex = MenuItem.Data.ModIndex
    VehicleModule.ApplyVehicleMods(Vehicle, VehicleMods, GetVehicleNumberPlateText(Vehicle), true)
    
    if ModType == 'Windows' then
        SetVehicleWindowTint(Vehicle, ModIndex)
    elseif ModType == 'PlateIndex' then
        SetVehicleNumberPlateTextIndex(Vehicle, ModIndex)
    elseif ModType == 'Extra' then
        SetVehicleExtra(Vehicle, ModIndex, false)
    elseif ModType == 'NeonSide' then
        SetVehicleNeonLightEnabled(Vehicle, ModIndex, true)
    elseif ModType == 'NeonColor' then
        SetVehicleNeonLightsColour(Vehicle, ModIndex.R, ModIndex.G, ModIndex.B)
    elseif ModType == 'Respray' then
        local ColorPrimary, ColorSecondary = GetVehicleColours(Vehicle)
        local PearlescentColor, WheelColor = GetVehicleExtraColours(Vehicle)
        if CurrentRespray == 'Primary' then
            SetVehicleColours(Vehicle, ModIndex, ColorSecondary)
        elseif CurrentRespray == 'Secondary' then
            SetVehicleColours(Vehicle, ColorPrimary, ModIndex)
        elseif CurrentRespray == 'Dashboard' then
            SetVehicleDashboardColor(Vehicle, ModIndex)
        elseif CurrentRespray == 'Interior' then
            SetVehicleInteriorColor(Vehicle, ModIndex)
        elseif CurrentRespray == 'Pearlescent' then
            SetVehicleExtraColours(Vehicle, ModIndex, WheelColor)
        elseif CurrentRespray == 'WheelColor' then
            SetVehicleExtraColours(Vehicle, PearlescentColor, ModIndex)
        end
    elseif ModType == 'Wheels' then
        SetVehicleWheelType(Vehicle, MenuItem.Data.WheelType)
        SetVehicleMod(Vehicle, 23, ModIndex, GetVehicleModVariation(Vehicle, 23))
        SetVehicleMod(Vehicle, 24, ModIndex, GetVehicleModVariation(Vehicle, 23))
    elseif ModType == 'XenonColor' then
        SetVehicleXenonLightsColor(Vehicle, ModIndex)
    elseif ModType == 22 then
        ToggleVehicleMod(Vehicle, 22, ModIndex == 1)
    else
        Citizen.SetTimeout(10, function()
            SetVehicleMod(Vehicle, ModType, ModIndex, GetVehicleModVariation(Vehicle, 23))
        end)
    end

    VehicleModule.RepairVehicle(Vehicle)
    Cb('Ok')
end)

RegisterNUICallback('PurchaseUpgrade', function(Data, Cb)
    if AlreadyDoing then return end
    if Data.Menu == 'WheelFitment' then return end

    local Vehicle = GetVehiclePedIsIn(PlayerPedId())
    local Plate = GetVehicleNumberPlateText(Vehicle)
    local Button = Menu.GetMenu(Data.Menu).Items[tonumber(Data.Index)]
    local Cash = PlayerModule.GetPlayerData().Money.Cash

    if Data.Menu == 'Repair' then
        if tonumber(Button.Data.Costs) > Cash then
            return exports['mercy-ui']:Notify("bennys-error", "Not enough cash..", "error")
        end

        local BodyHealth = GetVehicleBodyHealth(Vehicle)
        local EngineHealth = GetVehicleEngineHealth(Vehicle)

        local MissingBodyHealth = 1000.0 - BodyHealth
        local MissingEngineHealth = 1000.0 - EngineHealth

        SetVehicleHandbrake(Vehicle, true)

        if MissingEngineHealth > 50 then
            exports['mercy-ui']:ProgressBar('Repairing Engine..', 5000 + (MissingEngineHealth / 50), false, false, true, false, function(DidComplete)
                if DidComplete then
                    SetVehicleEngineHealth(Vehicle, EngineHealth + MissingEngineHealth)
                    SetVehiclePetrolTankHealth(Vehicle, 1000.0)
                end
            end)
            Citizen.Wait(6500 + (MissingEngineHealth / 50))
        end

        if MissingBodyHealth > 50 then
            exports['mercy-ui']:ProgressBar('Repairing Body..', 5000 + (MissingBodyHealth / 50), false, false, true, false, function(DidComplete)
                if DidComplete then
                    SetVehicleDeformationFixed(Vehicle)
                    SetVehicleBodyHealth(Vehicle, BodyHealth + MissingBodyHealth)
                end
            end)
            Citizen.Wait(6500 + (MissingBodyHealth / 50))
        end

        if GetVehicleBodyHealth(Vehicle) >= 900 and GetVehicleEngineHealth(Vehicle) >= 900 then
            SetVehicleFixed(Vehicle)
        end

        SetVehicleHandbrake(Vehicle, false)

        if not IsAdmin then
            EventsModule.TriggerServer('mercy-base/server/remove-money', tonumber(Button.Data.Costs))
            TriggerEvent('mercy-ui/client/play-sound', 'bennys-wrench', 0.4)
            VehicleModule.RepairVehicle(Vehicle)
            Menu.RemoveMenu("Repair")
            if InBennys then BuildMenu(Vehicle) end
        end
    else
        if Button.Id == "Wheels" and (VehicleMods['Wheels'] == Button.Data.WheelType and VehicleMods['ModFrontWheels'] == Button.Data.ModIndex) then
            return exports['mercy-ui']:Notify("bennys-error", "Mod is already installed..", "error")
        elseif Button.Id ~= "Wheels" and VehicleMods[Button.Id] == Button.Data.ModIndex then
            return exports['mercy-ui']:Notify("bennys-error", "Mod is already installed..", "error")
        end

        if Button.Id == "ResprayColor" then
            local ColorPrimary, ColorSecondary = VehicleMods['ColorOne'], VehicleMods['ColorTwo']
            local PearlescentColor, WheelColor = VehicleMods['PearlescentColor'], VehicleMods['WheelColor']
            local DashboardColor, InteriorColor = VehicleMods['DashboardColor'], VehicleMods['InteriorColor']

            if CurrentRespray == 'Primary' and Button.Data.ModIndex == ColorPrimary then
                return exports['mercy-ui']:Notify("bennys-error", "Respray is already applied..", "error")
            elseif CurrentRespray == 'Secondary' and Button.Data.ModIndex == ColorSecondary then
                return exports['mercy-ui']:Notify("bennys-error", "Respray is already applied..", "error")
            elseif CurrentRespray == 'Dashboard' and Button.Data.ModIndex == DashboardColor then
                return exports['mercy-ui']:Notify("bennys-error", "Respray is already applied..", "error")
            elseif CurrentRespray == 'Interior' and Button.Data.ModIndex == InteriorColor then
                return exports['mercy-ui']:Notify("bennys-error", "Respray is already applied..", "error")
            elseif CurrentRespray == 'Pearlescent' and Button.Data.ModIndex == PearlescentColor then
                return exports['mercy-ui']:Notify("bennys-error", "Respray is already applied..", "error")
            elseif CurrentRespray == 'WheelColor' and Button.Data.ModIndex == WheelColor then
                return exports['mercy-ui']:Notify("bennys-error", "Respray is already applied..", "error")
            end
        end

        if tonumber(Button.Data.Costs) > Cash and not IsAdmin then
            return exports['mercy-ui']:Notify("bennys-error", "Not enough cash..", "error") 
        end

        if type(Button.Data.Costs) == 'number' and tonumber(Button.Data.Costs) > 0 and not IsAdmin then
            EventsModule.TriggerServer('mercy-base/server/remove-money', tonumber(Button.Data.Costs)) 
        end

        if Data.Menu == 'ResprayMetallic' or Data.Menu == 'ResprayMetal' or Data.Menu == 'ResprayMatte' then
            TriggerEvent('mercy-ui/client/play-sound', 'bennys-respray', 1.0)
        else
            TriggerEvent('mercy-ui/client/play-sound', 'bennys-wrench', 0.4)
        end
		local IsOwner = CallbackModule.SendCallback('mercy-vehicles/server/is-veh-owner', Plate)
        if Button.Data.ModType == 'Extra' then
            if VehicleMods['ModExtras'][Button.Data.ModIndex] == 0 then
                SetVehicleExtra(Vehicle, Button.Data.ModIndex, true)
            else
                SetVehicleExtra(Vehicle, Button.Data.ModIndex, false)
            end

            Menu.UpdateMenuSecondText(Data.Menu, Data.Index, IsVehicleExtraTurnedOn(Vehicle, Button.Data.ModIndex) and "ON" or "OFF")
        elseif Button.Data.ModType == 'Wheels' then
            -- Bugs out with other wheel types
            -- Button.Installed = IsModInstalled(Vehicle, Button.Data)
            -- Menu.UpdateMenuPopulation(Data.Menu, Data.Index, Button)
        elseif Button.Data.ModType == 18 then
            ToggleVehicleMod(Vehicle, 18, not IsToggleModOn(Vehicle, 18))
            Button.Installed = IsToggleModOn(Vehicle, 18)
            Menu.UpdateMenuPopulation(Data.Menu, Data.Index, Button)
        else
            Button.Installed = GetVehicleMod(Vehicle, Button.Data.ModType) == Button.Data.ModIndex
            Menu.UpdateMenuPopulation(Data.Menu, Data.Index, Button)
        end
        
        if (not IsOwner) and (not exports['mercy-vehicles']:IsPoliceVehicle(Vehicle)) then
            VehicleMods = VehicleModule.GetVehicleMods(Vehicle)
            return
        end
        
        local VehicleMeta = { 
            ['Engine'] = math.floor(GetVehicleEngineHealth(Vehicle)), 
            ['Body'] = math.floor(GetVehicleBodyHealth(Vehicle)), 
            ['Fuel'] = exports['mercy-vehicles']:GetVehicleMeta(Vehicle, 'Fuel'),
            ['Nitrous'] = exports['mercy-vehicles']:GetVehicleMeta(Vehicle, 'Nitrous'),
            ['Harness'] = exports['mercy-vehicles']:GetVehicleMeta(Vehicle, 'Harness'),
        }
        local SaveMods = VehicleModule.SaveVehicle(Vehicle, Plate, VehicleMeta, exports['mercy-vehicles']:IsPoliceVehicle(Vehicle) and 'Police' or 'None')
        VehicleMods = VehicleModule.GetVehicleMods(Vehicle)

        if not SaveMods then
            CloseBennys()
            exports['mercy-ui']:Notify("bennys-error", "Failed to save upgrades! (Costs: "..Button.Data.Costs..")", "error", 7000)
        end
    end

    Cb('Ok')
end)

exports('GetIsInBennysZone', GetIsInBennysZone)