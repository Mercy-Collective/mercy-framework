EventsModule, FunctionsModule, VehicleModule = nil
local PdmShowVehicle, PdmCam = nil, nil
local CurrentVehicleModel = ''

local _Ready = false
AddEventHandler('Modules/client/ready', function()
    if not _Ready then
        _Ready = true
    end
    TriggerEvent('Modules/client/request-dependencies', {
        'Events',
        'Functions',
        'Vehicle',
    }, function(Succeeded)
        if not Succeeded then return end
        EventsModule = exports['mercy-base']:FetchModule('Events')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
        VehicleModule = exports['mercy-base']:FetchModule('Vehicle')
    end)
end)

RegisterNetEvent('mercy-base/client/on-login', function()
    Citizen.SetTimeout(350, function()
        InitPdmZones()
    end)
end)

-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('mercy-ui/client/ui-reset', function()
    StopAnimTask(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 1.0)
    exports['mercy-ui']:SendUIMessage('Pdm', 'Hide')
    exports['mercy-ui']:SendUIMessage('Hud', 'SetAppVisiblity', { Visible = true })
    exports['mercy-assets']:RemoveProps('Laplet')
    if PdmShowVehicle ~= nil then
        VehicleModule.DeleteVehicle(PdmShowVehicle['Vehicle'])
        PdmShowVehicle = nil
    end
    CurrentVehicleModel = ''
    TogglePdmCam(false)
end)

RegisterNetEvent('mercy-pdm/client/open-pdm-catalog', function()
    exports['mercy-assets']:AttachProp('Laplet')
    exports['mercy-ui']:SendUIMessage('Pdm', 'OpenCatalog', {Vehicles = Shared.Vehicles})
    exports['mercy-ui']:SendUIMessage('Hud', 'SetAppVisiblity', { Visible = false })
    FunctionsModule.RequestAnimDict('amb@code_human_in_bus_passenger_idles@female@tablet@base')
    TaskPlayAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
    Citizen.SetTimeout(750, function()
        TogglePdmCam(true, CurrentVehicleModel)
    end)
end)

RegisterNetEvent('mercy-pdm/client/bought-vehicle', function(Model, Plate)
    local ModelLoaded = FunctionsModule.RequestModel(Model)
    local VehicleCoords = { ['X'] = Config.SpawnLocationBought.x, ['Y'] = Config.SpawnLocationBought.y, ['Z'] = Config.SpawnLocationBought.z, ['Heading'] = Config.SpawnLocationBought.w }
    if ModelLoaded then
        local Vehicle = VehicleModule.SpawnVehicle(Model, VehicleCoords, Plate, false)
        if Vehicle ~= nil then
            Citizen.SetTimeout(450, function()
                TriggerServerEvent("mercy-business/server/hayes/load-parts", Plate, { Engine = 100, Body = 100, Fuel = 100, Axle = 100, Transmission = 100, FuelInjectors = 100, Clutch = 100, Brakes = 100 })
                exports['mercy-vehicles']:SetVehicleKeys(Plate, true, false)
                exports['mercy-vehicles']:SetFuelLevel(Vehicle.Vehicle, 100)
            end)
        end
    end
end)

-- [ Functions ] --

function TogglePdmCam(Bool, Model)
    if Bool then
        PdmCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetFocusArea(Config.UndergroundShowroom.x, Config.UndergroundShowroom.y, Config.UndergroundShowroom.z, 0.0, 0.0, 0.0)
        SetCamCoord(PdmCam, Config.UndergroundShowroom.x, Config.UndergroundShowroom.y, Config.UndergroundShowroom.z)
        SetCamRot(PdmCam, -15.0, 0.0, 252.063)
        SetCamFov(PdmCam, CalculateCamPos(Model, 15.5) and 70.0 or 50.0)
        SetCamActive(PdmCam, true)
        RenderScriptCams(true, false, 1, true, true)
    else
        if PdmCam ~= nil then
            RenderScriptCams(false, false, 1, true, true)
            SetCamActive(PdmCam, false)
            DestroyCam(PdmCam, true)
            PdmCam = nil
        end
        SetFocusEntity(PlayerPedId())
    end
end

function CheckForCamFov(Model)
    local IsVehicleBig = CalculateCamPos(Model, 15.5)
    if IsVehicleBig then
        SetCamFov(PdmCam, 70.0)
    else
        SetCamFov(PdmCam, 50.0)
    end
end

function SetPdmVehicle()
    if PdmShowVehicle ~= nil then
        VehicleModule.DeleteVehicle(PdmShowVehicle['Vehicle'])
        PdmShowVehicle = nil
    end
    local VehicleCoords = {['X'] = Config.UndergroundShowroomCar.x, ['Y'] = Config.UndergroundShowroomCar.y, ['Z'] = Config.UndergroundShowroomCar.z, ['Heading'] = Config.UndergroundShowroomCar.w}
    local ModelLoaded = FunctionsModule.RequestModel(CurrentVehicleModel)
    if ModelLoaded then
        PdmShowVehicle = VehicleModule.SpawnLocalVehicle(CurrentVehicleModel, VehicleCoords, 'PDM12345', false, true)
        SetVehicleEngineOn(PdmShowVehicle.Vehicle, true, true, false)
        FreezeEntityPosition(PdmShowVehicle.Vehicle, true)
        SetVehicleDirtLevel(PdmShowVehicle.Vehicle, 0.0)
    end
end

function CalculateCamPos(Model, LargeCamSize)
    local MinDim, MaxDim = GetModelDimensions(Model)
    local ModelSize = MaxDim - MinDim
    local ModelVolume = ModelSize.x * ModelSize.y * ModelSize.z
    return ModelVolume > LargeCamSize
