Hr = {}
HrFnc = {} 
TriggerServerEvent("plouffe_houserobbery:sendConfig")

RegisterNetEvent("plouffe_houserobbery:getConfig",function(list)
	if list == nil then
		CreateThread(function()
			while true do
				Wait(0)
				Hr = nil
				HrFnc = nil
				ESX = nil
			end
		end)
	else
		Hr = list
		HrFnc:Start()
	end
end)