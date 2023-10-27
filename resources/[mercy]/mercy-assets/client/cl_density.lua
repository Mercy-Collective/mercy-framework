-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(4)
        if LocalPlayer.state.LoggedIn then
            SetVehicleDensityMultiplierThisFrame(Config.Density['Vehicle'])
            SetPedDensityMultiplierThisFrame(Config.Density['Peds'])
            SetParkedVehicleDensityMultiplierThisFrame(Config.Density['Parked'])
            SetScenarioPedDensityMultiplierThisFrame(Config.Density['Scenario'], Config.Density['Scenario'])
            SetVehicleModelIsSuppressed(GetHashKey("blimp"), true)
        else
            Citizen.Wait(450)
        end
	end
end)

-- Populate world
Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(4)
        if not LoggedIn then goto Skip end
        PopulateNow()

        ::Skip::
        Citizen.Wait((1000 * 60) * 15) -- 15 minutes
    end
end)

-- [ Exports ] --

function SetDensity(Type, Value)
    if Config.Density[Type] == Value then 
        print('^1[ERROR]^7 Density [' .. Type .. '] does not exist.')
        return 
    end

    Config.Density[Type] = Value
end
exports("SetDensity", SetDensity)
