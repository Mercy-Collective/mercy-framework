local ProgressBarActive = false

function DoProgressBar(Title, Duration, Animation, Prop, Freeze, CanCancel, Finished)
    if not ProgressBarActive then
        ReturnFinished = Finished
        ProgressBarActive = true
        SendUIMessage("Progress", "Start", {
            Title = Title,
            Duration = Duration,
        })

        if Animation ~= nil and Animation ~= false then
            FunctionsModule.RequestAnimDict(Animation['AnimDict'])
            TaskPlayAnim(PlayerPedId(), Animation['AnimDict'], Animation['AnimName'], 8.0, 1.0, -1, Animation['AnimFlag'], 0, 0, 0, 0)
        end

        if Prop ~= nil and Prop ~= false then
            exports['mercy-assets']:AttachProp(Prop)
        end

        Citizen.CreateThread(function()
            while ProgressBarActive do
                Citizen.Wait(4)
                if Freeze then
                    DisableControlAction(0, 30, true) 
                    DisableControlAction(0, 36, true) 
                    DisableControlAction(0, 31, true) 
                    DisableControlAction(0, 36, true) 
                    DisableControlAction(0, 21, true) 
                    DisableControlAction(0, 75, true) 
                    DisableControlAction(27, 75, true)
                end
                if (IsControlJustPressed(0, 178) and CanCancel) or IsEntityDead(PlayerPedId()) then
                    StopProgress(true)
                end
                if Animation ~= nil and Animation ~= false then
                    if not IsEntityPlayingAnim(PlayerPedId(), Animation['AnimDict'], Animation['AnimName'], 3) then
                        TaskPlayAnim(PlayerPedId(), Animation['AnimDict'], Animation['AnimName'], 8.0, 1.0, -1, Animation['AnimFlag'], 0, 0, 0, 0)
                    end
                end
            end
            if Animation ~= nil and Animation ~= false then
                if Prop ~= nil and Prop ~= false then
                    exports['mercy-assets']:RemoveProps(Prop)
                end
                StopAnimTask(PlayerPedId(), Animation['AnimDict'], Animation['AnimName'], 1.0)
                ClearPedTasks(PlayerPedId())
            end
        end)
    end
end
exports("ProgressBar", DoProgressBar)

function StopProgress(Forced)
    if Forced then
        SendUIMessage("Progress", "Stop", {})
        if ReturnFinished ~= nil then
            ReturnFinished(false)
        end
    end
    ProgressBarActive = false
end

RegisterNUICallback('Progress/Done', function(Data, Cb)
    StopProgress(false)
    if ReturnFinished ~= nil then
        ReturnFinished(true)
    end
end)

RegisterNetEvent('mercy-ui/client/ui-reset', function()
    if ProgressBarActive then
        StopProgress(true)
    end
end)

exports("IsProgressBarActive", function() return IsProgressBarActive end)