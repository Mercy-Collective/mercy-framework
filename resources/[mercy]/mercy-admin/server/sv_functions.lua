-- [ Code ] --

-- [ Functions ] --

function onPlayerConnecting(name, setKickReason, deferrals)
    if Config.Settings['Bans']['BanCheck'] then
        local src = source
        deferrals.defer()
        Wait(0)
        deferrals.update(Lang:t('bans.checking_ban', name))
        local isBanned, Reason = IsPlayerBanned(src)
        if isBanned then
            deferrals.done(Reason)
        else
            deferrals.done()
            Wait(1000)
            TriggerEvent('connectqueue:playerConnect', name, setKickReason, deferrals)
        end
    end
end

function IsPlayerBanned(source)
    local Identifier = FunctionsModule.GetIdentifier(source, 'license') ~= nil and FunctionsModule.GetIdentifier(source, 'license') or FunctionsModule.GetIdentifier(source, 'steam')
    local BanData = MySQL.single.await('SELECT * FROM bans WHERE steam = ? or license = ?', { Identifier, Identifier })
    if not BanData then return false end
    if os.time() < BanData.expire then
        local TimeTable = os.date('*t', tonumber(BanData.expire))
        return true, Lang:t('bans.banned', {reason = BanData.reason, expires = TimeTable.day .. '/' .. TimeTable.month .. '/' .. TimeTable.year .. ' ' .. TimeTable.hour .. ':' .. TimeTable.min .. '\n'})
    else
        MySQL.query('DELETE FROM bans WHERE id = ?', { BanData.id })
    end
    return false
end

function CalculateTimeToDisplay()
    local Minute = os.date("*t").min
	if Minute <= 9 then Minute = "0" .. Minute end
    return os.date("*t").hour..':'..Minute
end

function GetPlayerFromIdentifier(Type, Identifier)
    local Retval = nil
    local Ident = Type ~= nil and Type or 'Steam'
    for _, v in pairs(PlayerModule.GetPlayers()) do
        local TPlayer = PlayerModule.GetPlayerBySource(v)
        if TPlayer.PlayerData.Identifiers[Ident] == Identifier then
            Retval = TPlayer
        end
    end
    return Retval
end

function CreateLog(Source, Type, Log, Data)
    DebugLog('Creating Log')
    local src = Source ~= nil and Source or source
    local Player = PlayerModule.GetPlayerBySource(src)
    if Player ~= nil then
        local Steam = FunctionsModule.GetIdentifier(src, "steam")
        if Steam == nil then DebugLog('Steam Identifiers not found using Player Name.') Steam = Player.PlayerData.name end
        MySQL.insert('INSERT INTO logs (Type, Steam, Log, Cid, Data) VALUES (?, ?, ?, ?, ?)', {
            Type,
            Steam,
            Log,
            Player.PlayerData.citizenid,
            Data,
        })
    end
end

function GetBanTimeCategory(Name)
    local Retval = nil
    for CatId, Cat in pairs(Config.BanTimeCategories) do
        if Cat['Name'] == Name then
            Retval = Cat
        end
    end
    return Retval
end

function CalculateLeftOverTimes(Type, Amount)
    local AmountAbove = 0
    if Type == 'Hours' then
        for i=1, Amount do
            if i > 24 then
                AmountAbove = AmountAbove + 1
            end
        end
    elseif Type == 'Minutes' then
        for i=1, Amount do
            if i > 60 then
                AmountAbove = AmountAbove + 1
            end
        end
    end
    return AmountAbove
end

