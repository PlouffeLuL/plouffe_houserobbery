local Utils = exports.plouffe_lib:Get("Utils")

function HrFnc:Start()
    TriggerEvent('ooc_core:getCore', function(Core) 
        while not Core.Player:IsPlayerLoaded() do
            Wait(500)
        end
    
        Hr.Player = Core.Player:GetPlayerData()

        self:RegisterAllEvents()
        self:ExportsAllZones()
    end)
end

function HrFnc:ExportsAllZones()
    for k,v in pairs(Hr.Coords) do
        local this = v
        this.aditionalParams = {zone = k}
        exports.plouffe_lib:ValidateZoneData(this)
    end
end

function HrFnc:RegisterAllEvents()    
    AddEventHandler('plouffe_lib:setGroup', function(data)
        Hr.Player[data.type] = data
    end)
    
    RegisterNetEvent("plouffe_lib:inVehicle", function(inVehicle, vehicleId)
        Hr.Utils.inCar = inVehicle
        Hr.Utils.carId = vehicleId
    end)

    RegisterNetEvent("plouffe_houserobbery:register", function()
        self:Register()
    end)
    
    RegisterNetEvent("plouffe_houserobbery:sendjob", function(owner,data)
        if tonumber(owner) == tonumber(GetPlayerServerId(PlayerId())) then
            self.gps = {x = data[1].aditionalParams.entryCoords.x, y = data[1].aditionalParams.entryCoords.y}
        end
        
        self:ExportThisHouse(data)
    end)
    
    RegisterNetEvent("plouffe_houserobbery:exportinterioronsync", function(data,source)
        self:ExportInteriorOnSync(data,source)
    end)
    
    RegisterNetEvent("plouffe_houserobbery:syncZoneDestroy", function(data,nid)
        self:DestroyHouse(data,nid)
    end)
    
    RegisterNetEvent("plouffe_houserobbery:action", function(p)
        self:Action(p)
    end)    

    RegisterCommand("housejob", function()
        if not self.gps then
            return
        end

        SetNewWaypoint(self.gps.x, self.gps.y)
        Utils:Notify("Gps placé, soyez discret !")
    end)
end

function HrFnc:ExportThisHouse(house)
    local data = house[1]
    local tempObj = self:CreateModel(Hr.Houses[data.aditionalParams.tier].shells[data.aditionalParams.shell].model, vector3(data.aditionalParams.entryCoords.x,data.aditionalParams.entryCoords.y,-100.0), true)

    for k,v in pairs(house) do
        if not v.coords then
            local offSet = GetOffsetFromEntityInWorldCoords(tempObj,v.aditionalParams.offSets.x,v.aditionalParams.offSets.y,v.aditionalParams.offSets.z)
            v.coords = offSet
            v.aditionalParams.offSetCoords = offSet
        end

        if self:IsPolice() and v.aditionalParams.type == "entry" then
            v.nuiLabel = "Entré"
        end

        exports.plouffe_lib:ValidateZoneData(v)
        Hr.SavedNames[v.name] = {time = GetGameTimer()}

        self:ClearOutDatedZone()
    end

    DeleteEntity(tempObj)
end

function HrFnc:Action(params)
    if Hr.Utils.inCar then
        return 
    end

    Hr.Utils.ped = PlayerPedId()
    Hr.Utils.pedCoords = GetEntityCoords(Hr.Utils.ped)

    if params.type == "entry" then
        Hr.Utils.houseEntry = Hr.Utils.pedCoords
        self:Enter(params)
    elseif params.type == "exit" then
        self:Exit(params)
    elseif params.type == "smallcabinet" or params.type == "cabinet" or params.type == "largecabinet" then
        self:Steal(params)
    end
end

function HrFnc:GetItemCount(item)
    local count = exports.ox_inventory:Search(2, item)
    count = count and count or 0
    return count
end

function HrFnc:Exit(params)
    if Hr.Utils.inCar then
        return 
    end
    
    RemoveStateBagChangeHandler(Hr.Utils.bagHandler)

    Hr.Utils.isInHouse = false
    Hr.Utils.hasSendAlert = false
    
    Utils:FadeOut(1000,true)

    exports.plouffe_lib:ChangeWeatherSync(true)
    exports.plouffe_lib:ChangeTimeSync(true)
    exports.plouffe_lib:Refresh(true, true)

    SetEntityCoords(Hr.Utils.ped, params.entryCoords.x,params.entryCoords.y,params.entryCoords.z)
    TriggerServerEvent("plouffe_houserobbery:left", params.tier, params.doorId, Hr.Utils.MyAuthKey)
    Utils:FadeIn(1000,true)
