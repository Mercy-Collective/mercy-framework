local FrozenPlayers, GodmodeEnabled, CloakEnabled, StaminaEnabled, AmmoEnabled = {}, {}, {}, {}, {}

CallbackModule, PlayerModule, FunctionsModule, CommandsModule, DatabaseModule, EventsModule = nil, nil, nil, nil, nil, nil
local BlipsEnabled = {}

local _Ready = false
AddEventHandler('Modules/server/ready', function()
    TriggerEvent('Modules/server/request-dependencies', {
        'Callback',
        'Player',
        'Functions',
        'Commands',
        'Database',
        'Events',
    }, function(Succeeded)
        if not Succeeded then return end
        CallbackModule = exports['mercy-base']:FetchModule('Callback')
        PlayerModule = exports['mercy-base']:FetchModule('Player')
        FunctionsModule = exports['mercy-base']:FetchModule('Functions')
        CommandsModule = exports['mercy-base']:FetchModule('Commands')
        DatabaseModule = exports['mercy-base']:FetchModule('Database')
        EventsModule = exports['mercy-base']:FetchModule('Events')
        _Ready = true
    end)
end)

-- [ Code ] --

Citizen.CreateThread(function() 
    while not _Ready do 
        Citizen.Wait(4) 
    end 

    -- [ Commands ] --

    CommandsModule.Add({"sv", "car"}, "Spawn vehicle", {}, false, function(source, args)
        local VehModel = args[1]
        TriggerClientEvent('mercy-base/client/spawn-vehicle', source, VehModel)
    end, 'admin')

    CommandsModule.Add({"dv", "delveh"}, "Delete vehicle", {}, false, function(source, args)
        TriggerClientEvent('mercy-base/client/delete-vehicle', source)
    end, 'admin')

    CommandsModule.Add({"fix", "fixveh"}, "Fix vehicle", {}, false, function(source, args)
        TriggerClientEvent('mercy-base/client/repair-vehicle', source)
    end, 'admin')

    CommandsModule.Add(Config.Commands['MenuOpen'], Lang:t("info.keymapping_desc"), {}, false, function(source)
        TriggerClientEvent('mc-admin/client/try-open-menu', source, true)
    end, 'admin')

    CommandsModule.Add(Config.Commands['MenuDebug'], Lang:t("info.menu_debug"), {}, false, function(source)
        TriggerClientEvent('mc-admin/client/toggle-debug', source, false)
    end, 'god')

    CommandsModule.Add(Config.Commands['MenuReset'], Lang:t("info.reset_data"), {}, false, function(source)
        TriggerClientEvent('mc-admin/client/reset-menu', -1, false)
    end, 'god')

    CommandsModule.Add(Config.Commands['MenuPerms'], Lang:t("info.menu_perms"), {{Name = "action", Help = Lang:t('info.perm_action')}, {Name = "commandid", Help = Lang:t('info.commandid')}, {Name = "group", Help = Lang:t('info.rankid')}}, false, function(source, args)
        local Action = args[1]:lower()
        local CommandId = args[2]
        local Group = args[3] ~= nil and args[3]:lower() or false
        local Player = PlayerModule.GetPlayerBySource(source)
        if Action ~= 'add' and Action ~= 'remove' and Action ~= 'list' then
            return Player.Functions.Notify('invalid-action', Lang:t('info.invalid_action'), 'error')
        end
        TriggerClientEvent('mc-admin/client/do-perms-action', source, Action, CommandId, Group)
    end, 'god')

    CommandsModule.Add(Config.Commands['ReportNew'], Lang:t("info.send_report"), {{Name = "message", Help = Lang:t('info.message')}}, false, function(source, args)
        local Player = PlayerModule.GetPlayerBySource(source)
        local Message = table.concat(args, ' ')
        if Message ~= nil then
            local ReportData = {
                ['Id'] = math.random(111111, 999999),
                ['ServerId'] = source,
                ['Chats'] = {
                    {
                        ['Message'] = Message,
                        ['Time'] = CalculateTimeToDisplay(),
                        ['Sender'] = Player.PlayerData.Name,
                    }
                },
            }
            TriggerClientEvent('mc-admin/client/send-report', source, ReportData)
        end
    end)

    CommandsModule.Add(Config.Commands['ReportChat'], Lang:t("info.reply_report"), {{Name = "message", Help = Lang:t('info.message')}}, false, function(source, args)
        local Message = table.concat(args, ' ')
        if Message ~= nil then
            TriggerClientEvent('mc-admin/client/reply-report', source, Message, CalculateTimeToDisplay())
        end
    end)

    CommandsModule.Add(Config.Commands['ReportClose'], Lang:t("info.close_report"), {}, false, function(source, args)
        TriggerClientEvent('mc-admin/client/close-report', source)
    end)

    -- [ Console ] --

    RegisterCommand('setpermission', function(source, args, rawCommand)
        if source == 0 then
            local ServerId = tonumber(args[1])
            local Group = args[2] ~= nil and args[2]:lower() or false
            if ServerId and Group then
                if Shared.Groups[Group] then
                    local Name = GetPlayerName(ServerId)
                    PlayerModule.SetPermission(ServerId, Group)
                    print('Set permission group for '..Name..' ('..ServerId..') to '..Group)
                else
                    print('Invalid group')
                end
            else
                print('SYNTAX: setpermission [serverid] [group]')
            end
        end
    end, false)

    RegisterCommand('refreshpermissions', function(source, args, rawCommand)
        if source == 0 then
            local ServerId = tonumber(args[1])
            if ServerId then
                PlayerModule.RefreshPermissions(ServerId)
                local Name = GetPlayerName(ServerId)
                print('Refreshed permissions for '..Name..' ('..ServerId..')')
            else
                print('SYNTAX: refreshpermissions [serverid]')
            end
        end
    end, false)

    RegisterCommand(Config.Commands['APKick'], function(source, args, rawCommand)
        if source == 0 then
            local ServerId = tonumber(args[1])
            table.remove(args, 1)
            local Msg = table.concat(args, " ")
            DropPlayer(ServerId, Lang:t('info.kicked', {reason = Msg}))
        end
    end, false)

    RegisterCommand(Config.Commands['APAddItem'], function(source, args, rawCommand)
        if source == 0 then
            local ServerId, ItemName, ItemAmount = tonumber(args[1]), tostring(args[2]), tonumber(args[3])
            local Player = PlayerModule.GetPlayerBySource(ServerId)
            if Player ~= nil then
                Player.Functions.AddItem(ItemName, ItemAmount, false, false)
                print(Lang:t('info.gaveitem', {amount = ItemAmount, name = ItemName}))
            end
        end
    end, false)

    RegisterCommand(Config.Commands['APAddMoney'], function(source, args, rawCommand)
        if source == 0 then
            local ServerId, Amount = tonumber(args[1]), tonumber(args[2])
            local Player = PlayerModule.GetPlayerBySource(ServerId)
            if Player ~= nil then
                Player.Functions.AddMoney('Cash', Amount)
                print(Lang:t('info.gavemoney', {amount = Amount, moneytype = 'Cash'}))
            end
        end
    end, false)

    RegisterCommand(Config.Commands['APSetJob'], function(source, args, rawCommand)
        if source == 0 then
            local ServerId, JobName, Grade = tonumber(args[1]), tostring(args[2]), tonumber(args[3])
            local Player = PlayerModule.GetPlayerBySource(ServerId)
            if Player ~= nil then
                Player.Functions.SetJob(JobName, Grade)
                print(Lang:t('info.setjob', {jobname = JobName}))
            end
        end
    end, false)

    RegisterCommand(Config.Commands['APRevive'], function(source, args, rawCommand)
        if source == 0 then
            local ServerId = tonumber(args[1])
            TriggerClientEvent('hospital:client:Revive', ServerId, true)
            print(Lang:t('info.gave_revive'))
        end
    end, false)
        
    -- [ Callbacks ] --

    CallbackModule.CreateCallback('mc-adminmenu/server/get-permission', function(Source, Cb)
        local Group = PlayerModule.GetPermission(Source)
        Cb(Group)
    end)

    CallbackModule.CreateCallback('mc-adminmenu/server/get-convar', function(source, Cb, ConvarName)
        Cb(GetConvar(ConvarName, 'none'))
    end)

    CallbackModule.CreateCallback('mc-admin/server/get-active-players-in-radius', function(Source, Cb, Coords, Radius)
        local Coords, Radius = Coords ~= nil and vector3(Coords.x, Coords.y, Coords.z) or GetEntityCoords(GetPlayerPed(Source)), Radius ~= nil and Radius or 5.0
        local ActivePlayers = {}
        for k, v in pairs(PlayerModule.GetPlayers()) do
            local TargetCoords = GetEntityCoords(GetPlayerPed(v))
            local TargetDistance = #(TargetCoords - Coords)
            if TargetDistance <= Radius then
                ActivePlayers[#ActivePlayers + 1] = {
                    ['ServerId'] = v,
                    ['Name'] = GetPlayerName(v)
                }
            end
        end
        Cb(ActivePlayers)
    end)

    CallbackModule.CreateCallback('mc-admin/server/get-bans', function(source, Cb)
        local BanList = {}
        local BansData = MySQL.Sync.fetchAll('SELECT * FROM bans', {})
        if BansData and BansData[1] ~= nil then
            for k, v in pairs(BansData) do
                BanList[#BanList + 1] = {
                    Text = v.name.." ("..v.banid..")",
                    BanId = v.banid,
                    Name = v.name,
                    Reason = v.reason,
                    Expires = os.date('*t', tonumber(v.expire)),
                    BannedOn = os.date('*t', tonumber(v.bannedon)),
                    BannedOnN = v.bannedon,
                    BannedBy = v.bannedby,
                    License = v.license ~= "Unknown" and v.license or v.steam,
                    Discord = v.discord,
                }
            end
        end
        Cb(BanList)
    end)

    CallbackModule.CreateCallback('mc-admin/server/get-logs', function(source, Cb)
        local LogsList = {}
        local LogsData = MySQL.query.await('SELECT * FROM logs', {})
        if LogsData and LogsData[1] ~= nil then
            for k, v in pairs(LogsData) do
                LogsList[#LogsList + 1] = {
                    Type = v.Type ~= nil and v.Type or "Unknown",
                    Steam = v.Steam ~= nil and v.Steam  or "Unknown",
                    Desc = v.Log ~= nil and v.Log or "Unknown",
                    Date = v.Date ~= nil and v.Date or "Unknown",
                    Cid = v.Cid ~= nil and v.Cid or "Unknown",
                    Data = v.Data ~= nil and v.Data or "Unknown",
                }
            end
        end
        Cb(LogsList)
    end)
    
    CallbackModule.CreateCallback('mc-admin/server/get-players', function(source, Cb)
        local PlayerList = {}
        for i=1, #PlayerModule.GetPlayers() do
            local Player = PlayerModule.GetPlayers()[i]
            local Steam = FunctionsModule.GetIdentifier(Player, "steam")
            local License = FunctionsModule.GetIdentifier(Player, "license")
            PlayerList[#PlayerList + 1] = {
                ServerId = Player,
                Name = GetPlayerName(Player),
                Steam = Steam ~= nil and Steam or 'Not Found',
                License = License  ~= nil and License or Steam
            }
        end
        Cb(PlayerList)
    end)

    CallbackModule.CreateCallback('mc-admin/server/get-player-data', function(source, Cb, Identifier)
        local PlayerInfo = {}
        local TPlayer = nil
        if string.match(Identifier, "license:") then
            TPlayer = GetPlayerFromIdentifier('license', Identifier)
        elseif string.match(Identifier, "steam:") then
            TPlayer = GetPlayerFromIdentifier('steam', Identifier)
        end

        if TPlayer ~= nil then
            local Steam = FunctionsModule.GetIdentifier(TPlayer.PlayerData.Source, "steam")
            PlayerInfo = {
                Name = TPlayer.PlayerData.Name,
                Steam = Steam ~= nil and Steam or 'Not found',
                CharName = TPlayer.PlayerData.CharInfo.Firstname..' '..TPlayer.PlayerData.CharInfo.Lastname,
                Source = TPlayer.PlayerData.Source,
                CitizenId = TPlayer.PlayerData.CitizenId
            }
            Cb(PlayerInfo)
        else
            Cb(false)
        end
    end)

    CallbackModule.CreateCallback('mc-admin/server/get-date-difference', function(source, Cb, Bans, Type)
        local FilteredBans, BanAmount = GetDateDifference(Type, Bans) 
        Cb(FilteredBans, BanAmount)
    end)

    CallbackModule.CreateCallback("mc-admin/server/create-log", function(source, Cb, Type, Log, Data)
        if Type == nil or Log == nil then return end
        CreateLog(source, Type, Log, Data)
    end)

    CallbackModule.CreateCallback("mc-admin/server/get-spectate-data", function(Source, Cb, TargetSource)
        local Player = PlayerModule.GetPlayerBySource(TargetSource)
        if Player then
            local SpectateData = {
                ServerId = Player.PlayerData.Source,
                x = GetEntityCoords(GetPlayerPed(Player.PlayerData.Source)).x,
                y = GetEntityCoords(GetPlayerPed(Player.PlayerData.Source)).y,
                z = GetEntityCoords(GetPlayerPed(Player.PlayerData.Source)).z
            }
            Cb(SpectateData)
        else
            Cb(nil)
        end
    end)

end)

