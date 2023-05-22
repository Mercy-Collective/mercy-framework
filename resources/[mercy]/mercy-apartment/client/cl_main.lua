EntityModule, CallbackModule, FunctionsModule, PlayerModule, EventsModule, KeybindsModule = nil, nil, nil, nil, nil, nil
local ApartmentObject = nil
local Offsets = nil
local RoomId = nil

AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
        'Entity',
        'Callback',
        'Functions',
        'Player',
        'Events',
        'Keybinds',
        'BlipManager',
    }, function(Succeeded)
        if not Succeeded then return end
    
        EntityModule = exports['mercy-base']:FetchModule('Entity')
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        KeybindsModule = exports['mercy-base']:FetchModule('Keybinds')
        BlipModule = exports['mercy-base']:FetchModule('BlipManager')

        BlipModule.CreateBlip('Apartment', Config.Apartment['Pos'], 'Apartment', 475, 3, false, 0.48)
        
        -- Sometimes doesn't render on the map??
        Citizen.SetTimeout(250, function()
            exports['mercy-ui']:AddLocation("Apartment", {
                Name = Config.Apartment['Label'],
                Icon = 'fas fa-building',
                Coords = { X = Config.Apartment['Pos'].x, Y = Config.Apartment['Pos'].y, Z = Config.Apartment['Pos'].z },
                Favorited = false,
                Type = 'Apartment',
            })
        end)
    end)
end)

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    local ShowingInteraction = false
    while true do
        Citizen.Wait(4)

        if LocalPlayer.state.LoggedIn then
            if Offsets ~= nil then
                if #(GetEntityCoords(PlayerPedId()) - vector3(Config.Apartment['Pos'].x + Offsets['Exit'].x, Config.Apartment['Pos'].y + Offsets['Exit'].y, (Config.Apartment['Pos'].z - 35.0) + Offsets['Exit'].z)) < 1.5 then
                    if not ShowingInteraction then
                        exports['mercy-ui']:SetInteraction("[E] Leave Apartment")
                        ShowingInteraction = true
                    end
                    
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent('mercy-apartment/client/leave-apartment')
                    end
                elseif #(GetEntityCoords(PlayerPedId()) - vector3(Config.Apartment['Pos'].x + Offsets['Stash'].x, Config.Apartment['Pos'].y + Offsets['Stash'].y, (Config.Apartment['Pos'].z - 35.0) + Offsets['Stash'].z)) < 1.5 then
                    if not ShowingInteraction then
                        exports['mercy-ui']:SetInteraction("[E] Storage")
                        ShowingInteraction = true
                    end
                    
                    if IsControlJustReleased(0, 38) then
                        if exports['mercy-inventory']:CanOpenInventory() then
                            local PlayerData = PlayerModule.GetPlayerData()
                            local TargetRoomId = RoomId ~= nil and RoomId or PlayerData.MetaData.RoomId

                            if (not GetApartmentLockdownStatus(TargetRoomId)) or ((PlayerData.Job.Name == 'police' or PlayerData.Job.Name == 'judge') and PlayerData.Job.Duty) then
                                TriggerEvent('mercy-ui/client/play-sound', 'stash-open', 0.75)
                                EventsModule.TriggerServer('mercy-inventory/server/open-other-inventory', 'Apartment'..TargetRoomId, 'Stash', 30, 700.0)
                            else
                                exports['mercy-ui']:Notify("apartment", "Apartment on lockdown, you may not open the stash.", "error")
                            end
                        end
                    end
                elseif #(GetEntityCoords(PlayerPedId()) - vector3(Config.Apartment['Pos'].x + Offsets['Wardrobe'].x, Config.Apartment['Pos'].y + Offsets['Wardrobe'].y, (Config.Apartment['Pos'].z - 35.0) + Offsets['Wardrobe'].z)) < 1.5 then
                    if not ShowingInteraction then
                        exports['mercy-ui']:SetInteraction("[E] Wardrobe")
                        ShowingInteraction = true
                    end
                    
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent('mercy-clothing/client/open-wardrobe', true)
                    end
                elseif #(GetEntityCoords(PlayerPedId()) - vector3(Config.Apartment['Pos'].x + Offsets['Logout'].x, Config.Apartment['Pos'].y + Offsets['Logout'].y, (Config.Apartment['Pos'].z - 35.0) + Offsets['Logout'].z)) < 1.5 then
                    if not ShowingInteraction then
                        exports['mercy-ui']:SetInteraction("[E] Sleep")
                        ShowingInteraction = true
                    end
                    
                    if IsControlJustReleased(0, 38) then
                        local Interior = exports['mercy-interiors']:DespawnInterior(ApartmentObject)
                        ApartmentObject = nil
                        Offsets = nil

                        exports['mercy-ui']:HideInteraction()

                        EventsModule.TriggerServer("mercy-ui/server/characters/send-to-character-screen")
                    end
                else
                    if ShowingInteraction then
                        exports['mercy-ui']:HideInteraction()
                        ShowingInteraction = false
                    end
                    Citizen.Wait(250)
                end                
            else                
                if #(GetEntityCoords(PlayerPedId()) - Config.Apartment['Pos']) < Config.Apartment['Distance'] then
                    if not ShowingInteraction then
                        exports['mercy-ui']:SetInteraction("[E] Enter Apartment; [G] More Options")
                        ShowingInteraction = true
                    end
                    
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent('mercy-apartment/client/enter-apartment')
                    end

                    if IsControlJustReleased(0, 47) then
                        TriggerEvent('mercy-apartment/client/apartment-options')
                    end
                else
                    if ShowingInteraction then
                        exports['mercy-ui']:HideInteraction()
                        ShowingInteraction = false
                    end
    
                    Citizen.Wait(250)
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)
 
