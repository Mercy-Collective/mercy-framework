FunctionsModule, CallbackModule, EventsModule, PlayerModule, VehicleModule = nil
local CustomerLoc, playerBusiness = {}, nil
ClockedData = {Business = 'None', Clocked = false}

AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
        'Callback',
        'Functions',
        'Events',
        'Player',
        'Vehicle',
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        VehicleModule = exports['mercy-base']:FetchModule('Vehicle')
    end)
end)

RegisterNetEvent('mercy-base/client/on-login', function()
    Citizen.SetTimeout(3000, function()
        InitZones()
        InitFoodzones()
        InitHayes()
    end)
end)


-- [ Code ] --

Citizen.CreateThread(function()
    while CallbackModule == nil do Citizen.Wait(100) end

    -- Uwu Café
    exports['mercy-ui']:AddEyeEntry("uwu-random-order-1", {
        Type = 'Zone',
        SpriteDistance = 1.61,
        Distance = 1.6,
        ZoneData = {
            Center = vector3(-594.3, -1054.19, 22.34),
            Length = 1.2,
            Width = 0.2,
            Data = {
                debugPoly = false,
                heading = 0,
                minZ = 22.54,
                maxZ = 23.54,
            },
        },
        Options = {
            {
                Name = 'foodchain-uwu-start-job-1',
                Icon = 'fas fa-circle',
                Label = 'Get Order',
                EventType = 'Client',
                EventName = 'mercy-business/client/send-order',
                EventParams = 'UwU Café',
                Enabled = function()
                    if exports['mercy-business']:IsPlayerInBusiness('UwU Café') then
                        return true
                    end
                end,
            },
            {
                Name = 'foodchain-uwu-end-job-1',
                Icon = 'fas fa-circle',
                Label = 'End Job',
                EventType = 'Client',
                EventName = 'mercy-business/client/end-job',
                EventParams = '',
                Enabled = function()
                    if exports['mercy-business']:IsPlayerInBusiness('UwU Café') then
                        return true
                    end
                end,
            },
        }
    })
end)

-- [ Events ] --

RegisterNetEvent('mercy-business/client/open-stash', function(Data, Entity)
    if Data.Stash == nil or Data.Business == nil then return end
    if not HasPlayerBusinessPermission(Data.Business, 'stash_access') then return end
    Citizen.SetTimeout(350, function()
        if exports['mercy-inventory']:CanOpenInventory() then
            EventsModule.TriggerServer('mercy-inventory/server/open-other-inventory', Data.Stash, 'Stash', 40, 700.0)
        end
    end)
end)

RegisterNetEvent('mercy-business/client/send-order', function(Data)
    Citizen.CreateThread(function()
        while CallbackModule == nil do Citizen.Wait(100) end
        playerBusiness = Data
        Citizen.Wait(math.random(5000, 15000))
        local NPCorder = randomLocFoodChain(Data)
        TriggerServerEvent("mercy-phone/server/mails/send-mail", NPCorder.Title, "#A-1001", NPCorder.OrderMail ..' $'.. NPCorder.price)
        FunctionsModule.ClearCustomGpsRoute()
        Citizen.Wait(500)
        GPSRouteFoodChain(NPCorder.center)
        exports['mercy-ui']:AddEyeEntry(NPCorder.name, {
            Type = 'Zone',
            SpriteDistance = 10.0,
            Distance = 1.5,
            ZoneData = {
                Center = NPCorder.center,
                Length = NPCorder.length,
                Width = NPCorder.width,
                Data = {
                    heading = NPCorder.heading,
                    minZ = NPCorder.minZ,
                    maxZ = NPCorder.maxZ
                },
            },
            Options = NPCorder.options
        })
        exports['mercy-ui']:Notify("not-cooking", "You have a new order", 'success')
    end)
end)

RegisterNetEvent('mercy-business/client/deliver-order', function(Data)
    if Data.RequestItem == nil or exports['mercy-inventory']:HasEnough(Data.RequestItem) then
        exports['mercy-inventory']:SetBusyState(true)
        exports['mercy-ui']:ProgressBar('Siparişleri Veriyosun', 4500, false, false, true, true, function(DidComplete)
            if DidComplete then
                EventsModule.TriggerServer('mercy-business/server/give-reward', Data.RequestItem, playerBusiness, CustomerLoc.price)
                exports['mercy-inventory']:SetBusyState(false)
                TriggerEvent('mercy-business/client/send-order', playerBusiness)
            end
        end)
    else
        exports['mercy-ui']:Notify("not-cooking", "You don't have the right menu!", 'error')
    end
end)

RegisterNetEvent('mercy-business/client/end-job', function()
    FunctionsModule.ClearCustomGpsRoute()
    CustomerLoc = nil
end)

-- [ Functions ] --

function IsPlayerInBusiness(Name)
    local Promise = promise:new()
    local Player = PlayerModule.GetPlayerData()
    local BusinessData = CallbackModule.SendCallback('mercy-business/server/get-specific-business', Name)
    if BusinessData ~= false then
        if BusinessData.Owner == Player.CitizenId then
            Promise:resolve(true)
        end
        for Employee, Employees in pairs(BusinessData.Employees) do
            if Employees.CitizenId == Player.CitizenId then
                Promise:resolve(true)
            end
        end
        Promise:resolve(false)
    else
        Promise:resolve(false)
    end
    return Citizen.Await(Promise)
end
exports("IsPlayerInBusiness", IsPlayerInBusiness)

function HasPlayerBusinessPermission(Name, Permission)
    local Promise = promise:new()
    local Player = PlayerModule.GetPlayerData()
    local BusinessData = CallbackModule.SendCallback('mercy-business/server/get-specific-business', Name)
    if BusinessData ~= false then
        if BusinessData.Owner == Player.CitizenId then
            Promise:resolve(true)
        end
        for Employee, Employees in pairs(BusinessData.Employees) do
            if Employees.CitizenId == Player.CitizenId and BusinessData.Ranks[Employees.Rank] ~= nil and BusinessData.Ranks[Employees.Rank].Permissions[Permission] ~= nil and BusinessData.Ranks[Employees.Rank].Permissions[Permission] then
                Promise:resolve(true)
            end
        end
        Promise:resolve(false)
    else
        Promise:resolve(false)
    end
    return Citizen.Await(Promise)
end
exports("HasPlayerBusinessPermission", HasPlayerBusinessPermission)

-- [ Functions ] --

function randomLocFoodChain(Data)
    local RandomOrder = Config.FoodChainOrders[Data][math.random(1, #Config.FoodChainOrders[Data])]
    CustomerLoc = RandomOrder
    return RandomOrder
end

function GPSRouteFoodChain(tCoords)
    local Result = tCoords
    local CoordsTable = {
        { Coords = GetEntityCoords(PlayerPedId()) },
        { Coords = vector3(Result.x, Result.y, Result.z) }
    }
    FunctionsModule.CreateCustomGpsRoute(CoordsTable, true)
end

exports("NearCustomerLoc", function()
    if CustomerLoc == nil then return false end

    local Coords = GetEntityCoords(PlayerPedId())
    if #(Coords - CustomerLoc.center) < 10.0 then
        return true
    end

    return false
end)

function GetClockedData()
    return ClockedData
end
exports('GetClockedData', GetClockedData)
