local HasItem, AddedProp, IgnoreControls = false, false, false

RegisterNetEvent("mercy-inventory/client/update-player", function()
    local HoldItem = CallbackModule.SendCallback('mercy-misc/server/has-illegal-item')
    if LocalPlayer.state.LoggedIn and HoldItem then
        if not AddedProp then
            AddedProp = true
            AddPropToHands(HoldItem)
        end
    else
        if AddedProp then
            AddedProp = false
            RemovePropFromHands()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            if AddedProp and not IgnoreControls then
                DisableControlAction(0, 21, true)
                DisableControlAction(0, 22, true)
                DisableControlAction(0, 23, true)
                DisableControlAction(0, 75, true)
                DisableControlAction(27, 23, true)
                DisableControlAction(27, 22, true)
                DisableControlAction(27, 75, true)
            else
                Citizen.Wait(5000)
            end
        end
    end
end)

-- [ Functions ] --

function AddPropToHands(PropName)
    HasItem = true
    TriggerEvent('mercy-assets/client/attach-items')
    exports['mercy-assets']:AttachProp(PropName)
    if PropName ~= 'Duffel' and PropName ~= 'BriefCase' then
        IgnoreControls = false
        while HasItem do
            Citizen.Wait(4)
            if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) then
                FunctionsModule.RequestAnimDict("anim@heists@box_carry@")
                TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
            else
                Citizen.Wait(100)
            end
        end
    else
        IgnoreControls = true
    end
end

function RemovePropFromHands()
    HasItem = false
    exports['mercy-assets']:RemoveProps()
    StopAnimTask(PlayerPedId(), 'anim@heists@narcotics@trash', 'drop_side', 1.0)
    StopAnimTask(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 1.0)
end