local NearCarwash, WashingVehicle, WaitingForWash = false, false, false
local ptfxData = {
    {
        dict = 'cut_test',
        name = 'exp_hydrant',
        offset = {0.0,0.0,4.0},
        rot = {0.0, 180.0, 0.0},
        scale = 0.5,
    },

    {
        dict = 'cut_test',
        name = 'exp_hydrant',
        offset = {-0.5,0.0,4.0},
        rot = {0.0, 180.0, 0.0},
        scale = 0.5,
    },

    {
        dict = 'cut_test',
        name = 'exp_hydrant',
        offset = {-1.0,0.0,4.0},
        rot = {0.0, 180.0, 0.0},
        scale = 0.5,
    },

    {
        dict = 'cut_test',
        name = 'exp_hydrant',
        offset = {-1.5,0.0,4.0},
        rot = {0.0, 180.0, 0.0},
        scale = 0.5,
    },

    {
        dict = 'cut_test',
        name = 'exp_hydrant',
        offset = {-2.0,0.0,4.0},
        rot = {0.0, 180.0, 0.0},
        scale = 0.5,
    },


    {
        dict = 'cut_test',
        name = 'exp_hydrant',
        offset = {0.5,0.0,4.0},
        rot = {0.0, 180.0, 0.0},
        scale = 0.5,
    },

    {
        dict = 'cut_test',
        name = 'exp_hydrant',
        offset = {1.0,0.0,4.0},
        rot = {0.0, 180.0, 0.0},
        scale = 0.5,
    },

    {
        dict = 'cut_test',
        name = 'exp_hydrant',
        offset = {1.5,0.0,4.0},
        rot = {0.0, 180.0, 0.0},
        scale = 0.5,
    },

    {
        dict = 'cut_test',
        name = 'exp_hydrant',
        offset = {2.0,0.0,4.0},
        rot = {0.0, 180.0, 0.0},
        scale = 0.5,
    },

    {
        dict = 'scr_fbi5a',
        name = 'scr_tunnel_vent_bubbles',
        offset = {0.0,0.0,0.0},
        rot = {0.0,180.0,0.0},
        scale = 2.0,
    },

    {
        dict = 'scr_fbi5a',
        name = 'scr_tunnel_vent_bubbles',
        offset = {0.0,-1.0,0.0},
        rot = {0.0,180.0,0.0},
        scale = 1.0,
    },

    {
        dict = 'scr_fbi5a',
        name = 'scr_tunnel_vent_bubbles',
        offset = {0.0,1.0,0.0},
        rot = {0.0,180.0,0.0},
        scale = 1.0,
    },

    {
        dict = 'scr_fbi5a',
        name = 'scr_tunnel_vent_bubbles',
        offset = {0.0,-2.0,0.0},
        rot = {0.0,180.0,0.0},
        scale = 1.0,
    },

    {
        dict = 'scr_fbi5a',
        name = 'scr_tunnel_vent_bubbles',
        offset = {0.0,2.0,0.0},
        rot = {0.0,180.0,0.0},
        scale = 1.0,
    },
}

-- [ Code ] --

-- [ Init ] --

CreateThread(function()
    while not BlipModule do Wait(0) end
    -- Blips
    for CarwashId, Carwash in pairs(Config.CarwashLocations) do
        if Carwash.ShowBlip then
            BlipModule.CreateBlip('carwash-'..CarwashId, Carwash.Coords, 'Carwash', 100, 2, false, 0.38)
        end
    end

    for LocationId, Location in pairs(Config.CarwashLocations) do
        exports['mercy-polyzone']:CreateBox({
            center = Location.Coords, 
            length = 5.0, 
            width = 5.0,
        }, {
            name = 'carwash-'..LocationId,
            minZ = Location.Coords.z - 1.0,
            maxZ = Location.Coords.z + 2.0,
            heading = 0,
            hasMultipleZones = false,
            debugPoly = false,
        }, function() end, function() end)
    end
end)

-- [ Functions ] --

