local InSpawnSelector, LoginCamera = false, nil

-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('mercy-housing/client/sync-house-data', function(Name, HouseData, RefreshInterior)
    if GetSpawnData('house_' .. Name) ~= nil then return end
    table.insert(Config.Locations, {
        Id = "house_"..Name,
        Name = HouseData.Adres,
        Icon = 'fas fa-house',
        Coords = { X = HouseData.Coords.Enter.X, Y = HouseData.Coords.Enter.Y },
        Type = 'House',
        Hidden = true,
    })
end)

RegisterNetEvent('mercy-spawn/client/open-spawn-selector', function()
    TriggerEvent('mercy-weathersync/client/set-default-weather', 17)

    Citizen.SetTimeout(750, function()
        InSpawnSelector = true
    
        SetEntityCoords(PlayerPedId(), -3970.76, 2016.56, 500.91)
        FreezeEntityPosition(PlayerPedId(), true)
        SetEntityVisible(PlayerPedId(), false)
    
        Config.Cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
        SetCamRot(Config.Cam , -90.0, 0.0, 250.0, 2)
        SetCamCoord(Config.Cam , -3968.85, 2015.93, 502.22)
        SetFocusArea(-3968.85, 2015.93, 502.22, 0.0, 0.0, 0.0)
        StopCamShaking(Config.Cam , true)
        SetCamFov(Config.Cam , 50.0)
        SetCamActive(Config.Cam , true)
        RenderScriptCams(true, false, 0, true, true)
    
        DoScreenFadeIn(250)
    
        SetNuiFocus(true, true)
    
        SendUIMessage('Spawn', 'SetVisibility', {
            Bool = true,
        })
    
        local Locations = {}
        local PlayerData = PlayerModule.GetPlayerData()
        while PlayerData == nil do
            PlayerData = PlayerModule.GetPlayerData()
            Wait(100)
        end
        
        if PlayerData.MetaData['Jail'] ~= nil and PlayerData.MetaData['Jail'] >= 1 then
            SendUIMessage('Spawn', 'SetupSpawns', {
                Spawns = {
                    {
                        Id = 'bolingbroke_penitentiary',
                        Name = 'Bolingbroke Penitentiary',
                        Icon = 'fas fa-voicemail',
                        Coords = { X = 1813.0, Y = 2605.78 },
                    },
                },
            })
            return
        end

        -- Own Houses
        local Houses = exports['mercy-housing']:GetHouseConfig()
        for k, v in pairs(Houses) do
            if GetSpawnData('house_'..v.Name) == nil then
                table.insert(Config.Locations, {
                    Id = "house_"..v.Name,
                    Name = v.Adres,
                    Icon = 'fas fa-house',
                    Coords = { X = v.Coords.Enter.X, Y = v.Coords.Enter.Y },
                    Type = 'House',
                    Hidden = true,
                })
            end
        end

        local FavoriteSpawnLoc = GetResourceKvpString("spawn_favorite")
        -- Keyholder Houses
        local Result = CallbackModule.SendCallback('mercy-houses/server/get-houses-keyholder', PlayerData.CitizenId)
        for k, v in pairs(Result) do
            table.insert(Locations, {
                Id = "house_"..v.Name,
                Name = v.Adres,
                Icon = 'fas fa-house',
                Coords = { X = v.Coords.Enter.X, Y = v.Coords.Enter.Y },
                Favorited = FavoriteSpawnLoc ~= nil and FavoriteSpawnLoc == v.Id or false,
            })
        end

        -- Locations
        for k, v in pairs(Config.Locations) do
            if not v.Hidden then
                if v.Id ~= 'last_location' then
                    table.insert(Locations, {
                        Id = v.Id,
                        Name = v.Name,
                        Icon = v.Icon,
                        Coords = { X = v.Coords.X, Y = v.Coords.Y },
                        Favorited = FavoriteSpawnLoc ~= nil and FavoriteSpawnLoc == v.Id or false,
                    })
                end
            end
        end

        -- Last Location
        if PlayerData.Position ~= nil then
            table.insert(Locations, {
                Id = 'last_location',
                Name = 'Last Location',
                Icon = 'fas fa-map-pin',
                Coords = { X = PlayerData.Position.x, Y =  PlayerData.Position.y },
            })
        end

        SendUIMessage('Spawn', 'SetupSpawns', {
            Spawns = Locations,
        })
    end)
end)

-- [ NUI Callbacks ] --

RegisterNUICallback("Spawn/Favorite", function(Data, Cb)
    local FavoriteLoc = GetResourceKvpString("spawn_favorite")
    if FavoriteLoc ~= nil and FavoriteLoc ~= Data.Id then
        SetResourceKvp("spawn_favorite", Data.Id)
        Cb({
            Bool = true,
            PrevId = FavoriteLoc,
            Id = Data.Id,
            Name = Data.Name
        })
    elseif FavoriteLoc == nil or FavoriteLoc == Data.Id then
        SetResourceKvp("spawn_favorite", "")
        Cb({
            Bool = false,
            Id = Data.Id,
            Name = Data.Name
        }) 
    end
end)

RegisterNUICallback('Spawn/GetSpawnData', function(Data, Cb)
    local SpawnData = GetSpawnData(Data.Id)
    Cb(SpawnData)
end)

