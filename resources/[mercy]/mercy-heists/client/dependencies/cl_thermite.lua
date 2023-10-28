local AlreadyThermiting = false

function DoThermite(Coords, IsColor)
    if AlreadyThermiting then return end

    AlreadyThermiting = true
    local Prom = promise:new()

    FunctionsModule.RequestModel("hei_p_m_bag_var22_arm_s")
    FunctionsModule.RequestAnimDict("anim@heists@ornate_bank@thermal_charge")

    Citizen.Wait(100)
    local Rotation = GetEntityRotation(PlayerPedId())
    HeistBagScene = NetworkCreateSynchronisedScene(Coords.x, Coords.y, Coords.z, Rotation.x, Rotation.y, Rotation.z, 2, false, false, 1065353216, 0, 1.3)
    
    local HeistBag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), Coords.x, Coords.y, Coords.z,  true,  true, false)
    SetEntityCollision(HeistBag, false, true)
    NetworkAddPedToSynchronisedScene(PlayerPedId(), HeistBagScene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(HeistBag, HeistBagScene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(HeistBagScene)

    Citizen.Wait(1500)

    local HeistThermite = CreateObject(GetHashKey("hei_prop_heist_thermite"), Coords.x, Coords.y, Coords.z + 0.2,  true,  true, true)
    SetEntityCollision(HeistThermite, false, true)
    AttachEntityToEntity(HeistThermite, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
    Citizen.Wait(4000)
    EntityModule.DeleteEntity(HeistBag)

    DetachEntity(HeistThermite, 1, 1)
    FreezeEntityPosition(HeistThermite, true)

    local OnSuccess = function(Success)
        if Success then
            TriggerServerEvent('mercy-heists/server/thermite-syncFx', Coords, false)
            TaskPlayAnim(Ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
            TaskPlayAnim(Ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 6000, 49, 1, 0, 0, 0)
            Citizen.Wait(2000)
            ClearPedTasks(Ped)
            exports['mercy-inventory']:SetBusyState(false)
            Citizen.Wait(11000)
        end

        EntityModule.DeleteEntity(HeistThermite)

        AlreadyThermiting = false
        Prom:resolve(Success)
    end

    if IsColor then
        exports['mercy-ui']:ColorMinigame(OnSuccess)
    else
        exports['mercy-ui']:MemoryMinigame(OnSuccess)
    end

    return Citizen.Await(Prom)
end
exports('DoThermite', DoThermite)

function DoNormalThermite(IsColor)
    if AlreadyThermiting then return end

    AlreadyThermiting = true
    local Prom = promise:new()

    local OnSuccess = function(Success)
        if Success then
            ClearPedTasks(Ped)
            exports['mercy-inventory']:SetBusyState(false)
        end

        AlreadyThermiting = false
        Prom:resolve(Success)
    end

    if IsColor then
        exports['mercy-ui']:ColorMinigame(OnSuccess)
    else
        exports['mercy-ui']:MemoryMinigame(OnSuccess)
    end

    return Citizen.Await(Prom)
end
exports('DoNormalThermite', DoNormalThermite)

RegisterNetEvent('mercy-heists/client/thermite/sync-fx', function(Coords, Detcord)
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    local Distance = #(PlayerCoords - Coords)
    if Distance < 45.0 then
        RequestNamedPtfxAsset("scr_ornate_heist")
        while not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
            Citizen.Wait(1)
        end
    
        SetPtfxAssetNextCall("scr_ornate_heist")
        local Effect = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", Coords.x, Coords.y + 1.0, Coords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
        Citizen.Wait(11000)
        if Detcord then 
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.5)
            PlaySoundFromCoord(-1, "MAIN_EXPLOSION_CHEAP", Coords.x, Coords.y, Coords.z, 0, 0, 75.0, 0) 
        end
        StopParticleFxLooped(Effect, 0)
    end
end)