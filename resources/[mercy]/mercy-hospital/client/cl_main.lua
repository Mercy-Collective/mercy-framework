PlayerModule, EventsModule, FunctionModule, VehicleModule, CallbackModule = nil
local HospitalBedCam = nil

AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
        'Player',
		'Events',
        'Functions',
        'Vehicle',
        'Callback',
    }, function(Succeeded)
        if not Succeeded then return end
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        FunctionModule = exports['mercy-base']:FetchModule('Functions')
        VehicleModule = exports['mercy-base']:FetchModule('Vehicle')
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
    end)
end)

RegisterNetEvent('mercy-base/client/on-login', function()
    Citizen.SetTimeout(2250, function()
        InitHospitalZones()
        InitHospital()
    end)
end)

RegisterNetEvent('mercy-base/client/on-logout', function()
    TriggerEvent('mercy-hospital/client/clear-bleeding')
    TriggerEvent('mercy-hospital/client/clear-wounds')
    Config.Dead, Config.Timer = false, 60
    PressingTime, Doingtimer = 5, false
    Config.InHospitalBed = false
end)

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if LocalPlayer.state.LoggedIn then
            Citizen.Wait(3500)
            TriggerEvent('mercy-hospital/client/save-vitals')
        else
            Citizen.Wait(450) 
        end
    end
end)

-- [ Events ] --

RegisterNetEvent('mercy-hospital/client/kill-player', function()
    SetEntityHealth(PlayerPedId(), 0)
    SetEntityMaxHealth(PlayerPedId(), 200)
end)

RegisterNetEvent("mercy-hospital/client/save-vitals", function()
    local Armor = GetPedArmour(PlayerPedId())
    local Health = GetEntityHealth(PlayerPedId())
    TriggerServerEvent('mercy-hospital/server/save-vitals', Armor, Health)
end)

RegisterNetEvent('mercy-hospital/client/set-hospital-bed-busy', function(BedId, Bool)
    Config.HospitalBeds[BedId]['Busy'] = Bool
end)

RegisterNetEvent('mercy-hospital/client/open-ems-store', function()
    if exports['mercy-inventory']:CanOpenInventory() then
        EventsModule.TriggerServer('mercy-inventory/server/open-other-inventory', 'Ems Cabin', 'Store', 0, 0, Config.EmsStore, 'EmsStore')
    end
end)

RegisterNetEvent('mercy-hospital/client/try-send-to-bed', function(IsRespawn)
    if not IsRespawn then
        exports['mercy-ui']:ProgressBar('Showing Credentials..', 5000, {['AnimName'] = 'base', ['AnimDict'] = 'missheistdockssetup1clipboard@base', ['AnimFlag'] = 49}, 'Clipboard', true, true, function(DidComplete)
            if DidComplete then
                local FreeBed = GetAvailableHospitalBed()
                if FreeBed ~= false then
                    TriggerEvent('mercy-hospital/client/send-to-bed', FreeBed)
                else
                    TriggerEvent('mercy-ui/client/notify', "hospital-beds", 'Their are no free beds..', 'error', 4500)
                end
            end
        end)
    else
        local FreeBed = GetAvailableHospitalBed()
        if FreeBed ~= false then
            PressingTime, Doingtimer = 5, false
            TriggerEvent('mercy-hospital/client/send-to-bed', FreeBed)
            TriggerServerEvent('mercy-hospital/server/clear-inventory')
            TriggerEvent('mercy-ui/client/notify', "hospital-items", 'You lost all your items..', 'error', 4500)
        else
            TriggerEvent('mercy-ui/client/notify', "hospital-beds", 'Their are no free beds at the moment please wait..', 'error', 4500)
        end
    end
end)

