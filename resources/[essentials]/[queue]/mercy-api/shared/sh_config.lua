Config = {
	Guild_ID = 'GUILD_ID_HERE', -- Set to the ID of your guild (or your Primary guild if using Multiguild)
	Multiguild = false, -- Set to true if you want to use multiple guilds
	Guilds = {
		-- ["main"] = "985482949359177749", -- Replace this with a name, like "main"
	},
	RoleList = {
		-- ["ROLE_NAME"] = "ROLE_ID",
	},
	CacheDiscordRoles = true, -- true to cache player roles, false to make a new Discord Request every time
	CacheDiscordRolesTime = 60, -- if CacheDiscordRoles is true, how long to cache roles before clearing (in seconds)
}

Config.Splash = {
	Header_IMG = '',
	Enabled = false,
	Wait = 2, -- How many seconds should splash page be shown for? (Max is 12)
	Heading1 = "Mercy",
	Heading2 = "Framework",
	Discord_Link = '',
	Website_Link = '',
}