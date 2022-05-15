
attachKey = 51 -- Index number for attach key - http://docs.fivem.net/game-references/controls/
attachKeyName = "~INPUT_CONTEXT~"

function GetVehicleInDirection(cFrom, cTo)
    local rayHandle = CastRayPointToPoint(cFrom.x, cFrom.y, cFrom.z, cTo.x, cTo.y, cTo.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
    return vehicle
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local veh = GetVehiclePedIsIn(ped)
        if veh ~= nil then
            for i = 1, #Config.Trailers do
            if GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == Config.Trailers[i]['boat']  then -- After a few hours here at 4am GetDisplayNameFromVehicleModel() got it working well :P
                local belowFaxMachine = GetOffsetFromEntityInWorldCoords(veh, 1.0, 0.0, -1.0)
				local boatCoordsInWorldLol = GetEntityCoords(veh)
                local trailerLoc = GetVehicleInDirection(boatCoordsInWorldLol, belowFaxMachine)
                
				if GetDisplayNameFromVehicleModel(GetEntityModel(trailerLoc)) == Config.Trailers[i]['trailer'] then -- Is there a trailer????
                    if IsEntityAttached(veh) then -- Is boat already attached?
                        if IsControlJustReleased(1, attachKey) then -- detach
							AttachEntityToEntity(veh, trailerLoc, 20, Config.Trailers[i]['dropOffset'].x, Config.Trailers[i]['dropOffset'].y, Config.Trailers[i]['dropOffset'].z, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
							DetachEntity(veh, true, true)
						end
                        Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING") -- BeginTextCommandDisplayHelp()
						Citizen.InvokeNative(0x5F68520888E69014, "Press " .. attachKeyName .. " to detach boat.") -- AddTextComponentScaleform()
						Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1) -- EndTextCommandDisplayHelp()
                    else
                        if IsControlJustReleased(1, attachKey) then -- Attach
							AttachEntityToEntity(veh, trailerLoc, 20, Config.Trailers[i]['position'].x, Config.Trailers[i]['position'].y, Config.Trailers[i]['position'].z, 0.0, 0.0, 0.0, false, false, true, false, 20, true)
                        end
						Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING") -- BeginTextCommandDisplayHelp()
						Citizen.InvokeNative(0x5F68520888E69014, "Press " .. attachKeyName .. " to attach boat.") -- AddTextComponentScaleform()
						Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1) -- EndTextCommandDisplayHelp()
					end
                end
            end
        end
        end
    end
end)