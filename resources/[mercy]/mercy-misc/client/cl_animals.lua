local Animals = {
    [GetHashKey("a_c_shepherd_np")] = true,
    [GetHashKey("a_c_redpanda_01")] = true,
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if Animals[GetEntityModel(PlayerPedId())] then
            RestorePlayerStamina(PlayerId(), 1.0)
        else
            Citizen.Wait(1000)
        end
    end
end)