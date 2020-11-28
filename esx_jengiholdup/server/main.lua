local rob = false
local robbers = {}
ESX = nil
local helari = math.random(0,20000)

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_jengiholdup:tooFar')
AddEventHandler('esx_jengiholdup:tooFar', function(currentStore)
	local _source = source
	local xPlayers = ESX.GetPlayers()
	rob = false

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		
		if xPlayer.job.name == 'mafia' then
TriggerClientEvent('esx_jengiholdup:xd', xPlayers[i])
			TriggerClientEvent('esx_jengiholdup:killBlip', xPlayers[i])
		end
	end

	if robbers[_source] then
		TriggerClientEvent('esx_jengiholdup:tooFar', _source)
		robbers[_source] = nil
	end
end)

RegisterServerEvent('esx_jengiholdup:robberyStarted')
AddEventHandler('esx_jengiholdup:robberyStarted', function(currentStore)
	local _source  = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()

	if Gangs[currentStore] then
		local store = Gangs[currentStore]

		if (os.time() - store.lastRobbed) < Config.TimerBeforeNewRob and store.lastRobbed ~= 0 then
			TriggerClientEvent('esx:showNotification', _source, "recently_robbed")
			return
		end
local cops1 = 0
		local cops = 0
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'mafia' then
				cops = cops + 1
			end
		end


		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' then
					cops1 = cops1 + 1
			end
		end

		if not rob then
if cops1 >= Config.TarvittavatPoliisitAloitukseen then
			if cops >= Config.PoliceNumberRequired then
				rob = true

				for i=1, #xPlayers, 1 do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
					if xPlayer.job.name == 'mafia' then
						TriggerClientEvent('esx_jengiholdup:setBlip', xPlayers[i], Gangs[currentStore].position)	
				end
				end

				TriggerClientEvent('esx:showNotification', _source, _U('started_to_rob', store.nameOfStore))
				
				TriggerClientEvent('esx_jengiholdup:currentlyRobbing', _source, currentStore)
				TriggerClientEvent('esx_jengiholdup:startTimer', _source)
				
				Gangs[currentStore].lastRobbed = os.time()
				robbers[_source] = currentStore

				SetTimeout(store.secondsRemaining * 1000, function()
					if robbers[_source] then
						rob = false
						if xPlayer then
							TriggerClientEvent('esx_jengiholdup:robberyComplete', _source)

							if Config.GiveBlackMoney then
								TriggerEvent('esx_jengiholdup:gianellintehari')
								xPlayer.addAccountMoney('black_money', helari)
							else
								xPlayer.addMoney(helari)
							end
							
							local xPlayers, xPlayer = ESX.GetPlayers(), nil
							for i=1, #xPlayers, 1 do
								xPlayer = ESX.GetPlayerFromId(xPlayers[i])

							if xPlayer.job.name == 'mafia' then
TriggerClientEvent('esx_jengiholdup:xd1', xPlayers[i])
								TriggerClientEvent('esx_jengiholdup:killBlip', xPlayers[i])
								end
							end
						end
					end
				end)
			else
				TriggerClientEvent('esx:showNotification', _source, "Jengiläisiä ei ole tarpeeksi paikalla!")
			end
else 
TriggerClientEvent('esx:showNotification', source, "min_police")
end
		else
			TriggerClientEvent('esx:showNotification', _source, "recently_robbed")
		end

	end
end)


RegisterServerEvent('esx_jengiholdup:gianellintehari')
AddEventHandler('esx_jengiholdup:gianellintehari', function()
TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mafia', function(account)
local xPlayer = ESX.GetPlayerFromId(source)

if account.money >= 0 then
account.removeMoney(tonumber(helari))
		end

	end)
end)