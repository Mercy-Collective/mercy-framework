CurrentTarget, CurrentInstance, CurrentProximity, CurrentVoiceChannel, MyServer = 0, 0, 0, 0, 0
ProximityOverrides, PlayerModule = {[1] = {}, [2] = {}, [3] = {}}, nil
Transmissions, Targets, Channels = Context:New(), Context:New(), Context:New()

KeybindsModule, OnesyncModule, FunctionsModule, InitialConnection = nil, nil, nil, true

RegisterNetEvent('mercy-base/client/on-login', function()
    local A, B = GetInfo()
    MumbleSetServerAddress(A, B)
    Citizen.SetTimeout(1200, function()
        TriggerEvent('mercy-voice/client/voice-state', true)
        InitKeybinds()
    end)
end)

RegisterNetEvent('mercy-base/client/on-logout', function()
    TriggerEvent('mercy-voice/client/voice-state', false)
end)

AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
        'Player',
        'Keybinds',
        'Onesync',
        'Preferences',
        'Functions',
    }, function(Succeeded)
        if not Succeeded then return end
        KeybindsModule = exports['mercy-base']:FetchModule('Keybinds')
        OnesyncModule = exports['mercy-base']:FetchModule('Onesync')
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        PreferencesModule = exports['mercy-base']:FetchModule('Preferences')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
        InitVoice()
    end)
end)

-- [ Events ] --

AddEventHandler("mumbleConnected", function()
    print("Mumble: Connected")
    Citizen.SetTimeout(1500, function()
        TriggerEvent('mercy-voice/client/voice-state', true)
    end)
end)

AddEventHandler("mumbleDisconnected", function()
    print("Mumble: Disconnected")
    TriggerEvent('mercy-voice/client/voice-state', false)
end)

RegisterNetEvent('mercy-voice/client/voice-state', function(State)
    Config.VoiceEnabled = State
    TriggerServerEvent("mercy-voice/server/connection-state", State)
    
    if Config.VoiceEnabled then
        local ServerId = GetPlayerServerId(PlayerId())
        local CurrentChannel = MumbleGetVoiceChannelFromServerId(ServerId)
        while (CurrentChannel == -1 or CurrentChannel == 0) do
            CurrentChannel = MumbleGetVoiceChannelFromServerId(ServerId)
            NetworkSetVoiceChannel(CurrentVoiceChannel)
            Citizen.Wait(100)
        end

        RefreshTargets()
    end
end)

RegisterNetEvent("mercy-voice/client/transmission-state", function(ServerId, Context, Transmitting, Effect)
    if Transmissions:ContextExists(Context) then
        if Transmitting then
            Transmissions:Add(ServerId, Context)
        else
            Transmissions:Remove(ServerId, Context)
        end
        local IsCivRadio = CurrentChannel and CurrentChannel.Id > 10.0 or false
        local Data = GetPriorityContextData(ServerId)
        local OverrideSubmix, OverrideVolume, RangeMultiplier, TooFar = 'Default', nil, 1.0, false
        if Context == "Radio" and IsCivRadio and Transmitting then
            local GetSendingRange = #(GetEntityCoords(PlayerPedId()) - GetPlayerCoords(ServerId))
            if GetSendingRange > Config.RadioVoiceRanges['Radio-Medium'].Ranges.Min * RangeMultiplier and GetSendingRange <= Config.RadioVoiceRanges['Radio-Medium'].Ranges.Max * RangeMultiplier then
                OverrideSubmix = 'Radio-Medium'
            elseif GetSendingRange > Config.RadioVoiceRanges['Radio-Far'].Ranges.Min * RangeMultiplier and GetSendingRange <= Config.RadioVoiceRanges['Radio-Far'].Ranges.Max * RangeMultiplier then
                OverrideSubmix = 'Radio-Far'
            elseif GetSendingRange > Config.RadioVoiceRanges['Radio-Far'].Ranges.Min * RangeMultiplier then
                OverrideSubmix = 'Default'
                OverrideVolume = 0.0
                TooFar = true
            end
        end
        if Config.EnableSubmixes and Transmitting then
            SetPlayerVoiceFilter(ServerId, OverrideSubmix or Context)
        end
        if not Transmitting then
            MumbleSetVolumeOverrideByServerId(ServerId, OverrideVolume or Data.Volume)
            ResetPlayerVoiceFilter(ServerId)
            Citizen.Wait(0)
        end
        if Context == "Radio" and exports['mercy-ui']:IsRadioOn() then
            if TooFar then
                TriggerEvent('mercy-ui/client/play-sound', 'radio-distortion', 0.2)
            else
                local Preferences = PreferencesModule.GetPreferences()
                if not Preferences.Voice.RadioClicksIn then return end
                PlayRadioClick(Transmitting)
            end
        end
        if Transmitting then
            Citizen.Wait(0)
            MumbleSetVolumeOverrideByServerId(ServerId, OverrideVolume or Data.Volume)
        end
        if Config.Debug then print(('[Main] Transmission | Origin: %s | Vol: %s | Ctx: %s | Active: %s'):format(ServerId, Data.Volume, Context, Transmitting)) end
    end
end)