-- [ Events ] --

AddEventHandler('playerConnecting', onPlayerConnecting)

-- User Commands

RegisterNetEvent("mc-admin/server/unban-player", function(BanId)
    local src = source
    if not AdminCheck(src) then return end

    local Player = PlayerModule.GetPlayerBySource(src)
    local BanData = MySQL.query.await('SELECT * FROM bans WHERE banid = ?', {BanId})
    if BanData and BanData[1] ~= nil then
        MySQL.query('DELETE FROM bans WHERE banid = ?', {BanId})
        Player.Functions.Notify('unbanned-success', Lang:t('bans.unbanned'), 'success')
    else
        Player.Functions.Notify('unbanned-fail', Lang:t('bans.not_banned'), 'success')
    end
end)

RegisterNetEvent("mc-admin/server/ban-player", function(ServerId, Expires, Reason)
    local src = source
    if not AdminCheck(src) then return end

    local Player = PlayerModule.GetPlayerBySource(src)
    local Identifier = FunctionsModule.GetIdentifier(ServerId, 'license') ~= nil and FunctionsModule.GetIdentifier(ServerId, 'license') or FunctionsModule.GetIdentifier(ServerId, 'steam')
    if Identifier == nil then
        Player.Functions.Notify('ban-fail', "Identifiers of player not found..", 'error')
        return
    end
    
    local BanData = MySQL.query.await('SELECT * FROM bans WHERE steam = ? or license = ?', {Identifier, Identifier})
    if BanData and BanData[1] ~= nil then
        Player.Functions.Notify('already-banned', Lang:t('bans.already_banned', {player = GetPlayerName(ServerId), reason = BanData[1].reason}), 'error')
    else
        local Expiring, ExpireDate = GetBanTime(Expires)
        local Time = os.time()
        local BanId = "BAN-"..math.random(111111111, 999999999)
        MySQL.insert('INSERT INTO bans (banid, name, steam, license, discord, ip, reason, bannedby, expire, bannedon) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', {
            BanId,
            GetPlayerName(ServerId),
            FunctionsModule.GetIdentifier(ServerId, 'steam') ~= nil and FunctionsModule.GetIdentifier(ServerId, 'steam') or "Unknown",
            FunctionsModule.GetIdentifier(ServerId, 'license') ~= nil and FunctionsModule.GetIdentifier(ServerId, 'license') or "Unknown",
            FunctionsModule.GetIdentifier(ServerId, 'discord') ~= nil and FunctionsModule.GetIdentifier(ServerId, 'discord') or "Unknown",
            FunctionsModule.GetIdentifier(ServerId, 'ip') ~= nil and FunctionsModule.GetIdentifier(ServerId, 'ip') or "Unknown",
            Reason,
            GetPlayerName(src),
            ExpireDate,
            Time,
        })
        Player.Functions.Notify('banned-success', Lang:t('bans.success_banned', {player = GetPlayerName(ServerId), reason = Reason}), 'success')
        local ExpireHours = tonumber(Expiring['hour']) < 10 and "0"..Expiring['hour'] or Expiring['hour']
        local ExpireMinutes = tonumber(Expiring['min']) < 10 and "0"..Expiring['min'] or Expiring['min']
        local ExpiringDate = Expiring['day'] .. '/' .. Expiring['month'] .. '/' .. Expiring['year'] .. ' | '..ExpireHours..':'..ExpireMinutes
        if Expires == "Permanent" then
            DropPlayer(ServerId,  Lang:t('bans.perm_banned', {reason = Reason}))
        else
            DropPlayer(ServerId, Lang:t('bans.banned', {reason = Reason, expires = ExpiringDate}))
        end
    end
end)

