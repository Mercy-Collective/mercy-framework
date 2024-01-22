InventorySaveData, CurrentStealNumber = {}, nil
local CurrentDrop, ShowingHotbar, UsingKey, LastUsedSlot = nil, false, false, 0
PlayerModule, EventsModule, FunctionsModule, BlipModule, CallbackModule, VehiclesModule, KeybindsModule, VehicleModule = nil, nil, nil, nil, nil, nil, nil, nil

AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
        'Player',
		'Events',
        'Functions',
        'BlipManager',
        'Callback',
        'Vehicle',
        'Keybinds',
    }, function(Succeeded)
        if not Succeeded then return end
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
        BlipModule = exports['mercy-base']:FetchModule('BlipManager')
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        VehiclesModule = exports['mercy-base']:FetchModule('Vehicle')
        KeybindsModule = exports['mercy-base']:FetchModule('Keybinds')
        VehicleModule = exports['mercy-base']:FetchModule('Vehicle')

        Citizen.CreateThread(function()
            for k, v in pairs(Shared.ItemList) do
                if v.Price == nil then v.Price = 0 end
                if v.Price ~= 0 then
                    v.Price = FunctionsModule.GetTaxPrice(v.Price, 'Goods') -- Calculate all prices with tax
                end
            end
            SendNUIMessage({
                Action = 'UpdateItemList',
                List = Shared.ItemList,
            })
        end)
    end)
end)

RegisterNetEvent('mercy-base/client/on-login', function()
    InitInventory()
    Citizen.SetTimeout(3500, function()
        TriggerEvent('mercy-assets/client/toggle-items', false)
    end)
end)

RegisterNetEvent('mercy-base/client/on-logout', function()
    TriggerEvent('mercy-inventory/client/reset-weapon')
end)

RegisterNetEvent("mercy-base/client/player-spawned", function()
    Citizen.CreateThread(function()
        for k, v in pairs(Shared.ItemList) do
            v.Price = FunctionsModule.GetTaxPrice(v.Price, 'Goods') -- Calculate all prices with tax
        end
        SendNUIMessage({
            Action = 'UpdateItemList',
            List = Shared.ItemList,
        })
    end)
end)
 
-- [ Degen Command ] -- 

RegisterCommand('degen', function(source, args, RawCommand)
    if not PlayerModule.IsPlayerAdmin() then return end

    local Item = args[1]
    local Amount = args[2] ~= nil and tonumber(args[2]) or 1
    EventsModule.TriggerServer('mercy-inventory/server/degen-item', exports['mercy-inventory']:GetSlotForItem(Item), Amount)
end)

-- [ Code ] -- 

