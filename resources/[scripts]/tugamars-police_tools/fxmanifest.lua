fx_version 'cerulean'
game 'gta5'

name 'Tugamars Police Tools'
version '2.1.12'
description 'Tugamars Police Tools'
author 'tugamars'

shared_scripts {
    '@ox_lib/init.lua',
    'main/shared/config/global.lua',
    'main/shared/*.lua',
    'main/shared/config/**/*.lua'
}

client_scripts {
    'main/client/*.lua',
    'main/client/target/**.lua',
    'main/client/modules/**/*.lua',
}

server_scripts {
    'main/server/**/*.lua',
}

ui_page 'nui/index.html'

files {
    'nui/**/*',
    'nui/**/*.html',
    'nui/**/*.png',
    'nui/**/*.jpg',
    'nui/**/*.css',
    'nui/**/*.js',
    'stream/**/*.ydr',
    'stream/**/*.ytd',
    'stream/**/*.ytyp',
    'locales/**/*.json'
}

data_file 'DLC_ITYP_REQUEST' 'stream/*.ytyp'

lua54 'yes'

escrow_ignore {
    'main/client/target/**/*.lua',
    'main/client/framework.lua',
    'main/client/target.lua',
    'main/server/framework.lua',
    'main/shared/config/**/*.lua',
    '_installation/**/*',
    'locales/**/*.json'
}
dependency '/assetpacks'