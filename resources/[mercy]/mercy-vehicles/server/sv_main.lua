CallbackModule, PlayerModule, FunctionsModule, DatabaseModule, CommandsModule, EventsModule = nil, nil, nil, nil, nil, nil
OccupiedTrunks = {}
VehicleMetas = {}
RecentlyImpounded = {}

local _Ready = false
AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Callback',
        'Player',
        'Functions',
        'Database',
        'Commands',
        'Events',
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
        DatabaseModule = exports['mercy-base']:FetchModule('Database')
        CommandsModule = exports['mercy-base']:FetchModule('Commands')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        _Ready = true
    end)
end)

-- [ Code ] --

Citizen.CreateThread(function() 
    while not _Ready do 
        Citizen.Wait(100) 
    end 

    -- [ Callbacks ] --

    -- Fuel

    local PaidForFuel = {}
    RegisterNetEvent("mercy-vehicles/server/fuel/send-bill", function(Plate, Cid, Amount, IsElectric)
        local src = source
        local Player = PlayerModule.GetPlayerBySource(src)
        local TargetPlayer = PlayerModule.GetPlayerByStateId(Cid)
        if not TargetPlayer then return end

        local NotifId = math.random(11111111, 99999999)
        TriggerClientEvent('mercy-phone/client/notification', TargetPlayer.PlayerData.Source, {
            Id = NotifId,
            Title = (IsElectric and "Charge" or "Fuel").." Payment Request",
            Message = "Plate: "..Plate..' - '..(IsElectric and 'Percentage: ' or 'Liters: ')..Amount,
            Icon = IsElectric and "fas fa-charging-station" or "fas fa-gas-pump",
            IconBgColor = "#4f5efc",
            IconColor = "white",
            Sticky = true,
            Duration = 30000,
            Buttons = {
                {
                    Icon = "fas fa-times-circle",
                    Event = "mercy-vehicles/server/fuel/decline-pay-request",
                    EventType = "Server",
                    EventData = {
                        ['NotifId'] = NotifId,
                    },
                    Tooltip = "Decline",
                    Color = "#f2a365",
                    CloseOnClick = true,
                },
                {
                    Icon = "fas fa-check-circle",
                    Event = "mercy-vehicles/server/fuel/accept-pay-request",
                    EventType = "Server",
                    EventData = {
                        ['NotifId'] = NotifId,
                        ['Source'] = TargetPlayer.PlayerData.Source,
                        ['Plate'] = Plate,
                        ['Amount'] = Amount,
                        ['Electric'] = IsElectric,
                    },
                    Tooltip = "Pay",
                    Color = "#2ecc71",
                    CloseOnClick = true,
                },
            },
        })
    end)

    RegisterNetEvent("mercy-vehicles/server/fuel/set-paid-state", function(Plate)
        local src = source
        local Player = PlayerModule.GetPlayerBySource(src)
        PaidForFuel[Plate] = false
    end)

    RegisterNetEvent("mercy-vehicles/server/fuel/accept-pay-request", function(Data)
        local Player = PlayerModule.GetPlayerBySource(Data.Source)
        TriggerClientEvent('mercy-phone/client/hide-notification', Data.Source, Data['NotifId'])
        if Player then
            local Amount = Data.Electric and math.floor((Data.Amount * Config.ChargePrice) * 1.17) or math.floor((Data.Amount * Config.FuelPrice) * 1.17)
            if Player.Functions.RemoveMoney('Bank', Amount) then
                PaidForFuel[Data.Plate] = true
            else
                Player.Functions.Notify('not-money', 'You do not have enough money to pay for the fuel..', 'error')
            end
        end
    end)

    RegisterNetEvent("mercy-vehicles/server/fuel/decline-pay-request", function(Data)
        TriggerClientEvent('mercy-phone/client/hide-notification', Data.Source, Data['NotifId'])
    end)

    CallbackModule.CreateCallback('mercy-vehicles/server/fuel/is-bill-paid', function(Source, Cb, Plate)
        if PaidForFuel[Plate] == nil then
            PaidForFuel[Plate] = false
        end
        Cb(PaidForFuel[Plate])
    end)

    -- Keys

    CallbackModule.CreateCallback('mercy-vehicles/server/get-keys', function(Source, Cb)
        Cb(Config.VehicleKeys)
    end)
    
    -- Garage

    CallbackModule.CreateCallback('mercy-vehicles/server/get-vehicle-position', function(Source, Cb, Plate)
        DatabaseModule.Execute('SELECT * FROM player_vehicles WHERE plate = ?', {
            Plate
        }, function(Vehicle)
            if Vehicle[1] ~= nil then
                if (Vehicle[1].state == 'In') then
                    if Config.Garages[Vehicle[1].garage] ~= nil then
                        Cb({Config.Garages[Vehicle[1].garage].Spots[1], 'Vehicle is parked.'})
                    else
                        Cb(false)
                    end
                else
                    if Vehicle[1].state == 'Out' then
                        -- Check if in world
                        for k, v in pairs(GetAllVehicles()) do
                            if (GetVehicleNumberPlateText(v) == Plate) then
                                local Vehicle = GetEntityCoords(v)
                                return Cb({{
                                    x = Vehicle.x,
                                    y = Vehicle.y,
                                }, 'Vehicle is outside garage.'})
                            end
                        end

                        -- Check if in Depot
                        if Vehicle[1].garage == 'depot' and Vehicle[1].state == 'In' then
                            Cb({Config.DepotSpots[1], 'Vehicle is in depot.'})
                        else
                            Cb(false)
                        end

                        -- Check if in Garage
                        if Config.Garages[Vehicle[1].garage] ~= nil then
                            Cb({Config.Garages[Vehicle[1].garage].Spots[1], 'Vehicle is parked.'})
                        else
                            Cb(false)
                        end
                    end
                end
            else
                Cb(false)
            end
        end)
    end)

    CallbackModule.CreateCallback('mercy-vehicles/server/get-garage-vehs', function(Source, Cb, Garage)
        local Player = PlayerModule.GetPlayerBySource(Source)
        DatabaseModule.Execute("SELECT * FROM player_vehicles WHERE garage = ? AND citizenid = ? ", {Garage, Player.PlayerData.CitizenId}, function(VehData)
            if VehData ~= nil and VehData[1] ~= nil then
                Cb(VehData)
            else
                Cb({})
            end
        end, true)
    end)

    CallbackModule.CreateCallback('mercy-vehicles/server/can-spawn-vehicle', function(Source, Cb, Plate)
        DatabaseModule.Execute('SELECT * FROM player_vehicles WHERE plate = ?', {
            Plate
        }, function(Vehicle)
            if Vehicle[1] ~= nil then
                if (Vehicle[1].state == 'In') then
                    Cb(true)
                else
                    Cb(false)
                end
            else
                Cb(false)
            end
        end)
    end)

    CallbackModule.CreateCallback('mercy-vehicles/server/get-veh-by-plate', function(Source, Cb, Plate)
        local Player = PlayerModule.GetPlayerBySource(Source)
        DatabaseModule.Execute("SELECT * FROM player_vehicles WHERE plate = ? AND citizenid = ? ", {Plate, Player.PlayerData.CitizenId}, function(VehData)
            if VehData ~= nil and VehData[1] ~= nil then
                Cb(VehData[1])
            else
                Cb({})
            end
        end, true)
    end)

    CallbackModule.CreateCallback('mercy-vehicles/server/can-retreive-veh', function(Source, Cb, Plate)
        DatabaseModule.Execute('SELECT * FROM player_vehicles WHERE plate = ?', {
            Plate
        }, function(Vehicle)
            if Vehicle[1] ~= nil then
                local ImpoundData = json.decode(Vehicle[1].impounddata)
                if ImpoundData ~= nil  then
                    if os.time() > ImpoundData['RetainedUntil'] then -- 
                        Cb(true)
                    else
                        Cb(false)
                    end
                else
                    Cb(true)
                end
            else
                Cb(false)
            end
        end)
    end)

    CallbackModule.CreateCallback('mercy-vehicles/server/pay-release-fee', function(Source, Cb, Plate, Amount)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.RemoveMoney('Bank', Amount) then
            Cb(true)
        else
            Cb(false)
        end
    end)
    
    CallbackModule.CreateCallback('mercy-vehicles/server/get-depot-vehicles', function(Source, Cb)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local DepotVehs = {}
        DatabaseModule.Execute("SELECT * FROM player_vehicles WHERE garage = ? AND state = ? AND citizenid = ?", {'depot', 'In', Player.PlayerData.CitizenId}, function(VehData)
            if VehData ~= nil and VehData[1] ~= nil then
                for k, v in pairs(VehData) do
                    if v.impounddata ~= nil then
                        table.insert(DepotVehs, v)
                    end
                end
                Cb(DepotVehs)
            else
                Cb({})
            end
        end, true)
    end)

    CallbackModule.CreateCallback('mercy-vehicles/client/get-recent-depots', function(Source, Cb)
        Cb(RecentlyImpounded)
    end)

    CallbackModule.CreateCallback('mercy-vehicles/server/is-veh-owner', function(Source, Cb, Plate)
        if Plate ~= nil and Plate ~= false then
            DatabaseModule.Execute("SELECT * FROM player_vehicles WHERE plate = ? ", {Plate}, function(VehData)
                local Player = PlayerModule.GetPlayerBySource(Source)
                if VehData ~= nil and VehData[1] ~= nil then
                    if VehData[1].citizenid == Player.PlayerData.CitizenId then
                        Cb(true)
                    else
                        Cb(false)
                    end
                else
                    Cb(false)
                end
            end, true)
        else
            Cb(false)
        end
    end)

    -- Trunk

    CallbackModule.CreateCallback('mercy-vehicles/server/is-trunk-empty', function(Source, Cb, Plate)
        if OccupiedTrunks[Plate] then
            Cb(false)
        else
            Cb(true)
        end
    end)

    -- [ Commands ] --

    CommandsModule.Add("givekeys", "Give keys from your vehicle", {}, false, function(Source, args)
        TriggerClientEvent('mercy-vehicles/client/give-keys', Source)
    end)
    
    CommandsModule.Add("getkeys", "Get keys of vehicle", {}, false, function(Source, args)
        TriggerClientEvent('mercy-vehicles/client/get-keys', Source)
    end, 'god')

    CommandsModule.Add("door", "/door open 0-7 or /door close 0-7", {{Name="State", Help="State"}, {Name="Door", Help="Door"}}, false, function(Source, args)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local State = args[1]
        local DoorId = tonumber(args[2])
        if (State ~= nil and (State == 'close' or State == 'open')) and (DoorId ~= nil and (DoorId <= 7 and DoorId >= 0)) then
            TriggerClientEvent('mercy-vehicles/client/toggle-door', Source, State, DoorId)
        else
            Player.Functions.Notify('error-doors', 'An error occurred.', 'error')
        end
    end)

    CommandsModule.Add("seat", "/seat -1 or /seat 5", {{Name="Seat", Help="Seat"}}, false, function(Source, args)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local SeatId = tonumber(args[1])
        if SeatId >= -1 and SeatId <= 5 then
            TriggerClientEvent('mercy-vehicles/client/switch-seat', Source, SeatId, false)
        else
            Player.Functions.Notify('error-doors', 'An error occurred.', 'error')
        end
    end)

    CommandsModule.Add("forceintrunk", "Force player into trunk", {}, false, function(Source, args)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local Data = {}
        Data.Forced = true
        TriggerClientEvent('mercy-vehicles/client/get-in-trunk', Source, Data)
    end)

    -- [ Events ] --
    
    EventsModule.RegisterServer("mercy-vehicles/server/receive-rental-papers", function(Source, RandomPlate)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local Info = {}
        Info.Plate = RandomPlate
        Player.Functions.AddItem('rental-papers', 1, false, Info, true)
    end)
end)