RegisterNetEvent("mercy-inventory/client/open-inventory", function()
    SetTimecycleModifier('hud_def_blur')
    SetTimecycleModifierStrength(1.0)
    -- Config.InventoryBusy = true
    local PlayerData = PlayerModule.GetPlayerData()

    SendNUIMessage({
        Action = 'OpenInventory',
        Items = FormatItemData(PlayerData.Inventory),
        Slots = Config.InventorySlots,
        Weight = GetTotalWeight(PlayerData.Inventory),
        OtherExtra = false,
        PlayerData = PlayerData,
    })

    SetNuiFocus(true, true)
    Citizen.InvokeNative(0xFC695459D4D0E219, 0.5, 0.5)
    DoPickupAnimation()
end)

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        if LocalPlayer.state.LoggedIn then
            DisableControlAction(0, 37, true)
            DisableControlAction(0, Keys["1"], true)
            DisableControlAction(0, Keys["2"], true)
            DisableControlAction(0, Keys["3"], true)
            DisableControlAction(0, Keys["4"], true)

            -- Functionality for using items
            for i = 1, 4, 1 do
                local Key = tostring(i)
                if IsDisabledControlJustPressed(0, Keys[Key]) then
                    local PlayerData = PlayerModule.GetPlayerData()
                    if not PlayerData.MetaData["Dead"] and not PlayerData.MetaData["Handcuffed"] then 
                        if not Config.InventoryBusy then 
                            if not UsingKey then
                                UsingKey = true
                                Citizen.SetTimeout(100, function()
                                    EventsModule.TriggerServer("mercy-inventory/server/use-item", Key)
                                    LastUsedSlot = Key
                                    Citizen.Wait(250)
                                    UsingKey = false
                                end)
                            end
                        end
                    end
                end
            end

            -- Get Closest Drop
            local NearAnything = false
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            for k, v in pairs(Config.Drops) do 
                if Config.Drops[k] ~= nil and v['Coords'] ~= nil then
                    local Distance = #(PlayerCoords - v['Coords'])
                    if Distance < 1.5 then
                        CurrentDrop = k
                        NearAnything = true
                    end
                end
            end

            -- Display Drops
            for k, v in pairs(Config.Drops) do
                if Config.Drops[k] ~= nil and v['Coords'] ~= nil then
                    local MaxDistance = 12.0
                    if GetVehiclePedIsIn(PlayerPedId()) == 0 then MaxDistance = 25.0 end

                    if #(PlayerCoords - v['Coords']) <= MaxDistance then
                        DrawMarker(20, v['Coords'].x, v['Coords'].y, v['Coords'].z - 0.8, 0, 0, 0, 0.0, 0, v['Heading'], 0.2, 0.3, 0.1, 252, 255, 255, 91, 0, 0, 0, 0)
                    end
                end
            end

            if not NearAnything then
                CurrentDrop = 0
            end
        else
            Citizen.Wait(500)
        end
        Citizen.Wait(4)
    end
end)

-- [ Events ] --

RegisterNetEvent('mercy-inventory/client/sync-drops', function(ConfigData)
    Config.Drops = ConfigData
end)

RegisterNetEvent('mercy-inventory/client/set-inventory-state', function(Bool)
    Config.InventoryBusy = Bool
    if Config.InventoryBusy then
        TriggerEvent('mercy-inventory/client/force-close')
    end
end)

RegisterNetEvent('mercy-inventory/client/open-empty-other', function()
    SetTimecycleModifier('hud_def_blur')
    SetTimecycleModifierStrength(1.0)
    -- Config.InventoryBusy = true
    local PlayerData = PlayerModule.GetPlayerData()
    DoPickupAnimation()
    
    SendNUIMessage({
        Action = 'OpenInventory',
        Items = FormatItemData(PlayerData.Inventory),
        Slots = Config.InventorySlots,
        Weight = GetTotalWeight(PlayerData.Inventory),
        OtherExtra = 'Empty',
        PlayerData = PlayerData,
    })

    Citizen.InvokeNative(0xFC695459D4D0E219, 0.5, 0.5)
    SetNuiFocus(true, true)
end)

RegisterNetEvent('mercy-inventory/client/open-inventory-other', function(OtherData)
    SetTimecycleModifier('hud_def_blur')
    SetTimecycleModifierStrength(1.0)
    local PlayerData = PlayerModule.GetPlayerData()
    SendNUIMessage({
        Action = 'OpenInventory',
        Slots = Config.InventorySlots,
        Items = FormatItemData(PlayerData.Inventory),
        Weight = GetTotalWeight(PlayerData.Inventory),
        Other = OtherData,
        OtherMaxWeight = OtherData['MaxWeight'] ~= nil and OtherData['MaxWeight'] or 100,
        OtherItems = OtherData['Type'] == "Crafting" and FormatNoDataItems(OtherData['Items'])
                    or OtherData['Type'] == 'Stash' and FormatNoDataItems(OtherData['Items'])
                    or OtherData['Type'] == 'Glovebox' and FormatNoDataItems(OtherData['Items'])
                    or OtherData['Type'] == 'Trunk' and FormatNoDataItems(OtherData['Items'])
                    or OtherData['Type'] == 'Temp' and FormatNoDataItems(OtherData['Items'])
                    or OtherData['Type'] == 'Drop' and FormatNoDataItems(OtherData['Items'])
                    or OtherData['Type'] == 'Store' and FormatNoDataItems(OtherData['Items'])
                    or OtherData['Items'] ~= nil and FormatItemData(OtherData['Items']) or {},
        OtherExtra = false,
        PlayerData = PlayerData,
    })

    Citizen.InvokeNative(0xFC695459D4D0E219, 0.5, 0.5)
    SetNuiFocus(true, true)

    if OtherData['Type'] ~= 'Trunk' then
        DoPickupAnimation() 
    end
    -- Config.InventoryBusy = false
end)

