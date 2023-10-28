ReturnCallback = nil

local KeyToCode = { ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164 }
local DoingTask, NeededStreak, CurrentStreak, GlobalReverse = false, 3, 0, false
local Colors = {
    BgColor = { 
        Red = 37, 
        Green = 50, 
        Blue = 56 
    },
    HudColor = { 
        Red = 0, 
        Green = 150, 
        Blue = 136 
    },
    CursorColor = { 
        Red = 220, 
        Green = 0, 
        Blue = 0 
    }
}

RegisterNetEvent('mercy-ui/client/ui-reset', function()
    if not DoingTask then return end

    DoingTask, CurrentStreak, NeededStreak = false, 0, 3
    exports['mercy-inventory']:SetBusyState(false)
    Colors = { BgColor = { Red = 37, Green = 50, Blue = 56 }, HudColor = { Red = 0, Green = 150, Blue = 136 }, CursorColor = { Red = 220, Green = 0, Blue = 0 }}
end)

-- [ Functions ] --

function StartSkillTest(NeededStreak, SkillGap, ReqSpeed, Reverse)
    if DoingTask then return end
    if CurrentStreak == 0 then GlobalReverse = Reverse end
    RequestStreamedTextureDict("mercy_sprites")

    local Prom = promise:new()

    BuildSkillTest(NeededStreak, SkillGap, ReqSpeed, Reverse, function(Result)
        Prom:resolve(Result)
    end)

    return Citizen.Await(Prom)
end
exports('StartSkillTest', StartSkillTest)

function BuildSkillTest(NeededStreak, SkillGap, ReqSpeed, Reverse, Callback)
    DoingTask, ReturnCallback = true, Callback
    exports['mercy-inventory']:SetBusyState(true)
    RequestStreamedTextureDict("mercy_sprites")
    while not HasStreamedTextureDictLoaded("mercy_sprites") do
        Citizen.Wait(0)
    end
    
    local MinigameResult = false
    local SkillGapSent = math.random(SkillGap[1], SkillGap[2])
    local KeyToPress = tostring(math.random(1, 4))
    local MoveCursor, CursorRot = true, 0
    local OriginX, OriginY = 0.5, 0.565
    local Duration, SkillTick = 10000, 0
    local Speed = (100.0 / math.random(ReqSpeed[1], ReqSpeed[2]))
    
    local SpriteW, SpriteH = 128.0 / 1920.0, 128.0 / 1080.0
    local TargetBuffer, SkillHandicap = 6.0, 2
    local TargetRotation = math.random(120,240) + 0.0
    local _, SpriteGap = SkillToSprite(SkillGapSent)
    local TargetGap = ((360 / 128) * math.floor((SpriteGap / 128) * 100)) + TargetRotation + TargetBuffer
    local DidPass = TargetRotation + TargetBuffer <= (SkillTick < 0 and 360 - SkillTick or SkillTick)

    local Timer = GetGameTimer()
    while DoingTask do
        local Delta = GetGameTimer() - Timer
        Timer = GetGameTimer()
    
        for i = 8, 32 do
            DisableControlAction(0, i, true)
        end
        for i = 140, 143 do
            DisableControlAction(0, i, true)
        end
    
        SkillTick = MoveCursor and SkillTick + (Delta * Speed * (Reverse and -1 or 1)) or SkillTick
        CursorRot = SkillTick / 100 * 360
    
        DrawKey(OriginX, OriginY, KeyToPress)
        SetScriptGfxDrawOrder(7)

        DrawSprite("mercy_sprites", "circle_128", OriginX, OriginY + (SpriteH / 3), SpriteW, SpriteH, 0, Colors.BgColor.Red, Colors.BgColor.Green, Colors.BgColor.Blue, 255)
        SetScriptGfxDrawOrder(9)

        DrawSprite("mercy_sprites", SkillToSprite(SkillGapSent), OriginX, OriginY + (SpriteH / 3.0), SpriteW, SpriteH, TargetRotation, Colors.HudColor.Red, Colors.HudColor.Green, Colors.HudColor.Blue, 255)
        SetScriptGfxDrawOrder(8)

        DrawSprite("mercy_sprites", "cursor_128", OriginX, OriginY + (SpriteH / 3), SpriteW, SpriteH, CursorRot, Colors.CursorColor.Red, Colors.CursorColor.Green, Colors.CursorColor.Blue, 255)
        SetScriptGfxDrawOrder(1)
    
        for k, v in pairs(KeyToCode) do
            if MoveCursor and IsDisabledControlJustPressed(0, v) then
                local CursorPos = (CursorRot < 0 and 360 + CursorRot or CursorRot)
                if k == KeyToPress and CursorPos >= (TargetRotation + TargetBuffer) and CursorPos <= (TargetGap + SkillHandicap) then
                    Colors.HudColor = { Red = 0, Green = 255, Blue = 0 }
                    MinigameResult, CurrentStreak = true, CurrentStreak + 1
                else
                    Colors.HudColor = { Red = 255, Green = 0, Blue = 0 }
                end
                MoveCursor = false
                Citizen.SetTimeout(250, function()
                    DoingTask = false
                end)
            end
        end
    
        if IsDisabledControlJustPressed(0, 200) then
            DoingTask = false
        end

        if (not Reverse and SkillTick >= 100 and not DidPass) or (Reverse and SkillTick <= -100 and not DidPass) then
            DoingTask = false
        end
        if (SkillTick >= 100 and not DidPass) then
            DoingTask = false
        end
        if SkillTick > 100 or SkillTick < -100 then
            DidPass, SkillTick = false, 0
        end
        if IsPedRagdoll(PlayerPedId()) then
            DoingTask = false
        end
        Citizen.Wait(0)
    end

    Citizen.SetTimeout(500, function()
        if not DoingTask then
            SetStreamedTextureDictAsNoLongerNeeded('mercy_sprites')
        end
    end)

    Colors = { BgColor = { Red = 37, Green = 50, Blue = 56 }, HudColor = { Red = 0, Green = 150, Blue = 136 }, CursorColor = { Red = 220, Green = 0, Blue = 0 }}

    if (not MinigameResult or CurrentStreak == NeededStreak) then
        exports['mercy-inventory']:SetBusyState(false)
        CurrentStreak, NeededStreak, GlobalReverse = 0, 3, false
        ReturnCallback(MinigameResult)
    else
        Citizen.SetTimeout(250, function()
            if GlobalReverse then Reverse = not Reverse end
            BuildSkillTest(NeededStreak, SkillGap, ReqSpeed, Reverse, ReturnCallback)
        end)
    end
end

function SkillToSprite(Skill)
    if Skill <= 5 then return "skill_5", 7 end
    if Skill <= 7 then return "skill_7", 10 end
    if Skill <= 10 then return "skill_10", 13 end
    if Skill <= 12 then return "skill_12", 15 end
    if Skill <= 15 then return "skill_15", 18 end
    if Skill <= 17 then return "skill_17", 20 end
    if Skill <= 20 then return "skill_20", 25 end
    if Skill > 20 then return "skill_25", 30 end
    if Skill >= 30 then return "skill_30", 40 end
end

function DrawKey(OriginX, OriginY, KeyToPress)
    SetTextColour(255, 255, 255, 255)
    SetTextScale(0.0, 1.25)
    SetTextDropshadow(10, 0, 0, 0, 255)
    SetTextOutline()
    SetTextFont(4)
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentSubstringPlayerName(KeyToPress)
    EndTextCommandDisplayText(OriginX, OriginY)
end