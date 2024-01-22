-- [ Events ] --

RegisterNetEvent("mercy-vehicles/server/set-vehicle-purge", function(VehNet, Bool)
    TriggerClientEvent('mercy-vehicles/client/set-vehicle-purge', -1, VehNet, Bool)
end)

RegisterNetEvent("mercy-vehicles/server/set-vehicle-flames", function(VehNet, Bool)
    TriggerClientEvent('mercy-vehicles/client/set-vehicle-flames', -1, VehNet, Bool)
end)