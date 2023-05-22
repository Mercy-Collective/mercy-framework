CallbackModule, PlayerModule, FunctionsModule, DatabaseModule, CommandsModule, EventsModule = nil, nil, nil, nil, nil, nil

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
        Citizen.Wait(4) 
    end 

    -- [ Callbacks ] --

    CallbackModule.CreateCallback('mercy-housing/server/get-houses', function(Source, Cb)
        DatabaseModule.Execute("SELECT * FROM player_houses", function(HouseData)
            if HouseData ~= nil then
                for k, v in pairs(HouseData) do
                    Config.Houses[v.house] = {
                        Name = v.house,
                        Owned = v.owned == '1' and true or false,
                        Owner = v.citizenid,
                        Tier = v.tier,
                        Price = v.price,
                        Adres = v.label,
                        Interior = v.tier,
                        Category = v.category,
                        Locked = true,
                        Active = v.active,
                        Coords = json.decode(v.coords),
                        Keyholders = json.decode(v.keyholders) or {},
                        Locations = json.decode(v.locations) or {},
                        Decorations = json.decode(v.decorations) or {},
                    }
                    Citizen.Wait(25)
                    TriggerClientEvent('mercy-housing/client/sync-house-data', -1, v.house, Config.Houses[v.house])
                end
                Cb(Config.Houses)
            else
                Cb(Config.Houses)
            end
        end)
    end)

    CallbackModule.CreateCallback('mercy-vehicles/server/get-house-garages', function(Source, Cb)
        local HouseGarages = {}
        DatabaseModule.Execute("SELECT * FROM player_houses", function(HouseData)
            if HouseData ~= nil then
                for k, v in pairs(HouseData) do
                    if v.hasgarage == 1 then
                        local TempGarage = {}
                        TempGarage.Blip = { Sprite = 357, Color = 3, Text = "House Garage" }
                        TempGarage.Zone = { vector3(v.garage.x, v.garage.y, v.garage.z), 5.0, 5.0, v.garage.w, v.garage.z - 1.0, v.garage.z + 1.0 }
                        TempGarage.IsHouse = true
                        TempGarage.Spots = {vector4(v.garage.x, v.garage.y, v.garage.z, v.garage.w)}
                        HouseGarages[v.house] = TempGarage
                    end
                end
                Cb(HouseGarages)
            else
                Cb(HouseGarages)
            end
        end)
    end)

    CallbackModule.CreateCallback('mercy-housing/server/has-keys', function(Source, Cb, IsHouse)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if not Player then return end
        print('Checking keys IsHouse: ', IsHouse)
        if IsHouse then
            DatabaseModule.Execute("SELECT * FROM player_houses", function(HouseData)
                if HouseData ~= nil then
                    for k, v in pairs(HouseData) do
                        local Keyholders = json.decode(v.keyholders)
                        if Keyholders ~= nil then
                            for k2, v2 in pairs(Keyholders) do
                                if v2 == Player.PlayerData.CitizenId then
                                    Cb(true)
                                end
                            end
                        else
                            Cb(false)
                        end
                    end
                else
                    Cb(false)
                end
            end)

        end
    end)

    -- [ Commands ] --

    CommandsModule.Add("addhouse", "Add a house", {}, true, function(source, args)
        local Player = PlayerModule.GetPlayerBySource(source)
        if not Player then return end
        if Player.PlayerData.Job.Name == "realestate" then
            TriggerClientEvent("mercy-housing/client/try-add-new-house", source)
        end
    end)

    -- [ Events ] --

    EventsModule.RegisterServer("mercy-housing/server/delete-decoration", function(Source, DecorationId, HouseId)
        table.remove(Config.Houses[HouseId].Decorations, DecorationId)
        DatabaseModule.Update("UPDATE player_houses SET decorations = ? WHERE house = ? ", {json.encode(Config.Houses[HouseId].Decorations), HouseId})
        TriggerClientEvent('mercy-housing/client/sync-house-data', -1, HouseId, Config.Houses[HouseId], true)
    end)
    
    EventsModule.RegisterServer("mercy-housing/server/place-decoration", function(Source, HouseId, Model, Coords, Heading)
        Config.Houses[HouseId].Decorations[#Config.Houses[HouseId].Decorations + 1] = {
            Model = Model,
            Coords = Coords,
            Heading = Heading
         }
         DatabaseModule.Update("UPDATE player_houses SET decorations = ? WHERE house = ? ", {json.encode(Config.Houses[HouseId].Decorations), HouseId})
        TriggerClientEvent('mercy-housing/client/sync-house-data', -1, HouseId, Config.Houses[HouseId], true)
    end)
    
    EventsModule.RegisterServer("mercy-housing/server/add-house", function(Source, CoordsTable, Interior, Price, StreetLabel)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local Price, Tier, HouseName = tonumber(Price), nil, nil
        local Street = StreetLabel:gsub("%'", "")
        local HouseNumber = GetFreeHouseNumber()
        local Name, Label = Street:lower()..tostring(HouseNumber), Street..' '..tostring(HouseNumber)
    
        -- Get Tier by Name
        for k, v in pairs(Config.HouseInteriors) do
            if v['Name'] == Interior then
                Tier = v['Tier']
                HouseName = v['Name']
            end
        end
    
        DatabaseModule.Insert("INSERT INTO player_houses (house, label, price, tier, category, owned, coords, keyholders, locations) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", {
            Name, 
            Label,
            Price, 
            Tier,
            string.match(HouseName:lower(), "house") and 'Housing' or 'Warehouse',
            '0', 
            json.encode(CoordsTable), 
            json.encode({}), 
            json.encode({})
        })

        Config.Houses[Name] = {
            Name = Name,
            Owned = false,
            Owner = nil,
            Tier = Tier,
            Price = Price,
            Adres = Label,
            Interior = Tier,
            Category = string.match(HouseName:lower(), "house") and 'Housing' or 'Warehouse',
            Locked = true,
            Active = true,
            Coords = CoordsTable,
            Keyholders = {},
            Decorations = {},
            Locations = {}
        }
        TriggerClientEvent('mercy-housing/client/sync-house-data', -1, Name, Config.Houses[Name])
        Player.Functions.Notify('created-house', "You have put a house for sale: "..Label, 'primary', 8500)
    end)
