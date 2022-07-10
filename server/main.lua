local Auth = exports.plouffe_lib:Get("Auth")

CreateThread(function()
    HrFnc:Init()
end)

RegisterNetEvent("plouffe_houserobbery:sendConfig",function()
    local playerId = source
    local registred, key = Auth:Register(playerId)

    if registred then
        local cbArray = Hr
        cbArray.Utils.MyAuthKey = key
        TriggerClientEvent("plouffe_houserobbery:getConfig",playerId, cbArray)
    else
        TriggerClientEvent("plouffe_houserobbery:getConfig",playerId, nil)
    end
end)

RegisterNetEvent("plouffe_houserobbery:registerforjob",function(authkey)
    local playerId = source

    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_houserobbery:registerforjob") then
            if not Server.avaiblePlayers[playerId] then
                Server.avaiblePlayers[playerId] = true
                HrFnc:StartListThread()
            end
        end
    end
end)

RegisterNetEvent("plouffe_houserobbery:acceptjob",function(authkey)
    local playerId = source

    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_houserobbery:acceptjob") then
            Server.acceptedPlayerJobs[playerId] = true
        end
    end
end)

RegisterNetEvent("plouffe_houserobbery:looted",function(name,authkey)
    local playerId = source

    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_houserobbery:looted") then
            HrFnc:LootedZone(playerId,name)
        end
    end
end)

RegisterNetEvent("plouffe_houserobbery:houseready",function(data,nId,houseName,syncdata,authkey)
    local playerId = source

    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_houserobbery:houseready") then
            HrFnc:SetupLoots(data,nId,playerId,houseName)
            TriggerClientEvent("plouffe_houserobbery:exportinterioronsync",-1,syncdata,playerId)
        end
    end
end)

RegisterNetEvent("plouffe_houserobbery:left", function(tier, door, authkey)
    local playerId = source

    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_houserobbery:left") then
            HrFnc:PlayerLeftHouse(playerId, tier, door)
        end
    end
end)

RegisterNetEvent("plouffe_houserobbery:entered", function(tier, door, offset, authkey)
    local playerId = source

    if Auth:Validate(playerId,authkey) then
        if Auth:Events(playerId,"plouffe_houserobbery:entered") then
            HrFnc:PlayerEnteredHouse(playerId, tier, door, offset)
        end
    end
end)

AddEventHandler('playerDropped', function(reason)
    local playerId = source
    Server.avaiblePlayers[playerId] = nil
	Server.onJobPlayers[playerId] = nil
    Server.acceptedPlayerJobs[playerId] = nil
end)