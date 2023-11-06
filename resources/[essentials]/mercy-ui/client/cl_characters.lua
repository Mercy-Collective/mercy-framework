MULTICHARACTER = {
    pos = vector4(2850.52, -1445.4, 15.7, 324.0),
    peds = {
        -- Deze volgorde klopt, 2,1,3,4
        { x = 2852.155, y = -1439.16, z = 13.92243, h = 180.69 }, 
        { x = 2853.134, y = -1439.275, z = 13.92243, h = 180.69 }, 
        { x = 2854.071, y = -1439.58, z = 13.92243, h = 180.69 }, 
        { x = 2854.931, y = -1440.063, z = 13.92243, h = 140.69 }, 
        { x = 2855.678, y = -1440.70, z = 13.92243, h = 140.69 }, 
        { x = 2856.286, y = -1441.481, z = 13.92243, h = 140.69 },
    },
    playerCoord = vector3(2870.52, -1445.4, 14.5),
}

-- local PedAnims = {
--     [1] = {
--         ['Dict'] = "mp_sleep",
--         ['Anim'] = "sleep_loop",
--     },
--     [2] = {
--         ['Dict'] = "mini@repair",
--         ['Anim'] = "fixing_a_ped",
--     },
--     [3] = {
--         ['Dict'] = "misshair_shop@hair_dressers",
--         ['Anim'] = "keeper_base",
--     },
--     [4] = {
--         ['Dict'] = "mp_sleep",
--         ['Anim'] = "sleep_loop",
--     }
-- }


local inCharacterMenu = false
local CharacterProps = {}
local CharCam = nil
local ped = nil

function SendToCharacterScreen(Bool)
    inCharacterMenu = Bool
    Citizen.SetTimeout(500, function()
        if inCharacterMenu then
            TriggerEvent('mercy-weathersync/client/set-default-weather', 21)
            SetEntityCoords(PlayerPedId(), MULTICHARACTER.playerCoord)
            FreezeEntityPosition(PlayerPedId(), true)

            DoCharacterCam(true)

            SetEntityCoords(PlayerPedId(), MULTICHARACTER.playerCoord)
            RequestCollisionAtCoord(MULTICHARACTER.playerCoord.x, MULTICHARACTER.playerCoord.y, MULTICHARACTER.playerCoord.z)
            while not HasCollisionLoadedAroundEntity(PlayerPedId()) do -- Added as a 'hotfix' for falling through the ground because collision wasn't loaded yet
                SetEntityCoords(PlayerPedId(), MULTICHARACTER.playerCoord)
                Citizen.Wait(1)
            end
        
            BuildCharacterProps()
        
            ShutdownLoadingScreen()
            ShutdownLoadingScreenNui()
        
            local Characters = CallbackModule.SendCallback('mercy-ui/server/characters-get')
            SetNuiFocus(true, true)
            SendUIMessage('Characters', 'LoadCharacters', {
                characters = Characters
            })
        else
            DoCharacterCam(false)
            RemoveCharacterProps()
            SetNuiFocus(false, false)
            FreezeEntityPosition(PlayerPedId(), false)
        end
    end)
end


