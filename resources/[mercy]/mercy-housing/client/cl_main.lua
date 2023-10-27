PlayerModule, EventsModule, FunctionsModule, CallbackModule = nil, nil, nil, nil
ClosestHouse, InsideHouse, InsideHouseData, ShowingInteraction, DoingAction = nil, false, nil, false, false
HouseObject, OffSets = nil, nil
LoadedDecorations = {}

AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
        'Player',
		'Events',
        'Functions',
        'Callback',
        'Entity'
    }, function(Succeeded)

        if not Succeeded then return end
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        EntityModule = exports['mercy-base']:FetchModule('Entity')

        Config.Houses = GetHouseConfig()
    end)
end)

RegisterNetEvent('mercy-base/client/on-login', function()
    Citizen.SetTimeout(1500, function()
        Config.Houses = GetHouseConfig()
    end)
end)

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn and ClosestHouse ~= nil then
            if not InsideHouse then
                local NearHouseDoor = false
                local HouseData = Config.Houses[ClosestHouse]
                if HouseData ~= nil and (not HouseData.Locked or IsKeyholderClosestHouse()) and HouseData.Active then
                    -- Front door
                    local PlayerCoords = GetEntityCoords(PlayerPedId())
                    local HouseFrontCoords = vector3(HouseData.Coords.Enter.X, HouseData.Coords.Enter.Y, HouseData.Coords.Enter.Z)
                    local FrontDistance = #(PlayerCoords - HouseFrontCoords)
                    if FrontDistance < 1.5 then
                        NearHouseDoor = true
                        if not ShowingInteraction then
                            exports['mercy-ui']:SetInteraction("[E] Enter House")
                            ShowingInteraction = true
                        end

                        if IsControlJustReleased(0, 38) and not DoingAction then
                            DoingAction = true
                            EnterHouse(false)
                        end
                    end

                    -- Back door
                    if HouseData.Coords.Back ~= nil and HouseData.Coords.Back.X ~= 0 and HouseData.Coords.Back.Y ~= 0 and HouseData.Coords.Back.Z ~= 0 then
                        local HouseBackCoords = vector3(HouseData.Coords.Back.X, HouseData.Coords.Back.Y, HouseData.Coords.Back.Z)
                        local BackDistance = #(PlayerCoords - HouseBackCoords)
                        if BackDistance < 1.5 then
                            NearHouseDoor = true
                            if not ShowingInteraction then
                                exports['mercy-ui']:SetInteraction("[E] Enter House")
                                ShowingInteraction = true
                            end
    
                            if IsControlJustReleased(0, 38) and not DoingAction then
                                DoingAction = true
                                EnterHouse(true)
                            end
                        end
                    end
                end
                if not NearHouseDoor then
                    if ShowingInteraction then
                        exports['mercy-ui']:HideInteraction()
                        ShowingInteraction = false
                    end
                    Citizen.Wait(450)
                end
            else
                local NearHouseThings = false
                local HouseData = Config.Houses[ClosestHouse]
                if HouseData ~= nil and OffSets ~= nil then
                    local PlayerCoords = GetEntityCoords(PlayerPedId())
                    -- Exit
                    local ExitCoords = vector3(HouseData.Coords.Enter.X + OffSets.Exit.x, HouseData.Coords.Enter.Y + OffSets.Exit.y, (HouseData.Coords.Enter.Z - Config.HouseZOffSet) + OffSets.Exit.z)
                    local Distance = #(PlayerCoords - ExitCoords)
                    if Distance < 1.5 then
                        NearHouseThings = true
                        if not ShowingInteraction then
                            exports['mercy-ui']:SetInteraction("[E] Leave House")
                            ShowingInteraction = true
                        end

                        if IsControlJustReleased(0, 38) and not DoingAction then
                            DoingAction = true
                            LeaveHouse(false)
                        end
                    end
                end
                if not NearHouseThings then
                    if ShowingInteraction then
                        exports['mercy-ui']:HideInteraction()
                        ShowingInteraction = false
                    end
                    Citizen.Wait(450)
                end
            end
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn and Config.Houses ~= nil and next(Config.Houses) ~= nil then
            if not InsideHouse then
                SetClosestHouse()
            end
            Citizen.Wait(750)
        else
            Citizen.Wait(450)
        end
    end