RegisterNetEvent('mercy-voice/client/proximity-override', function(Id, Mode, Range, Priority)
    if type(Mode) == 'table' then
        for i = 1, #Mode do
            local ProximityOverride = Mode[i]
            SetProximityOverride(ProximityOverride.Mode, Id, Range or ProximityOverride.Range, Priority or ProximityOverride.Priority)
        end
    else
        SetProximityOverride(Mode, Id, Range, Priority)
    end
end)

RegisterNetEvent('mercy-voice/client/set-muted', function(ServerId, Bool)
    MumbleSetPlayerMuted(ServerId, Bool)
    if Config.Debug then print(('[Main] Mute | Target %s'):format(Bool, ServerId)) end
end)

RegisterNUICallback("ResetMumble", function(Data, Cb)
    exports['mercy-ui']:Notify("reset-voice", "Resetted voice!", "success", 3000)
    RefreshConnection(true)
    TriggerEvent('mercy-voice/client/voice-state', true)
    Cb('Ok')
end)


-- [ Functions ] --

function InitVoice()
    Citizen.CreateThread(function()
        
        while not NetworkIsSessionStarted() do Citizen.Wait(50) end

        for i = 1, 4 do
            MumbleClearVoiceTarget(i)
        end
    
        if Config.EnableGrids then
            LoadGridModule()
        end

        if Config.EnableSubmixes then
            LoadFilters()
            LoadRadio()
            LoadPhone()
        end

        MyServer = GetPlayerServerId(PlayerId())
        SetVoiceProximity(2)
        TriggerEvent('mercy-voice/client/voice-state', true)
    end)
end

function InitKeybinds()
    Citizen.CreateThread(function()
        KeybindsModule.Add('SwitchProx', 'Voice', 'Switch Voice Proximity', 'GRAVE', function(IsPressed)
            if IsPressed then CycleVoiceProximity() end
        end)
        KeybindsModule.Add('UseRadio', 'Voice', 'Use Radio', 'CAPITAL', function(IsPressed)
            if IsPressed then StartRadioTransmission() else StopRadioTransmission() end
        end)
    end)
end

function RegisterModuleContext(Context, Priority)
    Transmissions:RegisterContext(Context)
    Targets:RegisterContext(Context)
    Channels:RegisterContext(Context)
    Transmissions:SetContextData(Context, "Priority", Priority)
    if Config.Debug then print(('[Main] Context Added | ID: %s | Priority: %s'):format(Context, Priority)) end
end

function IsDifferent(Current, Old)
    if #Current ~= #Old then
        return true
    else
        for i = 1, #Current, 1 do
            if Current[i] ~= Old[i] then
                return true
            end
        end
    end
end

function table.exist(Table, Val)
    for Key, Value in pairs(Table) do
        local Exist
        if type(Val) == "function" then
            Exist = val(Value, Key, Table)
        else
            Exist = Val == Value
        end
        if Exist then
            return true, Key
        end
    end
    return false
end

function _C(Condition, TrueExpr, FalseExpr)
    if Condition then
        return TrueExpr
    else
        return FalseExpr
    end
end

function AddChannelGroupToTargetList(Group, Context)
    if Channels:ContextExists(Context) then 
        for _, Channel in pairs(Group) do
            AddChannelToTargetList(Channel, Context)
        end
    end
