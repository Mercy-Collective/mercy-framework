local OpenInventories = {}
local DropSlots = 16
local TypeItems = {
	Stash = {}, -- DB
	Trunk = {}, -- DB
	Glovebox = {}, -- DB
	Temp = {},
}

CallbackModule, PlayerModule, DatabaseModule, FunctionsModule, CommandsModule, EventsModule = nil, nil, nil, nil, nil, nil

_Ready = false
AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Callback',
        'Player',
        'Database',
        'Functions',
        'Commands',
        'Events',
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        DatabaseModule = exports['mercy-base']:FetchModule('Database')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
        CommandsModule = exports['mercy-base']:FetchModule('Commands')
        EventsModule = exports['mercy-base']:FetchModule('Events')
		_Ready = true
	end)
end)

-- [ Code ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(100)
    end

	EventsModule.RegisterServer('mercy-inventory/server/open-other-inventory', function(Source, OtherData, Type, Slots, MaxWeight, ExtraData, ExtraType)
		local Player = PlayerModule.GetPlayerBySource(Source)
		local Slots = Slots ~= nil and Slots or DropSlots
		TriggerEvent('mercy-inventory/server/inventory-opened', Source, Type, OtherData)
		local TotalData = {}
		if Type == 'Glovebox' or Type == 'Trunk' or Type == 'Stash' or Type == 'Crafting' or Type == 'Temp' then
			if not OpenInventories[string.sub(Type, 1, 1)..OtherData] then
				if Type ~= 'Crafting' and Type ~= 'Temp' then -- Crafting and Temp does not have database items
					if TypeItems[Type][OtherData] == nil then
						TypeItems[Type][OtherData] = GetDBItems(Type, OtherData)
					end
					if TypeItems[Type][OtherData] == nil then TypeItems[Type][OtherData] = {} end
				end
				if Type == 'Temp' then
					if TypeItems[Type][OtherData] == nil then TypeItems[Type][OtherData] = {} end
				end
				
				local InvName = (Type ~= 'Crafting' and Type ~= 'Temp') and (Type..': '..OtherData) or OtherData -- Temp and Crafting only shows name not type.
				TotalData = {
					['Type'] = Type, 
					['SubType'] = OtherData, 
					['InvName'] = InvName, 
					['InvSlots'] = Slots ~= nil and Slots or 0, 
					['MaxWeight'] = MaxWeight ~= nil and MaxWeight or 0, 
					['Items'] = TypeItems[Type] ~= nil and TypeItems[Type][OtherData] or ExtraData ~= nil and ExtraData or {}, 
					['ExtraData'] = ExtraData ~= nil and ExtraData or {}
				}

				Citizen.SetTimeout(5, function()
					OpenInventories[string.sub(Type, 1, 1)..OtherData] = true
				end)
			else
				TriggerClientEvent('mercy-inventory/client/open-empty-other', Source)
				return
			end
		elseif Type == 'Player' then
			if not OpenInventories['OT'..OtherData] then
				local OtherPlayer = PlayerModule.GetPlayerByStateId(tonumber(OtherData))
				if OtherPlayer ~= nil then
					TotalData = {
						['Type'] = Type, 
						['SubType'] = tonumber(OtherData), 
						['InvName'] = Type..'-'..tonumber(OtherData), 
						['InvSlots'] = Config.InventorySlots, 
						['MaxWeight'] = Config.MaxInventoryWeight, 
						['Items'] = OtherPlayer.PlayerData.Inventory
					}
					TriggerClientEvent('mercy-inventory/client/set-inventory-state', tonumber(OtherData), true)
					Citizen.SetTimeout(5, function()
						OpenInventories['OT'..OtherData] = true
					end)
				else
					TriggerClientEvent('mercy-inventory/client/open-empty-other', Source)
					return
				end
			else
				TriggerClientEvent('mercy-inventory/client/open-empty-other', Source)
				return
			end
		elseif Type == 'Drop' then
			if not OpenInventories['D'..OtherData['SubType']] then
				TriggerClientEvent('mercy-inventory/client/open-inventory-other', Source, OtherData)
				Citizen.SetTimeout(5, function()
					OpenInventories['D'..OtherData['SubType']] = true
				end)
				return
			else
				TriggerClientEvent('mercy-inventory/client/open-empty-other', Source)
				return
			end
		else
			TotalData = {
				['Type'] = Type, 
				['SubType'] = ExtraType, 
				['InvName'] = OtherData, 
				['Cash'] = Player.PlayerData.Money['Cash'], 
				['InvSlots'] = Slots ~= nil and Slots or 0, 
				['MaxWeight'] = MaxWeight ~= nil and MaxWeight or 0, 
				['Items'] = ExtraData ~= nil and ExtraData or {}, 
				['ExtraData'] = ExtraData ~= nil and ExtraData or {}
			}
		end
		TriggerClientEvent('mercy-inventory/client/open-inventory-other', Source, TotalData)
	end)

	CallbackModule.CreateCallback('mercy-inventory/server/do-item-data', function(Source, Cb, data)
		local Player, OtherPlayer = PlayerModule.GetPlayerBySource(Source), PlayerModule.GetPlayerBySource(data['SubType']) ~= nil and PlayerModule.GetPlayerBySource(data['SubType']) or PlayerModule.GetPlayerByStateId(tonumber(data['SubType'])) 
		
		local OtherInventoryItems, ExtraData, MaxOtherWeight = data['OtherItems'], data['ExtraData'], data['MaxOtherWeight']
		local Amount, Type, SubType = tonumber(data['Amount']), data['Type'], data['SubType']
		local ToSlot, FromSlot = tonumber(data['ToSlot']), tonumber(data['FromSlot'])
		local ToInventory, FromInventory = data['ToInventory'], data['FromInventory']

		-- Other -> My
		if ToInventory == '.my-inventory-blocks' and FromInventory == '.other-inventory-blocks' then
			if Type == 'Store' then
				local StoreItem = Shared.ItemList[OtherInventoryItems[FromSlot]['ItemName']:lower()]
				local TaxPrice = FunctionsModule.GetTaxPrice((StoreItem.Price * Amount), 'Goods')
				if Player.Functions.RemoveMoney('Cash', TaxPrice) then
					if StoreItem['Type'] == 'Weapon' and not StoreItem['Melee'] then
						local SerialNumber = SubType == 'PoliceStore' and Player.PlayerData.Job.Serial or Shared.RandomStr(2)..Shared.RandomInt(3):upper()..Shared.RandomStr(3)..Shared.RandomInt(3):upper()..Shared.RandomStr(2)..Shared.RandomInt(3):upper()
						OtherInventoryItems[FromSlot].Info = {Quality = 100, CreateDate = os.date(), Ammo = 1, Serial = SerialNumber}
					else
						OtherInventoryItems[FromSlot].Info = {Quality = 100, CreateDate = os.date()}
					end
					if Player.Functions.AddItem(StoreItem['ItemName'], Amount, ToSlot, OtherInventoryItems[FromSlot].Info, false, 'Inventory') then
						Cb(true)
					else
						Player.Functions.AddMoney('Cash', TaxPrice)
						Player.Functions.Notify('invalid-action', 'Failed to buy item. Maybe we are full?', 'error')
						Cb(false)
					end
				else
					Cb(false)
				end
			elseif Type == 'Drop' then
				if Config.Drops[SubType] == nil and Config.Drops[SubType]['Items'] == nil then return Cb(false) end
				if Config.Drops[SubType]['Items'][FromSlot] == nil then return Cb(false) end

				if Player.Functions.AddItem(Config.Drops[SubType]['Items'][FromSlot]['ItemName'], Amount, ToSlot, Config.Drops[SubType]['Items'][FromSlot].Info, false, 'Inventory') then
					TriggerClientEvent("mercy-inventory/client/inventory-log", Source, "Picked up  "..Amount..'x '..Config.Drops[SubType]['Items'][FromSlot]['ItemName'].. " from Drop. ("..SubType..")")
					if (Config.Drops[SubType]['Items'][FromSlot].Amount - Amount) == 0 then
						Config.Drops[SubType]['Items'][FromSlot] = nil
						Config.Drops[SubType]['ItemCount'] = #Config.Drops[SubType]['Items']
					else
						Config.Drops[SubType]['Items'][FromSlot].Amount = Config.Drops[SubType]['Items'][FromSlot].Amount - Amount
						Config.Drops[SubType]['ItemCount'] = #Config.Drops[SubType]['Items']
					end
					CheckDropInventory(SubType)
					TriggerClientEvent('mercy-inventory/client/update-drops', -1, Config.Drops[SubType], SubType)
					Cb(true)
				else
					Cb(false)
				end
			elseif Type == 'Trunk' or Type == 'Glovebox' or Type == 'Stash' or Type == 'Temp' then
				local DBItems = TypeItems[Type][SubType] ~= nil and TypeItems[Type][SubType] or TriggerClientEvent('mercy-inventory/client/force-close', Source)
				if DBItems == nil and DBItems[FromSlot] == nil then return Cb(false) end

				if Player.Functions.AddItem(DBItems[FromSlot]['ItemName'], Amount, ToSlot, DBItems[FromSlot].Info, false, 'Inventory') then
					TriggerClientEvent("mercy-inventory/client/inventory-log", Source, "Took  "..Amount..'x '..DBItems[FromSlot]['ItemName'].. " out of "..Type.." ("..SubType..")")
					if (DBItems[FromSlot].Amount - Amount) == 0 then
						DBItems[FromSlot] = nil
					else
						DBItems[FromSlot].Amount = DBItems[FromSlot].Amount - Amount
					end
					SaveInventoryData(Type, SubType, DBItems)

					Cb(true)
				else
					Cb(false)
				end				
			elseif Type == 'Player' then
				local Item = OtherPlayer.PlayerData.Inventory[FromSlot]['ItemName']:lower()
				if Player.Functions.AddItem(Item, Amount, ToSlot, OtherPlayer.PlayerData.Inventory[FromSlot].Info, false, 'Inventory') then
					local ItemDataFrom = GetItemData(Item)
					TriggerClientEvent("mercy-inventory/client/inventory-log", Source, "Took "..Amount..'x '..Item.. " out of inventory of "..OtherPlayer.PlayerData.Name..".")
					OtherPlayer.Functions.RemoveItem(Item, Amount, FromSlot, false)
					if ItemDataFrom['Type'] == 'Weapon' then
						TriggerClientEvent('mercy-inventory/client/reset-weapon', OtherPlayer.PlayerData.Source)
					end
					TriggerClientEvent('mercy-inventory/client/update-player', OtherPlayer.PlayerData.Source)
					Cb(true)
				else
					Cb(false)
				end
			elseif Type == 'Crafting' then
				local Item = OtherInventoryItems[FromSlot]['ItemName']:lower()
				if HasCraftingItems(Source, Shared.ItemList[Item]['Cost'], Amount) then
					if Shared.ItemList[Item]['Type'] == 'Weapon' and not Shared.ItemList[Item]['Melee'] then
						OtherInventoryItems[FromSlot]['Info'] = {Quality = 100, CreateDate = os.date(), Ammo = 1, Serial = Shared.RandomStr(2)..Shared.RandomInt(3):upper()..Shared.RandomStr(3)..Shared.RandomInt(3):upper()..Shared.RandomStr(2)..Shared.RandomInt(3):upper()}
					else
						OtherInventoryItems[FromSlot]['Info'] = {Quality = 100, CreateDate = os.date()}
					end
					TriggerClientEvent('mercy-inventory/client/craft', Source, Item, Amount, ToSlot, OtherInventoryItems[FromSlot]['Info'], Shared.ItemList[Item]['Cost'])
					Cb('Crafting')
				else
					Cb(false)
				end
			end
		-- My -> Other
		elseif ToInventory == '.other-inventory-blocks' and FromInventory == '.my-inventory-blocks' then
			if Type == 'Drop' then
				if Config.Drops[SubType] ~= nil and Config.Drops[SubType]['Items'] ~= nil then
					local TotalWeight = GetTotalWeight(Config.Drops[SubType]['Items'])
					if Player.PlayerData.Inventory[FromSlot] == nil then return Cb(false) end
					if not WeightCheck(MaxOtherWeight, TotalWeight, Amount, Player.PlayerData.Inventory[FromSlot].Weight) then return Cb(false) end

					local Item = Player.PlayerData.Inventory[FromSlot]['ItemName']:lower()
					if Player.Functions.RemoveItem(Item, Amount, FromSlot, false) then
						TriggerClientEvent("mercy-inventory/client/inventory-log", Source, "Threw "..Amount..'x '..Item.. " on ground. ("..SubType..")")
						if Config.Drops[SubType]['Items'][ToSlot] == nil then
							Config.Drops[SubType]['Items'][ToSlot] = {
								ItemName = Item,
								Slot = ToSlot,
								Amount = Amount,
								Info = Player.PlayerData.Inventory[FromSlot].Info,
							}
						else
							Config.Drops[SubType]['Items'][ToSlot].Amount = Config.Drops[SubType]['Items'][ToSlot].Amount + Amount
						end
						Config.Drops[SubType]['ItemCount'] = #Config.Drops[SubType]['Items']
						TriggerClientEvent('mercy-inventory/client/update-drops', -1, Config.Drops[SubType], SubType)
						Cb(true)
					else
						Cb(false)
					end
				else
					if Player.PlayerData.Inventory[FromSlot] == nil then return Cb(false) end
					local PlayerCoords = GetEntityCoords(GetPlayerPed(Source))
					local Item = Player.PlayerData.Inventory[FromSlot]['ItemName']:lower()

					if not WeightCheck(MaxOtherWeight, 0, Amount, Player.PlayerData.Inventory[FromSlot].Weight) then return Cb(false) end

					if Player.Functions.RemoveItem(Item, Amount, FromSlot, false) then
						TriggerClientEvent("mercy-inventory/client/inventory-log", Source, "Threw "..Amount..'x '..Item.. " on ground. ("..SubType..")")
						Config.Drops[SubType] = {
							['SubType'] = SubType,
							['Type'] = 'Drop',
							['InvName'] = 'Drop'..SubType,
							['InvSlots'] = DropSlots,
							['Coords'] = vector3(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z),
							['Heading'] = PlayerCoords.w,
							['ItemCount'] = 1,
							['MaxWeight'] = Config.MaxDropWeight,
							['Items'] = {
								[ToSlot] = {
									ItemName = Item,
									Slot = ToSlot,
									Amount = Amount,
									Info = Player.PlayerData.Inventory[FromSlot].Info,
								},
							},
						}
						OpenInventories['D'..SubType] = true
						TriggerClientEvent('mercy-inventory/client/update-drops', -1, Config.Drops[SubType], SubType)
						Cb(true)
					else
						Cb(false)
					end
				end
			elseif Type == 'Trunk' or Type == 'Glovebox' or Type == 'Stash' or Type == 'Temp' then
				local DBItems = TypeItems[Type][SubType] ~= nil and TypeItems[Type][SubType] or TriggerClientEvent('mercy-inventory/client/force-close', Source)
				local TotalWeight = GetTotalWeight(DBItems)

				if Player.PlayerData.Inventory[FromSlot] == nil then return Cb(false) end
				if not WeightCheck(MaxOtherWeight, TotalWeight, Amount, Player.PlayerData.Inventory[FromSlot].Weight) then return Cb(false) end

				local Item = Player.PlayerData.Inventory[FromSlot]['ItemName']:lower()
				if Player.Functions.RemoveItem(Item, Amount, FromSlot, false) then
					TriggerClientEvent("mercy-inventory/client/inventory-log", Source, "Put "..Amount..'x '..Item.. " in "..Type..". ("..SubType..")")
					if DBItems[ToSlot] == nil then
						DBItems[ToSlot] = {
							ItemName = Item,
							Slot = ToSlot,
							Amount = Amount,
							Info = Player.PlayerData.Inventory[FromSlot].Info,
						}
					else
						DBItems[ToSlot].Amount = DBItems[ToSlot].Amount + Amount
					end
					SaveInventoryData(Type, SubType, DBItems)
					Cb(true)
				else
					Cb(false)
				end
			elseif Type == 'Player' then
				if OtherPlayer.Functions.AddItem(Player.PlayerData.Inventory[FromSlot].ItemName, Amount, ToSlot, Player.PlayerData.Inventory[FromSlot].Info, false, 'Inventory') then
					if Player.Functions.RemoveItem(Player.PlayerData.Inventory[FromSlot].ItemName, Amount, FromSlot, false) then
						TriggerClientEvent("mercy-inventory/client/inventory-log", Source, "Put "..Amount..'x '..Player.PlayerData.Inventory[FromSlot].ItemName.. " in inventory of "..OtherPlayer.PlayerData.Name..".")
						TriggerClientEvent('mercy-inventory/client/update-player', OtherPlayer.PlayerData.Source)
						Cb(true)
					else
						Cb(false)
					end
				else
					Cb(false)
				end
			end
		-- Other -> Other
		elseif ToInventory == '.other-inventory-blocks' and FromInventory == '.other-inventory-blocks' then
			if Type == 'Drop' then
				if ExtraData == 'Swap' then
					local DataFrom = Config.Drops[SubType]['Items'][FromSlot]
					local DataTo = Config.Drops[SubType]['Items'][ToSlot]
					Config.Drops[SubType]['Items'][ToSlot] = { 
						ItemName = DataFrom.ItemName, 
						Slot = ToSlot, 
						Amount = DataFrom.Amount, 
						Info = DataFrom.Info, 
					}
					Config.Drops[SubType]['Items'][FromSlot] = { 
						ItemName = DataTo.ItemName, 
						Slot = FromSlot, 
						Amount = DataTo.Amount, 
						Info = DataTo.Info, 
					}
					Config.Drops[SubType]['ItemCount'] = #Config.Drops[SubType]['Items']
					TriggerClientEvent('mercy-inventory/client/update-drops', -1, Config.Drops[SubType], SubType)
					Cb(true)
				elseif Config.Drops[SubType]['Items'][FromSlot].Amount == Amount then
					local NewAmount = Config.Drops[SubType]['Items'][ToSlot] == nil and Amount or (Config.Drops[SubType]['Items'][ToSlot].Amount + Amount)
					Config.Drops[SubType]['Items'][ToSlot] = {
						ItemName = Config.Drops[SubType]['Items'][FromSlot].ItemName,
						Slot = ToSlot,
						Amount = NewAmount,
						Info = Config.Drops[SubType]['Items'][FromSlot].Info,
					}
					Config.Drops[SubType]['ItemCount'] = #Config.Drops[SubType]['Items']
					Config.Drops[SubType]['Items'][FromSlot] = nil
					TriggerClientEvent('mercy-inventory/client/update-drops', -1, Config.Drops[SubType], SubType)
					Cb(true)
				elseif Config.Drops[SubType]['Items'][FromSlot].Amount > Amount then
					if Config.Drops[SubType]['Items'][ToSlot] == nil then
						Config.Drops[SubType]['Items'][ToSlot] = {
							ItemName = Config.Drops[SubType]['Items'][FromSlot].ItemName,
							Slot = ToSlot,
							Amount = Amount,
							Info = Config.Drops[SubType]['Items'][FromSlot].Info,
						}
						Config.Drops[SubType]['Items'][FromSlot].Amount = Config.Drops[SubType]['Items'][FromSlot].Amount - Amount
						Config.Drops[SubType]['ItemCount'] = #Config.Drops[SubType]['Items']
						TriggerClientEvent('mercy-inventory/client/update-drops', -1, Config.Drops[SubType], SubType)
						Cb(true)
					else
						Config.Drops[SubType]['Items'][ToSlot].Amount = Config.Drops[SubType]['Items'][ToSlot].Amount + Amount
						Config.Drops[SubType]['Items'][FromSlot].Amount = Config.Drops[SubType]['Items'][FromSlot].Amount - Amount
						Config.Drops[SubType]['ItemCount'] = #Config.Drops[SubType]['Items']
						TriggerClientEvent('mercy-inventory/client/update-drops', -1, Config.Drops[SubType], SubType)
						Cb(true)
					end
				end
			elseif Type == 'Trunk' or Type == 'Glovebox' or Type == 'Stash' or Type == 'Temp' then
				local DBItems = TypeItems[Type][SubType] ~= nil and TypeItems[Type][SubType] or TriggerClientEvent('mercy-inventory/client/force-close', Source)
				if ExtraData == 'Swap' then
					local DataFrom = DBItems[FromSlot]
					local DataTo = DBItems[ToSlot]
					DBItems[ToSlot] = { 
						ItemName = DataFrom.ItemName, 
						Slot = ToSlot, 
						Amount = DataFrom.Amount, 
						Info = DataFrom.Info, 
					}
					DBItems[FromSlot] = { 
						ItemName = DataTo.ItemName, 
						Slot = FromSlot, 
						Amount = DataTo.Amount, 
						Info = DataTo.Info, 
					}
					SaveInventoryData(Type, SubType, DBItems)
					Cb(true)
				elseif DBItems[FromSlot].Amount == Amount then
					if DBItems[ToSlot] == nil then
						DBItems[ToSlot] = { 
							ItemName = DBItems[FromSlot].ItemName, 
							Slot = ToSlot, 
							Amount = Amount, 
							Info = DBItems[FromSlot].Info, 
						}
						DBItems[FromSlot] = nil
						SaveInventoryData(Type, SubType, DBItems)
						Cb(true)
					else
						DBItems[ToSlot] = { 
							ItemName = DBItems[ToSlot].ItemName, 
							Slot = ToSlot, 
							Amount = DBItems[ToSlot].Amount + Amount, 
							Info = DBItems[ToSlot].Info, 
						}
						DBItems[FromSlot] = nil
						SaveInventoryData(Type, SubType, DBItems)
						Cb(true)
					end
				elseif DBItems[FromSlot].Amount > Amount then
					if DBItems[ToSlot] == nil then
						DBItems[ToSlot] = { 
							ItemName = DBItems[FromSlot].ItemName, 
							Slot = ToSlot, 
							Amount = Amount, 
							Info = DBItems[FromSlot].Info, 
						}
						DBItems[FromSlot].Amount = DBItems[FromSlot].Amount - Amount
						SaveInventoryData(Type, SubType, DBItems)
						Cb(true)
					else
						DBItems[ToSlot].Amount = DBItems[ToSlot].Amount + Amount
						DBItems[FromSlot].Amount = DBItems[FromSlot].Amount - Amount
						SaveInventoryData(Type, SubType, DBItems)
						Cb(true)
					end
				end
			elseif Type == 'Player' then
				local OtherItems = OtherPlayer.PlayerData.Inventory
				if ExtraData == 'Swap' then
					local DataFrom = OtherItems[FromSlot]
					local DataTo = OtherItems[ToSlot]
					local ItemDataFrom = GetItemData(OtherItems[FromSlot].ItemName:lower())
					local ItemDataTo = GetItemData(OtherItems[ToSlot].ItemName:lower())
					OtherItems[ToSlot] = {
						ItemName = DataFrom.ItemName,
						Slot = ToSlot,
						Amount = DataFrom.Amount,
						Info = DataFrom.Info,
						Label = ItemDataFrom["Label"], 
						Description = ItemDataFrom["Description"] ~= nil and ItemDataFrom["Description"] or "", 
						Weight = ItemDataFrom["Weight"], 
						Type = ItemDataFrom["Type"], 
						Unique = ItemDataFrom["Unique"], 
						Image = ItemDataFrom["Image"], 
						Combinable = ItemDataFrom["Combinable"],
					}
					OtherItems[FromSlot] = {
						ItemName = DataTo.ItemName,
						Slot = FromSlot,
						Amount = DataTo.Amount,
						Info = DataTo.Info,
						Label = ItemDataTo["Label"], 
						Description = ItemDataTo["Description"] ~= nil and ItemDataTo["Description"] or "", 
						Weight = ItemDataTo["Weight"], 
						Type = ItemDataTo["Type"], 
						Unique = ItemDataTo["Unique"], 
						Image = ItemDataTo["Image"],  
						Combinable = ItemDataTo["Combinable"],
					}
					OtherPlayer.Functions.SetItemData(OtherItems)
					if ItemDataFrom['Type'] == 'Weapon' then
						TriggerClientEvent('mercy-inventory/client/reset-weapon', OtherPlayer.PlayerData.Source)
					end
					TriggerClientEvent('mercy-inventory/client/update-player', OtherPlayer.PlayerData.Source)
					Cb(true)
				elseif OtherItems[FromSlot].Amount == Amount then
					if OtherItems[ToSlot] == nil then
						local ItemDataFrom = GetItemData(OtherItems[FromSlot].ItemName:lower())
						OtherItems[ToSlot] = {
							ItemName = OtherItems[FromSlot].ItemName,
							Slot = ToSlot,
							Amount = Amount,
							Info = OtherItems[FromSlot].Info,
							Label = ItemDataFrom["Label"], 
							Description = ItemDataFrom["Description"] ~= nil and ItemDataFrom["Description"] or "", 
							Weight = ItemDataFrom["Weight"], 
							Type = ItemDataFrom["Type"], 
							Unique = ItemDataFrom["Unique"], 
							Image = ItemDataFrom["Image"], 
							Combinable = ItemDataFrom["Combinable"],
						}
						OtherItems[FromSlot] = nil
						OtherPlayer.Functions.SetItemData(OtherItems)
						if ItemDataFrom['Type'] == 'Weapon' then
							TriggerClientEvent('mercy-inventory/client/reset-weapon', OtherPlayer.PlayerData.Source)
						end
						TriggerClientEvent('mercy-inventory/client/update-player', OtherPlayer.PlayerData.Source)
						Cb(true)
					else
						local ItemDataTo = GetItemData(OtherItems[ToSlot].ItemName:lower())
						OtherItems[ToSlot] = {
							ItemName = OtherItems[ToSlot].ItemName,
							Slot = ToSlot,
							Amount = OtherItems[ToSlot].Amount + Amount,
							Info = OtherItems[ToSlot].Info,
							Label = ItemDataTo["Label"], 
							Description = ItemDataTo["Description"] ~= nil and ItemDataTo["Description"] or "", 
							Weight = ItemDataTo["Weight"], 
							Type = ItemDataTo["Type"], 
							Unique = ItemDataTo["Unique"], 
							Image = ItemDataTo["Image"], 
							Combinable = ItemDataTo["Combinable"],
						}
						OtherItems[FromSlot] = nil
						OtherPlayer.Functions.SetItemData(OtherItems)
						TriggerClientEvent('mercy-inventory/client/update-player', OtherPlayer.PlayerData.Source)
						Cb(true)
					end
				elseif OtherItems[FromSlot].Amount > Amount then
					if OtherItems[ToSlot] == nil then
						local ItemDataFrom = GetItemData(OtherItems[FromSlot].ItemName:lower())
						OtherItems[ToSlot] = {
							ItemName = OtherItems[FromSlot].ItemName,
							Slot = ToSlot,
							Amount = Amount,
							Info = OtherItems[FromSlot].Info,
							Label = ItemDataFrom["Label"], 
							Description = ItemDataFrom["Description"] ~= nil and ItemDataFrom["Description"] or "", 
							Weight = ItemDataFrom["Weight"], 
							Type = ItemDataFrom["Type"], 
							Unique = ItemDataFrom["Unique"], 
							Image = ItemDataFrom["Image"], 
							Combinable = ItemDataFrom["Combinable"],
						}
						OtherItems[FromSlot].Amount = OtherItems[FromSlot].Amount - Amount
						OtherPlayer.Functions.SetItemData(OtherItems)
						if ItemDataFrom['Type'] == 'Weapon' then
							TriggerClientEvent('mercy-inventory/client/reset-weapon', OtherPlayer.PlayerData.Source)
						end
						TriggerClientEvent('mercy-inventory/client/update-player', OtherPlayer.PlayerData.Source)
						Cb(true)
					else
						OtherItems[ToSlot].Amount = OtherItems[ToSlot].Amount + Amount
						OtherItems[FromSlot].Amount = OtherItems[FromSlot].Amount - Amount
						OtherPlayer.Functions.SetItemData(OtherItems)
						TriggerClientEvent('mercy-inventory/client/update-player', OtherPlayer.PlayerData.Source)
						Cb(true)
					end
				end
			end
		end
	end)
end)

