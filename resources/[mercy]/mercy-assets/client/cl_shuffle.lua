local InVehicle = false

RegisterNetEvent("mercy-threads/entered-vehicle", function()
    InVehicle = true
    SetPedConfigFlag(PlayerPedId(), 184, true) -- CPED_CONFIG_FLAG_PreventAutoShuffleToDriversSeat

    local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    while InVehicle do 
        if GetIsTaskActive(PlayerPedId(), 165) then
            local CurrentSeat = 0
            if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() then
                CurrentSeat = -1
            end
            SetPedIntoVehicle(PlayerPedId(), Vehicle, CurrentSeat)
            SetPedConfigFlag(PlayerPedId(), 184, true) -- CPED_CONFIG_FLAG_PreventAutoShuffleToDriversSeat
        end
        Citizen.Wait(150)
    end

    SetPedConfigFlag(PlayerPedId(), 184, false) -- CPED_CONFIG_FLAG_PreventAutoShuffleToDriversSeat
end)

RegisterNetEvent("mercy-threads/exited-vehicle", function()
    InVehicle = false
end)
