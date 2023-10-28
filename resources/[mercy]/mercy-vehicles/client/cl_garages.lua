local CurrentGarage, IsGovGarage, PreviewVehicle = false, false, false

CreateThread(function()
    while CallbackModule == nil do Wait(100) end

    local HouseGarages = CallbackModule.SendCallback("mercy-vehicles/server/get-house-garages")
    for k, v in pairs(HouseGarages) do
        Config.Garages[k] = v
    end

    for k, v in pairs(Config.Garages) do
        exports['mercy-polyzone']:CreateBox({ 
            center = v.Zone[1], 
            length = v.Zone[2], 
            width = v.Zone[3],
        }, {
            name = 'garage-' .. k,
            heading = v.Zone[4],
            minZ = v.Zone[5], 
            maxZ = v.Zone[6],
            data = { Garage = k },
            hasMultipleZones = false, 
            debugPoly = false,
        }, function(ZoneData, ZoneCenter, Point)
        end)

        if v.Blip then
            BlipModule.CreateBlip('garage_blip_'..k, v.Spots[1], v.Blip.Text, v.Blip.Sprite, v.Blip.Color, false, 0.48)
        end
    end

    exports['mercy-polyzone']:CreateBox({
        center = vector3(-191.85, -1162.25, 23.67),
        length = 1.45,
        width = 1.0,
    }, {
        name = "garage-depot",
        heading = 0,
        minZ = 22.67, 
        maxZ = 24.87,
        hasMultipleZones = false, 
        debugPoly = false,
    }, function(IsInside, Zone, Point)
    end)
end)

RegisterNetEvent('mercy-polyzone/client/enter-polyzone', function(PolyData, Coords)
    if string.match(PolyData.name, "depot") then
        CurrentGarage = 'depot'
        exports['mercy-ui']:SetInteraction("[E] Depot")

        CreateThread(function()
            while CurrentGarage == 'depot' do
                if IsControlJustPressed(0, 38) then
                    TriggerEvent('mercy-vehicles/client/open-depot')
                end
                Wait(4)
            end
        end)
    elseif string.match(PolyData.name, "garage-") then
        if PolyData.data.Garage == nil then return end
        local IsGov = string.sub(PolyData.data.Garage, 1, 4) == "gov_"
        if IsGov and PlayerModule.GetPlayerData().Job.Name ~= 'police' then
            goto Skip
        end

        if Config.Garages[PolyData.data.Garage].IsHouse then
            local HasKeys = CallbackModule.SendCallback("mercy-housing/server/has-keys", Config.Garages[PolyData.data.Garage].IsHouse)
            if not HasKeys then
                goto Skip
            end
        end

        CurrentGarage = PolyData.data.Garage
        IsGovGarage = IsGov
        exports['mercy-ui']:SetInteraction("Garage")

        ::Skip::
    end
end)

RegisterNetEvent('mercy-polyzone/client/leave-polyzone', function(PolyData, Coords)
    if string.match(PolyData.name, "depot") then
        CurrentGarage = nil
        exports['mercy-ui']:HideInteraction()
    elseif string.match(PolyData.name, "garage-") then
        CurrentGarage = nil
        exports['mercy-ui']:HideInteraction()
    end
end)

function GetClosestGarage()
    local Distance, Id = nil, 0
    local Coords = GetEntityCoords(PlayerPedId())

    for k, v in pairs(Config.Garages[CurrentGarage].Spots) do
        local Dist = #(Coords - vector3(v.x, v.y, v.z))
        if Distance == nil or Distance > Dist then
            Distance = Dist
            Id = k
        end
    end

    return Id, Distance
end

function IsNearParking()
    return CurrentGarage ~= nil and CurrentGarage ~= 'depot' and CurrentGarage or nil
end
exports("IsNearParking", IsNearParking)

RegisterNetEvent("mercy-vehicles/client/spawn-veh-phone", function(Plate)
    local Result = CallbackModule.SendCallback("mercy-vehicles/server/can-spawn-vehicle", Plate)
    if not Result then
        return exports['mercy-ui']:Notify('veh-no-place', "Can't spawn vehicle, track vehicle to find location..", "error")
    end

    local Vehicle = CallbackModule.SendCallback("mercy-vehicles/server/get-veh-by-plate", Plate)
    TriggerEvent('mercy-vehicles/client/spawn-veh', {Vehicle = Vehicle})
end)

RegisterNetEvent("mercy-vehicles/client/load-house-garage", function(HouseId, Data) -- Add to housing
    Config.Garages[HouseId] = Data

    exports['mercy-polyzone']:CreateBox({ 
        center = Data.Zone[1], 
        length = Data.Zone[2], 
        width = Data.Zone[3], 
        data = { Garage = HouseId } 
    }, {
        name = 'garage-' .. HouseId,
        heading = Data.Zone[4],
        minZ = Data.Zone[5], 
        maxZ = Data.Zone[6],
        hasMultipleZones = false, 
        debugPoly = false,
    }, function(IsInside, Zone, Point)
        if IsInside then
            CurrentGarage = Zone.data.Garage
            IsGovGarage = false
            exports['mercy-ui']:SetInteraction("Garage")
        else
            CurrentGarage = nil
            exports['mercy-ui']:HideInteraction()
        end
    end)
end)

