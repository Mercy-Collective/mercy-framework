displayIndex = 1;
displays = Config.Displays.ConnectingLoop;
prefix = Config.Displays.Prefix;
currentConnectors = 0;
maxConnectors = Config.AllowedPerTick;
webhookURL = Config.Webhook;
notSet = true;
hostname = GetConvar("sv_hostname")
slots = GetConvarInt('sv_maxclients', 32)

local connecting = {}
local playerConnecting = {}

-- Functions

function GetPlayerCount() 
    local cout = 0;
    for _, id in pairs(GetPlayers()) do 
        cout = cout + 1;
    end
    return cout;
end

function CheckForGhostUsers()
    for license, data in pairs(playerConnecting) do 
        local found = false;
        local user = data.ID;
        local name = data.PlayerName;
        local connectingg = data.Connection;
        if GetPlayerName(user) == nil or GetPlayerName(user) ~= name then 
            -- They no longer exist
            Queue:PopLicense(license)
            if Config.Debug then 
                print("[mercy-queue] (Thread : NO LONGER EXISTS) Popped player " .. name .. " from queue...");
            end
            if connecting[license] ~= nil then 
                connecting[license] = nil;
                if (currentConnectors > 0) then 
                currentConnectors = currentConnectors - 1;
                end
            end
            if Config.Debug then 
                print("[mercy-queue] (Thread : NO LONGER EXISTS) currentConnectors is == " .. tostring(currentConnectors) )
            end
        playerConnecting[license] = nil;
        end
    end
end

function sendToDisc(title, message, footer)
	local embed = {}
	embed = {
		{
			["color"] = 65280, -- GREEN = 65280 --- RED = 16711680
			["title"] = "**".. title .."**",
			["description"] = "" .. message ..  "",
			["footer"] = {
				["text"] = footer,
			},
		}
	}
	-- Start
	-- TODO Input Webhook
	PerformHttpRequest(webhookURL, 
	function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
  -- END
end

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    --Loop over all identifiers
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        --Convert it to a nice table.
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end

function sendToDiscQueue(title, message, footer)
	local embed = {}
	embed = {
		{
			["color"] = 16711680, -- GREEN = 65280 --- RED = 16711680
			["title"] = "**".. title .."**",
			["description"] = "" .. message ..  "",
			["footer"] = {
				["text"] = footer,
			},
		}
	}
	-- Start
	-- TODO Input Webhook
	PerformHttpRequest(webhookURL, 
	function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
  -- END
end

-- Threads

CreateThread(function()
    while true do 
        Wait((1000 * 30)); -- Every 30 seconds
        --print("sv_maxclients is set to: " .. tostring(slots));
        --print("Queue:GetMax() is set to: " .. tostring(Queue:GetMax())); 
        if Config.HostDisplayQueue then 
            if hostname ~= "default FXServer" and Queue:GetMax() > 0 then 
                SetConvar("sv_hostname", "[" .. Queue:GetMax() .. "] " .. hostname);
                --print(prefix .. " Set server title: '" .. "[" .. "1" .. "/" .. (Queue:GetMax() + 1) .. "] " .. hostname .. "'")
            end
            if hostname ~= "default FXServer" and Queue:GetMax() == 0 then 
                SetConvar("sv_hostname", hostname);
                --print(prefix .. " Set server title: '" .. hostname .. "'")
            end
        end
    end
end)

CreateThread(function()
    while notSet do 
        if hostname == "default FXServer" then 
            hostname = GetConvar("sv_hostname");
        else 
            notSet = false;
        end
    end 
end)

CreateThread(function()
    while true do 
        Wait((Config.CheckForGhostUsers * 1000));
        CheckForGhostUsers();
    end
end)

-- Events

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals) 
    deferrals.defer();
    local user = source;
    local license = ExtractIdentifiers(user).license:gsub("license:", "");
    local ids = ExtractIdentifiers(user);
    local playerName = GetPlayerName(user);
    local allowed = true;
    if Config.Requirements.Steam then 
        -- Check if they have Steam
        if #ids.steam <= 1 then 
            deferrals.done(Config.Displays.Prefix .. " " .. Config.Displays.Messages.MSG_STEAM_REQUIRED);
            allowed = false;
            CancelEvent();
            return;
        end
    end
    if Config.Requirements.Discord then 
        -- Check if they have Discord
        if #ids.discord <= 1 then 
            deferrals.done(Config.Displays.Prefix .. " " .. Config.Displays.Messages.MSG_DISCORD_REQUIRED);
            allowed = false;
            CancelEvent();
            return;
        end
    end
    if Config.WhitelistRequired then 
        if not Queue:IsWhitelisted(user) then 
            -- Not whitelisted, return 
            deferrals.done(Config.Displays.Prefix .. " " .. Config.Displays.Messages.MSG_NOT_WHITELISTED);
            allowed = false;
            CancelEvent();
            return;
        end
    end
    if allowed then 
        playerConnecting[license] = {Connection = false, ID = user, PlayerName = playerName, Timeout = 0};
        if Config.onlyActiveWhenFull == true then 
            -- It's only active when server is full so lets check 
            if (GetPlayerCount() + 1) > slots or (GetPlayerCount() + Queue:GetMax()) > slots then  
                -- It's full, activate
                if not Queue:IsSetUp(user) then 
                    -- Set them up 
                    Queue:SetupPriority(user);
                    if GetPlayerName(user) ~= nil then
                        sendToDiscQueue("QUEUE", "**`" .. GetPlayerName(user):gsub("`", "") .. "`** has entered the queue.");
                    end 
                    local message = GetMessage(user);
                    if GetPlayerName(user) ~= nil then
                        print(prefix .. " " .. GetPlayerName(user) .. " has entered the queue.");
                    end
                end
                while ( ( (not Queue:CheckQueue(user, currentConnectors, slots)) or (currentConnectors == maxConnectors) ) or (GetPlayerCount() == slots) or ((GetPlayerCount() + currentConnectors + 1) > slots) or ( (GetPlayerCount() + currentConnectors ) >= slots) ) do  
                    -- They are still in the queue 
                    Wait(3000);
                    if displayIndex > #displays then
                        displayIndex = 30;
                    end 

                    local message = GetMessage(user);
                    local msg = message:gsub("{QUEUE_NUM}", Queue:GetQueueNum(user)):gsub("{QUEUE_MAX}", Queue:GetMax());
                    deferrals.update(displays[displayIndex] .. " " .. msg);
                end
                -- If it got down here, they are now allowed to join the server 
                if connecting[license] == nil or connecting[license] ~= true then 
                    Queue:PopLicense(license)
                    currentConnectors = currentConnectors + 1;
                    connecting[license] = true;
                    if GetPlayerName(user) ~= nil then
                        print(prefix .. " " .. GetPlayerName(user) .. " is now joining the server!");
                    end
                    Wait(1000);
                    if GetPlayerName(user) ~= nil then
                        sendToDisc("JOINING", "**`" .. GetPlayerName(user):gsub("`", "") .. "`** is now joining the server!");
                    end
                    if playerConnecting[license] ~= nil then 
                        playerConnecting[license].Timeout = Config.Timeout;
                        playerConnecting[license].Connection = true;
                    end
                    if Config.Debug then 
                        print("[mercy-queue] currentConnectors is == " .. tostring(currentConnectors) )
                    end
                end -- connecting[license] == nil 
                deferrals.done();
            else	 
                deferrals.done();--deferrals done if server is not full as we don't want the queue
            end
        else 
            if not Queue:IsSetUp(user) then 
                -- Set them up 
                Queue:SetupPriority(user);
                if GetPlayerName(user) ~= nil then
                    sendToDiscQueue("QUEUE", "**`" .. GetPlayerName(user):gsub("`", "") .. "`** has entered the queue.");
                end
                local message = GetMessage(user);
                if GetPlayerName(user) ~= nil then
                    print(prefix .. " " .. GetPlayerName(user) .. " has entered the queue.");
                end
            end
            while ( ( (not Queue:CheckQueue(user, currentConnectors, slots)) or (currentConnectors == maxConnectors) ) or (GetPlayerCount() == slots) or ((GetPlayerCount() + currentConnectors + 1) > slots) or ( (GetPlayerCount() + currentConnectors ) >= slots) ) do 
                -- They are still in the queue 
                Wait(3000);
                if displayIndex > #displays then
                    displayIndex = 1;
                end 

                local message = GetMessage(user);
                local msg = message:gsub("{QUEUE_NUM}", Queue:GetQueueNum(user)):gsub("{QUEUE_MAX}", Queue:GetMax());

                deferrals.update(prefix .. " " .. msg .. displays[displayIndex]);
            end
            -- If it got down here, they are now allowed to join the server 
            if connecting[license] == nil or connecting[license] ~= true then 
                Queue:PopLicense(license)
                currentConnectors = currentConnectors + 1;
                connecting[license] = true;
                if GetPlayerName(user) ~= nil then
                print(prefix .. " " .. GetPlayerName(user) .. " is now joining the server!");
                end
                Wait(1000);
                if GetPlayerName(user) ~= nil then
                    sendToDisc("JOINING", "**`" .. GetPlayerName(user):gsub("`", "") .. "`** is now joining the server!");
                end
                if playerConnecting[license] ~= nil then 
                    playerConnecting[license].Timeout = Config.Timeout;
                    playerConnecting[license].Connection = true;
                end
                if Config.Debug then 
                    print("[mercy-queue] Total Connected Players: " .. tostring(currentConnectors) )
                end
            end -- connecting[license] == nil
            deferrals.done();
        end
    end
end)