function BuildCharacterProps()
    RequestModel(GetHashKey('mp_m_freemode_01'))
    RequestModel(GetHashKey('mp_f_freemode_01'))

    while CallbackModule == nil do
        Citizen.Wait(100)
    end

    for i = 1, 6, 1 do
        local cid = i
        -- local Anim = PedAnims[i]
        local SkinData = CallbackModule.SendCallback('mercy-ui/server/characters/get-skin', cid)

        local Model = SkinData.Model ~= nil and SkinData.Model or GetHashKey("m_character_select")
        local IsCustomSkin = Config.CustomSkins[Model] or false

        if IsCustomSkin then 
            local ModelLoaded = FunctionsModule.RequestModel(Model)
            if ModelLoaded then
                local Ped = CreatePed(3, Model, MULTICHARACTER.peds[cid].x, MULTICHARACTER.peds[cid].y, MULTICHARACTER.peds[cid].z, MULTICHARACTER.peds[cid].h, false, false)
                SetEntityCoordsNoOffset(Ped, MULTICHARACTER.peds[cid].x, MULTICHARACTER.peds[cid].y, MULTICHARACTER.peds[cid].z)
                SetEntityHeading(Ped, MULTICHARACTER.peds[cid].h)
                -- SetEntityAlpha(Ped, 205, false)
                
                TriggerEvent('mercy-clothing/client/load-clothing', SkinData, Ped)
                
                -- if Anim then
                --     FunctionsModule.RequestAnimDict(Anim['Dict'])
                --     TaskPlayAnim(Ped, Anim['Dict'], Anim['Anim'], 2.0, 2.0, -1, 1, 0, false, false, false)
                -- end

                -- FunctionsModule.RequestAnimDict("amb@prop_human_seat_chair_mp@male@generic@base")
                -- TaskPlayAnim(Ped, "amb@prop_human_seat_chair_mp@male@generic@base", "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", 2.0, 2.0, -1, 1, 0, false, false, false)
        
                CharacterProps['Ped'..cid] = Ped
            end
        else
            local ModelLoaded = FunctionsModule.RequestModel(Model)
            if ModelLoaded then
                local Ped = CreatePed(6, Model, MULTICHARACTER.peds[cid].x, MULTICHARACTER.peds[cid].y, MULTICHARACTER.peds[cid].z, MULTICHARACTER.peds[cid].h, false, false)
                SetEntityCoordsNoOffset(Ped, MULTICHARACTER.peds[cid].x, MULTICHARACTER.peds[cid].y, MULTICHARACTER.peds[cid].z)
                SetEntityHeading(Ped, MULTICHARACTER.peds[cid].h)

                if Model == GetHashKey("m_character_select") then
                    SetEntityAlpha(Ped, 205, false)
                end
    
                TriggerEvent('mercy-clothing/client/load-clothing', SkinData, Ped)

                if Anim then
                    FunctionsModule.RequestAnimDict(Anim['Dict'])
                    TaskPlayAnim(Ped, Anim['Dict'], Anim['Anim'], 2.0, 2.0, -1, 1, 0, false, false, false)
                end

                -- FunctionsModule.RequestAnimDict("amb@prop_human_seat_chair_mp@male@generic@base")
                -- TaskPlayAnim(Ped, "amb@prop_human_seat_chair_mp@male@generic@base", "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", 2.0, 2.0, -1, 1, 0, false, false, false)

                CharacterProps['Ped'..cid] = Ped
            end
        end
    end

    Citizen.Wait(250)
    DoScreenFadeIn(500)
end

function DoCharacterCam(Bool)
    DestroyAllCams()
    if Bool then
        CharCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 
            MULTICHARACTER.pos.x, MULTICHARACTER.pos.y, 
            MULTICHARACTER.pos.z, -10.0, 
            0.0, MULTICHARACTER.pos.w, 
            33.0, false, 0
        )
        SetCamActive(CharCam, true)
        RenderScriptCams(true, false, 1, true, true, false)
        SetFocusArea(MULTICHARACTER.pos.x, MULTICHARACTER.pos.y, MULTICHARACTER.pos.z, 0.0, 0.0, 0.0)
    else
        DestroyCam(CharCam, true)
        SetCamActive(CharCam, false)
        RenderScriptCams(false, false, 1, true, true)
        CharCam = nil
    end
end

-- function DoCharacterCam(Bool)
--     if Bool then
--         CharCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", MULTICHARACTER.pos.x, MULTICHARACTER.pos.y, MULTICHARACTER.pos.z, -10.0, 0.0, MULTICHARACTER.pos.w, 50.0, false, 0)
--         SetCamActive(CharCam, true)
--         RenderScriptCams(true, false, 1, true, true)
--         SetFocusArea(MULTICHARACTER.pos.x, MULTICHARACTER.pos.y, MULTICHARACTER.pos.z, 0.0, 0.0, 0.0)
--     else
--         DestroyCam(CharCam, true)
--         SetCamActive(CharCam, false)
--         RenderScriptCams(false, false, 1, true, true)
--         CharCam = nil
--     end
-- end

