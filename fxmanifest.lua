fx_version 'cerulean'
game 'gta5'

description 'QBX-NewsJob'
repository 'https://github.com/Qbox-project/qbx_newsjob'
version '1.0.1'

shared_scripts {
    '@qbx_core/import.lua',
    'config.lua',
    '@qbx_core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    '@ox_lib/init.lua'
}

client_scripts {
    'client/main.lua',
    'client/camera.lua'
}

modules {
    'qbx_core:playerdata',
    'qbx_core:utils'
}

server_script 'server/main.lua'

lua54 'yes'
use_experimental_fxv2_oal 'yes'