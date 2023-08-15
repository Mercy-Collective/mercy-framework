local RegisteredBlips, RegisteredRadiusBlips = {}, {}

local _Ready = false
AddEventHandler('Modules/client/ready', function()
    if not _Ready then
        _Ready = true
        exports[GetCurrentResourceName()]:CreateModule("BlipManager", BlipModule)
    end
end)

BlipModule = {
    CreateBlip = function(BlipId, Coords, Text, Logo, FirstColor, Flashing, Size, ShortRange, Category, Number, Cone)
        if RegisteredBlips[BlipId] ~= nil then
            BlipModule.RemoveBlip(BlipId)
        end
        local Blip = AddBlipForCoord(Coords.x, Coords.y, Coords.z)
        SetBlipSprite(Blip, Logo)
        SetBlipDisplay(Blip, 4)
        SetBlipScale(Blip, Size)
        if ShortRange ~= nil and ShortRange ~= false then
            SetBlipAsShortRange(Blip, ShortRange)
        else
            SetBlipAsShortRange(Blip, true)
        end
        if FirstColor ~= nil and FirstColor ~= false then
            SetBlipColour(Blip, FirstColor)
        else
            SetBlipColour(Blip, 1)
        end
        if Flashing ~= nil and Flashing ~= false then
            SetBlipFlashes(Blip, true)
        end
        if Category ~= nil and Category ~= false then
            SetBlipCategory(Blip, Category)
            --7	Other Players
            --10 Property
            --11 Owned Property
        end
        if Number ~= nil and Number ~= false then
            ShowNumberOnBlip(Blip, Number)
        end
        if Cone ~= nil and Cone ~= false then
            SetBlipShowCone(Blip, Cone)
        end
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Text)
        EndTextCommandSetBlipName(Blip)
        RegisteredBlips[BlipId] = Blip
        return Blip
    end,
    CreateRadiusBlip = function(BlipId, Coords, Color, Radius)
        if RegisteredRadiusBlips[BlipId] ~= nil then
            BlipModule.RemoveBlip(BlipId)
        end
        local RadiusBlip = AddBlipForRadius(Coords.x, Coords.y, Coords.z, Radius)        
        SetBlipRotation(RadiusBlip, 0)
        SetBlipColour(RadiusBlip, Color)
        SetBlipAlpha(RadiusBlip, 175)
        RegisteredRadiusBlips[BlipId] = RadiusBlip
    end,
    SetBlipCoords = function(BlipId, Coords)
        local Blip = BlipModule.GetBlipById(BlipId)
        SetBlipCoords(Blip, Coords.x, Coords.y, Coords.z)
    end,
    RemoveBlip = function(BlipId)
        if RegisteredBlips[BlipId] ~= nil then
            RemoveBlip(RegisteredBlips[BlipId])
            RegisteredBlips[BlipId] = nil
        elseif RegisteredRadiusBlips[BlipId] ~= nil then
            RemoveBlip(RegisteredRadiusBlips[BlipId])
            RegisteredRadiusBlips[BlipId] = nil
        end
    end,
    GetBlipById = function(BlipId)
        if RegisteredRadiusBlips[BlipId] ~= nil then
            return RegisteredRadiusBlips[BlipId]
        end
        if RegisteredBlips[BlipId] ~= nil then
            return RegisteredBlips[BlipId]
        end
        return false
    end,
    GetAllBlipsData = function(Type)
        if Type ~= nil and Type == 'Radius' then
            return RegisteredRadiusBlips
        else
            return RegisteredBlips
        end
    end
}