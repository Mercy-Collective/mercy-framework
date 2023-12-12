-- [ Code ] --

-- [ Threads ] --

CreateThread(function()
    -- exports['mercy-ui']:AddEyeEntry("pd_impound_check_in", {
    --     Type = 'Entity',
    --     EntityType = 'Ped',
    --     SpriteDistance = 10.0,
    --     State = false,
    --     Position = vector4(464.52, -1013.06, 27.07, 179.94),
    --     Model = 'cs_fbisuit_01',
    --     Options = {
    --         {
    --             Name = 'clock_in',
    --             Icon = 'fas fa-clock',
    --             Label = 'Clock In',
    --             EventType = 'Client',
    --             EventName = 'mercy-business/client/foodchain/set-duty',
    --             EventParams = { Business = 'Los Santos Depot', Clocked = true },
    --             Enabled = function(Entity)
    --                 local CurrentClock = exports['mercy-business']:GetClockedData()
    --                 if not CurrentClock.Clocked and exports['mercy-business']:IsPlayerInBusiness('Los Santos Depot') then
    --                     return true
    --                 else
    --                     return false
    --                 end
    --             end,
    --         },
    --         {
    --             Name = 'clock_out',
    --             Icon = 'fas fa-clock',
    --             Label = 'Clock Out',
    --             EventType = 'Client',
    --             EventName = 'mercy-business/client/foodchain/set-duty',
    --             EventParams = { Business = 'Los Santos Depot', Clocked = false },
    --             Enabled = function(Entity)
    --                 local CurrentClock = exports['mercy-business']:GetClockedData()
    --                 if CurrentClock.Clocked and exports['mercy-business']:IsPlayerInBusiness('Los Santos Depot') then
    --                     return true
    --                 else
    --                     return false
    --                 end
    --             end,
    --         },
    --     }
    -- })
end)

-- [ Events ] --

RegisterNetEvent("mercy-vehicles/client/request-impound", function(Data)
    local MenuItems = {}

    for k, v in pairs(Config.ImpoundList) do
        if not v.Gov or (v.Gov and IsGov()) then
            MenuItems[#MenuItems + 1] = {
                Title = v.Title,
                Desc = v.Desc,
                Data = { Event = 'mercy-vehicles/client/check-request-impound', Type = 'Client', Vehicle = Data.Entity, ImpoundId = k },
            }
        end
    end

    exports['mercy-ui']:OpenContext({
        ['Width'] = '50vh',
        ['MainMenuItems'] = MenuItems,
    })
end)

RegisterNetEvent("mercy-vehicles/client/check-request-impound", function(Data)
    local VehicleRecord = CallbackModule.SendCallback('mercy-police/server/get-veh-record', GetVehicleNumberPlateText(Data.Vehicle))
    if VehicleRecord and VehicleRecord[1] and VehicleRecord[1].vinscratched == 1 then
        exports['mercy-ui']:ProgressBar('Sending vehicle to depot..', math.random(7000, 15000), {['AnimName'] = 'struggle_loop_b_thief', ['AnimDict'] = 'random@mugging4', ['AnimFlag'] = 49}, false, false, false, function(DidComplete)
            if DidComplete then
                CallbackModule.SendCallback('mercy-police/server/delete-veh-record', NetworkGetNetworkIdFromEntity(Data.Vehicle), GetVehicleNumberPlateText(Data.Vehicle))
            end
        end)
        return
    end

    if Data.ImpoundId == #Config.ImpoundList then -- self 
        Citizen.SetTimeout(10, function()
            local Result = exports['mercy-ui']:CreateInput({
                { Label = 'Reason', Icon = 'fas fa-heading', Name = 'Reason' },
                { Label = 'Fee', Icon = 'fas fa-dollar-sign', Name = 'Fee' },
                { Label = 'Strikes (not automatically filled)', Icon = 'fas fa-asterisk', Name = 'Strikes' },
                { Label = 'Retained Until (in hours - default 24h)', Icon = 'fas fa-clock', Name = 'RetainedUntil' },
            })

            if Result then
                exports['mercy-ui']:ProgressBar('Sending vehicle to depot..', math.random(7000, 15000), {['AnimName'] = 'struggle_loop_b_thief', ['AnimDict'] = 'random@mugging4', ['AnimFlag'] = 49}, false, false, false, function(DidComplete)
                    if DidComplete then
                        TriggerServerEvent("mercy-vehicles/server/depot-vehicle", NetworkGetNetworkIdFromEntity(Data.Vehicle), Data.ImpoundId, Result)
                    end
                end)
            end
        end)
    -- elseif Data.ImpoundId == #Config.ImpoundList then -- call for impound worker
    --     TriggerServerEvent("mercy-jobs/server/impound/add-impound-request", NetworkGetNetworkIdFromEntity(Data.Vehicle))
    --     exports['mercy-ui']:Notify('sent-depot', "Successfully sent notification to depot employees..", "success")
    else
        exports['mercy-ui']:ProgressBar('Sending vehicle to depot..', math.random(5000, 10000), {['AnimName'] = 'struggle_loop_b_thief', ['AnimDict'] = 'random@mugging4', ['AnimFlag'] = 49}, false, false, false, function(DidComplete)
            if DidComplete then
                TriggerServerEvent("mercy-vehicles/server/depot-vehicle", NetworkGetNetworkIdFromEntity(Data.Vehicle), Data.ImpoundId, nil)
            end
        end)
    end
end)

