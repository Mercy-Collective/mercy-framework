fx_version 'cerulean'
game 'gta5'

ui_page 'nui/index.html'

client_script {
    '@mercy-assets/client/cl_errorlog.lua',
    'client/cl_*.lua',
}

server_script {
    '@mercy-assets/server/sv_errorlog.lua',
    'server/sv_*.lua',
}

files {
    'nui/index.html',
    'nui/js/*.js',
    'nui/css/*.css',
    'nui/images/*.png',
}

lua54 'yes'