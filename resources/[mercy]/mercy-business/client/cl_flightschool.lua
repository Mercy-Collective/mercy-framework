function HasPilotLicense()
    return PlayerModule.GetPlayerData().Licenses['Flying']
end
exports("HasPilotLicense", HasPilotLicense)

Citizen.CreateThread(function()
    exports['mercy-ui']:AddEyeEntry("flightschool-highcommand-cabinet", {
        Type = 'Zone',
        SpriteDistance = 7.0,
        Distance = 1.2,
        ZoneData = {
            Center = vector3(-931.23, -2957.37, 13.95),
            Length = 2.2,
            Width = 0.3,
            Data = {
                heading = 330,
                minZ = 13.75,
                maxZ = 14.35
            },
        },
        Options = {
            {
                Name = 'highcommand_badge',
                Icon = 'fas fa-id-badge',
                Label = 'Create Pilot\'s License',
                EventType = 'Client',
                EventName = 'mercy-businesses/client/flightschool/create-pilot-license',
                EventParams = { Badge = 'flightschool' },
                Enabled = function(Entity)
                    return exports['mercy-businesses']:HasPlayerBusinessPermission('Los Santos Flightschool', 'charge_external')
                end,
            },
        }
    })
end)

RegisterNetEvent("mercy-businesses/client/flightschool/create-pilot-license", function()
    if not exports['mercy-businesses']:HasPlayerBusinessPermission('Los Santos Flightschool', 'charge_external') then return end
    local Result = exports['mercy-ui']:CreateInput({
        { Label = 'Name', Icon = 'fas fa-user', Name = 'Name' },
        { Label = 'Picture URL (.png/.jpg/.jpeg)', Icon = 'fas fa-heading', Name = 'Image' },
    })
    if Result and #Result['Name'] > 0 and #Result['Image'] > 0 then
        TriggerServerEvent("mercy-business/server/create-badge", Result, "fs")
    else
        exports['mercy-ui']:Notify('not-found', "No name or picture found!", "error")
    end
end)