end

function CalculateStats(Model)
    local VehicleInfo = {}
    local IsMotorCycle = IsThisModelABike(Model)

    local Timeout = false
    Citizen.SetTimeout(13500, function() Timeout = true end)
    while PdmShowVehicle == nil and not Timeout do
        Citizen.Wait(30)
    end
    if Timeout then return false end

    local InitialDriveMaxFlatVel = GetVehicleHandlingFloat(PdmShowVehicle['Vehicle'], 'CHandlingData', 'fInitialDriveMaxFlatVel')
    local InitialDriveForce = GetVehicleHandlingFloat(PdmShowVehicle['Vehicle'], 'CHandlingData', 'fInitialDriveForce')
    local DriveBiasFront = GetVehicleHandlingFloat(PdmShowVehicle['Vehicle'], 'CHandlingData', 'fDriveBiasFront')
    local InitialDragCoeff = GetVehicleHandlingFloat(PdmShowVehicle['Vehicle'], 'CHandlingData', 'fInitialDragCoeff')
    local TractionCurveMax = GetVehicleHandlingFloat(PdmShowVehicle['Vehicle'], 'CHandlingData', 'fTractionCurveMax')
    local TractionCurveMin = GetVehicleHandlingFloat(PdmShowVehicle['Vehicle'], 'CHandlingData', 'fTractionCurveMin')
    local SuspensionReboundDamp = GetVehicleHandlingFloat(PdmShowVehicle['Vehicle'], 'CHandlingData', 'fSuspensionReboundDamp')
    local BrakeForce = GetVehicleHandlingFloat(PdmShowVehicle['Vehicle'], 'CHandlingData', 'fBrakeForce')
    local Force = InitialDriveForce
    if InitialDriveForce > 0 and InitialDriveForce < 1 then
        Force = Force * 1.1
    end
    local Accel = (InitialDriveMaxFlatVel * Force) / 10
    VehicleInfo.Acceleration = Accel
    
    local Speed = ((InitialDriveMaxFlatVel / InitialDragCoeff) * (TractionCurveMax + TractionCurveMin)) / 40
    if IsMotorCycle then
        Speed = Speed * 2
    end
    VehicleInfo.Speed = Speed

    local Handling = (TractionCurveMax + SuspensionReboundDamp) * TractionCurveMin
    if IsMotorCycle then
        Handling = Handling / 2
    end
    VehicleInfo.Handling = Handling
    
    local Braking = ((TractionCurveMin / InitialDragCoeff) * BrakeForce) * 7
    if IsMotorCycle then
        Braking = Braking * 2
    end
    VehicleInfo.Braking = Braking

    return VehicleInfo
end

-- Showroom fake

function ShowShowroomVehicles()
    for k, v in pairs(Config.PDMSpots) do
        local VehicleCoords = {['X'] = v.Coords.x, ['Y'] = v.Coords.y, ['Z'] = v.Coords.z, ['Heading'] = v.Coords.w}
        local ModelLoaded = FunctionsModule.RequestModel(v.Model)
        if ModelLoaded then
            local PdmVehicle = VehicleModule.SpawnLocalVehicle(v.Model, VehicleCoords, 'PDMCAR-'..k, false, true)
            FreezeEntityPosition(PdmVehicle.Vehicle, true)
            SetEntityInvincible(PdmVehicle.Vehicle, true)
            SetVehicleDoorsLocked(PdmVehicle.Vehicle, 3)
            table.insert(Config.PdmVehicles, PdmVehicle.Vehicle)
        end
    end
end

function RemoveShowroomVehicles()
    for k, v in pairs(Config.PdmVehicles) do
        VehicleModule.DeleteVehicle(v)
    end
    Config.PdmVehicles = {}
end

-- [ NUI Callbacks ] --

RegisterNUICallback('PDM/EnableMouse', function(Data, Cb)
    exports['mercy-ui']:SetNuiFocus(true, true)
    Cb('Ok')
end)

RegisterNUICallback('PDM/GetStats', function(Data, Cb)
    local Stats = CalculateStats(Data.Model)
    if Stats == nil then Cb(false) end
    Cb(Stats)
end)

RegisterNUICallback('PDM/BuyVehicle', function(Data, Cb)
    EventsModule.TriggerServer('mercy-pdm/server/buy-vehicle', Data.Model)
    Cb('Ok')
end)

RegisterNUICallback('PDM/DoRPM', function(Data, Cb)
    if PdmShowVehicle == nil or PdmShowVehicle['Vehicle'] == nil then return end
    SetVehicleCurrentRpm(PdmShowVehicle['Vehicle'], 1.0)
    Cb('Ok')
end)

RegisterNUICallback('PDM/SetShowVehicle', function(Data, Cb)
    CurrentVehicleModel = Data.Vehicle
    Citizen.SetTimeout(10, function()
        CheckForCamFov(Data.Vehicle)
        SetPdmVehicle()
    end)
    Cb('Ok')
end)

RegisterNUICallback('PDM/Close', function(Data, Cb)
    StopAnimTask(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 1.0)
    exports['mercy-ui']:SendUIMessage('Hud', 'SetAppVisiblity', { Visible = true })
    exports['mercy-ui']:SetNuiFocus(false, false)
    exports['mercy-assets']:RemoveProps('Laplet')
    if PdmShowVehicle ~= nil then
        VehicleModule.DeleteVehicle(PdmShowVehicle['Vehicle'])
        PdmShowVehicle = nil
    end
    CurrentVehicleModel = ''
    TogglePdmCam(false)
    Cb('Ok')
end)

AddEventHandler('onResourceStop', function(Resource)
    if Resource == GetCurrentResourceName() then
        RemoveShowroomVehicles()
    end
end)