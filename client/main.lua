QBCore = exports['qbx-core']:GetCoreObject()
PlayerJob = {}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
    if PlayerJob.name == "reporter" then
        local blip = AddBlipForCoord(Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z)
        SetBlipSprite(blip, 225)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.6)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Locations["main"].label)
        EndTextCommandSetBlipName(blip)
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    if PlayerJob.name == "reporter" then
        local blip = AddBlipForCoord(Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z)
        SetBlipSprite(blip, 225)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.6)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.Locations["main"].label)
        EndTextCommandSetBlipName(blip)
    end
end)

function TakeOutVehicle(vehicleInfo)
    local coords = Config.Locations["vehicle"].coords
    QBCore.Functions.SpawnVehicle(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "WZNW"..tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, coords.w)
        SetVehicleFuelLevel(veh, 100.0)
        TaskWarpPedIntoVehicle(cache.ped, veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true, false)
        SetVehicleLivery(veh, 2)
        CurrentPlate = QBCore.Functions.GetPlate(veh)
    end, coords, true)
end

function MenuGarage()
    local authorizedVehicles = Config.Vehicles[QBCore.Functions.GetPlayerData().job.grade.level]
    local optionsMenu = {}

    for veh, label in pairs(authorizedVehicles) do
        optionsMenu[#optionsMenu + 1] = {
            title = label,
            event = 'qb-newsjob:client:TakeOutVehicle',
            args = {
                vehicle = veh
            }
        }
    end

    lib.registerContext({
        id = 'weazel_garage_context_menu',
        title = Lang:t("text.weazel_news_vehicles"),
        options = optionsMenu
    })

    lib.showContext('weazel_garage_context_menu')
end

function TakeOutHelicopters(vehicleInfo)
    local coords = Config.Locations["heli"].coords
    QBCore.Functions.SpawnVehicle(vehicleInfo, function(veh)
        SetVehicleNumberPlateText(veh, "WZNW"..tostring(math.random(1000, 9999)))
        SetEntityHeading(veh, coords.w)
        SetVehicleFuelLevel(veh, 100.0)
        TaskWarpPedIntoVehicle(cache.ped, veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true, false)
        SetVehicleLivery(veh, 2)
        CurrentPlate = QBCore.Functions.GetPlate(veh)
    end, coords, true)
end

function MenuHeliGarage()
    local Helicopters = Config.Helicopters[QBCore.Functions.GetPlayerData().job.grade.level]
    local optionsMenu = {}

    for veh, label in pairs(Helicopters) do
        optionsMenu[#optionsMenu + 1] = {
            title = label,
            event = 'qb-newsjob:client:TakeOutHelicopters',
            args = {
                vehicle = veh
            }
        }
    end

    lib.registerContext({
        id = 'weazel_heli_context_menu',
        title = Lang:t("text.weazel_news_helicopters"),
        options = optionsMenu
    })

    lib.showContext('weazel_heli_context_menu')
end

