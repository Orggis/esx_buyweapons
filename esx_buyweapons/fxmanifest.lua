fx_version 'cerulean'
game 'gta5'
client_scripts {
	'**/cl_*.lua'
}
server_scripts {
	'cl_config.lua',
	'sv_buyweapons.lua',
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua'
}