-- [ Events ] --

RegisterNetEvent('mercy-inventory/server/check-other', function(Type, Name)
	if Type == 'Glovebox' or Type == 'Trunk' then
		DatabaseModule.Execute("SELECT * FROM `player_inventory-vehicle` WHERE plate = ?", {
			Name
		}, function(Result)
			if Result ~= nil and Result[1] ~= nil then
				if TypeItems[Type][Name] ~= nil then
					TypeItems[Type][Name] = nil
				end
			end
		end)
		OpenInventories[string.sub(Type, 1, 1)..Name] = false
	elseif Type == 'Stash' then
		if TypeItems[Type][Name] ~= nil then TypeItems[Type][Name] = nil end
		OpenInventories[string.sub(Type, 1, 1)..Name] = false
	elseif Type == 'Crafting' or Type == 'Temp' or Type == 'Drop' then
		OpenInventories[string.sub(Type, 1, 1)..Name] = false
	elseif Type == 'Player' then
		OpenInventories['OT'..Name] = false
		TriggerClientEvent('mercy-inventory/client/set-inventory-state', tonumber(Name), false)
	end
end)

RegisterNetEvent('mercy-inventory/server/disable-other', function(PlayerId, State)
	local OtherPlayer = PlayerModule.GetPlayerBySource(tonumber(PlayerId))
	if OtherPlayer ~= nil then
		TriggerClientEvent('mercy-inventory/client/set-inventory-state', tonumber(PlayerId), State)
	end
end)

