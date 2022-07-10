local Utils = exports.plouffe_lib:Get("Utils")

function HrFnc:Init()
    local data = json.decode(LoadResourceFile(GetCurrentResourceName(), "data/housecoords.json")) or Hr.Houses

    for k,v in pairs(data) do
        for x,y in pairs(data[k].doors) do
            local vecCoords = vector3(y.coords.x,y.coords.y,y.coords.z)
            table.insert(Hr.Houses[k].doors, {coords = vecCoords})
        end
    end

    self:StartCoolDownThread()
end

function HrFnc:GetArrayLenght(array)
    local retval = 0
    
    for k,v in pairs(array) do 
        retval = retval + 1
    end

    return retval
end

function HrFnc:StartListThread()
    if self:GetArrayLenght(Server.avaiblePlayers) > 1 then
        return
    end

    CreateThread(function()
        while self:GetArrayLenght(Server.avaiblePlayers) > 0 do
            local sleepTimer = math.ceil(math.random(1000, (1000 * 60)))
            Wait(sleepTimer)
            self:GetRandomPlayer()
        end
    end)
end

function HrFnc:GenerateNewRob()
    local randi = math.random(1,100)
    local tier = "low"
    local doorId = 0

    if randi <= 15 then
        tier = "high"
    elseif randi <= 35 then 
        tier = "medium"
    end

    doorId = math.random(1,#Hr.Houses[tier].doors)

    if Server.ignoredHouse[tier][doorId] then
        return nil, nil
    end
    
    Server.ignoredHouse[tier][doorId] = true

    table.insert(Server.cooldown, {tier = tier, doorId = doorId, time = os.time()})

    return tier, doorId
end

function HrFnc:StartCoolDownThread()
    CreateThread(function()
        while #Server.cooldown < 0 do
            Wait(Server.cooldownThreadTimer)
            local currentTime = os.time()
            local remove = {}

            for k,v in pairs(Server.cooldown) do
                local timeCheck = currentTime - v.time
                if timeCheck >= Server.cooldownClearTimer then
                    remove[k] = {tier = v.tier, doorI = v.doorId}
                end
            end

            for k,v in pairs(remove) do
                Server.cooldown[k] = nil
                Server.ignoredHouse[v.tier][v.doorId] = nil
                
                if GlobalState[("houserobbery_%s_%s"):format(v.tier,v.doorId)] then
                    GlobalState[("houserobbery_%s_%s"):format(v.tier,v.doorId)] = nil
                end
            end
        end
    end)
end

function HrFnc:GetRandomPlayer()
    local randi = math.random(1, self:GetArrayLenght(Server.avaiblePlayers))
    local id = 0
    local tier, doorId = HrFnc:GenerateNewRob()

    if not tier and not doorId then
        return
    end

    for k,v in pairs(Server.avaiblePlayers) do
        id = id + 1

        if id == randi then
            Server.avaiblePlayers[k] = nil
            self:ProccesRandomPlayer(k, tier, doorId)
            break
        end
    end
end

function HrFnc:ProccesRandomPlayer(playerId, tier, doorId)
    local player = exports.ooc_core:getPlayerFromId(playerId)
    local phoneNumber = player and player.phone_number

    if not phoneNumber then
        return
    end
    
    local house = self:CreateHouse(tier, doorId)
    local messageData = {senderNumber = "Allen", targetNumber = tostring(phoneNumber), message = "J'ai du travail pour toi utilise /housejob pour le mettre sur ton gps"}
    
    TriggerClientEvent("plouffe_houserobbery:sendjob", -1, playerId, house)

    exports.npwd:emitMessage(messageData)
end

function HrFnc:GenerateRandomLoot(tier,type)
    local itemIndex = math.random(1,#Hr.Loots[tier][type])
    local randi = math.random(1,10)
    local itemInfo = Hr.Loots[tier][type][itemIndex]

    if itemInfo.chances <= randi then
        return itemInfo
    end

    return nil
end

function HrFnc:LootedZone(playerId,name)
    if Server.lootables[name] and Server.lootables[name].looted == false then
        Server.lootables[name].looted = true

        local tier = Server.lootables[name].tier
        local type = Server.lootables[name].type
        local loot = HrFnc:GenerateRandomLoot(tier,type)

        if not loot then
            Server.lootables[name].looted = false
            Utils:Notify(playerId,"Vous n'avez rien trouver, continuer de chercher...")
            return 
        end
        
        exports.ooc_core:addItem(playerId, loot.item, loot.amount, loot.meta)
    end
end

function HrFnc:GenerateRandomShell(index)
    return math.random(1, #Hr.Houses[index].shells)
end

function HrFnc:CreateHouse(tier, doorId)
    local shell = HrFnc:GenerateRandomShell(tier)
    local entryCoords = Hr.Houses[tier].doors[doorId].coords
    local offSets = Hr.Houses[tier].shells[shell].offSets
    local pedData = Hr.Houses[tier].shells[shell].ped
    local randi = math.random(0,10)

    Server.houseData[tier][doorId] = {
        dog = randi > pedData.dogChances and true or nil,
        owner = randi > pedData.ownerChances and true or nil,
        coords = pedData.coords,
        playersInHouse = 0
    }

    Server.houseData[tier][doorId] = {
        dog = true,
        owner = true,
        coords = pedData.coords,
        playersInHouse = 0
    }

    Server.createHouse[tier][doorId] = {
        {
            name = tostring(tier)..tostring(doorId)..tostring(shell).."entry",
            coords = entryCoords,
            maxDst = 1.0,
            isZone = true,
            nuiLabel = "Lockpick",
            aditionalParams = {
                type = "entry", 
                name = tostring(tier)..tostring(doorId)..tostring(shell).."entry", 
                tier = tier, 
                doorId = doorId, 
                shell = shell,
                entryCoords = entryCoords
            },
            keyMap = {
                checkCoordsBeforeTrigger = true,
                onRelease = true,
                releaseEvent = "plouffe_houserobbery:action",
                key = "M"
            }
        } 
    }

    for k,v in pairs(offSets) do
        local label = "Fouiller"
        local name = ("%s_%s_%s_%s"):format(tier, doorId, shell, k)
        
        if v.type == "exit" then
            label = "Sortir"
        else
            Server.lootables[name] = {looted = false, tier = tier, type = v.type}
        end

        local this = {
            name = name,
            coords = nil,
            maxDst = 1.0,
            isZone = true,
            nuiLabel = label,
            aditionalParams = {
                type = v.type, 
                name = name, 
                tier = tier, 
                doorId = doorId, 
                shell = shell,
                entryCoords = entryCoords,
                offSets = v.coords
            },
            keyMap = {
                onRelease = true,
                releaseEvent = "plouffe_houserobbery:action",
                key = "E"
            }
        }

        table.insert(Server.createHouse[tier][doorId], this)
    end
    
    return Server.createHouse[tier][doorId]
end

function HrFnc:CreatePed(model,coords,tier,door)
    local ped = CreatePed(
        1, 
		model, 
		coords.x, 
		coords.y, 
		coords.z, 
		0.0, 
		true,
		true
    )
    
    Wait(500)
    
    Entity(ped).state[("houserobbery_%s_%s"):format(tier,door)] = true
    
    return ped
end

function HrFnc:PlayerEnteredHouse(playerId, tier, door, offset)
    local data = Server.houseData[tier][door]

    if not data then
        return
    end

    Server.houseData[tier][door].playersInHouse = Server.houseData[tier][door].playersInHouse + 1

    -- Server.houseData[tier][door].dogEntity = not data.dogEntity and self:CreatePed(
	-- 	joaat(Hr.Peds.dog[math.random(1,#Hr.Peds.dog)]), 
	-- 	offset, 
    --     tier, 
    --     door
    -- ) or data.dogEntity

    -- Server.houseData[tier][door].ownerEntity = not data.ownerEntity and self:CreatePed(
	-- 	joaat(Hr.Peds.owners[math.random(1,#Hr.Peds.owners)]), 
	-- 	offset, 
    --     tier, 
    --     door
    -- ) or data.ownerEntity
end

function HrFnc:PlayerLeftHouse(playerId, tier, door)
    local data = Server.houseData[tier][door]
    
    if not data then
        return
    end

    Server.houseData[tier][door].playersInHouse = data.playersInHouse -1
    
    if Server.houseData[tier][door].playersInHouse <= 0 then
        -- DeleteEntity(data.ownerEntity)
        -- DeleteEntity(data.dogEntity)
        -- Server.houseData[tier][door].ownerEntity = nil
        -- Server.houseData[tier][door].dogEntity = nil
    end
end