RegisterNetEvent("mercy-vehicles/client/open-depot", function(args)
    local MenuItems = {}

    MenuItems[#MenuItems + 1] = {
        Title = "Recently confiscated",
        Desc = "List of last 10 vehicles put in depot since last tsunami.",
        Data = { Event = 'mercy-vehicles/client/lookup-recent-depots', Type = 'Client'},
    }

    MenuItems[#MenuItems + 1] = {
        Title = "Personal Vehicles",
        Desc = "List of personal vehicles in the depot.",
        Data = { Event = 'mercy-vehicles/client/lookup-personal-depot', Type = 'Client'},
    }

    MenuItems[#MenuItems + 1] = {
        Title = "Search by License Plate",
        Desc = "Search for vehicles with license plate.",
        Data = { Event = 'mercy-vehicles/client/lookup-by-plate', Type = 'Client'},
    }

    MenuItems[#MenuItems + 1] = {
        Title = "Ask for help",
        Desc = "",
        Data = { Event = 'mercy-vehicles/server/send-message-to-impound', Type = 'Server'},
    }

    exports['mercy-ui']:OpenContext({
        ['Width'] = '50vh',
        ['MainMenuItems'] = MenuItems,
    })
end)

RegisterNetEvent("mercy-vehicles/client/lookup-recent-depots", function()
    local Results = CallbackModule.SendCallback("mercy-vehicles/client/get-recent-depots")
    local MenuItems = {}

    MenuItems[#MenuItems + 1] = {
        Title = "<i class='fas fa-chevron-left' style='margin-right: .6vh;'></i> Back",
        Data = { Event = 'mercy-vehicles/client/open-depot', Type = 'Client'},
    }

    MenuItems[#MenuItems + 1] = {
        CloseMenu = false,
        Title = "Search Results",
        Desc = #Results .. " results found.",
        Data = { Event = '', Type = 'Client'},
    }

    for k, v in pairs(Results) do
        local VehicleData = Shared.Vehicles[v.Vehicle]
        if VehicleData == nil then goto Skip end

        MenuItems[#MenuItems + 1] = {
            Title = VehicleData.Name .. " | " .. v.Plate,
            Desc = "Date: " .. v.ImpoundDate,
            Data = { Event = '', Type = 'Client'},
            SecondMenu = {
                {
                    CloseMenu = false,
                    Title = 'Vehicle Information',
                    Desc = ('Plate: %s | VIN: %s'):format(v.Plate, v.VIN),
                    Data = { Event = "", Type = "Client" },
                },
                {
                    CloseMenu = false,
                    Title = 'Depot Information',
                    Desc = ('Reason: %s | Issuer: %s'):format(v.Reason, v.Issuer),
                    Data = { Event = "", Type = "Client" },
                },
                {
                    CloseMenu = false,
                    Title = 'Confiscation Information',
                    Desc = ('Strikes: %s | Confiscated until: %s'):format(v.Strikes, v.ReleaseTxt),
                    Data = { Event = "", Type = "Client" },
                },
                {
                    CloseMenu = false,
                    Title = 'Release Fee',
                    Desc = ('Total Costs: %s | TAX: %s%%'):format("$"..v.Fee..".00", math.floor(Shared.Tax['Goods'])),
                    Data = { Event = "", Type = "Client" },
                },
                {
                    CloseMenu = true,
                    Title = 'Take Vehicle',
                    Desc = 'Self-collection doubles the release fee to $' .. (v.Fee * 2) .. '.00 <br/>To avoid double fees call a depot employee.',
                    Data = { Event = "mercy-vehicles/client/take-out-depot", Type = "Client", Plate = v.Plate, SelfRetrieve = true },
                },
            }
        }

        local CurrentClock = exports['mercy-business']:GetClockedData()
        if CurrentClock.Clocked and CurrentClock.Business == 'Los Santos Depot' then
            table.insert(MenuItems[#MenuItems].SecondMenu, {
                CloseMenu = true,
                Title = 'Retrieve Vehicle as a Depot Employee',
                Desc = '',
                Data = { Event = "mercy-vehicles/client/take-out-depot", Type = "Client", Plate = v.Plate, SelfRetrieve = false },
            })
        end

        ::Skip::
    end
    
    exports['mercy-ui']:OpenContext({
        ['Width'] = '50vh',
        ['MainMenuItems'] = MenuItems,
    })
end)

