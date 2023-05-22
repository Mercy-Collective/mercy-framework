local DuiCounter = 0
local AvailableDuis, Duis = {}, {}

-- [ Code ] --

-- [ Functions ] --
 
function GetDui(url, width, height)
    width = width or 512
    height = height or 512
    local DuiSize = tostring(width) .. "x" .. tostring(height)
    if (AvailableDuis[DuiSize] and #AvailableDuis[DuiSize] > 0) then
        local n,t = pairs(AvailableDuis[DuiSize])
        local nextKey, nextValue = n(t)
        local id = nextValue
        local dictionary = Duis[id].textureDictName
        local texture = Duis[id].textureName
        -- clear
        nextValue = nil
        table.remove(AvailableDuis[DuiSize], nextKey)
        ChangeDuiURL(Duis[id].duiObject, url)
        return {id = id, dictionary = dictionary, texture = texture}
    end
    -- Generate a new one.
    DuiCounter = DuiCounter + 1
    local generatedDictName = DuiSize.."-dict-"..tostring(DuiCounter)
    local generatedTxtName = DuiSize.."-txt-"..tostring(DuiCounter)
    local duiObject = CreateDui(url, width, height)
    local dictObject = CreateRuntimeTxd(generatedDictName)
    local duiHandle = GetDuiHandle(duiObject)
    local txdObject = CreateRuntimeTextureFromDuiHandle(dictObject, generatedTxtName, duiHandle)
    Duis[DuiCounter] = {
        duiSize = DuiSize,
        duiObject = duiObject,
        duiHandle = duiHandle,
        dictionaryObject = dictObject,
        textureObject = txdObject,
        textureDictName = generatedDictName,
        textureName = generatedTxtName
    }
    return {id = DuiCounter, dictionary = generatedDictName, texture = generatedTxtName, object = duiObject, handle = duiHandle}
end

function ChangeDuiURL(id, url)
    if not Duis[id] then return end
    local Settings = Duis[id]
    SetDuiUrl(Settings.duiObject, url)
end

function ReleaseDui(id)
    if not Duis[id] then
        return
    end
    local Settings = Duis[id]
    local DuiSize = Settings.duiSize
    SetDuiUrl(Settings.duiObject, "about:blank")
    if not AvailableDuis[DuiSize] then
        AvailableDuis[DuiSize] = {}
    end
    table.insert(AvailableDuis[DuiSize], id)
end
