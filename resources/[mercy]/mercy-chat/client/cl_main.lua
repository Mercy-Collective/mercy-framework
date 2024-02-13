local ChatOpen, CanReceiveOOC, FunctionsModule, PlayerModule = false, true, nil, nil
local SpamFilter = {
    ["e passout"] = 5000,
    ["e passout2"] = 5000,
    ["e passout3"] = 5000,
    ["e passout4"] = 5000,
    ["e passout5"] = 5000,
    ["e slide"] = 5000,
}


local _Ready = false
AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
        'Functions',
        'Player',
        'Events',
    }, function(Succeeded)
        if not Succeeded then return end
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        _Ready = true
    end)
end)

-- [ Code ] --

RegisterNetEvent('mercy-chat/client/toggle-OOC', function()
    CanReceiveOOC = not CanReceiveOOC
    if CanReceiveOOC then exports['mercy-ui']:Notify("chat", "You can see OOC 👀", "success")
    else exports['mercy-ui']:Notify("no-ooc", "You won't see OOC anymore..", "error") end
end)

RegisterNetEvent('mercy-ui/client/ui-reset', function()
    if ChatOpen then
        SetNuiFocus(false, false)
        ChatOpen = false
    end
end)

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            if IsControlJustPressed(0, 245) and not ChatOpen then -- Press T to open chat
                SetNuiFocus(true, false)
                SendNUIMessage({
                    Action = 'OpenChat',
                })
                ChatOpen = true
            end
        else
            Citizen.Wait(450)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn and ChatOpen then
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisablePlayerFiring(PlayerId(), true)
        else
            Citizen.Wait(450)
        end
    end
end)

-- [ Events ] --

RegisterNetEvent('mercy-chat/client/post-message', function(Title, Message, Class)
    local ChatName = string.sub(Title, 1, 4)
    if (ChatName == 'OOC ' or ChatName == 'LOOC') and not CanReceiveOOC then return end

    local MessageData = {Header = Title, Message = Message, Type = Class}
    SendNUIMessage({
        Action = 'PostMessage',
        Message = MessageData
    })
end)

RegisterNetEvent('mercy-chat/client/send-identification', function(CitizenId, Firstname, Lastname, Date, Sex)
    local ClosestPlayer = PlayerModule.GetClosestPlayer(nil, 2.0)

    if ClosestPlayer['ClosestPlayerPed'] == -1 and ClosestPlayer['ClosestServer'] == -1 then
        EventsModule.TriggerServer("mercy-items/server/show-identification", CitizenId, Firstname, Lastname, Date, Sex, nil)
    else
        EventsModule.TriggerServer("mercy-items/server/show-identification", CitizenId, Firstname, Lastname, Date, Sex, ClosestPlayer['ClosestServer'])
    end
end)

RegisterNetEvent('mercy-chat/client/post-identification', function(CitizenId, Firstname, Lastname, Date, Sex)
    local IdentificationData = {CitizenId = CitizenId, Firstname = Firstname, Lastname = Lastname, Date = Date, Sex = Sex}
    SendNUIMessage({
        Action = 'PostIdentificationCard',
        Identification = IdentificationData
    })
end)

RegisterNetEvent('mercy-chat/client/add-suggestion', function(Name, Desc, Args)
    local SuggestionData = {Name = Name, Description = Desc, Args = Args}
    SendNUIMessage({
        Action = 'AddSuggestion',
        Suggestion = SuggestionData
    })
end)

RegisterNetEvent('mercy-chat/client/refresh-suggestion', function()
    SendNUIMessage({Action = 'ClearSuggestions'})
end)

RegisterNetEvent('mercy-chat/client/clear-chat', function()
    SendNUIMessage({Action = 'ClearChat'})
end)

RegisterNetEvent("mercy-chat/client/local-ooc", function(ServerId, Name, Message)
    local SourceCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(ServerId)), false)
    local TargetCoords = GetEntityCoords(PlayerPedId(), false)
    if (GetDistanceBetweenCoords(TargetCoords.x, TargetCoords.y, TargetCoords.z, SourceCoords.x, SourceCoords.y, SourceCoords.z, true) < 20.0) then
        TriggerEvent('mercy-chat/client/post-message', "LOOC | "..Name, Message, "normal")
    end
end)

RegisterNetEvent('3dme:shareDisplay', function(text, target, name)
    local player = GetPlayerFromServerId(target)
    if player ~= -1 or target == GetPlayerServerId(PlayerId()) then
        local ped = GetPlayerPed(player)
        displayText(ped, "~r~* " .. text .. " *", 0.45, 'ME', name, text)
    end
end)

-- [ NUI Callbacks ] --

RegisterNUICallback('Chat/Execute', function(Data, Cb)
    local Message = Data.Value
    if Message:sub(1,1) == '/' then
        Message = Message:sub(2)
    end

    -- Checking if filter has any match to fix empty space bypass.
    local HasSpamFilter, FilteredWord = false, ""
    for k, v in pairs(SpamFilter) do
        if string.find(Message:lower(), k) then
            HasSpamFilter, FilteredWord = true, k
            break
        end
    end

    local HasCooldown = FunctionsModule.Throttled("chat-" .. FilteredWord, SpamFilter[FilteredWord])
    if not HasSpamFilter or (HasSpamFilter and not HasCooldown) then
        ExecuteCommand(Message)
        TriggerServerEvent('mercy-chat/server/log-execute', Message)
    else
        exports['mercy-ui']:Notify("command-cooldown", "You can't use this command yet..", "error")
    end

    Cb('Ok')
end)

RegisterNUICallback('Chat/Close', function(Data, Cb)
    SetNuiFocus(false, false)
    ChatOpen = false
    Cb('Ok')
end)

exports("GetSpamFilter", function()
    return SpamFilter
end)

local peds = {}

function draw3dText(coords, text)
    local camCoords = GetGameplayCamCoord()
    local dist = #(coords - camCoords)

    local scale = 200 / (GetGameplayCamFov() * dist)

    SetTextColour(0, 0, 0, 255)
    SetTextScale(0.0, 0.5 * scale)
    SetTextFont(0)
    SetTextDropshadow(0, 0, 0, 0, 55)
    SetTextDropShadow()
    SetTextCentre(true)

    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(coords, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

function displayText(ped, text, yOffset, data, name, ctext)
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    local targetPos = GetEntityCoords(ped)
    local dist = #(playerPos - targetPos)
    local los = HasEntityClearLosToEntity(playerPed, ped, 17)

    if dist <= 250 and los then
        TriggerEvent('mercy-chat/client/post-message', data.." | "..name, ctext, "normal")
        peds[ped] = {
            time = GetGameTimer() + 5000,
            text = text,
            yOffset = yOffset
        }

        if not peds[ped].exists then
            peds[ped].exists = true

            Citizen.CreateThread(function()
                while GetGameTimer() <= peds[ped].time do
                    local pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, peds[ped].yOffset)
                    draw3dText(pos, peds[ped].text)
                    Citizen.Wait(0)
                end

                peds[ped] = nil
            end)
        end
    end
end
