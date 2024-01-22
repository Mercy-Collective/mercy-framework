PlayerModule, CallbackModule, EventsModule, FunctionsModule, VehicleModule = nil
local TVDui = false
InCasino = false

local PostGateTriggered = false
local InVRHeadset = false

local WheelPed = nil

AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
        'Player',
        'Callback',
        'Events',
        'Functions',
        'Vehicle',
    }, function(Succeeded)
        if not Succeeded then return end
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
        VehicleModule = exports['mercy-base']:FetchModule('Vehicle')

        local WheelVehicle = CallbackModule.SendCallback('mercy-casino/server/get-current-wheel-veh')
        Config.Options['Wheel']['Slots'][#Config.Options['Wheel']['Slots']]['Model'] = WheelVehicle
    end)
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if WheelPed ~= nil then
            RemoveReplaceTexture('vw_prop_vw_luckywheel_01a', 'script_rt_casinowheel')
            RemoveReplaceTexture('vw_prop_vw_cinema_tv_01', 'script_rt_tvscreen')
            exports['mercy-assets']:ReleaseDui('Casino-Wheel')
            exports['mercy-assets']:ReleaseDui('Casino-TV-Car')
            DeleteEntity(WheelPed)
        end
    end
end)

-- AddEventHandler('onResourceStart', function(resource)
--     if resource == GetCurrentResourceName() then
--         SetTimeout(1000, function()
--             EnterCasino(true)
--         end)
--     end
-- end)

-- [ Code ] --

-- [ Events ] --


RegisterNetEvent("mercy-casino/client/casino-actions", function()
    local MenuData = {
        {
            ['Title'] = 'Buy Chips',
            ['Desc'] = 'Buy chips to play with.',
            ['Data'] = { ['Event'] = 'mercy-casino/client/casino-action', ['Type'] = 'Client', ['Action'] = 'Buy' }
        },
        {
            ['Title'] = 'Buy Chips (Dirty)',
            ['Desc'] = 'Buy chips to play with.',
            ['Data'] = { ['Event'] = 'mercy-casino/client/casino-action', ['Type'] = 'Client', ['Action'] = 'BuyDirty' }
        },
        {
            ['Title'] = 'Withdraw (Cash)',
            ['Desc'] = 'Withdraw chips to cash.',
            ['Data'] = { ['Event'] = 'mercy-casino/client/casino-action', ['Type'] = 'Client', ['Action'] = 'CashWithdraw' }
        },
        {
            ['Title'] = 'Withdraw (Bank)',
            ['Desc'] = 'Withdraw chips to bank account.',
            ['Data'] = { ['Event'] = 'mercy-casino/client/casino-action', ['Type'] = 'Client', ['Action'] = 'BankWithdraw' }
        },
        {
            ['Title'] = 'Transfer',
            ['Desc'] = 'Transfer chips to other person.',
            ['Data'] = { ['Event'] = 'mercy-casino/client/casino-action', ['Type'] = 'Client', ['Action'] = 'Transfer' }
        },
    }
    exports['mercy-ui']:OpenContext({ ['MainMenuItems'] = MenuData })
end)

