SavedSkin = {}
local CreatingNew = false
PlayerModule, EventsModule, FunctionsModule, BlipModule, CallbackModule = nil, nil, nil, nil, nil

AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
        'Player',
		'Events',
        'Functions',
        'BlipManager',
        'Callback',
    }, function(Succeeded)
        if not Succeeded then return end
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
        BlipModule = exports['mercy-base']:FetchModule('BlipManager')
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
    end)
end)

RegisterNetEvent('mercy-base/client/on-login', function()
    InitMenu()
end)

-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('mercy-clothing/client/open-wardrobe', function(Forced) -- Apps
    if Forced then
        local POutfits = CallbackModule.SendCallback('mc-clothing/server/get-outfits')
        OpenMenu('Outfits', {POutfits})
    end
end)

RegisterNetEvent('mercy-clothing/client/create-new-char', function()
    PlayerModule.GetPlayerData(function(PlayerData)
        local DefaultPed = "mp_m_freemode_01"
        if PlayerData.CharInfo.Gender == 'Female' then
            DefaultPed = "mp_f_freemode_01"
        end
        Config.SkinData['Skin']['Model'].Item = DefaultPed
        NetworkSetEntityInvisibleToNetwork(PlayerPedId(), true)
        EventsModule.TriggerServer('mercy-base/server/bucketmanager/set-routing-bucket')
        TriggerEvent('mercy-weathersync/client/set-default-weather', 15)
        SetEntityCoords(PlayerPedId(), -755.57, 324.83, 199.2)
        SetEntityHeading(PlayerPedId(), 126.1)
        Citizen.SetTimeout(500, function()
            DoScreenFadeIn(200)
            while not IsScreenFadedIn() do
                Citizen.Wait(10)
            end
            CreatingNew = true
            ChangeToSkinNoUpdate(DefaultPed)
            OpenMenu('New')
            SendNUIMessage({ Action = "ResetValues" })
        end)
    end)
end)

RegisterNetEvent('mc-clothing/client/add-outfit', function()
    local OutfitName = 'outfit-' .. math.random(11111, 99999)
    TriggerEvent('mc-clothing/client/save-current-outfit', OutfitName)
end)

RegisterNetEvent("mc-clothing/client/save-current-outfit", function(Name)
    TriggerServerEvent('mc-clothing/server/save-outfit', Name, Config.SkinData)
    exports['mercy-ui']:Notify("clothes-saved", Lang:t('info.saved_outfit', { outfit = Name}), "success")
end)

RegisterNetEvent('mercy-clothing/client/open-menu', function() -- /skin
    local POutfits = CallbackModule.SendCallback('mc-clothing/server/get-outfits')
    OpenMenu('All', {POutfits})
end)

RegisterNetEvent('mc-clothing/client/get-outfits', function(Job)
    local Model = GetEntityModel(PlayerPedId())
    local Gender = Model == 'mp_f_freemode_01' and "Female" or "Male"
    local POutfits = CallbackModule.SendCallback('mc-clothing/server/get-outfits')
    OpenMenu('Room', {POutfits, Config.Outfits[Job][Gender]})
end)

RegisterNetEvent("mc-clothing/client/load-skin", function(Model, Skin, Tattoos)
    local SkinData = {}
    local Player = PlayerModule.GetPlayerData()
    Model = Model ~= nil and Model or Player.CharInfo.Gender == 'Male' and "mp_m_freemode_01" or 'mp_f_freemode_01'
    DebugLog('SkinLoad', 'Loading skin for player. '.. Model ..' | '.. json.encode(Skin) ..' | '.. json.encode(Tattoos))
    Citizen.CreateThread(function()
        if FunctionsModule.RequestModel(Model) then 
            SetPlayerModel(PlayerId(), GetHashKey(Model)) 
            SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 0) 
        end
        SkinData['Skin'] = Skin
        SkinData['Tattoos'] = Tattoos
        TriggerEvent('mercy-clothing/client/load-clothing', SkinData, PlayerPedId())
    end)
end)

