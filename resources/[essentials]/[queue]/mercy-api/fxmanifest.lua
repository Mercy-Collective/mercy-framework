fx_version 'cerulean'
game 'gta5'

shared_scripts {
	'shared/*.lua',
}

client_scripts {
	'client/*.lua',
}

server_scripts {
	'server/*.lua',
}

server_exports { 
	'GetDiscordRoles',
	'GetRoleIdFromRoleName',
	'GetDiscordAvatar',
	'GetDiscordName',
	'GetDiscordEmail',
	'IsDiscordEmailVerified',
	'GetDiscordNickname',
	'GetGuildIcon',
	'GetGuildSplash',
	'GetGuildName',
	'GetGuildDescription',
	'GetGuildMemberCount',
	'GetGuildOnlineMemberCount',
	'GetGuildRoleList',
	'ResetCaches',
	'CheckEqual'
} 
