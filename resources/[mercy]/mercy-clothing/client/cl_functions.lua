local StoreBlips = {}
InMenu = false
CurrentActiveCam, CamHeading, DoingCam, CurrentPedHeading = 2, 0.0, false, 0.0
HairColors, MakeUpColors = {}, {}

-- [ Code ] --

-- [ Functions ] --

function InitMenu()
    TriggerServerEvent("mc-clothing/server/load-skin")
    CreateBlips()
    DebugLog('PolyZones', 'Using polyzones for shops and rooms.')
    Citizen.CreateThread(PolyClothing)
end

function DebugLog(Part, Message)
    if Config.Debug then
        print("[" .. GetCurrentResourceName() .. ":" .. Part .. "]: " .. Message)
    end
end

local InZone = false
local ZoneName = nil
function PolyClothing()
    local StoreZones = {}
    local RoomZones = {}

    -- Create  Store Zones
    for i = 1, #Config.Stores do
        local Store = Config.Stores[i]
        StoreZones[#StoreZones + 1] =  exports['mercy-polyzone']:CreateBox({
            center = Store['Coords'],
            length = Store['Length'],
            width = Store['Width'], 
        }, {
            name = Store['Type']..i,
            minZ = Store['Coords'].z - 2,
            maxZ = Store['Coords'].z + 2,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
    end

    -- Create Clothing Room Zones
    for i = 1, #Config.ClothingRooms do
        local Room = Config.ClothingRooms[i]
        RoomZones[#RoomZones + 1] = exports['mercy-polyzone']:CreateBox({
            center = Room['Coords'],
            length = Room['Length'],
            width = Room['Width'], 
        }, {
            name = 'ClothingRooms_' .. i,
            heading = Room['Heading'] or 0.0,
            minZ = Room['Coords'].z - 2,
            maxZ = Room['Coords'].z + 2,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
    end

    Wait(1000)
    while true do
        local Sleep = 1000
        if InZone then
            Sleep = 2
            if string.find(ZoneName, 'surgeon') then
                if IsControlJustReleased(0, 38) then
                    OpenMenu('Surgeon')
                end
            elseif string.find(ZoneName, 'clothing') then
                if IsControlJustReleased(0, 38) then
                    OpenMenu('Store')
                end
            elseif string.find(ZoneName, 'barber') then
                if IsControlJustReleased(0, 38) then
                    OpenMenu('Barber')
                end
            elseif string.find(ZoneName, 'tattoos') then
                if IsControlJustReleased(0, 38) then
                    SendNUIMessage({
                        Action = "ToggleAllClothing",
                    })
                    OpenMenu('Tattoos')
                end
            else
                local Room = Config.ClothingRooms[ZoneName]
                if Room ~= nil then
                    if IsControlJustReleased(0, 38) then
                        PlayerModule.GetPlayerData(function(PlayerData)
                            TriggerEvent('mc-clothing/client/get-outfits', Room['Job'])
                        end)
                    end
                end
            end
        else
            Sleep = 1000
        end
        Wait(Sleep)
    end
end

RegisterNetEvent('mercy-polyzone/client/enter-polyzone', function(PolyData, Coords)
    ZoneName = PolyData.name
    InZone = true
    if string.find(ZoneName, 'surgeon') then
        exports['mercy-ui']:SetInteraction('[E] Plastic Surgery', 'success')
    elseif string.find(ZoneName, 'clothing') then
        exports['mercy-ui']:SetInteraction('[E] Clothing Shop', 'success')
    elseif string.find(ZoneName, 'barber') then
        exports['mercy-ui']:SetInteraction('[E] Barber', 'success')
    elseif string.find(ZoneName, 'tattoos') then
        exports['mercy-ui']:SetInteraction('[E] Tattoo Shop', 'success')
    else
        if string.find(ZoneName, 'ClothingRooms') == nil then return end
        local ZoneId = tonumber(Shared.SplitStr(ZoneName, "_")[2])
        local Room = Config.ClothingRooms[ZoneId]
        if Room ~= nil then
            PlayerModule.GetPlayerData(function(PlayerData)
                local JobName =  PlayerData.Job.Name
                if JobName == Config.ClothingRooms[ZoneId]['Job'] then
                    ZoneName = ZoneId
                    exports['mercy-ui']:SetInteraction('[E] Clothing Room', 'success')
                end
            end)
        end
    end
end)

RegisterNetEvent('mercy-polyzone/client/leave-polyzone', function(PolyData, Coords)
    if InZone then
        InZone = false
        exports["mercy-ui"]:HideInteraction()
    end
end)

function CreateBlips()
    for i = 1, #Config.Stores do
        local Store = Config.Stores[i]
        BlipModule.CreateBlip(Store['Type']..'-'..i, Store['Coords'], Store['BlipSettings']['Label'], Store['BlipSettings']['Sprite'], Store['BlipSettings']['Color'], false, 0.48)
    end
    DebugLog('blips', 'Successfully created blips.')
end

function GetMaxValues()
    local Model = GetEntityModel(PlayerPedId())
    local Gender = Model == `mp_f_freemode_01` and "Female" or "Male"
    Config.MaxValues['Face'].MaxComponent = 45
    Config.MaxValues['Face2'].MaxComponent = 45
    Config.MaxValues['Face3'].MaxComponent = 45

    Config.MaxValues['SkinM'].MaxComponent = #Config.ManPlayerModels
    Config.MaxValues['SkinF'].MaxComponent = #Config.WomanPlayerModels

    Config.MaxValues['HairFade'].MaxComponent = #Config.HairFades[Gender]

    for k, v in pairs(Config.MaxValues) do
        if v.Variation ~= nil then
            Config.MaxValues[k].MaxComponent = GetNumberOfPedDrawableVariations(PlayerPedId(), v.Variation)
            Config.MaxValues[k].MaxTexture = GetNumberOfPedTextureVariations(PlayerPedId(), v.Variation, GetPedDrawableVariation(PlayerPedId(), v.Variation)) - 1
        end
        if v.Prop ~= nil then
            Config.MaxValues[k].MaxComponent = GetNumberOfPedPropDrawableVariations(PlayerPedId(), v.Prop)
            Config.MaxValues[k].MaxTexture = GetNumberOfPedPropTextureVariations(PlayerPedId(), v.Prop, GetPedPropIndex(PlayerPedId(), v.Prop))
        end
        if v.Overlay ~= nil then
            Config.MaxValues[k].MaxComponent = GetNumHeadOverlayValues(v.Overlay) - 1
            Config.MaxValues[k].MaxTexture = 45
        end
    end
    for k, v in pairs(Config.Tattoos[Gender]) do
        Config.MaxValues[k].MaxComponent = #Config.Tattoos[Gender][k]
    end
    SendNUIMessage({
        Action = "UpdateMax",
        MaxValues = Config.MaxValues,
    })
end

function LoadColors()
    for i = 0, GetNumHairColors()-1 do
        local R, G, B = GetPedHairRgbColor(i)
        HairColors[i] = {R, G, B}
    end
    for i = 0, GetNumMakeupColors()-1 do
        local R, G, B= GetPedMakeupRgbColor(i)
        MakeUpColors[i] = {R, G, B}
    end
end

function OpenMenu(Type, Data)
    if InMenu then return end
    InMenu = true
    SavedSkin = json.encode(Config.SkinData)
    LoadColors()
    GetMaxValues()
    SendNUIMessage({
        Action = "Open",
        Type = Type,
        Config = Config,
        CurrentClothing = Config.SkinData,
        HairColors = HairColors,
        MakeUpColors = MakeUpColors,
        HairColor = GetPedHair(),
        Data = Data,
    })
    SetNuiFocus(true, true)
    SetCursorLocation(0.9, 0.25)
    FreezeEntityPosition(PlayerPedId(), true)
    ToggleCam(true)
end

function SetDOF()
    for k, v in pairs(Config.DOFSettings) do
        local Cam = Config.Cams[k]
        local DOFSettings = Config.DOFSettings[k]
        SetCamUseShallowDofMode(Cam, true)
        SetCamNearDof(Cam, DOFSettings['Near'])
        SetCamFarDof(Cam, DOFSettings['Far'])
        SetCamDofStrength(Cam, 1.0)
    end
    while DoesCamExist(Config.Cams[1]) do
        SetUseHiDof()
        Citizen.Wait(0)
    end
end

function ChangeVariation(Data)
    local PlayerPed = PlayerPedId()
    local Category = Data.ClothingType
    local Type = Data.Type
    local Item = Data.ArticleNumber
    local EntityModel = GetEntityModel(PlayerPed)
    if Item then
        ---
        -- Parents
        ---
        if (EntityModel == `mp_f_freemode_01` or EntityModel == `mp_m_freemode_01`) then
            if Category == "Face" then
                if Type == "Item" then
                    SetPedHeadBlendData(PlayerPed, 
                    Item, 
                    Config.SkinData['Skin']["Face2"].Item, 
                    Config.SkinData['Skin']["Face3"].Item, 
                    Config.SkinData['Skin']["Face"].Texture, 
                    Config.SkinData['Skin']["Face2"].Texture, 
                    Config.SkinData['Skin']["Face3"].Texture,
                    Config.SkinData['Skin']["Facemix"].Item, 
                    Config.SkinData['Skin']["Skinmix"].Item, 
                    Config.SkinData['Skin']["Thirdmix"].Item, false)

                    Config.SkinData['Skin']["Face"].Item = Item
                elseif Type == "Texture" then
                    SetPedHeadBlendData(PlayerPed, 
                    Config.SkinData['Skin']["Face"].Item, 
                    Config.SkinData['Skin']["Face2"].Item, 
                    Config.SkinData['Skin']["Face3"].Item, 
                    Item, 
                    Config.SkinData['Skin']["Face2"].Texture, 
                    Config.SkinData['Skin']["Face3"].Texture, 
                    Config.SkinData['Skin']["Facemix"].Item, 
                    Config.SkinData['Skin']["Skinmix"].Item, 
                    Config.SkinData['Skin']["Thirdmix"].Item, false)

                    Config.SkinData['Skin']["Face"].Texture = Item
                end
            elseif Category == "Face2" then
                if Type == "Item" then
                    SetPedHeadBlendData(PlayerPed, 
                    Config.SkinData['Skin']["Face"].Item, 
                    Item, 
                    Config.SkinData['Skin']["Face3"].Item, 
                    Config.SkinData['Skin']["Face"].Texture, 
                    Config.SkinData['Skin']["Face2"].Texture, 
                    Config.SkinData['Skin']["Face3"].Texture, 
                    Config.SkinData['Skin']["Facemix"].Item, 
                    Config.SkinData['Skin']["Skinmix"].Item, 
                    Config.SkinData['Skin']["Thirdmix"].Item, false)

                    Config.SkinData['Skin']["Face2"].Item = Item
                elseif Type == "Texture" then
                    SetPedHeadBlendData(PlayerPed, 
                    Config.SkinData['Skin']["Face"].Item, 
                    Config.SkinData['Skin']["Face2"].Item,
                    Config.SkinData['Skin']["Face3"].Item, 
                    Config.SkinData['Skin']["Face"].Texture, 
                    Item, 
                    Config.SkinData['Skin']["Face3"].Texture, 
                    Config.SkinData['Skin']["Facemix"].Item, 
                    Config.SkinData['Skin']["Skinmix"].Item, 
                    Config.SkinData['Skin']["Thirdmix"].Item, false)

                    Config.SkinData['Skin']["Face2"].Texture = Item
                end
            elseif Category == "Face3" then
                if Type == "Item" then
                    SetPedHeadBlendData(PlayerPed, 
                    Config.SkinData['Skin']["Face"].Item, 
                    Config.SkinData['Skin']["Face2"].Item, 
                    Item, 
                    Config.SkinData['Skin']["Face"].Texture, 
                    Config.SkinData['Skin']["Face2"].Texture, 
                    Config.SkinData['Skin']["Face3"].Texture, 
                    Config.SkinData['Skin']["Facemix"].Item, 
                    Config.SkinData['Skin']["Skinmix"].Item, 
                    Config.SkinData['Skin']["Thirdmix"].Item, false)

                    Config.SkinData['Skin']["Face3"].Item = Item
                elseif Type == "Texture" then
                    SetPedHeadBlendData(PlayerPed, 
                    Config.SkinData['Skin']["Face"].Item, 
                    Config.SkinData['Skin']["Face2"].Item, 
                    Config.SkinData['Skin']["Face3"].Item, 
                    Config.SkinData['Skin']["Face"].Texture, 
                    Config.SkinData['Skin']["Face2"].Texture, 
                    Item, 
                    Config.SkinData['Skin']["Facemix"].Item, 
                    Config.SkinData['Skin']["Skinmix"].Item, 
                    Config.SkinData['Skin']["Thirdmix"].Item, false)

                    Config.SkinData['Skin']["Face3"].Texture = Item
                end
            elseif Category == "Facemix" then
                if Type == "Item" then
                    SetPedHeadBlendData(PlayerPed, 
                    Config.SkinData['Skin']["Face"].Item, 
                    Config.SkinData['Skin']["Face2"].Item, 
                    Config.SkinData['Skin']["Face3"].Item, 
                    Config.SkinData['Skin']["Face"].Texture, 
                    Config.SkinData['Skin']["Face2"].Texture, 
                    Config.SkinData['Skin']["Face3"].Texture, 
                    Item, 
                    Config.SkinData['Skin']["Skinmix"].Item, 
                    Config.SkinData['Skin']["Thirdmix"].Item, false)

                    Config.SkinData['Skin']["Facemix"].Item = Item
                end
            elseif Category == "Skinmix" then
                if Type == "Item" then
                    SetPedHeadBlendData(PlayerPed,
                    Config.SkinData['Skin']["Face"].Item, 
                    Config.SkinData['Skin']["Face2"].Item, 
                    Config.SkinData['Skin']["Face3"].Item, 
                    Config.SkinData['Skin']["Face"].Texture, 
                    Config.SkinData['Skin']["Face2"].Texture, 
                    Config.SkinData['Skin']["Face3"].Texture, 
                    Config.SkinData['Skin']["Facemix"].Item, 
                    Item, 
                    Config.SkinData['Skin']["Thirdmix"].Item, false)

                    Config.SkinData['Skin']["Skinmix"].Item = Item
                end
            elseif Category == "Thirdmix" then
                if Type == "Item" then
                    SetPedHeadBlendData(PlayerPed, 
                    Config.SkinData['Skin']["Face"].Item, 
                    Config.SkinData['Skin']["Face2"].Item, 
                    Config.SkinData['Skin']["Face3"].Item, 
                    Config.SkinData['Skin']["Face"].Texture, 
                    Config.SkinData['Skin']["Face2"].Texture, 
                    Config.SkinData['Skin']["Face3"].Texture, 
                    Config.SkinData['Skin']["Facemix"].Item, 
                    Config.SkinData['Skin']["Skinmix"].Item, 
                    Item, false)

                    Config.SkinData['Skin']["Thirdmix"].Item = Item
                end
            end
        end
        ---
        -- Hair
        ---
        if Category == "Hair" then
            SetPedHeadBlendData(PlayerPed, 
            Config.SkinData['Skin']["Face"].Item, 
            Config.SkinData['Skin']["Face2"].Item, 
            Config.SkinData['Skin']["Face3"].Item, 
            Config.SkinData['Skin']["Face"].Texture, 
            Config.SkinData['Skin']["Face2"].Texture, 
            Config.SkinData['Skin']["Face3"].Texture, 
            Config.SkinData['Skin']["Facemix"].Item, 
            Config.SkinData['Skin']["Skinmix"].Item, 
            Config.SkinData['Skin']["Thirdmix"].Item, false)
            if Type == "Item" then
                SetPedComponentVariation(PlayerPed, 2, Item, 0, 0)
                Config.SkinData['Skin']["Hair"].Item = Item
            elseif Type == "Texture" then
                local Color = tonumber(Item[1]) ~= nil and tonumber(Item[1]) or Config.SkinData['Skin']["Hair"].Texture
                local Highlight = tonumber(Item[2]) ~= nil and tonumber(Item[2]) or Config.SkinData['Skin']["Hair"].Texture2
                SetPedHairColor(PlayerPed, Color, Highlight)
                Config.SkinData['Skin']["Hair"].Texture = Color
                Config.SkinData['Skin']["Hair"].Texture2 = Highlight
            end
        elseif Category == "HairFade" then
            if Type == "Item" then
                local Gender = "Female"
                ClearPedFacialDecorations(PlayerPed)

                local Model = GetEntityModel(PlayerPed)
                if Model == `mp_m_freemode_01` then Gender = "Male" end

                local FacialDec = Config.HairFades[Gender][Item]
                if FacialDec then
                    SetPedFacialDecoration(PlayerPedId(), FacialDec[1], FacialDec[2])
                end
                Config.SkinData['Skin']["HairFade"].Item = Item
            end
        elseif Category == "Eyebrows" then
            if Type == "Item" then
                SetPedHeadOverlay(PlayerPed, 2, Item, 1.0)
                Config.SkinData['Skin']["Eyebrows"].Item = Item
            elseif Type == "Texture" then
                local Color  = tonumber(Item[1]) ~= nil and tonumber(Item[1]) or Config.SkinData['Skin']["Eyebrows"].Texture
                local Color2 = tonumber(Item[2]) ~= nil and tonumber(Item[2]) or Config.SkinData['Skin']["Eyebrows"].Texture2
                SetPedHeadOverlayColor(PlayerPed, 2, 1, Color, Color2)
                Config.SkinData['Skin']["Eyebrows"].Texture = Color
                Config.SkinData['Skin']["Eyebrows"].Texture2 = Color2
            elseif Type == "Opacity" then 
                SetPedHeadOverlay(PlayerPed, 2, Config.SkinData['Skin']["Eyebrows"].Item, Item)
                Config.SkinData['Skin']["Eyebrows"].Opacity = Item
            end
        elseif Category == "Beard" then
            if Type == "Item" then
                SetPedHeadOverlay(PlayerPed, 1, Item, Config.SkinData['Skin']["Beard"].Opacity)
                Config.SkinData['Skin']["Beard"].Item = Item
            elseif Type == "Texture" then
                local Color = tonumber(Item[1]) ~= nil and tonumber(Item[1]) or Config.SkinData['Skin']["Beard"].Texture
                local Color2 = tonumber(Item[2]) ~= nil and tonumber(Item[2]) or Config.SkinData['Skin']["Beard"].Texture2
                SetPedHeadOverlayColor(PlayerPed, 1, 1, Color, Color2)
                Config.SkinData['Skin']["Beard"].Texture = Color
                Config.SkinData['Skin']["Beard"].Texture2 = Color2
            elseif Type == "Opacity" then 
                SetPedHeadOverlay(PlayerPed, 1, Config.SkinData['Skin']["Beard"].Item, Item)
                Config.SkinData['Skin']["Beard"].Opacity = Item
            end
        elseif Category == "Chesthair" then
            if Type == "Item" then
                SetPedHeadOverlay(PlayerPed, 10, Item, 1.0)
                Config.SkinData['Skin']["Chesthair"].Item = Item
            elseif Type == "Texture" then 
                local Color = tonumber(Item[1]) ~= nil and tonumber(Item[1]) or Config.SkinData['Skin']["Chesthair"].Texture
                local Color2 = tonumber(Item[2]) ~= nil and tonumber(Item[2]) or Config.SkinData['Skin']["Chesthair"].Texture2
                SetPedHeadOverlayColor(PlayerPed, 10, 1, Color, Color2)
                Config.SkinData['Skin']["Chesthair"].Texture = Color
                Config.SkinData['Skin']["Chesthair"].Texture2 = Color2
            elseif Type == "Opacity" then 
                SetPedHeadOverlay(PlayerPed, 10, Config.SkinData['Skin']["Chesthair"].Item, Item)
                Config.SkinData['Skin']["Chesthair"].Opacity = Item
            end
        ---
        -- Skin
        ---
        elseif Category == "Blemishes" then
            if Type == "Item" then
                SetPedHeadOverlay(PlayerPed, 0, Item, 1.0)
                Config.SkinData['Skin']["Blemishes"].Item = Item
            elseif Type == "Opacity" then 
                SetPedHeadOverlay(PlayerPed, 0, Config.SkinData['Skin']["Blemishes"].Item, Item)
                Config.SkinData['Skin']["Blemishes"].Opacity = Item
            end
        elseif Category == "Wrinkles" then
            if Type == "Item" then
                SetPedHeadOverlay(PlayerPed, 3, Item, 1.0)
                Config.SkinData['Skin']["Wrinkles"].Item = Item
            elseif Type == "Opacity" then 
                SetPedHeadOverlay(PlayerPed, 3, Config.SkinData['Skin']["Wrinkles"].Item, Item)
                Config.SkinData['Skin']["Wrinkles"].Opacity = Item
            end
        elseif Category == "Complexion" then
            if Type == "Item" then
                SetPedHeadOverlay(PlayerPed, 6, Item, 1.0)
                Config.SkinData['Skin']["Complexion"].Item = Item
            elseif Type == "Opacity" then 
                SetPedHeadOverlay(PlayerPed, 6, Config.SkinData['Skin']["Complexion"].Item, Item)
                Config.SkinData['Skin']["Complexion"].Opacity = Item
            end
        elseif Category == "SunDamage" then
            if Type == "Item" then
                SetPedHeadOverlay(PlayerPed, 7, Item, 1.0)
                Config.SkinData['Skin']["SunDamage"].Item = Item
            elseif Type == "Opacity" then 
                SetPedHeadOverlay(PlayerPed, 7, Config.SkinData['Skin']["SunDamage"].Item, Item)
                Config.SkinData['Skin']["SunDamage"].Opacity = Item
            end
        elseif Category == "Moles" then
            if Type == "Item" then
                SetPedHeadOverlay(PlayerPed, 9, Item, 1.0)
                Config.SkinData['Skin']["Moles"].Item = Item
            elseif Type == "Opacity" then 
                SetPedHeadOverlay(PlayerPed, 9, Config.SkinData['Skin']["Moles"].Item, Item)
                Config.SkinData['Skin']["Moles"].Opacity = Item
            end
        elseif Category == "BodyBlemishes" then
            if Type == "Item" then
                SetPedHeadOverlay(PlayerPed, 11, Item, 1.0)
                Config.SkinData['Skin']["BodyBlemishes"].Item = Item
            elseif Type == "Opacity" then 
                SetPedHeadOverlay(PlayerPed, 11, Config.SkinData['Skin']["BodyBlemishes"].Item, Item)
                Config.SkinData['Skin']["BodyBlemishes"].Opacity = Item
            end
        ---
        -- Makeup
        ---
        elseif Category == "Makeup" then
            if Type == "Item" then
                SetPedHeadOverlay(PlayerPed, 4, Item, 1.0)
                Config.SkinData['Skin']["Makeup"].Item = Item
            elseif Type == "Texture" then
                local Color = tonumber(Item[1]) ~= nil and tonumber(Item[1]) or Config.SkinData['Skin']["Makeup"].Texture
                local Color2 = tonumber(Item[2]) ~= nil and tonumber(Item[2]) or Config.SkinData['Skin']["Makeup"].Texture2
                SetPedHeadOverlayColor(PlayerPed, 4, 2, Color, Color2)
                Config.SkinData['Skin']["Makeup"].Texture = Color
                Config.SkinData['Skin']["Makeup"].Texture2 = Color2
            elseif Type == "Opacity" then 
                SetPedHeadOverlay(PlayerPed, 4, Config.SkinData['Skin']["Makeup"].Item, Item)
                Config.SkinData['Skin']["Makeup"].Opacity = Item
            end
        elseif Category == "Blush" then
            if Type == "Item" then
                SetPedHeadOverlay(PlayerPed, 5, Item, 1.0)
                Config.SkinData['Skin']["Blush"].Item = Item
            elseif Type == "Texture" then
                local Color = tonumber(Item[1]) ~= nil and tonumber(Item[1]) or Config.SkinData['Skin']["Blush"].Texture
                local Color2 = tonumber(Item[2]) ~= nil and tonumber(Item[2]) or Config.SkinData['Skin']["Blush"].Texture2
                SetPedHeadOverlayColor(PlayerPed, 5, 2, Color, Color2)
                Config.SkinData['Skin']["Blush"].Texture = Color
                Config.SkinData['Skin']["Blush"].Texture2 = Color2
            elseif Type == "Opacity" then 
                SetPedHeadOverlay(PlayerPed, 5, Config.SkinData['Skin']["Blush"].Item, Item)
                Config.SkinData['Skin']["Blush"].Opacity = Item
            end
        elseif Category == "Lipstick" then
            if Type == "Item" then
                SetPedHeadOverlay(PlayerPed, 8, Item, 1.0)
                Config.SkinData['Skin']["Lipstick"].Item = Item
            elseif Type == "Texture" then
                local Color = tonumber(Item[1]) ~= nil and tonumber(Item[1]) or Config.SkinData['Skin']["Lipstick"].Texture
                SetPedHeadOverlayColor(PlayerPed, 8, 2, Color, 0)
                Config.SkinData['Skin']["Lipstick"].Texture = Color
            elseif Type == "Opacity" then 
                SetPedHeadOverlay(PlayerPed, 8, Config.SkinData['Skin']["Lipstick"].Item, Item)
                Config.SkinData['Skin']["Lipstick"].Opacity = Item
            end
        ---
        -- Clothing
        ---
        elseif Category == "Hat" then
            if Type == "Item" then
                if Item ~= -1 then
                    SetPedPropIndex(PlayerPed, 0, Item, Config.SkinData['Skin']["Hat"].Texture, true)
                else
                    ClearPedProp(PlayerPed, 0)
                end
                Config.SkinData['Skin']["Hat"].Item = Item
            elseif Type == "Texture" then
                SetPedPropIndex(PlayerPed, 0, Config.SkinData['Skin']["Hat"].Item, Item, true)
                Config.SkinData['Skin']["Hat"].Texture = Item
            end
        elseif Category == "Shirts" then
            if Type == "Item" then
                SetPedComponentVariation(PlayerPed, 11, Item, 0, 2)
                Config.SkinData['Skin']["Shirts"].Item = Item
            elseif Type == "Texture" then
                local curItem = GetPedDrawableVariation(PlayerPed, 11)
                SetPedComponentVariation(PlayerPed, 11, curItem, Item, 0)
                Config.SkinData['Skin']["Shirts"].Texture = Item
            end
        elseif Category == "UnderShirt" then
            if Type == "Item" then
                SetPedComponentVariation(PlayerPed, 8, Item, 0, 2)
                Config.SkinData['Skin']["UnderShirt"].Item = Item
            elseif Type == "Texture" then
                local curItem = GetPedDrawableVariation(PlayerPed, 8)
                SetPedComponentVariation(PlayerPed, 8, curItem, Item, 0)
                Config.SkinData['Skin']["UnderShirt"].Texture = Item
            end
        elseif Category == "Arms" then
            if Type == "Item" then
                SetPedComponentVariation(PlayerPed, 3, Item, 0, 2)
                Config.SkinData['Skin']["Arms"].Item = Item
            elseif Type == "Texture" then
                local curItem = GetPedDrawableVariation(PlayerPed, 3)
                SetPedComponentVariation(PlayerPed, 3, curItem, Item, 0)
                Config.SkinData['Skin']["Arms"].Texture = Item
            end
        elseif Category == "Pants" then
            if Type == "Item" then
                SetPedComponentVariation(PlayerPed, 4, Item, 0, 0)
                Config.SkinData['Skin']["Pants"].Item = Item
            elseif Type == "Texture" then
                local curItem = GetPedDrawableVariation(PlayerPed, 4)
                SetPedComponentVariation(PlayerPed, 4, curItem, Item, 0)
                Config.SkinData['Skin']["Pants"].Texture = Item
            end
        elseif Category == "Shoes" then
            if Type == "Item" then
                SetPedComponentVariation(PlayerPed, 6, Item, 0, 2)
                Config.SkinData['Skin']["Shoes"].Item = Item
            elseif Type == "Texture" then
                local curItem = GetPedDrawableVariation(PlayerPed, 6)
                SetPedComponentVariation(PlayerPed, 6, curItem, Item, 0)
                Config.SkinData['Skin']["Shoes"].Texture = Item
            end
        elseif Category == "Decals" then
            if Type == "Item" then
                SetPedComponentVariation(PlayerPed, 10, Item, 0, 2)
                Config.SkinData['Skin']["Decals"].Item = Item
            elseif Type == "Texture" then
                SetPedComponentVariation(PlayerPed, 10, Config.SkinData['Skin']["Decals"].Item, Item, 0)
                Config.SkinData['Skin']["Decals"].Texture = Item
            end
        ---
        -- Accessories
        ---
        elseif Category == "Mask" then
            if Type == "Item" then
                SetPedComponentVariation(PlayerPed, 1, Item, 0, 2)
                Config.SkinData['Skin']["Mask"].Item = Item
            elseif Type == "Texture" then
                local curItem = GetPedDrawableVariation(PlayerPed, 1)
                SetPedComponentVariation(PlayerPed, 1, curItem, Item, 0)
                Config.SkinData['Skin']["Mask"].Texture = Item
            end
        elseif Category == "Glasses" then
            if Type == "Item" then
                if Item ~= -1 then
                    SetPedPropIndex(PlayerPed, 1, Item, Config.SkinData['Skin']["Glasses"].Texture, true)
                    Config.SkinData['Skin']["Glasses"].Item = Item
                else
                    ClearPedProp(PlayerPed, 1)
                end
            elseif Type == "Texture" then
                SetPedPropIndex(PlayerPed, 1, Config.SkinData['Skin']["Glasses"].Item, Item, true)
                Config.SkinData['Skin']["Glasses"].Texture = Item
            end
        elseif Category == "Earpiece" then
            if Type == "Item" then
                if Item ~= -1 then
                    SetPedPropIndex(PlayerPed, 2, Item, Config.SkinData['Skin']["Earpiece"].Texture, true)
                else
                    ClearPedProp(PlayerPed, 2)
                end
                Config.SkinData['Skin']["Earpiece"].Item = Item
            elseif Type == "Texture" then
                SetPedPropIndex(PlayerPed, 2, Config.SkinData['Skin']["Earpiece"].Item, Item, true)
                Config.SkinData['Skin']["Earpiece"].Texture = Item
            end
        elseif Category == "Necklace" then
            if Type == "Item" then
                SetPedComponentVariation(PlayerPed, 7, Item, 0, 2)
                Config.SkinData['Skin']["Necklace"].Item = Item
            elseif Type == "Texture" then
                SetPedComponentVariation(PlayerPed, 7, Config.SkinData['Skin']["Necklace"].Item, Item, 0)
                Config.SkinData['Skin']["Necklace"].Texture = Item
            end
        elseif Category == "Watch" then
            if Type == "Item" then
                if Item ~= 0 then
                    SetPedPropIndex(PlayerPed, 6, Item, Config.SkinData['Skin']["Watch"].Texture, true)
                else
                    ClearPedProp(PlayerPed, 6)
                end
                Config.SkinData['Skin']["Watch"].Item = Item
            elseif Type == "Texture" then
                SetPedPropIndex(PlayerPed, 6, Config.SkinData['Skin']["Watch"].Item, Item, true)
                Config.SkinData['Skin']["Watch"].Texture = Item
            end
        elseif Category == "Bracelet" then
            if Type == "Item" then
                if Item ~= 0 then
                    SetPedPropIndex(PlayerPed, 7, Item, Config.SkinData['Skin']["Bracelet"].Texture, true)
                else
                    ClearPedProp(PlayerPed, 7)
                end
                Config.SkinData['Skin']["Bracelet"].Item = Item
            elseif Type == "Texture" then
                SetPedPropIndex(PlayerPed, 7, Config.SkinData['Skin']["Bracelet"].Item, Item, true)
                Config.SkinData['Skin']["Bracelet"].Texture = Item
            end
        elseif Category == "ArmorVest" then
            if Type == "Item" then
                SetPedComponentVariation(PlayerPed, 9, Item, 0, 2)
                Config.SkinData['Skin']["ArmorVest"].Item = Item
            elseif Type == "Texture" then
                SetPedComponentVariation(PlayerPed, 9, Config.SkinData['Skin']["ArmorVest"].Item, Item, 0)
                Config.SkinData['Skin']["ArmorVest"].Texture = Item
            end
        elseif Category == "Bag" then
            if Type == "Item" then
                SetPedComponentVariation(PlayerPed, 5, Item, 0, 2)
                Config.SkinData['Skin']["Bag"].Item = Item
            elseif Type == "Texture" then
                SetPedComponentVariation(PlayerPed, 5, Config.SkinData['Skin']["Bag"].Item, Item, 0)
                Config.SkinData['Skin']["Bag"].Texture = Item
            end
        -- Face
        elseif Category == "Eyes" then
            if Type == "Item" then
                SetPedEyeColor(PlayerPed, Item)
                Config.SkinData['Skin']["Eyes"].Item = Item
            end
        elseif Category == "NoseWidth" then
            if Type == "Item" then
                SetPedFaceFeature(PlayerPed, 0, Item)
                Config.SkinData['Skin']["NoseWidth"].Item = Item
            end
        elseif Category == "PeakHeight" then
            if Type == "Item" then
                SetPedFaceFeature(PlayerPed, 1, Item)
                Config.SkinData['Skin']["PeakHeight"].Item = Item
            end
        elseif Category == "PeakLength" then
            if Type == "Item" then
                SetPedFaceFeature(PlayerPed, 2, Item)
                Config.SkinData['Skin']["PeakLength"].Item = Item
            end
        elseif Category == "BoneHeight" then
            if Type == "Item" then
                SetPedFaceFeature(PlayerPed, 3, Item)
                Config.SkinData['Skin']["BoneHeight"].Item = Item
            end
        elseif Category == "PeakLowering" then
            if Type == "Item" then
                SetPedFaceFeature(PlayerPed, 4, Item)
                Config.SkinData['Skin']["PeakLowering"].Item = Item
            end
        elseif Category == "BoneTwist" then
            if Type == "Item" then
                SetPedFaceFeature(PlayerPed, 5, Item)
                Config.SkinData['Skin']["BoneTwist"].Item = Item
            end
        elseif Category == "CheekBoneHeight" then
            if Type == "Item" then
                SetPedFaceFeature(PlayerPed, 8, Item)
                Config.SkinData['Skin']["CheekBoneHeight"].Item = Item
            end
        elseif Category == "CheekBoneWidth" then
            if Type == "Item" then
                SetPedFaceFeature(PlayerPed, 9, Item)
                Config.SkinData['Skin']["CheekBoneWidth"].Item = Item
            end
        elseif Category == "CheekWidth" then
            if Type == "Item" then
                SetPedFaceFeature(PlayerPed, 10, Item)
                Config.SkinData['Skin']["CheekWidth"].Item = Item
            end
        elseif Category == "EyesSquint" then
            if Type == "Item" then
                SetPedFaceFeature(PlayerPed, 11, Item)
                Config.SkinData['Skin']["EyesSquint"].Item = Item
            end
        elseif Category == "EyebrowHeight" then
            if Type == "Item" then
                SetPedFaceFeature(PlayerPed, 6, Item)
                Config.SkinData['Skin']["EyebrowHeight"].Item = Item
            end
        elseif Category == "EyebrowDepth" then
            if Type == "Item" then
                SetPedFaceFeature(PlayerPed, 7, Item)
                Config.SkinData['Skin']["EyebrowDepth"].Item = Item
            end
        elseif Category == "JawBoneWidth" then
            if Type == "Item" then
                SetPedFaceFeature(PlayerPed, 13, Item)
                Config.SkinData['Skin']["JawBoneWidth"].Item = Item
            end
        elseif Category == "JawBoneBackLength" then
            if Type == "Item" then
                SetPedFaceFeature(PlayerPed, 14, Item)
                Config.SkinData['Skin']["JawBoneBackLength"].Item = Item
            end
        elseif Category == "ChinBoneHeight" then
            if Type == "Item" then
                SetPedFaceFeature(PlayerPed, 15, Item)
                Config.SkinData['Skin']["ChinBoneHeight"].Item = Item
            end
        elseif Category == "ChinBoneLength" then
            if Type == "Item" then
                SetPedFaceFeature(PlayerPed, 16, Item)
                Config.SkinData['Skin']["ChinBoneLength"].Item = Item
            end
        elseif Category == "ChinBoneWidth" then
            if Type == "Item" then
                SetPedFaceFeature(PlayerPed, 17, Item)
                Config.SkinData['Skin']["ChinBoneWidth"].Item = Item
            end
        elseif Category == "ChinCleft" then
            if Type == "Item" then
                SetPedFaceFeature(PlayerPed, 18, Item)
                Config.SkinData['Skin']["ChinCleft"].Item = Item
            end
        elseif Category == "NeckThickness" then
            if Type == "Item" then
                SetPedFaceFeature(PlayerPed, 19, Item)
                Config.SkinData['Skin']["NeckThickness"].Item = Item
            end
        elseif Category == "LipsThickness" then
            if Type == "Item" then
                SetPedFaceFeature(PlayerPed, 12, Item)
                Config.SkinData['Skin']["LipsThickness"].Item = Item
            end
        ---
        -- Tattoos
        ---
        elseif Category == "TChest" or Category == "THead" or Category == "LLeg" or Category == "RLeg" or Category == "LArm" or Category == "RArm" then
            if Type == "Item" then
                local Model = GetEntityModel(PlayerPed)
                local Gender = Model == `mp_m_freemode_01` and "Male" or "Female"
                local TattooData = Config.Tattoos[Gender][Category][Item]
                Config.SkinData['Tattoos'][Category] = {Item = Item, Texture = TattooData ~= nil and TattooData['Name'] or 0, Collection = TattooData ~= nil and TattooData['Collection'] or nil, defaultItem = 0, defaultTexture = 0}
                ClearPedDecorations(PlayerPedId())
                for k, v in pairs(Config.SkinData['Tattoos']) do
                    if v.Collection ~= nil then
                        ApplyPedOverlay(PlayerPedId(), GetHashKey(v.Collection), GetHashKey(v.Texture))
                    end
                end
            end
        end
        GetMaxValues()
    end
end

function ChangeToSkinNoUpdate(Skin)
    Citizen.CreateThread(function()
        if FunctionsModule.RequestModel(Skin) then 
            SetPlayerModel(PlayerId(), GetHashKey(Skin))
            SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 2)

            for Type, v in pairs(Config.SkinData['Skin']) do
                -- Change Item Variations
                if Skin == "mp_m_freemode_01" or Skin == "mp_f_freemode_01" then
                    ChangeVariation({
                        ClothingType = Type,
                        ArticleNumber = v.defaultItem,
                        Type = "Item",
                    })
                else
                    if Type ~= "Face" and Type ~= "Hair" and Type ~= "HairFade" and Type ~= "Face2" and Type ~= "Face3" and Type ~= "Eyebrows" and Type ~= "Beard" and Type ~= "Chesthair" and Type ~= "Makeup" and Type ~= "Blush" and Type ~= "Lipstick" then
                        ChangeVariation({
                            ClothingType = Type,
                            ArticleNumber = v.defaultItem,
                            Type = "Item",
                        })
                    end
                end
                -- Change Texture Variations
                if Skin == "mp_m_freemode_01" or Skin == "mp_f_freemode_01" then
                    local ArticleTable = {tonumber(v.defaultTexture), tonumber(v.defaultTexture2)}
                    local Article = tonumber(v.defaultTexture)
                    if Type == 'Hair' or Type == 'Eyebrows' or Type == 'Beard' or Type == 'Chesthair' or Type == 'Makeup' or Type == 'Blush' or Type == 'Lipstick' then
                        ChangeVariation({
                            ClothingType = Type,
                            ArticleNumber = ArticleTable,
                            Type = "Texture",
                        })
                    else
                        ChangeVariation({
                            ClothingType = Type,
                            ArticleNumber = Article,
                            Type = "Texture",
                        })
                    end
                else
                    if Type ~= "Face" and Type ~= "Hair" and Type ~= "HairFade" and Type ~= "Face2" and Type ~= "Face3" and Type ~= "Eyebrows" and Type ~= "Beard" and Type ~= "Chesthair" and Type ~= "Makeup" and Type ~= "Blush" and Type ~= "Lipstick" then -- Custom Models can't have different face / hair textures
                        ChangeVariation({
                            ClothingType = Type,
                            ArticleNumber = v.defaultTexture,
                            Type = "Texture",
                        })
                    end
                end
            end
        end
    end)
end

function ToggleVariation(Type, Bool, Ped)
    local Model = GetEntityModel(Ped)
    if Type == 'All' then
        if Bool or GetPedPropIndex(Ped, 0) ~= Config.SkinData['Skin']['Hat'].Item then
            SetPedPropIndex(Ped, 0, Config.SkinData['Skin']['Hat'].Item, Config.SkinData['Skin']['Hat'].Texture, false)
        else
            ClearPedProp(Ped, 0)
        end
        if Bool or GetPedDrawableVariation(Ped, 1) ~= Config.SkinData['Skin']['Mask'].Item then
            SetPedComponentVariation(Ped, 1, Config.SkinData['Skin']['Mask'].Item, Config.SkinData['Skin']['Mask'].Texture, 0)
        else
            SetPedComponentVariation(Ped, 1, -1, 0, 0)
        end
        if Bool or GetPedPropIndex(Ped, 1) ~= Config.SkinData['Skin']['Glasses'].Item then
            SetPedPropIndex(Ped, 1, Config.SkinData['Skin']['Glasses'].Item, Config.SkinData['Skin']['Glasses'].Texture, false)
        else
            ClearPedProp(Ped, 1)
        end
        if Bool or GetPedDrawableVariation(Ped, 8) ~= Config.SkinData['Skin']['UnderShirt'].Item then
            SetPedComponentVariation(Ped, 3, Config.SkinData['Skin']['Arms'].Item, Config.SkinData['Skin']['Arms'].Texture, 0)
            SetPedComponentVariation(Ped, 8, Config.SkinData['Skin']['UnderShirt'].Item, Config.SkinData['Skin']['UnderShirt'].Texture, 0)
            SetPedComponentVariation(Ped, 9, Config.SkinData['Skin']['ArmorVest'].Item, Config.SkinData['Skin']['ArmorVest'].Texture, 0)
            SetPedComponentVariation(Ped, 11, Config.SkinData['Skin']['Shirts'].Item, Config.SkinData['Skin']['Shirts'].Texture, 0)
        else
            if Model == `mp_f_freemode_01` then -- Female
                SetPedComponentVariation(Ped, 3, 4, 0, 0)
                SetPedComponentVariation(Ped, 8, 14, 0, 0)
                SetPedComponentVariation(Ped, 11, 5, 0, 0)
            elseif Model == `mp_m_freemode_01` then
                SetPedComponentVariation(Ped, 3, 15, 0, 0)
                SetPedComponentVariation(Ped, 8, 15, 0, 0)
                SetPedComponentVariation(Ped, 11, 15, 0, 0)
            end
            SetPedComponentVariation(Ped, 9, -1, 0, 0)
        end
        if Bool or GetPedDrawableVariation(Ped, 5) ~= Config.SkinData['Skin']['Bag'].Item then
            SetPedComponentVariation(Ped, 5, Config.SkinData['Skin']['Bag'].Item, Config.SkinData['Skin']['Bag'].Texture, 0)
        else
            SetPedComponentVariation(Ped, 5, -1, 0, 0)
        end
        if Bool or GetPedDrawableVariation(Ped, 4) ~= Config.SkinData['Skin']['Pants'].Item then
            SetPedComponentVariation(Ped, 4, Config.SkinData['Skin']['Pants'].Item, Config.SkinData['Skin']['Pants'].Texture, 0)
        else
            if Model == `mp_f_freemode_01` then -- Female
                SetPedComponentVariation(Ped, 4, 4, 0, 0) -- TODO female legs
            elseif Model == `mp_m_freemode_01` then
                SetPedComponentVariation(Ped, 4, 21, 0, 0) -- Legs
            end
        end
        if Bool or GetPedDrawableVariation(Ped, 6) ~= Config.SkinData['Skin']['Shoes'].Item then
            SetPedComponentVariation(Ped, 6, Config.SkinData['Skin']['Shoes'].Item, Config.SkinData['Skin']['Shoes'].Texture, 0)
        else
            if Model == `mp_f_freemode_01` then -- Female
                SetPedComponentVariation(Ped, 6, 35, 0, 0)
            elseif Model == `mp_m_freemode_01` then
                SetPedComponentVariation(Ped, 6, 34, 0, 0)
            end
        end  
    elseif Type == 'Hat' then
        if Bool or GetPedPropIndex(Ped, 0) ~= Config.SkinData['Skin']['Hat'].Item then
            SetPedPropIndex(Ped, 0, Config.SkinData['Skin']['Hat'].Item, Config.SkinData['Skin']['Hat'].Texture, false)
        else
            ClearPedProp(Ped, 0)
        end
    elseif Type == 'Mask' then
        if Bool or GetPedDrawableVariation(Ped, 1) ~= Config.SkinData['Skin']['Mask'].Item then
            SetPedComponentVariation(Ped, 1, Config.SkinData['Skin']['Mask'].Item, Config.SkinData['Skin']['Mask'].Texture, 0)
        else
            SetPedComponentVariation(Ped, 1, -1, 0, 0)
        end
    elseif Type == 'Glasses' then
        if Bool or GetPedPropIndex(Ped, 1) ~= Config.SkinData['Skin']['Glasses'].Item then
            SetPedPropIndex(Ped, 1, Config.SkinData['Skin']['Glasses'].Item, Config.SkinData['Skin']['Glasses'].Texture, false)
        else
            ClearPedProp(Ped, 1)
        end
    elseif Type == 'Torso' then
        if Bool or GetPedDrawableVariation(Ped, 8) ~= Config.SkinData['Skin']['UnderShirt'].Item then
            SetPedComponentVariation(Ped, 3, Config.SkinData['Skin']['Arms'].Item, Config.SkinData['Skin']['Arms'].Texture, 0)
            SetPedComponentVariation(Ped, 8, Config.SkinData['Skin']['UnderShirt'].Item, Config.SkinData['Skin']['UnderShirt'].Texture, 0)
            SetPedComponentVariation(Ped, 9, Config.SkinData['Skin']['ArmorVest'].Item, Config.SkinData['Skin']['ArmorVest'].Texture, 0)
            SetPedComponentVariation(Ped, 11, Config.SkinData['Skin']['Shirts'].Item, Config.SkinData['Skin']['Shirts'].Texture, 0)
        else
            if Model == `mp_f_freemode_01` then -- Female
                SetPedComponentVariation(Ped, 3, 4, 0, 0)
                SetPedComponentVariation(Ped, 8, 14, 0, 0)
                SetPedComponentVariation(Ped, 11, 5, 0, 0)
            elseif Model == `mp_m_freemode_01` then
                SetPedComponentVariation(Ped, 3, 15, 0, 0)
                SetPedComponentVariation(Ped, 8, 15, 0, 0)
                SetPedComponentVariation(Ped, 11, 15, 0, 0)
            end
            SetPedComponentVariation(Ped, 9, -1, 0, 0)
        end
    elseif Type == 'Bag' then
        if Bool or GetPedDrawableVariation(Ped, 5) ~= Config.SkinData['Skin']['Bag'].Item then
            SetPedComponentVariation(Ped, 5, Config.SkinData['Skin']['Bag'].Item, Config.SkinData['Skin']['Bag'].Texture, 0)
        else
            SetPedComponentVariation(Ped, 5, -1, 0, 0)
        end
    elseif Type == 'Pants' then
        if Bool or GetPedDrawableVariation(Ped, 4) ~= Config.SkinData['Skin']['Pants'].Item then
            SetPedComponentVariation(Ped, 4, Config.SkinData['Skin']['Pants'].Item, Config.SkinData['Skin']['Pants'].Texture, 0)
        else
            if Model == `mp_f_freemode_01` then -- Female
                SetPedComponentVariation(Ped, 4, 4, 0, 0) -- TODO female legs
            elseif Model == `mp_m_freemode_01` then
                SetPedComponentVariation(Ped, 4, 21, 0, 0) -- Legs
            end
        end
    elseif Type == 'Shoes' then
        if Bool or GetPedDrawableVariation(Ped, 6) ~= Config.SkinData['Skin']['Shoes'].Item then
            SetPedComponentVariation(Ped, 6, Config.SkinData['Skin']['Shoes'].Item, Config.SkinData['Skin']['Shoes'].Texture, 0)
        else
            if Model == `mp_f_freemode_01` then -- Female
                SetPedComponentVariation(Ped, 6, 35, 0, 0)
            elseif Model == `mp_m_freemode_01` then
                SetPedComponentVariation(Ped, 6, 34, 0, 0)
            end
        end  
    end
end

function SaveSkin(Price)
    if Price ~= 0 then
        local HasPaid = CallbackModule.SendCallback('mc-clothing/server/pay-for-clothes', Price)
        if HasPaid then
            TriggerServerEvent("mc-clothing/server/save-skin", Config.SkinData)
        end
    else
        TriggerServerEvent("mc-clothing/server/save-skin", Config.SkinData)
    end
end

function GetPedHair()
    local Ped = PlayerPedId()
    local Colors = {}
    Colors[1] = GetPedHairColor(Ped)
    Colors[2] = GetPedHairHighlightColor(Ped)
    return Colors
end

function GetClothesPrice(ShopType)
    local Price, Clothes = 0, json.decode(SavedSkin)
    if ShopType == 'Tattoos' then
        for TattooName, OptionData in pairs(Config.SkinData['Tattoos']) do
            if OptionData['Collection'] ~= nil and OptionData.Item ~= Clothes['Tattoos'][TattooName].Item then
                Price = Price + 55
            end
        end
    else
        for OptionName, OptionData in pairs(Config.SkinData['Skin']) do
            if OptionData.Item ~= Clothes['Skin'][OptionName].Item then
                Price = Price + 45
            end
        end
    end
    return math.ceil(Price * Config.TaxAmount)
end

function typeof(var)
    local _type = type(var);
    if (_type ~= "table" and _type ~= "userdata") then
        return _type;
    end
    local _meta = getmetatable(var);
    if (_meta ~= nil and _meta._NAME ~= nil) then
        return _meta._NAME;
    else
        return _type;
    end
end

-- Cams

function ToggleCam(Toggle)
    if Toggle then
        Config.Cams[1] = CreateCam('DEFAULT_SCRIPTED_CAMERA', true) 
        Config.Cams[2] = CreateCam('DEFAULT_SCRIPTED_CAMERA', true) 
        Config.Cams[3] = CreateCam('DEFAULT_SCRIPTED_CAMERA', true) 
        Config.Cams[4] = CreateCam('DEFAULT_SCRIPTED_CAMERA', true) 
        for k, v in pairs(Config.Cams) do
            SetCamRot(v, 0.0, 0.0, GetEntityHeading(PlayerPedId()) + 180)
        end
        CamHeading = GetEntityHeading(PlayerPedId()) + 180
        local Coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), -0.1, 0.5, 0.6)
        SetCamCoord(Config.Cams[1], Coords.x, Coords.y, Coords.z)
        local Coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), -0.2, 1.2, 0.0)
        SetCamCoord(Config.Cams[2], Coords.x, Coords.y, Coords.z)
        local Coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), -0.2, 1.7, 0.0)
        SetCamCoord(Config.Cams[3], Coords.x, Coords.y, Coords.z)
        local Coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), -0.2, 0.7, -0.68)
        SetCamCoord(Config.Cams[4], Coords.x, Coords.y, Coords.z)
        SetCamActiveWithInterp(Config.Cams[2], nil, 550)
        RenderScriptCams(true, false, 0, true, true)
        SetDOF()
    else
        SetNuiFocus(false, false)
        NetworkSetEntityInvisibleToNetwork(PlayerPedId(), false)
        RenderScriptCams(false, false, 1, true, true) 
        SetFocusEntity(PlayerPedId())
        FreezeEntityPosition(PlayerPedId(), false)
        for k, Cam in pairs(Config.Cams) do
            SetCamActive(Cam, false) 
            DestroyCam(Cam, true) 
            Cam = nil
        end
        CurrentActiveCam, DoingCam = 2, false
        CurrentPedHeading, CamHeading = 0.0, 0.0
        InMenu = false
    end
end