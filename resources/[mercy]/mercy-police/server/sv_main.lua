CallbackModule, PlayerModule, FunctionsModule, DatabaseModule, CommandsModule, EventsModule = nil, nil, nil, nil, nil, nil
local PlayerStatus, Evidence, VehicleRecords = {}, {}, {}

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

CreateThread(function()
    while not _Ready do
        Wait(500)
    end

    -- [ Callbacks ] --

    CallbackModule.CreateCallback('mercy-police/server/get-all-cops-db', function(Source, Cb)
        local Cops = {}
        local Promise = promise:new()
        DatabaseModule.Execute("SELECT * FROM players", {}, function(Players)
            if Players ~= nil then
                -- Get From Database
                for k, v in pairs(Players) do
                    local JobInfo = json.decode(v.Job)
                    if JobInfo.Name == 'police' then
                        local Cop = {}
                        Cop.CitizenId = v.CitizenId
                        Cop.Name = v.Name
                        Cop.Job = JobInfo
                        table.insert(Cops, Cop)
                    end
                end
                -- Get Online
                for k, v in pairs(PlayerModule.GetPlayers()) do
                    local Player = PlayerModule.GetPlayerBySource(v)
                    if Player ~= nil then 
                        if (Player.PlayerData.Job.Name == "police") then
                        --    Check if person is already in Cops table
                            local Found = false
                            for k, v in pairs(Cops) do
                                if v.CitizenId == Player.PlayerData.CitizenId then
                                    Found = true
                                end
                            end
                            if not Found then
                                local Cop = {}
                                Cop.CitizenId = Player.PlayerData.CitizenId
                                Cop.Name = Player.PlayerData.CharInfo.Firstname..' '..Player.PlayerData.CharInfo.Lastname
                                Cop.Job = Player.PlayerData.Job
                                table.insert(Cops, Cop)
                            end
                        end
                    end
                end
                Promise:resolve(Cops)
            end
        end)
        Cb(Citizen.Await(Promise))
    end)

    CallbackModule.CreateCallback('mercy-police/server/get-active-cops', function(Source, Cb)
        local CopAmount = 0
        local Promise = promise:new()
        for k, v in pairs(PlayerModule.GetPlayers()) do
            local Player = PlayerModule.GetPlayerBySource(v)
            if Player ~= nil then 
                if (Player.PlayerData.Job.Name == "police" and Player.PlayerData.Job.Duty) then
                    CopAmount = CopAmount + 1
                end
            end
        end
        Promise:resolve(CopAmount)
        Cb(Citizen.Await(Promise))
    end)

    CallbackModule.CreateCallback('mercy-police/server/is-plate-flagged', function(Source, Cb, Plate)
        DatabaseModule.Execute("SELECT * FROM player_vehicles WHERE plate = ? ", {Plate}, function(VehData)
            if VehData ~= nil and VehData[1] ~= nil then
                Cb(VehData[1])
            else
                Cb(false)
            end
        end)
    end)

    CallbackModule.CreateCallback('mercy-police/server/get-vehicle-data', function(Source, Cb, Plate)
        DatabaseModule.Execute("SELECT * FROM player_vehicles WHERE plate = ?  ", {Plate}, function(VehData)
            if VehData ~= nil then
                local VehicleData = {}
                for k, v in pairs(VehData) do
                    local Player = PlayerModule.GetPlayerByStateId(tonumber(v.citizenid))
                    if Player then
                        VehicleData.Plate = v.plate
                        VehicleData.Owner = Player.PlayerData.CharInfo.Firstname..' '..Player.PlayerData.CharInfo.Lastname
                        VehicleData.CitizenId = v.citizenid
                        VehicleData.Vin = v.vin
                        VehicleData.Model = Shared.Vehicles[GetHashKey(v.vehicle)]['Name']
                        VehicleData.Flagged = v.Flagged
                        VehicleData.FlagReason = v.FlagReason
                    else
                        Cb(false)
                    end
                end
                Cb(next(VehicleData) ~= nil and VehicleData or false)
            else
                Cb(false)
            end
        end)
    end)

    CallbackModule.CreateCallback('mercy-police/server/get-garage', function(Source, Cb, Type)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local VehicleList = {}
        DatabaseModule.Execute("SELECT * FROM player_vehicles WHERE citizenid = ? AND state = ? ", {Player.PlayerData.CitizenId, Type}, function(VehData)
            if VehData ~= nil and VehData[1] ~= nil then
                for k, v in pairs(VehData) do
                    local PolVehicle = {}
                    PolVehicle.Label = Shared.Vehicles[GetHashKey(v.vehicle)]['Name']
                    PolVehicle.Plate = v.plate
                    PolVehicle.Vehicle = v.vehicle
                    PolVehicle.Damage = json.decode(v.damage)
                    PolVehicle.Metadata = json.decode(v.metadata)
                    table.insert(VehicleList, PolVehicle)
                end
                Cb(VehicleList)
            else
                Cb(false)
            end
        end)
    
    end)
    
    CallbackModule.CreateCallback('mercy-police/server/get-vehicle-state', function(Source, Cb, Plate)
        local Player = PlayerModule.GetPlayerBySource(Source)
        DatabaseModule.Execute("SELECT * FROM player_vehicles WHERE citizenid = ? AND plate = ? ", {Player.PlayerData.CitizenId, Plate}, function(VehData)
            if VehData ~= nil and VehData[1] ~= nil then
                Cb(VehData[1].state)
            end
        end)
    end)        

    -- [ Commands ] --

    CommandsModule.Add("911", "Call emergency services", {{Name="Message", Help="Message"}}, false, function(source, args)
        local Player = PlayerModule.GetPlayerBySource(source)
        local CallData = {}
        CallData['Id'] = source
        CallData['Who'] = Player.PlayerData.CharInfo.Firstname..' '..Player.PlayerData.CharInfo.Lastname
        CallData['Message'] = table.concat(args, ' ')
        TriggerClientEvent('mercy-police/client/send-911', source, CallData, false)
    end)

    CommandsModule.Add("911a", "Call emergency services anonymously", {{Name="Message", Help="Message"}}, false, function(source, args)
        local CallData = {}
        CallData['Message'] = table.concat(args, ' ')
        TriggerClientEvent('mercy-police/client/send-911', source, CallData, true)
    end)

    -- CommandsModule.Add("911r", "Reply on a 911 call", {{Name="Id", Help="Id"}, {Name="Message", Help="Message"}}, false, function(source, args)
    --     local Player = PlayerModule.GetPlayerBySource(source)
    --     local Target = args[1]             
    --     args[1] = "" 
    --     local CallData = {}
    --     CallData['Id'] = source
    --     CallData['Who'] = Player.PlayerData.CharInfo.Firstname..' '..Player.PlayerData.CharInfo.Lastname
    --     CallData['Message'] = table.concat(args, ' ')
    --     TriggerClientEvent('mercy-police/client/send-reaction-to-dispatch', -1, CallData)
    -- end)

    -- CommandsModule.Add("911ra", "Reply Anonymously on a 911 call", {{Name="Id", Help="Id"}, {Name="Message", Help="Message"}}, false, function(source, args)
    --     local Player = PlayerModule.GetPlayerBySource(source)
    --     local Target = args[1]             
    --     args[1] = "" 
    --     if Player.PlayerData.Job.Name == 'police' or Player.PlayerData.Job.Name == 'ems' and Player.PlayerData.Job.Duty then
    --         local CallData = {}
    --         CallData['Id'] = source
    --         CallData['Message'] = table.concat(args, ' ')
    --         TriggerClientEvent('mercy-police/client/send-911-dispatch', Target, CallData, true)
    --     end
    -- end)

    CommandsModule.Add("callsign", "View callsign", {}, false, function(source, args)
        local Player = PlayerModule.GetPlayerBySource(source)
        if Player.PlayerData.Job.Name ~= 'police' then return end
        TriggerClientEvent('mercy-chat/client/post-message', source, 'DEPARTMENT', Player.PlayerData.Job.Callsign, 'warning')
    end)

    CommandsModule.Add("setcallsign", "Set callsign", {{Name="Callsign", Help="Callsign"}}, false, function(source, args)
        local Player = PlayerModule.GetPlayerBySource(source)
        local Callsign = args[1]
        if Callsign ~= nil then
            if Player.PlayerData.Job.Name == 'police' or Player.PlayerData.Job.Name == 'ems' and Player.PlayerData.Job.Duty then
                Player.Functions.SetCallsign(Callsign)
                Player.Functions.Notify('sign-changed', 'Callsign succesfully changed. You now are the: '..Callsign, 'success')
            else
                Player.Functions.Notify('no-perm', 'No Permission..', 'error')
            end
        end
    end)

    CommandsModule.Add("department", "View your department", {}, false, function(source, args)
        local Player = PlayerModule.GetPlayerBySource(source)
        if Player.PlayerData.Job.Name ~= 'police' then return end
        TriggerClientEvent('mercy-chat/client/post-message', source, 'DEPARTMENT', Player.PlayerData.Job.Department, 'warning')
    end)
    
    CommandsModule.Add("setdepartment", "Set your department (LSPD/BCSO/SASP)", {{Name="Department", Help="Department"}}, false, function(source, args)
        local Player = PlayerModule.GetPlayerBySource(source)
        local Department = args[1]
        if Department ~= nil and Department == 'LSPD' or Department == 'BCSO' or Department == 'SASP' then
            if Player.PlayerData.Job.Name == 'police' or Player.PlayerData.Job.Name == 'ems' and Player.PlayerData.Job.Duty then
                Player.Functions.SetDepartment(Department)
                Player.Functions.Notify('sign-changed', 'Department succesfully changed. You now on the '..Department..'  department.', 'success')
            else
                Player.Functions.Notify('no-perm', 'No Permission..', 'error')
            end
        end
    end)
    
    CommandsModule.Add({"sethighcommand", "sethigh"}, "Set someone's highcommand status", {{Name="ID", Help="PlayerId"}, {Name="Status", Help="True/False"}}, true, function(source, args)
        if args ~= nil then
            local Player = PlayerModule.GetPlayerBySource(source)
            local TargetPlayer = PlayerModule.GetPlayerBySource(tonumber(args[1]))
            if TargetPlayer ~= nil then
                if args[2]:lower() == 'true' then
                    TargetPlayer.Functions.SetHighCommand(true)
                    TargetPlayer.Functions.Notify('got-highcom', 'You now are highcommand!', 'success')
                    Player.Functions.Notify('got-highcom-giv', 'Person now has highcommand!', 'success')
                else
                    TargetPlayer.Functions.SetHighCommand(false)
                    TargetPlayer.Functions.Notify('got-no-highcom', 'You are no longer highcommand!', 'error')
                    Player.Functions.Notify('no-highcom', 'Person is no longer highcommand!', 'error')
                end
                TargetPlayer.Functions.Save()
            end
        end
    end, "admin")

    CommandsModule.Add({"cuff"}, "(Un)cuff a player", {{Name="Id", Help="Player ID"}, {Name="Bool", Help="True or False"}}, true, function(source, args)
        local Player = PlayerModule.GetPlayerBySource(source)
        local TargetPlayer = PlayerModule.GetPlayerBySource(tonumber(args[1]))
        if TargetPlayer then
            local Bool = args[2]:lower() == 'true' and true or false
            TargetPlayer.Functions.SetMetaData("Handcuffed", Bool)
            TriggerClientEvent('mercy-police/client/set-cuff-state', TargetPlayer.PlayerData.Source, Bool)
        end
    end, "admin")

    CommandsModule.Add({"fine"}, "Give a fine", {}, true, function(source, args)
        TriggerClientEvent('mercy-police/client/give-fine', source)
    end)
    
    CommandsModule.Add({"setpolice", "setpol"}, "Hire an officer", {{Name="id", Help="Player ID"}}, true, function(source, args)
        local Player = PlayerModule.GetPlayerBySource(source)
        local TargetPlayer = PlayerModule.GetPlayerBySource(tonumber(args[1]))
        if Player.PlayerData.Job['HighCommand'] then
            if TargetPlayer then
                TargetPlayer.Functions.Notify('got-hired-off', 'You got hired at the PD!', 'success')
                Player.Functions.Notify('hired-off', 'You hired '..TargetPlayer.PlayerData.CharInfo.Firstname..' '..TargetPlayer.PlayerData.CharInfo.Lastname..'!', 'success')
                TargetPlayer.Functions.SetJob('police')
                TargetPlayer.Functions.Save()
            end
        end
    end)
    
    CommandsModule.Add({"firepolice", "firepol"}, "Fire an officer", {{Name="id", Help="Player ID"}}, true, function(source, args)
        local Player = PlayerModule.GetPlayerBySource(source)
        local TargetPlayer = PlayerModule.GetPlayerBySource(tonumber(args[1]))
        if Player.PlayerData.Job['HighCommand'] then
            if TargetPlayer and TargetPlayer.PlayerData.Job.Name == 'police' then
                TargetPlayer.Functions.Notify('got-fired-off', 'You got fired!', 'error')
                Player.Functions.Notify('fired-off', 'You fired '..TargetPlayer.PlayerData.CharInfo.Firstname..' '..TargetPlayer.PlayerData.CharInfo.Lastname..'!', 'success')
                TargetPlayer.Functions.SetJob('unemployed')
                TargetPlayer.Functions.Save()
            else
                Player.Functions.Notify('not-police', 'This person is not a police officer!', 'error')
            end
        end
    end)

    CommandsModule.Add("flagplate", "Flag/Unflag a plate", {{Name="Plate", Help="Plate"}, {Name="Reason", Help="Reason"}}, false, function(source, args)
        local Player = PlayerModule.GetPlayerBySource(source)
        local Plate = args[1]
        args[1] = ""
        local Reason = table.concat(args, ' ')
        if Plate ~= nil and Reason ~= nil then
            DatabaseModule.Execute("SELECT * FROM player_vehicles WHERE plate = ? ", {Plate}, function(VehData)
                if VehData ~= nil and VehData[1] ~= nil then
                    if VehData[1].Flagged == 1 then
                        Reason = 'No Reason.'
                        DatabaseModule.Update("UPDATE player_vehicles SET Flagged = ?, FlagReason = ? WHERE plate = ? ", {false, Reason, Plate})
                        Player.Functions.Notify('plate-unflagged', 'The vehicle with plate '..Plate..' is no longer flagged.', 'error')
                    else
                        DatabaseModule.Update("UPDATE player_vehicles SET Flagged = ?, FlagReason = ? WHERE plate = ? ", {true, Reason, Plate})
                        Player.Functions.Notify('plate-flagged', 'The vehicle with plate '..Plate..' is now flagged.', 'success')
                    end
                else
                    Player.Functions.Notify('veh-error', 'A vehicle with this plate could not be found..', 'error')
                end
            end)
        else
            Player.Functions.Notify('args-error', 'Argument mismatch..', 'error')
        end
    end)

    CommandsModule.Add("jail", "Send a criminal to jail.", {{Name="Id", Help="Id"}, {Name="Time", Help="Time"}, {Name="Parole", Help="Parole"}}, false, function(source, args)
        local Player = PlayerModule.GetPlayerBySource(source)
        local TPlayer = PlayerModule.GetPlayerBySource(tonumber(args[1])) 
        if TPlayer then
            if Player.PlayerData.Job.Name ~= 'police' then return end
            TriggerClientEvent('mercy-police/client/enter-jail', TPlayer.PlayerData.Source, tonumber(args[2]), args[3], false)
        else
            Player.Functions.Notify('not-online', 'This person is not available..', 'error')
        end
    end)

    -- [ Events ] --

    EventsModule.RegisterServer("mercy-police/server/receive-evidence", function(Source, ClosestEvidence)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.RemoveItem("evidence", 1, false, true) then
            for k, v in pairs(ClosestEvidence) do
                if Player.Functions.AddItem('evidence-'..v['Type']:lower(), 1, false, v, true) then
                    Evidence[v['Id']] = {}
                    TriggerClientEvent('mercy-police/client/set-evidence', -1, v['Id'], Evidence[v['Id']])
                end
            end
        else
            Player.Functions.Notify('no-bags', 'You don\'t have any empty evidence bags.', 'error')
        end
    end)

            
    EventsModule.RegisterServer("mercy-police/server/set-player-cuffs", function(Source, Cuffed)
        local Player = PlayerModule.GetPlayerBySource(Source)
        Player.Functions.SetMetaData("Handcuffed", Cuffed)
        TriggerClientEvent('mercy-police/client/set-cuff-state', src, Cuffed)
    end)

    CallbackModule.CreateCallback("mercy-police/server/get-player-cuffs", function(Source, Cb, Target)
        local Player = PlayerModule.GetPlayerBySource(Target)
        if not Player then return Cb(false) end
        Cb(Player.PlayerData.MetaData['Handcuffed'])
    end)

    EventsModule.RegisterServer("mercy-police/server/cuff-player", function(Source, TargetServer)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local CuffedPlayer = PlayerModule.GetPlayerBySource(tonumber(TargetServer))
        if CuffedPlayer then
            TriggerClientEvent("mercy-police/client/getting-cuffed", CuffedPlayer.PlayerData.Source)
            TriggerClientEvent("mercy-police/client/do-cuff-anim", Player.PlayerData.Source, CuffedPlayer.PlayerData.MetaData['Handcuffed'] and 'Uncuff' or 'Cuff')
            if not CuffedPlayer.PlayerData.MetaData['Handcuffed'] then
                TriggerClientEvent("mercy-police/client/do-cuff-anim", CuffedPlayer.PlayerData.Source, 'Getcuff', Player.PlayerData.Source)
            end
        else
            Player.Functions.Notify('no-near', 'No person is near you..', 'error')
        end
    end)

    EventsModule.RegisterServer("mercy-police/server/set-garage-state", function(Source, Plate, VehNet, State)
        -- if State == 'In' then
        --     DatabaseModule.Update("UPDATE player_vehicles SET state = ? WHERE plate = ? ", {State, Plate})
        -- elseif State == 'Out' then
        --     DatabaseModule.Update("UPDATE player_vehicles SET state = ?, depotprice = ? WHERE plate = ? ", {State, 0, Plate})
        -- end
        DatabaseModule.Update("UPDATE player_vehicles SET state = ? WHERE plate = ? ", {State, Plate})
    end)

    -- Escort
    EventsModule.RegisterServer("mercy-police/server/escort-player", function(Source, Escorted)
        TriggerClientEvent('mercy-police/client/do-escort', Escorted, Source)
    end)

    -- Seat
    EventsModule.RegisterServer("mercy-police/server/set-in-vehicle", function(Source, TargetServer, VehicleNet, VehicleSeat)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local EscortPlayer = PlayerModule.GetPlayerBySource(TargetServer)
        if EscortPlayer.PlayerData.MetaData["Handcuffed"] or EscortPlayer.PlayerData.MetaData["Dead"] then
            TriggerClientEvent("mercy-police/client/set-in-vehicle", EscortPlayer.PlayerData.Source, VehicleNet, VehicleSeat)
        else
            Player.Functions.Notify('not-cuf', "Person is not dead or cuffed!", "error")
        end
    end)

    EventsModule.RegisterServer("mercy-police/server/set-out-of-vehicle", function(Source, TargetServer, VehicleNet)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local EscortPlayer = PlayerModule.GetPlayerBySource(TargetServer)
        if EscortPlayer.PlayerData.MetaData["Handcuffed"] or EscortPlayer.PlayerData.MetaData["Dead"] then
            TriggerClientEvent("mercy-police/client/set-out-of-vehicle", EscortPlayer.PlayerData.Source, VehicleNet)
        else
            Player.Functions.Notify('not-cuf', "Person is not dead or cuffed!", "error")
        end
    end)

    -- Face wear

    EventsModule.RegisterServer("mercy-police/server/remove-face-wear", function(Source, TargetServer)
        TriggerClientEvent('mercy-clothing/client/take-off-face-wear', TargetServer, 'Mask')
    end)

    -- Seize

    EventsModule.RegisterServer("mercy-police/server/seize-possesions", function(Source, TargetServer)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local TPlayer = PlayerModule.GetPlayerBySource(tonumber(TargetServer))
        -- Remove Items
        exports['mercy-inventory']:SaveInventoryData('Stash', 'jail-'..TPlayer.PlayerData.CitizenId, TPlayer.PlayerData.Inventory)
        Citizen.SetTimeout(500, function()
            TPlayer.Functions.ClearInventory()
            TPlayer.Functions.Save()
        end)
        Player.Functions.Notify('suc-seize', 'Successfully seized '..TPlayer.PlayerData.CharInfo.Firstname..' '..TPlayer.PlayerData.CharInfo.Lastname..'\'s possessions!', 'success')
    end)

    --  Employees

    EventsModule.RegisterServer("mercy-police/server/hire-employee", function(Source, StateId)    
        local Player = PlayerModule.GetPlayerBySource(Source)
        local TPlayer = PlayerModule.GetPlayerByStateId(StateId)
        if TPlayer then
            if TPlayer.PlayerData.Job.Name == 'police' then
                Player.Functions.Notify('already-hired', 'This person is already working for the PD!', 'error')
                return
            end
            TPlayer.Functions.SetJob('police')
            Player.Functions.Notify('suc-hired-person', 'Successfully gave PD job to '..TPlayer.PlayerData.CharInfo.Firstname..' '..TPlayer.PlayerData.CharInfo.Lastname, 'success')
            TPlayer.Functions.Notify('hired-person', 'You are now working for the PD, Congrats!', 'success')
            TPlayer.Functions.Save()
        else
            Player.Functions.Notify('no-player', 'No citizen found with that state id!', 'error')
        end
    end)

    EventsModule.RegisterServer("mercy-police/server/fire-employee", function(Source, StateId)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local TPlayer = PlayerModule.GetPlayerByStateId(StateId)
        if TPlayer then
            if TPlayer.PlayerData.Job.Name ~= 'police' then
                Player.Functions.Notify('not-hired-job', 'This person is not working for the PD!', 'error')
                return
            end
            if TPlayer.PlayerData.Job.HighCommand then
                Player.Functions.Notify('not-hired-high', 'You can\'t fire highcommand!', 'error')
                return
            end
            TPlayer.Functions.SetJob('unemployed')
            Player.Functions.Notify('Successfully fired '..TPlayer.PlayerData.CharInfo.Firstname..' '..TPlayer.PlayerData.CharInfo.Lastname, 'success')
            TPlayer.Functions.Notify('fired-person', 'You got fired from the PD!', 'error')
            TPlayer.Functions.Save()
        else
            Player.Functions.Notify('no-player', 'No citizen found with that state id!', 'error')
        end
    end)
            
    EventsModule.RegisterServer("mercy-police/server/receive-jail-item", function(Source, Item)
        local Player = PlayerModule.GetPlayerBySource(Source)
        Player.Functions.AddItem(Item, 1, 'jail-item', false, true)
    end)

    EventsModule.RegisterServer("mercy-police/server/reduce-jail-time", function(Source, Amount)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Amount > 0 then
            if Amount - 1 > 0 then
                Amount = Amount - 1
            else
                Amount = 0
            end
            Player.Functions.SetMetaData("Jail", Amount)
            Player.Functions.Save()
        end
    end)

    EventsModule.RegisterServer("mercy-police/server/set-in-jail", function(Source, Time, Parole)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Time >= 1 then
            -- if Parole then -- Parole?
                if Player.PlayerData.Job.Name ~= 'police' and Player.PlayerData.Job.Name ~= 'ems' then
                    Player.Functions.SetJob("unemployed")
                    Player.Functions.Notify('no-job', 'You are unemployed..', 'error')
                end
                Player.Functions.SetMetaData("Jail", Time)
                Citizen.SetTimeout(250, function()
                    Player.Functions.Save()
                end)
            -- end
        else
            Player.Functions.Notify('free-jail', 'You are free..', 'error')
            Player.Functions.SetMetaData("Jail", 0)
            Player.Functions.Save()
        end
    end)

    EventsModule.RegisterServer("mercy-police/server/purchase-police-vehicle", function(Source, Data, StateId)
        local Player = PlayerModule.GetPlayerBySource(Source)
        StateId = StateId ~= "" and StateId or Player.PlayerData.CitizenId
        local TPlayer = PlayerModule.GetPlayerByStateId(tonumber(StateId))
        if not TPlayer then return end
        local VehicleData = Shared.Vehicles[GetHashKey(Data['BuyModel'])]
        if VehicleData ~= nil then
            if Player.Functions.RemoveMoney("Bank", Data['BuyData']['Price'], "police-vehicle-shop") then
                local Plate = GeneratePlate()
                local VinNumber = GenerateVIN()
                DatabaseModule.Insert("INSERT INTO player_vehicles (citizenid, vehicle, plate, garage, state, mods, type, vin) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", {
                    TPlayer.PlayerData.CitizenId, 
                    Data['BuyModel'], 
                    Plate, 
                    'gov_mrpd', 
                    'In', 
                    '{}', 
                    'Player', 
                    VinNumber
                })
                if Source == TPlayer.PlayerData.Source then
                    Player.Functions.Notify('bought-vehicle', 'You bought a '..VehicleData['Name']..' for $'..Data['BuyData']['Price']..'.', 'success')
                else
                    Player.Functions.Notify('bought-vehicle', 'You bought a '..VehicleData['Name']..' for $'..Data['BuyData']['Price']..' for '..TPlayer.PlayerData.CharInfo.Firstname..' '..TPlayer.PlayerData.CharInfo.Lastname..'.', 'success')
                    TPlayer.Functions.Notify('bought-vehicle', 'You received a '..VehicleData['Name']..' from '..Player.PlayerData.CharInfo.Firstname..' '..Player.PlayerData.CharInfo.Lastname..'.', 'success')
                end
            else
                Player.Functions.Notify('no-money', 'An error occurred: Not Enough Money', 'error')
            end
        end
    end)

    -- VEHICLE RECORDS
    CallbackModule.CreateCallback("mercy-police/server/get-veh-record", function(Source, Cb, Plate)
        Cb(VehicleRecords[Plate])
    end)

    CallbackModule.CreateCallback("mercy-police/server/delete-veh-record", function(Source, Cb, NetId, Plate)
        VehicleRecords[Plate] = nil
        local Vehicle = NetworkGetEntityFromNetworkId(NetId)
        DeleteVehicle(Vehicle)
        ClearPedTasks(GetPlayerPed(Source))
    end)
end)