RegisterNetEvent("mercy-vehicles/client/lookup-personal-depot", function()
    local Results = CallbackModule.SendCallback("mercy-vehicles/server/get-depot-vehicles")
    local MenuItems = {}

    MenuItems[#MenuItems + 1] = {
        Title = "<i class='fas fa-chevron-left' style='margin-right: .6vh;'></i> Back",
        Data = { Event = 'mercy-vehicles/client/open-depot', Type = 'Client'},
    }

    MenuItems[#MenuItems + 1] = {
        CloseMenu = false,
        Title = "Search Results",
        Desc = #Results .. " results found.",
        Data = { Event = '', Type = 'Client'},
    }

    for k, v in pairs(Results) do
        local VehicleData = Shared.Vehicles[GetHashKey(v.vehicle)]
        if VehicleData == nil then goto Skip end

        local ImpoundData = json.decode(v.impounddata)

        MenuItems[#MenuItems + 1] = {
            Title = VehicleData.Name .. " | " .. v.plate,
            Desc = "Date: " .. ImpoundData.ImpoundDate,
            Data = { Event = '', Type = 'Client'},
            SecondMenu = {
                {
                    CloseMenu = false,
                    Title = 'Vehicle Information',
                    Desc = ('Plate: %s | VIN: %s'):format(v.plate, v.vin),
                    Data = { Event = "", Type = "Client" },
                },
                {
                    CloseMenu = false,
                    Title = 'Depot Information',
                    Desc = ('Reason: %s | Issuer: %s'):format(ImpoundData.Reason, ImpoundData.Issuer),
                    Data = { Event = "", Type = "Client" },
                },
                {
                    CloseMenu = false,
                    Title = 'Confiscation Information',
                    Desc = ('Strikes: %s | Confiscated until: %s'):format(ImpoundData.Strikes, ImpoundData.ReleaseTxt),
                    Data = { Event = "", Type = "Client" },
                },
                {
                    CloseMenu = false,
                    Title = 'Release Fee',
                    Desc = ('Total Costs: %s | TAX: %s%%'):format("$"..ImpoundData.Fee..".00", math.floor(Shared.Tax['Goods'])),
                    Data = { Event = "", Type = "Client" },
                },
                {
                    CloseMenu = true,
                    Title = 'Take Vehicle',
                    Desc = 'Self-collection doubles the release fee to $' .. (ImpoundData.Fee * 2) .. '.00 <br/>To avoid double fees call a depot employee.',
                    Data = { Event = "mercy-vehicles/client/take-out-depot", Type = "Client", Plate = v.plate, SelfRetrieve = true },
                },
            }
        }

        local CurrentClock = exports['mercy-business']:GetClockedData()
        if CurrentClock.Clocked and CurrentClock.Business == 'Los Santos Depot' then
            table.insert(MenuItems[#MenuItems].SecondMenu, {
                CloseMenu = true,
                Title = 'Retrieve Vehicle as a Depot Employee',
                Data = { Event = "mercy-vehicles/client/take-out-depot", Type = "Client", Plate = v.plate, SelfRetrieve = false },
            })
        end

        ::Skip::
    end
    
    exports['mercy-ui']:OpenContext({
        ['Width'] = '50vh',
        ['MainMenuItems'] = MenuItems,
    })
end)

