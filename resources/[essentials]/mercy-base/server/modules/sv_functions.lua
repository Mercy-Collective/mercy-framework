UseableItems = {}

local _Ready = false
AddEventHandler('Modules/server/ready', function()
    if not _Ready then
        _Ready = true
        exports[GetCurrentResourceName()]:CreateModule("Functions", FunctionsModule)
    end
end)

FunctionsModule = {
    GetIdentifier = function(source, idtype)
        local idtype = idtype ~= nil and idtype or "steam"
        for _, identifier in pairs(GetPlayerIdentifiers(source)) do
            if string.find(identifier, idtype) then
                return identifier
            end
        end
        return nil
    end,
    GetPlayerIdentifiers = function(source)
        local Identifiers = {}
        Identifiers["ip"] = GetPlayerEndpoint(source)
        IdentifierTypes = { "steam", "discord" }
        for k, v in pairs(IdentifierTypes) do
            Identifiers[v] = FunctionsModule.GetIdentifier(source, v)
        end
        return Identifiers
    end,
    GetSource = function(identifier)
        for src, player in pairs(ServerPlayers) do
            local idens = FunctionsModule.GetPlayerIdentifiers(src)
            for _, id in pairs(idens) do
                if identifier == id then
                    return src
                end
            end
        end
        return 0
    end,
    GetTaxPrice = function(Price, Type)
        if Shared.Tax[Type] == nil then return Price end
        return math.floor(Price + ((Price / 100) * Shared.Tax[Type])) 
    end,
    ShowError = function(resource, msg)
        print("\x1b[31m["..resource..":ERROR]\x1b[0m "..msg)
    end,
    ShowSuccess = function(resource, msg)
        print("\x1b[32m["..resource..":LOG]\x1b[0m "..msg)
    end,
    CreateUseableItem = function(ItemName, cb)
        UseableItems[ItemName] = cb
    end,
    CanUseItem = function(ItemName)
        return UseableItems[ItemName] ~= nil
    end,
    UseItem = function(Source, ItemData)
        UseableItems[ItemData.ItemName](Source, ItemData)
    end,
    Kick = function(source, Reason, setKickReason, deferrals)
        local src = source
        reason = "\n"..Reason
        if(setKickReason ~=nil) then
            setKickReason(Reason)
        end
        Citizen.CreateThread(function()
            if(deferrals ~= nil)then
                deferrals.update(Reason)
                Citizen.Wait(2500)
            end
            if src ~= nil then
                DropPlayer(src, Reason)
            end
            local i = 0
            while (i <= 4) do
                i = i + 1
                while true do
                    if src ~= nil then
                        if(GetPlayerPing(src) >= 0) then
                            break
                        end
                        Citizen.Wait(100)
                        Citizen.CreateThread(function() 
                            DropPlayer(src, Reason)
                        end)
                    end
                end
                Citizen.Wait(5000)
            end
        end)
    end,
    IsPlayerBanned = function(Source)
        local DatabaseModule = exports[GetCurrentResourceName()]:FetchModule('Database')
        local IsBanned, Message = nil, nil
        DatabaseModule.Execute("SELECT * FROM bans WHERE steam = ? OR license = ?", {
            GetPlayerIdentifiers(Source)[1],
            GetPlayerIdentifiers(Source)[2],
        }, function(BanResult)
            if BanResult ~= nil and BanResult[1] ~= nil then
                Message = "\n🔰 You are banned from the server. \n🛑 Reason: " ..BanResult[1].reason.. '\n🛑 Banned By: ' ..BanResult[1].bannedby.. '\n\n If you think this is a mistake, open at ticket on the Discord.'
                IsBanned = true
            else
                IsBanned = false
            end
        end, true)
        return IsBanned, Message
    end,
}