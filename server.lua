ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('Kaazy_LocationMaritime:buyJet')
AddEventHandler('Kaazy_LocationMaritime:buyJet', function()

	local _source = source

	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeMoney(550)
	
	TriggerClientEvent('esx:showNotification', source, 'Vous avez payé ~g~550$')

end)

RegisterServerEvent('Kaazy_LocationMaritime:buyBat')
AddEventHandler('Kaazy_LocationMaritime:buyBat', function()

	local _source = source

	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeMoney(1500)
	
	TriggerClientEvent('esx:showNotification', source, 'Vous avez payé ~g~1500$')

end)

