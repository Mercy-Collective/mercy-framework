-- [ Code ] --

-- [ Functions ] --

function SetDiscordRichPresence()
	local ServerId = GetPlayerServerId(PlayerId())
	SetDiscordAppId(Config.DiscordSettings['AppId'])
	SetDiscordRichPresenceAsset('main')
	SetDiscordRichPresenceAssetText(Config.DiscordSettings['Text'])
	SetDiscordRichPresenceAssetSmall('main')
	SetDiscordRichPresenceAssetSmallText('Server ID: '..ServerId)
end

-- [ Events ] --

RegisterNetEvent("setPlayerCount", function(c)
    SetRichPresence(c .. " Player(s)")
end)