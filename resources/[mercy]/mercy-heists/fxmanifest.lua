fx_version 'cerulean'
game 'gta5'

lua54 'yes'

shared_scripts {
    'shared/sh_*.lua',
}

client_scripts {
    '@mercy-assets/client/cl_errorlog.lua',
    'client/**.lua',
}

server_scripts {
    '@mercy-assets/server/sv_errorlog.lua',
    'shared/sv_*.lua',
    'server/*.lua',
}