end

function HrFnc:SetInHouse(params)
    self:CreateModel(Hr.Houses[params.tier].shells[params.shell].model, vector3(params.entryCoords.x,params.entryCoords.y, - 100.0))
    Hr.Utils.houseEntry = params.entryCoords
    
    Utils:FadeOut(1000,true)

    exports.plouffe_lib:ChangeWeatherSync(false)
    exports.plouffe_lib:ChangeTimeSync(false)

    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypePersist("EXTRASUNNY")
    SetWeatherTypeNow("EXTRASUNNY")
    SetWeatherTypeNowPersist("EXTRASUNNY")

    NetworkOverrideClockTime(22, 22, 0)

    local offSets = Hr.Houses[params.tier].shells[params.shell].offSets[1].coords
    local entryCoords = GetOffsetFromEntityInWorldCoords(Hr.Utils.currentHouseId,offSets.x,offSets.y,offSets.z)
    local pedOffset = Hr.Houses[params.tier].shells[params.shell].ped.coords
    local pedSpawnOffset = GetOffsetFromEntityInWorldCoords(Hr.Utils.currentHouseId, pedOffset.x, pedOffset.y, pedOffset.z)
    
    Hr.Utils.bagHandler = AddStateBagChangeHandler(("houserobbery_%s_%s"):format(params.tier,params.doorId) ,nil, function(bagName,key,value,reserved,replicated)
        local id = bagName:gsub("entity:", "")
        id = tonumber(id)
        local entity = NetworkGetEntityFromNetworkId(id)        
        local hasControl = Utils:AssureEntityControl(entity, 1000)
        
        if not hasControl then
            return
        end

        TaskCombatPed(entity, PlayerPedId(), 0, 16)
        SetPedKeepTask(entity, true)
    end)

    SetEntityCoords(Hr.Utils.ped, entryCoords.x,entryCoords.y,entryCoords.z-0.8)
    Wait(100)
    TriggerServerEvent("plouffe_houserobbery:entered", params.tier, params.doorId, pedSpawnOffset, Hr.Utils.MyAuthKey)
    Hr.Utils.isInHouse = true
    Hr.Utils.hasSendAlert = false


    Utils:FadeIn(1000,true)
end

function HrFnc:Enter(params)
    if Hr.Utils.inCar then
        return 
    end
    
    if self:IsPolice() then
        return self:SetInHouse(params)
    end

    local count = self:GetItemCount("lockpick")

    if count <= 0 then
        return Utils:Notify("Vous n'avez pas le néscésaire pour entré")
    end

    local lockpickSucces = false

    exports.lockpicking:StartMinigame(1, 50, 250, 10, function(didWin) 
        lockpickSucces = didWin

        if not didWin then 
            ExecuteCommand("cancelprogress")
        end
    end,{})

    Utils:ProgressCircle({
        name = "lockpickking_fucking_shit_house",
        duration = 15000,
        label = 'En cours',
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "veh@break_in@0h@p_m_one@",
            anim = "low_force_entry_ds",
            flags = 49,
        }
    }, function(cancelled)
        if not cancelled and lockpickSucces then
            self:SetInHouse(params)
            self:InitialInhouseThread()
        end
    end)
end

function HrFnc:Steal(params)
    if self:IsPolice() then
        return
    end

    local doSearchBar, amount, minspeed, maxspeed = self:GetSearchBarInfo(params.tier)

    Hr.Utils.ped = PlayerPedId()
    Hr.Utils.pedCoords = GetEntityCoords(Hr.Utils.ped)
    Hr.Utils.lockpickSucces = false

    Utils:ProgressCircle({
        name = "searching_dumb_house",
        duration = 15000,
        label = 'Recherche en cours',
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "amb@prop_human_bum_bin@base",
            anim = "base",
            flags = 49,
        }
    }, function(cancelled)
        if not cancelled then
            if (doSearchBar and Hr.Utils.lockpickSucces) or not doSearchBar then
                TriggerServerEvent("plouffe_houserobbery:looted",params.name,Hr.Utils.MyAuthKey)
                self:WaitAndDestroyZone(params.name)
            end
        end
    end)

    if doSearchBar then
        exports.lockpicking:StartMinigame(amount,minspeed,maxspeed,10,function(didWin) 
            Hr.Utils.lockpickSucces = didWin
            if not didWin then 
                ExecuteCommand("cancelprogress")
                exports.plouffe_status:Add("Stress", 50)

                if math.random(1,100) < 35 then
                    Hr.Utils.hasSendAlert = true
                    exports.plouffe_dispatch:SendAlert('Houserob')
                end
            end
        end,{})
    end
