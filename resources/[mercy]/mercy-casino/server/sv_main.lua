CallbackModule, PlayerModule, DatabaseModule, EventsModule = nil, nil, nil, nil
local ActiveSlotSeats = {}

_Ready = false
AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Callback',
        'Player',
        'Database',
        'Events',
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        DatabaseModule = exports['mercy-base']:FetchModule('Database')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        _Ready = true
    end)
end)

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(500)
    end

    -- math.randomseed(os.clock()*100000000000)
    -- math.randomseed(os.clock()*math.random())
    -- math.randomseed(os.clock()*math.random())

    -- Rooms

    CallbackModule.CreateCallback("mercy-casino/server/check-room-ownership", function(Source, Cb)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if not Player then 
            Cb({ HasRoom = false })
            return Player.Functions.Notify('player-not-found', 'Player not found', 'error') 
        end

        DatabaseModule.Execute("SELECT * FROM hotel_rooms WHERE RoomInfo LIKE ?", { "%"..Player.PlayerData.CitizenId.."%" }, function(Result)
            if Result[1] ~= nil then
                Cb({ HasRoom = true, RoomInfo = json.decode(Result[1].RoomInfo) })
            else
                Cb({ HasRoom = false })
            end
        end)
    end)

    -- Wheel

    EventsModule.RegisterServer("mc-wheel/server/give-reward", function(Source, Slot)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if not Player then return end
        local SlotData = GetSlotData(Slot)
        if SlotData['Type'] == 'Money' then
            if tonumber(SlotData['Amount']) > 0 then
                Player.Functions.AddMoney("Casino", tonumber(SlotData['Amount']), "slots-payout")
                Player.Functions.Notify("wheel-won", 'Congrats, you received $'..SlotData['Amount']..' in chips!', "success")
            end
        elseif SlotData['Type'] == 'Vehicle' then
            Player.Functions.Notify("wheel-won-car", 'Congrats, you won the car!', "success")
            GiveCarToPlayer(Source, SlotData['Model'])
        end
    end)

    CallbackModule.CreateCallback("mercy-casino/server/get-current-wheel-veh", function(Source, Cb)
        Cb(ServerConfig.WheelVehicle)
    end)

    -- Slots

    CallbackModule.CreateCallback("mercy-casino/server/slots/check-bet", function(Source, Cb, Amount)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local ChipsAmount = Player.PlayerData.Money['Casino']
        if ChipsAmount >= Amount then
            Cb(true)
        else
            Cb(false)
        end
    end)
    
    CallbackModule.CreateCallback("mercy-casino/server/slots/check-seat", function(Source, Cb, SeatId)
        if ActiveSlotSeats[SeatId] ~= nil then
            if ActiveSlotSeats[SeatId].Used then
                Cb(false)
            else
                ActiveSlotSeats[SeatId].Used = true
                Cb(true)
            end
        else
            ActiveSlotSeats[SeatId] = {}
            ActiveSlotSeats[SeatId].Used = true
            Cb(true)
        end
    end)

    RegisterNetEvent("mercy-casino/server/slots/clear-seat", function(SeatId)
        if ActiveSlotSeats[SeatId] ~= nil then
            ActiveSlotSeats[SeatId].Used = false
        end
    end)

    RegisterNetEvent("mercy-casino/server/slots/start", function(SeatId, Data)
        local src = source
        local Player = PlayerModule.GetPlayerBySource(src)
        if not Player then return end
        if ActiveSlotSeats[SeatId] then
            if Player.Functions.RemoveMoney("Casino", Data.bet, "slots-bet") then
                local TickRate = {a = math.random(1, 16), b = math.random(1, 16), c = math.random(1, 16)}
                -- local RandomChance1 = math.random(1, 100)
                -- local RandomChance2 = math.random(1, 100)
                -- local RandomChance3 = math.random(1, 100)
                -- if Config.Offset then
                --     if RandomChance1 < Config.OffsetNum then TickRate.a = TickRate.a + 0.5 end
                --     if RandomChance2 < Config.OffsetNum then TickRate.b = TickRate.b + 0.5 end
                --     if RandomChance3 < Config.OffsetNum then TickRate.c = TickRate.c + 0.5 end
                -- end
                TriggerClientEvent('mercy-casino/client/slots/start', src, SeatId, TickRate)
                ActiveSlotSeats[SeatId].Win = TickRate
            else
                Player.Functions.Notify("slots-not-enough", "Not enough chips..", "error") 
            end
        end
    end)

    
    RegisterNetEvent('mercy-casino/server/slots/check-for-win',function(Index, Data, BeginData)
        local src = source
        if ActiveSlotSeats[Index] then
            if ActiveSlotSeats[Index].Win then
                if ActiveSlotSeats[Index].Win.a == Data.a and ActiveSlotSeats[Index].Win.b == Data.b and ActiveSlotSeats[Index].Win.c == Data.c then
                    CheckForSlotsWin(src, ActiveSlotSeats[Index].Win, BeginData)
                end
            end
        end
    end)

    function CheckForSlotsWin(Source, Win, BeginData)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local a = Config.Options['Slots']['Wins'][Win.a]
        local b = Config.Options['Slots']['Wins'][Win.b]
        local c = Config.Options['Slots']['Wins'][Win.c]
        local TotalWinnings = 0
        if a == b and b == c and a == c then
            if Config.Options['Slots']['Multiplier'][a] then
                TotalWinnings = BeginData.bet * Config.Options['Slots']['Multiplier'][a]
            end		
        elseif a == '6' and b == '6' then
            TotalWinnings = BeginData.bet * 5
        elseif a == '6' and c == '6' then
            TotalWinnings = BeginData.bet * 5
        elseif b == '6' and c == '6' then
            TotalWinnings = BeginData.bet * 5
        elseif a == '6' then
            TotalWinnings = BeginData.bet * 2
        elseif b == '6' then
            TotalWinnings = BeginData.bet * 2
        elseif c == '6' then
            TotalWinnings = BeginData.bet * 2
        end
        if TotalWinnings > 0 then
            Player.Functions.Notify("won-slots-chips", "You won $"..TotalWinnings.." in chips!", "success")
            Player.Functions.AddMoney('Casino', TotalWinnings, "slots-payout")
        end
    end

    -- Main Casino

    CallbackModule.CreateCallback("mc-wheel/server/check-cash", function(Source, Cb, Type)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if not Player then return end

        if Player.Functions.RemoveMoney("Casino", tonumber(Config.Options['Wheel']['Types'][Type]['Amount']), Type.."-spin") then
            Cb(true)
        else
            Player.Functions.Notify("wheel-not-enough", "Not enough chips..", "error") 
            Cb(false)
        end
    end)
    
    CallbackModule.CreateCallback("mercy-base/server/get-membership", function(Source, Cb)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local MemberCard = Player.Functions.GetItemByName("casinomember")
        if MemberCard ~= nil then
            Cb(MemberCard)
        else
            Cb(false)
        end  
    end)

    EventsModule.RegisterServer('mercy-casino/server/buy-chips', function(Source, Amount, Dirty)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if not Player then return end

        if Player.Functions.RemoveMoney("Cash", Amount, "buy-casino-chips") then
            Player.Functions.AddMoney("Casino", Amount, "buy-casino-chips")
            if Dirty then
                Player.Functions.Notify("buy-casino-chips", "You bought $"..Amount.." in chips with the stuff you had..", "success")
            else
                Player.Functions.Notify("buy-casino-chips", "You bought $"..Amount.." in chips.", "success")
            end
        else
            Player.Functions.Notify("buy-casino-chips", "Not enough cash..", "error")
        end
    end)

    CallbackModule.CreateCallback('mercy-casino/server/withdraw-money', function(Source, Cb, Type)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local CasinoChips = Player.PlayerData.Money['Casino']
        if CasinoChips == 0 then Player.Functions.Notify("withdraw-cash", "Not enough chips..", "error") Cb(false) return end
        if Type == 'Cash' then
            if Player.Functions.RemoveMoney("Casino", CasinoChips, "withdraw-casino-chips") then
                Player.Functions.AddMoney("Cash", CasinoChips, "withdraw-cash")
                Player.Functions.Notify("withdraw-cash", "You withdrew $"..CasinoChips.." from the casino.", "success")
                Cb(true)
            else
                Player.Functions.Notify("withdraw-cash", "Not enough chips..", "error")
                Cb(false)
            end
        elseif Type == 'Bank' then
            if Player.Functions.RemoveMoney("Casino", CasinoChips, "withdraw-casino-chips") then
                Player.Functions.AddMoney("Bank", CasinoChips, "withdraw-bank")
                Player.Functions.Notify("withdraw-bank", "You withdrew $"..CasinoChips.." from the casino.", "success")
                Cb(true)
            else
                Player.Functions.Notify("withdraw-bank", "Not enough chips..", "error")
                Cb(false)
            end
        else
            Cb(false)
        end
    end)

    EventsModule.RegisterServer('mercy-casino/server/transfer-chips', function(Source, StateId, Amount)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local TPlayer = PlayerModule.GetPlayerByStateId(StateId)
        if not TPlayer then return end
        if Player.Functions.RemoveMoney("Casino", tonumber(Amount), "transfer-chips") then
            TPlayer.Functions.AddMoney("Casino", tonumber(Amount), "transfer-chips")
            Player.Functions.Notify("transfer-chips", "You transferred $"..Amount.." in chips to "..TPlayer.PlayerData.Name, "success")
            TPlayer.Functions.Notify("transfer-chips", Player.PlayerData.Name.." transferred $"..Amount.." in chips to you.", "success")
        else
            Player.Functions.Notify("transfer-chips", "Not enough chips..", "error")
        end
    end)
