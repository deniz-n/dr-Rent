----   ____    ____         ----
----  /\  _`\ /\  _`\       ----
----  \ \ \/\ \ \ \L\ \     ----
----   \ \ \ \ \ \ ,  /     ----
----    \ \ \_\ \ \ \\ \    ----
----     \ \____/\ \_\ \_\  ----
----      \/___/  \/_/\/ /  ----

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(0)
      end
end)

Citizen.CreateThread(function()
	Citizen.Wait(100)
	while true do
		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)
		local dstCheck = GetDistanceBetweenCoords(pedCoords, Config.Zones.Coords.x,Config.Zones.Coords.y, Config.Zones.Coords.z, true)
		if dstCheck <= 5.0 then
			local text = "Taşıt Kiralama"
			if dstCheck <= 0.85 then
				text = "Taşıtlara bakmak için [~b~E~s~] Tuşuna bas."
				if IsControlJustPressed(0, 38) then
                    OpenMenu()
				end
			end
			ESX.Game.Utils.DrawText3D(Config.Zones.Coords, text, 0.7)
		end
		if dstCheck >= 13.0 then
			Citizen.Wait(7000)
		else
			Citizen.Wait(5)
		end
	end
end)

function OpenMenu()

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'open_surf_menu', {
		title    = "Taşıtlar",
		align    = 'top-right',
		elements = {
            {   label = 'Bisiklet',    value = 'rent_car'   },
            {   label = 'Kapat',       value = 'exit'       }
		}
	},function(data)
		if data.current.value == 'rent_car' then
			if Config.TakeMoney then
				TriggerServerEvent('dr:RentServer', source)
			else
				TriggerEvent('dr:RentClient', source)
			end
            ESX.UI.Menu.CloseAll()
        elseif data.current.value == 'exit' then
            ESX.UI.Menu.CloseAll()
        end
    end)
end

RegisterNetEvent('dr:RentClient')
AddEventHandler('dr:RentClient', function()
	ESX.Game.SpawnVehicle(Config.Vehicle, Config.Zones.Spawn, Config.Zones.Spawn.h, function(vehiclename)
		if Config.SpawnDriverSeat then
			TaskWarpPedIntoVehicle(PlayerPedId(), vehiclename, -1)
		end
	end)
	if Config.SendAlert then
		exports['mythic_notify']:SendAlert('inform', 'Taşıt Kiraladın.', 4000)
	else
		exports['mythic_notify']:DoHudText('inform', 'Taşıt Kiraladın.', 4000)
	end
end)