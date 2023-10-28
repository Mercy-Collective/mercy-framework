fx_version 'cerulean'
game 'gta5'

lua54 'yes'
use_experimental_fxv2_oal 'yes'

ui_page 'nui/index.html'

shared_scripts {
    'shared/sh_*.lua',
}

client_script {
    '@mercy-assets/client/cl_errorlog.lua',
    '@mercy-base/shared/sh_shared.lua',
    'client/*.lua',
}

server_scripts {
    '@mercy-assets/server/sv_errorlog.lua',
    'server/*.lua',
}

files {
    'nui/index.html',
    'nui/images/*.png',
    'nui/css/*.css',
    'nui/js/*.js',
    "data/*.meta",
    "data/*.ymt",
}

data_file "CARCOLS_GEN9_FILE" "data/carcols_gen9.meta"
data_file "CARMODCOLS_GEN9_FILE" "data/carmodcols_gen9.meta"
