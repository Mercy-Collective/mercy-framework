local FormattedToken = "Bot ".."TOKEN_HERE"

local error_codes_defined = {
	[200] = 'OK - The request was completed successfully..!',
	[400] = "Error - The request was improperly formatted, or the server couldn't understand it..!",
	[401] = 'Error - The Authorization header was missing or invalid..! Your Discord Token is probably wrong or does not have correct permissions attributed to it.',
	[403] = 'Error - The Authorization token you passed did not have permission to the resource..! Your Discord Token is probably wrong or does not have correct permissions attributed to it.',
	[404] = "Error - The resource at the location specified doesn't exist.",
	[429] = 'Error - Too many requests, you hit the Discord rate limit. https://discord.com/developers/docs/topics/rate-limits',
	[502] = 'Error - Discord API may be down?...'
};

CreateThread(function()
	if (GetCurrentResourceName() ~= "mercy-api") then 
		--StopResource(GetCurrentResourceName());
		print("[" .. GetCurrentResourceName() .. "] " .. "IMPORTANT: This resource must be named mercy-api for it to work properly with other scripts...");
	end
end)

tracked = {}

RegisterNetEvent('mercy-api/server/player-loaded', function()
	if (GetCurrentResourceName() ~= "mercy-api") then 
		TriggerClientEvent('chatMessage', -1, '^1[^5SCRIPT ERROR^1] ^3The script ^1' .. GetCurrentResourceName() .. ' ^3will not work properly... You must '
	.. 'rename the resource to ^1un-api');
	end
	local license = GetIdentifier(source, 'license');
	if (tracked[license] == nil) then 
		tracked[license] = true;
	end
end)

card = '{"type":"AdaptiveCard","$schema":"http://adaptivecards.io/schemas/adaptive-card.json","version":"1.3","body":[{"type":"Image","url":"' .. Config.Splash.Header_IMG .. '","horizontalAlignment":"Center"},{"type":"Container","items":[{"type":"TextBlock","text":"mercy-api","wrap":true,"fontType":"Default","size":"ExtraLarge","weight":"Bolder","color":"Light","horizontalAlignment":"Center"},{"type":"TextBlock","text":"' .. Config.Splash.Heading1 .. '","wrap":true,"size":"Large","weight":"Bolder","color":"Light","horizontalAlignment":"Center"},{"type":"TextBlock","text":"' .. Config.Splash.Heading2 .. '","wrap":true,"color":"Light","size":"Medium","horizontalAlignment":"Center"},{"type":"ColumnSet","height":"stretch","minHeight":"100px","bleed":true,"horizontalAlignment":"Center","columns":[{"type":"Column","width":"stretch","items":[{"type":"ActionSet","actions":[{"type":"Action.OpenUrl","title":"Discord","url":"' .. Config.Splash.Discord_Link .. '","style":"positive"}]}],"height":"stretch"},{"type":"Column","width":"stretch","items":[{"type":"ActionSet","actions":[{"type":"Action.OpenUrl","title":"Website","style":"positive","url":"' .. Config.Splash.Website_Link .. '"}]}]}]},{"type":"ActionSet","actions":[{"type":"Action.OpenUrl","title":"Click to join Unity\'s Discord","style":"destructive","iconUrl":"https://i.gyazo.com/0904b936e8e30d0104dec44924bd2294.gif","url":"https://discord.com/invite/WjB5VFz"}]}],"style":"default","bleed":true,"height":"stretch"},{"type":"Image","url":"https://i.gyazo.com/7e896862b14be754ae8bad90b664a350.png","selectAction":{"type":"Action.OpenUrl","url":""},"horizontalAlignment":"Center"}]}'
if Config.Splash.Enabled then 
	AddEventHandler('playerConnecting', function(name, setKickReason, deferrals) 
		-- Player is connecting
		deferrals.defer();
		local src = source;
		local toEnd = false;
		local count = 0;
		while not toEnd do 
			deferrals.presentCard(card,
			function(data, rawData)
			end)
			Wait((1000))
			count = count + 1;
			if count == Config.Splash.Wait then 
				toEnd = true;
			end
		end
		deferrals.done();
	end)
end 

function GetIdentifier(source, id_type)
    if type(id_type) ~= "string" then return print('Invalid usage') end
    for _, identifier in pairs(GetPlayerIdentifiers(source)) do
        if string.find(identifier, id_type) then
            return identifier
        end
    end
    return nil
