-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(8)
        if LocalPlayer.state.LoggedIn then
		    SetVehicleDensityMultiplierThisFrame(Config.Density['Vehicle'])
            SetRandomVehicleDensityMultiplierThisFrame(Config.Density['Vehicle'])
	        SetParkedVehicleDensityMultiplierThisFrame(Config.Density['Parked'])
		    SetPedDensityMultiplierThisFrame(Config.Density['Peds'])
            SetScenarioPedDensityMultiplierThisFrame(Config.Density['Scenario'], Config.Density['Scenario'])
        else
            Citizen.Wait(450)
        end
	end
end)

-- [ Exports ] --

exports("SetDensity", function(Type, Value)
    if Config.Density[Type] ~= nil then
        Config.Density[Type] = Value
        print('Density: '..Type..' set to: '..Value)
    else
        print('Density doesnt exits.')
    end
end)