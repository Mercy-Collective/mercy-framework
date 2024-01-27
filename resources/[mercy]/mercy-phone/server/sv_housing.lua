-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(4)
    end

    CallbackModule.CreateCallback('mercy-phone/server/housing/get-owned-houses', function(Source, Cb)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if not Player then return Cb({}) end
        local HouseData = {}
        DatabaseModule.Execute('SELECT * FROM player_houses WHERE citizenid = ?', {
            Player.PlayerData.CitizenId,
        }, function(Houses)
            if Houses[1] ~= nil then
                for k, v in pairs(Houses) do
                    HouseData[v.house] = {
                        Owner = v.citizenid,
                        Name = v.house,
                        Locked = exports['mercy-housing']:IsHouseLocked(v.house),
                        Category = v.category,
                        Adres = v.label,
                        Coords = json.decode(v.coords),
                    }
                end
                Cb(HouseData)
            else
                Cb({})
            end
        end)
    end)

    CallbackModule.CreateCallback('mercy-phone/server/housing/purchase-house', function(Source, Cb, Data)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if not Player then return Cb(false) end
        if not Data.House.ForSale then return Cb(false) end
        -- Check if player has enough money
        if Player.Functions.RemoveMoney('Bank', Data.House.Price, "Purchased house") then
            -- Add house to database
            local Keyholders = {}
            table.insert(Keyholders, {
                StateId = Player.PlayerData.CitizenId,
                CharName = Player.PlayerData.CharInfo.Firstname..' '..Player.PlayerData.CharInfo.Lastname,
            })
            DatabaseModule.Update('UPDATE player_houses SET citizenid = ?, owned = ?, keyholders = ? WHERE house = ?', {
                Player.PlayerData.CitizenId,
                true,
                json.encode(Keyholders),
                Data.House.Id,
            }, function()
                exports['mercy-housing']:RefreshHousing()
                Cb(true)
            end)
        else
            Cb(false)
        end
    end)

    CallbackModule.CreateCallback('mercy-phone/server/housing/toggle-locks', function(Source, Cb, Data)
        local DoorState = exports['mercy-housing']:ToggleDoorLocks(Data.HouseId)
        Cb(DoorState)
    end)

    CallbackModule.CreateCallback('mercy-phone/server/housing/sell-house', function(Source, Cb, Data)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if not Player then return Cb({Success = false, FailMessage = "Something went wrong.."}) end
        DatabaseModule.Execute('SELECT * FROM player_houses WHERE house = ?', {
            Data['HouseId'],
        }, function(Houses)
            if Houses ~= nil then
                for k, v in pairs(Houses) do
                    if Player.PlayerData.CitizenId == v.citizenid then      
                        DatabaseModule.Update('UPDATE player_houses SET citizenid = ?, owned = ?, keyholders = ? WHERE house = ?', {
                            nil,
                            false,
                            json.encode({}),
                            Data['HouseId'],
                        }, function()
                            local GivePrice = (v.price - math.ceil(v.price * 0.3))
                            Player.Functions.AddMoney('Bank', GivePrice, "Sold-house") -- 30% money removal
                            TriggerClientEvent('mercy-phone/client/notification', Source, {
                                Id = math.random(100000, 999999),
                                Title = 'Housing',
                                Message = 'You have sold your house for $'..GivePrice,
                                Icon = "fas fa-house",
                                IconBgColor = "#007d11",
                                IconColor = "white",
                                Sticky = false,
                                Duration = 4000,
                                Buttons = {},
                            })
                            exports['mercy-housing']:RefreshHousing()
                            Cb({Success = true})
                        end)
                    else
                        Cb({Success = false, FailMessage = "You don't own this house.."})
                    end
                end
            else
                Cb({Success = false, FailMessage = "House not found.."})
            end
        end)
    end)

    CallbackModule.CreateCallback('mercy-phone/server/housing/get-keyholders', function(Source, Cb, Data)
        DatabaseModule.Execute('SELECT * FROM player_houses WHERE house = ?', {
            Data['HouseId'],
        }, function(House)
            if House[1] == nil then return Cb({}) end
            Cb(json.decode(House[1].keyholders) or {})
        end)
    end)

    CallbackModule.CreateCallback('mercy-phone/server/housing/add-key', function(Source, Cb, Data)
        DatabaseModule.Execute('SELECT * FROM player_houses WHERE house = ?', {
            Data['HouseId'],
        }, function(Houses)
            if Houses[1] ~= nil then
                local Keyholders = json.decode(Houses[1]['keyholders'])
                for _, KeyHolderData in pairs(Keyholders) do
                    if KeyHolderData['StateId'] == Data['StateId'] then
                        return Cb({Result = false, FailMessage = "This person already has a key.."})
                    end
                end

                local TPlayer = PlayerModule.GetPlayerByStateId(Data['StateId'])
                if not TPlayer then return Cb({Result = false, FailMessage = "Player not found.."}) end

                table.insert(Keyholders, {
                    StateId = Data['StateId'],
                    CharName = TPlayer.PlayerData.CharInfo.Firstname..' '..TPlayer.PlayerData.CharInfo.Lastname,
                })

                DatabaseModule.Update('UPDATE player_houses SET keyholders = ? WHERE house = ?', {
                    json.encode(Keyholders),
                    Data['HouseId'],
                }, function()
                    TriggerClientEvent('mercy-phone/client/notification', Source, {
                        Id = math.random(100000, 999999),
                        Title = 'Housing',
                        Message = 'You have given a key to '..TPlayer.PlayerData.CharInfo.Firstname..' '..TPlayer.PlayerData.CharInfo.Lastname,
                        Icon = "fas fa-house",
                        IconBgColor = "#007d11",
                        IconColor = "white",
                        Sticky = false,
                        Duration = 4000,
                        Buttons = {},
                    })
                    TriggerClientEvent('mercy-phone/client/notification', TPlayer.PlayerData.Source, {
                        Id = math.random(100000, 999999),
                        Title = 'Housing',
                        Message = 'You have been given a key to property: '..Houses[1]['label'],
                        Icon = "fas fa-house",
                        IconBgColor = "#007d11",
                        IconColor = "white",
                        Sticky = false,
                        Duration = 4000,
                        Buttons = {},
                    })
                    exports['mercy-housing']:RefreshHousing()
                    Cb({Result = true})
                end)
            else
                Cb({Result = false, FailMessage = "House not found.."})
            end
        end)
    end)

    CallbackModule.CreateCallback('mercy-phone/server/housing/remove-key', function(Source, Cb, Data)
        DatabaseModule.Execute('SELECT * FROM player_houses WHERE house = ?', {
            Data['HouseId'],
        }, function(Houses)
            if Houses[1] ~= nil then
                local Keyholders = json.decode(Houses[1]['keyholders'])
                if Data['Keyholder'] == Houses[1].citizenid then
                    return Cb({Result = false, FailMessage = "You can't remove the owner of the house.."})
                end
                local TPlayer = PlayerModule.GetPlayerByStateId(Data['Keyholder'])
                if not TPlayer then return Cb({Result = false, FailMessage = "Player not found.."}) end

                table.remove(Keyholders, KeyHolderId)
                DatabaseModule.Update('UPDATE player_houses SET keyholders = ? WHERE house = ?', {
                    json.encode(Keyholders),
                    Data['HouseId'],
                }, function()
                    TriggerClientEvent('mercy-phone/client/notification', Source, {
                        Id = math.random(100000, 999999),
                        Title = 'Housing',
                        Message = 'Successfully removed keyholder from house.',
                        Icon = "fas fa-house",
                        IconBgColor = "#007d11",
                        IconColor = "white",
                        Sticky = false,
                        Duration = 4000,
                        Buttons = {},
                    })
                    TriggerClientEvent('mercy-phone/client/notification', TPlayer.PlayerData.Source, {
                        Id = math.random(100000, 999999),
                        Title = 'Housing',
                        Message = 'Your key got taken away of property: '..Houses[1]['label'],
                        Icon = "fas fa-house",
                        IconBgColor = "#007d11",
                        IconColor = "white",
                        Sticky = false,
                        Duration = 4000,
                        Buttons = {},
                    })
                    exports['mercy-housing']:RefreshHousing()
                    Cb({Result = true})
                end)       
            else
                Cb({Result = false, FailMessage = "House not found.."})
            end
        end)
    end)

    CallbackModule.CreateCallback('mercy-phone/server/housing/give-house', function(Source, Cb, Data)
        local TPlayer = PlayerModule.GetPlayerByStateId(Data['StateId'])
        DatabaseModule.Execute('SELECT * FROM player_houses WHERE house = ?', { Data['HouseId'] }, function(Houses)
            if Houses[1] ~= nil then
                DatabaseModule.Update("UPDATE player_houses SET citizenid = ? Where house = ?", {Data['StateId'], Data['HouseId']})
                TriggerClientEvent('mercy-phone/client/notification', TPlayer.PlayerData.Source, {
                    Id = math.random(100000, 999999),
                    Title = 'Housing',
                    Message = 'You have a new home: '..Data['HouseId'],
                    Icon = "fas fa-house",
                    IconBgColor = "#007d11",
                    IconColor = "white",
                    Sticky = false,
                    Duration = 4000,
                    Buttons = {},
                })
                exports['mercy-housing']:RefreshHousing()
                Cb({Result = true})
            else
                Cb({Result = false, FailMessage = "House not found.."})
            end
        end)
    end)
end)