end)

-- [ Events ] --

RegisterNetEvent('mercy-housing/client/set-house-location', function(Data)
    if InsideHouse == false and Data.Location ~= 'Backdoor' then return exports['mercy-ui']:Notify("housing-error", "You have to be in that house to change this location..", "error") end
    if InsideHouse and Data.HouseId ~= InsideHouseData.Name then return exports['mercy-ui']:Notify("housing-error", "You have to be in that house to change this location..", "error") end
    TriggerServerEvent('mercy-housing/server/set-house-location', Data, InsideHouse)
end)

RegisterNetEvent('mercy-housing/client/try-add-new-house', function()
    local InputChoices = {}
    for k, v in pairs(Config.HouseInteriors) do
        table.insert(InputChoices, {
            Icon = false,
            Text = v.Name,
            OnClickEvent = '',
            EventType = '',
        })
    end

    local Data = {
        {Name = 'Price', Label = 'Price', Icon = 'fas fa-dollar-sign'},
        {Name = 'Interior', Label = 'Interior', Icon = 'fas fa-house-user', Choices = InputChoices},
    }

    local HouseInput = exports['mercy-ui']:CreateInput(Data)
    if HouseInput['Price'] and HouseInput['Interior'] then
        local Coords = GetEntityCoords(PlayerPedId())
        local StreetLabel = FunctionsModule.GetStreetName(nil, 'Single')
        EventsModule.TriggerServer('mercy-housing/server/add-house', {
            Enter = {['X'] = Coords.x, ['Y'] = Coords.y, ['Z'] = Coords.z},
            Back = {['X'] = 0, ['Y'] = 0, ['Z'] = 0}  
        }, HouseInput['Interior'], tonumber(HouseInput['Price']), StreetLabel)
    end
end)

RegisterNetEvent('mercy-housing/client/sync-house-data', function(Name, HouseData, RefreshInterior)
    Config.Houses[Name] = HouseData
    if InsideHouseData ~= nil and InsideHouseData.Name == Name then
        InsideHouseData = HouseData

        if RefreshInterior then
            UnloadDecoration()
            Citizen.Wait(500)
            LoadDecoration(HouseData.Decorations)
        end
    end
end)

RegisterNetEvent('mercy-housing/client/lock-closest-house', function()
    if ClosestHouse == nil or Config.Houses[ClosestHouse] == nil then return end
    CallbackModule.SendCallback('mercy-phone/server/housing/toggle-locks', { HouseId = Config.Houses[ClosestHouse].Name })
end)

RegisterNetEvent('mercy-housing/client/lock-house-id', function(Name)
    if Name == nil or Config.Houses[Name] == nil then return end
    CallbackModule.SendCallback('mercy-phone/server/housing/toggle-locks', { HouseId = Name })
end)

RegisterNetEvent('mercy-housing/client/enter-house', function(Id)
    if ClosestHouse == Id then
        EnterHouse(false)
    end
end)

-- [ Functions ] --

function GetHouseConfig()
    local Config = CallbackModule.SendCallback('mercy-housing/server/get-houses')
    return Config
end