RegisterNetEvent("mc-admin/server/kick-all-players", function(Reason)
    local src = source
    if not AdminCheck(src) then return end
    for k, v in pairs(PlayerModule.GetPlayers()) do
        local Player = PlayerModule.GetPlayerBySource(v)
        if Player ~= nil then 
            DropPlayer(Player.PlayerData.Source, Reason)
        end
    end
end)

RegisterNetEvent("mc-admin/server/kick-player", function(ServerId, Reason)
    local src = source
    if not AdminCheck(src) then return end
    ServerId = tonumber(ServerId)
    local PlayerSource = ServerId ~= nil and ServerId or src

    local Player = PlayerModule.GetPlayerBySource(src)

    DropPlayer(PlayerSource, Reason)
    Player.Functions.Notify('kicked', Lang:t('info.kicked'), 'success')
end)

RegisterNetEvent("mc-admin/server/set-money", function(ServerId, MoneyType, MoneyAmount)
    local src = source
    if not AdminCheck(src) then return end
    ServerId = tonumber(ServerId)
    local PlayerSource = ServerId ~= nil and ServerId or src

    local TPlayer = PlayerModule.GetPlayerBySource(PlayerSource)
    if not TPlayer then return print('Error: User not found to set money.') end

    TPlayer.Functions.SetMoney(MoneyType, MoneyAmount, 'Admin-Menu-Set-Money')
end)