CreateThread(function()
    while true do
        Wait(0)
        if LocalPlayer.state.isLoggedIn then
            local inRange = false
            local boxZone = false
            local pos = GetEntityCoords(cache.ped)
            if PlayerJob.name == "reporter" then
                if #(pos - vector3(Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z)) < 10.0 then
                    inRange = true
                    DrawMarker(2, Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, 0, true, false, false, false)
                    if #(pos - vector3(Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z)) < 1.5 then
                        local function onEnter()
                            if IsPedInAnyVehicle(cache.ped, false) then
                                lib.showTextUI(Lang:t("text.store_vehicle"))
                            else
                                lib.showTextUI(Lang:t("text.vehicles"))
                            end
                        end
                         
                        local function onExit()
                            lib.hideTextUI()
                        end

                        local function inside()
                            if IsPedInAnyVehicle(cache.ped, false) then
                                if IsControlJustReleased(0, 38) then
                                    if IsPedInAnyVehicle(cache.ped, false) then
                                        DeleteVehicle(GetVehiclePedIsIn(cache.ped, false))
                                    end
                                end
                            else
                                if IsControlJustReleased(0, 38) then
                                    MenuGarage()
                                end
                            end
                        end
                        
                        if not VehicleZone then 
                            VehicleZone = lib.zones.box({
                                coords = vec3(Config.Locations["vehicle"].coords.x, Config.Locations["vehicle"].coords.y, Config.Locations["vehicle"].coords.z),
                                size = vec3(4, 4, 4),
                                rotation = 45,
                                debug = Config.DebugZones,
                                inside = inside,
                                onEnter = onEnter,
                                onExit = onExit
                            })
                        end

                        inRange = true
                    end
                elseif  #(pos - vector3(Config.Locations["heli"].coords.x, Config.Locations["heli"].coords.y, Config.Locations["heli"].coords.z)) < 5.0 then
                    inRange = true
                    DrawMarker(2, Config.Locations["heli"].coords.x, Config.Locations["heli"].coords.y, Config.Locations["heli"].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, 0, true, false, false, false)
                    if #(pos - vector3(Config.Locations["heli"].coords.x, Config.Locations["heli"].coords.y, Config.Locations["heli"].coords.z)) < 1.5 then
                        local function onEnter()
                            if IsPedInAnyVehicle(cache.ped, false) then
                                lib.showTextUI(Lang:t("text.store_helicopters"))
                            else
                                lib.showTextUI(Lang:t("text.helicopters"))
                            end
                        end
                         
                        local function onExit()
                            lib.hideTextUI()
                        end

                        local function inside()
                            if IsPedInAnyVehicle(cache.ped, false) then
                                if IsControlJustReleased(0, 38) then
                                    if IsPedInAnyVehicle(cache.ped, false) then
                                        DeleteVehicle(GetVehiclePedIsIn(cache.ped, false))
                                    end
                                end
                            else
                                if IsControlJustReleased(0, 38) then
                                    MenuHeliGarage()
                                end
                            end
                        end
                        
                        if not HeliZone then
                            HeliZone = lib.zones.box({
                                coords = vec3(Config.Locations["heli"].coords.x, Config.Locations["heli"].coords.y, Config.Locations["heli"].coords.z),
                                size = vec3(4, 4, 4),
                                rotation = 267.49,
                                debug = Config.DebugZones,
                                inside = inside,
                                onEnter = onEnter,
                                onExit = onExit
                            })
                        end

                        inRange = true
                    end
                end

                if not inRange then
                    Wait(1000)
                    if VehicleZone then
                        VehicleZone:remove()
                        VehicleZone = nil
                    end
                    if HeliZone then
                        HeliZone:remove()
                        HeliZone = nil
                    end
                end
            else
                Wait(2500)
            end
        else
            Wait(2500)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        local inRange = false
        if LocalPlayer.state.isLoggedIn then
            local pos = GetEntityCoords(cache.ped)
            if #(pos - vector3(Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z)) < 1.5 or #(pos - vector3(Config.Locations["inside"].coords.x, Config.Locations["inside"].coords.y, Config.Locations["inside"].coords.z)) < 1.5 then
                inRange = true
                if #(pos - vector3(Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z)) < 1.5 then
                    local function onEnter()
                        lib.showTextUI(Lang:t("text.enter"))
                    end
                     
                    local function onExit()
                        lib.hideTextUI()
                    end

                    local function inside()
                        if IsControlJustReleased(0, 38) then
                            lib.hideTextUI()
                            DoScreenFadeOut(500)
                            while not IsScreenFadedOut() do
                                Wait(10)
                            end
    
                            SetEntityCoords(cache.ped, Config.Locations["inside"].coords.x, Config.Locations["inside"].coords.y, Config.Locations["inside"].coords.z, false, false, false, false)
                            SetEntityHeading(cache.ped, Config.Locations["inside"].coords.w)
    
                            Wait(100)
    
                            DoScreenFadeIn(1000)
                        end
                    end
                    
                    if not MainEntrance then
                        MainEntrance = lib.zones.box({
                            coords = vec3(Config.Locations["main"].coords.x, Config.Locations["main"].coords.y, Config.Locations["main"].coords.z),
                            size = vec3(4, 4, 4),
                            rotation = 267.49,
                            debug = Config.DebugZones,
                            inside = inside,
                            onEnter = onEnter,
                            onExit = onExit
                        })
                    end

                elseif #(pos - vector3(Config.Locations["inside"].coords.x, Config.Locations["inside"].coords.y, Config.Locations["inside"].coords.z)) < 1.5 then
                    local function onEnter()
                        lib.showTextUI(Lang:t("text.go_outside"))
                    end
                     
                    local function onExit()
                        lib.hideTextUI()
                    end

                    local function inside()
                        if IsControlJustReleased(0, 38) then
                            lib.hideTextUI()
                            DoScreenFadeOut(500)
                            while not IsScreenFadedOut() do
                                Wait(10)
                            end
    
                            SetEntityCoords(cache.ped, Config.Locations["outside"].coords.x, Config.Locations["outside"].coords.y, Config.Locations["outside"].coords.z, false, false, false, false)
                            SetEntityHeading(cache.ped, Config.Locations["outside"].coords.w)
    
                            Wait(100)
    
                            DoScreenFadeIn(1000)
                        end
                    end
                    
                    if not MainExit then
                        MainExit = lib.zones.box({
                            coords = vec3(Config.Locations["inside"].coords.x, Config.Locations["inside"].coords.y, Config.Locations["inside"].coords.z),
                            size = vec3(2, 2, 2),
                            rotation = 245.46,
                            debug = Config.DebugZones,
                            inside = inside,
                            onEnter = onEnter,
                            onExit = onExit
                        })
                    end
                end
            end
        end
        if not inRange then
            Wait(1000)
            if MainEntrance then
                MainEntrance:remove()
                MainEntrance = nil
            end
            if MainExit then
                MainExit:remove()
                MainExit = nil
            end
        end
    end
end)

RegisterNetEvent('qb-newsjob:client:TakeOutVehicle', function(data)
    local vehicle = data.vehicle
    TakeOutVehicle(vehicle)
end)

RegisterNetEvent('qb-newsjob:client:TakeOutHelicopters', function(data)
    local vehicle = data.vehicle
    TakeOutHelicopters(vehicle)
end)