end

function HrFnc:GetSearchBarInfo(tier)
    local searchBar = math.random(1,100)
    if tier == "low" then
        if searchBar <= 20 then
            return true, math.random(1,5), math.random(75,100), math.random(100,150)
        end
    elseif tier == "medium" then
        if searchBar <= 50 then
            return true, math.random(1,5), math.random(100,150), math.random(150,200)
        end
    elseif tier == "high" then
        return true, math.random(1,5), math.random(200,250), math.random(250,300)
    end
end

function HrFnc:InitialInhouseThread()
    CreateThread(function()
        while Hr.Utils.isInHouse do
            Wait(100)
            local currentSpeed = GetEntitySpeed(Hr.Utils.ped)
            Hr.Utils.ped = PlayerPedId()

            ClearOverrideWeather()
            ClearWeatherTypePersist()
            SetWeatherTypePersist("EXTRASUNNY")
            SetWeatherTypeNow("EXTRASUNNY")
            SetWeatherTypeNowPersist("EXTRASUNNY")
            NetworkOverrideClockTime(22, 22, 0)
        
            if not Hr.Utils.hasSendAlert and NetworkGetTalkerProximity() > 3.5 and NetworkIsPlayerTalking(PlayerId()) == 1 then
                Hr.Utils.hasSendAlert = true
                exports.plouffe_dispatch:SendAlert('Houserob')
            end

            if currentSpeed > 1.74 then
                Wait(200)
                if GetEntitySpeed(Hr.Utils.ped) > 1.74 and not Hr.Utils.hasSendAlert then
                    Hr.Utils.hasSendAlert = true
                    exports.plouffe_dispatch:SendAlert('Houserob')
                end
            end
        end
    end)
end

function HrFnc:Register() 
    -- ExecuteCommand("e phone")
    Utils:ProgressCircle({
        name = "starting_house_robbery",
        duration = 7500,
        label = "Enregistrement en cours",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }
    }, function(cancelled)
        if not cancelled then
            TriggerServerEvent("plouffe_houserobbery:registerforjob",Hr.Utils.MyAuthKey)
        end
        -- ExecuteCommand("e c")
    end)
end

function HrFnc:CreateModel(model,coords,temp)
    local obj = Utils:CreateProp(model,coords, 0.0, false, false)

    FreezeEntityPosition(obj,true)  

    Hr.Utils.currentHouseId = obj

    if not temp then
        table.insert(Hr.Props, obj)
    end

    return obj
end

function HrFnc:WaitAndDestroyZone(name)
    -- Hr.Utils.ped = PlayerPedId()
    -- Hr.Utils.pedCoords = GetEntityCoords(Hr.Utils.ped)

    -- CreateThread(function()
    --     while #(Hr.Utils.pedCoords - GetEntityCoords(PlayerPedId())) <= 1.2 do
    --         Wait(0)
    --     end
        exports.plouffe_lib:DestroyZone(name)
    -- end)
end

function HrFnc:IsPolice()
    for k,v in pairs(Hr.Utils.policeJobs) do
        if Hr.Player.job.name == v then
            return true
        end
    end
    return false
end

function HrFnc:ClearOutDatedZone()
    if Utils:GetArrayLength(Hr.SavedNames) > 1 then
        return
    end

    CreateThread(function()
        local maxTime = 1000 * 60 * 30
        local sleepTimer = 1000 * 60
        
        while Utils:GetArrayLength(Hr.SavedNames) > 0 do
            Wait(sleepTimer)
            
            local time = GetGameTimer()
            local removed = {}
    
            for k,v in pairs(Hr.SavedNames) do
                if time - v.time > maxTime then
                    removed[k] = true
                    exports.plouffe_lib:DestroyZone(k)
                end
            end
    
            for k,v in pairs(removed) do
                Hr.SavedNames[k] = nil
            end
        end
    end)
end

exports("Register",HrFnc.Register)