RegisterNetEvent('mercy-clothing/client/load-clothing', function(Data, PlayerPed)
    if PlayerPed == nil then PlayerPed = PlayerPedId() end
    local SkinData = Data['Skin']
    local TattoosData = Data['Tattoos']
    local EntityModel = GetEntityModel(PlayerPed)

    if SkinData == nil then
        DebugLog('SkinLoad', 'Skin data is nil. Can\'t load skin...')
        return
    end
    if TattoosData == nil then
        DebugLog('TattoosLoad', 'Tattoos data is nil. Can\'t load tattoos...')
        return
    end

    -- Clear Ped
    for i = 0, 11 do
        SetPedComponentVariation(PlayerPed, i, 0, 0, 0)
    end
    for i = 0, 7 do
        ClearPedProp(PlayerPed, i)
    end

    ---
    -- Parents
    ---
    if not SkinData["Facemix"] or not SkinData["Skinmix"] or not SkinData["Thirdmix"] or not SkinData["Face"] or not SkinData["Face2"] or not SkinData["Face3"] then
        DebugLog('Parents', 'Missing parents data, applying default.')
        SkinData["Facemix"] = Config.SkinData['Skin']["Facemix"]
        SkinData["Skinmix"] = Config.SkinData['Skin']["Skinmix"]
        SkinData["Thirdmix"] = Config.SkinData['Skin']["Thirdmix"]

        SkinData["Facemix"].Item = SkinData["Facemix"].defaultItem
        SkinData["Skinmix"].Item = SkinData["Skinmix"].defaultItem
        SkinData["Thirdmix"].Item = SkinData["Thirdmix"].defaultItem

        SkinData["Face"] = Config.SkinData['Skin']["Face"]
        SkinData["Face2"] = Config.SkinData['Skin']["Face2"]
        SkinData["Face3"] = Config.SkinData['Skin']["Face3"]
    end
    if (EntityModel == `mp_f_freemode_01` or EntityModel == `mp_m_freemode_01`) then
        SetPedHeadBlendData(PlayerPed, SkinData["Face"].Item, SkinData["Face2"].Item, SkinData["Face3"].Item, SkinData["Face"].Texture, SkinData["Face2"].Texture, SkinData["Face3"].Texture, SkinData["Facemix"].Item, SkinData["Skinmix"].Item, SkinData["Thirdmix"].Item, false)
        DebugLog('Parents', 'Applied parents to ped.')
    end

    ---
    -- Hair
    ---
     
    -- Hair
    SetPedComponentVariation(PlayerPed, 2, SkinData["Hair"].Item, 0, 0)
    SetPedHairColor(PlayerPed, SkinData["Hair"].Texture, SkinData["Hair"].Texture2)

    -- Hair Fade
    local Gender = "Female"
    local Model = GetEntityModel(PlayerPed)
    if Model == `mp_m_freemode_01` then Gender = "Male" end
    local FacialDec = Config.HairFades[Gender][SkinData["HairFade"].Item]
    if Model ~= nil and FacialDec then
        SetPedFacialDecoration(PlayerPed, FacialDec[1], FacialDec[2])
    end

    -- Eyebrows
    SetPedHeadOverlay(PlayerPed, 2, SkinData["Eyebrows"].Item, 1.0)
    SetPedHeadOverlayColor(PlayerPed, 2, 1, SkinData["Eyebrows"].Texture, SkinData["Eyebrows"].Texture2)

    -- Beard (Facial Hair)
    SetPedHeadOverlay(PlayerPed, 1, SkinData["Beard"].Item, SkinData["Beard"].Opacity)
    SetPedHeadOverlayColor(PlayerPed, 1, 1, SkinData["Beard"].Texture, SkinData["Beard"].Texture2)

    -- Chest (Chest Hair)
    SetPedHeadOverlay(PlayerPed, 10, SkinData["Chesthair"].Item, SkinData["Chesthair"].Opacity)
    SetPedHeadOverlayColor(PlayerPed, 10, 1, SkinData["Chesthair"].Texture, SkinData["Chesthair"].Texture2)

    DebugLog('Hair', 'Applied hair to ped.')

    ---
    -- Skin
    ---

    -- Blemishes
    if SkinData["Blemishes"].Item ~= -1 and SkinData["Blemishes"].Item ~= 0 then
        SetPedHeadOverlay(PlayerPed, 0, SkinData["Blemishes"].Item, SkinData["Blemishes"].Opacity)
        -- SetPedHeadOverlayColor(PlayerPed, 0, 1, SkinData["Blemishes"].Texture, 0)
    end

    -- Ageing
    if SkinData["Wrinkles"].Item ~= -1 and SkinData["Wrinkles"].Item ~= 0 then
        SetPedHeadOverlay(PlayerPed, 3, SkinData["Wrinkles"].Item, SkinData["Wrinkles"].Opacity)
        -- SetPedHeadOverlayColor(PlayerPed, 3, 1, SkinData["Wrinkles"].Texture, 0)
    end

    -- Complexion
    if SkinData["Complexion"].Item ~= -1 and SkinData["Complexion"].Item ~= 0 then
        SetPedHeadOverlay(PlayerPed, 6, SkinData["Complexion"].Item, SkinData["Complexion"].Opacity)
        -- SetPedHeadOverlayColor(PlayerPed, 6, 1, SkinData["Complexion"].Texture, 0)
    end

    -- Sun Damage
    if SkinData["SunDamage"].Item ~= -1 and SkinData["SunDamage"].Item ~= 0 then
        SetPedHeadOverlay(PlayerPed, 7, SkinData["SunDamage"].Item, SkinData["SunDamage"].Opacity)
        -- SetPedHeadOverlayColor(PlayerPed, 7, 1, SkinData["SunDamage"].Texture, 0)
    end

    -- Moles & Freckles
    if SkinData["Moles"].Item ~= -1 and SkinData["Moles"].Item ~= 0 then
        SetPedHeadOverlay(PlayerPed, 9, SkinData["Moles"].Item, SkinData["Moles"].Opacity)
    end

    -- Body Blemishes
    if SkinData["BodyBlemishes"].Item ~= -1 and SkinData["BodyBlemishes"].Item ~= 0 then
        SetPedHeadOverlay(PlayerPed, 11, SkinData["BodyBlemishes"].Item, SkinData["BodyBlemishes"].Opacity)
        -- SetPedHeadOverlayColor(PlayerPed, 11, 1, SkinData["BodyBlemishes"].Texture, 0)
    end

    DebugLog('Skin', 'Applied skin to ped.')

    ---
    -- Makeup
    ---

    -- Makeup
    SetPedHeadOverlay(PlayerPed, 4, SkinData["Makeup"].Item, 1.0)
    SetPedHeadOverlayColor(PlayerPed, 4, 2, SkinData["Makeup"].Texture, SkinData["Makeup"].Texture2)

    -- Blush
    SetPedHeadOverlay(PlayerPed, 5, SkinData["Blush"].Item, 1.0)
    SetPedHeadOverlayColor(PlayerPed, 5, 2, SkinData["Blush"].Texture, SkinData["Blush"].Texture2)

    -- Lipstick
    SetPedHeadOverlay(PlayerPed, 8, SkinData["Lipstick"].Item, 1.0)
    SetPedHeadOverlayColor(PlayerPed, 8, 2, SkinData["Lipstick"].Texture, SkinData["Lipstick"].Texture2)

    DebugLog('Makeup', 'Applied makeup to ped.')

    ---
    -- Clothing
    ---

    -- Hat
    if SkinData["Hat"].Item ~= -1 and SkinData["Hat"].Item ~= 0 then
        SetPedPropIndex(PlayerPed, 0, SkinData["Hat"].Item, SkinData["Hat"].Texture, true)
    else
        ClearPedProp(PlayerPed, 0)
    end

    -- Jacket
    SetPedComponentVariation(PlayerPed, 11, SkinData["Shirts"].Item, 0, 2)
    SetPedComponentVariation(PlayerPed, 11, SkinData["Shirts"].Item, SkinData["Shirts"].Texture, 0)
        
    -- Undershirt
    SetPedComponentVariation(PlayerPed, 8, SkinData["UnderShirt"].Item, 0, 2)
    SetPedComponentVariation(PlayerPed, 8, SkinData["UnderShirt"].Item, SkinData["UnderShirt"].Texture, 0)

    -- Arms / Gloves
    SetPedComponentVariation(PlayerPed, 3, SkinData["Arms"].Item, 0, 2)
    SetPedComponentVariation(PlayerPed, 3, SkinData["Arms"].Item, SkinData["Arms"].Texture, 0)

    -- Pants
    SetPedComponentVariation(PlayerPed, 4, SkinData["Pants"].Item, 0, 0)
    SetPedComponentVariation(PlayerPed, 4, SkinData["Pants"].Item, SkinData["Pants"].Texture, 0)
        
    -- Shoes
    SetPedComponentVariation(PlayerPed, 6, SkinData["Shoes"].Item, 0, 2)
    SetPedComponentVariation(PlayerPed, 6, SkinData["Shoes"].Item, SkinData["Shoes"].Texture, 0)

    -- Decals
    SetPedComponentVariation(PlayerPed, 10, SkinData["Decals"].Item, 0, 2)
    SetPedComponentVariation(PlayerPed, 10, SkinData["Decals"].Item, SkinData["Decals"].Texture, 0)

    DebugLog('Clothing', 'Applied clothing to ped.')

    ---
    -- Accessories
    ---

    -- Mask
    SetPedComponentVariation(PlayerPed, 1, SkinData["Mask"].Item, 0, 2)
    SetPedComponentVariation(PlayerPed, 1, SkinData["Mask"].Item, SkinData["Mask"].Texture, 0)

    -- Glasses
    if SkinData["Glasses"].Item ~= -1 and SkinData["Glasses"].Item ~= 0 then
        SetPedPropIndex(PlayerPed, 1, SkinData["Glasses"].Item, SkinData["Glasses"].Texture, true)
    else
        ClearPedProp(PlayerPed, 1)
    end

    -- Earrings
    if SkinData["Earpiece"].Item ~= -1 and SkinData["Earpiece"].Item ~= 0 then
        SetPedPropIndex(PlayerPed, 2, SkinData["Earpiece"].Item, SkinData["Earpiece"].Texture, true)
    else
        ClearPedProp(PlayerPed, 2)
    end

    -- Scarfs & Necklaces
    SetPedComponentVariation(PlayerPed, 7, SkinData["Necklace"].Item, 0, 2)
    SetPedComponentVariation(PlayerPed, 7, SkinData["Necklace"].Item, SkinData["Necklace"].Texture, 0)

    -- Watches
    if SkinData["Watch"].Item ~= -1 and SkinData["Watch"].Item ~= 0 then
        SetPedPropIndex(PlayerPed, 6, SkinData["Watch"].Item, SkinData["Watch"].Texture, true)
    else
        ClearPedProp(PlayerPed, 6)
    end

    -- Bracelets
    if SkinData["Bracelet"].Item ~= -1 and SkinData["Bracelet"].Item ~= 0 then
        SetPedPropIndex(PlayerPed, 7, SkinData["Bracelet"].Item, SkinData["Bracelet"].Texture, true)
    else
        ClearPedProp(PlayerPed, 7)
    end

    -- Vest
    SetPedComponentVariation(PlayerPed, 9, SkinData["ArmorVest"].Item, 0, 2)
    SetPedComponentVariation(PlayerPed, 9, SkinData["ArmorVest"].Item, SkinData["ArmorVest"].Texture, 0)

    -- Bag
    SetPedComponentVariation(PlayerPed, 5, SkinData["Bag"].Item, 0, 2)
    SetPedComponentVariation(PlayerPed, 5, SkinData["Bag"].Item, SkinData["Bag"].Texture, 0)

    DebugLog('Accessories', 'Applied accessories to ped.')

    ---
    -- FACE CATEGORY
    ---

    -- Eye Color
    if SkinData["Eyes"].Item ~= -1 and SkinData["Eyes"].Item ~= 0 then
        SetPedEyeColor(PlayerPed, SkinData['Eyes'].Item)
    end

    -- Nose
    SetPedFaceFeature(PlayerPed, 0, (SkinData['NoseWidth'].Item / 10))
    SetPedFaceFeature(PlayerPed, 1, (SkinData['PeakHeight'].Item / 10))
    SetPedFaceFeature(PlayerPed, 2, (SkinData['PeakLength'].Item / 10))
    SetPedFaceFeature(PlayerPed, 3, (SkinData['BoneHeight'].Item / 10))
    SetPedFaceFeature(PlayerPed, 4, (SkinData['PeakLowering'].Item / 10))
    SetPedFaceFeature(PlayerPed, 5, (SkinData['BoneTwist'].Item / 10))

    -- Eyebrows
    SetPedFaceFeature(PlayerPed, 6, (SkinData['EyebrowHeight'].Item / 10))
    SetPedFaceFeature(PlayerPed, 7, (SkinData['EyebrowDepth'].Item / 10))

    -- Cheeks
    SetPedFaceFeature(PlayerPed, 8, (SkinData['CheekBoneHeight'].Item / 10))
    SetPedFaceFeature(PlayerPed, 9, (SkinData['CheekBoneWidth'].Item / 10))
    SetPedFaceFeature(PlayerPed, 10, (SkinData['CheekWidth'].Item / 10))

    -- Jaw Bone
    SetPedFaceFeature(PlayerPed, 13, (SkinData['JawBoneWidth'].Item / 10))
    SetPedFaceFeature(PlayerPed, 14, (SkinData['JawBoneBackLength'].Item / 10))

    -- Chin Bone
    SetPedFaceFeature(PlayerPed, 15, (SkinData['ChinBoneHeight'].Item / 10))
    SetPedFaceFeature(PlayerPed, 16, (SkinData['ChinBoneLength'].Item / 10))
    SetPedFaceFeature(PlayerPed, 17, (SkinData['ChinBoneWidth'].Item / 10))
    SetPedFaceFeature(PlayerPed, 18, (SkinData['ChinCleft'].Item / 10))

    -- Miscellaneous Features
    SetPedFaceFeature(PlayerPed, 11, (SkinData['EyesSquint'].Item / 10))
    SetPedFaceFeature(PlayerPed, 19, (SkinData['NeckThickness'].Item / 10))
    SetPedFaceFeature(PlayerPed, 12, (SkinData['LipsThickness'].Item / 10))

    DebugLog('Face', 'Applied face to ped.')

    -- Tattoos
    ClearPedDecorations(PlayerPed)
    if TattoosData["TChest"].Item ~= 0 then
        ApplyPedOverlay(PlayerPed, TattoosData["TChest"].Collection, TattoosData["TChest"].Texture)
    end
    if TattoosData["THead"].Item ~= 0 then
        ApplyPedOverlay(PlayerPed, TattoosData["THead"].Collection, TattoosData["THead"].Texture)
    end
    if TattoosData["LLeg"].Item ~= 0 then
        ApplyPedOverlay(PlayerPed, TattoosData["LLeg"].Collection, TattoosData["LLeg"].Texture)
    end
    if TattoosData["RLeg"].Item ~= 0 then
        ApplyPedOverlay(PlayerPed, TattoosData["RLeg"].Collection, TattoosData["RLeg"].Texture)
    end
    if TattoosData["LArm"].Item ~= 0 then
        ApplyPedOverlay(PlayerPed, TattoosData["LArm"].Collection, TattoosData["LArm"].Texture)
    end
    if TattoosData["RArm"].Item ~= 0 then
        ApplyPedOverlay(PlayerPed, TattoosData["RArm"].Collection, TattoosData["RArm"].Texture)
    end

    DebugLog('Tattoos', 'Applied tattoos to ped.')
    DebugLog('Skin', 'Applied skin to ped.')
    Config.SkinData['Skin'] = SkinData
    Config.SkinData['Tattoos'] = TattoosData
end)