RegisterNetEvent("mercy-vehicles/client/open-garage", function(Data)
    local Vehicles = CallbackModule.SendCallback("mercy-vehicles/server/get-garage-vehs", CurrentGarage)
    local MenuItems = {}

    for k, v in pairs(Vehicles) do
        local SharedVehicle = Shared.Vehicles[GetHashKey(v.vehicle)]
        local MetaData = json.decode(v.metadata)

        MenuItems[#MenuItems + 1] = {
            Title = SharedVehicle and SharedVehicle.Name or GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(v.vehicle))),
            Desc = ("Plate: %s | %s"):format(v.plate, v.state),
            Data = { Event = 'mercy-vehicles/client/spawn-preview', Type = 'Client', Vehicle = v },
            SecondMenu = {
                {
                    CloseMenu = true,
                    Disabled = v.state ~= 'In',
                    Title = 'Take Out Vehicle',
                    ['Data'] = {['Event'] = "mercy-vehicles/client/spawn-veh", ['Type'] = "Client", ['Vehicle'] = v },
                },
                {
                    Title = 'Vehicle Status',
                    Desc = ('%s | Engine: %s%% | Body: %s%%'):format(v.state, math.ceil(MetaData.Engine / 10), math.ceil(MetaData.Body / 10)),
                }
            },
        }
    end

    exports['mercy-ui']:OpenContext({
        ['MainMenuItems'] = MenuItems,
        ['ReturnEvent'] = { Event = "mercy-vehicles/client/delete-preview", Type = "Client" },
        ['CloseEvent'] = { Event = "mercy-vehicles/client/delete-preview", Type = "Client" },
    })
end)

RegisterNetEvent("mercy-vehicles/client/park-vehicle", function(Data)
    local VehiclePlate = GetVehicleNumberPlateText(Data.Entity)
    local IsOwner = CallbackModule.SendCallback("mercy-vehicles/server/is-veh-owner", VehiclePlate)
    if not IsOwner then
        exports['mercy-ui']:Notify('not-parked', "Vehicle can't be parked here..", "error")
        return
    end

    if (IsGovGarage and not IsGovVehicle(Data.Entity)) or (not IsGovGarage and IsGovVehicle(Data.Entity)) then
        return exports['mercy-ui']:Notify('not-parked', "Vehicle can't be parked here..", "error")
    end

    if (IsThisModelAHeli(GetEntityModel(Data.Entity)) or IsThisModelAPlane(GetEntityModel(Data.Entity))) and CurrentGarage ~= 'airport_1' then
        return exports['mercy-ui']:Notify('aircraft-no', "An aircraft does not fit here..", "error")
    end

    local VehicleMeta = { 
        ['Engine'] = math.floor(GetVehicleEngineHealth(Data.Entity)), 
        ['Body'] = math.floor(GetVehicleBodyHealth(Data.Entity)), 
        ['Fuel'] = exports['mercy-vehicles']:GetVehicleMeta(Data.Entity, 'Fuel'),
        ['Nitrous'] = exports['mercy-vehicles']:GetVehicleMeta(Data.Entity, 'Nitrous'),
        ['Harness'] = exports['mercy-vehicles']:GetVehicleMeta(Data.Entity, 'Harness'),
    }
    VehicleModule.SaveVehicle(Data.Entity, VehiclePlate, VehicleMeta)
    TriggerServerEvent("mercy-business/server/hayes/unload-parts", VehiclePlate)
    TriggerServerEvent("mercy-vehicles/server/park-vehicle", VehToNet(Data.Entity), CurrentGarage)
end)

RegisterNetEvent("mercy-vehicles/client/spawn-preview", function(Data)
    if PreviewVehicle then
        VehicleModule.DeleteVehicle(PreviewVehicle)
        PreviewVehicle = nil
    end

    local Model = Data.Vehicle.vehicle
    local MetaData = json.decode(Data.Vehicle.metadata)

    FunctionsModule.RequestModel(Model)

    local Id, Dist = GetClosestGarage()
    local Spot = Config.Garages[CurrentGarage].Spots[Id]

    PreviewVehicle = CreateVehicle(Model, Spot.x, Spot.y, Spot.z, Spot.w, false, false)

    SetEntityHeading(PreviewVehicle, Spot.w)
    FreezeEntityPosition(PreviewVehicle, true)
    SetEntityAlpha(PreviewVehicle, 150, false)
    SetEntityCollision(PreviewVehicle, false, true)

    VehicleModule.ApplyVehicleMods(PreviewVehicle, 'Request', Data.Vehicle.plate)
end)

RegisterNetEvent("mercy-vehicles/client/delete-preview", function(Data)
    if PreviewVehicle then
        VehicleModule.DeleteVehicle(PreviewVehicle)
        PreviewVehicle = nil
    end
end)

