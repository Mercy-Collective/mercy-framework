local SpinningObject = nil
local SpinningCar = nil
local AUXCar = nil

local CarOnShow = nil -- `neo`
local CarOnShowAppearence = nil -- json.decode('{"colors":{"primary":61,"secondary":146,"pearlescent":157,"wheels":143,"tyre":{"r":255,"g":255,"b":255},"neon":{"r":255,"g":0,"b":255},"xenon":255,"dashboard":65,"interior":13},"tint":3,"neon":{"left":false,"right":false,"front":false,"back":false},"extras":[],"wheelType":0,"oldLivery":-1,"plateIndex":1}')
local CarOnShowMods = nil -- json.decode('{"Spoilers":4,"FrontBumper":6,"RearBumper":2,"SideSkirt":0,"Exhaust":12,"Frame":5,"Grille":1,"Hood":5,"Fender":-1,"RightFender":-1,"Roof":3,"Engine":3,"Brakes":2,"Transmission":3,"Horns":-1,"Suspension":-1,"Armor":-1,"UNK17":0,"Turbo":1,"UNK19":0,"TireSmoke":0,"UNK21":0,"XenonHeadlights":0,"FrontWheels":60,"BackWheels":-1,"PlateHolder":-1,"VanityPlates":-1,"InteriorTrim":-1,"Ornaments":-1,"Dashboard":-1,"Dials":-1,"DoorSpeakers":-1,"Seats":-1,"SteeringWheel":-1,"ShiftLeavers":-1,"Plaques":-1,"Speakers":-1,"Trunk":-1,"Hydraulics":-1,"EngineBlock":-1,"AirFilter":-1,"Struts":-1,"ArchCover":-1,"Aerials":-1,"ExteriorTrim":-1,"Tank":-1,"Windows":-1,"UNK47":-1,"Livery":4}')
local CarOnShow2 = `panamera17turbo`
local CarOnShow2Active = true

-- [ Code ] --

-- [ Functions ] --

function SpinVehicle()
    Citizen.CreateThread(function()
        while InCasino do
            Wait(0)
            if LocalPlayer.state.LoggedIn then
                if not SpinningObject or SpinningObject == 0 or not DoesEntityExist(SpinningObject) then
                    SpinningObject = GetClosestObjectOfType(974.22, 39.76, 72.16, 10.0, -1561087446, 0, 0, 0)
                    InitVehicle()
                end
                if SpinningObject ~= nil and SpinningObject ~= 0 then
                    local curHeading = GetEntityHeading(SpinningObject)
                    local curHeadingCar = GetEntityHeading(SpinningCar)
                    if curHeading >= 360 then
                        curHeading = 0.0
                        curHeadingCar = 0.0
                    elseif curHeading ~= curHeadingCar then
                        curHeadingCar = curHeading
                    end
                    SetEntityHeading(SpinningObject, curHeading + 0.075)
                    SetEntityHeading(SpinningCar, curHeadingCar + 0.075)
                end
            else
                Citizen.Wait(450)
            end
        end
        SpinningObject = nil
    end)
end

function InitVehicle()
    if CallbackModule == nil then return end
    if DoesEntityExist(SpinningCar) then
        DeleteEntity(SpinningCar)
    end
    if DoesEntityExist(AUXCar) then
        DeleteEntity(AUXCar)
    end
    if not CarOnShow then
        CarOnShow = CallbackModule.SendCallback('mercy-casino/server/get-current-wheel-veh')
        CarOnShow = GetHashKey(CarOnShow)
    end
    FunctionsModule.RequestModel(CarOnShow)
    FunctionsModule.RequestModel(CarOnShow2)
    SetModelAsNoLongerNeeded(CarOnShow)
    if CarOnShow2Active then
        SetModelAsNoLongerNeeded(CarOnShow2)
    end
    SpinningCar = CreateVehicle(CarOnShow, Config.CasinoLocations['Wheel'].x, Config.CasinoLocations['Wheel'].y, Config.CasinoLocations['Wheel'].z, 0.0, 0, 0)
    Wait(0)
    if CarOnShow2Active then
        AUXCar = CreateVehicle(CarOnShow2, Config.CasinoLocations['AUXWheel'].x, Config.CasinoLocations['AUXWheel'].y, Config.CasinoLocations['AUXWheel'].z, Config.CasinoLocations['AUXWheel'].w, 0, 0)
    end
    if CarOnShowAppearence then
        -- VehicleModule.SetVehicleAppearance(SpinningCar, CarOnShowAppearence)
    end
    if CarOnShowMods then
        VehicleModule.ApplyVehicleMods(SpinningCar, CarOnShowMods)
    end
    SetVehicleDirtLevel(SpinningCar, 0.0)
    SetVehicleOnGroundProperly(SpinningCar)
    SetVehicleNumberPlateText(SpinningCar, "SPIN2WIN")
    if CarOnShow2Active then
        SetVehicleDirtLevel(AUXCar, 0.0)
        SetVehicleOnGroundProperly(AUXCar)
        SetVehicleNumberPlateText(AUXCar, "SPIN2WIN")
        SetVehicleDoorsLocked(AUXCar, 2)
        SetVehicleUndriveable(AUXCar, true)
    end
    Wait(0)
    FreezeEntityPosition(SpinningCar, 1)
    if CarOnShow2Active then
        FreezeEntityPosition(AUXCar, 1)
    end
end