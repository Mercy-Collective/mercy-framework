CallbackModule, PlayerModule, FunctionsModule, DatabaseModule, EventsModule = nil, nil, nil, nil, nil

local _Ready = false
AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Callback',
        'Player',
        'Functions',
        'Database',
        'Events',
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
        DatabaseModule = exports['mercy-base']:FetchModule('Database')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        _Ready = true
    end)
end)

Citizen.CreateThread(function() 
    while not _Ready do 
        Citizen.Wait(4) 
    end 

    -- [ Events ] --

    EventsModule.RegisterServer("mercy-pdm/server/buy-bicycle", function(Source, BikeData)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.RemoveMoney("Bank", FunctionsModule.GetTaxPrice(BikeData['Price'], 'Vehicle'), "bike-shop") then
            local Plate = GeneratePlate()
            local VehicleMeta = {Nitrous = 0, Harness = 0, Fuel = 100.0, Body = 1000.0, Engine = 1000.0}
            local VinNumber = GenerateVIN()
            DatabaseModule.Insert("INSERT INTO player_vehicles (citizenid, vehicle, plate, garage, state, mods, metadata, vin, type) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", {
                Player.PlayerData.CitizenId, 
                BikeData['Vehicle'], 
                Plate, 
                'depot', 
                'Out', 
                '{}', 
                json.encode(VehicleMeta), 
                VinNumber, 
                'Player'
            })
            TriggerClientEvent('mercy-pdm/client/bought-bicycle', Source, BikeData['Vehicle'], Plate)
            Player.Functions.Notify('bought-bike', 'You successfully bought a '..BikeData['Name'], 'success')
        else
            Player.Functions.Notify('no-money', 'Not enough money..', 'error')
        end
    end)

    EventsModule.RegisterServer("mercy-pdm/server/buy-vehicle", function(Source, Model)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local VehicleData = Shared.Vehicles[GetHashKey(Model)]
        if VehicleData ~= nil then
            if Player.Functions.RemoveMoney("Bank", FunctionsModule.GetTaxPrice(VehicleData['Price'], 'Vehicle'), "vehicle-shop") then
                local Plate = GeneratePlate()
                local VehicleMeta = {Nitrous = 0, Harness = 0, Fuel = 100.0, Body = 1000.0, Engine = 1000.0}
                local VinNumber = GenerateVIN()
                DatabaseModule.Insert("INSERT INTO player_vehicles (citizenid, vehicle, plate, garage, state, mods, metadata, vin, type) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", {
                    Player.PlayerData.CitizenId, 
                    VehicleData['Vehicle'], 
                    Plate, 
                    'depot', 
                    'Out', 
                    '{}', 
                    json.encode(VehicleMeta), 
                    VinNumber, 
                    'Player'
                })
                TriggerClientEvent('mercy-pdm/client/bought-vehicle', Source, VehicleData['Vehicle'], Plate)
                Player.Functions.Notify('bought-vehicle', 'You successfully bought a '..VehicleData['Model']..' '..VehicleData['Name'].. '. Vehicle can be found outside.', 'success')
            else
                Player.Functions.Notify('no-money', 'Not enough money..', 'error')
            end
        end
    end)
end)

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

-- [ Functions ] --

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