RegisterNetEvent("mc-admin/server/give-money", function(ServerId, MoneyType, MoneyAmount)
    local src = source
    if not AdminCheck(src) then return end
    ServerId = tonumber(ServerId)
    MoneyAmount = tonumber(MoneyAmount)
    local PlayerSource = ServerId ~= nil and ServerId or src

    local TPlayer = PlayerModule.GetPlayerBySource(PlayerSource)
    if not TPlayer then return print('Error: User not found to give money.') end

    TPlayer.Functions.AddMoney(MoneyType, MoneyAmount, 'Admin-Menu-Give-Money')
end)

RegisterNetEvent("mc-admin/server/give-item", function(ServerId, ItemName, ItemAmount)
    local src = source
    if not AdminCheck(src) then return end
    ServerId = tonumber(ServerId)
    local PlayerSource = ServerId ~= nil and ServerId or src

    local TPlayer = PlayerModule.GetPlayerBySource(PlayerSource)
    if not TPlayer then return print('Error: User not found to give item.') end

    TPlayer.Functions.AddItem(ItemName, ItemAmount, 'Admin-Menu-Give')
    TPlayer.Functions.Notify('item-given', Lang:t('info.gaveitem', {amount = ItemAmount, name = ItemName}), 'success')
end)

RegisterNetEvent("mc-admin/server/request-job", function(ServerId, JobName)
    local src = source
    if not AdminCheck(src) then return end
    ServerId = tonumber(ServerId)
    local PlayerSource = ServerId ~= nil and ServerId or src

    local TPlayer = PlayerModule.GetPlayerBySource(PlayerSource)
    TPlayer.Functions.SetJob(JobName, 1, 'Admin-Menu-Give-Job')
    TPlayer.Functions.Notify('job-given', Lang:t('info.setjob', {jobname = JobName}), 'success')
end)

