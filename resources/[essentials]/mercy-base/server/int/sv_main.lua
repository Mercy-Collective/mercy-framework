CallbackModule, PlayerModule, FunctionsModule, DatabaseModule, EventsModule = nil, nil, nil, nil, nil

-- [ Code ] --

local _Ready = false

Citizen.CreateThread(function()
    TriggerEvent('Modules/server/ready')
	_Ready = true
end)

AddEventHandler('onResourceStart', function()
	if not _Ready then return end
    TriggerEvent('Modules/server/ready')
end)

AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Callback',
        'Player',
        'Functions',
        'Database',
        'Events',
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports[GetCurrentResourceName()]:FetchModule('Callback')
        PlayerModule = exports[GetCurrentResourceName()]:FetchModule('Player')
        FunctionsModule = exports[GetCurrentResourceName()]:FetchModule('Functions')
        DatabaseModule = exports[GetCurrentResourceName()]:FetchModule('Database')
        EventsModule = exports[GetCurrentResourceName()]:FetchModule('Events')

        -- [ Callbacks ] --
        CallbackModule.CreateCallback('mercy-base/server/get-specific-coords', function(Source, Cb, PlayerId)
            local Coords = GetEntityCoords(GetPlayerPed(PlayerId))
            Cb(Coords)
        end)

        CallbackModule.CreateCallback('mercy-base/server/get-citizenid-by-source', function(Source, Cb, TargetSource)
            for src, player in pairs(ServerPlayers) do
                if src == TargetSource then
                    Cb(ServerPlayers[src].PlayerData.CitizenId)
                end
            end
        end)

        function GetPlayersFromCoords(Source, Coords, Distance)
            local Players, ClosestPlayers = PlayerModule.GetPlayers(), {}
            local Coords, Distance = Coords ~= nil and Coords or GetEntityCoords(GetPlayerPed(Source)), Distance ~= nil and Distance or 5.0
            for k, v in pairs(Players) do
                local TargetPed = GetPlayerPed(v)
                local TargetCoords = GetEntityCoords(TargetPed)
                local TargetDist = #(TargetCoords - Coords)
                if TargetDist <= Distance then
                    table.insert(ClosestPlayers, v)
                end
            end
            return ClosestPlayers
        end

        CallbackModule.CreateCallback('mercy-base/server/get-closest-player', function(Source, Cb, Coords, Radius)
            local ClosestDistance, ClosestPlayer = -1, { ClosestServer = -1, ClosestPlayerPed = -1, ClosestDistance = nil}
            local Coords = Coords ~= nil and Coords or GetEntityCoords(GetPlayerPed(Source))
            local ClosestPlayers = GetPlayersFromCoords(Source, Coords, Radius)
            for i=1, #ClosestPlayers, 1 do
                if ClosestPlayers[i] ~= Source and ClosestPlayers[i] ~= -1 then
                    local TargetCoords = GetEntityCoords(GetPlayerPed(ClosestPlayers[i]))
                    local Distance = #(TargetCoords - Coords)
                    if ClosestDistance == -1 or ClosestDistance > Distance then
                        ClosestPlayer.ClosestServer = ClosestPlayers[i]
                        ClosestPlayer.ClosestDistance = Distance
                    end
                end
            end
            Cb(ClosestPlayer)
        end)

        CallbackModule.CreateCallback('mercy-base/server/get-active-players', function(Source, Cb)
            local Players = {}
            for k, v in pairs(PlayerModule.GetPlayers()) do
                local Player = {}
                Player['ServerId'] = v
                Player['Name'] = GetPlayerName(v)
                Player['Steam'] = FunctionsModule.GetIdentifier(v, "steam")
                Players[#Players+1] = Player
            end
            Cb(Players)
        end)

        CallbackModule.CreateCallback('mercy-base/server/is-me-admin', function(Source, Cb)
            PlayerModule.HasPermission(Source, function(HasPerm)
                if HasPerm then
                    Cb(true)
                else
                    Cb(false)
                end
            end, "admin")
        end)

        CallbackModule.CreateCallback('mercy-base/server/get-active-players-in-radius', function(Source, Cb, Coords, Radius)
            local ActivePlayers = {}
            local Coords, Radius = Coords ~= nil and vector3(Coords.x, Coords.y, Coords.z) or GetEntityCoords(GetPlayerPed(Source)), Radius ~= nil and Radius or 5.0
            for k, v in pairs(PlayerModule.GetPlayers()) do
                local Player = PlayerModule.GetPlayerBySource(v)
                if Player ~= nil then
                    local TargetCoords = GetEntityCoords(GetPlayerPed(v))
                    local TargetDistance = #(TargetCoords - Coords)
                    if TargetDistance <= Radius then
                        ActivePlayers[#ActivePlayers+1] = {
                            ['ServerId'] = Player.PlayerData.Source,
                            ['Name'] = GetPlayerName(Player.PlayerData.Source)
                        }
                    end
                end
            end
            Cb(ActivePlayers)
        end)

        CallbackModule.CreateCallback('mercy-base/server/create-vehicle', function(Source, Cb, VehicleName, TargetCoords, Plate)
            local Tries = 100
            local Model = (type(VehicleName) == "number" and VehicleName or GetHashKey(VehicleName))
            local Coords = {['X'] = TargetCoords['X'], ['Y'] = TargetCoords['Y'], ['Z'] = TargetCoords['Z']}
            local Heading = TargetCoords['Heading']
            local Vehicle = CreateVehicle(Model, Coords['X'], Coords['Y'], Coords['Z'], Heading, true, true)
            while not DoesEntityExist(Vehicle) and Tries > 0 do
                Citizen.Wait(100)
                Tries = Tries - 1
            end
            if not DoesEntityExist(Vehicle) then -- Vehicle did not spawn
                Cb(false)
                return
            end

            if Plate and Plate ~= nil then
                SetVehicleNumberPlateText(Vehicle, Plate)
            end
            Cb(NetworkGetNetworkIdFromEntity(Vehicle))
        end)

        CallbackModule.CreateCallback('mercy-base/server/get-vehicle-mods', function(Source, Cb, Plate)
            -- Type is 'Police' or 'NotPolice' or 'None
            DatabaseModule.Execute("SELECT mods FROM player_vehicles WHERE plate = ? ", {Plate}, function(VehData)
                if VehData ~= nil and VehData[1] ~= nil then
                    local VehicleMods = json.decode(VehData[1].mods)
                    Cb(VehicleMods)
                else
                    Cb({})
                end
            end, true)
        end)

        CallbackModule.CreateCallback('mercy-base/server/save-vehicle-mods', function(Source, Cb, VehicleMods, VehicleDamage, MetaData, Plate, Type)
            -- Type is 'Police' or 'NotPolice' or 'None'
            DatabaseModule.Update("UPDATE player_vehicles SET mods = ?, damage = ?, metadata = ? WHERE plate = ? ", {
                json.encode(VehicleMods), 
                json.encode(VehicleDamage), 
                json.encode(MetaData), 
                Plate
            }, function(Saved)
                if Saved ~= nil then
                    Cb(true)
                else
                    Cb(false)
                end
            end)
        end)

        CallbackModule.CreateCallback('mercy-base/server/remove-item', function(Source, Cb, ItemName, Amount, Slot, ShowInv, VehClass)
            local Player = PlayerModule.GetPlayerBySource(Source)
            local Amount = Amount ~= nil and Amount or 1
            local Slot = Slot ~= nil and Slot or false
            if Player.Functions.RemoveItem(ItemName, Amount, Slot, ShowInv) then
                Cb(true)
            else
                Cb(false)
            end
        end)

        CallbackModule.CreateCallback('mercy-base/server/remove-cash', function(Source, Cb, Amount)
            local Player = PlayerModule.GetPlayerBySource(Source)
            if Player.Functions.RemoveMoney("Cash", Amount) then
                Cb(true)
            else 
                Cb(false)
            end
        end)

        CallbackModule.CreateCallback('mercy-base/server/has-enough-crypto', function(Source, Cb, Type, Amount)
            local Player = PlayerModule.GetPlayerBySource(Source)
            if Player.PlayerData.Money['Crypto'][Type] >= Amount then
                Cb(true)
            else
                Cb(false)
            end
        end)

        EventsModule.RegisterServer("mercy-base/server/check-nui", function(Source, Bucket)
            if Shared.ServerDebug then return print('[DEBUG:Devtools]: Tried to check devtools but check disabled because server is in debug mode..') end
            print('[DEBUG:Devtools]: Checking Devtools Allowance for ('..Source..')')
            local Player = PlayerModule.GetPlayerBySource(Source)
            if Player then
                PlayerModule.HasPermission(Source, function(HasPermission)
                    if not HasPermission then
                        TriggerClientEvent('mercy-ui/client/notify', Source, "access-devtools", "Devtools detected..", 'error', 3000)
                        DropPlayer(Source, "Devtools detected..")
                    end
                end, "admin")
            end
        end)

        local RoutingBuckets = {}
        EventsModule.RegisterServer("mercy-base/server/bucketmanager/set-routing-bucket", function(Source, Bucket)
            print('[DEBUG:Routing]: Setting Routing Bucket for ('..Source..') to: ', Bucket)
            local InstanceSource = 0
            if Bucket then
                -- Reset Instances
                if Bucket == 0 then
                    for k, v in pairs(RoutingBuckets) do
                        for k2, v2 in pairs(v) do
                            if v2 == Source then
                                table.remove(v, k2)
                                if #v == 0 then
                                    RoutingBuckets[k] = nil
                                end
                            end
                        end
                    end
                end
                InstanceSource = Bucket
            else
                -- Generate Random InstanceSource
                InstanceSource = math.random(1, 1000)
                while RoutingBuckets[InstanceSource] and #RoutingBuckets[InstanceSource] >= 1 do
                    InstanceSource = math.random(1, 1000)
                    Citizen.Wait(1)
                end
            end

            -- Import in RoutingBuckets if InstanceSource is not 0
            if InstanceSource ~= 0 then
                if not RoutingBuckets[InstanceSource] then
                    RoutingBuckets[InstanceSource] = {}
                end
                table.insert(RoutingBuckets[InstanceSource], Source)
            end

            print('[DEBUG:Routing]: Successfully set routing bucket for '..Source..' to:', InstanceSource)
            SetPlayerRoutingBucket(Source, InstanceSource)
        end)

        EventsModule.RegisterServer("mercy-base/server/remove-money", function(Source, Amount)
            local Player = PlayerModule.GetPlayerBySource(Source)
            if Player.Functions.RemoveMoney('Cash', Amount) then
            elseif Player.Functions.RemoveMoney('Bank', Amount) then
            else
                Player.Functions.Notify('no-money', 'Not enough money.', 'error', 5000)
            end
        end)
        
        EventsModule.RegisterServer("mercy-base/server/remove-crypto", function(Source, Type, Amount)
            local Player = PlayerModule.GetPlayerBySource(Source)
            Player.Functions.RemoveCrypto(Type, Amount)
        end)
        
        EventsModule.RegisterServer("mercy-base/server/create-log", function(Source, Log)
            local Player = PlayerModule.GetPlayerBySource(Source)
    
            local Name = Player.PlayerData.Name..' ('..Player.PlayerData.CharInfo.Firstname..' '..Player.PlayerData.CharInfo.Lastname..')'

            if string.sub(Log, -1) == '.' then
                Log = Log
            else
                Log = Log..'.'
            end
            DatabaseModule.Insert("INSERT INTO server_logs (cid, name, log) VALUES (?, ?, ?)", {Player.PlayerData.CitizenId, Name, Log}, function(Inserted)
                if Inserted ~= nil then
                    print("[SERVER:LOGS]: Inserted server log.")
                else
                    print("[SERVER:LOGS]: Failed to insert server log.")
                end
            end)
        end)

        local NoPayCheckBusinesses = {
            'Burger Shot',
            'Pizza This',
            'UwU Café',
            'Hayes Repairs',
            'Digital Den',
            '6STR. Tuner Shop',
        }
                
        EventsModule.RegisterServer("mercy-base/server/receive-paycheck", function(Source)
            local Player = PlayerModule.GetPlayerBySource(Source)
            if not Player then return end

            local IsInBusiness = false
            for k, Name in pairs(NoPayCheckBusinesses) do
                if exports['mercy-business']:IsPlayerInBusiness(Player, Name) then
                    IsInBusiness = true 
                end
            end
            if IsInBusiness then return end

            local NewAmount = Player.PlayerData.MetaData['SalaryPayheck'] + Player.PlayerData.Job.Salary
            Player.Functions.SetMetaData('SalaryPayheck', NewAmount)
            Player.Functions.Save()
            TriggerClientEvent('mercy-phone/client/notification', Source, {
                Id = math.random(11111111, 99999999),
                Title = "Bank",
                Message = "You have received your paycheck of $"..Player.PlayerData.Job.Salary.." ($"..Player.PlayerData.MetaData['SalaryPayheck']..")",
                Icon = "fas fa-dollar-sign",
                IconBgColor = "#4f5efc",
                IconColor = "white",
                Sticky = false,
                Duration = 5000,
                Buttons = {},
            })
        end)

        EventsModule.RegisterServer("mercy-base/server/save-position", function(Source, Coords)
            local Player = PlayerModule.GetPlayerBySource(Source)
            if not Player then return end
            Player.Functions.SetPosition(Coords)
        end)

        CallbackModule.CreateCallback('mercy-base/server/get-crypto-data', function(Source, Cb, Type)
            if Type == 'all' then
                Cb(Shared.Cryptos)
            else
                for k, v in pairs(Shared.Cryptos) do
                    if v['Name'] == Type then
                        Cb(v)
                    end
                end
            end
        end)
    end)
