PlayerModule, EventsModule, FunctionsModule, BlipModule, CallbackModule, LoggerModule = nil
SavedSkin = {}
local CreatingNew = false

AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
        'Player',
		'Events',
        'Functions',
        'BlipManager',
        'Callback',
        'Logger',
    }, function(Succeeded)
        if not Succeeded then return end
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
        BlipModule = exports['mercy-base']:FetchModule('BlipManager')
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        LoggerModule = exports['mercy-base']:FetchModule('Logger')
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
        SetEntityCoords(PlayerPedId(), 2852.08, -1460.88, 13.38)
        SetEntityHeading(PlayerPedId(), 29.94)
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
    DebugLog('SkinLoad', Model)
    Citizen.CreateThread(function()
        if FunctionsModule.RequestModel(Model) then 
            SetPlayerModel(PlayerId(), GetHashKey(Model)) 
            SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 0) 
        end
	resetCharItems()
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

    if SkinData == nil or next(SkinData) == nil then
        DebugLog('SkinLoad', 'Skin data not found. Can\'t load skin...')
        return
    end
    if TattoosData == nil or next(TattoosData) == nil then
        DebugLog('TattoosLoad', 'Tattoos data not found. Can\'t load tattoos...')
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
        SkinData["Facemix"] = Config.SkinData['Skin']["Facemix"]
        SkinData["Skinmix"] = Config.SkinData['Skin']["Skinmix"]
        SkinData["Thirdmix"] = Config.SkinData['Skin']["Thirdmix"]

        SkinData["Facemix"].Item = SkinData["Facemix"].defaultItem
        SkinData["Skinmix"].Item = SkinData["Skinmix"].defaultItem
        SkinData["Thirdmix"].Item = SkinData["Thirdmix"].defaultItem

        SkinData["Face"] = Config.SkinData['Skin']["Face"]
        SkinData["Face2"] = Config.SkinData['Skin']["Face2"]
        SkinData["Face3"] = Config.SkinData['Skin']["Face3"]

        DebugLog('Parents', 'Missing parents data, applying default. ('..SkinData["Face"]..' | '..SkinData["Face2"]..' | '..SkinData["Face3"]..' | '.. SkinData["Facemix"].Item ..' | '.. SkinData["Skinmix"].Item ..' | '.. SkinData["Thirdmix"].Item ..')')
    end
    if (EntityModel == `mp_f_freemode_01` or EntityModel == `mp_m_freemode_01`) then
        SetPedHeadBlendData(PlayerPed, 
        SkinData["Face"].Item, 
        SkinData["Face2"].Item, 
        SkinData["Face3"].Item, 
        SkinData["Face"].Texture, 
        SkinData["Face2"].Texture, 
        SkinData["Face3"].Texture, 
        SkinData["Facemix"].Item, 
        SkinData["Skinmix"].Item, 
        SkinData["Thirdmix"].Item, false)

        DebugLog('Parents', '('.. SkinData["Face"].Item ..' | '.. SkinData["Face2"].Item ..' | '.. SkinData["Face3"].Item ..' | '.. SkinData["Facemix"].Item ..' | '.. SkinData["Skinmix"].Item ..' | '.. SkinData["Thirdmix"].Item ..')')
    end

    ---
    -- Hair
    ---
     
    -- Hair
    SetPedComponentVariation(PlayerPed, 2, SkinData["Hair"].Item, 0, 0)
    SetPedHairColor(PlayerPed, SkinData["Hair"].Texture, SkinData["Hair"].Texture2)

    -- Eyebrows
    SetPedHeadOverlay(PlayerPed, 2, SkinData["Eyebrows"].Item, 1.0)
    SetPedHeadOverlayColor(PlayerPed, 2, 1, SkinData["Eyebrows"].Texture, SkinData["Eyebrows"].Texture2)

    -- Beard (Facial Hair)
    SetPedHeadOverlay(PlayerPed, 1, SkinData["Beard"].Item, SkinData["Beard"].Opacity)
    SetPedHeadOverlayColor(PlayerPed, 1, 1, SkinData["Beard"].Texture, SkinData["Beard"].Texture2)

    -- Chest (Chest Hair)
    SetPedHeadOverlay(PlayerPed, 10, SkinData["Chesthair"].Item, SkinData["Chesthair"].Opacity)
    SetPedHeadOverlayColor(PlayerPed, 10, 1, SkinData["Chesthair"].Texture, SkinData["Chesthair"].Texture2)

    DebugLog('Hair', '(Hair: '.. SkinData["Hair"].Item ..' | Eyebrows: '.. SkinData["Eyebrows"].Item ..' | Beard: '.. SkinData["Beard"].Item ..' | Chest: '.. SkinData["Chesthair"].Item ..')')

    ---
    -- Skin
    ---

    -- Blemishes
    if SkinData["Blemishes"].Item ~= -1 and SkinData["Blemishes"].Item ~= 0 then
        SetPedHeadOverlay(PlayerPed, 0, SkinData["Blemishes"].Item, SkinData["Blemishes"].Opacity)
    end

    -- Ageing
    if SkinData["Wrinkles"].Item ~= -1 and SkinData["Wrinkles"].Item ~= 0 then
        SetPedHeadOverlay(PlayerPed, 3, SkinData["Wrinkles"].Item, SkinData["Wrinkles"].Opacity)
    end

    -- Complexion
    if SkinData["Complexion"].Item ~= -1 and SkinData["Complexion"].Item ~= 0 then
        SetPedHeadOverlay(PlayerPed, 6, SkinData["Complexion"].Item, SkinData["Complexion"].Opacity)
    end

    -- Sun Damage
    if SkinData["SunDamage"].Item ~= -1 and SkinData["SunDamage"].Item ~= 0 then
        SetPedHeadOverlay(PlayerPed, 7, SkinData["SunDamage"].Item, SkinData["SunDamage"].Opacity)
    end

    -- Moles & Freckles
    if SkinData["Moles"].Item ~= -1 and SkinData["Moles"].Item ~= 0 then
        SetPedHeadOverlay(PlayerPed, 9, SkinData["Moles"].Item, SkinData["Moles"].Opacity)
    end

    -- Body Blemishes
    if SkinData["BodyBlemishes"].Item ~= -1 and SkinData["BodyBlemishes"].Item ~= 0 then
        SetPedHeadOverlay(PlayerPed, 11, SkinData["BodyBlemishes"].Item, SkinData["BodyBlemishes"].Opacity)
    end

    DebugLog('Skin', '(Blemishes: '.. SkinData["Blemishes"].Item ..' | Ageing: '.. SkinData["Wrinkles"].Item ..' | Complexion: '.. SkinData["Complexion"].Item ..' | Sun Damage: '.. SkinData["SunDamage"].Item ..' | Moles: '.. SkinData["Moles"].Item ..' | Body Blemishes: '.. SkinData["BodyBlemishes"].Item ..')')

    ---
    -- Makeup
    ---

    -- Makeup
    SetPedHeadOverlay(PlayerPed, 4, SkinData["Makeup"].Item, SkinData["Makeup"].Opacity)
    SetPedHeadOverlayColor(PlayerPed, 4, 2, SkinData["Makeup"].Texture, SkinData["Makeup"].Texture2)

    -- Blush
    SetPedHeadOverlay(PlayerPed, 5, SkinData["Blush"].Item, SkinData["Blush"].Opacity)
    SetPedHeadOverlayColor(PlayerPed, 5, 2, SkinData["Blush"].Texture, SkinData["Blush"].Texture2)

    -- Lipstick
    SetPedHeadOverlay(PlayerPed, 8, SkinData["Lipstick"].Item, SkinData["Lipstick"].Opacity)
    SetPedHeadOverlayColor(PlayerPed, 8, 2, SkinData["Lipstick"].Texture, SkinData["Lipstick"].Texture2)

    DebugLog('Makeup', '(Makeup: '.. SkinData["Makeup"].Item ..' | Blush: '.. SkinData["Blush"].Item ..' | Lipstick: '.. SkinData["Lipstick"].Item ..')')

    ---
    -- Clothing
    ---

    -- Hat
    if SkinData["Hat"].Item ~= -1 then
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

    local Hat = next(SkinData["Hat"]) ~= nil and SkinData["Hat"].Item or "Not found."
    local Jacket = next(SkinData["Shirts"]) ~= nil and SkinData["Shirts"].Item or "Not found."
    local Undershirt = next(SkinData["UnderShirt"]) ~= nil and SkinData["UnderShirt"].Item or "Not found."
    local Arms = next(SkinData["Arms"]) ~= nil and SkinData["Arms"].Item or "Not found."
    local Pants = next(SkinData["Pants"]) ~= nil and SkinData["Pants"].Item or "Not found."
    local Shoes = next(SkinData["Shoes"]) ~= nil and SkinData["Shoes"].Item or "Not found."
    local Decals = next(SkinData["Decals"]) ~= nil and SkinData["Decals"].Item or "Not found."
    DebugLog('Clothing', '(Hat: '..Hat..' | Jacket: '..Jacket..' | Undershirt: '..Undershirt..' | Arms: '..Arms..' | Pants: '..Pants..' | Shoes: '..Shoes..' | Decals: '..Decals..')')

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

    DebugLog('Accessories', '(Mask: '.. SkinData["Mask"].Item ..' | Glasses: '.. SkinData["Glasses"].Item ..' | Earrings: '.. SkinData["Earpiece"].Item ..' | Scarfs & Necklaces: '.. SkinData["Necklace"].Item ..' | Watches: '.. SkinData["Watch"].Item ..' | Bracelets: '.. SkinData["Bracelet"].Item ..' | Vest: '.. SkinData["ArmorVest"].Item ..' | Bag: '.. SkinData["Bag"].Item ..')')

    -- Tattoos
    ClearPedDecorations(PlayerPed)
    if TattoosData["TChest"].Item ~= 0 then
        AddPedDecorationFromHashes(PlayerPed, TattoosData["TChest"].Collection, TattoosData["TChest"].Texture)
    end
    if TattoosData["THead"].Item ~= 0 then
        AddPedDecorationFromHashes(PlayerPed, TattoosData["THead"].Collection, TattoosData["THead"].Texture)
    end
    if TattoosData["LLeg"].Item ~= 0 then
        AddPedDecorationFromHashes(PlayerPed, TattoosData["LLeg"].Collection, TattoosData["LLeg"].Texture)
    end
    if TattoosData["RLeg"].Item ~= 0 then
        AddPedDecorationFromHashes(PlayerPed, TattoosData["RLeg"].Collection, TattoosData["RLeg"].Texture)
    end
    if TattoosData["LArm"].Item ~= 0 then
        AddPedDecorationFromHashes(PlayerPed, TattoosData["LArm"].Collection, TattoosData["LArm"].Texture)
    end
    if TattoosData["RArm"].Item ~= 0 then
        AddPedDecorationFromHashes(PlayerPed, TattoosData["RArm"].Collection, TattoosData["RArm"].Texture)
    end

    DebugLog('Tattoos', '(Chest: '.. TattoosData["TChest"].Item ..' | Head: '.. TattoosData["THead"].Item ..' | Left Leg: '.. TattoosData["LLeg"].Item ..' | Right Leg: '.. TattoosData["RLeg"].Item ..' | Left Arm: '.. TattoosData["LArm"].Item ..' | Right Arm: '.. TattoosData["RArm"].Item ..')')

    ---
    -- FACE CATEGORY
    ---

    -- Eye Color
    if SkinData["Eyes"].Item ~= -1 and SkinData["Eyes"].Item ~= 0 then
        SetPedEyeColor(PlayerPed, SkinData['Eyes'].Item)
    end

    -- Nose
    SetPedFaceFeature(PlayerPed, 0, (SkinData['NoseWidth'].Item))
    SetPedFaceFeature(PlayerPed, 1, (SkinData['PeakHeight'].Item))
    SetPedFaceFeature(PlayerPed, 2, (SkinData['PeakLength'].Item))
    SetPedFaceFeature(PlayerPed, 3, (SkinData['BoneHeight'].Item))
    SetPedFaceFeature(PlayerPed, 4, (SkinData['PeakLowering'].Item))
    SetPedFaceFeature(PlayerPed, 5, (SkinData['BoneTwist'].Item))

    -- Eyebrows
    SetPedFaceFeature(PlayerPed, 6, (SkinData['EyebrowHeight'].Item))
    SetPedFaceFeature(PlayerPed, 7, (SkinData['EyebrowDepth'].Item))

    -- Cheeks
    SetPedFaceFeature(PlayerPed, 8, (SkinData['CheekBoneHeight'].Item))
    SetPedFaceFeature(PlayerPed, 9, (SkinData['CheekBoneWidth'].Item))
    SetPedFaceFeature(PlayerPed, 10, (SkinData['CheekWidth'].Item))

    -- Jaw Bone
    SetPedFaceFeature(PlayerPed, 13, (SkinData['JawBoneWidth'].Item))
    SetPedFaceFeature(PlayerPed, 14, (SkinData['JawBoneBackLength'].Item))

    -- Chin Bone
    SetPedFaceFeature(PlayerPed, 15, (SkinData['ChinBoneHeight'].Item))
    SetPedFaceFeature(PlayerPed, 16, (SkinData['ChinBoneLength'].Item))
    SetPedFaceFeature(PlayerPed, 17, (SkinData['ChinBoneWidth'].Item))
    SetPedFaceFeature(PlayerPed, 18, (SkinData['ChinCleft'].Item))

    -- Miscellaneous Features
    SetPedFaceFeature(PlayerPed, 11, (SkinData['EyesSquint'].Item))
    SetPedFaceFeature(PlayerPed, 19, (SkinData['NeckThickness'].Item))
    SetPedFaceFeature(PlayerPed, 12, (SkinData['LipsThickness'].Item))

    DebugLog('Face', 'Nose: (Width: '.. SkinData['NoseWidth'].Item ..' | Peak Height: '.. SkinData['PeakHeight'].Item ..' | Peak Length: '.. SkinData['PeakLength'].Item ..' | Bone Height: '.. SkinData['BoneHeight'].Item ..' | Peak Lowering: '.. SkinData['PeakLowering'].Item ..' | Bone Twist: '.. SkinData['BoneTwist'].Item ..')'..
    '\nEyebrows: (Height: '.. SkinData['EyebrowHeight'].Item ..' | Depth: '.. SkinData['EyebrowDepth'].Item ..')'.. 
    '\nCheeks: (Bone Height: '.. SkinData['CheekBoneHeight'].Item ..' | Bone Width: '.. SkinData['CheekBoneWidth'].Item ..' | Width: '.. SkinData['CheekWidth'].Item ..')'.. 
    '\nJaw Bone: (Width: '.. SkinData['JawBoneWidth'].Item ..' | Back Length: '.. SkinData['JawBoneBackLength'].Item ..')'..
    '\nChin Bone: (Height: '.. SkinData['ChinBoneHeight'].Item ..' | Length: '.. SkinData['ChinBoneLength'].Item ..' | Width: '.. SkinData['ChinBoneWidth'].Item ..' Cleft: | '.. SkinData['ChinCleft'].Item ..')'.. 
    '\nMiscellaneous: (Eyes Squint'.. SkinData['EyesSquint'].Item ..' | Neck Thickness:'.. SkinData['NeckThickness'].Item ..' | Lips Thickness: '.. SkinData['LipsThickness'].Item ..')')

    -- Hair Fade
    local Gender = "Female"
    local Model = GetEntityModel(PlayerPed)
    if Model == `mp_m_freemode_01` then Gender = "Male" end
    local FacialDec = Config.HairFades[Gender][SkinData["HairFade"].Item]
    if Model ~= nil and FacialDec then
        AddPedDecorationFromHashesInCorona(PlayerPed, FacialDec[1], FacialDec[2])
    end
    DebugLog('HairFade', SkinData["HairFade"].Item)


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
            ClearPedProp(PlayerPed, 2)
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

    -- Hat
    if Data["Hat"] ~= nil then
        if Data["Hat"].Item ~= -1 then
            SetPedPropIndex(PlayerPed, 0, Data["Hat"].Item, Data["Hat"].Texture, true)
        else
            ClearPedProp(PlayerPed, 0)
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

    FunctionsModule.RequestAnimDict("mp_sleep")
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
    SetPedMaxHealth(PlayerPedId(), 200)
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
    resetCharItems()
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