local Timeout = false
RegisterNetEvent("mercy-casino/client/casino-action", function(Data)
    if not HasCasinoMembership() then return exports['mercy-ui']:Notify("casino", "You must have a casino membership to do this..", "error") end
    local Type = Data['Action']

    if Type == 'Buy' then
        Wait(100)
        local ChipsInput = exports['mercy-ui']:CreateInput({
            {
                Name = 'chips-amount', 
                Label = 'Purchase Amount', 
                Icon = 'fas fa-dollar-sign',
                Type = 'Text',
            },
        })
        if ChipsInput['chips-amount'] then
            EventsModule.TriggerServer("mercy-casino/server/buy-chips", ChipsInput['chips-amount'])
        end
    elseif Type == 'BuyDirty' then
        local Payment = math.random(10, 110)
        if exports["mercy-inventory"]:HasEnoughOfItem("markedbills", 20) then
            local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', 'markedbills', 20, false, true)
            if DidRemove then
                Payment = Payment + (250 * 20) -- $5k / $250 per
            end
        end
        if exports["mercy-inventory"]:HasEnoughOfItem("cash-rolls", 5, false, true) then
            local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', 'cash-rolls', 5, false, true)
            if DidRemove then
                Payment = Payment + (30 * 5) -- $150 / $30 per
            end
        end
        if exports["mercy-inventory"]:HasEnoughOfItem("cash-bands", 5, false, true) then
            local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', 'cash-bands', 5, false, true)
            if DidRemove then
                Payment = Payment + (300 * 5) -- $1500, / $300 per
            end
        end
        EventsModule.TriggerServer("mercy-casino/server/buy-chips", Payment, true)
    elseif Type == 'CashWithdraw' then
        if Timeout then return exports['mercy-ui']:Notify("casino-withdraw", "You are already withdrawing, please wait..", "error") end
        if not Timeout then
            Timeout = true
            local Added = CallbackModule.SendCallback('mercy-casino/server/withdraw-money', 'Cash')
            if Added then
                Timeout = false
            else
                Timeout = false
            end
        end
    elseif Type == 'BankWithdraw' then
        if Timeout then return exports['mercy-ui']:Notify("casino-withdraw", "You are already withdrawing, please wait..", "error") end
        if not Timeout then
            Timeout = true
            local Added = CallbackModule.SendCallback('mercy-casino/server/withdraw-money', 'Bank')
            if Added then
                Timeout = false
            else
                Timeout = false
            end
        end
    elseif Type == 'Transfer' then
        Wait(100)
        local TransferInput = exports['mercy-ui']:CreateInput({
            {
                Name = 'state-id', 
                Label = 'State Id', 
                Icon = 'fas fa-user',
                Type = 'Text',
            },
            {
                Name = 'chips-amount', 
                Label = 'Chips Amount', 
                Icon = 'fas fa-dollar-sign',
                Type = 'Text',
            },
        })
        if TransferInput['state-id'] and TransferInput['chips-amount'] then
            EventsModule.TriggerServer("mercy-casino/server/transfer-chips", TransferInput['state-id'], ChipsInput['chips-amount'])
        end
    end
end)

-- [ Functions ] --

function SetupCasinoPeds()
    ChipsPed = CreatePed(3, GetHashKey('u_f_m_casinocash_01'), 990.85, 30.96, 70.47, 56.65, false, false)
    FreezeEntityPosition(ChipsPed, true)
    SetEntityInvincible(ChipsPed, true)
    SetBlockingOfNonTemporaryEvents(ChipsPed, true)
    SetPedCanRagdoll(ChipsPed, false)
end

function HasCasinoMembership()
    local PlayerData = PlayerModule.GetPlayerData()
    local CardData = CallbackModule.SendCallback('mercy-base/server/get-membership')
    if not CardData then return false end
    return CardData.Info.StateId == PlayerData.CitizenId
end

function EnterCasino(Bool)
    if Bool == InCasino then return end
    InCasino = Bool
    if DoesEntityExist(SpinningCar) then
        DeleteEntity(SpinningCar)
    end
    local function DoInitStuff()
        SpinVehicle()
        InitScreensHall()
        InitWheel(true)
        -- InitBlackjack(true)
        InitAudio()
        InitTVImage(true)
        InitSlots(true)
    end
    if not InCasino then
        InitTVImage(false)
        InitWheel(false)
        -- InitBlackjack(false)
        InitSlots(false)
        TriggerEvent("mercy-casino/client/exited")
        PostGateTriggered = false
        return
    end
    DoInitStuff()
    TriggerEvent("mercy-casino/client/entered")
end

function InitTVImage(Bool)
    if Bool then
        if TVDui then -- If tv exists, reset
            exports['mercy-assets']:ChangeDuiURL(TVDui['DuiId'], Config.TVImage)
            AddReplaceTexture('vw_prop_vw_cinema_tv_01', 'script_rt_tvscreen', TVDui['TxdDictName'], TVDui['TxdName'])
        else
            TVDui = exports['mercy-assets']:GenerateNewDui(Config.TVImage, 512, 256, 'Casino-TV-Car')
            if not TVDui then return end
            AddReplaceTexture('vw_prop_vw_cinema_tv_01', 'script_rt_tvscreen', TVDui['TxdDictName'], TVDui['TxdName'])
            Citizen.Wait(2000)
        end
    else
        TVDui = false
        exports['mercy-assets']:ReleaseDui('Casino-TV-Car')
        RemoveReplaceTexture('vw_prop_vw_cinema_tv_01', 'script_rt_tvscreen')
    end