RegisterNetEvent('mercy-inventory/client/item-box', function(Type, ItemData, Amount)
    local SendData = {['Image'] = ItemData['Image'], ['Label'] = ItemData['Label'], ['Amount'] = Amount, ['Type'] = Type}
    SendNUIMessage({
        Action = "ShowItemBox",
        data = SendData
    })
end)

RegisterNetEvent('mercy-inventory/client/inventory-log', function(Text)
    SendNUIMessage({
        Action = 'InventoryLog',
        Text = Text
    })
end)

RegisterNetEvent('mercy-inventory/client/set-required', function(ItemData, Bool)
    if Bool then
        SendNUIMessage({
            Action = "ShowRequired",
            data = ItemData
        })
    else
        SendNUIMessage({Action = "HideRequired"})
    end
end)

RegisterNetEvent('mercy-inventory/client/update-drops', function(DropData, DropId)
    Config.Drops[DropId] = DropData
end)

RegisterNetEvent('mercy-inventory/client/use-weapon', function(ItemData)
    local WeaponName, Ammo = ItemData.ItemName, ItemData.Info ~= nil and ItemData.Info.Ammo or 0
    local CurrentWeapon = GetSelectedPedWeapon(PlayerPedId())

    if GetHashKey(WeaponName) == CurrentWeapon then -- If we have the weapon out
        TriggerEvent('mercy-inventory/client/reset-weapon', true)
        return
    end

    if WeaponName == 'weapon_sniperrifle2' and not exports['mercy-jobs']:InsideHuntingZone() then return end

    Citizen.SetTimeout(15, function()
        exports['mercy-assets']:DoHolsterAnim()
        if Config.Throwables[WeaponName] then Ammo = 1 end

        GiveWeaponToPed(PlayerPedId(), GetHashKey(WeaponName), Ammo, false, false)
        SetPedAmmo(PlayerPedId(), GetHashKey(WeaponName), Ammo)
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey(WeaponName), true)

        local Attachments = HasAnyAttachments()
        if Attachments ~= nil then
            for k, v in pairs(Attachments) do
                GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(WeaponName), GetHashKey(Config.Attachments[v][WeaponName]))
            end
        end

        if WeaponName == 'weapon_glock' then
            GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(WeaponName), GetHashKey('COMPONENT_AT_GLOCK_FLSH'))
        elseif WeaponName == 'weapon_mpx' then
            GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(WeaponName), GetHashKey('COMPONENT_AT_MPX_LASR'))
            GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(WeaponName), GetHashKey('COMPONENT_AT_SCOPE_MPX_02'))
        elseif WeaponName == 'weapon_m4' then
            GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(WeaponName), GetHashKey('COMPONENT_AT_M4_FLSH'))
            GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(WeaponName), GetHashKey('COMPONENT_AT_M4_AFGRIP'))
            GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(WeaponName), GetHashKey('COMPONENT_AT_SCOPE_M4'))
        end
        
        SetWeaponsNoAutoswap(true)
        TriggerEvent('mercy-weapons/client/set-current-weapon', ItemData)
        TriggerEvent('mercy-assets/client/attach-items')
    end)
end)

RegisterNetEvent("mercy-inventory/client/reset-weapon", function(Anim)
    TriggerEvent('mercy-assets/client/reset-holster')
    if Anim ~= nil and Anim then
        exports['mercy-assets']:DoHolsterAnim()
    end
    Citizen.SetTimeout(100, function()
        DisablePlayerFiring(PlayerId(), false)
        SetPlayerCanDoDriveBy(PlayerId(), true)
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
        RemoveAllPedWeapons(PlayerPedId(), true)
        TriggerEvent('mercy-weapons/client/set-current-weapon', nil)
        Citizen.SetTimeout(100, function()
            TriggerEvent('mercy-assets/client/attach-items')
        end)
    end)
end)

