local PlayingMedia = false

RegisterNetEvent('mercy-ui/client/open-walkman', function()
    if not PlayingMedia then
        Citizen.SetTimeout(650, function()
            local InputChoices = {}
            for k, v in pairs(Config.Songs) do
                table.insert(InputChoices, {
                    Icon = false,
                    Text = v.Name,
                    OnClickEvent = '',
                    EventType = '',
                })
            end
            local Data = {
                {Name = 'Song', Label = 'Song', Icon = 'fas fa-music', Choices = InputChoices},
            }
            local WalkInput = exports['mercy-ui']:CreateInput(Data)
            if WalkInput['Song'] then
                Citizen.SetTimeout(150, function()
                    local SongNumber = GetSongNumber(WalkInput['Song'])
                    SendUIMessage('Media', 'PlayMedia', SongNumber)
                    SetNuiFocus(true, true)
                    PlayingMedia = true
                end)
            end
        end)
    else
        SendUIMessage('Media', 'OpenMedia', {})
        SetNuiFocus(true, true)
    end
end)

-- [ Functions ] --

function GetSongNumber(Name)
    for k, v in pairs(Config.Songs) do
        if v.Name == Name then
            return v.Id
        end
    end
    return 0 -- No found.
end

-- [ NUI Callbacks] --

RegisterNUICallback('Media/Stop', function(Data, Cb)
    PlayingMedia = false
    Cb('Ok')
end)

RegisterNUICallback('Media/Close', function(Data, Cb)
    SetNuiFocus(false, false)
    Cb('Ok')
end)