end

function CreateNamedRenderTargetForModel(Name, Model)
    local Handle = 0
    if not IsNamedRendertargetRegistered(Name) then
        RegisterNamedRendertarget(Name, 0)
    end
    if not IsNamedRendertargetLinked(Model) then
        LinkNamedRendertarget(Model)
    end
    if IsNamedRendertargetRegistered(Name) then
        Handle = GetNamedRendertargetRenderId(Name)
    end
    return Handle
end

function InitScreensHall()
    Citizen.CreateThread(function()
        local PropNames = {"vw_vwint01_video_overlay", "gbz_casino_video_overlay"}
        for _, PropName in pairs(PropNames) do
            Citizen.CreateThread(function()
                local Model = GetHashKey(PropName)
                local Timeout = 21085 -- 5000 / 255
                local CasinoScreenStr = PropName == "vw_vwint01_video_overlay" and "CasinoScreen_01" or "CasinoScreen_02"
                local Handle = CreateNamedRenderTargetForModel(CasinoScreenStr, Model)
                RegisterScriptWithAudio(0)
                SetTvChannel(-1)
                SetTvVolume(0)
                SetScriptGfxDrawOrder(4)
                SetTvChannelPlaylist(2, "CASINO_DIA_PL", 0)
                SetTvChannel(2)
                EnableMovieSubtitles(1)
        
                function DoAlpha()
                    Citizen.SetTimeout(Timeout, function()
                        SetTvChannelPlaylist(2, "CASINO_DIA_PL", 0)
                        SetTvChannel(2)
                        if InCasino then
                            DoAlpha()
                        end
                    end)
                end
                DoAlpha()
        
                Citizen.CreateThread(function()
                    while InCasino do
                        SetTextRenderId(Handle)
                        DrawTvChannel(0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
                        SetTextRenderId(GetDefaultScriptRendertargetRenderId())
                        Citizen.Wait(0)
                    end
                    SetTvChannel(-1)
                    ReleaseNamedRendertarget(GetHashKey(CasinoScreenStr))
                    SetTextRenderId(GetDefaultScriptRendertargetRenderId())
                end)
            end)
        end
    end)
end

function InitAudio()
    Citizen.CreateThread(function()
        local function AudioBanks()
            while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_GENERAL", false, -1) do
                Citizen.Wait(0)
            end
            while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_01", false, -1) do
                Citizen.Wait(0)
            end
            while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_02", false, -1) do
                Citizen.Wait(0)
            end
            while not RequestScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_03", false, -1) do
                Citizen.Wait(0)
            end
        end
        AudioBanks()
        while InCasino do
            if InVRHeadset and IsStreamPlaying() then
                StopStream()
            end
            if InVRHeadset and IsAudioSceneActive("DLC_VW_Casino_General") then
                StopAudioScene("DLC_VW_Casino_General")
            end
            if not InVRHeadset and not IsStreamPlaying() and LoadStream("casino_walla", "DLC_VW_Casino_Interior_Sounds") then
                PlayStreamFromPosition(996.13,38.48,71.07)
            end
            if not InVRHeadset and IsStreamPlaying() and not IsAudioSceneActive("DLC_VW_Casino_General") then
                StartAudioScene("DLC_VW_Casino_General")
            end
            Citizen.Wait(1000)
        end
        if IsStreamPlaying() then
            StopStream()
        end
        if IsAudioSceneActive("DLC_VW_Casino_General") then
            StopAudioScene("DLC_VW_Casino_General")
        end
        ReleaseScriptAudioBank("DLC_VINEWOOD/CASINO_GENERAL")
        ReleaseScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_01")
        ReleaseScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_02")
        ReleaseScriptAudioBank("DLC_VINEWOOD/CASINO_SLOT_MACHINES_03")
    end)
end