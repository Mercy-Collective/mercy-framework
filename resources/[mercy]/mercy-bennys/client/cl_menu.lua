Menu = {}
Menu.Menus = {}

function BuildMenu(Vehicle)
    local BodyHealth = GetVehicleBodyHealth(Vehicle)
    SetVehicleModKit(Vehicle, 0)

    Menu.SetHeader("Welcome to Benny's Original Motorworks", "banner")
    if BodyHealth < 1000.0 then
        local Costs = math.ceil(1000 - BodyHealth)
        
        Menu.SetSubHeader("Repair Vehicle")
        Menu.RemoveMenu('Repair')
        Menu.CreateMenu('Repair', nil)
        Menu.Populate('Repair', {
            Label = "Repair",
            Id = "RepairVehicle",
            Costs = "$" .. Costs,
            Data = {
                Costs = Costs
            }
        })

        Menu.SetMenuVisiblity('Repair', true)
    else
        VehicleModule.RepairVehicle(Vehicle)
        Menu.SetSubHeader("Choose a Category")

        if CurrentBennyZone and CurrentBennyZone.extra.IsWheelfitment then
            BuildFitmentMenu(Vehicle)
            return
        end

        for k, v in pairs(Config.ParentMenus) do
            Menu.RemoveMenu(v.Menu)
            Menu.CreateMenu(v.Menu, v.Parent)
        end

        for i = 1, #Config.Menus, 1 do
            local Data = Config.Menus[i]

            -- local VehicleRecord = CallbackModule.SendCallback("mercy-police/server/getVehicleRecord", GetVehicleNumberPlateText(Vehicle))
            -- local IsVinScratched = VehicleRecord ~= nil and VehicleRecord[0] ~= nil and VehicleRecord[0].vinscratched == 1
            -- If vehicle is Emergency class and menu item disabled for emergency, skip.
            if exports['mercy-vehicles']:IsGovVehicle(Vehicle) and Data.Disabled.Emergency then goto Skip end
            -- if IsVinScratched and Data.Disabled.Vin then goto Skip end

            if Data.ModType and GetNumVehicleMods(Vehicle, Data.ModType) > 0 or (not Data.ModType) or Data.ModType == 'Extra' then
                Menu.Populate(Data.Parent or 'MainMenu', {
                    Label = Data.Label,
                    Id = Data.Id,
                    TargetMenu = Data.TargetMenu or Data.Id,
                    Data = {}
                })
            end
            
            if Data.SubMenu and #Data.SubMenu > 0 then
                for k, v in pairs(Data.SubMenu) do
                    Menu.Populate(v.Parent, {
                        Id = v.Id,
                        Label = v.Label,
                        TargetMenu = v.TargetMenu,
                        Installed = v.Data ~= nil and IsModInstalled(Vehicle, v.Data) or nil,
                        Costs = GetModPrice(v.Id, k) ~= nil and '$' .. GetModPrice(v.Id, k) or nil,
                        Data = v.Data or {},
                    })
                end
            elseif Data.ModType then
                if Data.ModType == 'Extra' then
                    Menu.RemoveMenu(Data.Id)
                    Menu.CreateMenu(Data.Id, 'MainMenu')

                    local ExtraLabels = CheckVehicleExtras(GetEntityModel(Vehicle))
   
                    for i = 1, 12 do
                        if DoesExtraExist(Vehicle, i) then
                            Menu.Populate(Data.Id, {
                                Id = Data.Id .. 'Extra' .. i,
                                Label = (ExtraLabels and ExtraLabels[i] or "Extra " .. tostring(i)),
                                Costs = IsVehicleExtraTurnedOn(Vehicle, i) and "ON" or "OFF",
                                Data = {
                                    Costs = 0,
                                    ModType = 'Extra',
                                    ModIndex = i,
                                }
                            })
                        else
                            Menu.Populate(Data.Id, {
                                Id = Data.Id .. 'Extra' .. i,
                                Label = "No Option",
                                Data = { Costs = 0 }
                            })
                        end
                    end
                else
                    if GetNumVehicleMods(Vehicle, Data.ModType) > 0 then
                        Menu.RemoveMenu(Data.Id)
                        Menu.CreateMenu(Data.Id, 'MainMenu')
    
                        Menu.Populate(Data.Id, {
                            Id = Data.Id,
                            Label = 'Stock ' .. Data.Label,
                            Costs = "$0",
                            Installed = GetVehicleMod(Vehicle, Data.ModType) == -1,
                            Data = {
                                Costs = 0,
                                ModType = Data.ModType,
                                ModIndex = -1,
                            }
                        })
                        
                        for i = 0, (GetNumVehicleMods(Vehicle, Data.ModType) - 1) do
                            local ModLabel = GetLabelText(GetModTextLabel(Vehicle, Data.ModType, i))
    
                            if ModLabel == "NULL" then
                                ModLabel = Data.Label .. " " .. (i + 1)
                            end
                            
                            Menu.Populate(Data.Id, {
                                Id = Data.Id,
                                Label = ModLabel,
                                Costs = "$" .. GetModPrice(Data.Id, (i + 1)),
                                Installed = GetVehicleMod(Vehicle, Data.ModType) == i,
                                Data = {
                                    Costs = GetModPrice(Data.Id, (i + 1)),
                                    ModType = Data.ModType,
                                    ModIndex = i,
                                }
                            })
                        end
                    end
                end
            end

            ::Skip::
        end

        Menu.EmptyMenu('WheelsMenu')
        for k, v in pairs(Config.WheelTypes) do
            if GetVehicleClass(Vehicle) == 8 or IsMotorcycle(Vehicle) then
                if v.Data.ModIndex == 6 then -- Motorcycles
                    Menu.RemoveMenu(v.Id)
                    Menu.CreateMenu(v.Id, 'WheelsMenu')

                    Menu.Populate('WheelsMenu', {
                        Id = v.Id,
                        Label = v.Label,
                        TargetMenu = v.Id,
                        Disabled = { Emergency = false, Vin = false },
                        Data = v.Data,
                    })

                    for _, Sub in pairs(v.SubMenu) do
                        Menu.Populate(v.Id, {
                            Id = Sub.Id,
                            Label = Sub.Label,
                            Installed = v.Data ~= nil and IsModInstalled(Vehicle, Sub.Data) or nil,
                            Costs = Sub.Costs,
                            Data = Sub.Data or {},
                        })
                    end
                end
            elseif v.Data.ModIndex == 4 and (GetVehicleClass(Vehicle) == 9 or GetVehicleClass(Vehicle) == 2) then -- SUV & Off-road
                Menu.RemoveMenu(v.Id)
                Menu.CreateMenu(v.Id, 'WheelsMenu')

                Menu.Populate('WheelsMenu', {
                        Id = v.Id,
                        Label = v.Label,
                        TargetMenu = v.Id,
                        Disabled = { Emergency = false, Vin = false },
                        Data = v.Data,
                    })

                for _, Sub in pairs(v.SubMenu) do
                    Menu.Populate(v.Id, {
                        Id = Sub.Id,
                        Label = Sub.Label,
                        Installed = v.Data ~= nil and IsModInstalled(Vehicle, Sub.Data) or nil,
                        Costs = Sub.Costs,
                        Data = Sub.Data or {},
                    })
                end
            elseif v.Data.ModIndex ~= 4 then
                Menu.RemoveMenu(v.Id)
                Menu.CreateMenu(v.Id, 'WheelsMenu')

                Menu.Populate('WheelsMenu', {
                        Id = v.Id,
                        Label = v.Label,
                        TargetMenu = v.Id,
                        Disabled = { Emergency = false, Vin = false },
                        Data = v.Data,
                    })

                for _, Sub in pairs(v.SubMenu) do
                    Menu.Populate(v.Id, {
                        Id = Sub.Id,
                        Label = Sub.Label,
                        Installed = v.Data ~= nil and IsModInstalled(Vehicle, Sub.Data) or nil,
                        Costs = Sub.Costs,
                        Data = Sub.Data or {},
                    })
                end
            end
        end

        Menu.SetMenuVisiblity('MainMenu', true)
    end

    SendNUIMessage({
        Action = 'SetVisibility',
        Bool = true,
    })
    exports['mercy-ui']:HideInteraction()
