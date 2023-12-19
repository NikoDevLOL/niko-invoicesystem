fx_version 'cerulean'
game 'gta5'
lua54 'yes'
 
shared_scripts {
    'config.lua',
    '@es_extended/imports.lua',
    '@es_extended/locale.lua',
    '@ox_lib/init.lua',
    'locales/*.lua',
}
 
client_scripts {
    'client/*.lua'
}
 
server_scripts {
    'server/*.lua'
}
 
ui_page 'html/index.html'
 
files {
    'html/index.html',
    'html/assets/*.js',
    'html/assets/*.css',
}

escrow_ignore {
    'config.lua',
}