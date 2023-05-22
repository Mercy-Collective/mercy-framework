function GenerateNewDui(URL, Width, Height, DuiId)
    if Config.SavedDuiData[DuiId] == nil then
        local Width, Height = Width or 1920, Height or 1080
        local DuiSize = tostring(Width) .. 'x' .. tostring(Height)
        local GenerateDictName = DuiSize..'-dict-'..tostring(DuiId)
        local GenerateTxtName = DuiSize..'-txt-'..tostring(DuiId)
        local URL = Config.DuiLinks[DuiId] ~= nil and Config.DuiLinks[DuiId] or URL
        local DuiObject = CreateDui(URL, Width, Height)
        local DictObject = CreateRuntimeTxd(GenerateDictName)
        local DuiHandle = GetDuiHandle(DuiObject)
        local TxdObject = CreateRuntimeTextureFromDuiHandle(DictObject, GenerateTxtName, DuiHandle)
        local ReturnData = {
            ['DuiId'] = DuiId,
            ['DuiSize'] = DuiSize,
            ['DuiObject'] = DuiObject,
            ['DuiHandle'] = DuiHandle,
            ['DictObject'] = DictObject,
            ['TxdObject'] = TxdObject,
            ['TxdDictName'] = GenerateDictName,
            ['TxdName'] = GenerateTxtName,
            ['Width'] = Width,
            ['Height'] = Height,
            ['DuiUrl'] = URL,
        }
        
        Config.DuiLinks[DuiId] = URL
        Config.SavedDuiData[DuiId] = ReturnData
        TriggerServerEvent('mercy-assets/server/set-dui-data', DuiId, ReturnData)
        return ReturnData
    else
        return false
    end
end

function GetDuiData(DuiId)
    if Config.SavedDuiData[DuiId] ~= nil then
        return Config.SavedDuiData[DuiId]
    end
end

function ReleaseDui(DuiId)
    if Config.SavedDuiData[DuiId] ~= nil then
        local Settings = Config.SavedDuiData[DuiId]
        SetDuiUrl(Settings['DuiObject'], 'about:blank')
        DestroyDui(Settings['DuiObject'])
        Config.SavedDuiData[DuiId] = nil
    end
end

function DeactivateDui(DuiId)
    if Config.SavedDuiData[DuiId] ~= nil then
        local Settings = Config.SavedDuiData[DuiId]
        SetDuiUrl(Settings['DuiObject'], 'about:blank')
    end
end

function ActivateDui(DuiId)
    if Config.SavedDuiData[DuiId] ~= nil then
        local Settings = Config.SavedDuiData[DuiId]
        SetDuiUrl(Settings['DuiObject'], Config.DuiLinks[DuiId])
    end
end

function ChangeDuiURL(DuiId, URL)
    if not Config.SavedDuiData[DuiId] then return end
    local Settings = Config.SavedDuiData[DuiId]
    SetDuiUrl(Settings['DuiObject'], URL)
end

-- [ Events ] --

RegisterNetEvent('mercy-assets/client/set-dui-url', function(DuiId, URL)
    if Config.SavedDuiData[DuiId] ~= nil then
        local Settings = Config.SavedDuiData[DuiId]
        Config.DuiLinks[DuiId] = URL
        Settings['DuiUrl'] = URL
        SetDuiUrl(Settings['DuiObject'], URL)
    end
end)

RegisterNetEvent('mercy-assets/client/set-dui-data', function(DuiId, DuiData)
    Config.DuiLinks[DuiId] = DuiData['DuiUrl']
    Config.SavedDuiData[DuiId] = DuiData
end)

RegisterNetEvent('mercy-assets/client/change-dui-url', function(DuiId)
    if DuiId == "police" then
        DuiId = exports['mercy-police']:GetMeetingRoomId()
    else
        DuiId = DuiId
    end
    local TargetId = DuiId
    Citizen.SetTimeout(450, function()
        local Data = {{Name = 'Url', Label = 'URL', Icon = 'fas fa-link'}}
        local DUIInput = exports['mercy-ui']:CreateInput(Data)
        if DUIInput['Url'] then
            TriggerServerEvent('mercy-assets/server/set-dui-url', TargetId, DUIInput['Url'])
        end
    end)
end)

exports("GenerateNewDui", GenerateNewDui) 
exports("GetDuiData", GetDuiData) 
exports("ReleaseDui", ReleaseDui) 
exports("DeactivateDui", DeactivateDui) 
exports("ActivateDui", ActivateDui) 
exports("ChangeDuiURL", ChangeDuiURL)