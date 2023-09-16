local IsPeeking, IsPeekingZone, IsPeekingEntity, IsPeekingModel, IsPeekingTransport, RefreshTransportPeek = false, nil, nil, nil, false, false
PeekingEntity = nil

Eye = {}
Eye.Colours = {
    Sprite = {
        ['false'] = {
            r = 255,
            g = 255,
            b = 255,
        },
        ['true'] = {
            r = 0,
            g = 248,
            b = 185,
        },
    }
}

Eye.PedEntries = {}
Eye.Entries = Config.EyeEntries

-- [ Threads] --

Citizen.CreateThread(function()
    while true do
        if LocalPlayer.state.LoggedIn then
            local Pos = GetEntityCoords(PlayerPedId())
            for k, v in pairs(Eye.PedEntries) do
                if v.Entity == nil and #(Pos - vector3(v.Position.x, v.Position.y, v.Position.z)) < 30.0 then
                    FunctionsModule.RequestModel(v.Model)
                    v.Entity = CreatePed(-1, GetHashKey(v.Model), v.Position.x, v.Position.y, v.Position.z, v.Position.w, false, true)
    
                    Citizen.SetTimeout(250, function()
                        FreezeEntityPosition(v.Entity, true)
                        SetEntityInvincible(v.Entity, true)
                        SetPedDefaultComponentVariation(v.Entity)
                        SetBlockingOfNonTemporaryEvents(v.Entity, true)
                    end)
    
                    if v.Anim and next(v.Anim) ~= nil then
                        FunctionsModule.RequestAnimDict(v.Anim.Dict)
                        TaskPlayAnim(v.Entity, v.Anim.Dict, v.Anim.Name, 2.0, 2.0, -1, 1, 0, false, false, false)
                    end
    
                    if v.Scenario then
                        TaskStartScenarioInPlace(v.Entity, v.Scenario, 0, true)
                    end
                    
                    if v.Props and next(v.Props) ~= nil then
                        for _, Prop in pairs(v.Props) do
                            local off1, off2, off3, rot1, rot2, rot3 = table.unpack(Prop.Placement)
                            local x, y, z = table.unpack(GetEntityCoords(v.Entity))
                    
                            FunctionsModule.RequestModel(Prop.Prop)
                            Prop.Entity = CreateObject(GetHashKey(Prop.Prop), x, y, z + 0.2,  false,  true, true)
                            AttachEntityToEntity(Prop.Entity, v.Entity, GetPedBoneIndex(v.Entity, Prop.Bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
                        end
                    end
                elseif v.Entity and #(Pos - vector3(v.Position.x, v.Position.y, v.Position.z)) > 30.0 then
                    if v.Props and next(v.Props) ~= nil then
                        for _, Prop in pairs(v.Props) do
                            DeleteObject(Prop.Entity)
                        end
                    end
    
                    DeletePed(v.Entity)
                    v.Entity = nil
                end
            end
        end
        Citizen.Wait(500)
    end
end)

-- [ Functions ] --

function RayCastGamePlayCamera(Distance)
    local CameraRotation = GetGameplayCamRot()
    local CameraCoord = GetGameplayCamCoord()
    local Direction = RotationToDirection(CameraRotation)
    local Destination = {x = CameraCoord.x + Direction.x * Distance, y = CameraCoord.y + Direction.y * Distance, z = CameraCoord.z + Direction.z * Distance}
    local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(CameraCoord.x, CameraCoord.y, CameraCoord.z, Destination.x, Destination.y, Destination.z, -1, PlayerPedId(), 0))
    return b, c, e
end

AddInitialize(function()    
    -- Create all zones
    for k, v in pairs(Eye.PedEntries) do
        if v.Props then
            for _, Prop in pairs(v.Props) do
                DeleteObject(Prop.Entity)
            end

        end

        if v.Entity then
            DeletePed(v.Entity)
            v.Entity = nil
        end
    end
    
    Eye.PedEntries = {}
    for k, v in pairs(Eye.Entries) do
        if v.Type:lower() == 'zone' then
            v.ZoneData.Zone = BoxZone:Create(false, {
                name = k,
                center = v.ZoneData.Center,
                length = v.ZoneData.Length,
                width = v.ZoneData.Width,
            }, v.ZoneData.Data)
        elseif v.Type:lower() == 'entity' and v.EntityType ~= nil and v.EntityType:lower() == 'ped' then
            Eye.PedEntries[k] = v
        end
    end

    -- Create keybinds
    KeybindsModule.Add("eyePeek", 'Player', 'Peek', 'LMENU', function(IsPressed)
        if IsPressed then
            local PlayerData = PlayerModule.GetPlayerData()
            if PlayerData.MetaData == nil or PlayerData.MetaData['Handcuffed'] or PlayerData.MetaData['Dead'] then return end
            if IsPedInAnyVehicle(PlayerPedId()) then return end
            if IsNuiFocused() or not LocalPlayer.state.LoggedIn then return end
            IsPeeking = true

            SendUIMessage('Eye', 'ToggleEye', {
                State = true,
            })

            local Entries = GetNearestEntries()

            Citizen.CreateThread(function()
                while IsPeeking do
                    Citizen.Wait(1000)
                    Entries = GetNearestEntries()
                    RefreshTransportPeek = true
                end
            end)

            Citizen.CreateThread(function()
                while IsPeeking do
                    Citizen.Wait(4)
                    DisableControlAction(0, 24, true)
                    DisableControlAction(0, 25, true)
                    DisablePlayerFiring(PlayerId(), true)
                    SetPlayerLockon(PlayerId(), false)
                end
            end)

            Citizen.CreateThread(function()
                RequestStreamedTextureDict("shared")

                while IsPeeking do
                    local CameraCoord = GetGameplayCamCoord()
                    local Hit, Pos, Entity = RayCastGamePlayCamera(5.0)
                    
                    for k, v in pairs(Entries) do
                        if v.Type:lower() == 'zone' then -- Check if raycasting into zone
                            local IsInZone = false
                            local Coords = GetCoordinatesInBetweenLine()
                            for _, Coord in pairs(Coords) do
                                if v.ZoneData.Zone:isPointInside(vector3(Coord.x, Coord.y, Coord.z)) then
                                    if v.Distance == nil or #(GetEntityCoords(PlayerPedId()) - v.ZoneData.Center) <= v.Distance then
                                        IsInZone = true
                                        if IsPeekingZone ~= k then
                                            IsPeekingZone = k
                                            if UpdateUIOptions(v.Parent, v.Options) then
                                                v.State = true
                                            end
                                        end
                                    end
                                end
                            end

                            if IsPeekingZone == k and not IsInZone then
                                IsPeekingZone = nil
                                v.State = false
                                UpdateUIOptions(false, {})
                            end
                        elseif v.Type:lower() == 'entity' then -- Check if raycasting onto a entity
                            if Hit and GetEntityType(Entity) ~= 0 then
                                if Entity == v.Entity and (v.Distance == nil or #(GetEntityCoords(PlayerPedId()) - vector3(Pos.x, Pos.y, Pos.z)) <= v.Distance) then
                                    if IsPeekingEntity ~= k then
                                        IsPeekingEntity = k
                                        PeekingEntity = Entity
                                        if UpdateUIOptions(v.Parent, v.Options) then
                                            v.State = true
                                        end
                                    end
                                elseif IsPeekingEntity == v.Entity then
                                    IsPeekingEntity = nil
                                    PeekingEntity = nil
                                    v.State = false
                                    UpdateUIOptions(false, {})
                                end
                            elseif IsPeekingEntity ~= nil then
                                IsPeekingEntity = nil
                                PeekingEntity = nil
                                v.State = false
                                UpdateUIOptions(false, {})
                            end
                        elseif v.Type:lower() == 'model' then -- Check if raycasting onto a entity (by model name)
                            if Hit and GetEntityType(Entity) ~= 0 then
                                if GetEntityModel(Entity) == GetHashKey(v.Model) then
                                    if IsPeekingModel ~= k then
                                        IsPeekingModel = k
                                        PeekingEntity = Entity
                                        UpdateUIOptions(v.Parent, v.Options)
                                    end
                                elseif IsPeekingModel == v.Model then
                                    IsPeekingModel = nil
                                    PeekingEntity = nil
                                    UpdateUIOptions(false, {})
                                end
                            elseif IsPeekingModel ~= nil then
                                IsPeekingModel = nil
                                PeekingEntity = nil
                                UpdateUIOptions(false, {})
                            end
                        end
                        
                        -- No peeking, maybe a car?
                        if IsPeekingEntity == nil and IsPeekingModel == nil and IsPeekingZone == nil then
                            if Hit and GetEntityType(Entity) ~= 0 and IsEntityAVehicle(Entity) then
                                if PeekingEntity ~= Entity or RefreshTransportPeek then
                                    RefreshTransportPeek = false
                                    IsPeekingTransport = true
                                    PeekingEntity = Entity
        
                                    local EntityType = "none"
                                    if GetVehicleClass(Entity) ~= 8 and GetVehicleClass(Entity) ~= 14 and GetVehicleClass(Entity) ~= 15 and GetVehicleClass(Entity) ~= 16 and GetVehicleClass(Entity) ~= 21 then
                                        EntityType = "vehicles"
                                    elseif GetVehicleClass(Entity) == 8 then
                                        EntityType = "motorcycle"
                                    elseif GetVehicleClass(Entity) == 14 then
                                        EntityType = "watercraft"
                                    elseif GetVehicleClass(Entity) == 15 or GetVehicleClass(Entity) == 16 then
                                        EntityType = "aircraft"
                                    elseif GetVehicleClass(Entity) == 21 then
                                        EntityType = "train"
                                    end
        
                                    if EntityType ~= "none" then
                                        UpdateUIOptions(EntityType, Eye.Entries[EntityType].Options)
                                    else
                                        IsPeekingTransport = false
                                        PeekingEntity = nil
                                        UpdateUIOptions(false, {})
                                    end
                                end
                            elseif Hit and GetEntityType(Entity) ~= 0 and GetEntityType(Entity) == 1 and IsPedAPlayer(Entity) then -- Ped
                                if PeekingEntity ~= Entity or RefreshTransportPeek then
                                    RefreshTransportPeek = false
                                    IsPeekingTransport = true
                                    PeekingEntity = Entity
                                    UpdateUIOptions("ped", Eye.Entries["ped"].Options)
                                end
                            else
                                if IsPeekingTransport then
                                    RefreshTransportPeek = false
                                    IsPeekingTransport = false
                                    PeekingEntity = nil
                                    UpdateUIOptions(false, {})
                                end
                            end
                        end

                        -- Draw Sprites
                        if v.Type:lower() ~= 'model' then
                            local OnScreen, ScreenX, ScreenY = false, nil, nil
                            if v.Type:lower() == 'zone' then
                                SetDrawOrigin(v.ZoneData.Center.x, v.ZoneData.Center.y, v.ZoneData.Data.minZ + ((v.ZoneData.Data.maxZ - v.ZoneData.Data.minZ) / 2), 0)
                                OnScreen, ScreenX, ScreenY = GetScreenCoordFromWorldCoord(v.ZoneData.Center.x, v.ZoneData.Center.y, v.ZoneData.Data.minZ + ((v.ZoneData.Data.maxZ - v.ZoneData.Data.minZ) / 2))
                            elseif v.Type:lower() == 'entity' then
                                local EntityCoords = GetEntityCoords(v.Entity)
                                SetDrawOrigin(EntityCoords.x, EntityCoords.y, EntityCoords.z, 0)
                                OnScreen, ScreenX, ScreenY = GetScreenCoordFromWorldCoord(EntityCoords.x, EntityCoords.y, EntityCoords.z)
                            end

                            if OnScreen then DrawSprite("shared", "emptydot_32", 0, 0, 0.02, 0.035, 0, Eye.Colours.Sprite[tostring(v.State)].r, Eye.Colours.Sprite[tostring(v.State)].g, Eye.Colours.Sprite[tostring(v.State)].b, 255) end
                            ClearDrawOrigin()
                        end
                    end

                    if IsControlJustReleased(0, 18) then
                        if IsPeekingEntity ~= nil or IsPeekingModel ~= nil or IsPeekingZone ~= nil or IsPeekingTransport ~= nil then
                            if not IsNuiFocused() then
                                SetNuiFocus(true, true)
                                SetCursorLocation(0.5, 0.5)
                            end
                        end
                    end

                    if IsNuiFocused() then
                        DisableControlAction(0, 30, true) -- disable left/right
                        DisableControlAction(0, 31, true) -- disable forward/back
                        DisableControlAction(0, 36, true) -- INPUT_DUCK
                        DisableControlAction(0, 21, true) -- disable sprint
                    end

                    DisableControlAction(0, 24, true)
                    DisableControlAction(0, 25, true)
                    DisablePlayerFiring(PlayerId(), true)

                    Citizen.Wait(1)
                end

                Citizen.SetTimeout(500, function()
                    if not IsPeeking then
                        SetPlayerLockon(PlayerId(), true)
                        DisablePlayerFiring(PlayerId(), false)
                    end
                end)
            end)
        else
            if IsNuiFocused() then return end

            IsPeeking = false
            IsPeekingZone = nil
            IsPeekingEntity = nil
            PeekingEntity = nil
            IsPeekingModel = nil
            IsPeekingTransport = nil

            SetNuiFocus(false, false)
            
            SendUIMessage('Eye', 'ToggleEye', {
                State = false,
            })

            for k, v in pairs(Eye.Entries) do
                if v.Type:lower() == 'zone' and v.State then v.State = false end
            end
        end
    end)
end)

function GetNearestEntries()
    local Entries = {}
    local Coords = GetEntityCoords(PlayerPedId())
    local Entity = exports['mercy-base']:FetchModule("Entity")

    for k, v in pairs(Eye.Entries) do
        if v.Type:lower() == 'zone' then
            if #(Coords - v.ZoneData.Center) <= v.SpriteDistance then
                if v.State == nil then v.State = false end
                v.Parent = k
                table.insert(Entries, v)
            end
        elseif v.Type:lower() == 'entity' then
            if #(Coords - GetEntityCoords(v.Entity)) <= v.SpriteDistance then
                if v.State == nil then v.State = false end
                v.Parent = k
                table.insert(Entries, v)
            end
        elseif v.Type:lower() == 'model' or v.Type:lower() == 'default' then
            if v.State == nil then v.State = false end
            v.Parent = k
            table.insert(Entries, v)
        else
            local Logger = exports['mercy-base']:FetchModule("Logger")
            Logger.Error("UI/Eye", ("A interactable was created with unsupported type '%s'!"):format(v.Type))
        end
    end

    return Entries
end

function GetCoordinatesInBetweenLine(StartCoords, EndCoords)
    local CameraRotation = GetGameplayCamRot()
    local CameraCoord = GetGameplayCamCoord()
    local Direction = RotationToDirection(CameraRotation)
    local Distances = { 0.35, 0.45, 0.55, 0.65, 0.75, 0.85, 0.95, 1.0, 1.15, 1.25, 1.35, 1.45, 1.55, 1.65, 1.75, 1.85, 1.95, 2.0, 2.15, 2.25, 2.35, 2.45, 2.55, 2.65, 2.75, 2.85, 2.95, 3.0 } -- Dont touch, it fucks for whatever reason under 3.0

    local Markers = {}
    for k, v in pairs(Distances) do
        table.insert(Markers, {x = CameraCoord.x + Direction.x * v, y = CameraCoord.y + Direction.y * v, z = CameraCoord.z + Direction.z * v})
    end
    -- for k, v in pairs(Markers) do
    --     DrawMarker(28, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.05, 0.05, 0.05, 255, 0, 0, 50, false, false, false, false, false, false, false)
    -- end
    return Markers
end

function UpdateUIOptions(Parent, Options)
    local EnabledOptions = {}

    -- print(debug.traceback())

    for k, v in pairs(Options) do
        if v.Enabled(PeekingEntity) then
            table.insert(EnabledOptions, {
                Name = v.Name,
                Label = v.Label,
                Icon = v.Icon,
                Parent = Parent,
            })
        end
    end

    SendUIMessage('Eye', 'SetOptions', {
        Options = EnabledOptions
    })

    return #EnabledOptions > 0
end

-- [ NUI Callbacks ] --

RegisterNUICallback('Eye/Close', function(Data, Cb)
    IsPeeking = false
    IsPeekingZone = nil
    IsPeekingEntity = nil
    PeekingEntity = nil
    IsPeekingModel = nil
    IsPeekingTransport = nil

    SetNuiFocus(false, false)
    
    SendUIMessage('Eye', 'ToggleEye', {
        State = false,
    })

    for k, v in pairs(Eye.Entries) do
        if v.Type:lower() == 'zone' and v.State then v.State = false end
    end

    Cb('Ok')
end)

RegisterNUICallback('Eye/Unfocus', function(Data, Cb)
    SetNuiFocus(false, false)
    Cb('Ok')
end)

RegisterNUICallback('Eye/Click', function(Data, Cb)
    IsPeeking = false
    IsPeekingZone = nil
    IsPeekingEntity = nil
    IsPeekingModel = nil
    IsPeekingTransport = nil

    SetNuiFocus(false, false)
    
    SendUIMessage('Eye', 'ToggleEye', {
        State = false,
    })

    for k, v in pairs(Eye.Entries) do
        if v.Type:lower() == 'zone' and v.State then v.State = false end
    end

    -- Making it a number so it can identify hashes too
    if Eye.Entries[tonumber(Data.Parent)] ~= nil then Data.Parent = tonumber(Data.Parent) end

    if Eye.Entries[Data.Parent] == nil then
        local Logger = exports['mercy-base']:FetchModule("Logger")
        Logger.Error("UI/Eye", ("A interactable was triggered, but the parent '%s' does not exist! (Path: %s/%s)"):format(Data.Parent, Data.Parent, Data.Name))
        return
    end

    Eye.Entries[Data.Parent].State = false

    for k, v in pairs(Eye.Entries[Data.Parent].Options) do
        if v.Name == Data.Name then
            if v.EventType:lower() == 'client' then
                TriggerEvent(v.EventName, v.EventParams, PeekingEntity or nil)
            else
                TriggerServerEvent(v.EventName, v.EventParams, PeekingEntity or nil)
            end
            break
        end
    end

    PeekingEntity = nil

    Cb('Ok')
end)

-- [ Exports ] --

exports("AddEyeEntry", function(Name, Data)
    local Logger = exports['mercy-base']:FetchModule("Logger")
    local Type = Data.Type:lower()

    if Eye.Entries[Name] ~= nil then 
        -- Logger.Warning("UI/Eye/AddEyeEntry", ("Eye entry '%s' already exists, replacing it with new one.."):format(Name))
    end

    if Type == 'zone' then
        if Eye.Entries[Name] and Eye.Entries[Name].ZoneData.Zone then Eye.Entries[Name].ZoneData.Zone:destroy() end
        Eye.Entries[Name] = Data

        if Eye.Entries[Name].ZoneData.Data.name == nil then Eye.Entries[Name].ZoneData.Data.name = Name end

        Eye.Entries[Name].ZoneData.Zone = BoxZone:Create(false, {
            center = Eye.Entries[Name].ZoneData.Center,
            length = Eye.Entries[Name].ZoneData.Length,
            width = Eye.Entries[Name].ZoneData.Width,
        }, Eye.Entries[Name].ZoneData.Data)
    elseif Type == 'model' then
        Eye.Entries[Name] = Data
    elseif Type == 'entity' then
        Eye.Entries[Name] = Data
        
        if Data.EntityType ~= nil and Data.EntityType:lower() == 'ped' then
            if Eye.PedEntries[Name] then
                if Eye.PedEntries[Name].Props then
                    for k, v in pairs(Eye.PedEntries[Name].Props) do
                        DeleteObject(v.Entity)
                    end
                end

                DeletePed(Eye.PedEntries[Name].Entity)
                Eye.PedEntries[Name].Entity = nil
            end

            Eye.PedEntries[Name] = Data
        end
    end
end)

exports("RemoveEyeEntry", function(Name, Type)
    local Type = Type:lower()

    if Eye.Entries[Name] == nil then 
        Logger.Warning("UI/Eye/RemoveEyeEntry", ("Eye entry '%s' does not exist.."):format(Name))
    end
    if Type == 'zone' then
        if Eye.Entries[Name].ZoneData.Zone then 
            Eye.Entries[Name].ZoneData.Zone:destroy() 
            Eye.Entries[Name] = nil
        end
    elseif Type == 'entity' or Type == 'model' then
        Eye.Entries[Name] = nil
    end
end)

-- Events
RegisterNetEvent('mercy-ui/client/ui-reset', function()
    if IsPeeking then
        IsPeeking = false
        IsPeekingZone = nil
        IsPeekingEntity = nil
        PeekingEntity = nil
        IsPeekingModel = nil
        IsPeekingTransport = nil
    
        SetNuiFocus(false, false)
        
        SendUIMessage('Eye', 'ToggleEye', {
            State = false,
        })
    
        for k, v in pairs(Eye.Entries) do
            if v.Type:lower() == 'zone' and v.State then v.State = false end
        end
    end
end)

-- [ Examples \\
--[[
exports['mercy-ui']:AddEyeEntry("ped_1", {
    Type = 'Entity',
    EntityType = 'Ped', -- Optional, unless its a Ped
    -- Entity = Entity,  -- Optional, use only when the entity is spawned by script
    SpriteDistance = 10.0,
    State = false,
    Position = vector4(-623.44, -234.36, 38.06, 125.84),
    Model = 'a_m_m_bevhills_02',
    -- Scenario = "", -- Optional
    Anim = {
        Dict = "missheistdockssetup1clipboard@base",
        Name = "base"
    }, -- Optional
    Props = {
        {
            Prop = 'prop_notepad_01',
            Bone = 18905,
            Placement = { 0.1, 0.02, 0.05, 10.0, 0.0, 0.0 },
        },
        {
            Prop = 'prop_pencil_01',
            Bone = 58866,
            Placement = { 0.11, -0.02, 0.001, -120.0, 0.0, 0.0 },
        },
    }, -- Optional
    Options = {
        {
            Name = 'test_interaction',
            Icon = 'fas fa-tools',
            Label = 'Test Interaction',
            EventType = 'Client',
            EventName = 'mercy-ui:Client:EyeTest',
            EventParams = {},
            Enabled = function(Entity)
                return true
            end,
        }
    }
})


local Entity = CreateObject(GetHashKey("v_res_d_dildo_f"), -623.44, -234.36, 38.06, false, false, false)
FreezeEntityPosition(Entity, true)
SetEntityInvincible(Entity, true)

exports['mercy-ui']:AddEyeEntry("object_1", {
    Type = 'Entity',
    Entity = Entity,  -- Optional, use only when the entity is spawned by script
    SpriteDistance = 10.0,
    Distance = 5.0,
    State = false,
    Position = vector4(-623.44, -234.36, 38.06, 125.84),
    Options = {
        {
            Name = 'test_interaction',
            Icon = 'fas fa-tools',
            Label = 'Test Interaction',
            EventType = 'Client',
            EventName = 'mercy-ui:Client:EyeTest',
            EventParams = {},
            Enabled = function(Entity)
                return true
            end,
        }
    }
})

exports['mercy-ui']:AddEyeEntry("zone_1", {
    Type = 'Zone',
    SpriteDistance = 10.0,
    Distance = 5.0,
    State = false,
    ZoneData = {
        Center = vector3(-627.21, -234.9, 38.06),
        Length = 0.6,
        Width = 1.3,
        Data = {
            debugPoly = true, -- Optional, shows the box zone (Default: false)
            heading = 36,
            minZ = 37.76,
            maxZ = 38.26
        },
    },
    Options = {
        {
            Name = 'test_interaction',
            Icon = 'fas fa-tools',
            Label = 'Test Interaction',
            EventType = 'Client',
            EventName = 'mercy-ui:Client:EyeTest',
            EventParams = {},
            Enabled = function(Entity)
                return true
            end,
        }
    }
})

exports['mercy-ui']:AddEyeEntry(GetHashKey("prop_bin_05a"), {
    Type = 'Model',
    Model = 'prop_bin_05a',
    SpriteDistance = 10.0,
    Distance = 5.0,
    Options = {
        {
            Name = 'test_interaction',
            Label = 'Test Interaction',
            EventType = 'Client',
            EventName = 'mercy-ui:Client:EyeTest',
            EventParams = {},
            Enabled = function(Entity)
                return true
            end,
        }
    }
})
]]