-- [ Events ] --

RegisterNetEvent('mercy-apartment/client/spawn-apartment', function(NewChar)
    DoScreenFadeOut(250)

    while not IsScreenFadedOut() do Citizen.Wait(1) end

    local Interior = exports['mercy-interiors']:CreateInterior('gabz_pinkcage', vector3(Config.Apartment['Pos'].x, Config.Apartment['Pos'].y, Config.Apartment['Pos'].z - 35.0), false)
    if NewChar then 
        EventsModule.TriggerServer('mercy-items/server/receive-first-items') 
    else
        EventsModule.TriggerServer('mercy-base/server/bucketmanager/set-routing-bucket') -- Set new routing bucket for apartments.
    end

    if not Interior then
        DoScreenFadeIn(250)
        SetEntityCoords(PlayerPedId(), -266.27, -955.45, 31.23) -- 6316582 
        SetEntityHeading(PlayerPedId(), 120.48)
        exports['mercy-ui']:Notify("apartment-error", "Something went wrong whilst loading the apartment, you've been spawned outside..", "error")
        goto Skip
    end
    
    ApartmentObject = Interior[1]
    Offsets = Interior[2]
    
    SetEntityCoords(PlayerPedId(), Config.Apartment['Pos'].x + Offsets['Sofa'].x, Config.Apartment['Pos'].y + Offsets['Sofa'].y, (Config.Apartment['Pos'].z - 35.0) + Offsets['Sofa'].z)
    SetEntityHeading(PlayerPedId(),  Offsets['Sofa'].h)

    
    FunctionsModule.RequestAnimDict("switch@franklin@bed")
    TaskPlayAnim(PlayerPedId(), "switch@franklin@bed", "sleep_getup_rubeyes", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
    
    Citizen.SetTimeout(750, function()
        DoScreenFadeIn(250)
        Citizen.Wait((GetAnimDuration("switch@franklin@bed", "sleep_getup_rubeyes") * 1000) - 2000)
        StopAnimTask(PlayerPedId(), "switch@franklin@bed", "sleep_getup_rubeyes", 1.0)
    end)

    ::Skip::
end)

RegisterNetEvent('mercy-apartment/client/enter-apartment', function(Data)
    local PlayerData = PlayerModule.GetPlayerData()
    if Data ~= nil and Data.RoomId then RoomId = Data.RoomId else RoomId = nil end
    if RoomId ~= nil and (not GetApartmentLockStatus(RoomId)) then exports['mercy-ui']:Notify("apartment", "The apartment is locked..", "error") return end

    local LockdownStatus = GetApartmentLockdownStatus(RoomId ~= nil and RoomId or PlayerData.MetaData.RoomId)
    if LockdownStatus and ((PlayerData.Job.Name ~= 'police' and PlayerData.Job.Name ~= 'judge') or not PlayerData.Job.Duty) then
        return exports['mercy-ui']:Notify("apartment", "Apartment on lockdown, only Police or DOJ may enter.", "error")
    end

    DoScreenFadeOut(250)
    TriggerEvent('mercy-assets/client/toggle-items', true)
    TriggerEvent('mercy-assets/client/play-door-animation')
    TriggerEvent('mercy-ui/client/play-sound', 'door-open', 0.75)
    while not IsScreenFadedOut() do Citizen.Wait(1) end

    local Interior = exports['mercy-interiors']:CreateInterior('gabz_pinkcage', vector3(Config.Apartment['Pos'].x, Config.Apartment['Pos'].y, Config.Apartment['Pos'].z - 35.0), false)
    ApartmentObject = Interior[1]
    Offsets = Interior[2]

    SetEntityCoords(PlayerPedId(), Config.Apartment['Pos'].x + Offsets['Exit'].x, Config.Apartment['Pos'].y + Offsets['Exit'].y, (Config.Apartment['Pos'].z - 35.0) + Offsets['Exit'].z)
    EventsModule.TriggerServer('mercy-base/server/bucketmanager/set-routing-bucket', RoomId)

    Citizen.SetTimeout(100, function()
        exports['mercy-ui']:SetInteraction("[E] Leave Apartment")

        DoScreenFadeIn(250)
        
        TriggerEvent('mercy-ui/client/play-sound', 'door-close', 0.45)        
    end)
end)

RegisterNetEvent('mercy-apartment/client/leave-apartment', function()
    DoScreenFadeOut(250)
    TriggerEvent('mercy-assets/client/play-door-animation')
    TriggerEvent('mercy-ui/client/play-sound', 'door-open', 0.75)
    while not IsScreenFadedOut() do Citizen.Wait(1) end

    RoomId = nil

    local Interior = exports['mercy-interiors']:DespawnInterior(ApartmentObject)
    ApartmentObject = nil
    Offsets = nil

    exports['mercy-ui']:SetInteraction("[E] Enter Apartment; [G] More Options")

    EventsModule.TriggerServer('mercy-base/server/bucketmanager/set-routing-bucket', 0)
    
    Citizen.SetTimeout(100, function()
        SetEntityCoords(PlayerPedId(), Config.Apartment['Pos'].x, Config.Apartment['Pos'].y, Config.Apartment['Pos'].z)
        SetEntityHeading(PlayerPedId(), Config.Apartment['Heading'])

        DoScreenFadeIn(250)
        
        TriggerEvent('mercy-assets/client/toggle-items', false)
        TriggerEvent('mercy-ui/client/Play-sound', 'door-close', 0.45)
    end)
end)

RegisterNetEvent('mercy-apartment/client/apartment-options', function()
    local PlayerData = PlayerModule.GetPlayerData()
    local ApartmentLock = GetApartmentLockStatus(PlayerData.MetaData.RoomId)
    local LockdownStatus = GetApartmentLockdownStatus(PlayerData.MetaData.RoomId)

    local MenuItems = {
        {
            Title = ApartmentLock and 'Lock' or 'Unlock',
            Desc = 'Lock / Unlock Your apartment.',
            Disabled = LockdownStatus,
            Data = {['Event'] = 'mercy-apartment/server/toggle-lock', ['Type'] = 'Server', ['StateId'] = PlayerData.CitizenId},
            Type = 'Click',
        },
        {
            Title = 'Apartments',
            Desc = 'View / Enter Unlocked Apartments.',
            Data = {['Event'] = '', ['Type'] = 'Client'},
            SecondMenu = {}
        }
    }

    if (PlayerData.Job.Name == 'police' or PlayerData.Job.Name == 'judge') and PlayerData.Job.Duty then
        table.insert(MenuItems, {
            Title = 'Lockdown-CID',
            Desc = 'Lock / Unlock a Given Apartment using CID',
            Data = {['Event'] = 'mercy-apartments/client/lockdown-apartment', ['Type'] = 'Client'},
            Type = 'Click',
        })
    end
    
    local Apartments = CallbackModule.SendCallback('mercy-apartment/server/get-unlocked-apps')
    for k, v in pairs(Apartments) do
        if not GetApartmentLockStatus(v) then goto Skip end
        local MenuData = {}
        MenuData['Title'] = 'Apartment #' .. v
        MenuData['Data'] = {['Event'] = '', ['Type'] = 'Client', ['RoomId'] = v}
        MenuData['SecondMenu'] = {
            {
                ['Title'] = 'Enter Apartment',
                ['Type'] = 'Click',
                ['Data'] = {['Event'] = 'mercy-apartment/client/enter-apartment', ['Type'] = 'Client', ['RoomId'] = v }
            },
        }
        table.insert(MenuItems[2].SecondMenu, MenuData)
        ::Skip::
    end

    Citizen.SetTimeout(50, function()
        exports['mercy-ui']:OpenContext({ ['MainMenuItems'] = MenuItems })
    end)
end)

RegisterNetEvent('mercy-apartments/client/lockdown-apartment', function(Data)
    Citizen.SetTimeout(250, function()
        local Data = {{ Name = 'state_id', Label = 'State Id', Icon = 'fas fa-id-card' }}
        local LockdownInput = exports['mercy-ui']:CreateInput(Data)
        if LockdownInput['state_id'] then
            TriggerServerEvent('mercy-apartment/server/toggle-lockdown', LockdownInput['state_id'])
        else
            exports['mercy-ui']:Notify("apartment", "No valid state id..", "error")
        end
    end)
end)

-- [ Functions ] --

function GetApartmentLockStatus(RoomId)
    local LockStatus = CallbackModule.SendCallback('mercy-apartment/server/get-lockstatus-by-roomid', RoomId)
    return LockStatus
end

function GetApartmentLockdownStatus(RoomId)
    local LockStatus = CallbackModule.SendCallback('mercy-apartment/server/get-lockdown-by-roomid', RoomId)
    return LockStatus
end

function IsInsideApartment()
    if ApartmentObject ~= nil then
        return true
    end
    return false
end
exports('IsInsideApartment', IsInsideApartment)

exports("GetApartmentLocation", function()
    return Config.Apartment.Pos
end)