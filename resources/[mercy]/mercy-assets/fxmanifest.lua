fx_version 'cerulean'
game 'gta5'

shared_scripts {
    'shared/sh_*.lua',
}

client_scripts {
    'client/cl_*.lua',
}

server_scripts {
    'server/sv_*.lua',
}

data_file 'FIVEM_LOVES_YOU_341B23A2F0E0F131' 'misc/popgroups.ymt'
data_file 'TIMECYCLEMOD_FILE' 'timecycle/*.xml'
data_file 'HANDLING_FILE' 'misc/handling.meta'

files {
    'gta5.meta',
    'misc/*.ymt',
    'misc/*.dat',
    'timecycle/*.xml',
    'misc/*.meta',
}

replace_level_meta "gta5"
before_level_meta 'data'
replace_level_meta "gta5"

lua54 'yes'
