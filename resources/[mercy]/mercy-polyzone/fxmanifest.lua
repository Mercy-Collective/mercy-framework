fx_version 'cerulean'
game 'gta5'

ui_page 'nui/copy.html' 

client_scripts {
    '@mercy-assets/client/cl_errorlog.lua',
    'client/cl_main.lua',
    'client/BoxZone.lua',
    'client/EntityZone.lua',
    'client/CircleZone.lua',
    'client/ComboZone.lua',
    'client/creation/*.lua'
}

server_scripts {
    '@mercy-assets/server/sv_errorlog.lua',
    'server/sv_main.lua'
}

exports {
    'GetObject',
    'GetCreationStatus',
    'GetEditingLastPointStatus',
    'CreatePoly',
    'CreateBox',
}

files {
	'nui/copy.html',
}

lua54 'yes'