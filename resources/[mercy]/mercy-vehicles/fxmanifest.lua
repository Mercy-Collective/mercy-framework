fx_version 'cerulean'
game 'gta5'

shared_scripts {
    'shared/**.lua',   
}

client_script {
    '@mercy-assets/client/cl_errorlog.lua',
    '@mercy-base/shared/sh_shared.lua',
    'client/**.lua',
}

server_script {
    '@mercy-assets/server/sv_errorlog.lua',
    '@mercy-base/shared/sh_shared.lua',
    'server/**.lua',
}

lua54 'yes'