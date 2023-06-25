fx_version 'cerulean'
game 'gta5'

author 'Mercy'
description 'Inventory'

ui_page 'nui/index.html'

shared_scripts {
    'shared/sh_*.lua',
}

client_scripts {
    'client/cl_*.lua',
}

server_scripts {
    'server/sv_*.lua'
}

server_exports {
    'GetItemData',
    'SetInventoryItems',
    'GetInventoryItems',
}

files {
    'nui/index.html',
    'nui/js/**.js',
    'nui/css/*.css',
    'nui/img/**.png',
}

lua54 'yes'