RegisterNetEvent("mc-clothing/client/load-outfit", function(Data)
    local PlayerPed = PlayerPedId()
    local OutfitName = Data.OutfitName
    Data = Data.OutfitData['Skin'] or Data.OutfitData

    if typeof(Data) ~= "table" then 
        Data = json.decode(Data) 
    end

    for k, v in pairs(Data) do
        if type(k) == 'number' then -- Still Array
            for i, j in pairs(v) do
                Config.SkinData['Skin'][i].Item = v[i].Item
                Config.SkinData['Skin'][i].Texture = v[i].Texture
            end
            Data = Config.SkinData['Skin']
        else
            Config.SkinData['Skin'][k].Item = Data[k].Item
            Config.SkinData['Skin'][k].Texture = Data[k].Texture
        end
    end

    -- CLOTHING CATEGORY

    -- Hat
    if Data["Hat"] ~= nil then
        if Data["Hat"].Item ~= -1 and Data["Hat"].Item ~= 0 then
            SetPedPropIndex(PlayerPed, 0, Data["Hat"].Item, Data["Hat"].Texture, true)
        else
            ClearPedProp(PlayerPed, 0)
        end
    end

    -- Jacket
    if Data["Shirts"] ~= nil then
        SetPedComponentVariation(PlayerPed, 11, Data["Shirts"].Item, Data["Shirts"].Texture, 0)
    end

    -- Undershirt
    if Data["UnderShirt"] ~= nil then
        SetPedComponentVariation(PlayerPed, 8, Data["UnderShirt"].Item, Data["UnderShirt"].Texture, 0)
    end

    -- Arms / Gloves
    if Data["Arms"] ~= nil then
        SetPedComponentVariation(PlayerPed, 3, Data["Arms"].Item, Data["Arms"].Texture, 0)
    end

    -- Pants
    if Data["Pants"] ~= nil then
        SetPedComponentVariation(PlayerPed, 4, Data["Pants"].Item, Data["Pants"].Texture, 0)
    end

    -- Shoes
    if Data["Shoes"] ~= nil then
        SetPedComponentVariation(PlayerPed, 6, Data["Shoes"].Item, Data["Shoes"].Texture, 0)
    end

    -- Decals
    if Data["Decals"] ~= nil then
        SetPedComponentVariation(PlayerPed, 10, Data["Decals"].Item, Data["Decals"].Texture, 0)
    end

    -- ACCESSORIES CATEGORY

    -- Mask
    if Data["Mask"] ~= nil then
        SetPedComponentVariation(PlayerPed, 1, Data["Mask"].Item, Data["Mask"].Texture, 0)
    end

    -- Glass
    if Data["Glasses"] ~= nil then
        if Data["Glasses"].Item ~= -1 and Data["Glasses"].Item ~= 0 then
            SetPedPropIndex(PlayerPed, 1, Data["Glasses"].Item, Data["Glasses"].Texture, true)
        else
            ClearPedProp(PlayerPed, 1)
        end
    end

    -- Ear
    if Data["Earpiece"] ~= nil then
        if Data["Earpiece"].Item ~= -1 and Data["Earpiece"].Item ~= 0 then
            SetPedPropIndex(PlayerPed, 2, Data["Earpiece"].Item, Data["Earpiece"].Texture, true)
        else
            ClearPedProp(PlayerPed, accessory2)
        end
    end

    -- Scarfs & Necklaces
    if Data["Necklace"] ~= nil then
        SetPedComponentVariation(PlayerPed, 7, Data["Necklace"].Item, Data["Necklace"].Texture, 0)
    else
        SetPedComponentVariation(PlayerPed, 7, -1, 0, 2)
    end

    -- Watch
    if Data["Watch"] ~= nil then
        if Data["Watch"].Item ~= -1 and Data["Watch"].Item ~= 0 then
            SetPedPropIndex(PlayerPed, 6, Data["Watch"].Item, Data["Watch"].Texture, true)
        else
            ClearPedProp(PlayerPed, 6)
        end
    end

    -- Bracelets
    if Data["Bracelet"] ~= nil then
        if Data["Bracelet"].Item ~= -1 and Data["Bracelet"].Item ~= 0 then
            SetPedPropIndex(PlayerPed, 7, Data["Bracelet"].Item, Data["Bracelet"].Texture, true)
        else
            ClearPedProp(PlayerPed, 7)
        end
    end

    -- Vest
    if Data["ArmorVest"] ~= nil then
        SetPedComponentVariation(PlayerPed, 9, Data["ArmorVest"].Item, Data["ArmorVest"].Texture, 0)
    end

    -- Bag
    if Data["Bag"] ~= nil then
        SetPedComponentVariation(PlayerPed, 5, Data["Bag"].Item, Data["Bag"].Texture, 0)
    end

    exports['mercy-ui']:Notify("clothes-chosen", Lang:t('info.chosen_outfit', { name = OutfitName }), 'success')
end)

