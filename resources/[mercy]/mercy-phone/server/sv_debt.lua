-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(4)
    end

    CallbackModule.CreateCallback('mercy-phone/server/debts/get', function(Source, Cb)
        local Player = PlayerModule.GetPlayerBySource(Source)
        DatabaseModule.Execute('SELECT * FROM player_phone_debts WHERE citizenid = ?', {Player.PlayerData.CitizenId}, function(Debts)
            Cb(Debts)
        end)
    end)

    CallbackModule.CreateCallback('mercy-phone/server/debts/pay', function(Source, Cb, Data)
        local Player = PlayerModule.GetPlayerBySource(Source)
        DatabaseModule.Execute('SELECT * FROM player_phone_debts WHERE citizenid = ? AND id = ?', {
            Player.PlayerData.CitizenId, 
            Data.DebtData.id
        }, function(Debts)
            if Debts[1] ~= nil then
                if Player.Functions.RemoveMoney('Cash', Debts[1].amount, 'Paid Debt') then
                    DatabaseModule.Execute('DELETE FROM player_phone_debts WHERE id = ?', {Data.DebtData.id})
                    TriggerClientEvent('mercy-phone/client/notification', Source, {
                        Id = Source,
                        Title = "Debt",
                        Message = "You have paid your debt of $"..Debts[1].amount..".00",
                        Icon = "fas fa-money-bill-wave",
                        IconBgColor = "#1e90ff",
                        IconColor = "white",
                        Sticky = false,
                        Duration = 5000,
                        Buttons = {},
                    })
                    Cb({Success = true})
                else
                    Cb({Success = false, Message = "You do not have enough cash to pay your debt of $"..Debts[1].amount.."."})
                end
            else
                Cb({Success = false, Message = "Debt not found."})
            end
        end)
    end)

    CallbackModule.CreateCallback('mercy-phone/server/get-overdue-debts', function(Source, Cb, Category)
        local Player = PlayerModule.GetPlayerBySource(Source)
        DatabaseModule.Execute('SELECT * FROM player_phone_debts WHERE citizenid = ? AND category = ?', {
            Player.PlayerData.CitizenId, 
            Category
        }, function(Debts)
            if Debts[1] ~= nil then
                local OverdueDebts = {}
                for DebtId, DebtData in pairs(Debts) do
                    if DebtData.expire < os.time() then
                        table.insert(OverdueDebts, DebtData)
                    end
                end
                Cb(OverdueDebts)
            else
                Cb({})
            end
        end)
    end)

    EventsModule.RegisterServer('mercy-phone/server/debts/add', function(Source, StateId, Title, Amount, ExpireInDays)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local TPlayer = PlayerModule.GetPlayerByStateId(tonumber(StateId))
        local ExpireDate = os.time() + (tonumber(ExpireInDays) * 86400)
        DatabaseModule.Insert('INSERT INTO player_phone_debts (citizenid, category, title, amount, expire) VALUES (?, ?, ?, ?, ?)', {
            TPlayer.PlayerData.CitizenId,
            'Fine',
            Title,
            Amount,
            ExpireDate
        }, function(Debts)
            Player.Functions.Notify("given-fine", "You have given a fine of $"..Amount..".00 to the person.", "success", 5000)
            TPlayer.Functions.Notify("received-fine", "You have received a fine.", "error", 5000)
        end)
    end)
end)

-- [ Functions ] --

function AddDebt(Target, Title, Amount, ExpireInDays)
    local Player = PlayerModule.GetPlayerBySource(Target)
    local ExpireDate = os.time() + (tonumber(ExpireInDays) * 86400)
    DatabaseModule.Insert('INSERT INTO player_phone_debts (citizenid, category, title, amount, expire) VALUES (?, ?, ?, ?, ?)', {
        Player.PlayerData.CitizenId,
        'Fine',
        Title,
        Amount,
        ExpireDate
    }, function(Debts)
        Cb(Debts)
    end)
end
exports('AddDebt', AddDebt)