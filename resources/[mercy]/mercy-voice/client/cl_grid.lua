local GridSize, EdgeSize = Config.GridSize, Config.GridEdge
local CurrentGrids, PreviousGrid = {}, 0

local Deltas = {
    vector2(-1, -1),
    vector2(-1, 0),
    vector2(-1, 1),
    vector2(0, -1),
    vector2(1, -1),
    vector2(1, 0),
    vector2(1, 1),
    vector2(0, 1),
}

-- [ Threads ] --

Citizen.CreateThread(function()
    while true do
        if LocalPlayer.state.LoggedIn then
            Citizen.Wait(4)
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local CurrentGrid = GetGridChannel(PlayerCoords)
            local EdgeGrids = GetTargetChannels(PlayerCoords, EdgeSize)

            SetGridChannels(EdgeGrids, CurrentGrids)
            if Config.Debug then print(('[Grid] Current Grid: %s | Edge: %s'):format(CurrentGrid, json.encode(EdgeGrids))) end
        
            if CurrentGrid ~= PreviousGrid then
                SetVoiceChannel(CurrentGrid)
            end

            PreviousGrid = CurrentGrid
            
            Citizen.Wait(100)
        else
            Citizen.Wait(4)
        end
    end
end)

-- [ Functions ] --

function GridToChannel(Vectors)
    return (Vectors.x << 8) | Vectors.y
end

function GetGridChunk(Coords)
    return math.floor((Coords + 8192) / GridSize)
end

function GetGridChannel(Coords, Intact)
    local Grid = vector2(GetGridChunk(Coords.x), GetGridChunk(Coords.y))
    local Channel = GridToChannel(Grid)
    if not Intact and CurrentInstance ~= 0 then
        Channel = tonumber(("%s0%s"):format(Channel, CurrentInstance))
    end
    return Channel
end

function GetTargetChannels(Coords, Edge)
    local Targets = {}
    for _, Delta in ipairs(Deltas) do
        local Vectors = vector2(Coords.x + Delta.x * Edge, Coords.y + Delta.y * Edge)
        local Channel = GetGridChannel(Vectors)
        if not table.exist(Targets, Channel) then
            table.insert(Targets, Channel)
        end
    end
    return Targets
end

function SetGridChannels(Current, Previous)
    local ToRemove = {}
    for _, Grid in ipairs(Previous) do
        if not table.exist(Current, Grid) then
            ToRemove[#ToRemove + 1] = Grid
        end
    end
    AddChannelGroupToTargetList(Current, "Grid")
    RemoveChannelGroupFromTargetList(ToRemove, "Grid")
    CurrentGrids = Current
end

function LoadGridModule()
    RegisterModuleContext("Grid", 0)
    UpdateContextVolume("Grid", -1.0)
end
 
function RefreshGrids()
    CurrentGrids, PreviousGrid = {}, 0
end