RegisterNetEvent("mc-clothing/client/load-player-skin", function()
    TriggerServerEvent('mc-clothing/server/load-skin')
end)

-- [ NUI Callbacks ] --

RegisterNUICallback('SelectOutfit', function(Data, Cb)
    TriggerEvent('mc-clothing/client/load-outfit', Data)
    Cb('Ok')
end)

RegisterNUICallback("Zoom", function(Data, Cb)
    if DoingCam then return end
    DoingCam = true

    for k, v in pairs(Config.Cams) do
        SetCamRot(v, 0.0, 0.0, GetEntityHeading(PlayerPedId()) + 180)
    end

    local Coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), -0.1, 0.5, 0.6)
    SetCamCoord(Config.Cams[1], Coords.x, Coords.y, Coords.z)

    local Coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), -0.2, 1.2, 0.0)
    SetCamCoord(Config.Cams[2], Coords.x, Coords.y, Coords.z)

    local Coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), -0.2, 1.7, 0.0)
    SetCamCoord(Config.Cams[3], Coords.x, Coords.y, Coords.z)

    local Coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), -0.2, 0.7, -0.68)
    SetCamCoord(Config.Cams[4], Coords.x, Coords.y, Coords.z)

    if Data.Up then
        if CurrentActiveCam == 2 then
            SetCamActiveWithInterp(Config.Cams[1], Config.Cams[2], 500)
            CurrentActiveCam = 1
        elseif CurrentActiveCam == 3 then
            SetCamActiveWithInterp(Config.Cams[2], Config.Cams[3], 500)
            CurrentActiveCam = 2
        elseif CurrentActiveCam == 4 then
            SetCamActiveWithInterp(Config.Cams[3], Config.Cams[4], 500)
            CurrentActiveCam = 3
        end
    elseif Data.Down then
        if CurrentActiveCam == 1 then
            SetCamActiveWithInterp(Config.Cams[2], Config.Cams[1], 500)
            CurrentActiveCam = 2
        elseif CurrentActiveCam == 2 then
            SetCamActiveWithInterp(Config.Cams[3], Config.Cams[2], 500)
            CurrentActiveCam = 3
        elseif CurrentActiveCam == 3 then
            SetCamActiveWithInterp(Config.Cams[4], Config.Cams[3], 500)
            CurrentActiveCam = 4
        end
    end

    RequestAnimationDict("mp_sleep")
    Citizen.CreateThread(function()
        while CurrentActiveCam == 1 do
            if not IsEntityPlayingAnim(PlayerPedId(), 'mp_sleep', 'bind_pose_180', 3) then
                TaskPlayAnim(PlayerPedId(), 'mp_sleep', 'bind_pose_180', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
            end
            Citizen.Wait(500)
        end
        StopAnimTask(PlayerPedId(), 'mp_sleep', 'bind_pose_180', 1.0)
    end)
    Citizen.SetTimeout(650, function()
        DoingCam = false
    end)
    Cb('Ok')
end)