local function RequestNetworkControlOfEntity(Entity)
    NetworkRequestControlOfEntity(Entity)
    local Timeout = 2000

    while Timeout > 0 and not NetworkHasControlOfEntity(Entity) do
        Wait(100)
        Timeout = Timeout - 100
    end

    Timeout = 2000
    SetEntityAsMissionEntity(Entity, true, true)

    while Timeout > 0 and not IsEntityAMissionEntity(Entity) do
        Wait(100)
        Timeout = Timeout - 100
    end
end

local function RequestParticleFX(dict)
    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do Wait(0) end
end

local function CreateProp(model, coords)
    if FunctionsModule.RequestModel(model) then
        local Prop = CreateObjectNoOffset(model, coords.x, coords.y, coords.z, false, false, false)
        SetEntityAsMissionEntity(Prop, true, true)
        FreezeEntityPosition(Prop, true)
        SetEntityCollision(Prop, false, true)
        return Prop
    else
        return false
    end
end

-- [ Events ] --

RegisterNetEvent('mercy-polyzone/client/enter-polyzone', function(PolyData, Coords)
    local PolyName = string.sub(PolyData.name, 1, 7)
    if PolyName == 'carwash' then
        if not NearCarwash then
            NearCarwash = true

            if not ShowingInteraction then
                ShowingInteraction = true
                exports['mercy-ui']:SetInteraction('[E] Wash Car ($'..Config.CarwashSettings['Cost']..')', 'primary')
            end

            if PolyData.name == 'carwash-3' then
                UseWashProps = false
            else
                UseWashProps = true
            end 

            CreateThread(function()
                while NearCarwash do
                    Wait(4)
                    if IsControlJustReleased(0, 38) then -- E
                        exports['mercy-ui']:HideInteraction()
                        local PlayerPed = PlayerPedId()
                        local myVehicle = GetVehiclePedIsIn(PlayerPed)
                        if GetPedInVehicleSeat(myVehicle, -1) == PlayerPed and (Config.CarwashSettings['OnlyDirtyVehs'] and GetVehicleDirtLevel(myVehicle) >= 0.1 or not Config.CarwashSettings['OnlyDirtyVehs']) then
                            WashVehicle(myVehicle, UseWashProps)
                        else 
                            exports['mercy-ui']:Notify("not-dirty", "Vehicle is already clean...", "error")
                        end
                    end
                end
            end)
        end
    end
end)

RegisterNetEvent('mercy-polyzone/client/leave-polyzone', function(PolyData, Coords)
    local PolyName = string.sub(PolyData.name, 1, 7)
    if PolyName == 'carwash' then
        if NearCarwash then
            NearCarwash = false
            if ShowingInteraction then
                ShowingInteraction = false
                exports['mercy-ui']:HideInteraction()
            end
        end
    end
end)

