-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(450)
    end

    EventsModule.RegisterServer("mercy-jobs/server/hunting/sell", function(Source)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local CurrentTime = exports['mercy-weathersync']:GetCurrentTime()
        for k, v in pairs(Player.PlayerData.Inventory) do
            if v.ItemName == 'hunting-carcass-one' then
                Player.Functions.RemoveItem('hunting-carcass-one', v.Amount, v.Slot, true)
                Player.Functions.AddMoney('Cash', math.random(225, 275))
            elseif v.ItemName == 'hunting-carcass-two' then
                Player.Functions.RemoveItem('hunting-carcass-two', v.Amount, v.Slot, true)
                Player.Functions.AddMoney('Cash', math.random(425, 475))
            elseif v.ItemName == 'hunting-carcass-three' then
                Player.Functions.RemoveItem('hunting-carcass-three', v.Amount, v.Slot, true)
                Player.Functions.AddMoney('Cash', math.random(650, 1000))
            elseif v.ItemName == 'hunting-carcass-four' and (CurrentTime >= 20 and CurrentTime <= 24 or CurrentTime >= 0 and CurrentTime <= 5) then
                Player.Functions.RemoveItem('hunting-carcass-four', v.Amount, v.Slot, true)
                Player.Functions.AddItem('cash-rolls', math.random(25, 30), false, false, true)
            end
        end
    end)

    EventsModule.RegisterServer("mercy-jobs/server/hunting/receive-goods", function(Source, AnimalName, AnimalBait, Illegal, ItemBuff)
        local Player = PlayerModule.GetPlayerBySource(Source)
        -- TODO: Add reward for ItemBuff
        if Illegal then
            if AnimalBait then
                local RandomValue = math.random(1, 60)
                if RandomValue >= 1 and RandomValue <= 5 then
                    Player.Functions.AddItem('hunting-carcass-one', 1, false, {Date = os.date(), Animal = AnimalName}, true)
                elseif RandomValue > 5 and RandomValue <= 15 then 
                    Player.Functions.AddItem('hunting-carcass-two', 1, false, {Date = os.date(), Animal = AnimalName}, true)
                elseif RandomValue > 15 and RandomValue <= 38 then 
                    Player.Functions.AddItem('hunting-carcass-three', 1, false, {Date = os.date(), Animal = AnimalName}, true)
                else
                    Player.Functions.AddItem('hunting-carcass-four', 1, false, {Date = os.date(), Animal = AnimalName}, true)
                end
            else
                local RandomValue = math.random(1, 60)
                if RandomValue >= 1 and RandomValue <= 20 then
                    Player.Functions.AddItem('hunting-carcass-one', 1, false, {Date = os.date(), Animal = AnimalName}, true)
                elseif RandomValue > 20 and RandomValue <= 45 then 
                    Player.Functions.AddItem('hunting-carcass-two', 1, false, {Date = os.date(), Animal = AnimalName}, true)
                elseif RandomValue > 45 and RandomValue <= 55 then 
                    Player.Functions.AddItem('hunting-carcass-three', 1, false, {Date = os.date(), Animal = AnimalName}, true)
                else
                    Player.Functions.AddItem('hunting-carcass-four', 1, false, {Date = os.date(), Animal = AnimalName}, true)
                end
            end
        else
            if AnimalBait then
                local RandomValue = math.random(1, 50)
                if RandomValue >= 1 and RandomValue <= 26 then
                    Player.Functions.AddItem('hunting-carcass-one', 1, false, {Date = os.date(), Animal = AnimalName}, true)
                elseif RandomValue > 26 and RandomValue <= 45 then 
                    Player.Functions.AddItem('hunting-carcass-two', 1, false, {Date = os.date(), Animal = AnimalName}, true)
                else
                    Player.Functions.AddItem('hunting-carcass-three', 1, false, {Date = os.date(), Animal = AnimalName}, true)
                end
            else
                local RandomValue = math.random(1, 50)
                if RandomValue >= 1 and RandomValue <= 45 then
                    Player.Functions.AddItem('hunting-carcass-one', 1, false, {Date = os.date(), Animal = AnimalName}, true)
                elseif RandomValue > 45 and RandomValue <= 49 then 
                    Player.Functions.AddItem('hunting-carcass-two', 1, false, {Date = os.date(), Animal = AnimalName}, true)
                else
                    Player.Functions.AddItem('hunting-carcass-three', 1, false, {Date = os.date(), Animal = AnimalName}, true)
                end
            end
        end
        if AnimalName ~= 'Retriever' and AnimalName ~= 'Mountain-Lion' then
            if math.random(1, 100) < 45 then
                Player.Functions.AddItem('hunting-meat', 1, false, false, true)
            end
        end
    end)
end)