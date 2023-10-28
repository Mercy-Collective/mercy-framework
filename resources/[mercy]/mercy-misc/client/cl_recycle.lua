local RecycleProps = {}
local IsInsideRecycle = false
local CurrentRecycleId, CurrentRecycle, HasPackage = false, false, false

Citizen.CreateThread(function()
    exports['mercy-polyzone']:CreateBox({
        center = vector3(1010.0, -3101.43, -39.0),
        length = 24.4,
        width = 36.6,
    }, {
        name = "recycle-center-zone",
        minZ = -40.0,
        maxZ = -30.0,
        heading = 0.0,
        hasMultipleZones = false,
        debugPoly = false,
    }, function() 
        IsInsideRecycle = true
        SpawnRecycleProps()
        StartInsideRecycleLoop()
    end, function() 
        IsInsideRecycle = false
        ClearRecycleProps()
    end)

    exports['mercy-ui']:AddEyeEntry("recycle-deliver", {
        Type = 'Zone',
        SpriteDistance = 10.0,
        Distance = 2.0,
        ZoneData = {
            Center = vector3(997.27, -3091.94, -39.0),
            Length = 1.25,
            Width = 0.4,
            Data = {
                heading = 0,
                minZ = -40.0,
                maxZ = -37.75
            },
        },
        Options = {
            {
                Name = 'grab',
                Icon = 'fas fa-circle',
                Label = 'Deliver Materials',
                EventType = 'Client',
                EventName = 'mercy-misc/client/deliver-recycle',
                EventParams = {},
                Enabled = function(Entity)
                    return HasPackage
                end,
            },
        }
    })
end)

function SelectRandomRecycle()
    CurrentRecycleId = math.random(#Config.RecyclePropsCoords)
    CurrentRecycle = Config.RecyclePropsCoords[CurrentRecycleId]
end

function StartInsideRecycleLoop()
    Citizen.CreateThread(function()
        while IsInsideRecycle do

            if not CurrentRecycle then
                SelectRandomRecycle()
            end

            if not HasPackage then
                DrawMarker(32, CurrentRecycle.x, CurrentRecycle.y, CurrentRecycle.z + 3.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 2.0, 1.0, 255, 0, 0, 100, false, false, false, true, false, false, false)
            else
                DrawMarker(32, 997.81, -3091.93, -39.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 2.0, 1.0, 255, 0, 0, 100, false, false, false, true, false, false, false)
            end

            Citizen.Wait(1)
        end
    end)
end

function SpawnRecycleProps()
    while FunctionsModule == nil do
        Citizen.Wait(250)
    end
    ClearRecycleProps()

    for k, Coords in pairs(Config.RecyclePropsCoords) do
        local Prop = Config.RecycleProps[math.random(1, #Config.RecycleProps)]
        FunctionsModule.RequestModel(Prop)

        local Object = CreateObjectNoOffset(GetHashKey(Prop), Coords.x, Coords.y, Coords.z, false, false, false)
        FreezeEntityPosition(Object, true)
        SetEntityInvincible(Object, true)
        SetEntityHeading(Object, Coords.w)

        exports['mercy-ui']:AddEyeEntry("recycle-grab-" .. k, {
            Type = 'Zone',
            SpriteDistance = 10.0,
            Distance = 2.0,
            ZoneData = {
                Center = vector3(Coords.x, Coords.y, Coords.z),
                Length = 2.0,
                Width = 2.0,
                Data = {
                    heading = Coords.w,
                    minZ = -40.0,
                    maxZ = -38.0
                },
            },
            Options = {
                {
                    Name = 'grab',
                    Icon = 'fas fa-circle',
                    Label = 'Take Materials',
                    EventType = 'Client',
                    EventName = 'mercy-misc/client/grab-recycle',
                    EventParams = {},
                    Enabled = function(Entity)
                        return CurrentRecycleId == k
                    end,
                },
            }
        })

        RecycleProps[#RecycleProps + 1] = Object
    end
end

function ClearRecycleProps()
    for k, v in pairs(RecycleProps) do
        DeleteEntity(v)
    end

    RecycleProps = {}
end

RegisterNetEvent("mercy-misc/client/grab-recycle", function()
    if HasPackage then return end
    
    StopAnimTask(PlayerPedId(), "mini@repair" ,"fixing_a_ped", 1.0)
    exports['mercy-inventory']:SetBusyState(true)
    exports['mercy-ui']:ProgressBar('Getting Materials...', math.random(5000, 8000), {
        ['AnimDict'] = 'mini@repair',
        ['AnimName'] = 'fixing_a_ped',
        ['AnimFlag'] = 0,
    }, false, true, false, function(DidComplete)
        exports['mercy-inventory']:SetBusyState(false)
        StopAnimTask(PlayerPedId(), "mini@repair" ,"fixing_a_ped", 1.0)
        SetTimeout(250, function()
            exports['mercy-assets']:RemoveProps()
            exports['mercy-assets']:AttachProp("CardBox")
            TriggerEvent("mercy-animations/client/play-animation", "box")
            HasPackage = true
        end)
    end)
end)

RegisterNetEvent("mercy-misc/client/deliver-recycle", function()
    if not HasPackage then return end

    TriggerEvent("mercy-animations/client/clear-animation")
    exports['mercy-assets']:RemoveProps()
    exports['mercy-inventory']:SetBusyState(true)
    exports['mercy-ui']:ProgressBar('Delivering Materials...', math.random(8000, 15000), {
        ['AnimDict'] = 'mp_car_bomb',
        ['AnimName'] = 'car_bomb_mechanic',
        ['AnimFlag'] = 16,
    }, false, true, false, function(DidComplete)
        exports['mercy-inventory']:SetBusyState(false)
        StopAnimTask(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 1.0)
        SelectRandomRecycle()
        HasPackage = false
        EventsModule.TriggerServer("mercy-misc/server/recycle/get-loot")
    end)
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    ClearRecycleProps()
    exports['mercy-assets']:RemoveProps()
end)