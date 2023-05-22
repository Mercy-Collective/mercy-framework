local InVehicle = false
local IsDriver = false
local TurbulenceMin = 9.2
local TurbulenceMax = 19.2

RegisterNetEvent("mercy-threads/entered-vehicle", function() 
    local Vehicle = GetVehiclePedIsIn(PlayerPedId())
    local Model = GetEntityModel(Vehicle)
    if not IsThisModelAPlane(Model) and not IsThisModelAHeli(Model) then return end

    InVehicle = true
    SetHeliTurbulenceScalar(Vehicle, 0.1)
    
    local Player = PlayerModule.GetPlayerData()
    local HasLicense = Player.Licenses["Pilot"] and true or false
    if HasLicense then return end
    
    Citizen.CreateThread(function()
        while InVehicle do
            local DriverPed = GetPedInVehicleSeat(Vehicle, -1)
            
            if DriverPed == PlayerPedId() then
                if IsThisModelAHeli(Model) then
                    local Height = GetEntityHeightAboveGround(Vehicle)
                    if Height >= 10.0 then
                        local Turbulence = TurbulenceMin + ((Height / 100) * 20.0)
                        if Turbulence < TurbulenceMin then Turbulence = TurbulenceMin end
                        if Turbulence > TurbulenceMax then Turbulence = TurbulenceMax end
                        SetHeliTurbulenceScalar(Vehicle, Turbulence)
                    end
                end

                if IsThisModelAPlane(Model) and GetIsVehicleEngineRunning(Vehicle) then
                    exports['mercy-ui']:Notify("turbulence-message", "How do I start this thing?", 'error')
                    SetVehicleEngineOn(Vehicle, 0, 1, 1)
                    SetVehicleUndriveable(Vehicle, true)
                end
            end

            Citizen.Wait(1000)
        end
        SetHeliTurbulenceScalar(Vehicle, 0.1)
    end)
end)

RegisterNetEvent("mercy-threads/exited-vehicle", function()
    InVehicle = false
end)