RegisterNetEvent('mercy-hospital/client/send-to-bed', function(BedId)
    Citizen.SetTimeout(50, function()
        TriggerEvent('mercy-assets/client/attach-items')
        EnterHospitalBed(BedId)
        TriggerServerEvent('mercy-hospital/server/set-hospital-bed-busy', BedId, true)
        Citizen.Wait(25000)
        LeaveHospitalBed(BedId)
        EventsModule.TriggerServer('mercy-hospital/server/reset-vitals')
        TriggerEvent('mercy-hospital/client/revive', false)
        TriggerServerEvent('mercy-hospital/server/set-hospital-bed-busy', BedId, false)
    end)
end)

-- [ Functions ] --

function EnterHospitalBed(BedId)
    Citizen.CreateThread(function()
        Config.InHospitalBed = true
        local BedData = Config.HospitalBeds[BedId]
        DoScreenFadeOut(1000)
        while not IsScreenFadedOut() do
            Citizen.Wait(100)
        end
        SetEntityCoords(PlayerPedId(), BedData['Coords'].x, BedData['Coords'].y, BedData['Coords'].z - 0.40)
        SetEntityHeading(PlayerPedId(), BedData['Coords'].w)
        Citizen.Wait(500)
        FunctionModule.RequestAnimDict("misslamar1dead_body")
        TaskPlayAnim(PlayerPedId(), "misslamar1dead_body", "dead_idle", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
        FreezeEntityPosition(PlayerPedId(), true)
        CreateHospitalBedCamera()
        DoScreenFadeIn(1000)
    end)
end

function LeaveHospitalBed(BedId)
    Citizen.CreateThread(function()
        local BedData = Config.HospitalBeds[BedId]
        FreezeEntityPosition(PlayerPedId(), false)
        SetEntityCoords(PlayerPedId(), BedData['Coords'].x, BedData['Coords'].y, BedData['Coords'].z - 0.40)
        SetEntityHeading(PlayerPedId(), BedData['Coords'].w + 90)
        FunctionModule.RequestAnimDict("switch@franklin@bed")
        TaskPlayAnim(PlayerPedId(), 'switch@franklin@bed', 'sleep_getup_rubeyes', 100.0, 1.0, -1, 8, -1, 0, 0, 0)
        Citizen.Wait(4000)
        ClearPedTasks(PlayerPedId())
        DestroyCam(HospitalBedCam, true)
        RenderScriptCams(false, false, 1, true, true)
        HospitalBedCam, Config.InHospitalBed = nil, false
        -- Set bed state to normale
    end)
end

function CreateHospitalBedCamera()
    HospitalBedCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamActive(HospitalBedCam, true)
    RenderScriptCams(true, false, 1, true, true)
    AttachCamToPedBone(HospitalBedCam, PlayerPedId(), 31085, 0, 1.0, 1.0 , true)
    SetCamFov(HospitalBedCam, 100.0)
    SetCamRot(HospitalBedCam, -45.0, 0.0, GetEntityHeading(PlayerPedId()) + 180, true)
end

function GetAvailableHospitalBed()
    for k, v in pairs(Config.HospitalBeds) do
        if not v['Busy'] then
            return k
        end
    end
    return false
end

function DrawScreenText(ScreenX, ScreenY, Center, Text)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.57, 0.57)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(Center)
    SetTextEntry("STRING")
    AddTextComponentString(Text)
    DrawText(ScreenX, ScreenY)
end

function InitHospital()
    local Player = PlayerModule.GetPlayerData()
    Citizen.SetTimeout(3500, function()
        if Player.MetaData['Dead'] then
            Config.Dead, Config.Timer, Doingtimer, PressingTime = true, 60, false, 5
            EventsModule.TriggerServer('mercy-hospital/server/set-dead-state', true)
            TriggerEvent('mercy-hospital/client/do-dead-on-player', true)
        else
            SetEntityMaxHealth(PlayerPedId(), 200)
            SetEntityHealth(PlayerPedId(), Player.MetaData['Health'])
            SetPedArmour(PlayerPedId(), Player.MetaData['Armor'])
        end
    end)
end