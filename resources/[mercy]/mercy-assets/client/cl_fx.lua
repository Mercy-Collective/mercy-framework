local PlayerEffects, Puking = {}, false

RegisterNetEvent('mercy-assets/client/toggle-effect', function(TargetId, Effect, TimeOut, Bool)
    if Bool then
        CreatePedFx(TargetId, Effect, TimeOut)
    else
        ClearPedFx(TargetId)
    end
end)

-- [ Functions ] --

function CreatePedFx(TargetId, Effect, TimeOut)
    local MyServerId = GetPlayerServerId(PlayerId())
    local TargetPed = GetPlayerFromServerId(TargetId)
    local TimeOut = TimeOut ~= nil and TimeOut or 10000
    local EffectData = Config.Effects[Effect] ~= nil and Config.Effects[Effect] or nil
    if PlayerEffects[TargetId] == nil then PlayerEffects[TargetId] = {} end
    if MyServerId == TargetId and Effect == 'Puke' then 
        Puking = true 
        if EffectData['Anim'] ~= nil then
            TriggerEvent('mercy-animations/client/play-animation', EffectData['Anim'])
        end
    end
    if EffectData ~= nil then
        local LoadedEffect = RequestEffectDict(EffectData['EffectDict'])
        if LoadedEffect then
            UseParticleFxAssetNextCall(EffectData['EffectDict'])
            table.insert(PlayerEffects[TargetId], StartParticleFxLoopedOnEntityBone(EffectData['EffectName'], GetPlayerPed(TargetPed), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPedBoneIndex(GetPlayerPed(TargetPed), EffectData['Bone']), EffectData['Scale'], false, false, false))
        end
    end
    Citizen.SetTimeout(TimeOut, function()
        if MyServerId == TargetId and Effect == 'Puke' and Puking then 
            Puking = false 
            TriggerEvent('mercy-animations/client/clear-animation')
        end
        TriggerServerEvent('mercy-assets/server/toggle-effect', TargetId, Effect, false)
    end)
end

-- puking
function ClearPedFx(TargetId)
    for k, v in pairs(PlayerEffects[TargetId]) do
        StopParticleFxLooped(v, 1)
    end
    PlayerEffects[TargetId] = {}
end

function IsPuking()
    return Puking
end

function RequestEffectDict(EffecctDict)
    RequestNamedPtfxAsset(EffecctDict)
    while not HasNamedPtfxAssetLoaded(EffecctDict) do 
        Citizen.Wait(0) 
    end
    return true
end

exports('IsPuking', IsPuking)
exports('RequestEffectDict', RequestEffectDict)