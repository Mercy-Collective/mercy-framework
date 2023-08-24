fx_version 'cerulean'
game "gta5"

author "Kane @ .gg/mercy-coll"
description "Casino Wheel"

shared_scripts {
	"shared/sh_*.lua",
}

client_scripts {
	'@mercy-polyzone/client/cl_main.lua',
	'@mercy-polyzone/client/BoxZone.lua',
	'@mercy-polyzone/client/ComboZone.lua',
	"client/**.lua",
}

server_script {
	"shared/sv_*.lua",
	"server/**.lua",
}

lua54 'yes'