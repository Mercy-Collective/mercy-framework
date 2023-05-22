fx_version 'cerulean'
game 'gta5'

lua54 'yes'

shared_scripts {
    'shared/sh_*.lua'
}

client_scripts {
    '@mercy-assets/client/cl_errorlog.lua',
    '@mercy-inventory/shared/sh_config.lua',
    '@mercy-inventory/shared/sh_items.lua',
    'client/*.lua',
}

server_scripts {
    '@mercy-assets/server/sv_errorlog.lua',
    '@mercy-inventory/shared/sh_config.lua',
    '@mercy-inventory/shared/sh_items.lua',
    'server/*.lua',
}