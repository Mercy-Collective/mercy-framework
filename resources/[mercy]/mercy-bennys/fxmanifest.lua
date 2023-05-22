fx_version 'cerulean'
game 'gta5'

lua54 'yes'

shared_scripts {
    'shared/sh_*.lua',
}

client_script {
    '@mercy-assets/client/cl_errorlog.lua',
    '@mercy-base/shared/sh_shared.lua',
    'client/*.lua',
}

server_script {
    '@mercy-assets/server/sv_errorlog.lua',
    -- 'configs/sh_*.lua',
    -- 'server/*.lua',
}

ui_page 'nui/index.html'
files {
    '@mercy-ui/nui/fonts/gta.ttf',
    '@mercy-ui/nui/fonts/pricedown.ttf',
    '@mercy-ui/nui/fonts/tvnord.ttf',
    '@mercy-ui/nui/css/colors.css',
    '@mercy-ui/nui/Apps/Styles/css/main.css',
    'nui/index.html',
    'nui/images/*.png',
    'nui/css/*.css',
    'nui/js/*.js',
}