end)

function GetSlotData(Slot)
    for k, v in pairs(Config.Options['Wheel']['Slots']) do
        if v['Id'] == Slot then
            return v
        end
    end
end

-- [ Events ] --

RegisterNetEvent('mercy-casino/server/rooms/rent-start', function(Password)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    if not Player then return Player.Functions.Notify('player-not-found', 'Player not found', 'error') end

    local AvailableRooms = {}
    DatabaseModule.Execute("SELECT * FROM hotel_rooms WHERE Available = ?", {1}, function(Result)
        if Result[1] ~= nil then
            if Player.Functions.RemoveMoney('Cash', Config.Casino['Rent'], 'hotel-rent') then
                for k, v in pairs(Result) do
                    table.insert(AvailableRooms, v.RoomId)
                end
                local RandomRoom = AvailableRooms[math.random(#AvailableRooms)] -- randomly select a room from the list
                local RoomInfo = {
                    Owner = Player.PlayerData.CitizenId,
                    RoomId = RandomRoom,
                    StoragePass = Password,
                }
                DatabaseModule.Update("UPDATE hotel_rooms SET Available = ?, RoomInfo = ? WHERE RoomId = ?", {
                    0,
                    json.encode(RoomInfo),
                    RandomRoom
                }) 
                TriggerClientEvent('mercy-phone/client/notification', src, {
                    Id = math.random(11111111, 99999999),
                    Title = "Diamond Casino",
                    Message = "Thanks for checking in, your room number is "..RandomRoom..". ",
                    Icon = "fas fa-gem",
                    IconBgColor = "black",
                    IconColor = "white",
                    Sticky = false,
                    Duration = 7500,
                    Buttons = {},
                })
            else
                Player.Functions.Notify('not-enough-cash', 'Not enough cash..', 'error')
            end
        else
            Player.Functions.Notify('no-rooms', 'No rooms available..', 'error')
        end
    end)
end)

RegisterNetEvent("mercy-casino/server/rooms/rent-stop", function()
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    if not Player then return Player.Functions.Notify('player-not-found', 'Player not found', 'error') end

    DatabaseModule.Execute("SELECT * FROM hotel_rooms WHERE RoomInfo LIKE ?", { "%"..Player.PlayerData.CitizenId.."%" }, function(Result)
        if Result[1] ~= nil then
            local RoomInfo = json.decode(Result[1].RoomInfo)
            if RoomInfo.Owner == Player.PlayerData.CitizenId then
                DatabaseModule.Update("UPDATE hotel_rooms SET Available = ?, RoomInfo = ? WHERE RoomId = ?", {
                    1,
                    'Room-'..RoomInfo.RoomId,
                    RoomInfo.RoomId
                })
                TriggerClientEvent('mercy-phone/client/notification', src, {
                    Id = math.random(11111111, 99999999),
                    Title = "Diamond Casino",
                    Message = "You've succesfully checked out of room "..RoomInfo.RoomId..". ",
                    Icon = "fas fa-gem",
                    IconBgColor = "black",
                    IconColor = "white",
                    Sticky = false,
                    Duration = 7500,
                    Buttons = {},
                })
            else
                Player.Functions.Notify('not-renting-room', 'You are not renting a room..', 'error')
            end
        else
            Player.Functions.Notify('not-renting-room', 'You are not renting a room..', 'error')
        end
    end)
end)

RegisterNetEvent('mercy-casino/server/fetch-storage', function(PolyInfo, Password)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    if not Player then return Player.Functions.Notify('player-not-found', 'Player not found', 'error') end
    DatabaseModule.Execute("SELECT * FROM hotel_rooms WHERE RoomId = ?", { PolyInfo }, function(Result)
        if Result[1] ~= nil and Result[1].RoomInfo ~= nil then
            local RoomInfo = json.decode(Result[1].RoomInfo)
            if RoomInfo.StoragePass == Password then
                TriggerClientEvent('mercy-casino/client/hotel/open-storage', src, PolyInfo)
            else
                Player.Functions.Notify('wrong-password', 'Wrong password..', 'error')
            end
        else
            Player.Functions.Notify('room-not-found', 'Wrong password..', 'error')
        end
    end)
end)

RegisterNetEvent('mercy-casino/server/rooms/change-password', function(Password)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    if not Player then return Player.Functions.Notify('player-not-found', 'Player not found', 'error') end

    DatabaseModule.Execute("SELECT * FROM hotel_rooms WHERE RoomInfo LIKE ?", { "%"..Player.PlayerData.CitizenId.."%" }, function(Result)
        if Result[1] ~= nil then
            local RoomInfo = json.decode(Result[1].RoomInfo)
            
            local newRoomInfo = {
                Owner = RoomInfo.Owner,
                RoomId = RoomInfo.RoomId,
                StoragePass = Password
            }
            DatabaseModule.Update("UPDATE hotel_rooms SET RoomInfo = ? WHERE RoomId = ?", {
                json.encode(newRoomInfo), RoomInfo.RoomId
            })
            
            TriggerClientEvent('mercy-phone/client/notification', src, {
                Id = math.random(11111111, 99999999),
                Title = "Diamond Casino",
                Message = "Your storage password has been successfully updated",
                Icon = "fas fa-gem",
                IconBgColor = "black",
                IconColor = "white",
                Sticky = false,
                Duration = 7500,
                Buttons = {},
            })
        else
            Player.Functions.Notify('not-renting-room', 'You are not renting a room..', 'error')
        end
    end)
end)

RegisterNetEvent("mc-wheel/server/sync-wheel", function(Bool)
    TriggerClientEvent("mc-wheel/client/sync-wheel", -1, Bool)
end)

RegisterNetEvent("mc-wheel/server/set-wheel-status", function(Bool)
    TriggerClientEvent("mc-wheel/client/sync-wheel-status", -1, Bool)
end)

RegisterNetEvent("mc-wheel/server/sync-spin", function(Speed, Slot, Type)
    TriggerClientEvent("mc-wheel/client/sync-spin", -1, Speed, Slot, Type)
end)

-- [ Functions ] --

function GiveCarToPlayer(Source)
    -- ADD CAR GIVE THING HERE
end
