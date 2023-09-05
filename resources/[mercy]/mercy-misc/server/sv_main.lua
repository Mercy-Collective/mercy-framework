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

    CommandsModule.Add({"me"}, "Character Expression", {{Name="message", Help="Message"}}, false, function(source, args)
        local Text = table.concat(args, ' ')
        TriggerClientEvent('mercy-misc/client/me', source, source, Text)
    end)

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
        print('Giving goldpanning loot', Multiplier)
        if Multiplier == 1 then

        elseif Multiplier == 2 then

        elseif Multiplier == 3 then

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