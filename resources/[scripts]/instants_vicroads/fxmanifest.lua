fx_version 'cerulean'
game 'gta5'

author 'Instant'
description 'VicRoads System'
version '1.0.0'

lua54 'yes'

shared_script '@ox_lib/init.lua'
shared_script 'config.lua'

client_scripts {
    'client/main.lua',
    'client/practical_test.lua',
    'client/admin.lua'
}


server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/framework.lua',
    'server/main.lua',
    'server/tests.lua',
    'server/vehicles.lua',
    'server/admin.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'html/gtav_map.png'
}

dependencies {
    'ox_lib',
    'ox_target',
    'oxmysql'
}
