fx_version 'cerulean'
game 'gta5'

author 'Mercy Collective'
description 'Phone'

client_script {
    '@mercy-assets/client/cl_errorlog.lua',
    '@mercy-base/shared/sh_shared.lua',
    'config/sh_*.lua',
    'client/*.lua',
}

server_script {
    '@mercy-assets/server/sv_errorlog.lua',
    '@mercy-base/shared/sh_shared.lua',
    'config/sh_*.lua',
    'config/sv_*.lua',
    'server/*.lua',
}

lua54 'yes'