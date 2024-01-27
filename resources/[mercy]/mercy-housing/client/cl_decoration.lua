-- [ Code ] --

-- [ Events ] --

RegisterNetEvent('mercy-housing/client/remove-decoration-menu', function()
    if not InsideHouse then return exports['mercy-ui']:Notify("housing-error", "You must be inside a house to do this..", "error") end
    local MenuItems = {}

    for k, v in pairs(InsideHouseData.Decorations) do
        local MenuData = {}
        MenuData['Title'] = '(' .. k .. ') ' .. v.Model
        MenuData['Desc'] = 'Select this prop'
        MenuData['Data'] = { ['Event'] = 'mercy-housing/client/select-furniture', ['Type'] = 'Client', ['DecorationId'] = k }
        MenuData['SecondMenu'] = {
            {
                ['Title'] = 'Delete Decoration',
                ['Type'] = 'Click',
                ['Data'] = { ['Event'] = 'mercy-housing/client/delete-furniture', ['Type'] = 'Client', ['DecorationId'] = k },
            },
        }
        table.insert(MenuItems, MenuData)
    end

    exports['mercy-ui']:OpenContext({ ['MainMenuItems'] = MenuItems,
        ['ReturnEvent'] = {['Event'] = 'mercy-housing/client/unselect-furniture', ['Type'] = 'Client'}, 
        ['CloseEvent'] = {['Event'] = 'mercy-housing/client/unselect-furniture', ['Type'] = 'Client'}
    })
end)

RegisterNetEvent('mercy-housing/client/delete-furniture', function(Data)
    EventsModule.TriggerServer("mercy-housing/server/delete-decoration", Data.DecorationId, InsideHouseData.Name)
    SetTimeout(250, function()
        TriggerEvent('mercy-housing/client/remove-decoration-menu')
    end)
end)

RegisterNetEvent('mercy-housing/client/unselect-furniture', function(Data)
    HasFurnitureSelected = false
end)

RegisterNetEvent('mercy-housing/client/select-furniture', function(Data)
    HasFurnitureSelected = true
    if InsideHouseData.Decorations[tonumber(Data.DecorationId)] then
        Citizen.CreateThread(function()
            RequestStreamedTextureDict("helicopterhud")

            while HasFurnitureSelected do
                local Object = LoadedDecorations[tonumber(Data.DecorationId)]

                if Object == nil or not DoesEntityExist(Object) then
                    HasFurnitureSelected = false
                    exports['mercy-ui']:Notify("housing-error", "This decoration does not exist?", "error")
                end

                local EntityCoords = GetEntityCoords(Object)
                local OnScreen, ScreenX, ScreenY = GetScreenCoordFromWorldCoord(EntityCoords.x, EntityCoords.y, EntityCoords.z)
                SetDrawOrigin(EntityCoords.x, EntityCoords.y, EntityCoords.z, 0)

                if OnScreen then DrawSprite("helicopterhud", "hud_lock", 0, 0, 0.03, 0.05, 0, 0, 248, 185, 255) end
                ClearDrawOrigin()

                Citizen.Wait(1)
            end
        end)
    else
        exports['mercy-ui']:Notify("housing-error", "This decoration does not exist?", "error")
    end
end)

RegisterNetEvent('mercy-housing/client/open-furniture', function(Data)
    TriggerEvent('mercy-housing/client/cancel-preview')
    OpenFurnitureMenu(Data)
end)

RegisterNetEvent('mercy-housing/client/open-furniture-category', function(Data)
    TriggerEvent('mercy-housing/client/cancel-preview')
    OpenFurnitureMenuCategory(Data)
end)

local PreviewObject = nil
RegisterNetEvent('mercy-housing/client/preview-furniture', function(Data)
    local Coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 1.75, 0) GetEntityCoords(PlayerPedId())

    if PreviewObject == nil then
        FunctionsModule.RequestModel(Data.Model)
        PreviewObject = CreateObject(Data.Model, Coords.x, Coords.y, Coords.z, false, true, false)

        SetEntityHeading(PreviewObject, GetEntityHeading(PlayerPedId()) + 180)
        PlaceObjectOnGroundProperly(PreviewObject)
        FreezeEntityPosition(PreviewObject, true)
        SetEntityAlpha(PreviewObject, 205, false)
        SetEntityVisible(PlayerPedId(), false)
    end
end)