RegisterNetEvent('mercy-inventory/client/update-slot-quality', function(Slot, ItemName, CreateDate)
    SendNUIMessage({
        Action = 'UpdateSlotQuality',
        Slot = Slot,
        ItemName = ItemName,
        CreateDate = CreateDate
    })
end)

RegisterNetEvent("mercy-inventory/client/on-fully-degen-item", function(ItemData)
    if ItemData.Type == 'Weapon' then
        TriggerEvent('mercy-inventory/client/reset-weapon')
        TriggerEvent('mercy-assets/client/attach-items')
    end
    if ItemData.ItemName == 'weapon_grapple' then
        TriggerEvent('mercy-grapple/client/used-grapple', true)
    end
    if ItemData.Prop ~= nil and ItemData.Prop then
        TriggerEvent('mercy-assets/client/attach-items')
    end
end)

RegisterNetEvent("mercy-inventory/client/show-button-steal", function(TargetId)
    CurrentStealNumber = TargetId
    SendNUIMessage({Action = "ShowStealButton"})
end)

RegisterNetEvent("mercy-inventory/client/force-close", function()
    SendNUIMessage({Action = "ForceClose"})
end)

RegisterNetEvent('mercy-ui/client/ui-reset', function()
    TriggerEvent('mercy-inventory/client/force-close')
    SetNuiFocus(false, false)
end)

RegisterNetEvent("mercy-inventory/client/update-player", function()
    local PlayerData = PlayerModule.GetPlayerData()
    SendNUIMessage({
        Action = 'RefreshInventory',
        Slots = Config.InventorySlots,
        Items = FormatItemData(PlayerData.Inventory),
        Weight = GetTotalWeight(PlayerData.Inventory),
        PlayerData = PlayerModule,
    })
-- TriggerEvent('mercy-assets/client/attach-items')
end)

RegisterNetEvent("mercy-inventory/client/craft", function(ItemName, Amount, ToSlot, Info, Cost)
    SendNUIMessage({Action = "ForceClose"})
    Citizen.SetTimeout(550, function()
        if not Config.IsCrafting then
            Config.InventoryBusy, Config.IsCrafting = true, true
            exports['mercy-ui']:ProgressBar('Crafting..', math.random(5000, 7500), {['AnimName'] = "fixing_a_player", ['AnimDict'] = "mini@repair", ['AnimFlag'] = 16}, false, false, true, function(DidComplete)
                if DidComplete then
                    StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
                    TriggerServerEvent("mercy-inventory/server/done-crafting", ItemName, Amount, ToSlot, Info, Cost)
                else
                    StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
                end
                Config.InventoryBusy, Config.IsCrafting = false, false
            end)
        end
    end)
end)

-- [ Functions ] --