function GetDateDifference(Type, Bans)
    if Type == nil then return DebugLog('No valid Type found.') end
    local FilteredBans = {}
    local CategoryBans = {}
    local Category = GetBanTimeCategory(Type)
    -- Cats
    CategoryBans['all'] = 0
    for CatId, Cat in pairs(Config.BanTimeCategories) do
        CategoryBans[Cat['Name']] = 0
    end
    DebugLog('Filtering Bans')
    -- Filter Bans
    if Bans ~= nil then
        for _, Ban in pairs(Bans) do
            -- Calculate Time
            Reference = os.time{day=Ban.BannedOn.day, year=Ban.BannedOn.year, month=Ban.BannedOn.month, hour= Ban.BannedOn.hour, min= Ban.BannedOn.min, sec=Ban.BannedOn.sec}
            DaysFrom = os.difftime(os.time(), Reference) / 86400 
            HoursFrom = os.difftime(os.time(), Reference) / 3600 
            MinsFrom = os.difftime(os.time(), Reference) % 3600 / 60
            Days = math.floor(DaysFrom)
            Hours = math.floor(HoursFrom)
            Minutes =  math.ceil(MinsFrom)
            -- Format Time
            if Hours >= 24 then 
                local LeftOverHours = CalculateLeftOverTimes('Hours', Hours)
                Days = Days + 1
                Hours = LeftOverHours
            end
            if Minutes > 59 then 
                local LeftOverMins = CalculateLeftOverTimes('Minutes', Minutes)
                Hours = Hours + 1
                Minutes = LeftOverMins
            end
            if Type ~= 'all' then
                if Category ~= nil and #Category['Times'] < 3 then
                    local FirstTime = Category['Times'][1]
                    local SecondTime = Category['Times'][2]
                    if FirstTime ~= nil and SecondTime ~= nil then 
                        -- Check Times
                        if FirstTime['Type'] == 'Days' then
                            if (SecondTime['Type'] == 'Days' and (SecondTime['Value'] > FirstTime['Value']) and (SecondTime['Value'] ~= FirstTime['Value'])) then
                                if ((Days > 0 and Days >= FirstTime['Value']) and (Days <= SecondTime['Value'])) then
                                    FilteredBans[#FilteredBans + 1] = Ban
                                    CategoryBans[Type] = CategoryBans[Type] + 1
                                end
                            end
                        elseif FirstTime['Type'] == 'Hours' then
                            if SecondTime['Type'] == 'Days' then
                                if (Days == 0 and Hours > 0 and Hours >= FirstTime['Value'] and Hours <= 23) then
                                    FilteredBans[#FilteredBans + 1] = Ban
                                    CategoryBans[Type] = CategoryBans[Type] + 1
                                elseif (Days > 0 and Days == SecondTime['Value']) then
                                    FilteredBans[#FilteredBans + 1] = Ban
                                    CategoryBans[Type] = CategoryBans[Type] + 1
                                end
                            elseif (SecondTime['Type'] == 'Hours' and (SecondTime['Value'] > FirstTime['Value']) and (SecondTime['Value'] ~= FirstTime['Value'])) then
                                if (Days == 0 and Hours > 0 and Hours >= FirstTime['Value'] and Hours <= SecondTime['Value']) then
                                    FilteredBans[#FilteredBans + 1] = Ban
                                    CategoryBans[Type] = CategoryBans[Type] + 1
                                end
                            end
                        elseif FirstTime['Type'] == 'Minutes' then
                            if SecondTime['Type'] == 'Days' then
                                if (Minutes > 0 and Minutes >= FirstTime['Value'] and Days > 0 and Days <= SecondTime['Value']) then
                                    FilteredBans[#FilteredBans + 1] = Ban
                                    CategoryBans[Type] = CategoryBans[Type] + 1
                                end
                            elseif SecondTime['Type'] == 'Hours' then
                                if (Hours == 0 and Minutes > 0 and Minutes >= FirstTime['Value'] and Minutes <= 59) then
                                    FilteredBans[#FilteredBans + 1] = Ban
                                    CategoryBans[Type] = CategoryBans[Type] + 1
                                elseif (Hours > 0 and Hours == SecondTime['Value']) then
                                    FilteredBans[#FilteredBans + 1] = Ban
                                    CategoryBans[Type] = CategoryBans[Type] + 1
                                end
                            elseif (SecondTime['Type'] == 'Minutes' and (SecondTime['Value'] > FirstTime['Value']) and (SecondTime['Value'] ~= FirstTime['Value'])) then
                                if (Minutes > 0 and Minutes >= FirstTime['Value'] and Minutes <= SecondTime['Value']) then
                                    FilteredBans[#FilteredBans + 1] = Ban
                                    CategoryBans[Type] = CategoryBans[Type] + 1
                                end
                            end
                        end
                    -- 1 Time
                    elseif FirstTime ~= nil and SecondTime == nil then
                        if FirstTime['Type'] == 'Days' then
                            if (Days > 0 and Days == FirstTime['Value']) then
                                FilteredBans[#FilteredBans + 1] = Ban
                                CategoryBans[Type] = CategoryBans[Type] + 1
                            end
                        elseif FirstTime['Type'] == 'Hours' then
                            if (Hours > 0 and Hours <= FirstTime['Value'] and Days == 0) then
                                FilteredBans[#FilteredBans + 1] = Ban
                                CategoryBans[Type] = CategoryBans[Type] + 1
                            end
                        elseif FirstTime['Type'] == 'Minutes' then
                            if (Minutes > 0 and Minutes <= FirstTime['Value'] and Days == 0) then
                                FilteredBans[#FilteredBans + 1] = Ban
                                CategoryBans[Type] = CategoryBans[Type] + 1
                            end
                        end
                    end
                end
            else
                FilteredBans[#FilteredBans + 1] = Ban
                CategoryBans['all'] = CategoryBans['all'] + 1
            end
        end
    end
    return FilteredBans, CategoryBans
end

function AdminCheck(ServerId)
    local Player = PlayerModule.GetPlayerBySource(ServerId)
    local Prom = promise:new()
    if Player ~= nil then
        local Group = PlayerModule.GetPermission(ServerId)
        if type(Group) ~= 'table' then -- Old QB
            for i=1, #Config.Settings['AdminGroups'] do
                local ConfigGroup = Config.Settings['AdminGroups'][i]
                if Group == ConfigGroup then
                    Prom:resolve(true)
                end
            end
            Prom:resolve(false)
        else -- New QB
            for Rank, Bool in pairs(Group) do
                for i=1, #Config.Settings['AdminGroups'] do
                    local ConfigGroup = Config.Settings['AdminGroups'][i]
                    if Rank == ConfigGroup and Bool then
                        Prom:resolve(true)
                    end
                end
            end
            Prom:resolve(false)
        end
    else
        Prom:resolve(false)
    end
    return Citizen.Await(Prom)
end

function GetBanTime(Expires)
    local Time = os.time()
    local Expiring = Expires == '1 Hour' and os.date("*t", Time + 3600) or
                     Expires == '6 Hours' and os.date("*t", Time + 21600) or
                     Expires == '12 Hours' and os.date("*t", Time + 43200) or
                     Expires == '1 Day' and os.date("*t", Time + 86400) or
                     Expires == '3 Days' and os.date("*t", Time + 259200) or
                     Expires == '1 Week' and os.date("*t", Time + 604800) or
                     Expires == 'Permanent' and os.date("*t", Time + 315360000)
    local ExpDate  = Expires == '1 Hour' and tonumber(Time + 3600) or
                     Expires == '6 Hours' and tonumber(Time + 21600) or
                     Expires == '12 Hours' and tonumber(Time + 43200) or
                     Expires == '1 Day' and tonumber(Time + 86400) or
                     Expires == '3 Days' and tonumber(Time + 259200) or
                     Expires == '1 Week' and tonumber(Time + 604800) or
                     Expires == 'Permanent' and tonumber(Time + 315360000)
    return Expiring, ExpDate
end

function DebugLog(Message)
    if Config.Settings['Debug'] then
        print('[DEBUG]: ', Message)
    end
end