RegisterNUICallback("Rotate", function(Data, Cb)
    if Data.Type == 0 then
        SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) - (CurrentPedHeading - (Data.PageX / 2)))
        CurrentPedHeading = (Data.PageX / 2)
    elseif Data.Type == 2 then
        local CurrentHeading = GetEntityHeading(PlayerPedId())
        SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) - (CurrentPedHeading - (Data.PageX / 2)))

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

        SetEntityHeading(PlayerPedId(), CurrentHeading)
    end
    Cb('Ok')
end)

RegisterNUICallback('ResetOutfit', function(Data, Cb)
    TriggerServerEvent("mc-clothing/server/load-skin")
    Config.SkinData = json.decode(SavedSkin)
    SavedSkin = {}
    Cb('Ok')
end)

RegisterNUICallback('GetPrice', function(Data, Cb)
    local Price = GetClothesPrice(Data.ShopType)
    Cb(Price)
end)

RegisterNUICallback('Close', function(_, Cb)
    if CreatingNew then 
        CreatingNew = false
        DoScreenFadeOut(100)
        Citizen.SetTimeout(500, function()
            EventsModule.TriggerServer('mercy-base/server/bucketmanager/set-routing-bucket', 0)
            TriggerEvent('mercy-base/client/on-login')
            Citizen.Wait(5000)
            TriggerEvent('mercy-apartment/client/spawn-apartment', true)
        end)
        ToggleCam(false)
    else
        ToggleCam(false)
    end
    TriggerEvent('mercy-assets/client/toggle-items', false)
    Cb('Ok')
end)

