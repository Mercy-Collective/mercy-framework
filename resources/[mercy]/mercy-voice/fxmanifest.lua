fx_version 'cerulean'
game 'gta5'

author 'Mercy'
description 'Voice'

shared_scripts {
    'shared/sh_*.lua',
}

client_script {
    '@mercy-assets/client/cl_errorlog.lua',
    'client/classes/cl_*.lua',
    'client/cl_*.lua',
}

server_script {
    '@mercy-assets/server/sv_errorlog.lua',
    'server/sv_*.lua',
}

dependency 'mercy-ui'

lua54 'yes'