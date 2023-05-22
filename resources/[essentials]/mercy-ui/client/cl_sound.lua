local AudioPlayers, ShouldUpdate3dAudio, HeadBone = 0, false, 0x796e
local EntitySounds = {}

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn and ShouldUpdate3dAudio then
            UpdatePosition()
        else
            Citizen.Wait(450)
        end
    end
end)

-- [ Events ] --

RegisterNetEvent('mercy-ui/client/play-sound', function(AudioName, AudioVolume, Id)
    SendUIMessage('Sounds', 'PlaySound', {
        Name = AudioName,
        Volume = AudioVolume,
        Id = Id,
    })
end)

RegisterNetEvent('mercy-ui/client/stop-sound', function(Id)
    SendUIMessage('Sounds', 'StopSound', {
        Id = Id,
    })
end)

RegisterNetEvent('mercy-ui/client/play-audio-at-pos', function(Position, MaxDistance, AudioName, AudioVolume, FallOff)
    local Position = vector3(Position[1], Position[2], Position[3])
    StartPositionalAudio(Position, MaxDistance, AudioName, AudioVolume, false, MaxDistance, true)
end)

RegisterNetEvent('mercy-ui/client/playaudio-on-entity', function(SoundName, Entity, Timeout, Id, IsServerId, ServerId)
    local Entity = NetworkGetEntityFromNetworkId(Entity)
    if IsServerId ~= nil and IsServerId then 
        local ServerPlayer = GetPlayerFromServerId(ServerId) 
        Entity = GetPlayerPed(ServerPlayer) 
    end
    --if Entity == nil then Entity = PlayerPedId() end
    if DoesEntityExist(Entity) and DoesSoundExist(SoundName) then
        local SoundId = GetSoundId()
        PlaySoundFromEntity(SoundId, SoundName, Entity, 'DLC_NIKEZ_SOUNDS', false, false)
        if Timeout ~= nil then
            Citizen.SetTimeout(Timeout, function()
                StopSound(SoundId)
                ReleaseSoundId(SoundId)
            end)
        else
            if EntitySounds[Id] then
                StopSound(EntitySounds[Id])
                ReleaseSoundId(EntitySounds[Id])
                EntitySounds[Id] = nil
            end
            EntitySounds[Id] = SoundId
        end
    end
end)

RegisterNetEvent('mercy-ui/client/stop-entity-sound', function(Id)
    if EntitySounds[Id] then
        StopSound(EntitySounds[Id])
        ReleaseSoundId(EntitySounds[Id])
        EntitySounds[Id] = nil
    end
end)

-- [ Functions ] --

function StartPositionalAudio(Position, MaxDistance, AudioName, AudioVolume, Remote, RefDistance, FallOff)
    ShouldUpdate3dAudio, AudioPlayers = true, 1
    UpdatePosition()
    SendUIMessage('Sounds', 'PlaySoundSpatial', {
        Name = AudioName,
        Volume = AudioVolume,
        Position = {Position.x, Position.y, Position.z},
        RefDistance = RefDistance,
        MaxDistance = MaxDistance,
        Falloff = FallOff,
    })
end

function UpdatePosition() 
    local Position = GetPedBoneCoords(PlayerPedId(), HeadBone);
    local Heading = GetGameplayCamRot(2)
    local Direction = RotationToDirection(Heading)
    SendUIMessage('Sounds', 'UpdatePosition', {
        Listener = {Position.x, Position.y, Position.z},
        Orientation = {Direction.x, Direction.y, Direction.z},
    })
end

function DoesSoundExist(SoundName)
    for k, v in pairs(Config.Sounds) do
        if v == SoundName then
            return true
        end
    end
    return false
end

-- [ NUU Callbacks ] --

RegisterNUICallback('Sound/StopSpatial', function(Data, Cb)
    AudioPlayers = 0
    if AudioPlayers == 0 then
        ShouldUpdate3dAudio = false
    end
end)