function EnterHouse(IsBackdoor)
    InsideHouse = true
    DoScreenFadeOut(250)
    TriggerEvent('mercy-assets/client/play-door-animation')
    TriggerEvent('mercy-ui/client/play-sound', 'door-open', 0.75)

    while not IsScreenFadedOut() do Citizen.Wait(1) end

    InsideHouseData = Config.Houses[ClosestHouse]
    if InsideHouseData ~= nil then
        local HouseCoords = vector3(InsideHouseData.Coords.Enter.X, InsideHouseData.Coords.Enter.Y, InsideHouseData.Coords.Enter.Z - Config.HouseZOffSet)
        local Interior = exports['mercy-interiors']:CreateInterior(InsideHouseData.Interior, HouseCoords, false)
        HouseObject, OffSets = Interior[1], Interior[2]
        LoadDecoration(InsideHouseData.Decorations)

        if IsBackdoor and InsideHouseData.Locations['Backdoor'] then
            SetEntityCoords(PlayerPedId(), InsideHouseData.Locations['Backdoor'].Coords.x, InsideHouseData.Locations['Backdoor'].Coords.y, InsideHouseData.Locations['Backdoor'].Coords.z)
        else
            SetEntityCoords(PlayerPedId(), InsideHouseData.Coords.Enter.X + OffSets.Exit.x, InsideHouseData.Coords.Enter.Y + OffSets.Exit.y, (InsideHouseData.Coords.Enter.Z - Config.HouseZOffSet) + OffSets.Exit.z)
            exports['mercy-ui']:SetInteraction("[E] Leave House")
        end

        DoScreenFadeIn(250)
        TriggerEvent('mercy-ui/client/play-sound', 'door-close', 0.45)
        DoingAction = false
    end

    Citizen.CreateThread(function()
        while InsideHouse do
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local NearAnything = false
            local NearStash = false
            local Wait = 500

            if InsideHouseData.Locations['Stash'] and #(PlayerCoords - vector3(InsideHouseData.Locations['Stash'].Coords.x, InsideHouseData.Locations['Stash'].Coords.y, InsideHouseData.Locations['Stash'].Coords.z)) <= 5.0 then
                NearAnything = true
                Wait = 1

                if InsideHouseData.Locations['Stash'] and #(PlayerCoords - vector3(InsideHouseData.Locations['Stash'].Coords.x, InsideHouseData.Locations['Stash'].Coords.y, InsideHouseData.Locations['Stash'].Coords.z)) <= 1.0 then
                    DrawText3D(vector3(InsideHouseData.Locations['Stash'].Coords.x, InsideHouseData.Locations['Stash'].Coords.y, InsideHouseData.Locations['Stash'].Coords.z), '[~g~E~s~] Storage')
                    if IsControlJustReleased(0, 38) then
                        if exports['mercy-inventory']:CanOpenInventory() then
                            TriggerEvent('mercy-ui/client/play-sound', 'stash-open', 0.75)
                            EventsModule.TriggerServer('mercy-inventory/server/open-other-inventory', 'House-'..InsideHouseData.Name, 'Stash', Config.InventoryData[InsideHouseData.Interior].Slots, Config.InventoryData[InsideHouseData.Interior].Weight)
                        end
                    end
                else
                    DrawText3D(vector3(InsideHouseData.Locations['Stash'].Coords.x, InsideHouseData.Locations['Stash'].Coords.y, InsideHouseData.Locations['Stash'].Coords.z), 'Storage')
                end
            end

            if InsideHouseData.Locations['Wardrobe'] and #(PlayerCoords - vector3(InsideHouseData.Locations['Wardrobe'].Coords.x, InsideHouseData.Locations['Wardrobe'].Coords.y, InsideHouseData.Locations['Wardrobe'].Coords.z)) <= 5.0 then
                NearAnything = true
                Wait = 1

                if InsideHouseData.Locations['Wardrobe'] and #(PlayerCoords - vector3(InsideHouseData.Locations['Wardrobe'].Coords.x, InsideHouseData.Locations['Wardrobe'].Coords.y, InsideHouseData.Locations['Wardrobe'].Coords.z)) <= 1.0 then
                    DrawText3D(vector3(InsideHouseData.Locations['Wardrobe'].Coords.x, InsideHouseData.Locations['Wardrobe'].Coords.y, InsideHouseData.Locations['Wardrobe'].Coords.z), '[~g~E~s~] Wardrobe / [~g~G~s~] Swap Char')
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent('mercy-clothing/client/open-wardrobe', true)
                    end

                    if IsControlJustReleased(0, 47) then
                        local Interior = exports['mercy-interiors']:DespawnInterior(HouseObject)
                        UnloadDecoration()
                        InsideHouseData = nil
                        InsideHouse = false
                        HouseObject = nil
                        OffSets = nil
                        exports['mercy-ui']:HideInteraction()
                        EventsModule.TriggerServer("mercy-ui/server/characters/send-to-character-screen")
                    end
                else
                    DrawText3D(vector3(InsideHouseData.Locations['Wardrobe'].Coords.x, InsideHouseData.Locations['Wardrobe'].Coords.y, InsideHouseData.Locations['Wardrobe'].Coords.z), 'Wardrobe')
                end
            end

            if InsideHouseData.Locations['Backdoor'] and #(PlayerCoords - vector3(InsideHouseData.Locations['Backdoor'].Coords.x, InsideHouseData.Locations['Backdoor'].Coords.y, InsideHouseData.Locations['Backdoor'].Coords.z)) <= 5.0 then
                NearAnything = true
                Wait = 1

                if InsideHouseData.Locations['Backdoor'] and #(PlayerCoords - vector3(InsideHouseData.Locations['Backdoor'].Coords.x, InsideHouseData.Locations['Backdoor'].Coords.y, InsideHouseData.Locations['Backdoor'].Coords.z)) <= 1.0 then
                    DrawText3D(vector3(InsideHouseData.Locations['Backdoor'].Coords.x, InsideHouseData.Locations['Backdoor'].Coords.y, InsideHouseData.Locations['Backdoor'].Coords.z), '[~g~E~s~] Leave House')
                    if IsControlJustReleased(0, 38) then
                        if InsideHouseData.Coords.Back ~= nil and InsideHouseData.Coords.Back.X ~= 0 and InsideHouseData.Coords.Back.Y ~= 0 and InsideHouseData.Coords.Back.Z ~= 0 then
                            DoingAction = true
                            LeaveHouse(true)
                        else
                            exports['mercy-ui']:Notify("housing-error", "Back door not set on outside!", "error")
                        end
                    end

                else
                    DrawText3D(vector3(InsideHouseData.Locations['Backdoor'].Coords.x, InsideHouseData.Locations['Backdoor'].Coords.y, InsideHouseData.Locations['Backdoor'].Coords.z), 'Leave House')
                end
            end

            Citizen.Wait(Wait)
        end
    end)