-- [ Events ] --
-- Garages

RegisterNetEvent("mercy-vehicles/server/send-message-to-impound", function()
    for k, v in pairs(PlayerModule.GetPlayers()) do
        local Player = PlayerModule.GetPlayerBySource(v)
        if exports['mercy-business']:IsPlayerInBusiness(Player, 'Los Santos Depot') then
            TriggerClientEvent('mercy-chat/client/post-message', Player.PlayerData.Source, "Help is required at the depot!", "normal")
        end
    end
end)

RegisterNetEvent("mercy-vehicles/server/park-vehicle", function(VehNet, CurrentGarage)
    local Vehicle = NetworkGetEntityFromNetworkId(VehNet)
    local Plate = GetVehicleNumberPlateText(Vehicle)
    DeleteEntity(Vehicle)
    DatabaseModule.Update("UPDATE player_vehicles SET garage = ?, state = ? WHERE plate = ? ", {CurrentGarage, 'In', Plate}, function(Result)
    end)
end)

RegisterNetEvent("mercy-vehicles/server/set-veh-state", function(Plate, State, NetId)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    local Veh = NetworkGetEntityFromNetworkId(NetId)
    if State:lower() ~= 'out' then return end

    DatabaseModule.Execute('SELECT * FROM player_vehicles WHERE plate = ?', {
        Plate
    }, function(Result)
        if Result[1] == nil then return end
        local ImpoundData = {
            Reason = "Illegal parking.",
            Fee = 200,
            Strikes = 0,
            RetainedUntil = os.time(),
            ImpoundDate = os.date("%d/%m/%Y %H:%M", os.time()),
            Plate = Plate,
            Issuer = "LSPD",
            ReleaseTxt = os.date("%d/%m/%Y %H:%M", os.time()), -- 4 hours default
            Vehicle = GetEntityModel(Veh),
            VIN = Result[1].vin,
        }
        DatabaseModule.Update("UPDATE player_vehicles SET garage = ?, state = ?, impounddata = ? WHERE plate = ?", {'depot', State, json.encode(ImpoundData), Plate})
    end)

end)