-- [ Events ] --

-- Spikes
RegisterNetEvent("mercy-police/server/lay-down-spikes", function(SendData)
    TriggerClientEvent('mercy-police/client/lay-down-spikes', -1, SendData)
end)

-- Blips
RegisterNetEvent("mercy-police/server/clear-blip", function()
    TriggerClientEvent('mercy-police/client/clear-service-blips', -1)
end)

-- Badge
RegisterNetEvent("mercy-police/server/request-pd-badge", function(Name, Rank, Department, Image)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    local Info = {}
    Info.Name = Name
    Info.Rank = Rank
    Info.Department = Department
    Info.Image = Image
    Player.Functions.AddItem('pdbadge', 1, false, Info, true)
end)

RegisterNetEvent("mercy-police/server/helicam/sync-spotlight", function(Type, NetId, State, Coords)
    TriggerClientEvent('mercy-police/client/helicam/sync-spotlight', -1, Type, NetId, State, Coords)
end)

RegisterNetEvent("mercy-police/server/create-evidence", function(Type, WeaponData)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    local InsertData
    local RandomId = CreateRandomId()
    local EvidenceType = nil
    local Coords = GetEntityCoords(GetPlayerPed(src))
    if Type == 'Bullet' then
        local WeaponInfo = Shared.Weapons[GetHashKey(WeaponData.ItemName)]
        local SerialNumber = nil
        if WeaponInfo ~= nil then 
            local WeaponItem = Player.Functions.GetItemByName(WeaponInfo["WeaponID"])
            if WeaponItem ~= nil then
                if WeaponItem.Info ~= nil and WeaponItem.Info ~= "" then 
                    SerialNumber = WeaponItem.Info.Serial
                else
                    SerialNumber = 'Unknown'
                end
            end
        end
        InsertData = {['Type'] = 'Bullet', ['Id'] = RandomId, ['Weapon'] = WeaponInfo["WeaponID"], ['Coords'] = vector3(Coords.x, Coords.y, Coords.z), ['Data'] = {['Serial'] = SerialNumber}}
    elseif Type == 'Blood' then
        InsertData = {['Type'] = 'Blood', ['Id'] = RandomId, ['Coords'] = vector3(Coords.x, Coords.y, Coords.z), ['Data'] = {['BloodType'] = Player.PlayerData.MetaData["BloodType"]}}
    elseif Type == 'Fingerprint' then
        InsertData = {['Type'] = 'Finger', ['Id'] = RandomId, ['Coords'] = vector3(Coords.x, Coords.y, Coords.z), ['Data'] = {['FingerId'] = Player.PlayerData.MetaData["FingerPrint"]}}
    end
    Evidence[RandomId] = InsertData

    TriggerClientEvent('mercy-police/client/set-evidence', -1, RandomId, Evidence[RandomId])
end)