end


function BuildFitmentMenu(Vehicle)
    -- for k, v in pairs(Config.ParentMenus) do
    --     Menu.RemoveMenu(v.Menu)
    -- end

    Menu.SetHeader("6STR. Tuner Shop", "banner-6str")

    Menu.SetSubHeader("Adjust Wheel Fitment")
    Menu.RemoveMenu('WheelFitment')
    Menu.CreateMenu('WheelFitment', nil)
    Menu.Populate('WheelFitment', {
        Label = "Wheels Width",
        Id = "WheelWidth",
        Costs = "< " .. Round(GetVehicleWheelWidth(Vehicle), 2) .. " >",
    })

    local WheelToLocale = {
        [0] = "Front Left",
        "Front Right",
        "Rear Left",
        "Rear Right"
    }

    for i = 0, 3, 1 do
        Menu.Populate('WheelFitment', {
            Label = "Wheel " .. WheelToLocale[i],
            Id = "WheelOffset" .. i,
            Costs = "< " .. Round(GetVehicleWheelXOffset(Vehicle, i), 2) .. " >",
        })
    end

    -- Fucked.
    -- for i = 0, 3, 1 do
    --     Menu.Populate('WheelFitment', {
    --         Label = "Wheel Rotation " .. WheelToLocale[i],
    --         Id = "WheelOffset" .. i,
    --         Costs = "< " .. Round(GetVehicleWheelYRotation(Vehicle, i), 2) .. " >",
    --     })
    -- end

    Menu.SetMenuVisiblity('WheelFitment', true)

    SendNUIMessage({
        Action = 'SetVisibility',
        Bool = true,
    })

    exports['mercy-ui']:HideInteraction()

    Citizen.CreateThread(function()
        while InBennys do
            if IsControlJustReleased(0, 175) then
                if CurrentWheelfitmentIndex == 1 then -- Adjust Width
                    local WheelWidth = GetVehicleWheelWidth(Vehicle)
                    if Config.WheelFitment.Width[2] >= Round(WheelWidth + 0.01, 2) then
                        SetVehicleWheelWidth(Vehicle, WheelWidth + 0.01)
                        Menu.UpdateMenuSecondText("WheelFitment", CurrentWheelfitmentIndex, "< ".. Round(WheelWidth + 0.01, 2) .. " >")
                    end
                elseif CurrentWheelfitmentIndex == 2 then -- Adjust FL Offset
                    local WheelOffset = GetVehicleWheelXOffset(Vehicle, 0)
                    if Config.WheelFitment.OffsetLeft[2] <= Round(WheelOffset + -0.01, 2) then
                        SetVehicleWheelXOffset(Vehicle, 0, WheelOffset + -0.01)
                        Menu.UpdateMenuSecondText("WheelFitment", CurrentWheelfitmentIndex, "< ".. Round(WheelOffset + -0.01, 2) .. " >")
                    end
                elseif CurrentWheelfitmentIndex == 3 then -- Adjust FR Offset
                    local WheelOffset = GetVehicleWheelXOffset(Vehicle, 1)
                    if Config.WheelFitment.OffsetRight[2] >= Round(WheelOffset + 0.01, 2) then
                        SetVehicleWheelXOffset(Vehicle, 1, WheelOffset + 0.01)
                        Menu.UpdateMenuSecondText("WheelFitment", CurrentWheelfitmentIndex, "< ".. Round(WheelOffset + 0.01, 2) .. " >")
                    end
                elseif CurrentWheelfitmentIndex == 4 then -- Adjust RL Offset
                    local WheelOffset = GetVehicleWheelXOffset(Vehicle, 2)
                    if Config.WheelFitment.OffsetLeft[2] <= Round(WheelOffset + -0.01, 2) then
                        SetVehicleWheelXOffset(Vehicle, 2, WheelOffset + -0.01)
                        Menu.UpdateMenuSecondText("WheelFitment", CurrentWheelfitmentIndex, "< ".. Round(WheelOffset + -0.01, 2) .. " >")
                    end
                elseif CurrentWheelfitmentIndex == 5 then -- Adjust RR Offset
                    local WheelOffset = GetVehicleWheelXOffset(Vehicle, 3)
                    if Config.WheelFitment.OffsetRight[2] >= Round(WheelOffset + 0.01, 2) then
                        SetVehicleWheelXOffset(Vehicle, 3, WheelOffset + 0.01)
                        Menu.UpdateMenuSecondText("WheelFitment", CurrentWheelfitmentIndex, "< ".. Round(WheelOffset + 0.01, 2) .. " >")
                    end
                elseif CurrentWheelfitmentIndex == 6 then -- Adjust FL Rotation
                    local WheelRotation = GetVehicleWheelYRotation(Vehicle, 0)
                    if Config.WheelFitment.RotationLeft[2] <= Round(WheelRotation + -0.01, 2) then
                        SetVehicleWheelYRotation(Vehicle, 0, WheelRotation + -0.01)
                        Menu.UpdateMenuSecondText("WheelFitment", CurrentWheelfitmentIndex, "< ".. Round(WheelRotation + -0.01, 2) .. " >")
                    end
                elseif CurrentWheelfitmentIndex == 7 then -- Adjust FR Rotation
                    local WheelRotation = GetVehicleWheelYRotation(Vehicle, 1)
                    if Config.WheelFitment.RotationRight[2] >= Round(WheelRotation + 0.01, 2) then
                        SetVehicleWheelYRotation(Vehicle, 1, WheelRotation + 0.01)
                        Menu.UpdateMenuSecondText("WheelFitment", CurrentWheelfitmentIndex, "< ".. Round(WheelRotation + 0.01, 2) .. " >")
                    end
                elseif CurrentWheelfitmentIndex == 8 then -- Adjust RL Rotation
                    local WheelRotation = GetVehicleWheelYRotation(Vehicle, 2)
                    if Config.WheelFitment.RotationLeft[2] <= Round(WheelRotation + -0.01, 2) then
                        SetVehicleWheelYRotation(Vehicle, 2, WheelRotation + -0.01)
                        Menu.UpdateMenuSecondText("WheelFitment", CurrentWheelfitmentIndex, "< ".. Round(WheelRotation + -0.01, 2) .. " >")
                    end
                elseif CurrentWheelfitmentIndex == 9 then -- Adjust RR Rotation
                    local WheelRotation = GetVehicleWheelYRotation(Vehicle, 3)
                    if Config.WheelFitment.RotationRight[2] >= Round(WheelRotation + 0.01, 2) then
                        SetVehicleWheelYRotation(Vehicle, 3, WheelRotation + 0.01)
                        Menu.UpdateMenuSecondText("WheelFitment", CurrentWheelfitmentIndex, "< ".. Round(WheelRotation + 0.01, 2) .. " >")
                    end
                end
            end

            if IsControlJustReleased(0, 174) then
                if CurrentWheelfitmentIndex == 1 then -- Adjust Width
                    local WheelWidth = GetVehicleWheelWidth(Vehicle)
                    if Config.WheelFitment.Width[1] <= WheelWidth - 0.01 then
                        SetVehicleWheelWidth(Vehicle, WheelWidth - 0.01)
                        Menu.UpdateMenuSecondText("WheelFitment", CurrentWheelfitmentIndex, "< ".. Round(WheelWidth - 0.01, 2) .. " >")
                    end
                elseif CurrentWheelfitmentIndex == 2 then -- Adjust FL Offset
                    local WheelOffset = GetVehicleWheelXOffset(Vehicle, 0)
                    if Config.WheelFitment.OffsetLeft[1] > Round(WheelOffset + -0.01, 2) then
                        SetVehicleWheelXOffset(Vehicle, 0, WheelOffset - -0.01)
                        Menu.UpdateMenuSecondText("WheelFitment", CurrentWheelfitmentIndex, "< ".. Round(WheelOffset - -0.01, 2) .. " >")
                    end
                elseif CurrentWheelfitmentIndex == 3 then -- Adjust FR Offset
                    local WheelOffset = GetVehicleWheelXOffset(Vehicle, 1)
                    if Config.WheelFitment.OffsetRight[1] < Round(WheelOffset - 0.01, 2) then
                        SetVehicleWheelXOffset(Vehicle, 1, WheelOffset - 0.01)
                        Menu.UpdateMenuSecondText("WheelFitment", CurrentWheelfitmentIndex, "< ".. Round(WheelOffset - 0.01, 2) .. " >")
                    end
                elseif CurrentWheelfitmentIndex == 4 then -- Adjust RL Offset
                    local WheelOffset = GetVehicleWheelXOffset(Vehicle, 2)
                    if Config.WheelFitment.OffsetLeft[1] > Round(WheelOffset + -0.01, 2) then
                        SetVehicleWheelXOffset(Vehicle, 2, WheelOffset - -0.01)
                        Menu.UpdateMenuSecondText("WheelFitment", CurrentWheelfitmentIndex, "< ".. Round(WheelOffset - -0.01, 2) .. " >")
                    end
                elseif CurrentWheelfitmentIndex == 5 then -- Adjust RR Offset
                    local WheelOffset = GetVehicleWheelXOffset(Vehicle, 3)
                    if Config.WheelFitment.OffsetRight[1] < Round(WheelOffset - 0.01, 2) then
                        SetVehicleWheelXOffset(Vehicle, 3, WheelOffset - 0.01)
                        Menu.UpdateMenuSecondText("WheelFitment", CurrentWheelfitmentIndex, "< ".. Round(WheelOffset - 0.01, 2) .. " >")
                    end
                elseif CurrentWheelfitmentIndex == 6 then -- Adjust FL Rotation
                    local WheelRotation = GetVehicleWheelYRotation(Vehicle, 0)
                    if Config.WheelFitment.RotationLeft[1] >= Round(WheelRotation - -0.01, 2) then
                        SetVehicleWheelYRotation(Vehicle, 0, WheelRotation - -0.01)
                        Menu.UpdateMenuSecondText("WheelFitment", CurrentWheelfitmentIndex, "< ".. Round(WheelRotation - -0.01, 2) .. " >")
                    end
                elseif CurrentWheelfitmentIndex == 7 then -- Adjust FR Rotation
                    local WheelRotation = GetVehicleWheelYRotation(Vehicle, 1)
                    if Config.WheelFitment.RotationRight[1] <= Round(WheelRotation - 0.01, 2) then
                        SetVehicleWheelYRotation(Vehicle, 1, WheelRotation - 0.01)
                        Menu.UpdateMenuSecondText("WheelFitment", CurrentWheelfitmentIndex, "< ".. Round(WheelRotation - 0.01, 2) .. " >")
                    end
                elseif CurrentWheelfitmentIndex == 8 then -- Adjust RL Rotation
                    local WheelRotation = GetVehicleWheelYRotation(Vehicle, 2)
                    if Config.WheelFitment.RotationLeft[1] >= Round(WheelRotation - -0.01, 2) then
                        SetVehicleWheelYRotation(Vehicle, 2, WheelRotation - -0.01)
                        Menu.UpdateMenuSecondText("WheelFitment", CurrentWheelfitmentIndex, "< ".. Round(WheelRotation - -0.01, 2) .. " >")
                    end
                elseif CurrentWheelfitmentIndex == 9 then -- Adjust RR Rotation
                    local WheelRotation = GetVehicleWheelYRotation(Vehicle, 3)
                    if Config.WheelFitment.RotationRight[1] <= Round(WheelRotation - 0.01, 2) then
                        SetVehicleWheelYRotation(Vehicle, 3, WheelRotation - 0.01)
                        Menu.UpdateMenuSecondText("WheelFitment", CurrentWheelfitmentIndex, "< ".. Round(WheelRotation - 0.01, 2) .. " >")
                    end
                end
            end
            Citizen.Wait(4)
        end

        exports['mercy-vehicles']:SetVehicleMeta(Vehicle, "WheelFitment", {
            Width = GetVehicleWheelWidth(Vehicle),
            FLOffset = GetVehicleWheelXOffset(Vehicle, 0),
            FROffset = GetVehicleWheelXOffset(Vehicle, 1),
            RLOffset = GetVehicleWheelXOffset(Vehicle, 2),
            RROffset = GetVehicleWheelXOffset(Vehicle, 3),
            -- FLRotation = GetVehicleWheelYRotation(Vehicle, 0),
            -- FRRotation = GetVehicleWheelYRotation(Vehicle, 1),
            -- RLRotation = GetVehicleWheelYRotation(Vehicle, 2),
            -- RRRotation = GetVehicleWheelYRotation(Vehicle, 3),
        })

        CurrentWheelfitmentIndex = 0
    end)