RegisterNetEvent("mc-admin/server/drunk", function(ServerId)
    local src = source
    if not AdminCheck(src) then return end
    ServerId = tonumber(ServerId)
    local PlayerSource = ServerId ~= nil and ServerId or src

    TriggerClientEvent('mc-admin/client/drunk', PlayerSource)
end)

RegisterNetEvent("mc-admin/server/animal-attack", function(ServerId)
    local src = source
    if not AdminCheck(src) then return end
    ServerId = tonumber(ServerId)
    local PlayerSource = ServerId ~= nil and ServerId or src

    TriggerClientEvent('mc-admin/client/animal-attack', PlayerSource)
end)

RegisterNetEvent("mc-admin/server/set-fire", function(ServerId)
    local src = source
    if not AdminCheck(src) then return end
    ServerId = tonumber(ServerId)
    local PlayerSource = ServerId ~= nil and ServerId or src

    TriggerClientEvent('mc-admin/client/set-fire', PlayerSource)
end)

RegisterNetEvent("mc-admin/server/fling-player", function(ServerId)
    local src = source
    if not AdminCheck(src) then return end
    ServerId = tonumber(ServerId)
    local PlayerSource = ServerId ~= nil and ServerId or src

    TriggerClientEvent('mc-admin/client/fling-player', PlayerSource)
end)

RegisterNetEvent("mc-admin/server/play-sound", function(ServerId, SoundId)
    local src = source
    if not AdminCheck(src) then return end
    ServerId = tonumber(ServerId)
    local PlayerSource = ServerId ~= nil and ServerId or src

    TriggerClientEvent('mc-admin/client/play-sound', PlayerSource, SoundId)
end)

-- Utility Commands

RegisterNetEvent('mc-admin/server/get-player-blips', function()
    local src = source
    if not AdminCheck(src) then return end

    local BlipData = {}
    for k, v in pairs(PlayerModule.GetPlayers()) do
        BlipData[#BlipData + 1] = {
            ServerId = v,
            Name = GetPlayerName(v),
            Coords = GetEntityCoords(GetPlayerPed(v)),
        }
    end
    TriggerClientEvent('mc-admin/client/show', src, BlipData)
end)


RegisterNetEvent("mc-admin/server/teleport-all", function()
    local src = source
    if not AdminCheck(src) then return end
    
    local SourcePlayer = PlayerModule.GetPlayerBySource(src)
    for k, v in pairs(PlayerModule.GetPlayers()) do
        local TPlayer = PlayerModule.GetPlayerBySource(v)
        if SourcePlayer ~= nil and TPlayer ~= nil then 
            if SourcePlayer.PlayerData.CitizenId ~= TPlayer.PlayerData.CitizenId then
                local SourceCoords = GetEntityCoords(GetPlayerPed(src))
                TriggerClientEvent('mc-admin/client/teleport-player', v, SourceCoords)
            end
        end
    end
end)

RegisterNetEvent("mc-admin/server/teleport-player", function(ServerId, Type)
    local src = source
    if not AdminCheck(src) then return end
    ServerId = tonumber(ServerId)
    local PlayerSource = ServerId ~= nil and ServerId or src

    local Player = PlayerModule.GetPlayerBySource(PlayerSource)
    if not Player then return print('Error: User not found to teleport.') end

    local Msg = ""
    if Type == 'Goto' then
        Msg = Lang:t('info.teleported_to') 
        local TCoords = GetEntityCoords(GetPlayerPed(PlayerSource))
        TriggerClientEvent('mc-admin/client/teleport-player', src, TCoords)
    elseif Type == 'Bring' then
        Msg = Lang:t('info.teleported_brought')
        local Coords = GetEntityCoords(GetPlayerPed(src))
        TriggerClientEvent('mc-admin/client/teleport-player', PlayerSource, Coords)
    end
    Player.Functions.Notify('teleported', Lang:t('info.teleported', {tpmsg = Msg}), 'success')
end)

RegisterNetEvent("mc-admin/server/chat-say", function(Message)
    TriggerClientEvent('mercy-chat/client/post-message', -1, Lang:t('info.announcement'), Message, "normal")
end)

-- Player Commands

