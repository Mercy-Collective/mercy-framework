local BombProps = {}

RegisterNetEvent('mercy-heists/client/bomb-animation', function(Coords, Rotation)
    FunctionsModule.RequestModel("ch_prop_ch_explosive_01a")
    FunctionsModule.RequestAnimDict("anim_heist@hs3f@ig8_vault_explosives@right@male@")
    local HeistBag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), Coords.x + 0.5, Coords.y, Coords.z,  true,  true, false)
    local HeistExplosive = CreateObject(GetHashKey("ch_prop_ch_explosive_01a"), Coords.x + 0.5, Coords.y, Coords.z,  true,  true, false)
    table.insert(BombProps, HeistBag) table.insert(BombProps, HeistExplosive)
    SetEntityCollision(HeistBag, false, true)
    SetEntityCollision(HeistExplosive, false, true)

    local EnterAnim = NetworkCreateSynchronisedScene(Coords.x, Coords.y, Coords.z + 0.5, Rotation.x, Rotation.y, Rotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(PlayerPedId(), EnterAnim, "anim_heist@hs3f@ig8_vault_explosives@right@male@", "player_ig8_vault_explosive_enter", 4.0, -4.0, 1033, 0, 1000.0, 0)
    NetworkAddEntityToSynchronisedScene(HeistBag, EnterAnim, "anim_heist@hs3f@ig8_vault_explosives@right@male@", "bag_ig8_vault_explosive_enter", 1.0, -1.0, 0, 0)
    NetworkAddEntityToSynchronisedScene(HeistExplosive, EnterAnim, "anim_heist@hs3f@ig8_vault_explosives@right@male@", "semtex_a_ig8_vault_explosive_enter", 1.0, -1.0, 0, 0)
    NetworkStartSynchronisedScene(EnterAnim)

    Citizen.Wait(1200)

    local ExplosiveAnimOne = NetworkCreateSynchronisedScene(Coords.x, Coords.y, Coords.z + 0.5, Rotation.x, Rotation.y, Rotation.z, 2, 0, 0, 1065353216, 0, 1.3)	
    NetworkAddPedToSynchronisedScene(PlayerPedId(), ExplosiveAnimOne, "anim_heist@hs3f@ig8_vault_explosives@right@male@", "player_ig8_vault_explosive_plant_a", 4.0, -4.0, 1033, 0, 1000.0, 0)
    NetworkAddEntityToSynchronisedScene(HeistBag, ExplosiveAnimOne, "anim_heist@hs3f@ig8_vault_explosives@right@male@", "bag_ig8_vault_explosive_plant_a", 1.0, -1.0, 0, 0)
    NetworkAddEntityToSynchronisedScene(HeistExplosive, ExplosiveAnimOne, "anim_heist@hs3f@ig8_vault_explosives@right@male@", "semtex_a_ig8_vault_explosive_plant_a", 1.0, -1.0, 0, 0)
    local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', 'weapon_stickybomb', 1, false, true)

    NetworkStartSynchronisedScene(ExplosiveAnimOne)

    Citizen.Wait(2000)

    local ExplosiveAnimTwo = NetworkCreateSynchronisedScene(Coords.x, Coords.y, Coords.z + 0.5, Rotation.x, Rotation.y, Rotation.z, 2, 0, 0, 1065353216, 0, 1.3)	
    NetworkAddPedToSynchronisedScene(PlayerPedId(), ExplosiveAnimTwo, "anim_heist@hs3f@ig8_vault_explosives@right@male@", "player_ig8_vault_explosive_plant_b", 4.0, -4.0, 1033, 0, 1000.0, 0)
    NetworkAddEntityToSynchronisedScene(HeistBag, ExplosiveAnimTwo, "anim_heist@hs3f@ig8_vault_explosives@right@male@", "bag_ig8_vault_explosive_plant_b", 1.0, -1.0, 0, 0)
    FreezeEntityPosition(HeistExplosive, true)
    SetEntityCollision(HeistExplosive, false, true)
    
    local HeistExplosiveTwo = CreateObject(GetHashKey("ch_prop_ch_explosive_01a"), Coords.x + 0.5, Coords.y, Coords.z,  true,  true, false)
    table.insert(BombProps, HeistExplosiveTwo)
    SetEntityCollision(HeistExplosiveTwo, false, true)
    NetworkAddEntityToSynchronisedScene(HeistExplosiveTwo, ExplosiveAnimTwo, "anim_heist@hs3f@ig8_vault_explosives@right@male@", "semtex_b_ig8_vault_explosive_plant_b", 1.0, -1.0, 0, 0)
    local DidRemove = CallbackModule.SendCallback('mercy-base/server/remove-item', 'weapon_stickybomb', 1, false, true)
    NetworkStartSynchronisedScene(ExplosiveAnimTwo)
    
    Citizen.Wait(2000)

    SetEntityCollision(HeistExplosiveTwo, false, true)
    FreezeEntityPosition(HeistExplosiveTwo, true)
    NetworkStopSynchronisedScene(ExplosiveAnimTwo)
    EntityModule.DeleteEntity(HeistBag)
    ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('mercy-heists/client/reset-bomb-animation', function(Coords, Rotation)
    for k, v in pairs(BombProps) do
        EntityModule.DeleteEntity(v)
    end
    BombProps = {}
end)