RegisterNetEvent("mercy-vehicles/client/lookup-by-plate", function()
    Citizen.SetTimeout(100, function()
        local Result = exports['mercy-ui']:CreateInput({
            { Label = 'Plate', Icon = 'fas fa-closed-captioning', Name = 'Plate' },
        })
    
        if Result and #Result.Plate == 8 then
            local Vehicle = CallbackModule.SendCallback("mercy-vehicles/server/get-veh-by-plate", Result.Plate)        
            if Vehicle == nil or Vehicle.state ~= 'depot' then
                return exports['mercy-ui']:Notify('no-results', "No results found.", "error")
            end

            local MenuItems = {}
        
            MenuItems[#MenuItems + 1] = {
                Title = "<i class='fas fa-chevron-left' style='margin-right: .6vh;'></i> Back",
                Data = { Event = 'mercy-vehicles/client/open-depot', Type = 'Client'},
            }
        
            local VehicleData = Shared.Vehicles[GetHashKey(Vehicle.vehicle)]
            local ImpoundData = json.decode(Vehicle.impounddata)
    
            MenuItems[#MenuItems + 1] = {
                Title = VehicleData.Name .. " | " .. Vehicle.plate,
                Desc = "Date: " .. ImpoundData.ImpoundDate,
                Data = { Event = '', Type = 'Client'},
                SecondMenu = {
                    {
                        CloseMenu = false,
                        Title = 'Vehicle Information',
                        Desc = ('Plate: %s | VIN: %s'):format(Vehicle.plate, Vehicle.vin),
                        Data = { Event = "", Type = "Client" },
                    },
                    {
                        CloseMenu = false,
                        Title = 'Depot Information',
                        Desc = ('Reason: %s | Issuer: %s'):format(ImpoundData.Reason, ImpoundData.Issuer),
                        Data = { Event = "", Type = "Client" },
                    },
                    {
                        CloseMenu = false,
                        Title = 'Confiscation Information',
                        Desc = ('Strikes: %s | Confiscated until: %s'):format(ImpoundData.Strikes, ImpoundData.ReleaseTxt),
                        Data = { Event = "", Type = "Client" },
                    },
                    {
                        CloseMenu = false,
                        Title = 'Release Fee',
                        Desc = ('Total Costs: %s | TAX: %s%%'):format("$"..ImpoundData.Fee..".00", math.floor(Shared.Tax['Goods'])),
                        Data = { Event = "", Type = "Client" },
                    },
                    {
                        CloseMenu = true,
                        Title = 'Take Vehicle',
                        Desc = 'Self-collection doubles the release fee to $' .. (ImpoundData.Fee * 2) .. '.00 <br/>To avoid double fees call a depot employee.',
                        Data = { Event = "mercy-vehicles/client/take-out-depot", Type = "Client", Plate = Vehicle.plate, SelfRetrieve = true },
                    },
                }
            }
    
            local CurrentClock = exports['mercy-business']:GetClockedData()
            if CurrentClock.Clocked and CurrentClock.Business == 'Los Santos Depot' then
                table.insert(MenuItems[#MenuItems].SecondMenu, {
                    CloseMenu = true,
                    Title = 'Retrieve Vehicle as a Depot Employee',
                    Data = { Event = "mercy-vehicles/client/take-out-depot", Type = "Client", Plate = Vehicle.plate, SelfRetrieve = false },
                })
            end
            
            exports['mercy-ui']:OpenContext({
                ['Width'] = '50vh',
                ['MainMenuItems'] = MenuItems,
            })
        end
    end)
end)

