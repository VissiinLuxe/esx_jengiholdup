local holdingUp = false
local store = ""
isDead = false
local PlayerData = {}
local blipRobbery = nil
ESX = nil


  
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	PlayerData = ESX.GetPlayerData()
end)




function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
   SetTextFont(4)
   SetTextProportional(1)
   SetTextScale(0.6, 0.6)
   SetTextColour(128, 128, 128, 255)
   SetTextDropshadow(0, 0, 0, 0, 255)
   SetTextEdge(1, 0, 0, 0, 150)
   SetTextDropshadow()
   SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)

end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)





RegisterNetEvent('esx_jengiholdup:currentlyRobbing')
AddEventHandler('esx_jengiholdup:currentlyRobbing', function(currentStore)
	holdingUp, store = true, currentStore
end)

RegisterNetEvent('esx_jengiholdup:killBlip')
AddEventHandler('esx_jengiholdup:killBlip', function()
	RemoveBlip(blipRobbery)
end)


RegisterNetEvent('esx_jengiholdup:xd')
AddEventHandler('esx_jengiholdup:xd', function()
	ESX.ShowNotification('robbery_cancelled_at')
end)

RegisterNetEvent('esx_jengiholdup:xd1')
AddEventHandler('esx_jengiholdup:xd1', function()
	ESX.ShowNotification('robbery_complete_at')
end)





AddEventHandler('esx:onPlayerDeath', function(data)
    isDead = true
    ESX.UI.Menu.CloseAll()
end)

RegisterNetEvent('esx_jengiholdup:tooFar')
AddEventHandler('esx_jengiholdup:tooFar', function()
	holdingUp, store = false, ''
end)


RegisterNetEvent('esx_jengiholdup:setBlip')
AddEventHandler('esx_jengiholdup:setBlip', function(position)
	blipRobbery = AddBlipForCoord(position.x, position.y, position.z)

	SetBlipSprite(blipRobbery, 161)
	SetBlipScale(blipRobbery, 2.0)
	SetBlipColour(blipRobbery, 3)

	PulseBlip(blipRobbery)

	SetBlipFlashes(blipRobbery, true)



	BeginTextCommandSetBlipName("STRING")

    AddTextComponentString(('Kaappia ryöstetään!'))

    EndTextCommandSetBlipName(blipRobbery)
ESX.ShowNotification(' Kaappia ryöstetään ')

end)

RegisterNetEvent('esx_gangholdup:robberycomplete')
AddEventHandler('esx_gangholdup:robberycomplete', function(award)
	holdingup = false
	ESX.ShowNotification(_U('robbery_complete', award))
	store = ""
	incircle = false
end)


RegisterNetEvent('esx_jengiholdup:startTimer')
AddEventHandler('esx_jengiholdup:startTimer', function()
	local timer = Gangs[store].secondsRemaining

	Citizen.CreateThread(function()
		while timer > 0 and holdingUp do
			Citizen.Wait(1000)

			if timer > 0 then
				timer = timer - 1
			end
		end
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			if holdingUp then
				if not ulkopuolella then
					drawTxt(0.66, 1.4, 1.0,1.0,0.4, _U('robbery_timer', timer), 255, 255, 255, 255)
				else
				Citizen.Wait(1000)
			end
		end
	end)
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local playerPos = GetEntityCoords(PlayerPedId(), true)

		for k,v in pairs(Gangs) do
			local storePos = v.position
			local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, storePos.x, storePos.y, storePos.z)

			if distance < Config.Marker.DrawDistance then
				if not holdingUp then
					if distance < 0.5 then
						ESX.ShowHelpNotification(_U('press_to_rob', v.nameOfStore))

						if IsControlJustReleased(0, 38) then
							if PlayerData.job.name == 'police' or PlayerData.job.name == 'mafia' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'taxi' or PlayerData.job.name == 'mechanic' then -- työt jotka eivät voi ryöstää kassakaappia
								ESX.ShowNotification('Läheppäs vittuun siitä!')
							else
							if IsPedArmed(PlayerPedId(), 7) then -- Lyömä aseellakin voi ryöstää
								TriggerServerEvent('esx_jengiholdup:robberyStarted', k)
							else
								ESX.ShowNotification("no_threat")
							end
						end
					end
				end
			end
		end
	end

		if holdingUp then
			local storePos = Gangs[store].position

			if IsPedDeadOrDying(GetPlayerPed(-1)) then -- Jos ryöstäjä kuolee murto keskeytyy
				timer = 0
				TriggerServerEvent('esx_jengiholdup:tooFar', store)
			end

			if Vdist(playerPos.x, playerPos.y, playerPos.z, storePos.x, storePos.y, storePos.z) > Config.MaxDistance - 2 then
				ulkopuolella = true
			else
				ulkopuolella = false
			end

			if Vdist(playerPos.x, playerPos.y, playerPos.z, storePos.x, storePos.y, storePos.z) > Config.MaxDistance then -- Jos poistuu 3 metrin säteeltä niin keskeytyy
				TriggerServerEvent('esx_jengiholdup:tooFar', store)
			end
		end
	end
end)