RegisterNUICallback('Spawn/SelectSpawn', function(Data, Cb)
    local SpawnData = nil
    if Data.Id == 'last_location' then
        local PlayerData = exports['mercy-base']:FetchModule('Player').GetPlayerData()
        if PlayerData.Position ~= nil then
            SpawnData = {
                Type = 'Location',
                Coords = {
                    X = PlayerData.Position.x,
                    Y = PlayerData.Position.y,
                    Z = PlayerData.Position.z,
                },
            }
        end
    else
        SpawnData = GetSpawnData(Data.Id)
    end

    DoScreenFadeOut(250)
    while not IsScreenFadedOut() do Citizen.Wait(3) end
    InSpawnSelector = false

    SetCamActive(Config.Cam, false)
    DestroyCam(Config.Cam, true)
    RenderScriptCams(false, false, 1, true, true)
    
    SetNuiFocus(false, false)

    SendUIMessage('Spawn', 'SetVisibility', {
        Bool = false,
    })
    
    if not LocalPlayer.state.LoggedIn then
        TriggerEvent('mercy-base/client/on-login')
    end
    
    if SpawnData == nil then print("No SpawnData") return end

    local PlayerData = exports['mercy-base']:FetchModule('Player').GetPlayerData()
    while PlayerData == nil do
        PlayerData = exports['mercy-base']:FetchModule('Player').GetPlayerData()
	Wait(100)
    end
		
    if SpawnData.Type == 'Location' then
        EventsModule.TriggerServer("mercy-base/server/bucketmanager/set-routing-bucket", 0)
        SetEntityCoords(PlayerPedId(), SpawnData.Coords.X, SpawnData.Coords.Y, SpawnData.Coords.Z)
        DoLoginCamera(SpawnData.Coords.X, SpawnData.Coords.Y, SpawnData.Coords.Z)
        
        while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
            FreezeEntityPosition(PlayerPedId(), true)
            Citizen.Wait(1)
        end
        
        SetCamActive(LoginCamera, false)
        DestroyCam(LoginCamera, true)
        RenderScriptCams(false, false, 1, true, true)
        SetFocusEntity(PlayerPedId())
        
        SetEntityVisible(PlayerPedId(), true)
        FreezeEntityPosition(PlayerPedId(), false)
        
        Citizen.Wait(1000)
        DoScreenFadeIn(2500)
    elseif SpawnData.Type == 'Apartment' then
        SetEntityVisible(PlayerPedId(), true)
        SetFocusEntity(PlayerPedId())

        while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
            FreezeEntityPosition(PlayerPedId(), true)
            Citizen.Wait(1)
        end

        Citizen.SetTimeout(500, function()
            FreezeEntityPosition(PlayerPedId(), false)
            Citizen.Wait(2500)
            TriggerEvent('mercy-apartment/client/spawn-apartment', false)
        end)
    elseif SpawnData.Type == 'Jail' then
        EventsModule.TriggerServer("mercy-base/server/bucketmanager/set-routing-bucket", 0)
        SetEntityVisible(PlayerPedId(), true)
        SetFocusEntity(PlayerPedId())

        while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
            FreezeEntityPosition(PlayerPedId(), true)
            Citizen.Wait(1)
        end

        Citizen.SetTimeout(500, function()
            FreezeEntityPosition(PlayerPedId(), false)
            Citizen.Wait(1250)
            TriggerEvent('mercy-police/client/enter-jail', PlayerData.MetaData['Jail'], 0, true)
        end)
    elseif SpawnData.Type == 'House' then
        EventsModule.TriggerServer("mercy-base/server/bucketmanager/set-routing-bucket", 0)
        local HouseData = exports['mercy-housing']:GetHouseById(string.sub(Data.Id, 7, #Data.Id))
        if HouseData == nil then print("no house ):") return end

        SetEntityCoords(PlayerPedId(), HouseData.Coords.Enter.X, HouseData.Coords.Enter.Y, HouseData.Coords.Enter.Z)
        SetEntityVisible(PlayerPedId(), true)
        SetFocusEntity(PlayerPedId())

        while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
            FreezeEntityPosition(PlayerPedId(), true)
            Citizen.Wait(1)
        end

        Citizen.SetTimeout(2500, function()
            FreezeEntityPosition(PlayerPedId(), false)
            TriggerEvent('mercy-housing/client/enter-house', string.sub(Data.Id, 7, #Data.Id))
        end)
    end

    Config.Cam = nil
    Cb('Ok')
end)

-- [ Functions ] --

function DoLoginCamera(X, Y, Z)
	local CamAngle, I = -90.0, 2500
	DoScreenFadeOut(1)
	LoginCamera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	SetFocusArea(X, Y, Z, 0.0, 0.0, 0.0)
	SetCamActive(LoginCamera,  true)
	RenderScriptCams(true,  false,  0,  true,  true)
	DoScreenFadeIn(1500)
	while I > 1 do
		local Factor = I / 50
		if I < 1 then I = 1 end
		I = I - Factor
		SetCamCoord(LoginCamera, X, Y, Z + I)
		if I < 1200 then DoScreenFadeIn(600) end
		if I < 90.0 then CamAngle = I - I - I end
        if I < 25.0 then DoScreenFadeOut(600) end
		SetCamRot(LoginCamera, CamAngle, 0.0, 0.0)
		Citizen.Wait(2 / I)
	end
end

function GetSpawnData(Id)
    local Retval = nil
    for k, v in pairs(Config.Locations) do
        if v.Id == Id then
            Retval = v
        end
    end
    return Retval
end

-- [ Exports ] --

exports("AddLocation", function(Id, Data)
    Data.Id = Id
    table.insert(Config.Locations, Data)
end)

exports("RemoveLocation", function(Id, data)
    for k, v in pairs(Config.Locations) do
        if v.Id == Id then
            table.remove(Config.Locations, k)
        end
    end
end)