function InitInventory()
    KeybindsModule.Add('openInventory', 'Player', 'Open Inventory', 'K', function(IsPressed)
        if not IsPressed or not LocalPlayer.state.LoggedIn then return end
        if Config.InventoryBusy then return end

        local PlayerData = PlayerModule.GetPlayerData()
        if PlayerData.MetaData["Dead"] or PlayerData.MetaData["Handcuffed"] then return end
        if UsingKey then return end

        local InvType, InvName, MaxSlots, MaxWeight = nil, nil, nil, nil
        local IsTrunk, Plate, Vehicle = CheckVehicle()
        local NearContainer, Container = CheckContainer()
        local Apartment = exports['mercy-apartment']:IsInsideApartment()

        if Plate ~= nil and not IsTrunk then
            InvName = Plate
            InvType = 'Glovebox'
            MaxSlots, MaxWeight = 4, 50.0
            DoPickupAnimation()
        elseif Plate ~= nil and IsTrunk then
            InvName = Plate
            InvType = 'Trunk'
            MaxSlots = 65
            local VehicleClass = GetVehicleClass(Vehicle)
            local Min, Max = GetModelDimensions(GetEntityModel(Vehicle))
            local VehicleVolume = (Max.x - Min.x) * (Max.y - Min.y) * (Max.z - Min.z)
            local Seats = GetVehicleModelNumberOfSeats(GetEntityModel(Vehicle))

            local ClassModifier = Config.TrunkSpaces[VehicleClass][1]
            local BaseModifier = Config.TrunkSpaces[VehicleClass][2]
            local MaxModifier = Config.TrunkSpaces[VehicleClass][3]

            if BaseModifier == 0 then return end
            local VehSeatMod = (BaseModifier * Seats) / 3
            local VehicleWeightCalc = VehicleVolume * ClassModifier + VehSeatMod

            MaxWeight = math.ceil(VehicleWeightCalc / 50) * 50
            if MaxWeight > MaxModifier then MaxWeight = MaxModifier end
            DoTrunkAnimation(Vehicle, true)
        elseif NearContainer and Container ~= nil then
            InvName = 'HiddenContainer-'..math.ceil(GetEntityCoords(Container).x)..'/'..math.ceil(GetEntityCoords(Container).y)
            InvType = 'Stash'
            MaxSlots, MaxWeight = 200, 2000.0
            DoContainerAnimation()
        elseif Apartment ~= false then
            InvName = 'ApartmentFloor-'..PlayerData.CitizenId
            InvType = 'Temp'
            MaxSlots = 15
            MaxWeight = 500.0
            DoPickupAnimation()
        elseif CurrentDrop ~= 0 then
            InvName = Config.Drops[CurrentDrop]
            InvType = 'Drop'
            MaxSlots = 20
            MaxWeight = 200.0
            DoPickupAnimation()
        else
            TriggerEvent('mercy-inventory/client/open-inventory')
            return
        end
        EventsModule.TriggerServer('mercy-inventory/server/open-other-inventory', InvName, InvType, MaxSlots, MaxWeight, Vehicle or nil)
    end)

    KeybindsModule.Add("openInventoryHotbar", "Player", "Show Inventory Hotbar", 'Z', function(IsPressed)
        if Config.InventoryBusy then return end
        if IsPressed then
            if not ShowingHotbar then
                local PlayerData = PlayerModule.GetPlayerData()
                ShowingHotbar = true
                SendNUIMessage({
                    Action = "ToggleHotbar",
                    Items = FormatItemData(PlayerData.Inventory),
                    Visible = true,
                })
            end
        else
            if ShowingHotbar then
                ShowingHotbar = false
                SendNUIMessage({
                    Action = "ToggleHotbar",
                    Visible = false,
                })
            end
        end
    end)
end

function GetLastUsedSlot()
    return LastUsedSlot
end
exports('GetLastUsedSlot', GetLastUsedSlot)

function GetSlotForItem(ItemName)
    local PlayerData = PlayerModule.GetPlayerData()
    for k, v in pairs(PlayerData.Inventory) do
        if v.ItemName == ItemName and HasEnoughQuality(1, v.Slot) then
            return v.Slot
        end
    end
    return 0
end
exports('GetSlotForItem', GetSlotForItem)

exports("SetBusyState", function(Bool)
    Config.InventoryBusy = Bool
end)

function CanOpenInventory()
    return not Config.InventoryBusy
end
exports('CanOpenInventory', CanOpenInventory)

function GetItemAmount(ItemName)
    if PlayerModule == nil then return 0 end
    local PlayerData = PlayerModule.GetPlayerData()
    if PlayerData.Inventory == nil then return 0 end

    local TotalItems = 0
    for k, v in pairs(PlayerData.Inventory) do
        if v.ItemName == ItemName and HasEnoughQuality(1, v.Slot) then
            TotalItems = TotalItems + v.Amount
        end
    end
    return TotalItems
end
exports('GetItemAmount', GetItemAmount)

