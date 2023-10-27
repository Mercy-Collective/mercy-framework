local HasPauseMenu = false
local ResetStats = {
    "DB_HEADSHOTS",
    "DB_HITS_PEDS_VEHICLES",
    "DB_HITS",
    "DB_KILLS",
    "DB_SHOTS",
    "DB_SHOTTIME",
    "DEATHS_PLAYER",
    "DEATHS",
    "EXPLOSIVE_DAMAGE_HITS_ANY",
    "EXPLOSIVE_DAMAGE_HITS",
    "EXPLOSIVES_USED",
    "HEADSHOTS",
    "HITS_PEDS_VEHICLES",
    "HITS",
    "KILLS_ARMED",
    "KILLS_IN_FREE_AIM",
    "KILLS",
    "PASS_DB_HEADSHOTS",
    "PASS_DB_HITS_PEDS_VEHICLES",
    "PASS_DB_HITS",
    "PASS_DB_KILLS",
    "PASS_DB_PLAYER_KILLS",
    "PASS_DB_SHOTS",
    "PASS_DB_SHOTTIME",
    "PISTOL_KILLS",
    "PLAYER_HEADSHOTS",
    "SHOTS",
}

Citizen.CreateThread(function()
    while true do
        local _HasPauseMenu = IsPauseMenuActive()
        if HasPauseMenu ~= _HasPauseMenu then
            HasPauseMenu = _HasPauseMenu
            TriggerEvent('mercy-misc/client/pause-menu-active', _HasPauseMenu)
        end

        Citizen.Wait(250)
    end
end)

RegisterNetEvent("mercy-misc/client/pause-menu-active", function(Active)
    for k, v in pairs(ResetStats) do
        StatSetInt(GetHashKey("MP0_" .. v), 0, true)
        StatSetInt(GetHashKey("MP1_" .. v), 0, true)
    end

    StatSetFloat(GetHashKey("MP0_WEAPON_ACCURACY"), 420.69, true)
    StatSetFloat(GetHashKey("MP1_WEAPON_ACCURACY"), 420.69, true)
end)