RegisterNetEvent("mercy-vehicles/server/depot-vehicle", function(NetId, ImpoundId, InputResult)
    local Vehicle = NetworkGetEntityFromNetworkId(NetId)
    local Plate = GetVehicleNumberPlateText(Vehicle)
    local Player = PlayerModule.GetPlayerBySource(source)
    DatabaseModule.Execute("SELECT * FROM player_vehicles WHERE plate = ? ", {Plate}, function(VehData)
        if VehData ~= nil and VehData[1] ~= nil then
            local ImpoundData = {
                Reason = InputResult ~= nil and InputResult['Reason'] or "Not provided.",
                Fee = InputResult ~= nil and InputResult['Fee'] or 200,
                Strikes = InputResult ~= nil and InputResult['Strikes'] or 1,
                RetainedUntil = InputResult ~= nil and os.time() + (InputResult["RetainedUntil"]*3600) or os.time() + 14400, -- 4 hours default
                ImpoundDate = os.date("%d/%m/%Y %H:%M", os.time()),
                Plate = Plate,
                Issuer = Player.PlayerData.CharInfo.Firstname.." "..Player.PlayerData.CharInfo.Lastname,
                ReleaseTxt = os.date("%d/%m/%Y %H:%M", InputResult ~= nil and (os.time() + (InputResult["RetainedUntil"] * 3600)) or (os.time() + 14400)), -- 4 hours default
                Vehicle = GetEntityModel(Vehicle),
                VIN = VehData[1].vin,
            }
            DatabaseModule.Update("UPDATE player_vehicles SET garage = ?, state = ?, impounddata = ? WHERE plate = ? ", {
                'depot', 
                'In', 
                json.encode(ImpoundData),
                Plate,
            }, function(Result)
                RecentlyImpounded[#RecentlyImpounded+1] = ImpoundData
                -- Reverse order of table
                if #RecentlyImpounded > 0 then
                    local TempTable = {}
                    for i = #RecentlyImpounded, 1, -1 do
                        TempTable[#TempTable+1] = RecentlyImpounded[i]
                    end
                    RecentlyImpounded = TempTable
                end
                DeleteEntity(Vehicle)
            end)
        else -- NPC Vehicle
            DeleteEntity(Vehicle)
        end
    end, true)
end)

AddEventHandler('onResourceStart', function(Resource)
    if Resource == GetCurrentResourceName() then
        while DatabaseModule == nil do Citizen.Wait(10) end
        DatabaseModule.Execute('SELECT state FROM player_vehicles WHERE garage = ? AND state = ?', {
            'depot',
            'Out'
        }, function(Result)
            if Result[1] == nil then return end
            local ImpoundData = {
                Reason = "Illegal Parking.",
                Fee = 200,
                Strikes = 0,
                RetainedUntil = os.time(),
                ImpoundDate = os.date("%d/%m/%Y %H:%M", os.time()),
                Plate = Result.plate,
                Issuer = "LSPD",
                ReleaseTxt = os.date("%d/%m/%Y %H:%M", os.time()), -- 4 hours default
                Vehicle = Result.vehicle,
                VIN = Result.vin,
            }
            
            DatabaseModule.Update('UPDATE player_vehicles SET state = ?, impounddata = ? WHERE garage = ? AND state = ?', { 'In', json.encode(ImpoundData), 'depot', 'Out' })
        end)
    end
end)

-- Metas

RegisterNetEvent("mercy-vehicles/server/load-veh-meta", function(NetId, Data)
    local Vehicle = NetworkGetEntityFromNetworkId(NetId)
    local Meta = Entity(Vehicle).state.meta

    -- Set meta firsttime
    if Meta == nil then
        Entity(Vehicle).state:set('meta', Config.DefaultMeta, true)
        return
    end

    if Data == nil then
        return
    end
    -- Update
    Entity(Vehicle).state:set('meta', Data, true)
end)

RegisterNetEvent("mercy-vehicles/server/set-veh-meta", function(NetId, Key, Value)
    local Vehicle = NetworkGetEntityFromNetworkId(NetId)
    local Meta = Entity(Vehicle).state.meta
    if Meta == nil then
        Entity(Vehicle).state:set('meta', Config.DefaultMeta, true)
        return
    end

    if Value == nil then
        return
    end
    
    Meta[Key] = Value
    Entity(Vehicle).state:set('meta', Meta, true)
end)

-- Keys

RegisterNetEvent("mercy-vehicles/server/set-keys", function(Plate, Bool, CitizenId)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    if CitizenId then
        if Config.VehicleKeys[Plate] ~= nil then
            Config.VehicleKeys[Plate][CitizenId] = Bool
        else
            Config.VehicleKeys[Plate] = {}
            Config.VehicleKeys[Plate][CitizenId] = Bool
        end
    else
        if Config.VehicleKeys[Plate] ~= nil then
            Config.VehicleKeys[Plate][Player.PlayerData.CitizenId] = Bool
        else
            if Plate == nil then return end
            Config.VehicleKeys[Plate] = {}
            Config.VehicleKeys[Plate][Player.PlayerData.CitizenId] = Bool
        end
    end

    TriggerClientEvent('mercy-vehicles/client/set-veh-keys', -1, Plate, Config.VehicleKeys[Plate])
end)

-- Nitrous

RegisterNetEvent("mercy-vehicles/server/set-vehicle-purge", function(VehNet, Bool)
    TriggerClientEvent('mercy-vehicles/client/set-vehicle-purge', -1, VehNet, Bool)
end)

RegisterNetEvent("mercy-vehicles/server/set-vehicle-flames", function(VehNet, Bool)
    TriggerClientEvent('mercy-vehicles/client/set-vehicle-flames', -1, VehNet, Bool)
end)

-- Sirens

RegisterNetEvent("mercy-vehicles/server/mute-sirens", function(NetId)
    TriggerClientEvent('mercy-vehicles/client/mute-sirens', -1, NetId)
end)

-- Trunks

RegisterNetEvent("mercy-vehicles/server/set-trunk-occupied", function(Plate, Bool)
    OccupiedTrunks[Plate] = Bool
end)
