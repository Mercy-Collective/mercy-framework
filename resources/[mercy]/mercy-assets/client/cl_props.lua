local NetProp, AllProps, HasProp, AttachedProps = {}, {}, false, {}
local PropList = {}

function AttachProp(Name)
    if Config.PropList[Name] ~= nil then
        if not HasProp then
            AttachedProps[Name] = true
            HasProp = true
            local ObjectHash = GetHashKey(Config.PropList[Name]['Model'])
            if FunctionsModule.RequestModel(ObjectHash) then
                local CurrentProp = CreateObject(ObjectHash, 0, 0, 0, true, false, false)
                local PropNetId = ObjToNet(CurrentProp)
                SetNetworkIdExistsOnAllMachines(PropNetId, true)
                SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(CurrentProp), true)
                AttachEntityToEntity(CurrentProp, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), Config.PropList[Name]['Bone']), Config.PropList[Name]['X'], Config.PropList[Name]['Y'], Config.PropList[Name]['Z'], Config.PropList[Name]['XR'], Config.PropList[Name]['YR'], Config.PropList[Name]['ZR'], true, true, false, true, 1, true)
                table.insert(NetProp, PropNetId)
                table.insert(AllProps, CurrentProp)
                table.insert(PropList, {
                    ['Name'] = Name,
                    ['NetId'] = PropNetId,
                    ['Object'] = CurrentProp
                })
            end
        end
    end 
end
exports("AttachProp", AttachProp)

function RemoveProps()
    for k, v in pairs(NetProp) do
        NetworkRequestControlOfEntity(NetToObj(v))
        SetEntityAsMissionEntity(NetToObj(v), true, true)
        DeleteObject(NetToObj(v))
    end
    for k, v in pairs(AllProps) do
        NetworkRequestControlOfEntity(v)
        SetEntityAsMissionEntity(v, true, true)
        DeleteObject(v)
    end
    AllProps, NetProp, AttachedProps, PropList = {}, {}, {}, {}
    HasProp = false
end
exports("RemoveProps", RemoveProps)

function GetPropStatus()
    return HasProp
end

AddEventHandler('onResourceStop', function(resource)
    RemoveProps()
end)

exports("GetSpecificProp", function(Name)
    for k, v in pairs(PropList) do
        if v['Name'] == Name then
            return v['Object']
        end
    end
    return false
end)

exports("GetSpecificPropStatus", function(Name)
  return AttachedProps[Name]
end)