RegisterNUICallback('UpdateSkin', function(Data, Cb)
    ChangeVariation(Data)
    Cb('Ok')
end)

RegisterNUICallback('UpdateSkinOnInput', function(Data, Cb)
    ChangeVariation(Data)
    Cb('Ok')
end)

RegisterNUICallback('RemoveOutfit', function(Data, Cb)
    TriggerServerEvent('mc-clothing/server/remove-outfit', Data.OutfitName, Data.OutfitId)
    Citizen.SetTimeout(500, function()
        local POutfits = CallbackModule.SendCallback('mc-clothing/server/get-outfits')
        SendNUIMessage({
            Action = "ReloadMyOutfits",
            Outfits = POutfits
        })
        exports['mercy-ui']:Notify("removed-outfit", Lang:t('info.removed_outfit', { outfit = Data.OutfitName}), 'success')
    end)
    Cb('Ok')
end)

RegisterNUICallback('ToggleVariation', function(Data, Cb)
    local Type = Data.Type
    local Bool = Data.Bool
    ToggleVariation(Type, Bool, PlayerPedId())
    Cb('Ok')
end)

RegisterNUICallback('SetCurrentPed', function(Data, Cb)
    local Ped = Data.Ped
    local Type = Data.Type:lower()
    if Type == 'male' then
        Config.SkinData['Skin']['Model'].Item = Config.ManPlayerModels[Ped]
        ChangeToSkinNoUpdate(Config.ManPlayerModels[Ped])
        Cb(Config.ManPlayerModels[Ped])
    else
        Config.SkinData['Skin']['Model'].Item = Config.WomanPlayerModels[Ped]
        ChangeToSkinNoUpdate(Config.WomanPlayerModels[Ped])
        Cb(Config.WomanPlayerModels[Ped])
    end
end)

