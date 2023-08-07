PlayerModule = nil

-- [ Code ] --

AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Player',
    }, function(Succeeded)
        if not Succeeded then return end
        PlayerModule = exports['mercy-base']:FetchModule('Player')
    end)
end)

-- [ Events ] --

RegisterNetEvent("mercy-weapons/server/update-weapon-ammo", function(WeaponData, Ammo)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    local Amount = tonumber(Ammo)
    if WeaponData ~= nil then
        if Player.PlayerData.Inventory[WeaponData.Slot] ~= nil then
            if (type(Player.PlayerData.Inventory[WeaponData.Slot].Info) ~= 'table') then
                Player.PlayerData.Inventory[WeaponData.Slot].Info = {
                    Ammo = Amount,
                    Quality = 100,
                    Created = os.time(),
                }
            end
            Player.PlayerData.Inventory[WeaponData.Slot].Info.Ammo = Amount
        end
        Player.Functions.SetItemData(Player.PlayerData.Inventory)
    end
end)