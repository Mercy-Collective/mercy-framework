-- [ Code ] --

CallbackModule, PlayerModule, FunctionsModule, DatabaseModule, CommandsModule, EventsModule = nil, nil, nil, nil, nil, nil

local _Ready = false
AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Callback',
        'Player',
        'Functions',
        'Database',
        'Commands',
        'Events',
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
        DatabaseModule = exports['mercy-base']:FetchModule('Database')
        CommandsModule = exports['mercy-base']:FetchModule('Commands')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        _Ready = true
        
    end)
end)

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(100)
    end
    -- [ Commands ] --

   local function addCommand(name, description, animDict, animName, itemType)
        CommandsModule.Add(name, description, {}, false, function(source, args)
            TriggerClientEvent('mercy-clothing/client/take-off-face-wear', source, itemType, nil, animName, animDict, nil, nil, true)
        end)
    end

    local commands = {
        { name = "hat",        description = "Take hat off..",       animDict = 'missheist_agency2ahelmet', animName = 'take_off_helmet_stand', itemType = 'Hat' },
        { name = "glasses",    description = "Take glasses off..",   animDict = 'clothingspecs',           animName = 'take_off',               itemType = 'Glasses' },
        { name = "mask",       description = "Take mask off..",      animDict = 'missfbi4',                animName = 'takeoff_mask',           itemType = 'Mask' },
        { name = "vest",       description = "Take vest off..",      animDict = 'clothingtie',             animName = 'try_tie_negative_a',     itemType = 'ArmorVest' },
        { name = "pants",      description = "Take pants off..",     animDict = 'mini@triathlon',          animName = 'idle_f',                 itemType = 'Pants' },
        { name = "shirt",      description = "Take shirt off..",     animDict = 'clothingtie',             animName = 'try_tie_negative_a',     itemType = 'Shirts' },
        { name = "undershirt", description = "Take undershirt off..", animDict = 'clothingtie',             animName = 'try_tie_negative_a',     itemType = 'UnderShirt' },
        { name = "shoes",      description = "Take shoes off..",     animDict = 'mini@triathlon',          animName = 'idle_f',                 itemType = 'Shoes' },
        { name = "bag",        description = "Take bag off..",       animDict = 'mini@clothingtie',        animName = 'try_tie_negative_a',     itemType = 'Bag' },
    }

    for _, cmd in ipairs(commands) do
        addCommand(cmd.name, cmd.description, cmd.animDict, cmd.animName, cmd.itemType)
    end

    CommandsModule.Add('addoutfit', 'Put your current outfit in your closet.', {{Name = 'name', Help = 'Outfit Name'}}, false, function(source, args)
        local OutfitName = args[1] ~= nil and args[1] or 'outfit-'..math.random(111111, 999999)
        DebugLog('Menu', 'Adding outfit '..OutfitName..' to closet.')
        TriggerClientEvent('mc-clothing/client/save-current-outfit', source, OutfitName)
    end)

    CommandsModule.Add('skin', 'Clothing Menu', {}, false, function(source, args)
        DebugLog('Menu', 'Opening Clothing Menu.')
        TriggerClientEvent('mercy-clothing/client/open-menu', source)
    end, "admin")

    CommandsModule.Add('fixskins', 'Check the clothing tables and fix where needed.', {}, false, function(source, args)
        DatabaseModule.Execute('SELECT * FROM player_skins', {}, function(SkinsData)
            if SkinsData ~= nil then
                for k, v in pairs(SkinsData) do
                    local Skin = json.decode(v.skin)
                    local Tattoos = json.decode(v.tatoos)
                    if Skin == nil then
                        Skin = {}
                    end
                    if Tattoos == nil then
                        Tattoos = {}
                    end
    
                    -- Fix Skin
                    for i, j in pairs(Config.SkinData['Skin']) do
                        if Skin[i] == nil then
                            Skin[i] = Config.SkinData['Skin'][i]
                        end
                    end
                    -- Fix Tattoos
                    for l, m in pairs(Config.SkinData['Tattoos']) do
                        if Tattoos[l] == nil then
                            Tattoos[l] = Config.SkinData['Tattoos'][l]                    
                        end
                    end
                    DatabaseModule.Update('UPDATE player_skins SET skin = ?, tatoos = ? WHERE citizenid = ?', {
                        json.encode(Skin),
                        json.encode(Tattoos),
                        v.citizenid
                    })
                    DebugLog('Skins', 'Fixed skin for '..v.citizenid)
                end
            end
        end)
    end, "admin")

    -- [ Callbacks ] --

    CallbackModule.CreateCallback('mc-clothing/server/pay-for-clothes', function(Source, Cb, Price)
        local Player = PlayerModule.GetPlayerBySource(Source)
        if Player.Functions.RemoveMoney('Cash', Price) then
            Cb(true)
        else
            Cb(false)
            TriggerClientEvent("mc-clothing/client/load-player-skin", Source)
            Player.Functions.Notify('no-money', Lang:t('info.no_money'), "error")
        end
    end)

    CallbackModule.CreateCallback('mc-clothing/server/get-outfits', function(Source, Cb)
        local Player = PlayerModule.GetPlayerBySource(Source)
        local OutfitList = {}
        DatabaseModule.Execute('SELECT * FROM player_outfits WHERE citizenid = ?', {Player.PlayerData.CitizenId}, function(OutfitResult)
            if OutfitResult[1] ~= nil then
                for k, v in pairs(OutfitResult) do
                    OutfitList[k] = {
                        ['Skin'] = json.decode(OutfitResult[k].skin),
                        ['Name'] = OutfitResult[k].outfitname,
                        ['Id'] = OutfitResult[k].outfitId
                    }
                end
            end
            Cb(OutfitList)
        end)
    end)