RegisterNetEvent('mercy-inventory/server/steal-money', function(TargetId)
	local SourcePlayer = PlayerModule.GetPlayerBySource(Source)
	local TargetPlayer = PlayerModule.GetPlayerBySource(TargetId)
	if TargetPlayer then
		local StealCash = TargetPlayer.PlayerData.Money['Cash']
		if StealCash > 0 then
			if SourcePlayer.PlayerData.Job.Name == 'police' and SourcePlayer.PlayerData.Job.Duty then
				SourcePlayer.Functions.AddItem('markedbills', 1, false, {Worth = StealCash}, true)
				TargetPlayer.Functions.RemoveMoney('Cash', StealCash)
				TriggerClientEvent('mercy-inventory/client/update-player', Source)
			else
				SourcePlayer.Functions.AddMoney('Cash', StealCash)
				TargetPlayer.Functions.RemoveMoney('Cash', StealCash)
				TargetPlayer.Functions.Notify("robbed-cash", "You got robbed of $"..StealCash.." cash!", 'error')
			end
		end
	end
end)

RegisterNetEvent('mercy-inventory/server/set-player-items', function(PlayerItems)
	local src = source
	local Player = PlayerModule.GetPlayerBySource(src)
	if not Player then return end

	for k, v in pairs(PlayerItems) do
		local CurrentQuality = GetQuality(v.ItemName, v.Info.CreateDate)
		if CurrentQuality ~= nil then
			PlayerItems[k].Info.Quality = CurrentQuality
		end
	end

	Player.Functions.SetItemData(PlayerItems)
end)