end)

-- [ Events ] --

RegisterNetEvent("mercy-base/server/sync-request", function(Native, ServerId, NetId, ...)
   TriggerClientEvent('mercy-base/client/sync-execute', ServerId, Native, NetId, ...)
end)

RegisterNetEvent("mercy-base/server/set-meta-data", function(Type, Amount)
    local Source = source
    local Player = PlayerModule.GetPlayerBySource(Source)
	if Player then
        Player.Functions.SetMetaData(Type, Amount)
        Player.Functions.Save()
    end
end)

RegisterNetEvent("mercy-base/server/reduce-player-food-water", function()
    local Source = source
    local Player = PlayerModule.GetPlayerBySource(Source)
	if Player then
		local NewHunger = Player.PlayerData.MetaData['Food'] - 3.0
		local NewThirst = Player.PlayerData.MetaData['Water'] - 3.0
		if NewHunger <= 0 then NewHunger = 0 end
		if NewThirst <= 0 then NewThirst = 0 end
		Player.Functions.SetMetaData("Water", NewThirst)
		Player.Functions.SetMetaData("Food", NewHunger)
		Player.Functions.Save()
	end
end)

RegisterNetEvent("mercy-base/server/set-duty", function(Data)
    local src = source
	local Player = PlayerModule.GetPlayerBySource(src)
    if Player then
        Player.Functions.SetJobDuty(Data['State'])
        TriggerClientEvent('mercy-ui/client/notify', src, "duty-set", "You are now "..(Data['State'] and "on" or "off").." duty", Data['State'] and "success" or "error")
    end
end)

AddEventHandler('oxmysql:error', function(data)
	print('^8======================[OXMYSQL ERROR]======================')
    print('^2Query: ^3', data.query)
    print('^2Parameters: ^3', json.encode(data.parameters))
    print('^2Error: ^3', data.message)
    print('^2Full Error: ^3', json.encode(data.err))
    print('^2Resource: ^3', data.invokingResource)
	print('^8===========================================================')
end)

AddEventHandler('playerSpawned', function()
    local src = source
    TriggerClientEvent('mercy-base/client/player-spawned', src)
end)

RegisterNetEvent('Modules/server/ready')