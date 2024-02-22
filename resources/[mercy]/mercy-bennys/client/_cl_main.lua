PlayerModule, CallbackModule, FunctionsModule, VehicleModule, BlipManager, EventsModule = nil
VehicleMods, CurrentBennyZone, CurrentRespray = {}, nil, nil
local _Ready, AlreadyDoing, IsInBennysZone = false, false, false
IsEmployedAtMechanic, InVehicle, InBennys, IsAdmin, CurrentWheelfitmentIndex = false, false, false, false, 0

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

-- Set Wheelfitment when entering vehicle
-- RegisterNetEvent("mercy-threads/entered-vehicle", function(Vehicle)
--     InVehicle = true
--     local Vehicle = GetVehiclePedIsUsing(PlayerPedId())

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
--                 Citizen.Wait(50)
--             else
--                 Citizen.Wait(250)
--             end

--             Citizen.Wait(4)
--         end
--     end)
-- end)

-- RegisterNetEvent("mercy-threads/exited-vehicle", function()
--     InVehicle = false
-- end)

RegisterNetEvent('mercy-polyzone/client/enter-polyzone', function(PolyData, Coords)
    if PolyData.name == 'bennys' then
        CurrentBennyZone = PolyData
        IsInBennysZone = true

        if CurrentBennyZone.extra.Secret then return end
        
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
        local IsMechanicOnline = CallbackModule.SendCallback("mercy-bennys/server/is-mechanic-online")
        
        local PlayerData = PlayerModule.GetPlayerData()
        local IsGov = Admin or IsBennysGov(CurrentBennyZone.extra.Authorized) and ((PlayerData.Job.Name == "police" or PlayerData.Job.Name == "ems") and PlayerData.Job.Duty)
        IsEmployedAtMechanic = IsGov or exports['mercy-business']:IsPlayerInBusiness('Bennys Motorworks') or exports['mercy-business']:IsPlayerInBusiness('Hayes Repairs') or exports['mercy-business']:IsPlayerInBusiness('Harmony Repairs')
        if IsMechanicOnline and not IsEmployedAtMechanic and not IsAdmin then
            return exports['mercy-ui']:Notify("bennys-repair", "Speak to one of the vehicle repair companies for help.", "error")
        end

        PlaySoundFrontend(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
        VehicleMods = VehicleModule.GetVehicleMods(Vehicle)
    
        if not IsAdmin then SetEntityHeading(Vehicle, CurrentBennyZone.extra ~= nil and CurrentBennyZone.extra.Heading or CurrentBennyZone.offsetRot) end
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
    local Multiplier = 1.0
    if IsEmployedAtMechanic then Multiplier = 0.7 end

    local Price = nil
    if ModIndex ~= nil and type(Config.Prices[Name]) == 'table' then
        Price = Config.Prices[Name][ModIndex] ~= nil and Config.Prices[Name][ModIndex] or Config.Prices[Name][#Config.Prices[Name]]
    elseif Config.Prices[Name] then
        Price = Config.Prices[Name]
    end

    return (Price ~= nil and math.floor(Price * Multiplier) or nil)
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

function IsBennysGov(Authorized)
    if not Authorized then return false end

    if Authorized.Job then
        for k, Job in pairs(Authorized.Job) do
            if Job == "police" or Job == "ems" then
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
        if MenuItem.Data.WheelType ~= nil then
            Citizen.SetTimeout(20, function() -- If this isn't here, its not updated???
                if GetVehicleWheelType(Vehicle) ~= MenuItem.Data.WheelType then
                    SetVehicleWheelType(Vehicle, MenuItem.Data.WheelType)
                end
                SetVehicleMod(Vehicle, 23, ModIndex, false)
                SetVehicleMod(Vehicle, 24, ModIndex, false)
            end)
        end
    elseif ModType == 'XenonColor' then
        SetVehicleXenonLightsColor(Vehicle, ModIndex)
    elseif ModType == 'Spoiler' then
        ToggleVehicleMod(Vehicle, 0, ModIndex == 1)
    else
        Citizen.SetTimeout(10, function()
            SetVehicleMod(Vehicle, ModType, ModIndex)
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
            VehicleModule.RepairVehicle(Vehicle)
        end

        SetVehicleHandbrake(Vehicle, false)

        if not IsAdmin then
            EventsModule.TriggerServer('mercy-base/server/remove-money', tonumber(Button.Data.Costs))
            TriggerEvent('mercy-ui/client/play-sound', 'bennys-wrench', 0.4)
            
            Menu.RemoveMenu("Repair")
            if InBennys then BuildMenu(Vehicle) end
        end
    else
        if Button.Id == "Wheels" and (VehicleMods['Wheels'] == Button.Data.WheelType and VehicleMods['ModFrontWheels'] == Button.Data.ModIndex) then
            return exports['mercy-ui']:Notify("bennys-error", "Mod is already installed..", "error")
        elseif Button.Id ~= "Wheels" and VehicleMods[Button.Id] == Button.Data.ModIndex then
            return exports['mercy-ui']:Notify("bennys-error", "Mod is already installed..", "error")
        elseif Button.Id ~= "Wheels" and VehicleMods[Button.Data.ModType] == Button.Data.ModIndex then
            return exports['mercy-ui']:Notify("bennys-error", "Mod is already installed..", "error")
        end

        -- if VehicleMods['Neon'] ~= nil and Button.Data.ModType == 'NeonSide' and  VehicleMods['Neon'][Button.Data.ModIndex+1] == 1 then
        -- return exports['mercy-ui']:Notify("bennys-error", "Mod is already installed..", "error")
        -- end
        
        -- if VehicleMods['NeonColor'] ~= nil then
        --     local oldR, oldG, oldB = table.unpack(VehicleMods['NeonColor'])
        --     local oldRGB = {R= oldR, G= oldG, B = oldB}
        -- end

        -- if oldRGB ~= nil and Button.Data.ModType == 'NeonColor' and json.encode(oldRGB) == json.encode(Button.Data.ModIndex) then
                -- return exports['mercy-ui']:Notify("bennys-error", "Mod is already installed..", "error")
        -- end

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

        local Costs = tonumber(Button.Data.Costs)
        if not Costs then
            Costs = 0
        end

        if type(Button.Data.Costs) == 'number' and Costs > 0 and not IsAdmin then
            if Costs > tonumber(Cash) then
                return exports['mercy-ui']:Notify("bennys-error", "Not enough cash..", "error") 
            end

            EventsModule.TriggerServer('mercy-base/server/remove-money', Costs) 
        end

        if Data.Menu == 'ResprayMetallic' or Data.Menu == 'ResprayMetal' or Data.Menu == 'ResprayMatte' then
            TriggerEvent('mercy-ui/client/play-sound', 'bennys-respray', 1.0)
        else
            TriggerEvent('mercy-ui/client/play-sound', 'bennys-wrench', 0.4)
        end
        if Button.Data.ModType == 'Extra' then
            if VehicleMods['ModExtras'][Button.Data.ModIndex] == 0 then
                SetVehicleExtra(Vehicle, Button.Data.ModIndex, true)
            else
                SetVehicleExtra(Vehicle, Button.Data.ModIndex, false)
            end

            Menu.UpdateMenuSecondText(Data.Menu, Data.Index, IsVehicleExtraTurnedOn(Vehicle, Button.Data.ModIndex) and "ON" or "OFF")
        elseif Button.Data.ModType == 'Wheels' and Button.Data.WheelType == GetVehicleWheelType(Vehicle) then
            -- Bugs out with other wheel types
            -- Stock wheels are returned with -1, just like GetVehicleMod when the mod is empty
            local _bModInstalled = false
            if GetVehicleMod(Vehicle, 23) ~= -1 and GetVehicleMod(Vehicle, 23) == Button.Data.ModIndex then _bModInstalled = true end
            if GetVehicleMod(Vehicle, 24) ~= -1 and GetVehicleMod(Vehicle, 24) == Button.Data.ModIndex then _bModInstalled = true end
            Button.Installed = _bModInstalled
            Menu.UpdateMenuPopulation(Data.Menu, Data.Index, Button)
        elseif Button.Data.ModType == 'PlateIndex' then
            Button.Installed = GetVehicleNumberPlateTextIndex(Vehicle) == Button.Data.ModIndex
            Menu.UpdateMenuPopulation(Data.Menu, Data.Index, Button)
        elseif Button.Data.ModType == 18 then
            ToggleVehicleMod(Vehicle, 18, not IsToggleModOn(Vehicle, 18))
            Button.Installed = IsToggleModOn(Vehicle, 18)
            Menu.UpdateMenuPopulation(Data.Menu, Data.Index, Button)
        elseif Button.Data.ModType == 22 then
            Button.Installed = IsToggleModOn(Vehicle, 22)
            Menu.UpdateMenuPopulation(Data.Menu, Data.Index, Button)
        elseif Button.Data.ModType == 'XenonColor' then
            Button.Installed = GetVehicleHeadlightsColour(Vehicle) == Button.Data.ModIndex
            Menu.UpdateMenuPopulation(Data.Menu, Data.Index, Button)
        elseif Button.Data.ModType == 'NeonColor' then
            local r, g, b = GetVehicleNeonLightsColour(Vehicle)
            local _oRGB = {R = r, G = g, B = b}
            Button.Installed = json.encode(_oRGB) == json.encode(Button.Data.ModIndex) 
            Menu.UpdateMenuPopulation(Data.Menu, Data.Index, Button)
        elseif Button.Data.ModType == 0 then -- Spoilers
            Button.Installed = GetVehicleMod(Vehicle, 0) == Button.Data.ModIndex
            Menu.UpdateMenuPopulation(Data.Menu, Data.Index, Button)
        -- elseif Button.Data.ModType == 'NeonSide' and IsVehicleNeonLightEnabled(Vehicle, Data.ModIndex) then
        --     Button.Installed = true
        --     Menu.UpdateMenuPopulation(Data.Menu, Data.Index, Button)
        else
            Button.Installed = GetVehicleMod(Vehicle, Button.Data.ModType) == Button.Data.ModIndex
            Menu.UpdateMenuPopulation(Data.Menu, Data.Index, Button)
        end

        VehicleMods = VehicleModule.GetVehicleMods(Vehicle)

        local IsOwner = CallbackModule.SendCallback('mercy-vehicles/server/is-veh-owner', Plate)
        local IsEmployedAtMechanic = exports['mercy-business']:IsPlayerInBusiness('Bennys Motorworks') or exports['mercy-business']:IsPlayerInBusiness('Hayes Repairs')
        if not IsOwner and not IsEmployedAtMechanic then
            return
        end
        
        local VehicleMeta = { 
            ['Engine'] = math.floor(GetVehicleEngineHealth(Vehicle)), 
            ['Body'] = math.floor(GetVehicleBodyHealth(Vehicle)), 
            ['Fuel'] = exports['mercy-vehicles']:GetVehicleMeta(Vehicle, 'Fuel'),
            ['Nitrous'] = exports['mercy-vehicles']:GetVehicleMeta(Vehicle, 'Nitrous'),
            ['Harness'] = exports['mercy-vehicles']:GetVehicleMeta(Vehicle, 'Harness'),
        }
        local ModsSaved = VehicleModule.SaveVehicle(Vehicle, Plate, VehicleMeta, exports['mercy-vehicles']:IsGovVehicle(Vehicle) and 'Police' or 'None')
        if not ModsSaved then
            -- CloseBennys()
            exports['mercy-ui']:Notify("bennys-error", "Failed to save upgrades! (Costs: "..Button.Data.Costs..")", "error", 7000)
        end

        ::Cancel::
    end

    Cb('Ok')
end)

exports('GetIsInBennysZone', GetIsInBennysZone)

exports('IsInSecretBennys', function()
    return IsInBennysZone and CurrentBennyZone.extra.Secret
end)

-- Chameleon Names
Citizen.CreateThread(function()
    AddTextEntryByHash(0x03235520, "Vice City")
    AddTextEntryByHash(0x03B1050B, "Red/Rainbow Flip")
    AddTextEntryByHash(0x0451F232, "Magenta/Orange Flip")
    AddTextEntryByHash(0x06019DB0, "Kamen Rider")
    AddTextEntryByHash(0x0709E6CB, "Blue/Pink Flip")
    AddTextEntryByHash(0x0B5C8B4A, "Turquoise/Purple Flip")
    AddTextEntryByHash(0x0FAFB10C, "Chromatic Aberration")
    AddTextEntryByHash(0x0FD93295, "Anodized Lime Pearl")
    AddTextEntryByHash(0x1C0545B9, "Oil Spill Prismatic Pearl")
    AddTextEntryByHash(0x1C9FCAEC, "It's Christmas!")
    AddTextEntryByHash(0x2A6D23B3, "Maisonette 9 Throwback")
    AddTextEntryByHash(0x2BC823E4, "Green/Turquoise Flip")
    AddTextEntryByHash(0x2C7D6CAC, "White Prismatic Pearl")
    AddTextEntryByHash(0x2E6A54F8, "Magenta/Green Flip")
    AddTextEntryByHash(0x2E6BABA4, "Night & Day")
    AddTextEntryByHash(0x2E626E71, "Temperature")
    AddTextEntryByHash(0x2EB58817, "Black Holographic Pearl")
    AddTextEntryByHash(0x3BC1133D, "Fubuki-jo Specials: Temperature")
    AddTextEntryByHash(0x3C1EC716, "Bubblegum")
    AddTextEntryByHash(0x4BDAE075, "Fubuki-jo Specials: Kamen Rider")
    AddTextEntryByHash(0x4D2314AA, "Copper/Purple Flip")
    AddTextEntryByHash(0x5DFFC4A0, "Oil Slick Pearl")
    AddTextEntryByHash(0x6DA87068, "Blue Prismatic Pearl")
    AddTextEntryByHash(0x6E6A15C1, "Fubuki-jo Specials: Synthwave Night")
    AddTextEntryByHash(0x7BD85AD1, "Baby Blue Pearl")
    AddTextEntryByHash(0x7DC7AE1E, "Anodized Copper Pearl")
    AddTextEntryByHash(0x7F2307EC, "Fubuki-jo Specials: HSW Badge")
    AddTextEntryByHash(0x7F4189DD, "Green Prismatic Pearl")
    AddTextEntryByHash(0x8BDE41CD, "Orange/Purple Flip")
    AddTextEntryByHash(0x8F33A80A, "Green/Blue Flip")
    AddTextEntryByHash(0x9B263D99, "Green/Brown Flip")
    AddTextEntryByHash(0x13BA6BF3, "Anodized Red Pearl")
    AddTextEntryByHash(0x17E87317, "Blue/Green Flip")
    AddTextEntryByHash(0x23D77E08, "Light Purple Pearl")
    AddTextEntryByHash(0x32C535AD, "Anodized Gold Pearl")
    AddTextEntryByHash(0x32F288BF, "Purple/Green Flip")
    AddTextEntryByHash(0x56B75588, "Burgundy/Green Flip")
    AddTextEntryByHash(0x61ED2843, "Blue/Rainbow Flip")
    AddTextEntryByHash(0x70CE5288, "Dark Green Pearl")
    AddTextEntryByHash(0x72A83420, "Monochrome")
    AddTextEntryByHash(0x79F3A406, "White Holographic Pearl")
    AddTextEntryByHash(0x96E24FFA, "Dark Blue Pearl")
    AddTextEntryByHash(0x118BC585, "Fubuki-jo Specials: Fubuki Castle")
    AddTextEntryByHash(0x127E9C05, "Black Prismatic Pearl")
    AddTextEntryByHash(0x401A4F01, "The Verlierer")
    AddTextEntryByHash(0x443CE6DF, "Orange/Blue Flip")
    AddTextEntryByHash(0x454C51AA, "Graphite Prismatic Pearl")
    AddTextEntryByHash(0x583D6C3C, "Dark Teal Pearl")
    AddTextEntryByHash(0x982FF214, "Cyan/Purple Flip")
    AddTextEntryByHash(0x989B28DF, "Fubuki-jo Specials: It's Christmas!")
    AddTextEntryByHash(0x2348F313, "Fubuki-jo Specials: Bubblegum")
    AddTextEntryByHash(0x3323E41D, "Dark Purple Pearl")
    AddTextEntryByHash(0x5368EB75, "Light Pink Pearl")
    AddTextEntryByHash(0x5437D164, "Fubuki-jo Specials: Anod. Lightning")
    AddTextEntryByHash(0x5984C4B9, "Sunset")
    AddTextEntryByHash(0x9711D5D1, "Turquoise/Red Flip")
    AddTextEntryByHash(0x45773C51, "Fubuki-jo Specials: Sunset")
    AddTextEntryByHash(0x57013C1B, "Purple Prismatic Pearl")
    AddTextEntryByHash(0x88547DDC, "Light Green Pearl")
    AddTextEntryByHash(0x99526FEF, "Fubuki-jo Specials: The Verlierer")
    AddTextEntryByHash(0x636925C1, "Fubuki-jo Specials: Sprunk Extreme")
    AddTextEntryByHash(0x3000802B, "Cute Pink Pearl")
    AddTextEntryByHash(0x4793312A, "Fubuki-jo Specials: Emeralds")
    AddTextEntryByHash(0x8346183B, "The Seven")
    AddTextEntryByHash(0x34379647, "Hot Pink Prismatic Pearl")
    AddTextEntryByHash(0x48712292, "Full Rainbow")
    AddTextEntryByHash(0x79018996, "Purple/Red Flip")
    AddTextEntryByHash(0xA00B1BBB, "White/Purple Flip")
    AddTextEntryByHash(0xA0C2DC6E, "Light Blue Pearl")
    AddTextEntryByHash(0xA4CC12D6, "Rainbow Prismatic Pearl")
    AddTextEntryByHash(0xA833DE6E, "Red Prismatic Pearl")
    AddTextEntryByHash(0xAAD5FFDD, "Fubuki-jo Specials: M9 Throwback")
    AddTextEntryByHash(0xAB87144D, "Magenta/Yellow Flip")
    AddTextEntryByHash(0xAC3FB952, "Fubuki-jo Specials: The Seven")
    AddTextEntryByHash(0xB0C55438, "Anodized Champagne Pearl")
    AddTextEntryByHash(0xB65F5BB6, "Green/Red Flip")
    AddTextEntryByHash(0xB113B2B5, "Fubuki-jo Specials: Four Seasons")
    AddTextEntryByHash(0xBD891512, "Fubuki-jo Specials: Full Rainbow")
    AddTextEntryByHash(0xBE32CB2C, "Synthwave Nights")
    AddTextEntryByHash(0xC2F63B4B, "Green/Purple Flip")
    AddTextEntryByHash(0xC4777F6C, "Fubuki-jo Specials: Vice City")
    AddTextEntryByHash(0xCA6A29F5, "Anodized Green Pearl")
    AddTextEntryByHash(0xCE39A022, "Off White Pearl")
    AddTextEntryByHash(0xD07D6FC1, "Four Seasons")
    AddTextEntryByHash(0xD0B213A3, "Fubuki-jo Specials: Chromatic")
    AddTextEntryByHash(0xD32AC8FE, "Teal/Purple Flip")
    AddTextEntryByHash(0xD435A690, "Baby Green Pearl")
    AddTextEntryByHash(0xD486B901, "Fubuki-jo Specials: Monochrome")
    AddTextEntryByHash(0xE63626A2, "Baby Yellow Pearl")
    AddTextEntryByHash(0xE683878C, "Anodized Purple Pearl")
    AddTextEntryByHash(0xF0E7181A, "Magenta/Cyan Flip")
    AddTextEntryByHash(0xF175B1C5, "Sprunk Extreme")
    AddTextEntryByHash(0xF2668D56, "Anodized Bronze Pearl")
    AddTextEntryByHash(0xF1225475, "Anodized Wine Pearl")
    AddTextEntryByHash(0xFC532CC6, "Fubuki-jo Specials: Night & Day")
    AddTextEntryByHash(0xFE4F92F5, "Anodized Blue Pearl")
    AddTextEntryByHash(0xFF952547, "Cream Pearl")
    AddTextEntryByHash(0xFFBA4291, "Red/Orange Flip")
end)