RegisterNetEvent('mercy-vehicles/client/take-out-depot', function(Data)
    local CanRetreive = CallbackModule.SendCallback("mercy-vehicles/server/can-retreive-veh", Data.Plate)
    if not CanRetreive then return exports['mercy-ui']:Notify('not-released', "This vehicle cannot be released yet.", "error") end

    local VehicleData = CallbackModule.SendCallback("mercy-vehicles/server/get-veh-by-plate", Data.Plate)

    if Data.SelfRetrieve and VehicleData.citizenid ~= PlayerModule.GetPlayerData().CitizenId then
        exports['mercy-ui']:Notify('not-your-veh', "The employee looks at you and says this is not your vehicle.", "error")
        return
    end


    local Result = CallbackModule.SendCallback("mercy-vehicles/server/can-spawn-vehicle", Data.Plate)
    if not Result then return exports['mercy-ui']:Notify('veh-no-place', "This vehicle is outside depot.", "error") end


    local Spot = GetDepotSpot()
    if Spot == false then return end

    local HasPaid = CallbackModule.SendCallback("mercy-vehicles/server/pay-release-fee", VehicleData.plate, Data.SelfRetrieve and json.decode(VehicleData.impounddata).Fee * 2 or json.decode(VehicleData.impounddata).Fee)
    if not HasPaid then
        exports['mercy-ui']:Notify('not-bank', "You don't have enough money.", "error")
        return
    end

    local Model = VehicleData.vehicle
    local MetaData = json.decode(VehicleData.metadata)
    local Damage = json.decode(VehicleData.damage)

    FunctionsModule.RequestModel(Model)

    local Veh = VehicleModule.SpawnVehicle(Model, { X = Spot.x, Y = Spot.y, Z = Spot.z, Heading = Spot.w }, VehicleData.plate)
    local NetId = Veh['VehicleNet']
    while not NetworkDoesEntityExistWithNetworkId(NetId) do Citizen.Wait(100) end
    
    local Vehicle = NetToVeh(NetId)
    while not DoesEntityExist(Vehicle) do Citizen.Wait(100) end
    SetEntityVisible(Vehicle, false)
    NetworkRequestControlOfEntity(Vehicle)

    TriggerServerEvent("mercy-business/server/hayes/load-parts", VehicleData.plate)
    exports['mercy-vehicles']:SetVehicleKeys(VehicleData.plate, true, false)
    exports['mercy-vehicles']:SetFuelLevel(Vehicle, 100.0)
    TriggerServerEvent('mercy-vehicles/server/set-veh-state', VehicleData.plate, 'Out', NetId)

    Citizen.SetTimeout(500, function()
        SetCarDamage(Vehicle, MetaData, Damage)
        -- DoCarDamage(Vehicle, MetaData.Engine, MetaData.Body)
        NetworkRegisterEntityAsNetworked(Vehicle)
        VehicleModule.SetVehicleNumberPlate(Vehicle, VehicleData.plate)
        VehicleModule.ApplyVehicleMods(Vehicle, 'Request', VehicleData.plate)
        TriggerServerEvent("mercy-vehicles/server/load-vehicle-meta", NetId, MetaData)
        SetEntityVisible(Vehicle, true)

        exports['mercy-ui']:Notify('outside-veh', "Vehicle can be found outside..", "success")
    end)
end)

-- [ Functions ] --

function IsGov()
    local PlayerJob = PlayerModule.GetPlayerData().Job.Name
    return PlayerJob == 'police' or PlayerJob == 'judge'
end

function GetDepotSpot()
    for k, v in pairs(Config.DepotSpots) do
        if VehicleModule.CanVehicleSpawnAtCoords(v, 2.5) then
            return v
        end
    end

    return false
end