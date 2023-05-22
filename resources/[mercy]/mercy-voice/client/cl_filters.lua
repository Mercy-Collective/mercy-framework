local MegaphoneSubMix, RadioSubmixFar, RadioSubmixMedium, RadioSubmix, PhoneSubmix, GagSubmix, PodiumSubmix = 0, 0, 0, 0, 0, 0, 0

function LoadFilters()
    if Config.EnableMegaphone then
        RegisterModuleContext("Megaphone", 1)
        UpdateContextVolume("Megaphone", -1.0)
        MegaphoneSubMix = CreateAudioSubmix('Megaphone')
        SetAudioSubmixEffectRadioFx(MegaphoneSubMix, 1)
        SetAudioSubmixEffectParamInt(MegaphoneSubMix, 1, GetHashKey('default'), 1)
        SetAudioSubmixEffectParamFloat(MegaphoneSubMix, 1, GetHashKey('freq_low'), 10.0)
        SetAudioSubmixEffectParamFloat(MegaphoneSubMix, 1, GetHashKey('freq_hi'), 10000.0)
        SetAudioSubmixEffectParamFloat(MegaphoneSubMix, 1, GetHashKey('rm_mod_freq'), 300.0)
        SetAudioSubmixEffectParamFloat(MegaphoneSubMix, 1, GetHashKey('rm_mix'), 0.2)
        SetAudioSubmixEffectParamFloat(MegaphoneSubMix, 1, GetHashKey('fudge'), 0.0)
        SetAudioSubmixEffectParamFloat(MegaphoneSubMix, 1, GetHashKey('o_freq_lo'), 200.0)
        SetAudioSubmixEffectParamFloat(MegaphoneSubMix, 1, GetHashKey('o_freq_hi'), 5000.0)
        AddAudioSubmixOutput(MegaphoneSubMix, 1)
    end
    if Config.EnablePhone then
        PhoneSubmix = CreateAudioSubmix('Phone')
        SetAudioSubmixEffectRadioFx(PhoneSubmix, 1)
        SetAudioSubmixEffectParamInt(PhoneSubmix, 1, GetHashKey('default'), 1)
        SetAudioSubmixEffectParamFloat(PhoneSubmix, 1, GetHashKey('freq_low'), 100.0)
        SetAudioSubmixEffectParamFloat(PhoneSubmix, 1, GetHashKey('freq_hi'), 10000.0)
        SetAudioSubmixEffectParamFloat(PhoneSubmix, 1, GetHashKey('rm_mod_freq'), 0.0)
        SetAudioSubmixEffectParamFloat(PhoneSubmix, 1, GetHashKey('rm_mix'), 0.10)
        SetAudioSubmixEffectParamFloat(PhoneSubmix, 1, GetHashKey('fudge'), 1.0)
        SetAudioSubmixEffectParamFloat(PhoneSubmix, 1, GetHashKey('o_freq_lo'), 100.0)
        SetAudioSubmixEffectParamFloat(PhoneSubmix, 1, GetHashKey('o_freq_hi'), 10000.0)
        AddAudioSubmixOutput(PhoneSubmix, 1)
    end
    if Config.EnableGag then
        RegisterModuleContext("Gag", 1)
        UpdateContextVolume("Gag", -1.0)
        GagSubmix = CreateAudioSubmix('Gag')
        SetAudioSubmixEffectRadioFx(GagSubmix, 1)
        SetAudioSubmixEffectParamInt(GagSubmix, 1, GetHashKey('default'), 1)
        SetAudioSubmixEffectParamFloat(GagSubmix, 1, GetHashKey('freq_low'), 10.0)
        SetAudioSubmixEffectParamFloat(GagSubmix, 1, GetHashKey('freq_hi'), 275.0)
        SetAudioSubmixEffectParamFloat(GagSubmix, 1, GetHashKey('rm_mod_freq'), 300.0)
        SetAudioSubmixEffectParamFloat(GagSubmix, 1, GetHashKey('rm_mix'), 0.1)
        SetAudioSubmixEffectParamFloat(GagSubmix, 1, GetHashKey('fudge'), 0.5)
        SetAudioSubmixEffectParamFloat(GagSubmix, 1, GetHashKey('o_freq_lo'), 10.0)
        SetAudioSubmixEffectParamFloat(GagSubmix, 1, GetHashKey('o_freq_hi'), 275.0)
        AddAudioSubmixOutput(GagSubmix, 1)
    end
    if Config.EnablePodium then
        RegisterModuleContext("Podium", 1)
        UpdateContextVolume("Podium", -1.0)
        PodiumSubmix = CreateAudioSubmix('Podium')
        SetAudioSubmixEffectRadioFx(PodiumSubmix, 1)
        SetAudioSubmixEffectParamInt(PodiumSubmix, 1, GetHashKey('default'), 1)
        SetAudioSubmixEffectParamFloat(PodiumSubmix, 1, GetHashKey('freq_low'), 50.0)
        SetAudioSubmixEffectParamFloat(PodiumSubmix, 1, GetHashKey('freq_hi'), 10000.0)
        SetAudioSubmixEffectParamFloat(PodiumSubmix, 1, GetHashKey('rm_mod_freq'), 300.0)
        SetAudioSubmixEffectParamFloat(PodiumSubmix, 1, GetHashKey('rm_mix'), 0.05)
        SetAudioSubmixEffectParamFloat(PodiumSubmix, 1, GetHashKey('fudge'), 1.0)
        SetAudioSubmixEffectParamFloat(PodiumSubmix, 1, GetHashKey('o_freq_lo'), 50.0)
        SetAudioSubmixEffectParamFloat(PodiumSubmix, 1, GetHashKey('o_freq_hi'), 6000.0)
        AddAudioSubmixOutput(PodiumSubmix, 1)
    end
    if Config.EnableRadio then
        RadioSubmixFar = CreateAudioSubmix('RadioF')
        SetAudioSubmixEffectRadioFx(RadioSubmixFar, 1)
        SetAudioSubmixEffectParamInt(RadioSubmixFar, 1, GetHashKey('default'), 1)
        SetAudioSubmixEffectParamFloat(RadioSubmixFar, 1, GetHashKey('freq_low'), 100.0)
        SetAudioSubmixEffectParamFloat(RadioSubmixFar, 1, GetHashKey('freq_hi'), 5000.0)
        SetAudioSubmixEffectParamFloat(RadioSubmixFar, 1, GetHashKey('rm_mod_freq'), 300.0)
        SetAudioSubmixEffectParamFloat(RadioSubmixFar, 1, GetHashKey('rm_mix'), 0.8)
        SetAudioSubmixEffectParamFloat(RadioSubmixFar, 1, GetHashKey('fudge'), 16.0)
        SetAudioSubmixEffectParamFloat(RadioSubmixFar, 1, GetHashKey('o_freq_lo'), 300.0)
        SetAudioSubmixEffectParamFloat(RadioSubmixFar, 1, GetHashKey('o_freq_hi'), 5000.0)
        AddAudioSubmixOutput(RadioSubmixFar, 1)

        RadioSubmixMedium = CreateAudioSubmix('RadioM')
        SetAudioSubmixEffectRadioFx(RadioSubmixMedium, 1)
        SetAudioSubmixEffectParamInt(RadioSubmixMedium, 1, GetHashKey('default'), 1)
        SetAudioSubmixEffectParamFloat(RadioSubmixMedium, 1, GetHashKey('freq_low'), 100.0)
        SetAudioSubmixEffectParamFloat(RadioSubmixMedium, 1, GetHashKey('freq_hi'), 5000.0)
        SetAudioSubmixEffectParamFloat(RadioSubmixMedium, 1, GetHashKey('rm_mod_freq'), 300.0)
        SetAudioSubmixEffectParamFloat(RadioSubmixMedium, 1, GetHashKey('rm_mix'), 0.5)
        SetAudioSubmixEffectParamFloat(RadioSubmixMedium, 1, GetHashKey('fudge'), 10.0)
        SetAudioSubmixEffectParamFloat(RadioSubmixMedium, 1, GetHashKey('o_freq_lo'), 300.0)
        SetAudioSubmixEffectParamFloat(RadioSubmixMedium, 1, GetHashKey('o_freq_hi'), 5000.0)
        AddAudioSubmixOutput(RadioSubmixMedium, 1)

        RadioSubmix = CreateAudioSubmix('RadioN')
        SetAudioSubmixEffectRadioFx(RadioSubmix, 1)
        SetAudioSubmixEffectParamInt(RadioSubmix, 1, GetHashKey('default'), 1)
        SetAudioSubmixEffectParamFloat(RadioSubmix, 1, GetHashKey('freq_low'), 100.0)
        SetAudioSubmixEffectParamFloat(RadioSubmix, 1, GetHashKey('freq_hi'), 5000.0)
        SetAudioSubmixEffectParamFloat(RadioSubmix, 1, GetHashKey('rm_mod_freq'), 300.0)
        SetAudioSubmixEffectParamFloat(RadioSubmix, 1, GetHashKey('rm_mix'), 0.1)
        SetAudioSubmixEffectParamFloat(RadioSubmix, 1, GetHashKey('fudge'), 4.0)
        SetAudioSubmixEffectParamFloat(RadioSubmix, 1, GetHashKey('o_freq_lo'), 300.0)
        SetAudioSubmixEffectParamFloat(RadioSubmix, 1, GetHashKey('o_freq_hi'), 5000.0)
        AddAudioSubmixOutput(RadioSubmix, 1)
    end