end

function Menu.CreateMenu(Name, Parent)
    Menu.Menus[Name] = {
        Name = Name,
        Parent = Parent,
        Items = {},
    }

    SendNUIMessage({
        Action = 'AddMenu',
        Name = Name,
        Parent = Parent,
        Show = Show,
    })
end

function Menu.SetMenuVisiblity(Name, Show)
    SendNUIMessage({
        Action = 'SetMenuVisiblity',
        Name = Name,
        Show = Show,
    })
end

function Menu.Populate(Name, Item)
    table.insert(Menu.Menus[Name].Items, Item)

    SendNUIMessage({
        Action = 'PopulateMenu',
        Name = Name,
        Item = Item
    })
end

function Menu.RemoveMenu(Name)
    Menu.Menus[Name] = nil

    SendNUIMessage({
        Action = 'RemoveMenu',
        Name = Name
    })
end

function Menu.EmptyMenu(Name)
    Menu.Menus[Name].Items = {}

    SendNUIMessage({
        Action = 'EmptyMenu',
        Name = Name
    })
end

function Menu.SetHeader(Text, Banner)
    SendNUIMessage({
        Action = 'SetHeader',
        Text = Text,
        Banner = Banner
    })
end

function Menu.SetSubHeader(Text)
    SendNUIMessage({
        Action = 'SetSubHeader',
        Text = Text
    })
