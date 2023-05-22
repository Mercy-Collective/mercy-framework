local GrabProps = {}
local TrolleyTypes = {['Money'] = GetHashKey('ch_prop_ch_cash_trolly_01c'), ['Gold'] = GetHashKey('ch_prop_gold_trolly_01c')}

-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('mercy-heists/client/try-trolly-gabbing', function(Nothing, Entity)
    local Type, CurrentRobbery, CanRob = GetCurrentRobberyType(), GetCurrentRobbery(), false
    if Type == 'Fleeca' or Type == 'Paleto' then
        if not Config.Panels[Type][CurrentRobbery.BankKey].Trolly.Busy then
            TriggerServerEvent('mercy-heists/server/banks/set-trolly-busy', Type, CurrentRobbery.BankKey, true)
            CanRob = true
        end
    end
    if CanRob then
        TriggerEvent('mercy-heists/client/trolly-grab', Type, Entity)
        exports['mercy-ui']:ProgressBar('Grabbing..', 40000, false, false, true, false, function(DidComplete)
            if DidComplete then
                EventsModule.TriggerServer('mercy-heists/server/banks/receive-trolly-goods', Type)
            end
        end)
    end
end)

RegisterNetEvent('mercy-heists/client/trolly-grab', function(Nothing, Entity)
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    local BagProp = "hei_p_m_bag_var22_arm_s"
    local GrabProp = "hei_prop_heist_cash_pile"
    local CurrentTrolly = Entity

    FunctionsModule.RequestModel(BagProp)
    FunctionsModule.RequestModel(GrabProp)
    FunctionsModule.RequestAnimDict('anim@heists@ornate_bank@grab_cash')

    local GrabObject = CreateObject(GetHashKey(GrabProp), PlayerCoords, true)
    FreezeEntityPosition(GrabObject, true)
    SetEntityInvincible(GrabObject, true)
    SetEntityNoCollisionEntity(GrabObject, PlayerPedId())
    SetEntityVisible(GrabObject, false, false)
    AttachEntityToEntity(GrabObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
    table.insert(GrabProps, GrabObject)
    local StartedGrabbing = GetGameTimer()
    Citizen.CreateThread(function()
        while GetGameTimer() - StartedGrabbing < 37000 do
            Citizen.Wait(4)
            DisableControlAction(0, 73, true)
            if HasAnimEventFired(PlayerPedId(), GetHashKey("CASH_APPEAR")) then
                if not IsEntityVisible(GrabObject) then
                    SetEntityVisible(GrabObject, true, false)
                end
            end
            if HasAnimEventFired(PlayerPedId(), GetHashKey("RELEASE_CASH_DESTROY")) then
                if IsEntityVisible(GrabObject) then
                    SetEntityVisible(GrabObject, false, false)                   
                end
            end
        end
    end)
    
    NetworkRequestControlOfEntity(CurrentTrolly)
    while not NetworkHasControlOfEntity(CurrentTrolly) do
		Citizen.Wait(1)
	end

    local BagObject = CreateObject(GetHashKey(BagProp), GetEntityCoords(PlayerPedId()), true, false, false)
    table.insert(GrabProps, BagObject)
    local GrabAnimationOne = NetworkCreateSynchronisedScene(GetEntityCoords(CurrentTrolly), GetEntityRotation(CurrentTrolly), 2, false, false, 1065353216, 0, 1.3)
	NetworkAddPedToSynchronisedScene(PlayerPedId(), GrabAnimationOne, "anim@heists@ornate_bank@grab_cash", "intro", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(BagObject, GrabAnimationOne, "anim@heists@ornate_bank@grab_cash", "bag_intro", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(GrabAnimationOne)
    Citizen.Wait(1500)
    local GrabAnimationTwo = NetworkCreateSynchronisedScene(GetEntityCoords(CurrentTrolly), GetEntityRotation(CurrentTrolly), 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(PlayerPedId(), GrabAnimationTwo, "anim@heists@ornate_bank@grab_cash", "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(BagObject, GrabAnimationTwo, "anim@heists@ornate_bank@grab_cash", "bag_grab", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(CurrentTrolly, GrabAnimationTwo, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(GrabAnimationTwo)
    Citizen.Wait(37000)
    local GrabAnimationThree = NetworkCreateSynchronisedScene(GetEntityCoords(CurrentTrolly), GetEntityRotation(CurrentTrolly), 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(PlayerPedId(), GrabAnimationThree, "anim@heists@ornate_bank@grab_cash", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(BagObject, GrabAnimationThree, "anim@heists@ornate_bank@grab_cash", "bag_exit", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(GrabAnimationThree)
    Citizen.Wait(1800)
    
    EntityModule.DeleteEntity(CurrentTrolly)

    for k, v in pairs(GrabProps) do
        EntityModule.DeleteEntity(v)
    end
    
    GrabProps = {}
end)

-- [ Functions ] --

function SpawnTrolley(Coords, Type)
    Citizen.CreateThread(function()
        if Coords ~= nil and Type ~= nil then
            local SpawnModel = TrolleyTypes['Money']
            if Type == 'Gold' then
                SpawnModel = TrolleyTypes['Gold']
            end
            local LoadedModel = FunctionsModule.RequestModel(SpawnModel)
            if LoadedModel then
                local Trolley = CreateObject(SpawnModel, Coords.x, Coords.y, Coords.z, true, false, false)
                Citizen.Wait(0)
                SetEntityHeading(Trolley, Coords.w)
                PlaceObjectOnGroundProperly(Trolley)
            end
        end
    end)
end