end

function RemoveChannelGroupFromTargetList(Group, Context)
    if Channels:ContextExists(Context) then 
        for _, Channel in pairs(Group) do
            RemoveChannelFromTargetList(Channel, Context, false)
        end
        RefreshTargets()
    end
end

function AddChannelToTargetList(Channel, Context)
    if not Channels:TargetContextExist(Channel, Context) then
        if not Channels:TargetHasAnyActiveContext(Channel) then
            MumbleAddVoiceTargetChannel(CurrentTarget, Channel)
        end
        Channels:Add(Channel, Context)
        if Config.Debug then print( ('[Main] Channel Added | ID: %s | Context: %s'):format(Channel, Context) ) end
    end
end

function RemoveChannelFromTargetList(Channel, Context, Refresh)
    if Channels:TargetContextExist(Channel, Context) then
        Channels:Remove(Channel, Context)
        if Refresh then
            RefreshTargets()
        end
        if Config.Debug then print( ('[Main] Channel Removed | ID: %s | Context: %s'):format(Channel, Context) ) end
    end
end

function AddGroupToTargetList(Group, Context)
    if Targets:ContextExists(Context) then
        for ServerId, Active in pairs(Group) do
            if Active then
                AddPlayerToTargetList(ServerId, Context, false)
            end
        end
        TriggerServerEvent("mercy-voice/server/transmission-state-radio", Group, Context, true, true)
    end
end

function AddPlayerToTargetList(ServerId, Context, Transmit)
    if not Targets:TargetContextExist(ServerId, Context) then
        if Transmit then
            TriggerServerEvent("mercy-voice/server/transmission-state-radio", ServerId, Context, true, false)
        end
        if not Targets:TargetHasAnyActiveContext(ServerId) and MyServer ~= ServerId then
            MumbleAddVoiceTargetPlayerByServerId(CurrentTarget, ServerId)
        end
        Targets:Add(ServerId, Context)
        if Config.Debug then print( ('[Main] Target Added | Player: %s | Context: %s'):format(ServerId, Context) ) end
    end
end

function RemoveGroupFromTargetList(Group, Context)
    if Targets:ContextExists(Context) then
        for ServerId, Active in pairs(Group) do
            if Active then
                RemovePlayerFromTargetList(ServerId, Context, false, false)
            end
        end
        RefreshTargets()
        TriggerServerEvent("mercy-voice/server/transmission-state-radio", Group, Context, false, true)
    end
end

function RemovePlayerFromTargetList(ServerId, Context, Transmit, Refresh)
    if Targets:TargetContextExist(ServerId, Context) then
        Targets:Remove(ServerId, Context)
        if Transmit then
            TriggerServerEvent("mercy-voice/server/transmission-state-radio", ServerId, Context, false, false)
        end
        if Refresh then
            RefreshTargets()
        end
        if Config.Debug then print( ('[Main] Target Removed | Player: %s | Context: %s'):format(ServerId, Context) ) end
    end
end

function IsPlayerInTargetChannel(ServerId)
    local GridChannel = MumbleGetVoiceChannelFromServerId(ServerId)
    return Channels:TargetHasAnyActiveContext(GridChannel) == true
end

function RefreshTargets()
    local VoiceTarget = _C(CurrentTarget == 1, 2, 1)
    MumbleClearVoiceTarget(VoiceTarget)
    SetVoiceTargets(VoiceTarget)
    ChangeVoiceTarget(VoiceTarget)
end

function SetVoiceTargets(TargetId)
    local Players, Channelss = {}, {}
    Channels:ContextIterator(function(Channel)
        if not Channelss[Channel] then
            Channelss[Channel] = true
            MumbleAddVoiceTargetChannel(TargetId, Channel)
        end
    end)
    Targets:ContextIterator(function(ServerId)
        if not Players[ServerId] and not IsPlayerInTargetChannel(ServerId) then
            Players[ServerId] = true
            MumbleAddVoiceTargetPlayerByServerId(TargetId, ServerId)
        end
    end)
end

function ChangeVoiceTarget(TargetId)
    CurrentTarget = TargetId
    MumbleSetVoiceTarget(TargetId)
