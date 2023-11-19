local config = require 'config.client'
IsLoggedIn = LocalPlayer.state.isLoggedIn
local VehicleZone, HeliZone, mainEntrance, mainExit, heliEntrance, heliExit = nil, nil, nil, nil, nil, nil

if config.useBlips then
    CreateThread(function()
        local blip = AddBlipForCoord(config.locations.mainEntrance.coords.x, config.locations.mainEntrance.coords.y, config.locations.mainEntrance.coords.z)
        SetBlipSprite(blip, 459)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 1)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(config.locations.mainEntrance.label)
        EndTextCommandSetBlipName(blip)
    end)
end

local function takeOutVehicle(vehicleInfo)
    if QBX.PlayerData.job.name == 'reporter' then
        local coords = config.locations.vehicleStorage.coords
        if not coords then
            local plyCoords = GetEntityCoords(cache.ped)
            coords = vec4(plyCoords.x, plyCoords.y, plyCoords.z, GetEntityHeading(cache.ped))
        end

        local netId = lib.callback.await('qbx_newsjob:server:spawnVehicle', false, vehicleInfo, coords, Lang:t('info.news_plate')..tostring(math.random(1000, 9999)), true)
        local timeout = 100
        while not NetworkDoesEntityExistWithNetworkId(netId) and timeout > 0 do
            Wait(10)
            timeout = timeout - 1
        end
        local veh = NetToVeh(netId)
        if veh == 0 then
            exports.qbx_core:Notify(Lang:t('error.cant_spawn_vehicle'), 'error')
            return
        end
        SetVehicleFuelLevel(veh, 100.0)
        SetVehicleEngineOn(veh, true, true, false)
        SetVehicleLivery(veh, 2)
        CurrentPlate = GetPlate(veh)
    end
end

local function menuVehicleGarage()
    local authorizedVehicles = config.authorizedVehicles[QBX.PlayerData.job.grade.level]
    local optionsMenu = {}

    for veh, label in pairs(authorizedVehicles) do
        optionsMenu[#optionsMenu + 1] = {
            title = label,
            onSelect = function()
                takeOutVehicle(veh)
            end,
        }
    end

    lib.registerContext({
        id = 'weazel_garage_context_menu',
        title = Lang:t('info.weazel_news_vehicles'),
        options = optionsMenu
    })

    lib.showContext('weazel_garage_context_menu')
end

local function takeOutHeli(vehicleInfo)
    if QBX.PlayerData.job.name == 'reporter' then
        local coords = config.locations.helicopterStorage.coords.xyz
        if not coords then
            local plyCoords = GetEntityCoords(cache.ped)
            coords = vec4(plyCoords.x, plyCoords.y, plyCoords.z, GetEntityHeading(cache.ped))
        end

        local netId = lib.callback.await('qbx_newsjob:server:spawnHeli', false, vehicleInfo, coords, Lang:t('info.news_plate')..tostring(math.random(1000, 9999)), true)
        local timeout = 100
        while not NetworkDoesEntityExistWithNetworkId(netId) and timeout > 0 do
            Wait(10)
            timeout = timeout - 1
        end
        local veh = NetToVeh(netId)
        if veh == 0 then
            exports.qbx_core:Notify(Lang:t('error.cant_spawn_vehicle'), 'error')
            return
        end
        SetVehicleFuelLevel(veh, 100.0)
        SetVehicleEngineOn(veh, true, true, false)
        CurrentPlate = GetPlate(veh)
    end
end

local function menuHeliGarage()
    local helicopters = config.authorizedhelicopters[QBX.PlayerData.job.grade.level]
    local optionsMenu = {}

    for veh, label in pairs(helicopters) do
        optionsMenu[#optionsMenu + 1] = {
            title = label,
            onSelect = function()
                takeOutHeli(veh)
            end,
        }
    end

    lib.registerContext({
        id = 'weazel_heli_context_menu',
        title = Lang:t('info.weazel_news_helicopters'),
        options = optionsMenu
    })

    lib.showContext('weazel_heli_context_menu')
end

