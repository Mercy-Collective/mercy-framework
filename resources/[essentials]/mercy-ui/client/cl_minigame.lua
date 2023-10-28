local Minigames = {}

-- [ Functions ] --

function StartMemoryMinigame(Cb)
    Minigames.MemoryCallback = Cb
    SendUIMessage("Minigames", "StartMemoryMinigame", {})
    SetNuiFocus(true, true)
end
exports("MemoryMinigame", StartMemoryMinigame)

function StartColorMinigame(Cb)
    Minigames.ColorCallback = Cb
    SendUIMessage("Minigames", "StartColorMinigame", {})
    SetNuiFocus(true, true)
end
exports("ColorMinigame", StartColorMinigame)

function StartFigureMinigame(IconsAmount, ResponseTime, Cb)
    Minigames.FigureCallback = Cb
    SendUIMessage("Minigames", "StartFigureMinigame", {
        ResponseTime = ResponseTime,
        IconsAmount = IconsAmount
    })
    SetNuiFocus(true, true)
end
exports("FigureMinigame", StartFigureMinigame)

function StartBoostingMinigame(Cb)
    Minigames.BoostingCallback = Cb
    SendUIMessage("Minigames", "StartBoostingMinigame", {})
    SetNuiFocus(true, true)
end
exports("BoostingMinigame", StartBoostingMinigame)

-- [ NUI Callbacks ] --

RegisterNUICallback('Minigame/Memory/Outcome', function(Data, Cb)
    SetNuiFocus(false, false)
    if Minigames.MemoryCallback then Minigames.MemoryCallback(Data.Outcome) end
    Minigames.MemoryCallback = nil
    Cb('Ok')
end)

RegisterNUICallback('Minigame/Color/Outcome', function(Data, Cb)
    SetNuiFocus(false, false)
    if Minigames.ColorCallback then Minigames.ColorCallback(Data.Outcome) end
    Minigames.ColorCallback = nil
    Cb('Ok')
end)

RegisterNUICallback('Minigames/Figure/Outcome', function(Data, Cb)
    SetNuiFocus(false, false)
    if Minigames.FigureCallback then Minigames.FigureCallback(Data.Outcome) end
    Minigames.FigureCallback = nil
    Cb('Ok')
end)

RegisterNUICallback('Minigames/Boosting/Outcome', function(Data, Cb)
    SetNuiFocus(false, false)
    if Minigames.BoostingCallback then Minigames.BoostingCallback(Data.Outcome) end
    Minigames.BoostingCallback = nil
    Cb('Ok')
end)


-- [ Events ] --

RegisterNetEvent('mercy-ui/client/ui-reset', function()
    if Minigames.MemoryCallback ~= nil then Minigames.MemoryCallback(false) end
    if Minigames.ColorCallback ~= nil then Minigames.ColorCallback(false) end
    if Minigames.FigureCallback ~= nil then Minigames.FigureCallback(false) end
    if Minigames.BoostingCallback ~= nil then Minigames.BoostingCallback(false) end
    exports['mercy-ui']:SendUIMessage("Minigames", "HideAll")
end)

-- Drill

Scaleforms = Scaleforms()

Drilling = {}

Drilling.DisabledControls = {30,31,32,33,34,35}

Drilling.Start = function(callback)
    RequestScriptAudioBank("DLC_HEIST_FLEECA_SOUNDSET", false, -1)
    while not RequestScriptAudioBank("DLC_HEIST_FLEECA_SOUNDSET", false, -1) do
        Citizen.Wait("Waiting for DLC_HEIST_FLEECA_SOUNDSET")
    end
        RequestScriptAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL", false, -1)
    while not RequestScriptAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL", false, -1) do
        Citizen.Wait("Waiting for DLC_MPHEIST\\HEIST_FLEECA_DRILL")
    end
        RequestScriptAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2", false, -1)
    while not RequestScriptAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2", false, -1) do
        Citizen.Wait("Waiting for DLC_MPHEIST\\HEIST_FLEECA_DRILL_2")
    end

    if not Drilling.Active then
        Drilling.SoundActive = false
        Drilling.SoundId = GetSoundId()
        Drilling.Active = true
        Drilling.Init()
        Drilling.Update(callback)
    end
end

Drilling.Init = function()
    if Drilling.Scaleform then
        Scaleforms.UnloadMovie(Drilling.Scaleform)
    end

    Drilling.Scaleform = Scaleforms.LoadMovie("DRILLING")

    
    Drilling.DrillSpeed = 0.0
    Drilling.DrillPos   = 0.0
    Drilling.DrillTemp  = 0.0
    Drilling.HoleDepth  = 0.0
    

    Scaleforms.PopFloat(Drilling.Scaleform,"SET_SPEED",           0.0)
    Scaleforms.PopFloat(Drilling.Scaleform,"SET_DRILL_POSITION",  0.0)
    Scaleforms.PopFloat(Drilling.Scaleform,"SET_TEMPERATURE",     0.0)
    Scaleforms.PopFloat(Drilling.Scaleform,"SET_HOLE_DEPTH",      0.0)
end

