local EntityModule, FunctionsModule = nil, nil
local SpawnedObjects, InsideInterior = {}, false

AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
        'Entity',
        'Functions',
    }, function(Succeeded)
        if not Succeeded then return end
        EntityModule = exports['mercy-base']:FetchModule('Entity')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
    end)
end)

-- [ Code ] --

RegisterNetEvent('onResourceStop', function(Resource)
    if Resource == GetCurrentResourceName() then
        for k, v in pairs(SpawnedObjects) do
            DeleteObject(v)
        end
    end
end)

-- [ Functions ] --

function DespawnInteriors()
    for k, v in pairs(SpawnedObjects) do
		SetEntityAsMissionEntity(v, true, true)
		DeleteObject(v)
		table.remove(SpawnedObjects, k)
    end
    SpawnedObjects, InsideInterior = {}, false
end
exports("DespawnInteriors", DespawnInteriors)

function CreateInterior(InteriorId, Coords, LoadProps)
	if not IsModelValid(InteriorId) then
        exports['mercy-ui']:SendUIMessage('Prompts', 'CreatePrompt', {
            color = 'error',
            text = ("Interior '%s' cannot be loaded.."):format(InteriorId),
            duration = 2000,
            id = 'interior-error',
        })
        return false
    end

	if Config.Interiors[InteriorId] == nil then
        exports['mercy-ui']:SendUIMessage('Prompts', 'CreatePrompt', {
            color = 'error',
            text = ("Couldn't find interior settings for '%s'. This is not a major issue and may be ignored unless otherwise said."):format(InteriorId),
            duration = 2000,
            id = 'interior-warning-settings',
        })
	end

	if LoadProps and Config.Interiors[InteriorId] == nil then
        exports['mercy-ui']:SendUIMessage('Prompts', 'CreatePrompt', {
            color = 'error',
            text = ("Couldn't find interior props for '%s'. This **WILL** cause requested props not loading."):format(InteriorId),
            duration = 2000,
            id = 'interior-warning-props',
        })
		LoadProps = false
	end

    local ModelLoaded = FunctionsModule.RequestModel(InteriorId)
    if ModelLoaded then
        local Shell = CreateObject(GetHashKey(InteriorId), Coords.x, Coords.y, Coords.z, false, false, false)
        local Offsets = Config.Interiors[InteriorId] ~= nil and Config.Interiors[InteriorId].Offsets or {}
    
        SetEntityHeading(Shell, 0.0)
        FreezeEntityPosition(Shell, true)
        SetEntityInvincible(Shell, true)
    
        if LoadProps then
            LoadInteriorProps(InteriorId, Coords)
        end
    
        table.insert(SpawnedObjects, Shell)
        InsideInterior = true
    
        return {
            Shell,
            Offsets
        }
    end
end
exports("CreateInterior", CreateInterior)

function DespawnInterior(ObjectId)
    for k, v in pairs(SpawnedObjects) do
        if v == ObjectId then
            DeleteObject(v)
            table.remove(SpawnedObjects, k)
        end
    end
    InsideInterior, SpawnedObjects = false, {}
end
exports("DespawnInterior", DespawnInterior)

function LoadInteriorProps(InteriorId, Coords)
    if Config.Interiors[InteriorId] == nil or Config.Interiors[InteriorId].Props == nil then return end
    Citizen.CreateThread(function()
        for k, v in pairs(Config.Interiors[InteriorId].Props) do
            local Prop = CreateObject(GetHashKey(v.Prop), Coords.x + v.Coords.x, Coords.y + v.Coords.y, Coords.z + v.Coords.z, false, false, false)
            SetEntityHeading(Prop, v.Coords.w)
            FreezeEntityPosition(Prop, true)
            table.insert(SpawnedObjects, Prop)
        end
    end)
end

function IsInsideInterior()
    return InsideInterior
end
exports("IsInsideInterior", IsInsideInterior)

RegisterNetEvent('onResourceStop', function(Resource)
    if Resource == GetCurrentResourceName() then
        for k, v in pairs(SpawnedObjects) do
            DeleteObject(v)
        end
    end
end)

--[[
function round(value)
    return math.floor(value * 100) / 100
end

local Interior = false
RegisterCommand("getOffset", function(Source, Args, Raw)
    local Coords = GetEntityCoords(PlayerPedId())
    local IntCoords = GetEntityCoords(Interior)

    local Offset = vector3(Coords.x - IntCoords.x, Coords.y - IntCoords.y, IntCoords.z - Coords.z)
    TriggerEvent("mercy-admin/client/copy-to-clipboard", (
        "{ x = %s, y = %s, z = %s, h = %s },"
    ):format(round(Offset.x), round(Offset.y), round(Offset.z), round(GetEntityHeading(PlayerPedId()))))
end)

RegisterCommand("testInterior", function(Source, Args, Raw)
    exports['mercy-interiors']:DespawnInteriors()
    local Coords = GetEntityCoords(PlayerPedId())
    Coords = vector3(-1729.55, -2902.29, 13.94 - 35.0)
    local InteriorData = exports['mercy-interiors']:CreateInterior(Args[1], Coords, false)
    if not InteriorData then return end

    local Offsets = InteriorData[2]
    Interior = InteriorData[1]

    SetEntityCoords(PlayerPedId(), Coords.x + Offsets.Exit.x, Coords.y + Offsets.Exit.y, Coords.z + Offsets.Exit.z)
    SetEntityHeading(PlayerPedId(), Offsets.Exit.h)
end)
]]