RegisterNetEvent('mercy-inventory/server/done-crafting', function(ItemName, Amount, ToSlot, Info, Cost)
	local src = source
	local Player = PlayerModule.GetPlayerBySource(src)
	if not Player then return end
	for k, v in pairs(Cost) do
		Player.Functions.RemoveItem(v['Item'], (v['Amount'] * Amount), false, true)
	end
	Player.Functions.AddItem(ItemName, Amount, false, Info, true)
	Player.Functions.Notify('craft-done', 'You crafted '..Amount..'x of '..ItemName..'!', 'success')
end)

RegisterNetEvent('mercy-inventory/server/done-combinding', function(FromSlot, FromItem, ToSlot, ToItem, Reward)
	local src = source
	local Player = PlayerModule.GetPlayerBySource(src)
	local FromItemCheck = Player.Functions.GetItemByName(FromItem)
	local ToItemCheck = Player.Functions.GetItemByName(ToItem)
	if FromItemCheck ~= nil and ToItemCheck ~= nil then
		if Player.Functions.RemoveItem(FromItem, 1, FromSlot, true) then
			if Player.Functions.RemoveItem(ToItem, 1, ToSlot, true) then
				local ItemData = Shared.ItemList[Reward:lower()]
				if ItemData['Type'] == 'Weapon' then
					if ItemData['Melee'] then
						Info = {Quality = 100, CreateDate = os.date()}
					else
						Info = {Quality = 100, CreateDate = os.date(), Ammo = 1, Serial = tostring(Shared.RandomInt(2) .. Shared.RandomStr(3) .. Shared.RandomInt(1) .. Shared.RandomStr(2) .. Shared.RandomInt(3) .. Shared.RandomStr(4))}
					end
				else
					Info = {}
				end
				Player.Functions.AddItem(Reward, 1, false, Info, true)
			end
		end
	end
end)