RegisterNetEvent("mercy-police/server/evidence/set-status", function(Status)
    local src = source
    PlayerStatus[src] = Status
end)

RegisterNetEvent("mercy-police/server/get-target-status", function(TargetServer)
    local src = source
    if not PlayerStatus[TargetServer] then
        TriggerClientEvent('mercy-chat/client/post-message', src, 'Status', 'None', 'warning')
    else
        TriggerClientEvent('mercy-chat/client/post-message', src, 'Status', PlayerStatus[TargetServer].Text, 'warning')
    end
end)

RegisterNetEvent("mercy-police/server/gsr-result", function(TargetServer)
    local src = source
    local Retval = 'Nothing found.'
    if not PlayerStatus[TargetServer] then
        TriggerClientEvent('mercy-chat/client/post-message', src, 'GSR', 'No GSR found.', 'warning')
        return
    end
    for k, v in pairs(PlayerStatus[TargetServer]) do
        if v.Text == 'Gunpowder Residue' then
            Retval = 'Gunshot residue found.'
        end
    end
    TriggerClientEvent('mercy-chat/client/post-message', src, 'GSR', Retval, 'warning')
end)

RegisterNetEvent("mercy-police/server/finger-result", function(TargetServer)
    local src = source
    local Target = PlayerModule.GetPlayerBySource(TargetServer)
    if not Target then return end

    TriggerClientEvent('mercy-chat/client/post-message', src, 'FINGER', Target.PlayerData.MetaData["FingerPrint"], 'warning')
end)

