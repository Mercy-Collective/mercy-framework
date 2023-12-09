-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(100)
    end
   
    CommandsModule.Add({"giveitem", "gi"}, "Spawn in item", {{Name="id", Help="Player ID"}, {Name="itemname", Help="Item Name"}, {Name="amount", Help="Item Amount"}}, false, function(Source, args)
        local PlayerId = args[1] ~= nil and args[1] or Source 
        local Amount = args[3] ~= nil and tonumber(args[3]) or 1
        local ItemName = args[2]
        local Player = PlayerModule.GetPlayerBySource(tonumber(PlayerId))
        if Player ~= nil then
            local ItemData = GetItemData(ItemName)
            if ItemData then
                if ItemData['Unique'] then
                    for i=1, Amount do
                        Player.Functions.AddItem(ItemName, 1, false, nil, true)
                    end
                else
                    Player.Functions.AddItem(ItemName, Amount, false, nil, true)
                end
                if ItemData['Type'] == 'Weapon' then
                    TriggerClientEvent('mercy-assets/client/attach-items', Source)
                end
            end
        end
    end, "admin")
    
    CommandsModule.Add({"removeitem", "ri"}, "Delete someone's item", {{Name="id", Help="Player ID"}, {Name="itemname", Help="Item Name or all"}, {Name="amount", Help="Item Amount"}}, false, function(Source, args)
        local PlayerId = args[1] ~= nil and args[1] or Source 
        local Player = PlayerModule.GetPlayerBySource(tonumber(PlayerId))
        local Item = args[2] ~= nil and args[2] or 'all'
        local Amount = args[3] ~= nil and args[3] or 1
        if Player ~= nil then 
            if Item ~= nil and Item:lower() == 'all' then
                for k, v in pairs(Player.PlayerData.Inventory) do
                    Player.Functions.RemoveItem(v.ItemName, v.Amount, nil, true)
                end
            elseif Item ~= nil then
                local ItemData = GetItemData(Item)
                if ItemData['Unique'] then
                    for i=1, Amount do
                        Player.Functions.RemoveItem(Item, 1, false, true)
                    end
                else
                    Player.Functions.RemoveItem(Item, Amount, false, true)
                end
            end
        else
            Player.Functions.Notify('not-found', 'Player not online!', 'error')
        end
    end, "admin")

    CommandsModule.Add({"resetinv"}, "Reset inventory if can't be opened", {{Name="Type", Help="Type: Stash/Drop/Crafting/Glovebox/Trunk"},{Name="Name", Help="Inventory Name"}}, true, function(Source, args)
        local InventoryType = args[1]:lower()
        local Player = PlayerModule.GetPlayerBySource(Source)
        table.remove(args, 1)
        local StashName = table.concat(args, " ")
        if InventoryType == 'drop' then
            if OpenInventories['D'..StashName] ~= nil then
                OpenInventories['D'..StashName] = false
            else
                Player.Functions.Notify('not-exists', "This inventory does not exist..", 'error')
            end
        elseif InventoryType == 'trunk' then
            if OpenInventories['T'..StashName] ~= nil then
                OpenInventories['T'..StashName] = false
            else
                Player.Functions.Notify('not-exists', "This inventory does not exist..", 'error')
            end
        elseif InventoryType == 'glovebox' then
            if OpenInventories['G'..StashName] ~= nil then
                OpenInventories['G'..StashName] = false
            else
                Player.Functions.Notify('not-exists', "This inventory does not exist..", 'error')
            end
        elseif InventoryType == 'crafting' then
            if OpenInventories['C'..StashName] ~= nil then
                OpenInventories['C'..StashName] = false
            else
                Player.Functions.Notify('not-exists', "This inventory does not exist..", 'error')
            end
        elseif InventoryType == 'stash' then
            if OpenInventories[StashName] ~= nil then
                OpenInventories[StashName] = false
            else
                Player.Functions.Notify('not-exists', "This inventory does not exist..", 'error')
            end
        end
    end, 'admin')
end)