Drilling.Update = function(callback)
    while Drilling.Active do
        Drilling.Draw()
        Drilling.DisableControls()
        Drilling.HandleControls()

        -- if Drilling.DrillSpeed > 0 and not Drilling.SoundActive then
        --     Drilling.SoundActive = true
        --     PlaySoundFromEntity(Drilling.SoundId, "Drill", PlayerPedId(), "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
        --   elseif Drilling.DrillSpeed <= 0 and Drilling.SoundActive then
        --     StopSound(Drilling.SoundId)
        --     Drilling.SoundActive = false
        -- end

        Wait(0)
    end
    callback(Drilling.Result)
end

Drilling.Draw = function()
    DrawScaleformMovieFullscreen(Drilling.Scaleform,255,255,255,255,255)
end

Drilling.HandleControls = function()
    local last_pos = Drilling.DrillPos
    if IsControlJustPressed(0,172) then
        Drilling.DrillPos = math.min(1.0,Drilling.DrillPos + 0.01)
    elseif IsControlPressed(0,172) then
        Drilling.DrillPos = math.min(1.0,Drilling.DrillPos + (0.1 * GetFrameTime() / (math.max(0.1,Drilling.DrillTemp) * 10)))
    elseif IsControlJustPressed(0,173) then
        Drilling.DrillPos = math.max(0.0,Drilling.DrillPos - 0.01)
    elseif IsControlPressed(0,173) then
        Drilling.DrillPos = math.max(0.0,Drilling.DrillPos - (0.1 * GetFrameTime()))
    end

    local last_speed = Drilling.DrillSpeed
    if IsControlJustPressed(0,175) then
        Drilling.DrillSpeed = math.min(1.0,Drilling.DrillSpeed + 0.05)
    elseif IsControlPressed(0,175) then
        Drilling.DrillSpeed = math.min(1.0,Drilling.DrillSpeed + (0.5 * GetFrameTime()))
    elseif IsControlJustPressed(0,174) then
        Drilling.DrillSpeed = math.max(0.0,Drilling.DrillSpeed - 0.05)
    elseif IsControlPressed(0,174) then
        Drilling.DrillSpeed = math.max(0.0,Drilling.DrillSpeed - (0.5 * GetFrameTime()))
    end

    if IsControlJustPressed(0, 322) then
        Drilling.Result = false
        Drilling.Active = false
    end

    local last_temp = Drilling.DrillTemp
    if last_pos < Drilling.DrillPos then
        if Drilling.DrillSpeed > 0.4 then
        Drilling.DrillTemp = math.min(1.0,Drilling.DrillTemp + ((0.05 * GetFrameTime()) *  (Drilling.DrillSpeed * 10)))
        Scaleforms.PopFloat(Drilling.Scaleform,"SET_DRILL_POSITION",Drilling.DrillPos)
        else
        if Drilling.DrillPos < 0.1 or Drilling.DrillPos < Drilling.HoleDepth then
            Scaleforms.PopFloat(Drilling.Scaleform,"SET_DRILL_POSITION",Drilling.DrillPos)
        else
            Drilling.DrillPos = last_pos
            Drilling.DrillTemp = math.min(1.0,Drilling.DrillTemp + (0.01 * GetFrameTime()))
        end
        end
    else
        if Drilling.DrillPos < Drilling.HoleDepth then
        Drilling.DrillTemp = math.max(0.0,Drilling.DrillTemp - ( (0.05 * GetFrameTime()) *  math.max(0.005,(Drilling.DrillSpeed * 10) /2)) )
        end

        if Drilling.DrillPos ~= Drilling.HoleDepth then
        Scaleforms.PopFloat(Drilling.Scaleform,"SET_DRILL_POSITION",Drilling.DrillPos)
        end
    end

    if last_speed ~= Drilling.DrillSpeed then
        Scaleforms.PopFloat(Drilling.Scaleform,"SET_SPEED",Drilling.DrillSpeed)
    end

    if last_temp ~= Drilling.DrillTemp then    
        Scaleforms.PopFloat(Drilling.Scaleform,"SET_TEMPERATURE",Drilling.DrillTemp)
    end

    if not Drilling.SoundActive and (Drilling.DrillPos >= 0.29 and Drilling.DrillPos <= 0.305 or Drilling.DrillPos >= 0.50 and Drilling.DrillPos <= 0.51 or Drilling.DrillPos >= 0.62 and Drilling.DrillPos <= 0.63 or Drilling.DrillPos >= 0.78 and Drilling.DrillPos <= 0.79) then
        Drilling.SoundActive = true
        PlaySoundFrontend(-1, "Drill_Pin_Break", "DLC_HEIST_FLEECA_SOUNDSET", 1);

        Citizen.SetTimeout(1000, function()
        Drilling.SoundActive = false
        end)
    end

    if Drilling.DrillTemp >= 1.0 then
        Drilling.Result = false
        Drilling.Active = false
    elseif Drilling.DrillPos >= 1.0 then
        Drilling.Result = true
        Drilling.Active = false
    end

    Drilling.HoleDepth = (Drilling.DrillPos > Drilling.HoleDepth and Drilling.DrillPos or Drilling.HoleDepth)
end

Drilling.DisableControls = function()
    for _,control in ipairs(Drilling.DisabledControls) do
        DisableControlAction(0,control,true)
    end
end

Drilling.EnableControls = function()
    for _,control in ipairs(Drilling.DisabledControls) do
        DisableControlAction(0,control,true)
    end
end

function StartDrilling(callback)
    if not Drilling.Active then
      Drilling.Active = true
      Drilling.Init()
      Drilling.Update(callback)
    end
end
exports('StartDrilling', StartDrilling)