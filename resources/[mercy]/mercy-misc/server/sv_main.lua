CallbackModule, PlayerModule, FunctionsModule, DatabaseModule, CommandsModule, EventsModule = nil, nil, nil, nil, nil, nil
Carrying, Carried = {}, {}

local _Ready = false
AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Callback',
        'Player',
        'Functions',
        'Database',
        'Commands',
        'Events',
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
        DatabaseModule = exports['mercy-base']:FetchModule('Database')
        CommandsModule = exports['mercy-base']:FetchModule('Commands')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        _Ready = true
    end)
end)

Citizen.CreateThread(function() 
    while not _Ready do 
        Citizen.Wait(4) 
    end 

    CommandsModule.Add({"carry"}, "Carry the closest person", {}, false, function(source, args)
        local Player = PlayerModule.GetPlayerBySource(source)
        local Text = args[1]
        TriggerClientEvent('mercy-misc/client/try-carry', source)
    end)

    CallbackModule.CreateCallback('mercy-misc/server/gopros/does-exist', function(Source, Cb, CamId)
        for k, v in pairs(Config.GoPros) do
            if tonumber(v.Id) == tonumber(CamId) then
                Cb(v)
                return
            end
        end
        Cb(false)
    end)

    CallbackModule.CreateCallback('mercy-misc/server/gopros/get-all', function(Source, Cb)
        Cb(Config.GoPros)
    end)

    CallbackModule.CreateCallback('mercy-misc/server/has-illegal-item', function(Source, Cb)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player then
            for k, v in pairs(Config.IllegalItems) do
                local ItemData = Player.Functions.GetItemByName(v)
                if ItemData ~= nil and ItemData.Amount > 0 then
                    Cb(v)
                end
            end
        end
        Cb(false)
    end)
    
    EventsModule.RegisterServer("mercy-misc/server/spray-place", function(Source, Coords, Heading, Type)
        local CustomId = math.random(11111, 99999)
        local NewSpray = {
            Id = CustomId,
            Name = "Spray-"..CustomId,
            Type = Type,
            Coords = { 
                X = Coords.x,
                Y = Coords.y,
                Z = Coords.z - 2.0,
                H = Heading
            },
        }
        Config.Sprays[#Config.Sprays + 1] = NewSpray
        TriggerClientEvent('mercy-misc/client/sync-sprays', -1, NewSpray)
        TriggerClientEvent('mercy-misc/client/done-placing-spray', Source, CustomId)
    end)

    EventsModule.RegisterServer("mercy-misc/server/gopro-place", function(Source, Coords, Heading, Encrypted, IsVehicle, Vehicle)
        local CustomId = math.random(11111, 99999)
        local NewGoPro = {
            Id = CustomId,
            Name = "GoPro-"..CustomId,
            IsEncrypted = Encrypted,
            IsVehicle = IsVehicle,
            Vehicle = IsVehicle and Vehicle or false,
            Coords = { 
                X = Coords.x,
                Y = Coords.y,
                Z = Coords.z,
                H = Heading
            },
            Timestamp = os.date(),
        }
        Config.GoPros[#Config.GoPros + 1] = NewGoPro
        TriggerClientEvent('mercy-misc/client/gopro-action', -1, 2, NewGoPro)
        TriggerClientEvent('mercy-ui/client/notify', Source, "gopro-placed", "You placed a GoPro ("..CustomId..")", 'success')
    end)
    
    EventsModule.RegisterServer('mercy-misc/server/send-me', function(Source, Text)
        TriggerClientEvent('mercy-misc/client/me', -1, Source, Text)
    end)
    
    EventsModule.RegisterServer('mercy-misc/server/goldpanning/get-loot', function(Source, Multiplier)
        print('[DEBUG:Misc]: Giving goldpanning loot. Multiplier: '..Multiplier)
        if Multiplier == 1 then

        elseif Multiplier == 2 then

        elseif Multiplier == 3 then

        end
    end)

    function ShuffleTable(tbl)
        local random = math.random
        local n = #tbl

        for i = n, 2, -1 do
            local j = random(i)
            tbl[i], tbl[j] = tbl[j], tbl[i]
        end
    end

    EventsModule.RegisterServer('mercy-misc/server/metal-detecting/get-loot', function(Source)
        print('[DEBUG:Misc]: Giving metal detecting loot.')

        local Player = PlayerModule.GetPlayerBySource(Source)
        if not Player then return end
        local RandomChance = math.random(0, 100) / 100

        local ShuffledItems = {}
        for ItemName, Chance in pairs(Config.MetalDetectItems) do
            table.insert(ShuffledItems, { Name = ItemName, Chance = Chance })
        end
        ShuffleTable(ShuffledItems)

        for _, ItemData in ipairs(ShuffledItems) do
            if RandomChance <= ItemData.Chance then
                Player.Functions.AddItem(ItemData.Name, math.random(1, 4), false, {}, true)
                return
            end
        end

        Player.Functions.Notify('no-item', 'You did not find anything..', 'error')
    end)

    EventsModule.RegisterServer('mercy-misc/server/recycle/get-loot', function(Source)
        print('[DEBUG:Misc]: Giving recycle loot.')
        local Player = PlayerModule.GetPlayerBySource(Source)
        if not Player then return end

        Player.Functions.AddItem('recyclablematerial', math.random(5, 8), false, false, true)
    end)

    EventsModule.RegisterServer('mercy-misc/server/get-tea', function(Source)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if not Player then return end
        if Player.Functions.RemoveItem('water', 1) then
            Player.Functions.AddItem('mugoftea', 1, false, {}, true)
        end
    end)

    EventsModule.RegisterServer('mercy-misc/server/write-notepad', function(Source, Text)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if not Player then return end
          
        local Notepad = Player.Functions.GetItemByName('notepad')
        if Notepad == nil then return end

        if Player.Functions.AddItem('notepad-page', 1, false, {Note = Text}, true) then
            Notepad.Info.Pages = Notepad.Info.Pages - 1
            Player.Functions.SetItemBySlotAndKey(Notepad.Slot, "Info", Notepad.Info)
            if Notepad.Info.Pages <= 0 then
                Player.Functions.RemoveItem('notepad', 1, Notepad.Slot, true)          
            end
        end
    end)
end)

RegisterNetEvent("mercy-misc/server/sprays/try-remove", function(Data)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    if not Player then return end

    if Player.Functions.RemoveItem('scrubbingcloth', 1) then
        TriggerClientEvent('mercy-misc/client/sprays/remove', src, Data.Id)
    else
        Player.Functions.Notify('no-scrub-cloth', 'You do not seem to have a scrubbing cloth..', 'error')
    end
end)

RegisterNetEvent("mercy-misc/server/sprays/remove", function(Id)
    for SprayId, Spray in pairs(Config.Sprays) do
        if tonumber(SprayId) == tonumber(Id) then
            TriggerClientEvent('mercy-misc/client/sync-sprays', -1, Spray, true, SprayId)
            table.remove(Config.Sprays, SprayId)
            return
        end
    end
end)

RegisterNetEvent("mercy-misc/server/carry-target", function(TargetServer)
    local src = source
    TriggerClientEvent('mercy-misc/client/getting-carried', TargetServer, src)
    Carrying[src] = TargetServer
    Carried[TargetServer] = src
end)

RegisterNetEvent("mercy-misc/server/stop-carry", function()
    local src = source
    if Carrying[src] then
        TriggerClientEvent('mercy-misc/client/stop-carry', Carrying[src])
    elseif Carried[src] then
        TriggerClientEvent('mercy-misc/client/stop-carry', Carried[src])
    end
    Carrying[src] = nil
    Carried[TargetServer] = nil
end)

-- GoPro

RegisterNetEvent("mercy-misc/server/gopro-action", function(GoProId, Action, Bool)
    if Action == 'SetBlurred' then
        for k, v in pairs(Config.GoPros) do
            if tonumber(v.Id) == tonumber(GoProId) then
                Config.GoPros[k].Blurred = Bool
                TriggerClientEvent('mercy-misc/client/gopro-action', -1, 3, Config.GoPros[k])
                return
            end
        end
    end
end)