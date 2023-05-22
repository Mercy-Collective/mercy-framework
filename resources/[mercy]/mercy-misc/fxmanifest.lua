fx_version 'cerulean'
game 'gta5'

lua54 'yes'

data_file 'DLC_ITYP_REQUEST' 'stream/**/*.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/**/**/*.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/**/**/**/*.ytyp'

shared_scripts {
    'shared/sh_*.lua',
}

client_scripts {
    '@mercy-assets/client/cl_errorlog.lua',
    '@mercy-base/shared/sh_shared.lua',
    'client/cl_*.lua',
}

server_scripts {
    '@mercy-assets/server/sv_errorlog.lua',
    '@mercy-base/shared/sh_shared.lua',
    'server/sv_*.lua',
}

files {
    'stream/**/*.ytyp',
    'stream/**/**/*.ytyp',
    'stream/**/**/**/*.ytyp',
}