-- [ Threads ] --

-- Update Blips
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if PlayerModule ~= nil then
            local DutyPlayers = {}
            for k, v in pairs(PlayerModule.GetPlayers()) do
                local Player = PlayerModule.GetPlayerBySource(v)
                if Player then 
                    local RadioItem = Player.Functions.GetItemByName('pdradio')
                    if ((Player.PlayerData.Job.Name == "police" or Player.PlayerData.Job.Name == "ambulance") and Player.PlayerData.Job.Duty and RadioItem ~= nil) then
                        table.insert(DutyPlayers, {
                            ServerId = Player.PlayerData.Source, 
                            Coords = GetEntityCoords(GetPlayerPed(v)),
                            Callsign = Player.PlayerData.Job.Callsign,
                            Name = Player.PlayerData.CharInfo.Firstname..' '..Player.PlayerData.CharInfo.Lastname, 
                        })
                    end
                end
            end
            TriggerClientEvent('mercy-police/client/update-service-blips', -1, DutyPlayers)
            Citizen.Wait(2000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if DatabaseModule ~= nil and PlayerModule ~= nil then
            DatabaseModule.Execute("SELECT * FROM players", {}, function(PlayersData)
                if PlayersData ~= nil and PlayersData[1] ~= nil then
                    for k, v in pairs(PlayersData) do
                        local Player = PlayerModule.GetPlayerByStateId(v.CitizenId)
                        if Player then
                            local JailTime = Player.PlayerData.MetaData['Jail']
                            if JailTime > 0 then
                                if JailTime - 1 > 0 then
                                    JailTime = JailTime - 1
                                else
                                    JailTime = 0
                                end
                                Player.Functions.SetMetaData("Jail", JailTime)
                                Player.Functions.Save()
                            end
                        else
                            local MetaData = json.decode(v.Globals)
                            if MetaData ~= nil and MetaData['Jail'] ~= nil and MetaData['Jail'] > 1 then
                                if MetaData['Jail'] - 1 > 1 then
                                    MetaData['Jail'] = MetaData['Jail'] - 1
                                else
                                    MetaData['Jail'] = 1
                                end
                                DatabaseModule.Update("UPDATE players SET Globals = ? WHERE CitizenId = ? ", {json.encode(MetaData), v.CitizenId})
                            end
                        end
                    end
                end
            end)
            Citizen.Wait(1000 * 60) -- 1 Minute
        end
    end
end)

-- [ Functions ] --

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GeneratePlate()
    local Plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
    DatabaseModule.Execute("SELECT * FROM player_vehicles WHERE plate = ? ", {Plate}, function(PlateData)
        while (PlateData[1] ~= nil) do
            Plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
        end
        return Plate
    end)
    return Plate:upper()
end

function GenerateVIN()
    local Vin = tostring(GetRandomNumber(1)) .. GetRandomLetter(4) .. tostring(GetRandomNumber(2)) .. GetRandomLetter(4) .. tostring(GetRandomNumber(6))
    DatabaseModule.Execute("SELECT * FROM player_vehicles WHERE vin = ? ", {Vin}, function(VinData)
        while (VinData[1] ~= nil) do
            Vin = tostring(GetRandomNumber(1)) .. GetRandomLetter(4) .. tostring(GetRandomNumber(2)) .. GetRandomLetter(4) .. tostring(GetRandomNumber(6))
        end
        return Vin
    end)
    return Vin:upper()
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

function CreateRandomId()
    return math.random(11111,99999)
end