end

function Menu.UpdateMenuPopulation(Name, Index, Item)
    Name = tostring(Name)
    Menu.Menus[Name].Items[Index] = Item
    SendNUIMessage({
        Action = 'UpdateMenuPopulation',
        Name = Name,
        Index = Index,
        Item = Item,
    })
end

function Menu.UpdateMenuSecondText(Name, Index, Text)
    Name = tostring(Name)
    Menu.Menus[Name].Items[Index].Costs = Text
    SendNUIMessage({
        Action = 'UpdateMenuSecondText',
        Name = Name,
        Index = Index,
        Text = Text,
    })
end

function Menu.GetMenu(Name)
    return Menu.Menus[Name]
end

function IsModInstalled(Vehicle, Data)
    if Data.ModType == 'PlateIndex' then
        return GetVehicleNumberPlateTextIndex(Vehicle) == Data.ModIndex
    elseif Data.ModType == 'Windows' then
        return GetVehicleWindowTint(Vehicle) == Data.ModIndex
    elseif Data.ModType == 'NeonSide' then
        return IsVehicleNeonLightEnabled(Vehicle, Data.ModIndex)
    elseif Data.ModType == 'NeonColor' then
        local r, g, b = GetVehicleNeonLightsColour(Vehicle)
        local _oRGB = {R = r, G = g, B = b}
        return json.encode(_oRGB) == json.encode(Data.ModIndex) 
    elseif Data.ModType == 'Headlights' then
        if Data.ModIndex == 1 and IsToggleModOn(Vehicle, 22) then
            return true
        else
            return false
        end
    elseif Data.ModType == 'Wheels' and Data.WheelType == GetVehicleWheelType(Vehicle) then
        -- Stock wheels are returned with -1, just like GetVehicleMod when the mod is empty
        local _bModInstalled = false
        if GetVehicleMod(Vehicle, 23) ~= -1 and GetVehicleMod(Vehicle, 23) == Data.ModIndex then _bModInstalled = true end
        if GetVehicleMod(Vehicle, 24) ~= -1 and GetVehicleMod(Vehicle, 24) == Data.ModIndex then _bModInstalled = true end
        return _bModInstalled
    elseif Data.ModType == 'Spoiler' then
        return GetVehicleMod(Vehicle, 0) == Data.ModIndex
    elseif Data.ModType == 'PrimaryColor' then
        return GetVehicleCustomPrimaryColour(Vehicle) == Data.ModType
    elseif Data.ModType == 'XenonColor' then
        return GetVehicleHeadlightsColour(Vehicle) == Data.ModIndex
    elseif Data.ModType == 18 then
        if Data.ModIndex == 1 and IsToggleModOn(Vehicle, 18) then
            return true
        else
            return false
        end
    elseif Data.ModType == 22 then
        if Data.ModIndex == 1 and IsToggleModOn(Vehicle, 22) then
            return true
        else
            return false
        end
    elseif Data.ModType == 14 then
        return GetVehicleMod(Vehicle, 14) == Data.ModIndex
    else
        return nil
    end