RegisterNetEvent('mercy-inventory/server/add-new-drop-core', function(Source, ItemName, Amount, Info, Date)
	if Config.Drops == nil then return end
	local PlayerCoords = GetEntityCoords(GetPlayerPed(Source))

	-- Check if drop is close to another drop
	for k, v in pairs(Config.Drops) do
		if Config.Drops[k] ~= nil and v['Coords'] ~= nil then
			local Distance = #(PlayerCoords - v['Coords'])
			if Distance <= 1.5 then 
				print('[DEBUG:Drops]: Adding item to existing drop.')
				Config.Drops[k]['ItemCount'] = Config.Drops[k]['ItemCount'] + 1
				Config.Drops[k]['Items'][#Config.Drops[k]['Items'] + 1] = {
					ItemName = ItemName,
					Slot = GetFreeSlotInDrop(DropSlots, k),
					Amount = Amount,
					Info = Info,
				}
				TriggerClientEvent('mercy-inventory/client/update-drops', -1, Config.Drops[k], k)
				goto continue
				return
			end
		end
	end

	-- Drop is not close to another drop
	local RandomId = math.random(1111111, 9999999)
	Config.Drops[RandomId] = {
		['SubType'] = RandomId,
		['Type'] = 'Drop',
		['InvName'] = 'Drop'..RandomId,
		['InvSlots'] = DropSlots,
		['Coords'] = vector3(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z),
		['Heading'] =  PlayerCoords.w,
		['MaxWeight'] = Config.MaxDropWeight,
		['ItemCount'] = 1,
		['Items'] = {
			[1] = {
				ItemName = ItemName,
				Slot = 1,
				Amount = Amount,
				Info = Info,
			},
		},
	}
	TriggerClientEvent('mercy-inventory/client/update-drops', -1, Config.Drops[RandomId], RandomId)

	::continue::
end)

