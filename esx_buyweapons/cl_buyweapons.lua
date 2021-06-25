ESX = nil
local ostelee = false
local spawned = true
local ostopoint = {}
local itemimaara = {}
local ostomaara = {}

CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Wait(10)
	end
	ESX.PlayerData = ESX.GetPlayerData()
	Wait(5000)
	while true do
		local wait = 2000
			if ostelee then
				local coords = GetEntityCoords(PlayerPedId())
				local distance = #(ostopoint.pos-coords)
				local plate = 'GUNS' .. math.random(1000,9999)

				if not spawned and ostelee then
					if distance < 50 then
						wait = 0
						spawned = true

						TriggerServerEvent('esx_buyweapons:laitaitemit', itemimaara, ostomaara, plate)
						TriggerEvent("esx_buyweapons:auto", plate)
					end
				end
			end
		Wait(wait)
	end
end)

function StartOsto()

    ESX.UI.Menu.CloseAll()
	ExecuteCommand('e tablet2')
	local elements = {}

	for i=1, #Config.Weapons, 1 do
		local itemit = Config.Weapons[i]

		table.insert(elements, {
			label = ' ' ..ESX.GetWeaponLabel(itemit.name).. ' $' .. itemit.hinta,
			paskavalue = itemit.name,
			paskahinta = itemit.hinta
		})
	end

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), '',
		{
			title    = 'Mitä haluat ostaa?',
			align    = 'center',
			elements = elements,
		},

		function(data, menu)
			TriggerEvent("esx_buyweapons:maara", data.current.paskavalue)
		end,
		function(data, menu)
			menu.close()
		end
	)
end

RegisterNetEvent('esx_buyweapons:auto')
AddEventHandler('esx_buyweapons:auto', function(plate)
	RequestModel(GetHashKey("asea"))
	while not HasModelLoaded(GetHashKey("asea")) do
		Wait(1)
	end
	local car = CreateVehicle(GetHashKey("asea"), ostopoint.pos, ostopoint.heading, true, true)
	SetVehicleOnGroundProperly(car)
	SetVehicleNumberPlateText(car, plate)
	SetVehicleHasBeenOwnedByPlayer(car, true)
	ostelee = false
end)

RegisterNetEvent('esx_buyweapons:maara')
AddEventHandler('esx_buyweapons:maara', function(itemi)
	ESX.UI.Menu.CloseAll()
	AddTextEntry('FMMC_KEY_TIP8', "Kuinka monta tahdot ostaa")
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 4)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait( 0 )
	end
	local maara = GetOnscreenKeyboardResult()
	maara = tonumber(maara)
	blockinput = false

	if maara ~= nil and maara > 0 and maara <= Config.Itemiosto then
		for i=1, #Config.Position, 1 do
			ostopoint = Config.Position[math.random(1,#Config.Position)]

			for i=1, #Config.Weapons, 1 do
				local itemit = Config.Weapons[i]
						
				if itemi == itemit.name then
					hinta = itemit.hinta*maara
				end
			end
		end
		ESX.TriggerServerCallback('esx_buyweapons:onkomassia', function(hasEnoughMoney)
			if hasEnoughMoney then
				ostelee = true
				spawned = false
				itemimaara = itemi 
				ostomaara = maara
				ESX.ShowNotification("Sinulla on " ..Config.Vehicletime.. " minuuttia aikaa hakea tavarat GPS:sästä!")
				SetNewWaypoint(ostopoint.pos)

				Wait(1000*60*Config.Vehicletime)
				if ostelee then
					ostelee = false
					ESX.ShowNotification("~r~Et sit hakenut autoa!")
				end
			else
				ESX.ShowNotification("~r~Sinulla ei riittänyt rahat ostaa!")
			end
		end, hinta)

	elseif maara ~= nil and maara > Config.Itemiosto then
		ESX.ShowNotification("~r~Meiltä ei löydy noin montaa asetta!")
	else
		ESX.ShowNotification("~r~Etkö osaa valita kuinka monta haluat!")
	end
end)

RegisterNetEvent('esx_buyweapons:startmission')
AddEventHandler('esx_buyweapons:startmission', function()
	itemimaara = nil
	ostomaara = nil
	StartOsto()
end)