-- Change this if needed changes
RegisterNetEvent("mc-admin/server/set-environment", function(Weather, Hour, Minute)
    local src = source
    if not AdminCheck(src) then return end
    Hour, Minute = tonumber(Hour), tonumber(Minute)

    local Player = PlayerModule.GetPlayerBySource(src)
    if Weather ~= nil then
        local UpdatedWeather = exports['mercy-weathersync']:SetWeather(Weather:upper())
        if UpdatedWeather ~= nil and UpdatedWeather then
            Player.Functions.Notify('weather-changed', Lang:t('info.set_weather', {weather = Weather}), 'success')
        else
            DebugLog('Could not set weather, is the export valid? server/sv_main.lua line 380')
        end
    end
    if Hour ~= nil and Minute ~= nil then
        local UpdatedTime = exports['mercy-weathersync']:SetTime(Hour, Minute)
        if UpdatedTime ~= nil and UpdatedTime then
            Player.Functions.Notify('time-changed', Lang:t('info.set_time', {time = Hour..":"..Minute}), 'success')
        else
            DebugLog('Could not set time, is the export valid? server/sv_main.lua line 388')
        end
    end
end)

RegisterNetEvent("mc-admin/server/open-bennys", function(ServerId)
    local src = source
    if not AdminCheck(src) then return end
    ServerId = tonumber(ServerId)
    local PlayerSource = ServerId ~= nil and ServerId or src

    TriggerClientEvent('mercy-bennys/client/open-bennys', PlayerSource, true)
end)

RegisterNetEvent("mc-admin/server/set-permissions", function(ServerId, Permission)
    local src = source
    if not AdminCheck(src) then return end
    ServerId = tonumber(ServerId)
    local PlayerSource = ServerId ~= nil and ServerId or src
    local Player = PlayerModule.GetPlayerBySource(PlayerSource)
    if not Player then return end

    PlayerModule.SetPermission(PlayerSource, Permission)
    Player.Functions.Notify('set-perm', 'You successfully set the permission group of '..Player.PlayerData.Name..' to '..Permission..'!', 'success')
end)

RegisterNetEvent("mc-admin/server/refresh-permissions", function(ServerId)
    local src = source
    if not AdminCheck(src) then return end
    ServerId = tonumber(ServerId)
    local PlayerSource = ServerId ~= nil and ServerId or src
    local Player = PlayerModule.GetPlayerBySource(PlayerSource)
    if not Player then return end

    PlayerModule.RefreshPermissions(PlayerSource)
    Player.Functions.Notify('set-perm', 'You successfully refreshed all permissions!', 'success')
end)


RegisterNetEvent("mc-admin/server/kill", function(ServerId)
    local src = source
    if not AdminCheck(src) then return end
    ServerId = tonumber(ServerId)
    local PlayerSource = ServerId ~= nil and ServerId or src

    TriggerClientEvent('mercy-hospital/client/kill-player', PlayerSource)
end)

RegisterNetEvent("mc-admin/server/delete-area", function(Type, Radius)
    local src = source
    if not AdminCheck(src) then return end

    TriggerClientEvent('mc-admin/client/delete-area', src, Type, Radius)
end)

RegisterNetEvent("mc-admin/server/freeze-player", function(ServerId)
    local src = source
    if not AdminCheck(src) then return end
    ServerId = tonumber(ServerId)
    local PlayerSource = ServerId ~= nil and ServerId or src

    local Player = PlayerModule.GetPlayerBySource(src)
    local TPlayer = PlayerModule.GetPlayerBySource(PlayerSource)
    if not TPlayer then return print('Error: User not found to freeze.') end

    local PData = TPlayer.PlayerData
    FrozenPlayers[PData.CitizenId] = not FrozenPlayers[PData.CitizenId]
    local Msg = FrozenPlayers[PData.CitizenId] and Lang:t("info.gave_freeze", {frozenmsg =  Lang:t('commands.frozen')}) or Lang:t("info.gave_freeze", {frozenmsg =  Lang:t('commands.unfrozen')})
    Player.Functions.Notify('frozen-toggled', Msg, FrozenPlayers[PData.CitizenId] and 'success' or 'error')
    TriggerClientEvent('mc-admin/client/freeze-player', PlayerSource, FrozenPlayers[PData.CitizenId])
end)

RegisterNetEvent("mc-admin/server/toggle-infinite-ammo", function(ServerId)
    local src = source
    if not AdminCheck(src) then return end
    ServerId = tonumber(ServerId)
    local PlayerSource = ServerId ~= nil and ServerId or src

    local Player = PlayerModule.GetPlayerBySource(src)
    local TPlayer = PlayerModule.GetPlayerBySource(PlayerSource)
    if not TPlayer then return print('Error: User not found to toggle infinite ammo for.') end

    local PData = TPlayer.PlayerData
    AmmoEnabled[PData.CitizenId] = not AmmoEnabled[PData.CitizenId]
    local Msg = AmmoEnabled[PData.CitizenId] and Lang:t("commands.enabled") or Lang:t("commands.disabled")
    Player.Functions.Notify('infinite-ammo', 'Infinite Ammo '..Msg, AmmoEnabled[PData.CitizenId] and 'success' or 'error')
    TriggerClientEvent('mc-admin/client/toggle-infinite-ammo', PlayerSource, AmmoEnabled[PData.CitizenId])
end)