RegisterNetEvent('mercy-carwash/client/do-sync', function(VehNet, WasherSource, UseProps)
    if NetworkDoesEntityExistWithNetworkId(VehNet) then
        if WasherSource == GetPlayerServerId(PlayerId()) then
            WaitingForWash = true
            WasherSource = true 
        end

        local Veh = NetworkGetEntityFromNetworkId(VehNet)
        local ptfxHandles = {}
        local SideProps = nil
        local MinOffsets, MaxOffsets = GetModelDimensions(GetEntityModel(Veh))

        if UseProps then
            local _, max_prop_dim = GetModelDimensions(`prop_carwash_roller_vert`)
            local LeftOffset = GetOffsetFromEntityInWorldCoords(Veh, MinOffsets.x, MinOffsets.y, MinOffsets.z - 0.5);LeftOffset = vector3(LeftOffset.x + max_prop_dim.x, LeftOffset.y, LeftOffset.z)
            local RightOffset = GetOffsetFromEntityInWorldCoords(Veh, MaxOffsets.x, MinOffsets.y, MinOffsets.z - 0.5);RightOffset = vector3(RightOffset.x - max_prop_dim.x, RightOffset.y, RightOffset.z)

            SideProps = {
                {prop = CreateProp(`prop_carwash_roller_vert`, LeftOffset), offset = vector3(MinOffsets.x - (max_prop_dim.x - 0.2), MinOffsets.y, max_prop_dim.z/2)},
                {prop = CreateProp(`prop_carwash_roller_vert`, RightOffset), offset = vector3(MaxOffsets.x + (max_prop_dim.x - 0.2), MinOffsets.y, max_prop_dim.z/2)},
            }

            for i =1, #SideProps, 1 do
                Citizen.CreateThread(function()
                    while SideProps and SideProps[i] and DoesEntityExist(SideProps[i].prop) do
                        if i == 1 then
                            SetEntityHeading(SideProps[i].prop, ((GetEntityHeading(SideProps[i].prop) + 0.75) + 360) %360)
                        elseif i == 2 then
                            SetEntityHeading(SideProps[i].prop, ((GetEntityHeading(SideProps[i].prop) - 0.75) + 360) %360)
                        end
                        Citizen.Wait(0)
                    end
                end)
            end
        end

        for index, ptfx in pairs(ptfxData) do
            RequestParticleFX(ptfx.dict)
            UseParticleFxAssetNextCall(ptfx.dict)
            local CreatedParticle = StartNetworkedParticleFxLoopedOnEntity(ptfx.name, Veh, ptfx.offset[1], ptfx.offset[2], ptfx.offset[3], ptfx.rot[1], ptfx.rot[2], ptfx.rot[3], ptfx.scale, false, false, false)
            table.insert(ptfxHandles, CreatedParticle)
        end

        local offset = MinOffsets.y
        local PropOffset = MinOffsets.y

        while offset < MaxOffsets.y and DoesEntityExist(Veh) do
            for i = 1, #ptfxHandles do
                SetParticleFxLoopedOffsets(ptfxHandles[i], ptfxData[i].offset[1], offset, ptfxData[i].offset[3], ptfxData[i].rot[1], ptfxData[i].rot[2], ptfxData[i].rot[3])
            end

            if SideProps ~= nil then
                for i = 1, #SideProps, 1 do
                    SetEntityCoordsNoOffset(SideProps[i].prop, GetOffsetFromEntityInWorldCoords(Veh, SideProps[i].offset.x, PropOffset, SideProps[i].offset.z))
                end
                PropOffset += 0.0055
            end

            offset += 0.0055
            Wait(0)
        end

        if Config.CarwashSettings['DoubleClean'] then
            while MinOffsets.y < offset and DoesEntityExist(Veh) do
                for i = 1, #ptfxHandles, 1 do
                    SetParticleFxLoopedOffsets(ptfxHandles[i], ptfxData[i].offset[1], offset, ptfxData[i].offset[3], ptfxData[i].rot[1], ptfxData[i].rot[2], ptfxData[i].rot[3])
                end
                if SideProps ~= nil then
                    for i = 1, #SideProps, 1 do
                        SetEntityCoordsNoOffset(SideProps[i].prop, GetOffsetFromEntityInWorldCoords(Veh, SideProps[i].offset.x, PropOffset, SideProps[i].offset.z))
                    end
                    PropOffset -= 0.0055
                end
                offset -= 0.0055
                Wait(0)
            end
        end

        for i = 1, #ptfxHandles do StopParticleFxLooped(ptfxHandles[i], false) end

        if SideProps ~= nil then
            for i = 1, #SideProps, 1 do DeleteEntity(SideProps[i].prop) end
            SideProps = nil
        end
        
        if WasherSource then
            RequestNetworkControlOfEntity(Veh)
            SetVehicleDirtLevel(Veh, 0.0)
            WashDecalsFromVehicle(Veh, 1.0)
            Wait(1000)
            FreezeEntityPosition(Veh, false)
            exports['mercy-ui']:Notify("car-washed", "Vehicle Washed", "success")
            WaitingForWash = false
            WashingVehicle = false
        end
    end
end)

function WashVehicle(Veh, UseProps)
    if WashingVehicle then return end
    local Paid = CallbackModule.SendCallback("mercy-carwash/server/do-payment")
    if Paid then
        WashingVehicle = true
        FreezeEntityPosition(Veh, true)
        TriggerServerEvent('mercy-carwash/server/do-sync', VehToNet(Veh), UseProps)
    end
end