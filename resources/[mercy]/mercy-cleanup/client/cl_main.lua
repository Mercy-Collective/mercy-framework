local EntityModule = nil
local SkipCleanupChecks = false

-- [ Code ] --

AddEventHandler('Modules/client/ready', function()
    TriggerEvent('Modules/client/request-dependencies', {
        'Entity'
    }, function(Succeeded)
        if not Succeeded then return end
        EntityModule = exports['mercy-base']:FetchModule('Entity')
    end)
end)

-- [ Threads ] --

CreateThread(function()
    while true do
        Wait(4)
        if LocalPlayer.state.LoggedIn then
            local ShitList = {}
            local PropList = GetGamePool("CObject")

            if SkipCleanupChecks then
                Wait(2500)
                goto skipwhile
            end
            
            for k, v in ipairs(PropList) do
                local Success, Model = pcall(function()
                    return GetEntityModel(v)
                end)
                
                if not Success then
                    EntityModule.DeleteEntity(v)
                    goto continue 
                end

                local Model = GetEntityModel(v)
                if Config.BlacklistedProps[Model] then
                    goto continue 
                end
                if IsEntityAttached(v) then
                    goto continue
                end
                if (GetObjectFragmentDamageHealth(v, true) ~= nil and (GetEntityHealth(v) >= GetEntityMaxHealth(v)) and (GetEntityRotation(v).x < 25.0 and GetEntityRotation(v).x > -25.0)) then
                    goto continue 
                end
                ShitList[#ShitList + 1] = v
                ::continue::
            end

            Wait(2500)

            for k, v in ipairs(ShitList) do 
                local Success, Model = pcall(function()
                    return GetEntityModel(v)
                end)
                
                if not Success then
                    EntityModule.DeleteEntity(v)
                    goto continue 
                end

                local Model, PropCoords = GetEntityModel(v), GetEntityCoords(v)
                if not DoesEntityHaveFragInst(v) then 
                    goto continue 
                end
                if v == PlayerPedId() then
                    goto continue
                end
                if IsEntityTouchingEntity(PlayerPedId(), v) then
                    goto continue
                end
                if IsEntityOnFire(v) then
                    StopFireInRange(PropCoords.x, PropCoords.y, PropCoords.z, 10.0)
                end
                if Config.RoadCheckObjects[Model] then
                    local Worked, GroundZ = GetGroundZAndNormalFor_3dCoord(PropCoords.x, PropCoords.y, PropCoords.z) 
                    if not IsPointOnRoad(PropCoords.x, PropCoords.y, GroundZ) then
                        goto continue
                    end
                end
                SetEntityCoords(v, -14204.15, -1923.68, -161.7)
                if IsEntityAMissionEntity(v) then
                    DeleteObject(v)
                end
                ::continue::
            end
            ::skipwhile::
        end
        Wait(1000)
    end
end)