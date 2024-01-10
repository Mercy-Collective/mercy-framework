--[[
    App: Housing
]]

Housing = {}
Housing.OwnedProperties = {}

function Housing.OnPlayerLoad()
    local Houses = CallbackModule.SendCallback("mercy-phone/server/housing/get-owned-houses")
    Housing.OwnedProperties = Houses
end

RegisterNetEvent('mercy-housing/client/sync-house-data', function(Name, HouseData)
    Citizen.SetTimeout(500, function()
        if Housing.OwnedProperties[Name] then
            if exports['mercy-housing']:IsKeyholderHouseId(Name) then
                Housing.OwnedProperties[Name] = HouseData
            else
                Housing.OwnedProperties[Name] = nil
            end
            if CurrentApp == 'housing' then
                exports['mercy-ui']:SendUIMessage("Phone", "RenderHousingApp", {
                    OwnedProperties = Housing.OwnedProperties,
                })
            end
        end
    end)
end)

function RefreshHouses()
    local Houses = CallbackModule.SendCallback("mercy-phone/server/housing/get-owned-houses")
    Housing.OwnedProperties = Houses
end

function Housing.Render()
    RefreshHouses()
    exports['mercy-ui']:SendUIMessage("Phone", "RenderHousingApp", {
        OwnedProperties = Housing.OwnedProperties,
        Room = { RoomId = PlayerModule.GetPlayerData().MetaData['RoomId'], Street = FunctionsModule.GetStreetName(vector3(-267.56, -958.96, 31.22)) },
    })
end

RegisterNUICallback('Housing/SearchCurrentLocation', function(Data, Cb)
    local HouseData = exports['mercy-housing']:GetClosestHouse()
    if HouseData == nil then Cb(false) return end
    print('Checking location', json.encode(HouseData))
    Cb({
        Id = HouseData.Name,
        Adress = HouseData.Adres,
        Category = exports['mercy-housing']:GetCategoryFromTier(HouseData.Interior),
        Price = HouseData.Price,
        ForSale = not HouseData.Owned
    })
end)

RegisterNUICallback('Housing/PurchaseHousing', function(Data, Cb)
    local Purchased = CallbackModule.SendCallback("mercy-phone/server/housing/purchase-house", Data)
    if Purchased then
        local Houses = CallbackModule.SendCallback("mercy-phone/server/housing/get-owned-houses")
        Housing.OwnedProperties = Houses
        exports['mercy-ui']:SendUIMessage("Phone", "RenderHousingApp", {
            OwnedProperties = Housing.OwnedProperties,
        })
    end
    Cb(Purchased)
end)

-- Housing Options

RegisterNUICallback('Housing/ToggleLock', function(Data, Cb)
    local NewState = CallbackModule.SendCallback("mercy-phone/server/housing/toggle-locks", Data)
    Cb(NewState)
end)

RegisterNUICallback('Housing/SellHouse', function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-phone/server/housing/sell-house", Data)
    local Houses = CallbackModule.SendCallback("mercy-phone/server/housing/get-owned-houses")
    Housing.OwnedProperties = Houses
        exports['mercy-ui']:SendUIMessage("Phone", "RenderHousingApp", {
        OwnedProperties = Housing.OwnedProperties,
    })
    Cb(Result)
end)

RegisterNUICallback('Housing/Locate', function(Data, Cb)
    Cb('Ok')

    if Data.HouseId == 'apartment' then
        local Coords = exports['mercy-apartment']:GetApartmentLocation()
        SetNewWaypoint(Coords.x, Coords.y)
    else
        local HouseData = Housing.OwnedProperties[Data.HouseId]
        if HouseData == nil then return end
    
        SetNewWaypoint(HouseData.Coords.Enter.X, HouseData.Coords.Enter.Y)
    end
    exports['mercy-ui']:Notify("phone-success", "Waypoint set!", "primary")
end)

RegisterNUICallback('Housing/SetHouseLocation', function(Data, Cb)
    TriggerEvent('mercy-housing/client/set-house-location', Data)
    Cb('Ok')
end)

RegisterNUICallback('Housing/OpenFurniture', function(Data, Cb)
    ClosePhone()
    TriggerEvent('mercy-housing/client/open-furniture', Data)
    Cb('Ok')
end)

RegisterNUICallback('Housing/SetHouseOwner', function(Data, Cb)
    local Result = CallbackModule.SendCallback('mercy-phone/server/housing/give-house', Data)
    Cb(Result)
end)

RegisterNUICallback('Housing/DeleteFurniture', function(Data, Cb)
    ClosePhone()
    TriggerEvent('mercy-housing/client/remove-decoration-menu')
    Cb('Ok')
end)

-- Keys

RegisterNUICallback('Housing/AddKey', function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-phone/server/housing/add-key", Data)
    Cb(Result)
end)

RegisterNUICallback('Housing/GetKeyholders', function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-phone/server/housing/get-keyholders", Data)
    Cb(Result)
end)

RegisterNUICallback('Housing/RemoveKey', function(Data, Cb)
    local Result = CallbackModule.SendCallback("mercy-phone/server/housing/remove-key", Data)
    Cb(Result)
end)
