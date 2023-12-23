EventsModule, LoggerModule, CallbackModule, FunctionsModule, BlipModule, PlayerModule = nil

local _Ready = false
AddEventHandler('Modules/client/ready', function()
    if not _Ready then
        _Ready = true
    end
    TriggerEvent('Modules/client/request-dependencies', {
        'Events',
        'Logger',
        'Callback',
        'Functions',
        'BlipManager',
        'Player',
    }, function(Succeeded)
        if not Succeeded then return end
        EventsModule = exports['mercy-base']:FetchModule('Events')
        LoggerModule = exports['mercy-base']:FetchModule('Logger')
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
        BlipModule = exports['mercy-base']:FetchModule('BlipManager')
        PlayerModule = exports['mercy-base']:FetchModule('Player')
    end)
end)

RegisterNetEvent('mercy-base/client/on-login', function()
    Citizen.SetTimeout(350, function()
        InitStores()
    end)
end)

-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('mercy-stores/client/open-store', function(ShopType)
    if Config.StoreItems[ShopType] ~= nil then
        if exports['mercy-inventory']:CanOpenInventory() then
            if Config.RequireWeaponLicense and ((ShopType == 'Weapons' or ShopType == 'Hunting') and not HasWeaponLicense()) then
                exports['mercy-ui']:Notify("no-license", "You don't have a weapons license..", "error")
                return
            end
            EventsModule.TriggerServer('mercy-inventory/server/open-other-inventory', 'Store'..ShopType, 'Store', 0, 0, Config.StoreItems[ShopType], ShopType)
        end
    end
end)

Citizen.CreateThread(function()
    for k, v in pairs(Config.VendingMachines) do
        exports['mercy-ui']:AddEyeEntry(GetHashKey(v.Prop), {
            Type = 'Model',
            Model = v.Prop,
            SpriteDistance = 10.0,
            Distance = 1.5,
            Options = {
                {
                    Name = "open_vending",
                    Icon = 'fas fa-shopping-basket',
                    Label = "Vending Machine",
                    EventType = "Client",
                    EventName = "mercy-stores/client/open-vending",
                    EventParams = {Vending = v.Vending},
                    Enabled = function(Entity)
                        return true
                    end,
                }
            }
        })
    end
end)

RegisterNetEvent("mercy-stores/client/open-vending", function(Data)
    if exports['mercy-inventory']:CanOpenInventory() then
        EventsModule.TriggerServer('mercy-inventory/server/open-other-inventory', 'Vending'..Data.Vending, 'Store', 0, 0, Config.StoreItems[Data.Vending], Data.Vending)
    end
end)

-- [ Functions ] --

function InitStores()
    for k, v in pairs(Config.Stores) do
        exports['mercy-ui']:AddEyeEntry("stores-"..k, {
            Type = 'Entity',
            EntityType = 'Ped',
            SpriteDistance = 10.0,
            Distance = 5.0,
            Position = v['Coords'],
            Model = v['Ped'],
            Anim = {},
            Scenario = v['Scenario'] ~= nil and v['Scenario'] or nil,
            Props = {},
            Options = {
                {
                    Name = 'store-'..k,
                    Icon = v['Icon'] ~= nil and v['Icon'] or 'fas fa-circle',
                    Label = 'Store',
                    EventType = 'Client',
                    EventName = 'mercy-stores/client/open-store',
                    EventParams = v.Store,
                    Enabled = function(Entity)
                        return true
                    end,
                }
            }
        })
        if v.Blip ~= nil and v.Blip then
            BlipModule.CreateBlip('stores-'..k, vector3(v.Coords.x, v.Coords.y, v.Coords.z), v.Name, v.Store == 'Weapons' and 110 or 59, v.Store == 'Weapons' and 49 or 26, false, 0.43)
        end
    end
end

function HasWeaponLicense()
    local Player = PlayerModule.GetPlayerData()
    return Player.Licenses['Weapons']
end