AddEventHandler('playerDropped', function (reason)
    local user = source;
    local license = ExtractIdentifiers(user).license:gsub("license:", "");
    if (connecting[license] ~= nil) then 
        if (currentConnectors > 0) then 
        currentConnectors = currentConnectors - 1;
        end
        connecting[license] = nil;
    end
    playerConnecting[license] = nil;
    if (Queue:IsSetUp(user)) then 
        Queue:Pop(user);
        sendToDiscQueue("[QUEUE] PLAYER DROPPED", "**`" .. GetPlayerName(user):gsub("`", "") .. "`** has been dropped from the queue.");
        print(prefix .. " " .. GetPlayerName(user) .. " has been dropped from the queue.");
    end
end)

RegisterNetEvent('mercy-queue/server/activated', function()
    -- They were activated, pop them from Queue 
    Queue:Pop(source);
    local user = source;
    local license = ExtractIdentifiers(user).license:gsub("license:", "");
    connecting[license] = nil;
    playerConnecting[license] = nil;
    sendToDiscQueue("[QUEUE] PLAYER DROPPED", "**`" .. GetPlayerName(user):gsub("`", "") .. "`** has been dropped from the queue.");
    if (currentConnectors > 0) then 
        currentConnectors = currentConnectors - 1;
    end
    if Config.Debug then 
        print(prefix .. " " .. GetPlayerName(user) .. " has been dropped from the queue.");
        print("[mercy-queue] Total Connected Players: " .. tostring(currentConnectors) )
    end
end)

StopResource('hardcap')

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if GetResourceState('hardcap') == 'stopped' then
            StartResource('hardcap')
        end
    end
end)