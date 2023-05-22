local KeybindsModule, CallbackModule, Scenes, ScenesEnabled, ForceRefresh = nil, nil, {}, true, false

local _Ready = false
AddEventHandler('Modules/client/ready', function()
    if not _Ready then
        _Ready = true
    end
    TriggerEvent('Modules/client/request-dependencies', {
        'Keybinds',
        'Callback',
    }, function(Succeeded)
        if not Succeeded then return end
        KeybindsModule = exports['mercy-base']:FetchModule('Keybinds')
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
    end)
end)

RegisterNetEvent('mercy-base/client/on-login', function()
    Citizen.SetTimeout(350, function()
        InitScenes()
    end)
end)

RegisterNetEvent('mercy-base/client/on-logout', function()
    ScenesEnabled = false
end)

-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    AddTextEntry("LONGSTRING", "~a~\n~a~\n~a~")
end)

-- [ Events ] --

RegisterNetEvent("mercy-scenes/client/update-scene", function(SceneId, Scene)
    if Scene then
        Config.Scenes[SceneId] = Scene
    else
        table.remove(Config.Scenes, SceneId)
        ForceRefresh = true
    end
end)

-- [ Functions ] --

function InitScenes()
    ScenesEnabled = GetResourceKvpInt("mercy_scene_disabled") ~= nil and GetResourceKvpInt("mercy_scene_disabled") == 0 or true

    local Scenes = CallbackModule.SendCallback("mercy-scenes/server/get-scenes")
    Config.Scenes = Scenes

    if ScenesEnabled then StartScenesLoop() end

    KeybindsModule.Add("toggleScenes", "Scenes", "Toggle", "", function(IsPressed)
        if IsPressed then
            ScenesEnabled = not ScenesEnabled
            SetResourceKvpInt("mercy_scene_disabled", ScenesEnabled and 0 or 1)
            exports['mercy-ui']:Notify("scene-action", "Scenes " .. (ScenesEnabled and "activated" or "deactivated"), ScenesEnabled and "success" or "error")
            if ScenesEnabled then StartScenesLoop() end
        end
    end)
    
    local PlacingScene = false
    KeybindsModule.Add("placeScene", "Scenes", "Place", "", function(IsPressed)
        if not ScenesEnabled then return end
        PlacingScene = IsPressed

        if PlacingScene then
            Citizen.CreateThread(function()
                local CanPlace, ScenePos = true, vector3(0.0, 0.0, 0.0)
                while PlacingScene do
                    if GetVehiclePedIsIn(PlayerPedId()) ~= 0 then
                        CanPlace = false
                        return
                    end

                    local Hit, Coords, _, _ = RayCastGamePlayCamera(7.0)
                    if Hit then
                        ScenePos = Coords
                        DrawMarker(28, Coords.x, Coords.y, Coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.1, 255, 0, 0, 100, false, false, 2, false, false, false)
                    end

                    Citizen.Wait(4)
                end

                if not CanPlace or #(ScenePos - vector3(0.0, 0.0, 0.0)) <= 1.0 then return end

                local ColorChoices = {}
                for k, v in pairs(Config.Colors) do
                    ColorChoices[#ColorChoices + 1] = {
                        Icon = false,
                        Text = k,
                    }
                end

                local Result = exports['mercy-ui']:CreateInput({
                    { Label = 'Tekst', Icon = 'fas fa-pencil-alt', Name = 'Text' },
                    { Label = 'Kleur', Icon = 'fas fa-palette', Name = 'Color', Choices = ColorChoices },
                    { Label = 'Afstand (0.1 - 10)', Icon = 'fas fa-people-arrows', Name = 'Distance', Type = 'Number' },
                })

                if Result then
                    if #Result.Text > Config.MaxTextLength then
                        exports['mercy-ui']:Notify("scene-action", "Text is too long.. (" .. #Result.Text .. "/" .. Config.MaxTextLength .. ")", "error")
                        return
                    end

                    if #Result.Color == 0 then Result.Color = "white" end
                    if Config.Colors[Result.Color:lower()] == nil then
                        exports['mercy-ui']:Notify("color-not-good", "Invalid color..", "error")
                        return
                    end
                    
                    if #Result.Distance == 0 then Result.Distance = 1.0 end
                    local Dist = tonumber(Result.Distance) + 0.0
                    if Dist < 0.1 or Dist > 10.0 then
                        exports['mercy-ui']:Notify("long-distance", "Invalid distance..", "error")
                        return
                    end

                    TriggerServerEvent("mercy-scenes/server/add-scene", Result, ScenePos)
                end
            end)
        end
    end)
    
    KeybindsModule.Add("deleteScene", "Scenes", "Delete closest", "", function(IsPressed)
        if not IsPressed or not ScenesEnabled then return end
        
        local PlayerCoords = GetEntityCoords(PlayerPedId())
        local ClosestScene, ClosestDist = -1, 0.0
        for k, v in pairs(Config.Scenes) do
            if ClosestScene == -1 or #(PlayerCoords - v.Coords) < ClosestDist then
                ClosestScene = k
                ClosestDist = #(PlayerCoords - v.Coords)
            end
        end
    
        if ClosestScene ~= -1 and ClosestDist <= 4.0 then
            TriggerServerEvent("mercy-scenes/server/remove-scene", ClosestScene)
        end
    end)
end

function StartScenesLoop()
    Citizen.CreateThread(function()
        local LastUpdate = 0
        local ScenesToDraw = {}
        while ScenesEnabled do
            local PlayerCoords = GetEntityCoords(PlayerPedId())

            if ForceRefresh or GetGameTimer() - LastUpdate >= 500 then
                ForceRefresh, LastUpdate, ScenesToDraw = false, GetGameTimer(), {}
                for k, v in pairs(Config.Scenes) do
                    if #(PlayerCoords - v.Coords) <= v.Distance then
                        -- Calculate amount of lines for background height
                        local Lines = 0

                        if (string.sub(v.Text, 0, 99)):len() > 0 then Lines = Lines + 1 end
                        if (string.sub(v.Text, 100, 199)):len() > 0 then Lines = Lines + 1 end
                        if (string.sub(v.Text, 200, 255)):len() > 0 then Lines = Lines + 1 end

                        local _, Count = v.Text:gsub('\n', '\n')
                        Lines = Count + Lines

                        local _, Count2 = v.Text:gsub('~n~', '~n~')
                        Lines = Count2 + Lines

                        ScenesToDraw[#ScenesToDraw + 1] = {
                            Coords = v.Coords,
                            Color = v.Color,
                            Text = {
                                Lines = Lines,
                                StringOne = string.sub(v.Text, 0, 99),
                                StringTwo = string.sub(v.Text, 100, 199),
                                StringThree = string.sub(v.Text, 200, 255),
                            }
                        }
                    end
                end
            end
            
            for k, v in pairs(ScenesToDraw) do
                local Dist = #(PlayerCoords - v.Coords)
                DrawText3D(v.Coords.x, v.Coords.y, v.Coords.z, Dist, v.Text, v.Color)
            end

            Citizen.Wait(4)
        end
    end)
end

function GetMapRange(S, A1, A2, B1, B2)
    return B1 + (S - A1) * (B2 - B1) / (A2 - A1)
end

function GetCharCount(Text)
    local AllText = Text.StringOne .. Text.StringTwo .. Text.StringThree
	local CharCount = 0
	for k in AllText:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
		CharCount = CharCount + 1
	end
	return CharCount
end

function DrawText3D(X, Y, Z, Dist, Text, Color)
    if not Text then return end

    local OnScreen, _x, _y = World3dToScreen2d(X, Y, Z)
    if not OnScreen then return end

    local Scale = math.max(GetMapRange(Dist, 0, 10.0, 0.5, 0.1), 0.1)
    local Width = (0.015 * GetCharCount(Text)) * Scale

    SetDrawOrigin(X, Y, Z, 0)
    local RgbColor = Config.Colors[Color] or Config.Colors['white']
    SetTextColour(RgbColor.r, RgbColor.g, RgbColor.b, 255)
    SetTextScale(0.0, Scale)
    SetTextFont(0)
    SetTextCentre(true)
    SetTextEntry("LONGSTRING")
    AddTextComponentSubstringPlayerName(Text.StringOne)
    AddTextComponentSubstringPlayerName(Text.StringTwo)
    AddTextComponentSubstringPlayerName(Text.StringThree)
    EndTextCommandDisplayText(0, 0)

    local CharHeight = GetRenderedCharacterHeight(Scale, 4)
    local TotalHeight = (CharHeight + (Scale / 50)) * Text.Lines
    DrawRect(0, TotalHeight / 2.2, Width, TotalHeight, 0, 0, 0, 100)

    ClearDrawOrigin()
end

local function RotationToDirection(Rotation)
    local AdjustedRotation = vector3(
        math.pi / 180 * Rotation.x,
        math.pi / 180 * Rotation.y,
        math.pi / 180 * Rotation.z
    )
    local Direction = vector3(
        -math.sin(AdjustedRotation.z) * math.abs(math.cos(AdjustedRotation.x)),
        math.cos(AdjustedRotation.z) * math.abs(math.cos(AdjustedRotation.x)),
        math.sin(AdjustedRotation.x)
    )
    return Direction
end

function RayCastGamePlayCamera(distance)
    local CamRot = GetGameplayCamRot()
    local CamCoord = GetGameplayCamCoord()
    local Direction = RotationToDirection(CamRot)
    local Destination = vector3(
        CamCoord.x + Direction.x * distance,
        CamCoord.y + Direction.y * distance,
        CamCoord.z + Direction.z * distance
    )
    local Ray = StartShapeTestRay(CamCoord.x, CamCoord.y, CamCoord.z, Destination.x, Destination.y, Destination.z, 17, -1, 0)
    local _, Hit, EndCoords, SurfaceNormal, EntityHit = GetShapeTestResult(Ray)
    return Hit, EndCoords, EntityHit, SurfaceNormal
end