end)


-- [ Events ] --

RegisterNetEvent("mc-clothing/server/rename-outfit", function(OutfitName, OutfitId, NewName)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    if Player then
        DatabaseModule.Update('UPDATE player_outfits SET outfitname = ? WHERE citizenid = ? AND outfitname = ? AND outfitId = ?', {
            NewName,
            Player.PlayerData.CitizenId,
            OutfitName,
            OutfitId
        })
    else
        DebugLog('Outfits', 'Could not find Player to update outfits.')
    end
end)

RegisterNetEvent("mc-clothing/server/save-skin", function(Data)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    if Player and Data ~= nil then
        DatabaseModule.Execute('SELECT * FROM player_skins WHERE citizenid = ?', {Player.PlayerData.CitizenId}, function(SkinResult)
            if SkinResult[1] ~= nil then
                DatabaseModule.Update('UPDATE player_skins SET model = ?, skin = ?, tatoos = ? WHERE citizenid = ?', {
                    Data['Skin']['Model'].Item ~= nil and Data['Skin']['Model'].Item == "" and "mp_m_freemode_01" or Data['Skin']['Model'].Item,
                    json.encode(Data['Skin']),
                    json.encode(Data['Tattoos']),
                    Player.PlayerData.CitizenId,
                })
                DebugLog('Skin', 'Updated skin for '..Player.PlayerData.CitizenId)
            else
                DatabaseModule.Insert('INSERT INTO player_skins (citizenid, model, skin, tatoos) VALUES (?, ?, ?, ?)', {
                    Player.PlayerData.CitizenId,
                    Data['Skin']['Model'].Item ~= nil and Data['Skin']['Model'].Item == "" and "mp_m_freemode_01" or Data['Skin']['Model'].Item,
                    json.encode(Data['Skin']),
                    json.encode(Data['Tattoos']),
                }, function(Result)
                    DatabaseModule.Execute('SELECT * FROM player_skins WHERE citizenid = ?', {Player.PlayerData.CitizenId}, function(SkinResult)
                        if SkinResult[1] ~= nil then
                            DebugLog('Skin', 'Saved skin for '..Player.PlayerData.CitizenId)
                            TriggerClientEvent("mc-clothing/client/load-skin", src, SkinResult[1].model, json.decode(SkinResult[1].skin), json.decode(SkinResult[1].tatoos))
                        else
                            DebugLog('Skin', 'Unable to save skin for '..Player.PlayerData.CitizenId)
                        end
                    end)
                end)
            end
            Player.Functions.Notify('saved-skin', Lang:t('info.saved_skin'), "success")
        end)
    else
        DebugLog('Save', 'Could not find Player or Data to save skin.')
    end
end)

RegisterNetEvent("mc-clothing/server/load-skin", function()
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    if Player then
        DatabaseModule.Execute('SELECT * FROM player_skins WHERE citizenid = ?', {Player.PlayerData.CitizenId}, function(SkinResult)
            if SkinResult[1] ~= nil then
                TriggerClientEvent("mc-clothing/client/load-skin", src, SkinResult[1].model, json.decode(SkinResult[1].skin), json.decode(SkinResult[1].tatoos))
            else
                TriggerClientEvent("mc-clothing/client/load-skin", src)
            end
        end)
    else
        DebugLog('Outfits', 'Could not find Player to load skin.')
    end
end)

RegisterNetEvent("mc-clothing/server/save-outfit", function(OutfitName, SkinData)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    if Player and SkinData ~= nil then
        local OutfitId = "outfit-"..math.random(1, 10).."-"..math.random(11111, 99999)
        DatabaseModule.Insert('INSERT INTO player_outfits (citizenid, outfitname, model, skin, outfitId) VALUES (?, ?, ?, ?, ?)', {
            Player.PlayerData.CitizenId,
            OutfitName,
            SkinData['Skin']['Model'].Item == "" and "mp_m_freemode_01" or SkinData['Skin']['Model'].Item,
            json.encode(SkinData['Skin']),
            OutfitId
        })
    else
        DebugLog('Save', 'Could not find Player, Model or SkinData to save skin.')
    end
end)

RegisterNetEvent("mc-clothing/server/remove-outfit", function(OutfitName, OutfitId)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    if Player then
        local Outfit = nil
        local OutfitIdentifier = nil
        if type(OutfitName) == 'table' then
            Outfit = OutfitName.name
            OutfitIdentifier = OutfitName.id
        else
            Outfit = OutfitName
            OutfitIdentifier = OutfitId
        end
        DatabaseModule.Execute('DELETE FROM player_outfits WHERE citizenid = ? AND outfitname = ? AND outfitId = ?', {
            Player.PlayerData.CitizenId,
            Outfit,
            OutfitIdentifier
        })
    else
        DebugLog('Outfits', 'Could not find player to delete outfit.')
    end
end)

-- [ Functions ] --

function DebugLog(Comp, Text)
    print("[DEBUG:"..Comp.."]: "..Text)
end

RegisterNetEvent("mercy-clothing/server/receive-clothing", function(Type, Data)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    local Item = 'clothing-'..Type
    Player.Functions.AddItem(Item, 1, false, Data, true)
end)

RegisterNetEvent("mercy-clothing/server/steal-shoes", function(ServerId, ToShoes)
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    Player.Functions.AddItem("weapon_shoe", 1, false, false, true)
    TriggerClientEvent('mercy-clothing/client/take-off-face-wear', ServerId, 'Shoes', ToShoes, 'idle_f', 'mini@triathlon')
end)
