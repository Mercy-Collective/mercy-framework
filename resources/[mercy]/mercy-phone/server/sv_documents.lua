-- [ Code ] --

-- [ Threads ] --

Citizen.CreateThread(function()
    while not _Ready do
        Citizen.Wait(4)
    end

    CallbackModule.CreateCallback('mercy-phone/server/documents/get-by-citizenid', function(Source, Cb)
        local Player = PlayerModule.GetPlayerBySource(Source)
        DatabaseModule.Execute('SELECT * FROM player_phone_documents WHERE citizenid = ?', {
            Player.PlayerData.CitizenId
        }, function(Docs)
            Cb(Docs)
        end)
    end)

    CallbackModule.CreateCallback('mercy-phone/server/documents/new', function(Source, Cb, Data)
        -- Title, type 
        local Player = PlayerModule.GetPlayerBySource(Source)
        local DocId = GetUniqueDocumentId()
        DatabaseModule.Insert('INSERT INTO player_phone_documents (citizenid, id, title, type) VALUES (?, ?, ?, ?)', {
            Player.PlayerData.CitizenId,
            DocId,
            Data.Result.title,
            Data.Result.type,
        })
        Cb({
            title = Data.Result.title,
            type = Data.Result.type,
            content = '',
            id = DocId,
        })
    end)

    CallbackModule.CreateCallback('mercy-phone/server/documents/get-data', function(Source, Cb, Data)
        -- DocumentId
        DatabaseModule.Execute('SELECT * FROM player_phone_documents WHERE id = ?', {
            Data.DocumentId
        }, function(Docs)
            if Docs[1] ~= nil then
                Cb({
                    Success = true,
                    title = Docs[1].title,
                    content = Docs[1].content ~= nil and Docs[1].content or "",
                    id = Docs[1].id,
                })
            else
                Cb({
                    Success = false,
                    Error = "Document not found."
                })
            end
        end)
    end)
    
    CallbackModule.CreateCallback('mercy-phone/server/documents/get-by-type', function(Source, Cb, Data)
        -- Type
        local Player = PlayerModule.GetPlayerBySource(Source)
        DatabaseModule.Execute('SELECT * FROM player_phone_documents WHERE citizenid = ? AND type = ?', {
            Player.PlayerData.CitizenId,
            Data.Type
        }, function(Docs)
            Cb(Docs)
        end)
    end)

    CallbackModule.CreateCallback('mercy-phone/server/documents/save', function(Source, Cb, Data)
        -- DocumentId, Content, Title
        DatabaseModule.Execute('UPDATE player_phone_documents SET content = ?, title = ? WHERE id = ?', {
            Data.Content,
            Data.Title,
            Data.DocumentId
        }, function(Docs)
            Cb(Docs)
        end)
    end)

    CallbackModule.CreateCallback('mercy-phone/server/documents/delete', function(Source, Cb, Data)
        -- DocumentId
        DatabaseModule.Execute('DELETE FROM player_phone_documents WHERE id = ?', {
            Data.DocumentId
        }, function(Docs)
            Cb(Docs)
        end)
    end)
end)

-- [ Events ] --

RegisterNetEvent("mercy-phone/server/documents/share", function(Data)
    -- DocumentId
    local src = source
    local Player = PlayerModule.GetPlayerBySource(src)
    DatabaseModule.Execute("SELECT * FROM player_phone_documents WHERE id = ?", {Data['DocumentId']}, function(Result)
        if Result[1] ~= nil then
            local Coords = GetEntityCoords(GetPlayerPed(src))
            local Players = PlayerModule.GetPlayersInArea(src, Coords, 5.0)
            if next(Players) == nil then return print('[DEBUG]: Something went wrong, no players found.') end
            for k, v in pairs(Players) do
                if src == v['ServerId'] then goto continue end -- Can't share with self
                local TPlayer = PlayerModule.GetPlayerBySource(v['ServerId'])
                local DocId = GetUniqueDocumentId()
                DatabaseModule.Insert('INSERT INTO player_phone_documents (citizenid, id, title, type, content) VALUES (?, ?, ?, ?, ?)', {
                    TPlayer.PlayerData.CitizenId,
                    DocId,
                    Result[1].title.." (Shared)",
                    Result[1].type,
                    Result[1].content,
                })
                TriggerClientEvent('mercy-phone/client/documents/refresh', TPlayer.PlayerData.Source)
                TriggerClientEvent('mercy-phone/client/notification', TPlayer.PlayerData.Source, {
                    Id = TPlayer.PlayerData.Source,
                    Title = "New Document",
                    Message = Player.PlayerData.CharInfo.Firstname.." "..Player.PlayerData.CharInfo.Lastname.." shared a document ("..Result[1].type..") with you.",
                    Icon = "fas fa-file-alt",
                    IconBgColor = "#1e90ff",
                    IconColor = "white",
                    Sticky = false,
                    Duration = 5000,
                    Buttons = {},
                })
                ::continue::
            end
        else
            print('[DEBUG]: Document data not found..')
        end
    end)
end)

-- [ Functions ] --

function GetUniqueDocumentId()
    local Id = math.random(10000000, 99999999)
    DatabaseModule.Execute("SELECT * FROM player_phone_documents WHERE id = ?", {Id}, function(Result)
        while (Result[1] ~= nil) do
            Id = math.random(10000000, 99999999)
        end
        return Id
    end)
    return Id
end