end

function SetVoiceChannel(ChannelId)
    NetworkSetVoiceChannel(ChannelId)
    CurrentVoiceChannel = ChannelId
    if Config.Debug then print( ('[Main] Current Channel: %s | Previous: %s | Target: %s'):format(ChannelId, CurrentVoiceChannel, CurrentTarget) ) end
end

function UpdateContextVolume(Context, Volume)
    Transmissions:SetContextData(Context, "Volume", Volume)
    Transmissions:ContextIterator(function(TargetId, TContext)
        if TContext == Context then
            local Context = GetPriorityContextData(TargetId)
            MumbleSetVolumeOverrideByServerId(TargetId, Context.Volume)
        end
    end)
end

function GetPriorityContextData(ServerId)
    local _, Contexts = Transmissions:GetTargetContexts(ServerId)
    local Context = {Volume = -1.0, Priority = 0}
    for _, Ctx in pairs(Contexts) do
        if Ctx.Priority >= Context.Priority and (Ctx.Volume == -1 or Ctx.Volume >= Context.Volume) then
            Context = Ctx
        end
    end
    return Context
end

function SetVoiceProximity(Proximity)
    local VoiceProximity = Config.VoiceRanges[Proximity]
    CurrentProximity = Proximity
    local Range, Priority = -1, -1
    for _, Override in pairs(ProximityOverrides[Proximity]) do
        if Override and (Override.Priority > Priority) then
            Range = Override.Range
            Priority = Override.Priority
        end
    end
    Range = Range > -1 and Range or VoiceProximity.Range
    NetworkSetTalkerProximity(Range + 0.0)
    if Config.Debug then print( ('[Main] Proximity Range | Proximity: %s | Range: %s'):format(VoiceProximity.Name, Range) ) end
end

function CycleVoiceProximity()
    local NewProximity = CurrentProximity + 1
    local Proximity = _C(Config.VoiceRanges[NewProximity] ~= nil, NewProximity, 1)
    SetVoiceProximity(Proximity)
    if Proximity == 3 then
        TriggerEvent('mercy-ui/client/set-hud-values', 'Voice', 'Value',  100)
    elseif Proximity == 2 then
        TriggerEvent('mercy-ui/client/set-hud-values', 'Voice', 'Value',  66)
    else
        TriggerEvent('mercy-ui/client/set-hud-values', 'Voice', 'Value',  33)
    end
end

function RefreshConnection(IsForced)
    if InitialConnection or IsForced then
        local A, B = GetInfo()
        MumbleSetServerAddress(A, B)
        InitialConnection = IsForced and InitialConnection or false
    end
end

function SetProximityOverride(Mode, Id, Range, Priority)
    if not ProximityOverrides[Mode] then return error('Invalid proximity mode') end
    ProximityOverrides[Mode][Id] = {Range = Range, Priority = Priority, Mode = Mode}
    if CurrentProximity ~= Mode then return end
    if Config.Debug then print(('[Main] Proximity Override | Range: %s | Priority: %s | Mode: %s'):format(Range, Priority, Mode)) end
    SetVoiceProximity(CurrentProximity)
end

function GetInfo()
    local Info, Endpoint = {}, GetCurrentServerEndpoint()
    local CustomEndpoint = GetConvar('customEndpoint', 'false')
    if CustomEndpoint ~= 'false' then Endpoint = CustomEndpoint end
    for Match in string.gmatch(Endpoint, "[^:]+") do
        Info[#Info + 1] = Match
    end
    return Info[1], tonumber(Info[2])
end

function GetPlayerCoords(ServerId)
    local PlayerId = GetPlayerFromServerId(ServerId)
    if PlayerId ~= -1 then
        return GetEntityCoords(GetPlayerPed(PlayerId))
    else
        return OnesyncModule.GetPlayerCoords(ServerId) or vector3(0.0, 0.0, 0.0)
    end
end

function TimeOut(Time)
    local Promise = promise:new()
    Citizen.SetTimeout(Time, function ()
        Promise:resolve(true)
    end)
    return Promise
end

function AlmostEqual(FloatOne, FloatTwo, Threshold)
    return math.abs(FloatOne - FloatTwo) <= Threshold
end