-- [ Code ] --

-- [ Events ] --

AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
	deferrals.defer()
	local src = source
    FunctionsModule = exports[GetCurrentResourceName()]:FetchModule('Functions')
	Wait(500)
    -- Name
	if Config.JoinChecks['Name'] then
		deferrals.update("📝 Checking Name..")
		Wait(1000)
		local PlayerName = GetPlayerName(src)
		if PlayerName == nil then 
			FunctionsModule.Kick(src, '❌ Don\'t use an empty Steam name.', setKickReason, deferrals)
			CancelEvent()
			return false
		end
		if(string.match(PlayerName, "[*%%'=`\"]")) then
			FunctionsModule.Kick(src, ' ❌ You have a sign in your name ('..string.match(PlayerName, "[*%%'=`\"]")..') which is not allowed.\nPlease remove this from your name.', setKickReason, deferrals)
			CancelEvent()
			return false
		end
		if (string.match(PlayerName, "drop") or string.match(PlayerName, "table") or string.match(PlayerName, "database")) then
			FunctionsModule.Kick(src, '❌ You have a word in your name (drop/table/database) which is not allowed.\nPlease remove this from your steam name.', setKickReason, deferrals)
			CancelEvent()
			return false
		end
	end
    -- Discord
	if Config.JoinChecks['Discord'] then
		Wait(750)
		deferrals.update("💻 Checking Discord..")
		Wait(1000)
		local Discord = FunctionsModule.GetIdentifier(src, "discord")
		if ((Discord:sub(1,8) == "discord:") == false) then
			FunctionsModule.Kick(src, '❌ You must have Discord on to play.', setKickReason, deferrals)
			CancelEvent()
			return false
		end
	end
    -- Identifier
	if Config.JoinChecks['Identifier'] then
		Wait(750)
		if Config.Server['IdentifierType'] == "steam" then
			deferrals.update("💻 Checking Steam..")
			Wait(1000)
			local Steam = FunctionsModule.GetIdentifier(src, "steam")
			if Steam == nil then 
				FunctionsModule.Kick(src, '❌ Error while contacting steam services, please try again.', setKickReason, deferrals)
				CancelEvent()
				return false
			end
			if ((Steam:sub(1,6) == "steam:") == false) then
				FunctionsModule.Kick(src, '❌ You must have Steam on to play.', setKickReason, deferrals)
				CancelEvent()
				return false
			end
		elseif Config.Server['IdentifierType'] == "license" then
			deferrals.update("💻 Checking License..")
			Wait(1000)
			local License = FunctionsModule.GetIdentifier(src, "license")
			if License == nil then 
				FunctionsModule.Kick(src, '❌ Error while contacting rockstar services, please try again.', setKickReason, deferrals)
				CancelEvent()
				return false
			end
			if ((License:sub(1,8) == "license:") == false) then
				FunctionsModule.Kick(src, '❌ You must have a rockstar linked to play.', setKickReason, deferrals)
				CancelEvent()
				return false
			end
		end
	end
	if Config.JoinChecks['Ban'] then
		Wait(750)
		deferrals.update("🔒 Checking if you are banned..")
		Wait(1000)
		local IsBanned, Message = FunctionsModule.IsPlayerBanned(src)
		if IsBanned then
			deferrals.update(Message)
			CancelEvent()
			return false
		end
	end
	Wait(750)
	deferrals.update("\n\nWelcome to the Mercy Framework! Please have a moment, we're loading everything in!")
    Wait(1000)
	deferrals.update("Everything has succesfully loaded! We are searching a spot for you..")
    Citizen.Wait(1250)
    deferrals.done()

	TriggerClientEvent('onPlayerJoining', src)
	TriggerClientEvent('setPlayerCount', -1, #GetPlayers() + 1)
end)

AddEventHandler('playerDropped', function(Reason) 
	local src = source
	TriggerClientEvent('mercy-base/client/on-logout', src)
	if Reason ~= "Reconnecting" and src > 60000 then return false end
	if(src==nil or (ServerPlayers[src] == nil)) then return false end
	ServerPlayers[src].Functions.Save()
	ServerPlayers[src] = nil
end)

RegisterNetEvent("mercy-base/server/load-user", function()
	local src = source
    local SteamIdentifier = FunctionsModule.GetIdentifier(src, "steam")
    DatabaseModule.Execute("SELECT * FROM server_users WHERE steam = ? ", {SteamIdentifier}, function(UserData)
        if UserData[1] == nil then
            DatabaseModule.Insert("INSERT INTO server_users (name, steam, ip, permission, token) VALUES (?, ?, ?, ?, ?)", {
				GetPlayerName(src), 
				SteamIdentifier, 
				GetPlayerEndpoint(src), 
				"user",
				"MERCY-"..math.random(1111, 9999),
			})
        else
            DatabaseModule.Update("UPDATE server_users SET name = ?, ip = ? WHERE steam = ? ", {GetPlayerName(src), GetPlayerEndpoint(src), SteamIdentifier})
        end
    end)
end)
