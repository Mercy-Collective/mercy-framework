-- [ Events] --

RegisterNetEvent("mercy-vehicles/server/mute-sirens", function(NetId)
    TriggerClientEvent('mercy-vehicles/client/mute-sirens', -1, NetId)
end)