end

function LeaveHouse(IsBackdoor)
    DoScreenFadeOut(250)
    TriggerEvent('mercy-assets/client/play-door-animation')
    TriggerEvent('mercy-ui/client/play-sound', 'door-open', 0.75)
    while not IsScreenFadedOut() do Citizen.Wait(1) end

    local HouseData = Config.Houses[ClosestHouse]
    if HouseData ~= nil then
        UnloadDecoration()
        local Interior = exports['mercy-interiors']:DespawnInterior(HouseObject)
        InsideHouseData = nil
        InsideHouse = false
        HouseObject = nil
        OffSets = nil

        if IsBackdoor then
            SetEntityCoords(PlayerPedId(), HouseData.Coords.Back.X, HouseData.Coords.Back.Y, HouseData.Coords.Back.Z)
        else
            SetEntityCoords(PlayerPedId(), HouseData.Coords.Enter.X, HouseData.Coords.Enter.Y, HouseData.Coords.Enter.Z)
        end

        if not HouseData.Locked then
            exports['mercy-ui']:SetInteraction("[E] Enter House")
        else
            exports['mercy-ui']:HideInteraction()
        end

        DoScreenFadeIn(250)
        TriggerEvent('mercy-ui/client/play-sound', 'door-close', 0.45)
        DoingAction = false
    end
end

