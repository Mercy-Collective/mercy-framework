function DrawAdvancedNativeText(x, y, w, h, sc, text, r, g, b, a, font, jus)
    SetTextFont(font)
    SetTextScale(sc, sc)
    N_0x4e096588b13ffeca(jus)
    SetTextColour(254, 254, 254, 255)
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(x - 0.1 + w, y - 0.02 + h)
end

function ShowHelpNotification(msg)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function DrawNativeNotification(text)
    SetTextComponentFormat('STRING')
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function SetRandomPedVoice(RandomNumber, DealerPed)
    if RandomNumber == 0 then
        SetPedVoiceGroup(DealerPed, GetHashKey('S_M_Y_Casino_01_WHITE_01'))
    elseif RandomNumber == 1 then
        SetPedVoiceGroup(DealerPed, GetHashKey('S_M_Y_Casino_01_ASIAN_01'))
    elseif RandomNumber == 2 then
        SetPedVoiceGroup(DealerPed, GetHashKey('S_M_Y_Casino_01_ASIAN_02'))
    elseif RandomNumber == 3 then
        SetPedVoiceGroup(DealerPed, GetHashKey('S_M_Y_Casino_01_ASIAN_01'))
    elseif RandomNumber == 4 then
        SetPedVoiceGroup(DealerPed, GetHashKey('S_M_Y_Casino_01_WHITE_01'))
    elseif RandomNumber == 5 then
        SetPedVoiceGroup(DealerPed, GetHashKey('S_M_Y_Casino_01_WHITE_02'))
    elseif RandomNumber == 6 then
        SetPedVoiceGroup(DealerPed, GetHashKey('S_M_Y_Casino_01_WHITE_01'))
    elseif RandomNumber == 7 then
        SetPedVoiceGroup(DealerPed, GetHashKey('S_F_Y_Casino_01_ASIAN_01'))
    elseif RandomNumber == 8 then
        SetPedVoiceGroup(DealerPed, GetHashKey('S_F_Y_Casino_01_ASIAN_02'))
    elseif RandomNumber == 9 then
        SetPedVoiceGroup(DealerPed, GetHashKey('S_F_Y_Casino_01_ASIAN_01'))
    elseif RandomNumber == 10 then
        SetPedVoiceGroup(DealerPed, GetHashKey('S_F_Y_Casino_01_ASIAN_02'))
    elseif RandomNumber == 11 then
        SetPedVoiceGroup(DealerPed, GetHashKey('S_F_Y_Casino_01_LATINA_01'))
    elseif RandomNumber == 12 then
        SetPedVoiceGroup(DealerPed, GetHashKey('S_F_Y_Casino_01_LATINA_02'))
    elseif RandomNumber == 13 then
        SetPedVoiceGroup(DealerPed, GetHashKey('S_F_Y_Casino_01_LATINA_01'))
    end
end