end)

-- [ Events ] --

RegisterNetEvent("mercy-housing/server/set-house-location", function(Data, InsideHouse)
    local src = source
	local Player = PlayerModule.GetPlayerBySource(src)
    local PCoords = GetEntityCoords(GetPlayerPed(src))
    DatabaseModule.Execute('SELECT * FROM player_houses WHERE citizenid = ? AND house = ?', {
        Player.PlayerData.CitizenId,
        Data['HouseId'],
    }, function(Result)
        if Result ~= nil then
            for k, v in pairs(Result) do
                if v.house == Data['HouseId'] then
                    local Locations = json.decode(v.locations)
                    if Locations ~= nil then
                        Locations[Data['Location']] = { Coords = PCoords }
                        DatabaseModule.Update("UPDATE player_houses SET locations = ? WHERE house = ? ", {json.encode(Locations), Data['HouseId']}, function()
                            Config.Houses[Data['HouseId']]['Locations'] = Locations
                            if InsideHouse then
                                TriggerClientEvent('mercy-housing/client/sync-house-data', -1, Data['HouseId'], Config.Houses[Data['HouseId']])
                            end
                        end)
                    end
                end
            end
        end
    end)
end)

-- [ Functions ] --

function RefreshHousing()
    DatabaseModule.Execute('SELECT * FROM player_houses', {}, function(Result)
        if Result ~= nil then
            for k, v in pairs(Result) do
                Config.Houses[v.house] = {
                    Name = v.house,
                    Owned = v.owned == '1' or v.owned == 'true' and true or false,
                    Owner = v.citizenid,
                    Tier = v.tier,
                    Price = v.price,
                    Adres = v.label,
                    Category = v.category,
                    Interior = v.tier,
                    Locked = true,
                    Active = v.active,
                    Coords = json.decode(v.coords),
                    Keyholders = json.decode(v.keyholders) or {},
                    Locations = json.decode(v.locations) or {},
                    Decorations = json.decode(v.decorations) or {},
                }
                Citizen.Wait(25)
                TriggerClientEvent('mercy-housing/client/sync-house-data', -1, v.house, Config.Houses[v.house])
            end
        end
    end)
end
exports('RefreshHousing', RefreshHousing)

function IsHouseLocked(HouseId)
    return Config.Houses[HouseId]['Locked']
end
exports('IsHouseLocked', IsHouseLocked)

function ToggleDoorLocks(HouseId)
    Config.Houses[HouseId]['Locked'] = not Config.Houses[HouseId]['Locked'] 
    TriggerClientEvent('mercy-housing/client/sync-house-data', -1, HouseId, Config.Houses[HouseId])
    return Config.Houses[HouseId]['Locked']
end
exports('ToggleDoorLocks', ToggleDoorLocks)

function GetFreeHouseNumber()
    return math.random(1111,9999)
end