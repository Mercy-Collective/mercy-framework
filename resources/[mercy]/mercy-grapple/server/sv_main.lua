-- [ Code ] --

-- [ Events ] --

RegisterNetEvent("mercy-grapple/server/do-rope", function(RopeId, Coords, Type)
    local src = source
    TriggerClientEvent('mercy-grapple/client/do-rope', -1, src, Type, RopeId, src, Coords)
end)