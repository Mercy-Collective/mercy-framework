local MessagesCount, CanStealShoes = 0, true
EventsModule, CallbackModule, FunctionsModule, PlayerModule, EntityModule, VehicleModule = nil, nil, nil, nil, nil, nil

RegisterNetEvent('mercy-base/client/on-login', function()
    Citizen.SetTimeout(350, function()
        local GoPros = CallbackModule.SendCallback("mercy-misc/server/gopros/get-all")
        Config.GoPros = GoPros
        InitGoPros()
        InitMiscZones()
    end)
end)

local _Ready = false
AddEventHandler('Modules/client/ready', function()
    if not _Ready then
        _Ready = true
    end
    TriggerEvent('Modules/client/request-dependencies', {
        'Player',
        'Events',
        'Callback',
        'Functions',
        'Entity',
        'Vehicle',
    }, function(Succeeded)
        if not Succeeded then return end
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
        EntityModule = exports['mercy-base']:FetchModule('Entity')
        VehicleModule = exports['mercy-base']:FetchModule('Vehicle')
    end)
end)

-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('mercy-misc/client/steal-target-shoes', function(Data)
    if CanStealShoes then
        CanStealShoes = false
        FunctionsModule.RequestAnimDict("random@domestic")
        TaskPlayAnim(PlayerPedId(), 'random@domestic', 'pickup_low',5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
        Citizen.Wait(1400)
        ClearPedTasks(PlayerPedId())
        TriggerServerEvent('mercy-clothing/server/steal-shoes', Data.ServerId, Data.ToShoes)
        Citizen.SetTimeout(2000, function()
            CanStealShoes = true
        end)
    else
        exports['mercy-ui']:Notify("misc-error", "I don\'t think so..", 'error')
    end
end)

RegisterNetEvent('mercy-misc/client/open-scav-box', function(BoxId)
    Citizen.SetTimeout(450, function()
        if exports['mercy-inventory']:CanOpenInventory() then
            EventsModule.TriggerServer('mercy-inventory/server/open-other-inventory', BoxId, 'Stash', 25, 500, 'scavbox')
        end
    end)
end)

RegisterNetEvent('mercy-misc/client/do-yoga', function(Nothing, Entity)
    local EntityCoords, EntityHeading = GetEntityCoords(Entity), GetEntityHeading(Entity)
    TaskStartScenarioAtPosition(PlayerPedId(), "WORLD_HUMAN_YOGA", EntityCoords.x, EntityCoords.y, EntityCoords.z, (EntityHeading + 90.0), 20000, false, true)
    exports['mercy-ui']:ProgressBar('Breathe In..', 20000, false, false, true, false, function(DidComplete)
        if DidComplete then
            EventsModule.TriggerServer('mercy-ui/server/set-stress', 'Remove', math.random(15, 20))
        end
        ClearPedTasks(PlayerPedId())
    end)
end)

RegisterNetEvent('mercy-misc/client/used-dice', function()
    Citizen.SetTimeout(450, function()
        local Data = {{Name = 'Amount', Label = 'Dices Amount (1-20)', Icon = 'fas fa-dice'}, {Name = 'Sides', Label = 'Dice Sides (1-6)', Icon = 'fas fa-dice'}}
        local DiceInput = exports['mercy-ui']:CreateInput(Data)
        if DiceInput['Amount'] and tonumber(DiceInput['Amount']) <= 20 and DiceInput['Sides'] and tonumber(DiceInput['Sides']) <= 6 then
            local DiceResult = {}
            for i = 1, DiceInput['Amount'] do
                table.insert(DiceResult, math.random(1, DiceInput['Sides']))
            end
            TriggerEvent('mercy-assets/client/dice-animation')
            local RollText = CreateRollText(DiceResult, DiceInput['Sides'])
            Citizen.SetTimeout(1900, function()
                EventsModule.TriggerServer('mercy-ui/server/play-sound-in-distance', {['Distance'] = 2.0, ['Type'] = 'Distance', ['Name'] = 'dice', ['Volume'] = 0.3})
                EventsModule.TriggerServer('mercy-misc/server/send-me', RollText)
            end)
        else
            exports['mercy-ui']:Notify("misc-error", "An error occured!", 'error')
        end
    end)
end)

local MessagesCount = 0
RegisterNetEvent('mercy-misc/client/me', function(Source, Text)
    local Alpha = 600
    MessagesCount = MessagesCount + 1
    local MessageCount = MessagesCount + 0.1
    local Distance = 0.1
    
    local Ped = GetPlayerPed(GetPlayerFromServerId(Source))

    while Alpha > 0 do
        Alpha = Alpha - 1

        local Pos = GetEntityCoords(Ped)
        if GetVehiclePedIsUsing(Ped) ~= 0 then
            Pos = GetPedBoneCoords(Ped, 0x4B2)
            Distance = 0.2
        end

        OutputAlpha = Alpha

        if OutputAlpha > 255 then OutputAlpha = 255 end
        DrawMeText(Pos.x, Pos.y, Pos.z + (Distance * (MessageCount - 1)), Text, OutputAlpha)
        Citizen.Wait(1)
    end
    MessagesCount = MessagesCount - 1
end)

-- [ Functions ] --

function DrawMeText(X, Y, Z, Text, Alpha)
    local OnScreen, _X, _Y = World3dToScreen2d(X, Y, Z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    if Alpha > 255 then Alpha = 255 end

    if OnScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 155)
        SetTextEdge(1, 0, 0, 0, 250)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(Text)
        SetTextColour(255, 255, 255, Alpha)
        DrawText(_X,_Y)

        local factor = (string.len(Text)) / 250
        if Alpha < 115 then
            DrawRect(_X,_Y+0.0125, 0.015+ factor, 0.03, 11, 1, 11, Alpha)
        else
            DrawRect(_X,_Y+0.0125, 0.015+ factor, 0.03, 11, 1, 11, 115)
        end
    end
end

function CreateRollText(Table, Sides)
    local Total, String = 0, "~g~Dice Roll~s~: "
    for k, v in pairs(Table) do
        Total = Total + v
        if k == 1 then
            String = String .. v .. "/" .. Sides
        else
            String = String .. " | " .. v .. "/" .. Sides
        end
    end
    String = String .. " | (Total: ~g~"..Total.."~s~)"
    return String
end