function RemoveCharacterProps()
    for k, v in pairs(CharacterProps) do
        DeletePed(v)
    end
end

RegisterNetEvent("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then return end
    RemoveCharacterProps()
end)

RegisterNUICallback('Characters/GetCharacterNameByCid', function(Data, Cb)
    local Name = CallbackModule.SendCallback('mercy-ui/server/characters/get-character-name-by-cid', Data.Cid)
    Cb(Name)
end)

RegisterNUICallback('Characters/CreateCharacter', function(Data, Cb)
    DoScreenFadeOut(200)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    SendUIMessage('Characters', 'HideCharacters', {})

    DoCharacterCam(false)
    RemoveCharacterProps()
    SetNuiFocus(false, false)

    FreezeEntityPosition(PlayerPedId(), false)
    SetEntityCollision(PlayerPedId(), true, true)
    EventsModule.TriggerServer("mercy-ui/server/create-character", Data)
end)

RegisterNUICallback('Characters/LoadCharacter', function(Data, Cb)
    SetNuiFocus(false, false)
    SendUIMessage('Characters', 'HideCharacters', {})
    DoScreenFadeOut(250)
    Citizen.SetTimeout(450, function()
        DoCharacterCam(false)
        RemoveCharacterProps()
        FreezeEntityPosition(PlayerPedId(), false)
        SetEntityCollision(PlayerPedId(), true, true)
        EventsModule.TriggerServer("mercy-ui/server/load-character", Data) 
    end)
end)

RegisterNUICallback('Characters/DeleteCharacter', function(Data, Cb)
    EventsModule.TriggerServer("mercy-ui/server/delete-character", Data)

    SetNuiFocus(false, false)
    SendUIMessage('Characters', 'HideCharacters', {})

    DoScreenFadeOut(250)
    RemoveCharacterProps()
    while not IsScreenFadedOut() do Citizen.Wait(10) end
    
    Citizen.SetTimeout(2500, function()
        local Characters = CallbackModule.SendCallback('mercy-ui/server/characters-get')
        DoScreenFadeIn(250)
        SetNuiFocus(true, true)
        SendUIMessage('Characters', 'LoadCharacters', {
            characters = Characters
        })
        BuildCharacterProps()
    end)
end)

RegisterNetEvent('mercy-ui/client/send-to-character-screen', function()
    SendToCharacterScreen(true)
end)

RegisterNUICallback("Characters/GetFirstEmptyCid", function(Data, Cb)
    local EmptyCid = CallbackModule.SendCallback('mercy-ui/server/characters/get-first-empty-cid')
    Cb(EmptyCid)
end)

RegisterNUICallback("Characters/Refresh", function(Data, Cb)
    SetNuiFocus(false, false)
    SendUIMessage('Characters', 'HideCharacters', {})

    DoScreenFadeOut(250)
    RemoveCharacterProps()
    while not IsScreenFadedOut() do Citizen.Wait(10) end
    
    Citizen.SetTimeout(500, function()
        local Characters = CallbackModule.SendCallback('mercy-ui/server/characters-get')
        DoScreenFadeIn(250)
        SetNuiFocus(true, true)
        SendUIMessage('Characters', 'LoadCharacters', {
            characters = Characters
        })
        BuildCharacterProps()
    end)

    Cb('Ok')
end)

function VecLerp(x1, y1, z1, x2, y2, z2, l, clamp)
    if clamp then
        if l < 0.0 then l = 0.0 end
        if l > 1.0 then l = 1.0 end
    end
    local x = Lerp(x1, x2, l)
    local y = Lerp(y1, y2, l)
    local z = Lerp(z1, z2, l)
    return vector3(x, y, z)
end

function Lerp(a, b, t)
    return a + (b - a) * t
end