-- [ Functions ] --

function GetFreeSlotInDrop(InvSlots, DropId)
	local Promise = promise:new()
	for i=1, InvSlots, 1 do
		if Config.Drops[DropId]['Items'][i] == nil then
			Promise:resolve(i)
			break
		elseif Config.Drops[DropId]['Items'][i] ~= nil and Config.Drops[DropId]['Items'][i].Slot ~= i then
			Promise:resolve(i)
			break
		end
	end
	return Citizen.Await(Promise)
end

function GetDBItems(Type, Name)
    local ReturnItems = {}
    local Promise = promise:new()
    if Type == 'Glovebox' or Type == 'Trunk' or Type == 'Stash' then
        local Table = (Type == 'Stash' and 'stash' or 'vehicle')
        local ExtraQuery = ((Type == 'Glovebox' or Type == 'Trunk') and ' WHERE plate = ?' or ' WHERE stash = ?')
        DatabaseModule.Execute("SELECT * FROM `player_inventory-"..Table.."`"..ExtraQuery, {
            Name
        }, function(Result)
            if Result ~= nil and Result[1] ~= nil then
                local DBItems = json.decode(Type == 'Glovebox' and Result[1].gloveboxitems or Type == 'Trunk' and Result[1].trunkitems or Result[1].items)
                if DBItems ~= nil and DBItems[1] ~= nil then
                    for k,v in pairs(DBItems) do
                        if DBItems[k] ~= nil then
                            if v ~= nil and v.ItemName ~= nil and Shared.ItemList[v.ItemName:lower()] ~= nil then
                                local ItemInfo = Shared.ItemList[v.ItemName:lower()]
                                ReturnItems[v.Slot] = {
                                    ItemName = ItemInfo["ItemName"],
                                    Amount = tonumber(v.Amount),
                                    Info = v.Info ~= nil and v.Info or "",
                                    Slot = v.Slot,
                                }
                            end
                        end
                    end
                    Promise:resolve(ReturnItems)
                else
                    ReturnItems = {}
                    Promise:resolve(ReturnItems)
                end
            else
                ReturnItems = {}
                Promise:resolve(ReturnItems)
            end
        end)
    end
    return Citizen.Await(Promise)
