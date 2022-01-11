-- Based on es_carwash by 'EssentialMode 5 CarWash by TheSpartaPT.' --
-- Modified a bit by Calm Producions
-- RECOMMEND-THAT-YOU-DO-NOT-EDIT-BELLOW-THIS-LINE--

Key = 201 -- ENTER

vehicleWashStation = {
	{-699.6325,  -932.7043,  17.0139},
	{26.5906,  -1392.0261,  27.3634},
	{167.1034,  -1719.4704,  27.2916},
	{-74.5693,  6427.8715,  29.4400},
	{1362.5385, 3592.1274, 33.9211}
}


Citizen.CreateThread(function ()
	Citizen.Wait(0)
	for i = 1, #vehicleWashStation do
		garageCoords = vehicleWashStation[i]
		stationBlip = AddBlipForCoord(garageCoords[1], garageCoords[2], garageCoords[3])
		SetBlipSprite(stationBlip, 100) -- 100 = carwash
		SetBlipColour(stationBlip, 2) -- 0 White, 1 Red, 2 Green, 3 Blue etc.
		SetBlipAsShortRange(stationBlip, true)
		SetBlipDisplay(stationBlip, 2) -- 0 Doesn't showup ever. 
										--1 Doesn't showup ever anywhere. 
										--2 Shows on both main map and minimap 
										--3&4 Main map only 
										--5 shows on minimap only 
										--6 shows on both 
										--7 Doesn't showup 
										--8 both not selectable
										--9 minimap only 
										--10 both not selectable
										--Rockstar seem to only use 0, 2, 3, 4, 5 and 8 in the decompiled scripts.
	end
    return
end)

function es_carwash_DrawSubtitleTimed(m_text, showtime)
	SetTextEntry_2('STRING')
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

function es_carwash_DrawNotification(m_text)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(m_text)
	DrawNotification(true, false)
end

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)
		if IsPedSittingInAnyVehicle(PlayerPedId()) then 
			for i = 1, #vehicleWashStation do
				garageCoords2 = vehicleWashStation[i]
				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), garageCoords2[1], garageCoords2[2], garageCoords2[3], true ) < 20 then
					DrawMarker(1, garageCoords2[1], garageCoords2[2], garageCoords2[3], 0, 0, 0, 0, 0, 0, 5.0, 5.0, 2.0, 0, 157, 0, 155, 0, 0, 2, 0, 0, 0, 0)
					if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), garageCoords2[1], garageCoords2[2], garageCoords2[3], true ) < 5 then
						es_carwash_DrawSubtitleTimed("Press [~g~ENTER~s~] to wash your vehicle!")
						if IsControlJustPressed(1, Key) then
							TriggerServerEvent('es_carwash:checkmoney')
						end
					end
				end
			end
		end
	end
end)

RegisterNetEvent('es_carwash:success')
AddEventHandler('es_carwash:success', function (price)
	WashDecalsFromVehicle(GetVehiclePedIsUsing(PlayerPedId()), 1.0)
	SetVehicleDirtLevel(GetVehiclePedIsUsing(PlayerPedId()))
	es_carwash_DrawNotification("Your vehicle was ~y~cleaned~s~! ~g~-$" .. price .. "~s~!")
end)

RegisterNetEvent('es_carwash:notenoughmoney')
AddEventHandler('es_carwash:notenoughmoney', function (moneyleft)
	es_carwash_DrawNotification("~h~~r~You don't have enough money! $" .. moneyleft .. " left!")
end)

RegisterNetEvent('es_carwash:free')
AddEventHandler('es_carwash:free', function ()
	WashDecalsFromVehicle(GetVehiclePedIsUsing(PlayerPedId()), 1.0)
	SetVehicleDirtLevel(GetVehiclePedIsUsing(PlayerPedId()))
	es_carwash_DrawNotification("Your vehicle was ~y~cleaned~s~ for free!")
end)