function HasEnoughOfItem(ItemName, RequestedAmount)
    local TotalItems = 0
    if PlayerModule == nil then return end
    local PlayerData = PlayerModule.GetPlayerData()
    if PlayerData.Inventory == nil then return false end
    for k, v in pairs(PlayerData.Inventory) do
        if v.ItemName == ItemName and HasEnoughQuality(1, v.Slot) then
            TotalItems = TotalItems + v.Amount
        end
        if TotalItems >= RequestedAmount then
            return true
        end
    end
    return false
end
exports('HasEnoughOfItem', HasEnoughOfItem)

function HasEnoughQuality(MinQuality, Slot)
    local HasEnoughQuality = CallbackModule.SendCallback('mercy-inventory/server/has-item-enough-quality', MinQuality, Slot)
    return HasEnoughQuality
end

function CheckVehicle()
    local Entity, EntityType, EntityCoords = FunctionsModule.GetEntityPlayerIsLookingAt(3.5, 0.2, 286, PlayerPedId())
    if GetVehiclePedIsIn(PlayerPedId()) ~= 0 then
        local Vehicle = GetVehiclePedIsIn(PlayerPedId())
        return false, GetVehicleNumberPlateText(Vehicle), Vehicle
    elseif GetVehiclePedIsIn(PlayerPedId()) == 0 and Entity ~= 0 and GetEntityType(Entity) == 2 and GetVehicleDoorLockStatus(Entity) < 2 then
        local Coords = GetEntityCoords(PlayerPedId())
        local TrunkCoords = GetWorldPositionOfEntityBone(Entity, GetEntityBoneIndexByName(Entity, "boot"))
        if TrunkCoords == vector3(0, 0, 0) then TrunkCoords = GetOffsetFromEntityInWorldCoords(Entity, 0.0, -2.5, 0.0) end

        if Config.BackEngine[GetEntityModel(Entity)] then
            TrunkCoords = GetWorldPositionOfEntityBone(Entity, GetEntityBoneIndexByName(Entity, "bonnet"))
            if TrunkCoords == vector3(0, 0, 0) then TrunkCoords = GetOffsetFromEntityInWorldCoords(Entity, 0.0, 2.5, 0.0) end
        end

        if #(Coords - TrunkCoords) < 1.5 then return true, GetVehicleNumberPlateText(Entity), Entity end
    end

    return false, nil, nil
end

function CheckContainer()
    local Entity, EntityType, EntityCoords = FunctionsModule.GetEntityPlayerIsLookingAt(3.5, 0.2, 286, PlayerPedId())

    if Entity ~= 0 and EntityType == 3 then
        if Config.Containers[GetEntityModel(Entity)] then
            return true, Entity
        end
    end

    return false, nil
end

function FormatItemData(ItemData) 
    local ReturnData = {}
    for k, v in pairs(ItemData) do
        ReturnData[v.Slot] = {
            ['Label'] = v.Label,
            ['ItemName'] = v.ItemName,
            ['Slot'] = v.Slot,
            ['Type'] = v.Type,
            ['Unique'] = v.Unique,
            ['Amount'] = v.Amount,
            ['Image'] = v.Image,
            ['Weight'] = v.Weight,
            ['Info'] = v.Info,
            ['Description'] = v.Description,
            ['Combinable'] = v.Combinable,
        }
    end
    return ReturnData
end

function FormatNoDataItems(ItemData) 
    local ReturnData = {}
    for k, v in pairs(ItemData) do
        local Data = Shared.ItemList[v.ItemName:lower()]
        ReturnData[v.Slot] = {
            ['Label'] = Data['Label'],
            ['ItemName'] = v.ItemName,
            ['Slot'] = v.Slot,
            ['Type'] = Data['Type'],
            ['Unique'] = Data['Unique'],
            ['Amount'] = v.Amount,
            ['Image'] = Data['Image'],
            ['Weight'] = Data['Weight'],
            ['Info'] = v.Info,
            ['Price'] = v.Price ~= nil and v.Price or 0,
            ['Description'] = Data['Description'],
            ['Combinable'] = Data['Combinable'],
            ['Cost'] = Data['Cost'],
        }
    end
    return ReturnData
