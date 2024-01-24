fx_version 'adamant'
games { 'gta5' }
dependency 'chat'
lua54 'yes'
version '1.0.0'
author 'TheStoicBear'
description 'Stoic-Reg'

client_script 'client.lua'
server_script 'server.lua'

shared_scripts {
    "@ND_Core/init.lua",
    "@ox_lib/init.lua",
    "@oxmysql/lib/MySQL.lua"
}