RegisterNetEvent("mc-admin/server/toggle-infinite-stamina", function(ServerId)
    local src = source
    if not AdminCheck(src) then return end
    ServerId = tonumber(ServerId)
    local PlayerSource = ServerId ~= nil and ServerId or src

    local Player = PlayerModule.GetPlayerBySource(src)
    local TPlayer = PlayerModule.GetPlayerBySource(PlayerSource)
    if not TPlayer then return print('Error: User not found to toggle infinite stamina for.') end

    local PData = TPlayer.PlayerData
    StaminaEnabled[PData.CitizenId] = not StaminaEnabled[PData.CitizenId]
    local Msg = StaminaEnabled[PData.CitizenId] and Lang:t("commands.enabled") or Lang:t("commands.disabled")
    Player.Functions.Notify('infinite-stamina', 'Infinite Stamina '..Msg, StaminaEnabled[PData.CitizenId] and 'success' or 'error')
    TriggerClientEvent('mc-admin/client/toggle-infinite-stamina', PlayerSource, StaminaEnabled[PData.CitizenId])
end)

RegisterNetEvent("mc-admin/server/toggle-cloak", function(ServerId)
    local src = source
    if not AdminCheck(src) then return end
    ServerId = tonumber(ServerId)
    local PlayerSource = ServerId ~= nil and ServerId or src

    local Player = PlayerModule.GetPlayerBySource(src)
    local TPlayer = PlayerModule.GetPlayerBySource(PlayerSource)
    if not TPlayer then return print('Error: User not found to cloak for.') end

    local PData = TPlayer.PlayerData
    CloakEnabled[PData.CitizenId] = not CloakEnabled[PData.CitizenId]
    local Msg = CloakEnabled[PData.CitizenId] and Lang:t("commands.enabled") or Lang:t("commands.disabled")
    Player.Functions.Notify('cloak-toggled', 'Cloak '..Msg, CloakEnabled[PData.CitizenId] and 'success' or 'error')
    TriggerClientEvent('mc-admin/client/toggle-cloak', PlayerSource, CloakEnabled[PData.CitizenId])
end)

RegisterNetEvent("mc-admin/server/toggle-godmode", function(ServerId)
    local src = source
    if not AdminCheck(src) then return end
    ServerId = tonumber(ServerId)
    local PlayerSource = ServerId ~= nil and ServerId or src

    local Player = PlayerModule.GetPlayerBySource(src)
    local TPlayer = PlayerModule.GetPlayerBySource(PlayerSource)
    if not TPlayer then return print('Error: User not found to toggle godmode for.') end

    local PData = TPlayer.PlayerData
    GodmodeEnabled[PData.CitizenId] = not GodmodeEnabled[PData.CitizenId]
    local Msg = GodmodeEnabled[PData.CitizenId] and Lang:t('commands.enabled') or Lang:t('commands.disabled')
    local MsgType = GodmodeEnabled[PData.CitizenId] and 'success' or 'error'
    Player.Functions.Notify('godmode-toggled', 'Godmode '..Msg, MsgType)
    TriggerClientEvent('mc-admin/client/toggle-godmode', PlayerSource, GodmodeEnabled[PData.CitizenId])
end)

RegisterNetEvent("mc-admin/server/set-food-drink", function(ServerId)
    local src = source
    if not AdminCheck(src) then return end
    ServerId = tonumber(ServerId)
    local PlayerSource = ServerId ~= nil and ServerId or src

    local Player = PlayerModule.GetPlayerBySource(src)
    local TPlayer = PlayerModule.GetPlayerBySource(PlayerSource)
    if not TPlayer then return print('Error: User not found to set food and drinks for.') end

    TPlayer.Functions.SetMetaData("Food", 100)
    TPlayer.Functions.SetMetaData("Water", 100)
    Player.Functions.Notify('gave-needs', Lang:t('info.gave_needs'), 'success')
end)

RegisterNetEvent("mc-admin/server/remove-stress", function(ServerId)
    local src = source
    if not AdminCheck(src) then return end
    ServerId = tonumber(ServerId)
    local PlayerSource = ServerId ~= nil and ServerId or src

    local Player = PlayerModule.GetPlayerBySource(src)
    local TPlayer = PlayerModule.GetPlayerBySource(PlayerSource)
    if not TPlayer then return print('Error: User not found to remove stress for.') end

    TPlayer.Functions.SetMetaData('Stress', 0)
    Player.Functions.Notify('removed-stress', Lang:t('info.removed_stress'), 'success')
end)