end

function CheckVehicleExtras(Model)
    return Config.ExtraPresets[Model] or false
end

function IsMotorcycle(Model)
    return Config.SpecialMotorcycles[GetEntityModel(Model)] or false
end

RegisterNUICallback("OpenTargetMenu", function(Data, Cb)
    local Vehicle = GetVehiclePedIsIn(PlayerPedId())

    Citizen.SetTimeout(250, function()
        VehicleModule.ApplyVehicleMods(Vehicle, VehicleMods, GetVehicleNumberPlateText(Vehicle), true)
    end)

    if Data.TargetMenu == 'ResprayTypeMenu' and CurrentRespray ~= 'Primary' and CurrentRespray ~= 'Secondary' then
        Data.TargetMenu = 'ResprayMenu'
    end

    if Data.CurrentMenu == 'WheelsMenu' then
        local WheelIndex = 0
        if Data.TargetMenu == 'WheelsMuscle'then WheelIndex = 1
        elseif Data.TargetMenu == 'WheelsLowrider'then WheelIndex = 2
        elseif Data.TargetMenu == 'WheelsSUV'then WheelIndex = 3
        elseif Data.TargetMenu == 'WheelsOffroad'then WheelIndex = 4
        elseif Data.TargetMenu == 'WheelsTuner'then WheelIndex = 5
        elseif Data.TargetMenu == 'WheelsMotorcycle'then WheelIndex = 6
        elseif Data.TargetMenu == 'WheelsHighend'then WheelIndex = 7 end

        SetVehicleWheelType(Vehicle, WheelIndex)
    end

    if Menu.GetMenu(Data.TargetMenu) ~= nil then
        Menu.SetMenuVisiblity(Data.CurrentMenu, false)
        Menu.SetMenuVisiblity(Data.TargetMenu, true)
    else
       LoggerModule.Error("Bennys/OpenTargetMenu", ("Can't open target menu '%s'. (Current: %s)"):format(Data.TargetMenu, Data.CurrentMenu))
    end
    Cb('Ok')
end)