RegisterNetEvent('mercy-clothing/client/take-off-face-wear', function(Type, Extra, anim, animdict)
    if Type and Type ~= 'SteelShoes' then
        local bool = IsType(Type)
        local Gender = "Female"
        local Model = GetEntityModel(PlayerPed)
        local propID, propID2 = 0, 0
        local HasType
        if bool then HasType = GetPedPropIndex(PlayerPedId(), Config.AccessoriesTypes[Type]) else HasType = GetPedDrawableVariation(PlayerPedId(), Config.ClothesTypes[Type]) end
        if Model == `mp_m_freemode_01` then Gender = "Male" end
        if HasType ~= -1 then
            if Config.charItems[Type]['Using'] then
                FunctionsModule.RequestAnimDict(animdict)
                TaskPlayAnim(PlayerPedId(), animdict, anim, 4.0, 3.0, -1, 49, 1.0, 0, 0, 0)
                Citizen.Wait(800)
                local faceProps = {}
                if bool then
                    faceProps = getCloth({Config.AccessoriesTypes[Type]}, {Type}, {-1})
                    ClearPedProp(PlayerPedId(), Config.AccessoriesTypes[Type])
                else
                    if Type == 'Pants' then
                        if Gender == 'Male' then propID = 0 else propID = 61 end
                        faceProps = getCloth({Config.ClothesTypes[Type]}, {Type}, {propID})
                        SetPedComponentVariation(PlayerPedId(), Config.ClothesTypes[Type], propID, math.random(1, 13), 0)
                    elseif Type == 'Shirts' then
                        if Gender == 'Male' then propID = 0 else propID = 15 end
                        faceProps = getCloth({Config.ClothesTypes[Type], 8, 3}, {Type, 'UnderShirt', 'Arms'}, {propID, propID, propID})
                        SetPedComponentVariation(PlayerPedId(), Config.ClothesTypes[Type], propID, 0, 0)
                        SetPedComponentVariation(PlayerPedId(), 8, propID, 0, 0)
                        SetPedComponentVariation(PlayerPedId(), 3, propID, 0, 0)
                    elseif Type == 'UnderShirt' then
                        if Gender == 'Male' then propID, propID2 = 0, 0 else propID, propID2 = 15, 184 end
                        faceProps = getCloth({Config.ClothesTypes[Type], 3}, {Type, 'Arms'}, {propID, propID2})
                        SetPedComponentVariation(PlayerPedId(), Config.ClothesTypes[Type], propID, 0, 0)
                        SetPedComponentVariation(PlayerPedId(), 3, propID2, 0, 0)
                    elseif Type == 'Shoes' then
                        if Gender == 'Male' then propID = 35 else propID = 34 end
                        faceProps = getCloth({Config.ClothesTypes[Type]}, {Type}, {propID})
                        SetPedComponentVariation(PlayerPedId(), Config.ClothesTypes[Type], propID, 0, 0)
                    else
                        faceProps = getCloth({Config.ClothesTypes[Type]}, {Type}, {-1})
                        SetPedComponentVariation(PlayerPedId(), Config.ClothesTypes[Type], -1, 0, 0)
                    end
                end
                TriggerServerEvent('mercy-clothing/server/receive-clothing', Type:lower(), faceProps)
            end
        end
    elseif Type == 'SteelShoes' then
        Config.SkinData['Skin']['Shoes']['Item'] = Extra
        Config.SkinData['Skin']['Shoes']['Texture'] = 0
        SetPedComponentVariation(PlayerPedId(), 6, Extra, 0, 0)
    end
    ClearPedTasks(PlayerPedId())
    TriggerServerEvent("mc-clothing/server/save-skin", Config.SkinData)
end)