RegisterNetEvent('mercy-housing/client/cancel-preview', function()
    SetEntityVisible(PlayerPedId(), true)
    if PreviewObject then
        DeleteObject(PreviewObject)
        SetModelAsNoLongerNeeded(PreviewObject)
        PreviewObject = nil
    end
end)

RegisterNetEvent('mercy-housing/client/place-furniture', function(Data)
        TriggerEvent('mercy-housing/client/cancel-preview')
    EntityModule.DoEntityPlacer(Data['Model'], 15.0, false, true, nil, function(DidPlace, Coords, Heading)
        if not DidPlace then
            TriggerEvent('mercy-housing/client/open-furniture', { HouseId = InsideHouseData.Name })
            return exports['mercy-ui']:Notify("housing-error", "You stopped placing this decoration, or something went wrong..", "error")
        end

        EventsModule.TriggerServer('mercy-housing/server/place-decoration', InsideHouseData.Name, Data['Model'], Coords, Heading)

        SetTimeout(250, function()
            TriggerEvent('mercy-housing/client/open-furniture', { HouseId = InsideHouseData.Name })
        end)
    end)
end)

-- [ Functions ] --

function OpenFurnitureMenu(Data)
    if InsideHouseData == nil or InsideHouseData.Name ~= Data.HouseId then
        return exports['mercy-ui']:Notify("housing-error", "You have to be in that house if you want to decorate it..", "error")
    end

    Citizen.SetTimeout(250, function()
        local MenuItems = {}
        for k, v in pairs(Config.EditorMenus) do
            local MenuData = {}
            MenuData['Title'] = v.Title
            MenuData['Desc'] = v.Desc
            MenuData['Data'] = { ['Event'] = 'mercy-housing/client/open-furniture-category', ['Type'] = 'Client', ['Category'] = v.Category }
            MenuData['Type'] = 'Click'
            MenuData['Disabled'] = v.Disabled
            table.insert(MenuItems, MenuData)
        end
        exports['mercy-ui']:OpenContext({ ['MainMenuItems'] = MenuItems })
    end)
end

function OpenFurnitureMenuCategory(Data)
    Citizen.SetTimeout(250, function()

        local MenuItems = {}
        MenuItems[1] = {}
        MenuItems[1]['Title'] = '<i class="fas fa-chevron-left"></i> Back'
        MenuItems[1]['Desc'] = 'Back'
        MenuItems[1]['Data'] = { ['Event'] = 'mercy-housing/client/open-furniture', ['Type'] = 'Client', ['HouseId'] = InsideHouseData.Name }
        MenuItems[1]['Type'] = 'Click'
    
        for k, v in pairs(Config.Decorations[Data.Category]) do
            local MenuData = {}
            MenuData['Title'] = v
            MenuData['Desc'] = ''
            MenuData['Data'] = { ['Event'] = 'mercy-housing/client/preview-furniture', ['Type'] = 'Client', ['Model'] = v }
            MenuData['SecondMenu'] = {
                {
                    ['Title'] = 'Place Decoration',
                    ['Type'] = 'Click',
                    ['Data'] = { ['Event'] = 'mercy-housing/client/place-furniture', ['Type'] = 'Client', ['Model'] = v },
                },
            }
            table.insert(MenuItems, MenuData)
        end
    
        exports['mercy-ui']:OpenContext({ ['MainMenuItems'] = MenuItems, 
            ['ReturnEvent'] = {['Event'] = 'mercy-housing/client/cancel-furniture', ['Type'] = 'Client'}, 
            ['CloseEvent'] = {['Event'] = 'mercy-housing/client/cancel-preview', ['Type'] = 'Client'}
        })
    end)
end

function UnloadDecoration()
    for k, v in pairs(LoadedDecorations) do
        DeleteObject(v)
        SetModelAsNoLongerNeeded(v)
    end
    LoadedDecorations = {}
end

function LoadDecoration(Decorations)
    for k, v in pairs(Decorations) do
        FunctionsModule.RequestModel(v.Model)
        local Object = CreateObject(v.Model, v.Coords.x, v.Coords.y, v.Coords.z, false, true, false)
        SetEntityHeading(Object, v.Heading)
        SetEntityCoords(Object, v.Coords.x, v.Coords.y, v.Coords.z)
        FreezeEntityPosition(Object, true)

        LoadedDecorations[k] = Object
    end
end