RegisterNUICallback('SaveClothing', function(Data, Cb)
    SaveSkin(Data.OutfitPrice)
    if Data.OutfitName ~= nil then -- Outfit Wardrobe
        TriggerServerEvent('mc-clothing/server/save-outfit', Data.OutfitName, Config.SkinData)
        exports['mercy-ui']:Notify("added-outfit", Lang:t('info.added_outfit', { outfit = Data.OutfitName}), 'success')
    end
    Cb('Ok')
end)

RegisterNUICallback("RenameOutfit", function(Data, Cb)
    local OutfitData = Data.OutfitData
    TriggerServerEvent('mc-clothing/server/rename-outfit', OutfitData.OutfitName, OutfitData.OutfitId, Data.Name)
    Citizen.SetTimeout(500, function()
        local POutfits = CallbackModule.SendCallback('mc-clothing/server/get-outfits')
        SendNUIMessage({
            Action = "ReloadMyOutfits",
            Outfits = POutfits
        })
        exports['mercy-ui']:Notify("renamed-outfit", Lang:t('info.renamed_outfit', { fromOutfit = OutfitData.OutfitName, toOutfit = Data.Name}), 'success')
    end)
    Cb('Ok')
end)

RegisterNetEvent('mercy-clothing/client/take-off-face-wear', function(Type, Extra)
    if Type == 'Hat' then
        local HasHat = GetPedPropIndex(PlayerPedId(), 0)
        if HasHat ~= -1 then
            local HatProp, HatTexture = GetPedPropIndex(PlayerPedId(), 0), GetPedPropTextureIndex(PlayerPedId(), 0)
            FunctionsModule.RequestAnimDict('missheist_agency2ahelmet')
            TaskPlayAnim(PlayerPedId(), "missheist_agency2ahelmet", "take_off_helmet_stand", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0)
            Citizen.Wait(800)
            Config.SkinData['Skin']['Hat']['Item'] = -1
            Config.SkinData['Skin']['Hat']['Texture'] = 0
            ClearPedProp(PlayerPedId(), 0)
            TriggerServerEvent('mercy-clothing/server/receive-clothing', 'Hat', HatProp, HatTexture)
        end
    elseif Type == 'Mask' then
        local HasMask = GetPedDrawableVariation(PlayerPedId(), 1)
        if HasMask ~= -1 then
            local MaskProp, MaskTexture = GetPedDrawableVariation(PlayerPedId(), 1), GetPedTextureVariation(PlayerPedId(), 1)
            FunctionsModule.RequestAnimDict('missfbi4')
            TaskPlayAnim(PlayerPedId(), "missfbi4", "takeoff_mask", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0)
            Citizen.Wait(800)
            Config.SkinData['Skin']['Mask']['Item'] = -1
            Config.SkinData['Skin']['Mask']['Texture'] = 0
            SetPedComponentVariation(PlayerPedId(), 1, -1, 0, 0)
            TriggerServerEvent('mercy-clothing/server/receive-clothing', 'Mask', MaskProp, MaskTexture)
        end
    elseif Type == 'Glasses' then
        local HasGlasses = GetPedPropIndex(PlayerPedId(), 1)
        if HasGlasses ~= -1 then
            local GlassesProp, GlassesTexture = GetPedPropIndex(PlayerPedId(), 1), GetPedPropTextureIndex(PlayerPedId(), 1)
            FunctionsModule.RequestAnimDict('clothingspecs')
            TaskPlayAnim(PlayerPedId(), "clothingspecs", "take_off", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0)
            Citizen.Wait(800)
            Config.SkinData['Skin']['Glasses']['Item'] = -1
            Config.SkinData['Skin']['Glasses']['Texture'] = 0
            ClearPedProp(PlayerPedId(), 1)
            TriggerServerEvent('mercy-clothing/server/receive-clothing', 'Glasses', GlassesProp, GlassesTexture)
        end
    elseif Type == 'Vest' then
        local HasVest = GetPedDrawableVariation(PlayerPedId(), 9)
        if HasVest ~= -1 then
            FunctionsModule.RequestAnimDict('clothingtie')
            TaskPlayAnim(PlayerPedId(), "clothingtie", "try_tie_negative_a", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0)
            Citizen.Wait(800)
            SetPedComponentVariation(PlayerPedId(), 9, -1, 0, 0)
        end
    elseif Type == 'Shoes' then
        Config.SkinData['Skin']['Shoes']['Item'] = Extra
        Config.SkinData['Skin']['Shoes']['Texture'] = 0
        SetPedComponentVariation(PlayerPedId(), 6, Extra, 0, 0)
    end
    ClearPedTasks(PlayerPedId())
    TriggerServerEvent("mc-clothing/server/save-skin", Config.SkinData)
end)