CreateThread(function()
    while true do
        Wait(0)
        if IsLoggedIn then
            local inRange = false
            local pos = GetEntityCoords(cache.ped)
            if QBX.PlayerData.job.name == 'reporter' then
                if #(pos - vector3(config.locations.vehicleStorage.coords.xyz)) < 10.0 then
                    inRange = true
                    DrawMarker(2, config.locations.vehicleStorage.coords.x, config.locations.vehicleStorage.coords.y, config.locations.vehicleStorage.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, 0, true, false, false, false)
                    if #(pos - vector3(config.locations.vehicleStorage.coords.x, config.locations.vehicleStorage.coords.y, config.locations.vehicleStorage.coords.z)) < 1.5 then
                        local function onEnter()
                            if cache.vehicle then
                                lib.showTextUI(Lang:t('info.store_vehicle'))
                            else
                                lib.showTextUI(Lang:t('info.vehicles'))
                            end
                        end

                        local function onExit()
                            lib.hideTextUI()
                        end

                        local function inside()
                            if IsControlJustReleased(0, 38) then
                                if cache.vehicle then
                                    DeleteVehicle(cache.vehicle)
                                else
                                    menuVehicleGarage()
                                end
                            end
                        end
                        if not VehicleZone then
                            VehicleZone = lib.zones.box({
                                coords = vec3(config.locations.vehicleStorage.coords.xyz),
                                size = vec3(6.0, 4.0, 4.0),
                                rotation = 0.0,
                                debug = config.debugZones,
                                inside = inside,
                                onEnter = onEnter,
                                onExit = onExit
                            })
                        end

                        inRange = true
                    end
                elseif #(pos - vector3(config.locations.helicopterStorage.coords.xyz)) < 5.0 then
                    inRange = true
                    DrawMarker(2, config.locations.helicopterStorage.coords.x, config.locations.helicopterStorage.coords.y, config.locations.helicopterStorage.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 200, 200, 222, false, false, 0, true, false, false, false)
                    if #(pos - vector3(config.locations.helicopterStorage.coords.xyz)) < 1.5 then
                        local function onEnter()
                            if cache.vehicle then
                                lib.showTextUI(Lang:t('info.store_helicopters'))
                            else
                                lib.showTextUI(Lang:t('info.helicopters'))
                            end
                        end

                        local function onExit()
                            lib.hideTextUI()
                        end

                        local function inside()
                            if IsControlJustReleased(0, 38) then
                                if cache.vehicle then
                                    DeleteVehicle(cache.vehicle)
                                else
                                    menuHeliGarage()
                                end
                            end
                        end

                        if not HeliZone then
                            HeliZone = lib.zones.box({
                                coords = vec3(config.locations.helicopterStorage.coords.xyz),
                                size = vec3(4, 4, 4),
                                rotation = 267.49,
                                debug = config.debugZones,
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
        if IsLoggedIn then
            local pos = GetEntityCoords(cache.ped)
            if #(pos - vector3(config.locations.mainEntrance.coords.xyz)) < 1.5 or #(pos - vector3(config.locations.inside.coords.xyz)) < 1.5 then
                inRange = true
                if #(pos - vector3(config.locations.mainEntrance.coords.xyz)) < 1.5 then
                    local function onEnter()
                        lib.showTextUI(Lang:t('info.enter'))
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

                            SetEntityCoords(cache.ped, config.locations.inside.coords.x, config.locations.inside.coords.y, config.locations.inside.coords.z, false, false, false, false)
                            SetEntityHeading(cache.ped, config.locations.inside.coords.w)

                            Wait(100)

                            DoScreenFadeIn(1000)
                        end
                    end

                    if not mainEntrance then
                        mainEntrance = lib.zones.box({
                            coords = vec3(config.locations.mainEntrance.coords.xyz),
                            size = vec3(4, 4, 4),
                            rotation = 267.49,
                            debug = config.debugZones,
                            inside = inside,
                            onEnter = onEnter,
                            onExit = onExit
                        })
                    end

                elseif #(pos - vector3(config.locations.inside.coords.xyz)) < 1.5 then
                    local function onEnter()
                        lib.showTextUI(Lang:t('info.go_outside'))
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

                            SetEntityCoords(cache.ped, config.locations.outside.coords.x, config.locations.outside.coords.y, config.locations.outside.coords.z, false, false, false, false)
                            SetEntityHeading(cache.ped, config.locations.outside.coords.w)

                            Wait(100)

                            DoScreenFadeIn(1000)
                        end
                    end

                    if not mainExit then
                        mainExit = lib.zones.box({
                            coords = vec3(config.locations.inside.coords.xyz),
                            size = vec3(1.0, 2.25, 3.45),
                            rotation = 340.0,
                            debug = config.debugZones,
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
            if mainEntrance then
                mainEntrance:remove()
                mainEntrance = nil
            end
            if mainExit then
                mainExit:remove()
                mainExit = nil
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        local inRange = false

        if IsLoggedIn then
            local pos = GetEntityCoords(cache.ped)
            if #(pos - vector3(config.locations.helicopterStorageEntrance.coords.xyz)) < 1.5 or #(pos - vector3(config.locations.helicopterStorageExit.coords.xyz)) < 1.5 then
                inRange = true
                if #(pos - vec3(config.locations.helicopterStorageEntrance.coords.xyz)) < 1.5 then
                    local function onEnter()
                        lib.showTextUI(Lang:t('info.heli_enter'))
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

                            SetEntityCoords(cache.ped, config.locations.helicopterStorageExit.coords.x, config.locations.helicopterStorageExit.coords.y, config.locations.helicopterStorageExit.coords.z, false, false, false, false)
                            SetEntityHeading(cache.ped, config.locations.helicopterStorageExit.coords.w)

                            Wait(100)

                            DoScreenFadeIn(1000)
                        end
                    end

                    if not heliEntrance then
                        heliEntrance = lib.zones.box({
                            coords = vec3(config.locations.helicopterStorageEntrance.coords.xyz),
                            size = vec3(1.0, 2.25, 3.45),
                            rotation = 340.0,
                            debug = config.debugZones,
                            inside = inside,
                            onEnter = onEnter,
                            onExit = onExit
                        })
                    end

                elseif #(pos - vector3(config.locations.helicopterStorageExit.coords.xyz)) < 1.5 then
                    local function onEnter()
                        lib.showTextUI(Lang:t('info.heli_exit'))
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

                            SetEntityCoords(cache.ped, config.locations.helicopterStorageEntrance.coords.x, config.locations.helicopterStorageEntrance.coords.y, config.locations.helicopterStorageEntrance.coords.z, false, false, false, false)
                            SetEntityHeading(cache.ped, config.locations.helicopterStorageEntrance.coords.w)

                            Wait(100)

                            DoScreenFadeIn(1000)
                        end
                    end

                    if not heliExit then
                        heliExit = lib.zones.box({
                            coords = vec3(config.locations.helicopterStorageExit.coords.xyz),
                            size = vec3(1.9, 4.3, 3.2),
                            rotation = 0.0,
                            debug = config.debugZones,
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
            if heliEntrance then
                heliEntrance:remove()
                heliEntrance = nil
            end
            if heliExit then
                heliExit:remove()
                heliExit = nil
            end
        end
    end
end)
