local Zones = {}
local CasinoInteriorId = nil
local InteriorSetNames = {
    ["bets"] = "casino_rm_betting_standard",
    ["poker"] = "casino_rm_betting_poker",
    ["roulette"] = "casino_rm_betting_roulette",
}
local InRoom = false

Citizen.CreateThread(function()
    RequestAnimDict('anim_casino_b@amb@casino@games@shared@dealer@')
    RequestAnimDict('anim_casino_b@amb@casino@games@threecardpoker@dealer')
    RequestAnimDict('anim_casino_b@amb@casino@games@shared@player@')
    RequestAnimDict('anim_casino_b@amb@casino@games@threecardpoker@player')
    -- CASINO WHEEL
    -- Load Ped Target
    local WheelList = {}
    for name, data in pairs(Config.Options['Wheel']['Types']) do
        WheelList[data['Id']] = {
            Name = "spin_"..data['Id'],
            Icon ="fas fa-dollar-sign",
            Label = name.. " Spin! ($"..data['Amount']..")",
            EventType = 'Client',
            EventName = "mc-wheel/client/do-spin",
            EventParams = {Type = name},
            Enabled = function(Entity)
                return true
            end,
        }
    end
    exports['mercy-ui']:AddEyeEntry("casino_wheel_ped", {
        Type = 'Entity',
        EntityType = 'Ped',
        SpriteDistance = 10.0,
        State = false,
        Position = vector4(988.64, 42.93, 70.27, 176.13),
        Model = 'u_f_m_casinocash_01',
        Options = WheelList
    })    
    exports['mercy-ui']:AddEyeEntry("casino_chips2", {
        Type = 'Zone',
        SpriteDistance = 10.0,
        Distance = 5.0,
        ZoneData = {
            Center = vector3(990.09, 31.45, 71.47),
            Length = 4.0,
            Width = 1.2,
            Data = {
                debugPoly = false, -- Optional, shows the box zone (Default: false)
                heading = 325,
                minZ = 69.87,
                maxZ = 73.87
            },
        },
        Options = {
            {
                Name = 'casino_chips',
                Icon = 'fas fa-coins',
                Label = 'Interact',
                EventType = 'Client',
                EventName = 'mercy-casino/client/casino-actions',
                EventParams = {},
                Enabled = function(Entity)
                    return true
                end,
            },
        }
    })
    SetupCasinoPeds()
    -- Load Room Rental Ped
    exports['mercy-ui']:AddEyeEntry("room_rental_ped_right", {
        Type = 'Entity',
        EntityType = 'Ped',
        SpriteDistance = 10.0,
        Distance = 5.0,
        Position = vector4(966.41, 47.43, 70.7, 145.22),
        Model = 'u_f_m_casinocash_01',
        Options = {
            {
                Name = 'casino_interaction',
                Icon = 'fas fa-circle',
                Label = 'Interact',
                EventType = 'Client',
                EventName = 'mercy-casino/client/hotel-availability',
                EventParams = {},
                Enabled = function(Entity)
                    return true
                end,
            },
        }
    })
    -- Load Locations
    for k, Location in pairs(Config.Locations) do
        exports['mercy-polyzone']:CreateBox({
            center = Location['Coords'],
            length = Location['Length'],
            width = Location['Width'], 
        }, {
            name = Location['Name'],
            minZ = Location['MinHeight'],
            maxZ = Location['MaxHeight'],
            heading = Location['Coords'].w,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
    end
    -- Load Rooms
    for k, v in pairs(Config.Rooms) do
        exports['mercy-polyzone']:CreateBox({
            center = v['Coords'],
            length = v['Length'],
            width = v['Width'], 
        }, {
            name = v['Name'],
            minZ = v['MinHeight'],
            maxZ = v['MaxHeight'],
            heading = v['Coords'].w,
            hasMultipleZones = false,
            debugPoly = Config.Debug,
        }, function() end, function() end)
    end

    RequestIpl("hei_dlc_windows_casino")
    SetIplPropState(274689, "Set_Pent_Tint_Shell", true, true)
    SetInteriorEntitySetColor(274689, "Set_Pent_Tint_Shell", 3)
    local InteriorId = GetInteriorAtCoords(1032.22, 40.71, 69.87)
    CasinoInteriorId = InteriorId
    if IsValidInterior(InteriorId) then
        RefreshInterior(InteriorId)
    end
end)


RegisterNetEvent("np-casino:entitySetSwap", function(InteriorId)
    local cInteriorId = GetInteriorAtCoords(993.04, 80.07, 69.67)
    for _, v in pairs(InteriorSetNames) do
        DeactivateInteriorEntitySet(cInteriorId, v)
    end
    ActivateInteriorEntitySet(cInteriorId, InteriorSetNames[InteriorId])
    RefreshInterior(cInteriorId)
end)

RegisterNetEvent('mercy-polyzone/client/enter-polyzone', function(PolyData, Coords)
    -- Locations
    if PolyData.name == 'casino_entrance' then
        EnterCasino(true)
    elseif PolyData.name == 'casino_exit' then
        EnterCasino(false)
    end
    -- Rooms
    if DoesRoomExist(PolyData.name) then
        PolyInfo = PolyData.name
        exports['mercy-ui']:SetInteraction('[E] Storage', 'primary')
        StartRoomThread(PolyInfo)
    end
end)

RegisterNetEvent('mercy-polyzone/client/leave-polyzone', function(PolyData, Coords)
    -- Rooms
    if DoesRoomExist(PolyData.name) then
        InRoom = false
        exports['mercy-ui']:HideInteraction()
    end
end)

-- [ Functions ] --

function IsTable(T)
    return type(T) == 'table'
end

function SetIplPropState(InteriorId, Props, State, Refresh)
    if Refresh == nil then Refresh = false end
    if IsTable(InteriorId) then
        for key, value in pairs(InteriorId) do
            SetIplPropState(value, Props, State, Refresh)
        end
    else
        if IsTable(Props) then
            for key, value in pairs(Props) do
                SetIplPropState(InteriorId, value, State, Refresh)
            end
        else
            if State then
                if not IsInteriorPropEnabled(InteriorId, Props) then EnableInteriorProp(InteriorId, Props) end
            else
                if IsInteriorPropEnabled(InteriorId, Props) then DisableInteriorProp(InteriorId, Props) end
            end
        end
        if Refresh then RefreshInterior(InteriorId) end
    end
end

function DoesRoomExist(Room)
    for k, v in pairs(Config.Rooms) do
        if v['Name'] == Room then
            return true
        end
    end
    return false
end

function StartRoomThread(PolyInfo)
    InRoom = true
    while InRoom do
        Citizen.Wait(3) 
        if IsControlJustReleased(0, 38) then
            exports['mercy-ui']:HideInteraction()
            local StorageFetch = exports['mercy-ui']:CreateInput({
                {
                    Name = 'password', 
                    Label = 'Storage Password', 
                    Icon = 'fas fa-lock',
                    Type = 'Password',
                },
            })
            if StorageFetch['password'] then
                TriggerServerEvent('mercy-casino/server/fetch-storage', PolyInfo, StorageFetch['password'])
            end
        end
    end
end