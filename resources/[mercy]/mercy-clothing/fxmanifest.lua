fx_version 'cerulean'
game 'gta5'

author 'Mercy Collective (https://dsc.gg/mercy-coll)'
description 'Clothing'

ui_page 'nui/index.html'

shared_scripts  {
	'shared/sh_*.lua',
	'locale.lua',
    'locales/en.lua', -- Change this to your desired language.
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/sv_*.lua'
}

client_scripts {
	'@mercy-inventory/shared/sh_items.lua',
    'client/cl_*.lua'
}

files {
	'nui/index.html',
	'nui/css/*.css',
	'nui/js/**.js',
	'nui/img/*.png'
}

provide 'qb-clothing'

lua54 'yes'