ESX = nil
local ostamas = false
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('koodari', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	local cops = 0
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			cops = cops + 1
		end
	end

	if cops >= Config.PoliceCount then
		TriggerClientEvent('esx_buyweapons:startmission', source)
	end
end)

RegisterServerEvent('esx_buyweapons:laitaitemit')
AddEventHandler('esx_buyweapons:laitaitemit', function(itemi, maara, plate)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if ostamas then
		MySQL.Async.execute( 'INSERT INTO truck_inventory (item,count,plate,name,itemt,owned) VALUES (@item,@qty,@plate,@name,@itemt,@owned) ON DUPLICATE KEY UPDATE count=count+ @qty',
		{
		['@plate'] = plate,
		['@qty'] = maara,
		['@item'] = itemi,
		['@name'] = ESX.GetWeaponLabel(itemi),
		['@itemt'] = "item_weapon",
		['@owned'] = 0,
		})
		ostamas = false
	end
end)

RegisterServerEvent('esx_buyweapons:poista')
AddEventHandler('esx_buyweapons:poista', function(plate)
	MySQL.Async.execute('DELETE FROM truck_inventory WHERE plate = @plate',{['@plate'] = plate})
end)

ESX.RegisterServerCallback('esx_buyweapons:onkomassia', function(source, cb, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.getAccount('bank').money >= amount then
		xPlayer.removeAccountMoney('bank', amount)
		ostamas = true
		cb(true)
	else
		cb(false)
	end
end)