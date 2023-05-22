local ShowingInteraction, NearAppraisal, GemVehicle, GemCam = false, false, nil, nil
local GemCoords = vector4(-468.39, 32.69, 46.92, 264.01)

-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('mercy-business/client/used-gemstone', function(GemData)
    if not NearAppraisal then
        TriggerEvent('mercy-ui/client/notify', 'gallery-error', "Where is the appraisal table??", 'error')
        return
    end
    local GemColor = GemData.GemType ~= nil and Config.GemColors[GemData.GemType] or 0
    CreateGem(GemColor, GemData.GemPurity ~= nil and GemData.GemPurity or 10.0)
end)

RegisterNetEvent('mercy-polyzone/client/enter-polyzone', function(PolyData, Coords)
    if PolyData.name == 'gallery-gem-ap' then
        if NearAppraisal then return end
        if not HasPlayerBusinessPermission('Vultur Le Culture', 'craft_access') then return end
        NearAppraisal = true
        if not ShowingInteraction then
            ShowingInteraction = true
            exports['mercy-ui']:SetInteraction('Appraisal', 'primary')
        end
    else
        return
    end
end)

RegisterNetEvent('mercy-polyzone/client/leave-polyzone', function(PolyData, Coords)
    if PolyData.name == 'gallery-gem-ap' then
        if not NearAppraisal then return end
        NearAppraisal = false
        if ShowingInteraction then
            ShowingInteraction = false
            exports['mercy-ui']:HideInteraction()
        end
    else
        return
    end
end)

-- [ Functions ] --

function CreateGem(Color, Purity)
    DoScreenFadeOut(1000)
    FreezeEntityPosition(PlayerPedId(), true)
    Citizen.SetTimeout(1000, function()
        local ModelLoaded = FunctionsModule.RequestModel('gem')
        local VehicleCoords = {['X'] = GemCoords.x, ['Y'] = GemCoords.y, ['Z'] = GemCoords.z, ['Heading'] = GemCoords.w}
        if ModelLoaded then
            local DirtLevel = (15 - math.floor(Purity / 6.66)) + 0.0
            GemVehicle = VehicleModule.SpawnLocalVehicle('gem', VehicleCoords, 'GALLERY1', false, false)
            FreezeEntityPosition(GemVehicle.Vehicle, true)
            SetEntityCollision(GemVehicle.Vehicle, false, false)
            SetVehicleDirtLevel(GemVehicle.Vehicle, DirtLevel)
            SetVehicleColours(GemVehicle.Vehicle, Color, 0)
            SetVehicleExtraColours(GemVehicle.Vehicle, 0, false)
            CreateGemCam(true)
            Citizen.CreateThread(function()
                while GemCam ~= nil do
                    Citizen.Wait(4)
                    if GemVehicle ~= nil then
                        local CurrentHeading = GetEntityHeading(GemVehicle.Vehicle)
                        if CurrentHeading >= 360 then
                            CurrentHeading = 0.0
                        end
                        SetEntityHeading(GemVehicle.Vehicle, CurrentHeading + 0.075)
                    end
                end
            end)
        end
        DoScreenFadeIn(1000)
        Citizen.CreateThread(function()
            local DisablePause = true
            Citizen.CreateThread(function()
                while DisablePause do
                    Citizen.Wait(4)
                    SetPauseMenuActive(false)
                    if IsControlJustPressed(0, 177) then
                        EscapeGem()
                        Citizen.SetTimeout(500, function()
                            DisablePause = false
                        end)
                    end
                end
            end)
        end)
    end)
end

function CreateGemCam(Bool)
    if Bool then
        GemCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(GemCam, GetOffsetFromEntityInWorldCoords(GemVehicle.Vehicle, 0.5, 0.0, 0.1))
        SetCamRot(GemCam, -20.0, 0.0, 352.0)
        SetCamFov(GemCam, 50.0)
        RenderScriptCams(true, false, 0, 1, 0)
    else
        if GemCam ~= nil then
            RenderScriptCams(false, false, 1, true, true)
            SetCamActive(GemCam, false)
            DestroyCam(GemCam, true)
            GemCam = nil
        end
        SetFocusEntity(PlayerPedId())
    end
end

function EscapeGem()
    DoScreenFadeOut(1000)
    Citizen.SetTimeout(800, function()
        CreateGemCam(false)
        if GemVehicle ~= nil then
            VehicleModule.DeleteVehicle(GemVehicle.Vehicle)
            GemVehicle = nil
        end
        FreezeEntityPosition(PlayerPedId(), false)
        DoScreenFadeIn(1000)
    end)
end