end

function GetItemData(ItemName)
	return Shared.ItemList[ItemName]
end
exports('GetItemData', GetItemData)

function GetItemByName(Item)
    if Shared.ItemList[Item] == nil then return false end

    local TotalItems = 0
    local PlayerData = PlayerModule.GetPlayerData()
    for k, ItemData in pairs(PlayerData.Inventory) do
        if ItemData.ItemName == Item then
            return ItemData
        end
    end

    return false
end
exports("GetItemByName", GetItemByName)

function GetTotalWeight(Inventory)
    local ReturnWeight = 0
	for k, v in pairs(Inventory) do
		ReturnWeight = ReturnWeight + (v.Weight * v.Amount)
	end
	return ReturnWeight
end

function HasAnyAttachments()
    local ReturnItems = {}
    local PlayerData = PlayerModule.GetPlayerData()
    if next(PlayerData.Inventory) ~= nil then
        for k, v in pairs(PlayerData.Inventory) do
            if Config.Attachments[v.ItemName] ~= nil then
                table.insert(ReturnItems, v.ItemName)
            end
        end
    end
    return ReturnItems
end

function CheckContainer()
    local Entity, EntityType, EntityCoords = FunctionsModule.GetEntityPlayerIsLookingAt(3.5, 0.2, 286, PlayerPedId())

    if Entity ~= 0 and GetEntityType(Entity) == 3 then 
        if Config.Containers[GetEntityModel(Entity)] then
            return true, Entity
        end
    end

    return false, nil
end