RegisterNetEvent('mercy-clothing/client/take-on-face-wear', function(Type, Info, Slot, Ignore)
    if Type == 'Hat' then
        if Ignore ~= nil and not Ignore then
            FunctionsModule.RequestAnimDict('mp_masks@on_foot')
            TaskPlayAnim(PlayerPedId(), "mp_masks@on_foot", "put_on_mask", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0)
            Citizen.Wait(800)
            Config.SkinData['Skin']['Hat']['Item'] = Info.Prop
            Config.SkinData['Skin']['Hat']['Texture'] = Info.Texture
            SetPedPropIndex(PlayerPedId(), 0, Info.Prop, Info.Texture, true)
            local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', 'clothing-hat', 1, Slot, true)
        else
            if Config.SkinData['Skin']['Hat']['Item'] > -1 then
                FunctionsModule.RequestAnimDict('mp_masks@on_foot')
                TaskPlayAnim(PlayerPedId(), "mp_masks@on_foot", "put_on_mask", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0)
                Citizen.Wait(800)
                SetPedPropIndex(PlayerPedId(), 0, Config.SkinData['Skin']['Hat']['Item'], Config.SkinData['Skin']['Hat']['Texture'], true)
            end
        end
    elseif Type == 'Mask' then
        if Ignore ~= nil and not Ignore then
            FunctionsModule.RequestAnimDict('mp_masks@on_foot')
            TaskPlayAnim(PlayerPedId(), "mp_masks@on_foot", "put_on_mask", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0)
            Citizen.Wait(800)
            Config.SkinData['Skin']['Mask']['Item'] = Info.Prop
            Config.SkinData['Skin']['Mask']['Texture'] = Info.Texture
            SetPedComponentVariation(PlayerPedId(), 1, Info.Prop, Info.Texture, 0)
            local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', 'clothing-mask', 1, Slot, true)
        else
            if Config.SkinData['Skin']['Mask']['Item'] > -1 then
                FunctionsModule.RequestAnimDict('mp_masks@on_foot')
                TaskPlayAnim(PlayerPedId(), "mp_masks@on_foot", "put_on_mask", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0)
                Citizen.Wait(800)
                SetPedComponentVariation(PlayerPedId(), 1, Config.SkinData['Skin']['Mask']['Item'], Config.SkinData['Skin']['Mask']['Texture'], 0)
            end
        end
    elseif Type == 'Glasses' then
        if Ignore ~= nil and not Ignore then
            FunctionsModule.RequestAnimDict('clothingspecs')
            TaskPlayAnim(PlayerPedId(), "clothingspecs", "take_off", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0)
            Citizen.Wait(800)
            Config.SkinData['Skin']['Glasses']['Item'] = Info.Prop
            Config.SkinData['Skin']['Glasses']['Texture'] = Info.Texture
            SetPedPropIndex(PlayerPedId(), 1, Info.Prop, Info.Texture, true)
            local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', 'clothing-glasses', 1, Slot, true)
        else
            if Config.SkinData['Skin']['Glasses']['Item'] > -1 then
                FunctionsModule.RequestAnimDict('clothingspecs')
                TaskPlayAnim(PlayerPedId(), "clothingspecs", "take_off", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0)
                Citizen.Wait(800)
                SetPedPropIndex(PlayerPedId(), 1, Config.SkinData['Skin']['Glasses']['Item'], Config.SkinData['Skin']['Glasses']['Texture'], true)
            end
        end
    elseif Type == 'Vest' then
        if not Ignore then return end
        if Config.SkinData['Skin']['ArmorVest']['Item'] > -1 then
            FunctionsModule.RequestAnimDict('clothingtie')
            TaskPlayAnim(PlayerPedId(), "clothingtie", "try_tie_negative_a", 4.0, 3.0, -1, 49, 1.0, 0, 0, 0)
            Citizen.Wait(800)
            SetPedComponentVariation(PlayerPedId(), 9, Config.SkinData['Skin']['ArmorVest']['Item'], Config.SkinData['Skin']['ArmorVest']['Texture'], 0)
        end
    end
    ClearPedTasks(PlayerPedId())
    TriggerServerEvent("mc-clothing/server/save-skin", Config.SkinData)
end)

RegisterNetEvent('mercy-clothing/client/set-hair-color', function(ColorNumber)
    Config.SkinData['Skin']['Hair'].Texture = ColorNumber
    SetPedHairColor(PlayerPedId(), ColorNumber, Config.SkinData['Skin']['Hair'].Texture2)
    Citizen.SetTimeout(10, function()
        TriggerServerEvent("mc-clothing/server/save-skin", Config.SkinData)
    end)
end)