RegisterNetEvent("mercy-vehicles/client/spawn-veh", function(Data)
    if HasOverdueDebts(Data.Vehicle.plate) then
        if PreviewVehicle then
            VehicleModule.DeleteVehicle(PreviewVehicle)
            PreviewVehicle = nil
        end

        TriggerServerEvent("mercy-phone/server/mails/send-mail", "State of Los Santos", "Notice of confiscation", "You have maintenance fees outstanding on this vehicle. Failure to pay these may result in permanent confiscation of property to the State of Los Santos. Once outstanding maintenance fees are paid, your keys will be returned to you.")
        return
    end

    local Model = Data.Vehicle.vehicle
    local MetaData = json.decode(Data.Vehicle.metadata)
    local Damage = json.decode(Data.Vehicle.damage)

    FunctionsModule.RequestModel(Model)
    
    local Spot = vector4(0.0, 0.0, 0.0, 0.0)
    if CurrentGarage then
        local Id, Dist = GetClosestGarage()
        Spot = Config.Garages[CurrentGarage].Spots[Id]
    else
        local Coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 1.75, 0)
        Spot = vector4(Coords.x, Coords.y, Coords.z, GetEntityHeading(PlayerPedId()) + 90)
    end

    local Veh = VehicleModule.SpawnVehicle(Model, { X = Spot.x, Y = Spot.y, Z = Spot.z, Heading = Spot.w }, Data.Vehicle.plate)
    local NetId = Veh['VehicleNet']
    while not NetworkDoesEntityExistWithNetworkId(NetId) do Wait(100) end
    
    local Vehicle = NetToVeh(NetId)
    while not DoesEntityExist(Vehicle) do Wait(100) end

    if PreviewVehicle then
        VehicleModule.DeleteVehicle(PreviewVehicle)
        PreviewVehicle = nil
    end

    SetEntityVisible(Vehicle, false)
    NetworkRequestControlOfEntity(Vehicle)
    
    exports['mercy-vehicles']:SetVehicleKeys(Data.Vehicle.plate, true, false)
    exports['mercy-vehicles']:SetFuelLevel(Vehicle, MetaData.Fuel)
    TriggerServerEvent('mercy-vehicles/server/set-veh-state', Data.Vehicle.plate, 'Out', NetId)
    
    SetTimeout(500, function()
        SetCarDamage(Vehicle, MetaData, Damage)
        NetworkRegisterEntityAsNetworked(Vehicle)
        VehicleModule.SetVehicleNumberPlate(Vehicle, Data.Vehicle.plate)
        VehicleModule.ApplyVehicleMods(Vehicle, 'Request', Data.Vehicle.plate)
        TriggerServerEvent("mercy-business/server/hayes/load-parts", Data.Vehicle.plate)
        TriggerServerEvent("mercy-vehicles/server/load-veh-meta", NetId, MetaData)
        SetEntityVisible(Vehicle, true)

        if not MetaData.WheelFitment then return end

        CreateThread(function()
            local LastFetch = GetGameTimer()
            local WheelFitment = MetaData.WheelFitment
            while DoesEntityExist(Vehicle) and WheelFitment do

                if LastFetch + 5000 < GetGameTimer() then
                    LastFetch = GetGameTimer()
                    WheelFitment = exports['mercy-vehicles']:GetVehicleMeta(Vehicle, "WheelFitment")
                end

                if not exports['mercy-bennys']:GetIsInBennysZone() then
                    if WheelFitment.Width then SetVehicleWheelWidth(Vehicle, WheelFitment.Width) end
                    if WheelFitment.FLOffset then SetVehicleWheelXOffset(Vehicle, 0, WheelFitment.FLOffset) end
                    if WheelFitment.FROffset then SetVehicleWheelXOffset(Vehicle, 1, WheelFitment.FROffset) end
                    if WheelFitment.RLOffset then SetVehicleWheelXOffset(Vehicle, 2, WheelFitment.RLOffset) end
                    if WheelFitment.RROffset then SetVehicleWheelXOffset(Vehicle, 3, WheelFitment.RROffset) end
                end
                Wait(4)
            end
        end)
    end)
end)

function SetCarDamage(Vehicle, MetaData, Damage)
	Wait(100)
	SetVehicleEngineHealth(Vehicle, MetaData.Engine + 0.0 or 1000.0)
    SetVehicleBodyHealth(Vehicle, MetaData.Body + 0.0 or 1000.0)

    -- Damage Doors
    for DoorId, IsDamaged in pairs(Damage.Doors) do
        if IsDamaged then
            SetVehicleDoorBroken(Vehicle, tonumber(DoorId), true)
        end
    end

    -- Damage Windows
    for WindowId, IsNotDamaged in pairs(Damage.Windows) do
        if not IsNotDamaged then
            SmashVehicleWindow(Vehicle, tonumber(WindowId))
        end
    end

    -- Damage Tyres
    for TyreId, IsDamaged in pairs(Damage.Tyres) do
        if IsDamaged then
            SetVehicleTyreBurst(Vehicle, tonumber(TyreId), false, 990.0)
        end
    end
end