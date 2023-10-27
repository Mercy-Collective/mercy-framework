PlayingAnim, PlayingAnimData, EmoteMenuOpen, FunctionsModule = false, {}, false, nil

AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
		'Functions',
    }, function(Succeeded)
        if not Succeeded then return end
		FunctionsModule = exports['mercy-base']:FetchModule('Functions')
    end)
end)

RegisterNetEvent('mercy-base/client/on-login', function()
	Citizen.SetTimeout(450, function()
        InitChairs()
	end)
end)

RegisterNetEvent('mercy-base/client/on-logout', function()
    PlayingAnim, PlayingAnimData = false, {}
    EmoteMenuOpen = false
end)

-- Code

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn and PlayingAnim then
            if IsControlJustReleased(0, 73) then
                TriggerEvent('mercy-animations/client/clear-animation')
            end
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn and EmoteMenuOpen then
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisablePlayerFiring(PlayerId(), true)
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2)
        if LocalPlayer.state.LoggedIn and EmoteMenuOpen then
            if Menu.IsMenuOpened('EmoteMenu') then
                if Menu.MenuButton('~r~Clear Current Emote~s~', 'EmoteMenu', false) then
                    TriggerEvent('mercy-animations/client/clear-animation')
                end
                for k, v in pairs(Config.Animations) do
                    if not v.Hidden and Menu.MenuButton(v.Name, 'EmoteMenu', false, {Emote = v.Id}) then
                        local CurrentOption = Menu.GetCurrentButton()
                        CurrentEmote = CurrentOption.meta.Emote
                        TriggerEvent('mercy-animations/client/play-animation', CurrentEmote)
                    end
                end
                Menu.Display()
            end 
            if Menu.IsMenuAboutToBeClosed('EmoteMenu') then
                EmoteMenuOpen = false
            end
        else
            Citizen.Wait(450)
        end
    end
end)

-- [ Events ] --

RegisterNetEvent('mercy-animations/client/open-emote-menu', function()
    SetupAnimationMenu()
    EmoteMenuOpen = true
    Menu.OpenMenu('EmoteMenu')
end)

RegisterNetEvent('mercy-animations/client/play-animation', function(Animation)
    local AnimationData = GetAnimationFromId(Animation)
    if AnimationData ~= nil then
        -- ClearPedTasks(PlayerPedId())
        PlayingAnimData = AnimationData
        Citizen.SetTimeout(100, function()
            if AnimationData['Type'] == 'Scenario' then
                TaskStartScenarioInPlace(PlayerPedId(), AnimationData['Animation'], false, true)
                PlayingAnim = true
            else
                local AnimMovement = 0
                if AnimationData['Looping'] ~= nil and AnimationData['Looping'] then
                    AnimMovement = 1
                elseif AnimationData['Moving'] ~= nil and AnimationData['Moving'] then
                    AnimMovement = 49
                end
                FunctionsModule.RequestAnimDict(AnimationData['Dict'])
                TaskPlayAnim(PlayerPedId(), AnimationData['Dict'], AnimationData['Animation'], 2.0, 2.0, -1, AnimMovement, 0, false, false, false)
                PlayingAnim = true
                if AnimationData['Duration'] ~= nil and AnimationData['Duration'] > 0 then
                    Citizen.Wait(AnimationData['Duration'])
                    TriggerEvent('mercy-animations/client/clear-animation')
                end
            end
        end)
    else
        exports['mercy-ui']:Notify('no-emote', 'Emote '..Animation..' does not exist.', 'error')
    end
end)

RegisterNetEvent('mercy-animations/client/clear-animation', function()
    if PlayingAnimData['Prop'] ~= nil and PlayingAnimData['Prop'] then
        exports['mercy-assets']:RemoveProps(PlayingAnimData['Prop'])
    end
    ClearPedTasks(PlayerPedId())
    PlayingAnim, PlayingAnimData = false, {}
end)

-- [ Functions ] --

function SetupAnimationMenu()
    Menu.CreateMenu('EmoteMenu', '~b~Emote Menu')
    Menu.SetSubTitle("EmoteMenu", "Emotes")
    Menu.SetMenuMaxOptionCountOnScreen("EmoteMenu", 12)

    Menu.SetMenuX('EmoteMenu', 0.71)
    Menu.SetMenuY('EmoteMenu', 0.15)
    Menu.SetMenuWidth('EmoteMenu', 0.23)
    Menu.SetTitleColor('EmoteMenu', 135, 206, 250, 255)
    Menu.SetTitleBackgroundColor('EmoteMenu', 0 , 0, 0, 150)
    Menu.SetMenuBackgroundColor('EmoteMenu', 0, 0, 0, 100)
    Menu.SetMenuSubTextColor('EmoteMenu', 255, 255, 255, 255)
end

function GetAnimationFromId(AnimId)
    for k, v in pairs(Config.Animations) do
        if v.Id == AnimId then
            return v
        end
    end
end