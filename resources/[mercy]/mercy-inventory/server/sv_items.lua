local MaxTime = (((1000 * 60) * 60) * 24) * 28

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(100)
    end

    EventsModule.RegisterServer('mercy-inventory/server/move-items-to-stash', function(Source, PlayerInv, ToInv)
        local Player = PlayerModule.GetPlayerBySource(Source)
        -- Check if inventory is empty
        if next(Player.PlayerData.Inventory) == nil then
            return DebugPrint('MoveItems', 'Inventory is empty.')
        end
        SaveInventoryData('Stash', ToInv, Player.PlayerData.Inventory)
        Citizen.SetTimeout(500, function()
            Player.Functions.ClearInventory()
            Player.Functions.Save()
        end)
    end)
   
    EventsModule.RegisterServer('mercy-inventory/server/use-item', function(Source, Slot)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local ItemData = Player.Functions.GetItemBySlot(Slot)
        if ItemData ~= nil and ItemData.Amount > 0 then
            if FunctionsModule.CanUseItem(ItemData.ItemName) or ItemData['Type'] == 'Weapon' then
                if ItemData.Info.Quality ~= nil then
                    if ItemData.Info.Quality > 0 then
                        TriggerClientEvent('mercy-inventory/client/item-box', Source, 'Used', Shared.ItemList[ItemData.ItemName], false)
                        if ItemData['Type'] ~= 'Weapon' then
                            FunctionsModule.UseItem(Source, ItemData)
                            return
                        end
                        TriggerClientEvent('mercy-inventory/client/use-weapon', Source, ItemData)
                    else
                        Player.Functions.Notify("broken-item", "Item is broken..", 'error')
                    end
                else
                    Player.Functions.Notify("no-quality-item", "No quality found..", 'error')
                end
            end
        end
    end)

    CallbackModule.CreateCallback('mercy-inventory/server/has-item-enough-quality', function(Source, Cb, MinQuality, Slot)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if not Player then return Cb(true) end

        local ItemData = Player.Functions.GetItemBySlot(Slot)
        if ItemData == nil then return Cb(true) end
        if ItemData.Info.Quality == nil then return Cb(true) end
        if ItemData.Info.Quality <= MinQuality then return Cb(false) end

        Cb(true)
    end)

    EventsModule.RegisterServer('mercy-inventory/server/degen-item', function(Source, Slot, Amount)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local ItemData = Player.Functions.GetItemBySlot(Slot)
    
        if ItemData == nil or Amount <= 0 then
            return
        end
    
        local CurrentQuality = GetQuality(ItemData.ItemName, ItemData.Info.CreateDate)
        if CurrentQuality == nil then
            DebugPrint('DegenItem', 'CurrentQuality is nil. Item will not degrade.')
            return
        end

        if CurrentQuality == 0 then
            TriggerClientEvent('mercy-inventory/client/on-fully-degen-item', Source, ItemData)
            return
        end
    
        if ItemData.Info.Quality ~= nil then
            local NewQuality = CurrentQuality - Amount
            if NewQuality < 0 then
                NewQuality = 0
            end
    
            -- Calculate the new CreateDate based on the current quality
            local OriginalQuality = GetQuality(ItemData.ItemName, ItemData.Info.CreateDate)
            local DecayR = Shared.ItemList[ItemData.ItemName].DecayRate

            if DecayR == 0.0 then
                DebugPrint('DegenItem', 'DecayRate is 0.0. Item will not degrade.')
                return
            end

            local TimeExtra = MaxTime * DecayR
    
            -- Calculate the time difference to achieve the new quality
            local QualityDifference = OriginalQuality - NewQuality
            local TimeDifference = (QualityDifference / 100) * TimeExtra
    
            -- Calculate the new CreateDate as a timestamp
            local NewCreateDate = math.floor((ParseDate(ItemData.Info.CreateDate) - TimeDifference) / 1000)
    
            ItemData.Info.Quality = NewQuality
            ItemData.Info.CreateDate = os.date("%a %b %d %H:%M:%S %Y", NewCreateDate)

            Player.PlayerData.Inventory[Slot].Info.Quality = NewQuality
            Player.PlayerData.Inventory[Slot].Info.CreateDate = os.date("%a %b %d %H:%M:%S %Y", NewCreateDate)
            Player.Functions.SetItemData(Player.PlayerData.Inventory)
            TriggerClientEvent('mercy-inventory/client/update-player', Source)
            DebugPrint('DegenItem', 'Updating quality of '..Player.PlayerData.Inventory[Slot].ItemName..'.. \nNew Quality: ' .. NewQuality .. '\nNew CreateDate: ' .. ItemData.Info.CreateDate)
            if NewQuality < 1 then
                TriggerClientEvent('mercy-inventory/client/on-fully-degen-item', Source, ItemData)
            end
        else
            DebugPrint('DegenItem', 'No quality found..')
        end
    end)

    EventsModule.RegisterServer('mercy-inventory/server/add-item', function(Source, ItemName, Amount, Slot, ItemInfo, Show)
        local Player = PlayerModule.GetPlayerBySource(Source)
        Player.Functions.AddItem(ItemName, Amount, Slot, ItemInfo, Show)
    end)
end)

-- [ Functions ] --

function ParseDate(dateString)
    if dateString == nil then
        DebugPrint('ParseDate', 'dateString is nil.')
        return false
    end
    local monthNames = {Jan = 1, Feb = 2, Mar = 3, Apr = 4, May = 5, Jun = 6, Jul = 7, Aug = 8, Sep = 9, Oct = 10, Nov = 11, Dec = 12}
    local day, month, dayNum, time, year = dateString:match("(%a+) (%a+) (%s?%d+) (%d+:%d+:%d+) (%d+)")
    local monthNum = monthNames[month]

    if day and monthNum and dayNum and time and year then
        local timestamp = os.time({year = year, month = monthNum, day = dayNum, hour = time:match("(%d+):%d+:%d+"), min = time:match("%d+:(%d+):%d+"), sec = time:match("%d+:%d+:(%d+)")})
        return timestamp * 1000 -- Convert to milliseconds
    else
        return false
    end
end

function GetQuality(ItemName, CreateDate)
    DebugPrint('GetQuality', 'Getting quality of '..ItemName..' with CreateDate: '..CreateDate)
    local StartDate = ParseDate(CreateDate)

    if not StartDate then
        DebugPrint("GetQuality", "Failed to get quality for item " .. ItemName .. ".")
        return
    end

    if Shared.ItemList[ItemName] == nil then
        DebugPrint("GetQuality", "Failed to get quality for item " .. ItemName .. ".")
        return
    end

    local DecayRate = Shared.ItemList[ItemName].DecayRate
    local TimeExtra = MaxTime * DecayRate
    local Quality = 100 - math.ceil(((os.time() * 1000 - StartDate) / TimeExtra) * 100)

    if DecayRate == 0.0 then
        Quality = 100
    end

    if Quality <= 0 then
        Quality = 0
    end

    if Quality > 99.0 then
        Quality = 100
    end

    return Quality
end

function DebugPrint(Type, Message, ...)
    if ... ~= nil then
        print(('^4[^5Debug^4:^5Inventory^4:^5%s^4]:^7 %s %s'):format(Type, Message, ...))
    else
        print(('^4[^5Debug^4:^5Inventory^4:^5%s^4]:^7 %s'):format(Type, Message))
    end
end