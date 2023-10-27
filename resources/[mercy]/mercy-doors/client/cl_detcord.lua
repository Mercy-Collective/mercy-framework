local AlreadyDetcording = false

-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('mercy-items/client/used-lockpick', function(IsAdvanced)
    Citizen.SetTimeout(450, function()
        local PlayerData = PlayerModule.GetPlayerData()
        local Entity, EntityType, EntityCoords = FunctionsModule.GetEntityPlayerIsLookingAt(4.0, 0.2, 286, PlayerPedId())
        local DoorId = GetTargetDoorId(Entity)
        if DoorId ~= nil then
            if Config.Doors[DoorId].CanLockpick then
                local Outcome = exports['mercy-ui']:StartSkillTest(3, { 7, 10 }, { 1000, 1500 }, false)
                if Outcome then
                    TriggerServerEvent('mercy-doors/server/set-locks', DoorId, 0)
                    TriggerServerEvent('mercy-doors/server/toggle-locks', DoorId, 0)
                else
                    exports['mercy-assets']:RemoveLockpickChance(IsAdvanced)
                    TriggerEvent('mercy-ui/client/notify', 'lockpick-error', "Failed attempt..", 'error')
                end
            else
                TriggerEvent('mercy-ui/client/notify', "lockpick-error", "This door can\'t be lockpicked..", 'error')
            end
        else
            return
        end
    end)
end)

RegisterNetEvent('mercy-doors/client/used-detcord', function()
    Citizen.SetTimeout(450, function()
        local PlayerData = PlayerModule.GetPlayerData()
        if PlayerData.Job.Name ~= 'police' then TriggerEvent('mercy-ui/client/notify', "detcord-error", "You can\'t use this..", 'error') return end

        -- Housing
        if exports['mercy-housing']:IsNearHouse() then 
            local HouseData = exports['mercy-housing']:GetClosestHouse()
            if not HouseData.Locked then return end
            local Coords = vector3(HouseData.Coords.Enter.X, HouseData.Coords.Enter.Y, GetEntityCoords(PlayerPedId()).z + 0.5)
            local DetcordDone = DoDetcord(Coords)
            if DetcordDone then
                TriggerEvent('mercy-housing/client/lock-house-id', HouseData.Name)
            end
        else
            -- Doorlocks
            local Entity, EntityType, EntityCoords = FunctionsModule.GetEntityPlayerIsLookingAt(4.0, 0.2, 286, PlayerPedId())
            if Entity == 0 or Entity == -1 or EntityType ~= 3 then return end
            local DoorId = GetTargetDoorId(Entity)
            if not CanDetcordDoor(DoorId) then 
                TriggerEvent('mercy-ui/client/notify', "detcord-error", "This door can\'t be detcorded..", 'error')
                return 
            end
            local DetcordDone = DoDetcord(EntityCoords)
            if DetcordDone then
                TriggerServerEvent('mercy-doors/server/set-locks', DoorId, 0)
                if Config.Doors[DoorId].Connected ~= nil and next(Config.Doors[DoorId].Connected) then
                    for k, v in pairs(Config.Doors[DoorId].Connected) do
                        TriggerServerEvent('mercy-doors/server/toggle-locks', v, 0)
                    end
                end
            end
        end

    end)
end)

-- [ Functions ] --

function CanDetcordDoor(DoorId)
    if DoorId == nil or Config.Doors[DoorId] == nil then return false end
    if Config.Doors[DoorId].Locked == 1 then
        return Config.Doors[DoorId].CanDetcord
    else
        return false
    end
end

function DoDetcord(Coords)
    if AlreadyDetcording then return end

    local Coords = vector3(Coords.x, Coords.y, Coords.z - 0.4)

    AlreadyDetcording = true
    FunctionsModule.RequestModel("hei_p_m_bag_var22_arm_s")
    FunctionsModule.RequestAnimDict("anim@heists@ornate_bank@thermal_charge")

    Citizen.Wait(100)
    local Rotation = GetEntityRotation(PlayerPedId())
    HeistBagScene = NetworkCreateSynchronisedScene(Coords.x, Coords.y, Coords.z, Rotation.x, Rotation.y, Rotation.z, 2, false, false, 1065353216, 0, 1.3)

    local HeistBag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), Coords.x, Coords.y, Coords.z, true,  true, false)
    SetEntityCollision(HeistBag, false, true)
    NetworkAddPedToSynchronisedScene(PlayerPedId(), HeistBagScene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(HeistBag, HeistBagScene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(HeistBagScene)

    Citizen.Wait(1500)

    local HeistThermite = CreateObject(GetHashKey("hei_prop_heist_thermite"), Coords.x, Coords.y, Coords.z, true,  true, true)
    SetEntityCollision(HeistThermite, false, true)
    AttachEntityToEntity(HeistThermite, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
    Citizen.Wait(4000)
    EntityModule.DeleteEntity(HeistBag)

    DetachEntity(HeistThermite, 1, 1)
    FreezeEntityPosition(HeistThermite, true)
    local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', 'detcord', 1, false, true)
    
    Citizen.Wait(1500)

    TriggerServerEvent('mercy-heists/server/thermite-syncFx', Coords, true)
    TaskPlayAnim(Ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
    TaskPlayAnim(Ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 6000, 49, 1, 0, 0, 0)
    Citizen.Wait(2000)
    ClearPedTasks(Ped)
    Citizen.Wait(11000)
  
    EntityModule.DeleteEntity(HeistThermite)
    AlreadyDetcording = false

    return true
end