end

function SetPlayerVoiceFilter(Source, Filter)
    if Filter == 'Megaphone' then
        if MegaphoneSubMix ~= nil then
            MumbleSetSubmixForServerId(Source, MegaphoneSubMix)
        end
    elseif Filter == 'Radio-Medium' then
        if RadioSubmixMedium ~= nil then
            MumbleSetSubmixForServerId(Source, RadioSubmixMedium)
        end
    elseif Filter == 'Radio-Far' then
        if RadioSubmixFar ~= nil then
            MumbleSetSubmixForServerId(Source, RadioSubmixFar)
        end
    elseif Filter == 'Default' then
        if RadioSubmix ~= nil then
            MumbleSetSubmixForServerId(Source, RadioSubmix)
        end
    elseif Filter == 'Gag' then
        if GagSubmix ~= nil then
            MumbleSetSubmixForServerId(Source, GagSubmix)
        end
    elseif Filter == 'Podium' then
        if PodiumSubmix ~= nil then
            MumbleSetSubmixForServerId(Source, PodiumSubmix)
        end
    elseif Filter == 'Phone' then
        if PhoneSubmix ~= nil then
            MumbleSetSubmixForServerId(Source, PhoneSubmix)
        end
    end
end

function ResetPlayerVoiceFilter(Source)
    MumbleSetSubmixForServerId(Source, -1)
end