function SetClosestHouse()
    local OtherDistance, Current = nil, nil
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    for k, v in pairs(Config.Houses) do
        local HouseData = v
        if HouseData ~= nil and HouseData.Coords ~= nil and HouseData.Coords.Enter ~= nil then
            if Current ~= nil then
                local Distance = #(PlayerCoords - vector3(HouseData.Coords.Enter.X, HouseData.Coords.Enter.Y, HouseData.Coords.Enter.Z))
                if Distance < OtherDistance then
                    Current, OtherDistance = k, Distance
                elseif HouseData.Coords.Back ~= nil and HouseData.Coords.Back.X ~= 0 and HouseData.Coords.Back.Y ~= 0 and HouseData.Coords.Back.Z ~= 0 then
                    Distance = #(PlayerCoords - vector3(HouseData.Coords.Enter.X, HouseData.Coords.Enter.Y, HouseData.Coords.Enter.Z))
                    if Distance < OtherDistance then
                        Current, OtherDistance = k, Distance
                    end
                end
            else
                local Distance = #(PlayerCoords - vector3(HouseData.Coords.Enter.X, HouseData.Coords.Enter.Y, HouseData.Coords.Enter.Z))
                Current, OtherDistance = k, Distance
            end
        end
    end
    local HouseData = Config.Houses[Current]
    if HouseData ~= nil and HouseData.Coords.Enter ~= nil then
        local Distance = #(PlayerCoords - vector3(HouseData.Coords.Enter.X, HouseData.Coords.Enter.Y, HouseData.Coords.Enter.Z))
        if Distance >= 15.0 and HouseData.Coords.Back.X ~= 0 and HouseData.Coords.Back.Y ~= 0 and HouseData.Coords.Back.Z ~= 0 then
            Distance = #(PlayerCoords - vector3(HouseData.Coords.Back.X, HouseData.Coords.Back.Y, HouseData.Coords.Back.Z))
        end
        if Distance < 15.0 then 
            ClosestHouse = Current
        else
            ClosestHouse = nil
        end
    end
end

function DrawText3D(Coords, Text)
    local OnScreen, _X, _Y = World3dToScreen2d(Coords.x, Coords.y, Coords.z)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(Text)
    DrawText(_X, _Y)
    local Factor = (string.len(Text)) / 370
    DrawRect(_X, _Y + 0.0125, 0.015 + Factor, 0.03, 41, 11, 41, 68)
end

exports("GetHouseConfig", GetHouseConfig)

exports("GetClosestHouse", function()
    return ClosestHouse ~= nil and Config.Houses[ClosestHouse] or nil
end)

exports("GetHouseById", function(Id)
    return Config.Houses[Id]
end)

exports("GetCategoryFromTier", function(Tier)
    return Config.TierCategories[Tier]
end)

function IsKeyholderClosestHouse()
    if ClosestHouse == nil or Config.Houses[ClosestHouse] == nil then return end
    local HouseData = Config.Houses[ClosestHouse]
    
    local CitizenId = PlayerModule.GetPlayerData().CitizenId
    if CitizenId == HouseData.Owner then return true end
    for k, v in pairs(HouseData.Keyholders) do
        if v == CitizenId then
            return true
        end
    end

    return false
end

exports("IsKeyholderClosestHouse", IsKeyholderClosestHouse)

function IsKeyholderHouseId(HouseId)
    if HouseId == nil or Config.Houses[HouseId] == nil then return end
    local HouseData = Config.Houses[HouseId]
    
    local CitizenId = PlayerModule.GetPlayerData().CitizenId
    if CitizenId == HouseData.Owner then return true end
    for k, v in pairs(HouseData.Keyholders) do
        if v == CitizenId then
            return true
        end
    end

    return false
end
exports("IsKeyholderHouseId", IsKeyholderHouseId)

exports("IsNearHouse", function()
    if ClosestHouse == nil then return end
    local HouseData = Config.Houses[ClosestHouse]
    local PlayerCoords = GetEntityCoords(PlayerPedId())

    local Distance = #(PlayerCoords - vector3(HouseData.Coords.Enter.X, HouseData.Coords.Enter.Y, HouseData.Coords.Enter.Z))

    if Distance >= 1.0 and HouseData.Coords.Back.X ~= 0 and HouseData.Coords.Back.Y ~= 0 and HouseData.Coords.Back.Z ~= 0 then
        Distance = #(PlayerCoords - vector3(HouseData.Coords.Back.X, HouseData.Coords.Back.Y, HouseData.Coords.Back.Z))
    end

    if Distance < 1.0 then 
        return true
    end

    return false
end)