RegisterNetEvent('mercy-clothing/client/take-on-face-wear', function(Type, Info, Slot, Ignore, anim, animdict)
    if Type then
        local bool = IsType(Type)
        if Ignore ~= nil and not Ignore then
            FunctionsModule.RequestAnimDict(animdict)
            TaskPlayAnim(PlayerPedId(), animdict, anim, 4.0, 3.0, -1, 49, 1.0, 0, 0, 0)
            Citizen.Wait(800)
            setCloth(Info)
            local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', 'clothing-' .. Type:lower(), 1, Slot, true)
        else
            if Config.SkinData['Skin'][Type]['Item'] > -1 then
                FunctionsModule.RequestAnimDict(animdict)
                TaskPlayAnim(PlayerPedId(), animdict, anim, 4.0, 3.0, -1, 49, 1.0, 0, 0, 0)
                Citizen.Wait(800)
                if bool then SetPedPropIndex(PlayerPedId(), Config.AccessoriesTypes[Type], Config.SkinData['Skin'][Type]['Item'], Config.SkinData['Skin'][Type]['Texture'], true) else SetPedComponentVariation(PlayerPedId(), Config.ClothesTypes[Type], Config.SkinData['Skin'][Type]['Item'], Config.SkinData['Skin'][Type]['Texture'], 0) end
            end
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

function IsType(Type)
    if not Config.AccessoriesTypes[Type] then return false else return true end
end

function getCloth(dataId, dataName, propID)
    local faceProps = {}
    for i=1, #dataId do
        local bool = IsType(dataName[i])
        local charItem = Config.charItems[dataName[i]]
        local skinItem = Config.SkinData['Skin'][dataName[i]]

        if charItem and skinItem then
            faceProps[i] = {}
            skinItem['Item'] = propID[i]
            skinItem['Texture'] = 0
            charItem['Using'] = false

            if bool then
                faceProps[i]['TypeName'] = dataName[i]
                faceProps[i]['TypeID'] = dataId[i]
                faceProps[i]['Item'] = GetPedPropIndex(PlayerPedId(), dataId[i])
                faceProps[i]['Texture'] = GetPedPropTextureIndex(PlayerPedId(), dataId[i])
            else
                faceProps[i]['TypeName'] = dataName[i]
                faceProps[i]['TypeID'] = dataId[i]
                faceProps[i]['Item'] = GetPedDrawableVariation(PlayerPedId(), dataId[i])
                faceProps[i]['Texture'] = GetPedTextureVariation(PlayerPedId(), dataId[i])
            end
        else
            print("Error: Invalid charItem or skinItem for '" .. tostring(dataName[i]) .. "'.")
        end
    end
    return faceProps
end

function setCloth(Info)
    local data = Info
    for k, v in ipairs(data) do
        if v.TypeID ~= nil then
            local bool = IsType(v.TypeName)
            Config.charItems[v.TypeName]['Using'] = true
            if bool then
                Config.SkinData['Skin'][v.TypeName]['Item'] = v.Item
                Config.SkinData['Skin'][v.TypeName]['Texture'] = v.Texture
                SetPedPropIndex(PlayerPedId(), v.TypeID, v.Item, v.Texture, true)
            else
                Config.SkinData['Skin'][v.TypeName]['Item'] = v.Item
                Config.SkinData['Skin'][v.TypeName]['Texture'] = v.Texture
                SetPedComponentVariation(PlayerPedId(), v.TypeID, v.Item, v.Texture, 0)
            end
        else
            break
        end
    end
end

function resetCharItems()
    for k, v in pairs(Config.charItems) do
        v['Using'] = true
    end
end