end

function GetGuildId (guildName)
  local result = Config.Guild_ID
  if guildName and Config.Guilds[guildName] then
    result = tostring(Config.Guilds[guildName])
  end
  return result
end

function DiscordRequest(method, endpoint, jsondata)
    local data = nil
    PerformHttpRequest("https://discordapp.com/api/"..endpoint, function(errorCode, resultData, resultHeaders)
		data = {data=resultData, code=errorCode, headers=resultHeaders}
    end, method, #jsondata > 0 and json.encode(jsondata) or "", {["Content-Type"] = "application/json", ["Authorization"] = FormattedToken})

    while data == nil do
        Wait(0)
    end
	
    return data
end

function GetRoleIdFromRoleName(name, guild --[[optional]])
  local guildId = GetGuildId(guild)
	if (Caches.RoleList[guildId] ~= nil) then 
		return tonumber(Caches.RoleList[name]);
	else 
		local roles = GetGuildRoleList(guild);
		return tonumber(roles[name]);
	end
end

function CheckEqual(role1, role2, guild --[[optional]])
	local checkStr1 = false;
	local checkStr2 = false;
	local roleID1 = role1;
	local roleID2 = role2;
	local searchGuild1 = true;
	local searchGuild2 = true;
	if type(role1) == "string" then checkStr1 = true end;
	if type(role2) == "string" then checkStr2 = true end; 
	if checkStr1 then 
		local roles2 = Config.RoleList;
		for roleRef, roleID in pairs(roles2) do 
			if roleRef == role1 then 
				roleID1 = roleID;
				searchGuild1 = false;
			end
		end
		if searchGuild1 then 
			local roles = GetGuildRoleList(guild);
			for roleName, roleID in pairs(roles) do 
				if roleName == role1 then 
					roleID1 = roleID;
				end
			end
		end
	end
	if checkStr2 then
		local roles2 = Config.RoleList;
		for roleRef, roleID in pairs(roles2) do 
			if roleRef == role2 then 
				roleID2 = roleID;
				searchGuild2 = false;
			end
		end 
		if searchGuild2 then 
			local roles = GetGuildRoleList(guild);
			for roleName, roleID in pairs(roles) do 
				if roleName == role2 then 
					roleID2 = roleID;
				end
			end
		end
	end
	if tonumber(roleID1) == tonumber(roleID2) then 
		return true;
	end
	return false;
end

function IsDiscordEmailVerified(user) 
    local discordId = nil
    local isVerified = false;
    for _, id in ipairs(GetPlayerIdentifiers(user)) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
    end
    if discordId then 
        local endpoint = ("users/%s"):format(discordId)
        local member = DiscordRequest("GET", endpoint, {})
        if member.code == 200 then
            local data = json.decode(member.data)
            if data ~= nil then 
                -- It is valid data 
                --print("The data for User " .. GetPlayerName(user) .. " is: ");
                --print(data.avatar);
                isVerified = data.verified;
                --print("---")
            end
        else 
        	print("[mercy-discord] ERROR: Code 200 was not reached. DETAILS: " .. error_codes_defined[member.code]);
        end
    end
    return isVerified;
end

function GetDiscordEmail(user) 
    local discordId = nil
    local emailData = nil;
    for _, id in ipairs(GetPlayerIdentifiers(user)) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
    end
    if discordId then 
        local endpoint = ("users/%s"):format(discordId)
        local member = DiscordRequest("GET", endpoint, {})
        if member.code == 200 then
            local data = json.decode(member.data)
            if data ~= nil then 
                -- It is valid data 
                --print("The data for User " .. GetPlayerName(user) .. " is: ");
                --print(data.avatar);
                emailData = data.email;
                --print("---")
            end
        else 
        	print("[mercy-discord] ERROR: Code 200 was not reached. DETAILS: " .. error_codes_defined[member.code])
        end
    end
    return emailData;
end

function GetDiscordName(user) 
    local discordId = nil
    local nameData = nil;
    for _, id in ipairs(GetPlayerIdentifiers(user)) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
    end
    if discordId then 
        local endpoint = ("users/%s"):format(discordId)
        local member = DiscordRequest("GET", endpoint, {})
        if member.code == 200 then
            local data = json.decode(member.data)
            if data ~= nil then 
                -- It is valid data 
                --print("The data for User " .. GetPlayerName(user) .. " is: ");
                --print(data.avatar);
                nameData = data.username .. "#" .. data.discriminator;
                --print("---")
            end
        else 
        	print("[mercy-discord] ERROR: Code 200 was not reached. DETAILS: " .. error_codes_defined[member.code])
        end
    end
    return nameData;
end

function GetGuildIcon(guild --[[optional]])
  local guildId = GetGuildId(guild)
	local guild = DiscordRequest("GET", "guilds/"..guildId, {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		if (data.icon:sub(1, 1) and data.icon:sub(2, 2) == "_") then 
			-- It's a gif 
			return 'https://cdn.discordapp.com/icons/' .. Config.Guild_ID .. "/" .. data.icon .. ".gif";
		else 
			-- Image 
			return 'https://cdn.discordapp.com/icons/' .. Config.Guild_ID .. "/" .. data.icon .. ".png";
		end 
	else
		print("[mercy-discord] An error occured, please check your config and ensure everything is correct. Error: "..(guild.data or guild.code)) 
	end
	return nil;
end

function GetGuildSplash(guild --[[optional]])
  local guildId = GetGuildId(guild)
	local guild = DiscordRequest("GET", "guilds/"..guildId, {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		-- Image 
		return 'https://cdn.discordapp.com/splashes/' .. Config.Guild_ID .. "/" .. data.icon .. ".png";
	else
		print("[mercy-discord] An error occured, please check your config and ensure everything is correct. Error: "..(guild.data or guild.code)) 
	end
	return nil;
end 

function GetGuildName(guild --[[optional]])
  local guildId = GetGuildId(guild)
	local guild = DiscordRequest("GET", "guilds/"..guildId, {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		-- Image 
		return data.name;
	else
		print("[mercy-discord] An error occured, please check your config and ensure everything is correct. Error: "..(guild.data or guild.code)) 
	end
	return nil;
end

function GetGuildDescription(guild --[[optional]])
  local guildId = GetGuildId(guild)
	local guild = DiscordRequest("GET", "guilds/"..guildId, {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		-- Image 
		return data.description;
	else
		print("[mercy-discord] An error occured, please check your config and ensure everything is correct. Error: "..(guild.data or guild.code)) 
	end
	return nil;
end

function GetGuildMemberCount(guild --[[optional]])
  local guildId = GetGuildId(guild)
	local guild = DiscordRequest("GET", "guilds/"..guildId.."?with_counts=true", {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		-- Image 
		return data.approximate_member_count;
	else
		print("[mercy-discord] An error occured, please check your config and ensure everything is correct. Error: "..(guild.data or guild.code)) 
	end
	return nil;
end

function GetGuildOnlineMemberCount(guild --[[optional]])
  local guildId = GetGuildId(guild)
	local guild = DiscordRequest("GET", "guilds/"..guildId.."?with_counts=true", {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		return data.approximate_presence_count;
	else
		print("[mercy-discord] An error occured, please check your config and ensure everything is correct. Error: "..(guild.data or guild.code)) 
	end
	return nil;
end

function GetDiscordAvatar(user) 
    local discordId = nil
    local imgURL = nil;
    for _, id in ipairs(GetPlayerIdentifiers(user)) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
	end
	if discordId then 
		if Caches.Avatars[discordId] == nil then 
			local endpoint = ("users/%s"):format(discordId)
			local member = DiscordRequest("GET", endpoint, {})
			if member.code == 200 then
				local data = json.decode(member.data)
				if data ~= nil and data.avatar ~= nil then 
					-- It is valid data 
					--print("The data for User " .. GetPlayerName(user) .. " is: ");
					--print(data.avatar);
					if (data.avatar:sub(1, 1) and data.avatar:sub(2, 2) == "_") then 
						--print("IMG URL: " .. "https://cdn.discordapp.com/avatars/" .. discordId .. "/" .. data.avatar .. ".gif")
						imgURL = "https://cdn.discordapp.com/avatars/" .. discordId .. "/" .. data.avatar .. ".gif";
					else 
						--print("IMG URL: " .. "https://cdn.discordapp.com/avatars/" .. discordId .. "/" .. data.avatar .. ".png")
						imgURL = "https://cdn.discordapp.com/avatars/" .. discordId .. "/" .. data.avatar .. ".png"
					end
					--print("---")
				end
			else 
				print("[mercy-discord] ERROR: Code 200 was not reached. DETAILS: " .. error_codes_defined[member.code])
			end
			Caches.Avatars[discordId] = imgURL;
		else 
			imgURL = Caches.Avatars[discordId];
		end 
	else 
		print("[mercy-discord] ERROR: Discord ID was not found...")
	end
    return imgURL;
end

Caches = {
	Avatars = {},
  RoleList = {}
}
function ResetCaches()
	Caches = {
    Avatars = {},
    RoleList = {},
  };
end

function GetGuildRoleList(guild --[[optional]])
  local guildId = GetGuildId(guild)
	if (Caches.RoleList[guildId] == nil) then 
		local guild = DiscordRequest("GET", "guilds/"..guildId, {})
		if guild.code == 200 then
			local data = json.decode(guild.data)
			-- Image 
			local roles = data.roles;
			local roleList = {};
			for i = 1, #roles do 
				roleList[roles[i].name] = roles[i].id;
			end
			Caches.RoleList[guildId] = roleList;
		else
			print("[mercy-discord] An error occured, please check your config and ensure everything is correct. Error: "..(guild.data or guild.code)) 
			Caches.RoleList = nil;
		end
	end
	return Caches.RoleList[guildId];
end

local recent_role_cache = {}

function GetDiscordRoles(user, guild --[[optional]])
	local discordId = nil
  local guildId = GetGuildId(guild)
	for _, id in ipairs(GetPlayerIdentifiers(user)) do
		if string.match(id, "discord:") then
			discordId = string.gsub(id, "discord:", "")
			break;
		end
	end

	if discordId then
		if Config.CacheDiscordRoles and recent_role_cache[discordId] then
			return recent_role_cache[discordId]
		end
		local endpoint = ("guilds/%s/members/%s"):format(guildId, discordId)
		local member = DiscordRequest("GET", endpoint, {})
		if member.code == 200 then
			local data = json.decode(member.data)
			local roles = data.roles
			local found = true
			if Config.CacheDiscordRoles then
				recent_role_cache[discordId] = roles
				SetTimeout(((Config.CacheDiscordRolesTime or 60)*1000), function() recent_role_cache[discordId] = nil end)
			end
			return roles
		else
			print("[mercy-discord] ERROR: Code 200 was not reached... Returning false. [Member Data NOT FOUND] DETAILS: " .. error_codes_defined[member.code])
			return false
		end
	else
		print("[mercy-discord] ERROR: Discord was not connected to user's Fivem account...")
		return false
	end
	return false
end

function GetDiscordNickname(user)
	local discordId = nil
	for _, id in ipairs(GetPlayerIdentifiers(user)) do
		if string.match(id, "discord:") then
			discordId = string.gsub(id, "discord:", "")
			break
		end
	end

	if discordId then
		local endpoint = ("guilds/%s/members/%s"):format(Config.Guild_ID, discordId)
		local member = DiscordRequest("GET", endpoint, {})
		if member.code == 200 then
			local data = json.decode(member.data)
			local nickname = data.nick
			return nickname;
		else
			print("[mercy-discord] ERROR: Code 200 was not reached. Error Code: " .. error_codes_defined[member.code])
			return nil;
		end
	else
		print("[mercy-discord] ERROR: Discord was not connected to user's Fivem account...")
		return nil;
	end
	return nil;
end

CreateThread(function()
  local mguild = DiscordRequest("GET", "guilds/"..Config.Guild_ID, {})
  if mguild.code == 200 then
    local data = json.decode(mguild.data)
    print("[mercy-discord] Successful connection to Guild : "..data.name.." ("..data.id..")")
  else
    print("[mercy-discord] An error occured, please check your config and ensure everything is correct. Error: "..(mguild.data and json.decode(mguild.data) or mguild.code)) 
  end
  if (Config.Multiguild) then 
    for _,guildID in pairs(Config.Guilds) do
      local guild = DiscordRequest("GET", "guilds/"..guildID, {})
      if guild.code == 200 then
        local data = json.decode(guild.data)
        print("[mercy-discord] Successful connection to Guild : "..data.name.." ("..data.id..")")
      else
        print("[mercy-discord] An error occured, please check your config and ensure everything is correct. Error: "..(guild.data and json.decode(guild.data) or guild.code)) 
      end
    end
  end
end)
