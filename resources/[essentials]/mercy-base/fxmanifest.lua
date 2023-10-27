fx_version 'cerulean'
game 'gta5'

author 'Mercy'
description 'Base'

ui_page "nui/index.html"

shared_scripts {
    'shared/sh_config.lua',
    'shared/sh_shared.lua',
    '@mercy-inventory/shared/sh_items.lua',
}

client_scripts {
    '@mercy-assets/client/cl_errorlog.lua',
    'client/int/*.lua',
    'client/modules/*.lua',
    'client/*.lua',
    'client/*.js',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@mercy-assets/server/sv_errorlog.lua',
    'server/int/*.lua',
    'server/modules/*.lua',
    'server/*.lua',
    'server/*.js',
}

files {
	'nui/index.html',
}

lua54 'yes'