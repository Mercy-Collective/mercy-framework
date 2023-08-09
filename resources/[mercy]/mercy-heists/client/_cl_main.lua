EntityModule, LoggerModule, EventsModule, CallbackModule, FunctionsModule, PlayerModule = nil, nil, nil, nil, nil, nil
PlayerData = false, {}

local _Ready = false
AddEventHandler('Modules/client/ready', function()
    if not _Ready then
        _Ready = true
    end
    TriggerEvent('Modules/client/request-dependencies', {
        'Events',
        'Entity',
        'Logger',
        'Callback',
        'Functions',
        'Player',
    }, function(Succeeded)
        if not Succeeded then return end
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        EntityModule = exports['mercy-base']:FetchModule("Entity")
        LoggerModule = exports['mercy-base']:FetchModule('Logger')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')      

    end)
end)

RegisterNetEvent('mercy-base/client/on-login', function()
    Citizen.SetTimeout(450, function()
        function GetHeistConfig()
            local Config = CallbackModule.SendCallback('mercy-heists/server/get-config')
            return Config
        end  
        Config = GetHeistConfig()
        PlayerData = PlayerModule.GetPlayerData()
        Citizen.SetTimeout(150, function()
            InitJewellery() InitHouses()
            InitBobcat() InitZones()
            InitVault()
        end)
    end)
end)

RegisterNetEvent('mercy-base/client/on-job-update', function(JobData, DutyUpdate)
	PlayerData.Job = JobData
end)

-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('mercy-heists/client/banks/sync-data', function(BankType, BankKey, BankData)
    Config.Panels[BankType][BankKey] = BankData
end)

-- [ Functions ] --

function GetCurrentRobberyType()
    local Coords = GetEntityCoords(PlayerPedId())
    for k, v in pairs(Config.Zones) do
        local Distance = #(Coords - v['Coords'])
        if Distance < 30.0 then
            return v['Type']
        end
    end
end

function GetCurrentRobbery()
    local Coords = GetEntityCoords(PlayerPedId())
    for k, v in pairs(Config.Zones) do
        local Distance = #(Coords - v['Coords'])
        if Distance < 30.0 then
            return v
        end
    end
end

function IsWearingHandshoes()
    local ArmIndex, Model = GetPedDrawableVariation(PlayerPedId(), 3), GetEntityModel(PlayerPedId())
    if Model == GetHashKey("mp_m_freemode_01") then
        if Config.MaleNoHandshoes[ArmIndex] ~= nil and Config.MaleNoHandshoes[ArmIndex] then
            return false
        end
    elseif Model == GetHashKey("mp_f_freemode_01") then
        if Config.FemaleNoHandshoes[ArmIndex] ~= nil and Config.FemaleNoHandshoes[ArmIndex] then
            return false
        end
    end
    return true
end


