local config = require 'config.client'

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    if QBX.PlayerData.job.name == 'reporter' then
        local blip = AddBlipForCoord(config.locations.mainEntrance.coords.x, config.locations.mainEntrance.coords.y, config.locations.mainEntrance.coords.z)
        SetBlipSprite(blip, 184)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 1)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(config.locations.mainEntrance.label)
        EndTextCommandSetBlipName(blip)
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function()
    if QBX.PlayerData.job.name == 'reporter' then
        local blip = AddBlipForCoord(config.locations.mainEntrance.coords.x, config.locations.mainEntrance.coords.y, config.locations.mainEntrance.coords.z)
        SetBlipSprite(blip, 184)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, 1)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(config.locations.mainEntrance.label)
        EndTextCommandSetBlipName(blip)
    end
end)

local function takeOutVehicle(vehicleInfo)
    local plyCoords = GetEntityCoords(cache.ped)
    local coords = vec4(plyCoords.x, plyCoords.y, plyCoords.z, GetEntityHeading(cache.ped))
    if not coords then return end

    local netId = lib.callback.await('qbx_newsjob:server:spawnVehicle', false, vehicleInfo, coords, Lang:t('info.news_plate')..tostring(math.random(1000, 9999)), true)
    local timeout = 100
    while not NetworkDoesEntityExistWithNetworkId(netId) and timeout > 0 do
        Wait(10)
        timeout -= 1
    end
    local veh = NetToVeh(netId)
    if veh == 0 then
        exports.qbx_core:Notify(Lang:t('error.cant_spawn_vehicle'), 'error')
        return
    end
    local vehClass = GetVehicleClass(veh)
    if vehClass == 12 then -- Vans
        SetVehicleLivery(veh, 2)
    end
    SetEntityHeading(veh, coords.w)
    SetVehicleFuelLevel(veh, 100.0)
    SetVehicleEngineOn(veh, true, true, false)
    CurrentPlate = GetPlate(veh)
end

function MenuVehicleGarage()
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

function MenuHeliGarage()
    local helicopters = config.helicopters[QBX.PlayerData.job.grade.level]
    local optionsMenu = {}

    for veh, label in pairs(helicopters) do
        optionsMenu[#optionsMenu + 1] = {
            title = label,
            onSelect = function()
                takeOutVehicle(veh)
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
        if LocalPlayer.state.isLoggedIn then
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
                            if cache.vehicle then
                                if IsControlJustReleased(0, 38) then
                                    if IsPedInAnyVehicle(cache.ped, false) then
                                        DeleteVehicle(cache.vehicle)
                                    end
                                end
                            else
                                if IsControlJustReleased(0, 38) then
                                    MenuVehicleGarage()
                                end
                            end
                        end
                        if not VehicleZone then
                            VehicleZone = lib.zones.box({
                                coords = vec3(config.locations.vehicleStorage.coords.xyz),
                                size = vec3(4, 4, 4),
                                rotation = 45,
                                debug = config.debugZones,
                                inside = inside,
                                onEnter = onEnter,
                                onExit = onExit
                            })
                        end

                        inRange = true
                    end
                elseif  #(pos - vector3(config.locations.helicopterStorage.coords.xyz)) < 5.0 then
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
                            if cache.vehicle then
                                if IsControlJustReleased(0, 38) then
                                    if IsPedInAnyVehicle(cache.ped, false) then
                                        DeleteVehicle(cache.vehicle)
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
        if LocalPlayer.state.isLoggedIn then
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

                    if not MainEntrance then
                        MainEntrance = lib.zones.box({
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

                    if not MainExit then
                        MainExit = lib.zones.box({
                            coords = vec3(config.locations.inside.coords.xyz),
                            size = vec3(2, 2, 2),
                            rotation = 245.46,
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