function DoPickupAnimation()
    Citizen.CreateThread(function()
        RequestAnimDict("pickup_object")
        FunctionsModule.RequestAnimDict('pickup_object')
        TaskPlayAnim(PlayerPedId(),'pickup_object', 'putdown_low',5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
        Wait(1000)
        ClearPedSecondaryTask(PlayerPedId())
    end)
end

function DoContainerAnimation()
    TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
end

function DoTrunkAnimation(Vehicle, Open)
    Citizen.CreateThread(function()
        if Open then
            TaskTurnPedToFaceEntity(PlayerPedId(), Vehicle, 1.0)
            VehicleModule.SetVehicleDoorOpen(Vehicle, 5)
            FunctionsModule.RequestAnimDict('mini@repair')
            TaskPlayAnim(PlayerPedId(), 'mini@repair', 'fixing_a_player', 8.0, -8, -1, 16, 0, 0, 0, 0);
        else
            StopAnimTask(PlayerPedId(), 'mini@repair', 'fixing_a_player', 1.0)
            VehicleModule.SetVehicleDoorShut(Vehicle, 5)
        end
    end)
end

-- [ NUI Calbacks ] --

RegisterNUICallback('IsHoldingWeapon', function(data, cb)
    local Weapon = GetSelectedPedWeapon(PlayerPedId())
    if Weapon ~= GetHashKey('weapon_unarmed') and IsPedArmed(PlayerPedId(), 6) then
        cb(true)
    else
        cb(false)
    end
end)

RegisterNUICallback('UseItem', function(Data)
    UsingKey = true
    LastUsedSlot = Data.Slot
    Citizen.SetTimeout(150, function()
        EventsModule.TriggerServer('mercy-inventory/server/use-item', Data.Slot)
        Citizen.Wait(450)
        UsingKey = false
    end)
end)

RegisterNUICallback('RefreshInv', function(data)
    local PlayerData = PlayerModule.GetPlayerData()
    SendNUIMessage({
        Action = 'RefreshInventory',
        Slots = Config.InventorySlots,
        Items = FormatItemData(PlayerData.Inventory),
        Weight = GetTotalWeight(PlayerData.Inventory),
        PlayerData = PlayerData,
    })
    TriggerEvent('mercy-assets/client/attach-items')
end)

RegisterNUICallback('DoItemData', function(data, Cb)
    local SendData = {['Amount'] = data.Amount, ['ToSlot'] = data.ToSlot, ['FromSlot'] = data.FromSlot, ['ToInventory'] = data.ToInv, ['FromInventory'] = data.FromInv, ['Type'] = data.Type, ['SubType'] = data.SubType, ['OtherItems'] = data.OtherItems, ['ExtraData'] = data.ExtraData, ['MaxOtherWeight'] = data.MaxOtherWeight}
    local DidData = CallbackModule.SendCallback('mercy-inventory/server/do-item-data', SendData)
    Cb(DidData)
end)

RegisterNUICallback('CloseInventory', function(Data, Cb)
    -- Config.InventoryBusy = false
    TriggerServerEvent('mercy-inventory/server/closed', Data.OtherInv, Data.OtherName)
    SetTimecycleModifier('default')
    if IsEntityPlayingAnim(PlayerPedId(), 'mini@repair', 'fixing_a_player', 3) then
        if Data.ExtraData ~= nil then
            DoTrunkAnimation(Data.ExtraData, false)
        end
    elseif Data.OtherName ~= nil and string.match(Data.OtherName, "HiddenContainer") then
        ClearPedTasks(PlayerPedId())
    else
        DoPickupAnimation()
    end
    TriggerServerEvent('mercy-inventory/server/check-other', Data.OtherInv, Data.OtherName)
    TriggerEvent('mercy-animations/client/clear-animation')
    CurrentStealNumber = nil
    UsingKey = true
    Citizen.SetTimeout(500, function()
        UsingKey = false
    end)
    SetNuiFocus(false, false)
    Cb('Ok')
end)

RegisterNUICallback('StealMoney', function()
    TriggerServerEvent('mercy-inventory/server/steal-money', CurrentStealNumber)
    CurrentStealNumber = nil
end)

RegisterNUICallback('ResetWeapons', function()
    TriggerEvent('mercy-inventory/client/reset-weapon')
end)

RegisterNUICallback('ErrorSound', function()
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)

RegisterNUICallback('CopyToClipboard', function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
    exports['mercy-ui']:Notify("copied", "Copied item info..", "success", 3000)
end)

RegisterNUICallback('SuccessSound', function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback('SaveInventory', function(data)
    if data.Type == 'TableInput' then
        local InventoryData = data.InventoryData
        InventorySaveData[tonumber(InventoryData['Slot'])] = {
            Label = InventoryData['Label'],
	    	ItemName = InventoryData['ItemName'],
	    	Slot = tonumber(InventoryData['Slot']),
	    	Type = InventoryData['Type'],
	    	Unique = InventoryData['Unique'],
	    	Amount = InventoryData['Amount'],
	    	Image = InventoryData['Image'],
	    	Weight = InventoryData['Weight'],
	    	Info = InventoryData['Info'],
	    	Description = InventoryData['Description'],
	    	Combinable = InventoryData['Combinable'],
        }
    elseif data.Type == 'SaveNow' then
        TriggerServerEvent('mercy-inventory/server/set-player-items', InventorySaveData)
        InventorySaveData = {}
    end
end)

RegisterNUICallback('CombineItems', function(data)
    Citizen.SetTimeout(1500, function()
        exports['mercy-inventory']:SetBusyState(true)
        exports['mercy-ui']:ProgressBar('Combining..', math.random(5000, 6500), {['AnimName'] = "idle_c", ['AnimDict'] = "amb@world_human_clipboard@male@idle_a", ['AnimFlag'] = 49}, false, false, true, function(DidComplete)
            if DidComplete then
                StopAnimTask(PlayerPedId(), "amb@world_human_clipboard@male@idle_a", "idle_c", 1.0)
                TriggerServerEvent("mercy-inventory/server/done-combinding", data.FromSlot, data.FromItem, data.ToSlot, data.ToItem, data.Reward)
                exports['mercy-inventory']:SetBusyState(false)
            else
                StopAnimTask(PlayerPedId(), "amb@world_human_clipboard@male@idle_a", "idle_c", 1.0)
                exports['mercy-inventory']:SetBusyState(false)
            end
        end)
    end)
end)
