fx_version 'cerulean'
game 'gta5'

shared_scripts {
    'shared/sh_*.lua',   
}

client_script {
    '@mercy-assets/client/cl_errorlog.lua',
    '@mercy-base/shared/sh_shared.lua',
    'client/cl_*.lua',
}

server_script {
    '@oxmysql/lib/MySQL.lua',
    '@mercy-assets/server/sv_errorlog.lua',
    '@mercy-base/shared/sh_shared.lua',
    'server/sv_*.lua',
}

lua54 'yes'