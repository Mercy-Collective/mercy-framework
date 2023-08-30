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
            return print('[DEBUG:MoveItems]: Inventory is empty.')
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
            if FunctionsModule.CanUseItem(ItemData.ItemName) then
                TriggerClientEvent('mercy-inventory/client/item-box', Source, 'Used', Shared.ItemList[ItemData.ItemName], false)
                FunctionsModule.UseItem(Source, ItemData)
            elseif ItemData['Type'] == 'Weapon' then
                if ItemData.Info.Quality ~= nil then
                    if ItemData.Info.Quality > 0 then
                        TriggerClientEvent('mercy-inventory/client/item-box', Source, 'Used', Shared.ItemList[ItemData.ItemName], false)
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
        if not Player then return Cb(false) end

        local ItemData = Player.Functions.GetItemBySlot(Slot)
        if ItemData.Quality == nil then return Cb(true) end
        if ItemData.Quality <= MinQuality then return Cb(false) end

        Cb(true)
    end)

    EventsModule.RegisterServer('mercy-inventory/server/degen-item', function(Source, Slot, Amount)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local ItemData = Player.Functions.GetItemBySlot(Slot)
        if ItemData.Quality ~= nil then
            if ItemData.Quality > 0 then
                if ItemData.Quality - Amount <= 0 then
                    ItemData.Quality = 0
                    TriggerClientEvent('mercy-inventory/client/on-fully-degen-item', Source, ItemData)
                else
                    ItemData.Quality = ItemData.Quality - Amount
                end
            end
        end
    end)

    EventsModule.RegisterServer('mercy-inventory/server/add-item', function(Source, ItemName, Amount, Slot, ItemInfo, Show)
        local Player = PlayerModule.GetPlayerBySource(Source)
        Player.Functions.AddItem(ItemName, Amount, Slot, ItemInfo, Show)
    end)
end)