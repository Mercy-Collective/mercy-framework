local RecentlyImpounded = {}

CreateThread(function()
    while not _Ready do
        Wait(100) 
    end

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
end)

-- [ Events ] --

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
    if Resource ~= GetCurrentResourceName() then return end
    while DatabaseModule == nil do Wait(10) end
    
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
end)