RegisterNetEvent("mc-admin/server/set-armor", function(ServerId)
    local src = source
    if not AdminCheck(src) then return end
    ServerId = tonumber(ServerId)
    local PlayerSource = ServerId ~= nil and ServerId or src

    local Player = PlayerModule.GetPlayerBySource(src)
    local TPlayer = PlayerModule.GetPlayerBySource(PlayerSource)
    if not TPlayer then return print('Error: User not found to give armor.') end

    SetPedArmour(GetPlayerPed(PlayerSource), 100)
    Player.Functions.Notify('gave-armor', Lang:t('info.gave_armor'), 'success')
end)

RegisterNetEvent("mc-admin/server/reset-skin", function(ServerId)
    local src = source
    if not AdminCheck(src) then return end
    ServerId = tonumber(ServerId)
    local PlayerSource = ServerId ~= nil and ServerId or src

    local Player = PlayerModule.GetPlayerBySource(PlayerSource)
    if Player then
        DatabaseModule.Execute('SELECT * FROM player_skins WHERE citizenid = ?', {Player.PlayerData.CitizenId}, function(SkinResult)
            if SkinResult[1] ~= nil then
                TriggerClientEvent("mc-clothing/client/load-skin", Player.PlayerData.Source, SkinResult[1].model, json.decode(SkinResult[1].skin), json.decode(SkinResult[1].tatoos))
            else
                TriggerClientEvent("mc-clothing/client/load-skin", Player.PlayerData.Source)
            end
        end)
    end
end)

RegisterNetEvent("mc-admin/server/set-model", function(ServerId, Model)
    local src = source
    if not AdminCheck(src) then return end
    ServerId = tonumber(ServerId)
    local PlayerSource = ServerId ~= nil and ServerId or src

    TriggerClientEvent('mc-admin/client/set-model', PlayerSource, Model)
end)

RegisterNetEvent("mc-admin/server/revive-all", function()
    local src = source
    if not AdminCheck(src) then return end

    for k, v in pairs(PlayerModule.GetPlayers()) do
		local Player = PlayerModule.GetPlayerBySource(v)
		if Player ~= nil then
            Player.Functions.SetMetaData("Food", 100)
            Player.Functions.SetMetaData("Water", 100)
            Player.Functions.SetMetaData("Stress", 0)
            TriggerClientEvent('mercy-hospital/client/revive', v, true)
		end
	end
end)

RegisterNetEvent("mc-admin/server/revive-in-distance", function(Radius)
    local src = source
    if not AdminCheck(src) then return end

    local Coords, Radius = GetEntityCoords(GetPlayerPed(src)), Radius ~= nil and tonumber(Radius) or 5.0
	for k, v in pairs(PlayerModule.GetPlayers()) do
		local Player = PlayerModule.GetPlayerBySource(v)
		if Player ~= nil then
			local TargetCoords = GetEntityCoords(GetPlayerPed(v))
			local TargetDistance = #(TargetCoords - Coords)
			if TargetDistance <= Radius then
                Player.Functions.SetMetaData("Food", 100)
                Player.Functions.SetMetaData("Water", 100)
                Player.Functions.SetMetaData("Stress", 0)
                TriggerClientEvent('mercy-hospital/client/revive', v, true)
			end
		end
	end
end)

RegisterNetEvent("mc-admin/server/revive-target", function(ServerId)
    local src = source
    if not AdminCheck(src) then return end
    ServerId = tonumber(ServerId)
    local PlayerSource = ServerId ~= nil and ServerId or src

    local Player = PlayerModule.GetPlayerBySource(src)
    if Player then
        Player.Functions.SetMetaData("Food", 100)
        Player.Functions.SetMetaData("Water", 100)
        Player.Functions.SetMetaData("Stress", 0)
        TriggerClientEvent('mercy-hospital/client/revive', PlayerSource, true)
        Player.Functions.Notify('gave-revive', Lang:t('info.gave_revive'), 'success')
    end
end)

RegisterNetEvent("mc-admin/server/open-clothing", function(ServerId)
    local src = source
    if not AdminCheck(src) then return end
    ServerId = tonumber(ServerId)
    local PlayerSource = ServerId ~= nil and ServerId or src

    local Player = PlayerModule.GetPlayerBySource(src)
    TriggerClientEvent('mercy-admin/client/force-close', PlayerSource)
    SetTimeout(500, function()
        TriggerClientEvent('mercy-clothing/client/open-menu', PlayerSource)
    end)
    Player.Functions.Notify('gave-clothing', Lang:t('info.gave_clothing'), 'success')
end)


RegisterNetEvent('mc-admin/server/sync-chat-data', function(Type, Data, UpdateDelay)
    UpdateDelay = UpdateDelay == nil and false or UpdateDelay
    if Type == 'Staffchat' then 
        Config.StaffChat = Data 
    else 
        Config.Reports = Data 
    end
    TriggerClientEvent('mc-admin/client/sync-chat-data', -1, Type, Type == 'Staffchat' and Config.StaffChat or Config.Reports, UpdateDelay)
end)

RegisterNetEvent("mc-admin/server/send-chat-report", function(ServerId, Message)
    TriggerClientEvent('mercy-chat/client/post-message', ServerId, 'Report', Message, "normal")
end)