function SetRandomPedClothes(RandomNumber, DealerPed)
    if RandomNumber == 0 then
        SetPedDefaultComponentVariation(DealerPed)
        SetPedComponentVariation(DealerPed, 0, 3, 0, 0)
        SetPedComponentVariation(DealerPed, 1, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 2, 3, 0, 0)
        SetPedComponentVariation(DealerPed, 3, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(DealerPed, 8, 3, 0, 0)
        SetPedComponentVariation(DealerPed, 10, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 11, 1, 0, 0)
    elseif RandomNumber == 1 then
        SetPedDefaultComponentVariation(DealerPed)
        SetPedComponentVariation(DealerPed, 0, 2, 2, 0)
        SetPedComponentVariation(DealerPed, 1, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 2, 4, 0, 0)
        SetPedComponentVariation(DealerPed, 3, 0, 3, 0)
        SetPedComponentVariation(DealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(DealerPed, 8, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 10, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 11, 1, 0, 0)
    elseif RandomNumber == 2 then
        SetPedDefaultComponentVariation(DealerPed)
        SetPedComponentVariation(DealerPed, 0, 2, 1, 0)
        SetPedComponentVariation(DealerPed, 1, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 2, 2, 0, 0)
        SetPedComponentVariation(DealerPed, 3, 0, 3, 0)
        SetPedComponentVariation(DealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(DealerPed, 8, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 10, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 11, 1, 0, 0)
    elseif RandomNumber == 3 then
        SetPedDefaultComponentVariation(DealerPed)
        SetPedComponentVariation(DealerPed, 0, 2, 0, 0)
        SetPedComponentVariation(DealerPed, 1, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 2, 3, 0, 0)
        SetPedComponentVariation(DealerPed, 3, 1, 3, 0)
        SetPedComponentVariation(DealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(DealerPed, 8, 3, 0, 0)
        SetPedComponentVariation(DealerPed, 10, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 11, 1, 0, 0)
    elseif RandomNumber == 4 then
        SetPedDefaultComponentVariation(DealerPed)
        SetPedComponentVariation(DealerPed, 0, 4, 2, 0)
        SetPedComponentVariation(DealerPed, 1, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 2, 3, 0, 0)
        SetPedComponentVariation(DealerPed, 3, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(DealerPed, 8, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 10, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 11, 1, 0, 0)
    elseif RandomNumber == 5 then
        SetPedDefaultComponentVariation(DealerPed)
        SetPedComponentVariation(DealerPed, 0, 4, 0, 0)
        SetPedComponentVariation(DealerPed, 1, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 2, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 3, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(DealerPed, 8, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 10, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 11, 1, 0, 0)
    elseif RandomNumber == 6 then
        SetPedDefaultComponentVariation(DealerPed)
        SetPedComponentVariation(DealerPed, 0, 4, 1, 0)
        SetPedComponentVariation(DealerPed, 1, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 2, 4, 0, 0)
        SetPedComponentVariation(DealerPed, 3, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(DealerPed, 8, 3, 0, 0)
        SetPedComponentVariation(DealerPed, 10, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 11, 1, 0, 0)
    elseif RandomNumber == 7 then
        SetPedDefaultComponentVariation(DealerPed)
        SetPedComponentVariation(DealerPed, 0, 1, 1, 0)
        SetPedComponentVariation(DealerPed, 1, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 2, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 3, 0, 3, 0)
        SetPedComponentVariation(DealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 6, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 7, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 8, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 10, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 11, 0, 0, 0)
    elseif RandomNumber == 8 then
        SetPedDefaultComponentVariation(DealerPed)
        SetPedComponentVariation(DealerPed, 0, 1, 1, 0)
        SetPedComponentVariation(DealerPed, 1, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 2, 1, 1, 0)
        SetPedComponentVariation(DealerPed, 3, 1, 3, 0)
        SetPedComponentVariation(DealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 6, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(DealerPed, 8, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 10, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 11, 0, 0, 0)
    elseif RandomNumber == 9 then
        SetPedDefaultComponentVariation(DealerPed)
        SetPedComponentVariation(DealerPed, 0, 2, 0, 0)
        SetPedComponentVariation(DealerPed, 1, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 2, 2, 0, 0)
        SetPedComponentVariation(DealerPed, 3, 2, 3, 0)
        SetPedComponentVariation(DealerPed, 4, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 6, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 7, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 8, 2, 0, 0)
        SetPedComponentVariation(DealerPed, 10, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 11, 0, 0, 0)
    elseif RandomNumber == 10 then
        SetPedDefaultComponentVariation(DealerPed)
        SetPedComponentVariation(DealerPed, 0, 2, 1, 0)
        SetPedComponentVariation(DealerPed, 1, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 2, 2, 1, 0)
        SetPedComponentVariation(DealerPed, 3, 3, 3, 0)
        SetPedComponentVariation(DealerPed, 4, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(DealerPed, 8, 3, 0, 0)
        SetPedComponentVariation(DealerPed, 10, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 11, 0, 0, 0)
    elseif RandomNumber == 11 then
        SetPedDefaultComponentVariation(DealerPed)
        SetPedComponentVariation(DealerPed, 0, 3, 0, 0)
        SetPedComponentVariation(DealerPed, 1, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 2, 3, 0, 0)
        SetPedComponentVariation(DealerPed, 3, 0, 1, 0)
        SetPedComponentVariation(DealerPed, 4, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 7, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 8, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 10, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 11, 0, 0, 0)
        SetPedPropIndex(DealerPed, 1, 0, 0, false)
    elseif RandomNumber == 12 then
        SetPedDefaultComponentVariation(DealerPed)
        SetPedComponentVariation(DealerPed, 0, 3, 1, 0)
        SetPedComponentVariation(DealerPed, 1, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 2, 3, 1, 0)
        SetPedComponentVariation(DealerPed, 3, 1, 1, 0)
        SetPedComponentVariation(DealerPed, 4, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 7, 2, 0, 0)
        SetPedComponentVariation(DealerPed, 8, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 10, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 11, 0, 0, 0)
    elseif RandomNumber == 13 then
        SetPedDefaultComponentVariation(DealerPed)
        SetPedComponentVariation(DealerPed, 0, 4, 0, 0)
        SetPedComponentVariation(DealerPed, 1, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 2, 4, 0, 0)
        SetPedComponentVariation(DealerPed, 3, 2, 1, 0)
        SetPedComponentVariation(DealerPed, 4, 1, 0, 0) 
        SetPedComponentVariation(DealerPed, 6, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 7, 1, 0, 0)
        SetPedComponentVariation(DealerPed, 8, 2, 0, 0)
        SetPedComponentVariation(DealerPed, 10, 0, 0, 0)
        SetPedComponentVariation(DealerPed, 11, 0, 0, 0)
        SetPedPropIndex(DealerPed, 1, 0, 0, false)
    end
end

function GetBetAmount()
    local Data = {{Name = 'amount', Label = 'Bet Amount', Icon = 'fas fa-dollar-sign'}}
    local BetInput = exports['mercy-ui']:CreateInput(Data)
    if BetInput['amount'] then
        local Amount = tonumber(BetInput['amount'])
        if Amount and Amount > 0 then
            return Amount
        else
            exports['mercy-ui']:Notify('invalid-chips-am', "Invalid amount of chips..", 'error')
        end
    end
	return false
end

function DrawTimerBar2(title, text, barIndex)
	local width = 0.13
	local hTextMargin = 0.003
	local rectHeight = 0.038
	local textMargin = 0.008
	
	local rectX = GetSafeZoneSize() - width + width / 2
	local rectY = GetSafeZoneSize() - rectHeight + rectHeight / 2 - (barIndex - 1) * (rectHeight + 0.005)
	
	DrawSprite("timerbars", "all_black_bg", rectX, rectY, width, 0.038, 0, 0, 0, 0, 128)
	
	DrawTimerBarText(title, GetSafeZoneSize() - width + hTextMargin, rectY - textMargin, 0.32)
	DrawTimerBarText(string.upper(text), GetSafeZoneSize() - hTextMargin, rectY - 0.0175, 0.5, true, width / 2)
end

function DrawNoiseBar(noise, barIndex)
	DrawTimerBar2("NOISE", math.floor(noise), barIndex)
end

function DrawTimerBarText(text, x, y, scale, right, width)
	SetTextFont(0)
	SetTextScale(scale, scale)
	SetTextColour(254, 254, 254, 255)

	if right then
		SetTextWrap(x - width, x)
		SetTextRightJustify(true)
	end
	
	BeginTextCommandDisplayText("STRING")	
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(x, y)
end

function DrawAdvancedNativeText(x,y,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
    SetTextColour(254, 254, 254, 255)
    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end

function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function Button(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end