end
exports('GetDBItems', GetDBItems)

function SaveInventoryData(Type, Name, Items)
	local ItemsJson = {}
	for k, v in pairs(Items) do
		if Items[k] ~= nil then
			local NewData = {}
			NewData.ItemName = v.ItemName
			NewData.Slot = v.Slot
			NewData.Amount = v.Amount
			NewData.Info = v.Info
			ItemsJson[#ItemsJson+1] = NewData
		end
	end
	if Type == 'Trunk' or Type == 'Glovebox' then
		DatabaseModule.Execute("SELECT * FROM `player_vehicles` WHERE plate = ?", {
			Name
		}, function(VehResult)
			if VehResult ~= nil and VehResult[1] ~= nil then
				local SetItems = (Type == "Trunk" and "trunkitems" or "gloveboxitems")
				DatabaseModule.Execute("SELECT * FROM `player_inventory-vehicle` WHERE plate = ?", {
					Name
				}, function(Result)
					if Result ~= nil and Result[1] ~= nil then
						DatabaseModule.Update("UPDATE `player_inventory-vehicle` SET "..SetItems.." = ? WHERE plate = ?", {
							json.encode(ItemsJson),
							Name
						})
					else
						DatabaseModule.Insert("INSERT INTO `player_inventory-vehicle` (plate, "..SetItems..") VALUES (?, ?)", {
							Name,
							json.encode(ItemsJson)
						})
					end
				end)
			end
		end)
	elseif Type == 'Stash' then
		DatabaseModule.Execute("SELECT * FROM `player_inventory-stash` WHERE stash = ?", {
			Name
		}, function(StashResult)
			if StashResult ~= nil and StashResult[1] ~= nil then
				DatabaseModule.Update("UPDATE `player_inventory-stash` SET items = ? WHERE stash = ?", {
					json.encode(ItemsJson),
					Name
				})
			else
				DatabaseModule.Insert("INSERT INTO `player_inventory-stash` (stash, items) VALUES (?, ?)", {
					Name,
					json.encode(ItemsJson)
				})
			end
		end)
	end
end
exports('SaveInventoryData', SaveInventoryData)

function HasCraftingItems(Source, CostItems, Amount)
	local Player = PlayerModule.GetPlayerBySource(Source)
	if not Player then return false end
	for k, CraftData in pairs(CostItems) do
		local ItemData = Player.Functions.GetItemByName(CraftData['Item'])
		if ItemData ~= nil then
			if ItemData.Amount < (CraftData['Amount'] * Amount) then
				return false
			end
		else
			return false
		end
	end
	return true
end

function CheckDropInventory(DropId)
	local NoNilCount = 0
	for i = 1, DropSlots do
		if Config.Drops[DropId]['Items'][i] ~= nil then
			NoNilCount = NoNilCount + 1
		end
	end
	if NoNilCount == 0 then
		Config.Drops[DropId] = {}
		OpenInventories['D'..DropId] = false
	end
end

function GetTotalWeight(Items)
	local ReturnWeight = 0
	if Items ~= nil and type(Items) == 'table' then
		for k, v in pairs(Items) do
			if Items[k] ~= nil then
				local ItemData = Shared.ItemList[v.ItemName]
				if ItemData ~= nil then
					ReturnWeight = ReturnWeight + (ItemData['Weight'] * v.Amount)
				end
			end
		end
	end
	return ReturnWeight
end

function WeightCheck(MaxWeight, CurrentWeight, Amount, Weight)
	local MaxWeight = MaxWeight
	local TotalAdd = (Weight * Amount)
	if CurrentWeight + TotalAdd <= MaxWeight then
		return true
	else
		return false
	end
end

function GetInventoryItems(Name)
	return TypeItems['Temp'][Name]
end

function SetInventoryItems(Name, Items)
	TypeItems['Temp'][Name] = Items
end

function GetItemData(ItemName)
	if Shared.ItemList == nil then return false end
	return Shared.ItemList[ItemName] or false
end