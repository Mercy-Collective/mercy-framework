var Sounds = RegisterApp('Sounds');
var ActiveSounds = [];
var Active3DAudio = null;

CreateSound = function(AudioName){
    return new Howl({
        src: [`./sounds/${AudioName}.ogg`],
        preload: true,
        autoplay: false,
    });
}

StopSound = function(SoundId) {
    ActiveSounds[SoundId].pause();
    ActiveSounds[SoundId].unload()
    ActiveSounds[SoundId] = null;
}

PlaySound = function(AudioName, AudioVolume, Id) {
    var RandomId = Math.floor(Math.random() * 100000)
    if (Id != undefined) RandomId = Id;
    ActiveSounds[RandomId] = CreateSound(AudioName)
    ActiveSounds[RandomId].volume(AudioVolume);
    ActiveSounds[RandomId].play();
    return RandomId
}

PlaySoundWithTimeOut = function(AudioName, AudioVolume, Id) {
    var RandomId = Math.floor(Math.random() * 100000)
    if (Id != undefined) RandomId = Id;
    ActiveSounds[RandomId] = CreateSound(AudioName)
    ActiveSounds[RandomId].volume(AudioVolume);
    ActiveSounds[RandomId].play();
    ActiveSounds[RandomId].on('end', function(){
        ActiveSounds[RandomId].unload()
        ActiveSounds[RandomId] = null;
    });
}

PlaySoundSpatial = function(AudioName, AudioVolume, Position, RefDistance, MaxDistance, Falloff) {
    if (Active3DAudio != null) { Active3DAudio.pause(); Active3DAudio.unload()}
    Active3DAudio = CreateSound(AudioName)
    Active3DAudio.volume(AudioVolume);
    Active3DAudio.play();
    Active3DAudio.pannerAttr({
        maxDistance: MaxDistance,
        refDistance: RefDistance,
        rolloffFactor: Falloff,
        panningModel: "HRTF",
        distanceModel: "exponential",
        coneInnerAngle: 360,
        coneOuterAngle: 360,
        coneOuterGain: 0,
    })
    Active3DAudio.pos(Position[0], Position[1], Position[2]);
    Active3DAudio.on('end', function(){
        Active3DAudio.unload()
        Active3DAudio = null;
        $.post('https://mercy-ui/Sound/StopSpatial', JSON.stringify({}))
    });
}

UpdatePosition = function(Listener, Orientation) {
    Howler.pos(Listener[0], Listener[1], Listener[2]);
    Howler.orientation(Orientation[0], Orientation[1], 0, Orientation[0], Orientation[1], 1);
}

Sounds.addNuiListener('PlaySound', (Data) => {
    PlaySoundWithTimeOut(Data['Name'], Data['Volume'], Data['Id'])
});

Sounds.addNuiListener('StopSound', (Data) => {
    StopSound(Data['Id'])
});

Sounds.addNuiListener('PlaySoundSpatial', (Data) => {
    PlaySoundSpatial(Data['Name'], Data['Volume'], Data['Position'], Data['RefDistance'], Data['MaxDistance'], Data['Falloff'])
});

Sounds.addNuiListener('UpdatePosition', (Data) => {
    UpdatePosition(Data['Listener'], Data['Orientation'])
});