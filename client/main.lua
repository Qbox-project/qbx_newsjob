local config = require 'config.client'
local isLoggedIn = LocalPlayer.state.isLoggedIn

local mainEntranceTarget = 'mainEntranceTarget'
local mainExitTarget = 'mainExitTarget'
local enterRoofTarget = 'enterRoofTarget'
local exitRoofTarget = 'exitRoofTarget'

local exitZone, enterRoofZone, exitRoofZone, vehicleZone, heliZone = nil, nil, nil, nil, nil

local function setLocationBlip()
    local blip = AddBlipForCoord(config.locations.mainEntrance.coords.x, config.locations.mainEntrance.coords.y, config.locations.mainEntrance.coords.z)
    SetBlipSprite(blip, 459)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 1)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Lang:t('info.blip_name'))
    EndTextCommandSetBlipName(blip)
end

local function takeOutVehicle(vehType, coords)
    local netId = lib.callback.await('qbx_newsjob:server:spawnVehicle', false, vehType, coords, Lang:t('info.news_plate')..tostring(math.random(1000, 9999)), true)
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
    local vehClass = GetVehicleClass(veh)
    if vehClass == 12 then
        SetVehicleLivery(veh, 2)
    end
    SetVehicleFuelLevel(veh, 100.0)
    SetVehicleFuelLevel(veh, 100.0)
    TaskWarpPedIntoVehicle(cache.ped, veh, -1)
    SetVehicleEngineOn(veh, true, true, false)
    CurrentPlate = qbx.getVehiclePlate(veh)
end

local function menuVehicleGarage()
    local authorizedVehicles = config.authorizedVehicles[QBX.PlayerData.job.grade.level]
    local optionsMenu = {}

    for veh, label in pairs(authorizedVehicles) do
        optionsMenu[#optionsMenu + 1] = {
            title = label,
            event = 'qbx_newsjob:client:takeOutVehicle',
            args = {
                vehicle = veh
            }
        }
    end

    lib.registerContext({
        id = 'weazel_garage_context_menu',
        title = Lang:t('info.weazel_news_vehicles'),
        options = optionsMenu
    })

    lib.showContext('weazel_garage_context_menu')
end

local function menuHeliGarage()
    local helicopters = config.authorizedhelicopters[QBX.PlayerData.job.grade.level]
    local optionsMenu = {}

    for veh, label in pairs(helicopters) do
        optionsMenu[#optionsMenu + 1] = {
            title = label,
            event = 'qbx_newsjob:client:takeOutVehicle',
            args = {
                helicopter = veh
            }
        }
    end

    lib.registerContext({
        id = 'weazel_heli_context_menu',
        title = Lang:t('info.weazel_news_helicopters'),
        options = optionsMenu
    })

    lib.showContext('weazel_heli_context_menu')
end

local function registerMainEntrance()
    local coords = vec3(config.locations.mainEntrance.coords.xyz)

    if config.useTarget then
        exports.ox_target:addBoxZone({
            name = mainEntranceTarget,
            coords = coords,
            rotation = 0.0,
            size = vec3(1.0, 5.85, 3),
            debug = config.debugPoly,
            options = {
                {
                    icon = 'fa-solid fa-house',
                    type = 'client',
                    event = 'qbx_newsjob:client:target:enterLocation',
                    label = Lang:t("info.enter"),
                    distance = 1
                },
            },
        })
    else
        lib.zones.box({
            coords = coords,
            rotation = 0.0,
            size = vec3(1.0, 5.85, 3),
            debug = config.debugPoly,
            onEnter = function()
                lib.showTextUI(Lang:t("info.enter"))
            end,
            onExit = function()
                lib.hideTextUI()
            end,
            inside = function()
                if IsControlJustReleased(0, 38) then
                    TriggerEvent('qbx_newsjob:client:target:enterLocation')
                    lib.hideTextUI()
                end
            end
        })
    end
end

local function registerMainExit()
    local coords = vec3(config.locations.inside.coords.xyz)

    if config.useTarget then
        exitZone = exports.ox_target:addBoxZone({
            name = mainExitTarget,
            coords = coords,
            size = vec3(1.0, 2.25, 3.45),
            rotation = 340.0,
            debug = config.debugPoly,
            options = {
                {
                    icon = 'fa-solid fa-house',
                    type = 'client',
                    event = 'qbx_newsjob:client:target:exitLocation',
                    label = Lang:t("info.go_outside"),
                    distance = 1
                },
            },
        })
    else
        exitZone = lib.zones.box({
            coords = coords,
            size = vec3(1.0, 2.25, 3.45),
            rotation = 340.0,
            debug = config.debugPoly,
            onEnter = function()
                lib.showTextUI(Lang:t("info.go_outside"))
            end,
            onExit = function()
                lib.hideTextUI()
            end,
            inside = function()
                if IsControlJustReleased(0, 38) then
                    TriggerEvent('qbx_newsjob:client:target:exitLocation')
                    lib.hideTextUI()
                end
            end
        })
    end
end

local function destroyMainExitZones()
    if not exitZone then
        return
    end

    if config.useTarget then
        exports.ox_target:removeZone(mainExitTarget)
        exitZone = nil
    else
        exitZone:remove()
        exitZone = nil
    end
end

local function registerEnterRoof()
    local coords = vec3(config.locations.roofEntrance.coords.xyz)

    if config.useTarget then
        enterRoofZone = exports.ox_target:addBoxZone({
            name = enterRoofTarget,
            coords = coords,
            size = vec3(1.0, 2.25, 3.45),
            rotation = 340.0,
            debug = config.debugPoly,
            options = {
                {
                    icon = 'fa-solid fa-house',
                    type = 'client',
                    event = 'qbx_newsjob:client:target:enterRoof',
                    label = Lang:t("info.roof_enter"),
                    distance = 1
                },
            },
        })
    else
        enterRoofZone = lib.zones.box({
            coords = coords,
            size = vec3(1.0, 2.25, 3.45),
            rotation = 340.0,
            debug = config.debugPoly,
            onEnter = function()
                lib.showTextUI(Lang:t("info.roof_enter"))
            end,
            onExit = function()
                lib.hideTextUI()
            end,
            inside = function()
                if IsControlJustReleased(0, 38) then
                    TriggerEvent('qbx_newsjob:client:target:enterRoof')
                    lib.hideTextUI()
                end
            end
        })
    end
end

local function destroyEnterRoofZones()
    if not enterRoofZone then
        return
    end

    if config.useTarget then
        exports.ox_target:removeZone(enterRoofTarget)
        enterRoofZone = nil
    else
        enterRoofZone:remove()
        enterRoofZone = nil
    end
end

local function registerExitRoof()
    local coords = vec3(config.locations.roofExit.coords.xyz)

    if config.useTarget then
        exitRoofZone = exports.ox_target:addBoxZone({
            name = exitRoofTarget,
            coords = coords,
            size = vec3(1.0, 1.45, 2.75),
            rotation = 0.0,
            debug = config.debugPoly,
            options = {
                {
                    icon = 'fa-solid fa-house',
                    type = 'client',
                    event = 'qbx_newsjob:client:target:exitRoof',
                    label = Lang:t("info.roof_exit"),
                    distance = 1
                },
            },
        })
    else
        exitRoofZone = lib.zones.box({
            coords = coords,
            size = vec3(1.0, 1.45, 2.75),
            rotation = 0.0,
            debug = config.debugPoly,
            onEnter = function()
                lib.showTextUI(Lang:t("info.roof_exit"))
            end,
            onExit = function()
                lib.hideTextUI()
            end,
            inside = function()
                if IsControlJustReleased(0, 38) then
                    TriggerEvent('qbx_newsjob:client:target:exitRoof')
                    lib.hideTextUI()
                end
            end
        })
    end
end

local function destroyExitRoofZones()
    if not exitRoofZone then
        return
    end

    if config.useTarget then
        exports.ox_target:removeZone(exitRoofTarget)
        exitRoofZone = nil
    else
        exitRoofZone:remove()
        exitRoofZone = nil
    end
end

local function registerVehicleStorage()
    local coords = vec3(config.locations.vehicleStorage.coords.xyz)
    vehicleZone = lib.zones.box({
        coords = coords,
        size = vec3(6.0, 4.0, 4.0),
        rotation = 0.0,
        debug = config.debugPoly,
        onEnter = function()
            if cache.vehicle then
                lib.showTextUI(Lang:t('info.store_vehicle'))
            else
                lib.showTextUI(Lang:t('info.vehicles'))
            end
        end,
        onExit = function()
            lib.hideTextUI()
        end,
        inside = function()
            if IsControlJustReleased(0, 38) then
                if cache.vehicle then
                    DeleteVehicle(cache.vehicle)
                else
                    menuVehicleGarage()
                end
            end
        end
    })
end

local function destroyVehicleStorageZones()
    if not vehicleZone then
        return
    end

    vehicleZone:remove()
    vehicleZone = nil
end

local function registerHeliStorage()
    local coords = vec3(config.locations.helicopterStorage.coords.xyz)
    heliZone = lib.zones.box({
        coords = coords,
        size = vec3(4, 4, 4),
        rotation = 267.49,
        debug = config.debugPoly,
        onEnter = function()
            if cache.vehicle then
                lib.showTextUI(Lang:t('info.store_helicopters'))
            else
                lib.showTextUI(Lang:t('info.helicopters'))
            end
        end,
        onExit = function()
            lib.hideTextUI()
        end,
        inside = function()
            if IsControlJustReleased(0, 38) then
                if cache.vehicle then
                    DeleteVehicle(cache.vehicle)
                else
                    menuHeliGarage()
                end
            end
        end
    })
end

local function destroyHeliStorageZones()
    if not heliZone then
        return
    end

    heliZone:remove()
    heliZone = nil
end

local function enterLocation()
    DoScreenFadeOut(500)

    while not IsScreenFadedOut() do
        Wait(10)
    end

    SetEntityCoords(cache.ped, config.locations.inside.coords.x, config.locations.inside.coords.y, config.locations.inside.coords.z, false, false, false, false)
    SetEntityHeading(cache.ped, config.locations.inside.coords.w)
    DoScreenFadeIn(500)
end

local function exitLocation()
    DoScreenFadeOut(500)

    while not IsScreenFadedOut() do
        Wait(10)
    end

    SetEntityCoords(cache.ped, config.locations.outside.coords.x, config.locations.outside.coords.y, config.locations.outside.coords.z, false, false, false, false)
    SetEntityHeading(cache.ped, config.locations.outside.coords.w)
    DoScreenFadeIn(500)
end

local function enterRoof()
    DoScreenFadeOut(500)

    while not IsScreenFadedOut() do
        Wait(10)
    end

    SetEntityCoords(cache.ped, config.locations.roofExit.coords.x, config.locations.roofExit.coords.y, config.locations.roofExit.coords.z, false, false, false, false)
    SetEntityHeading(cache.ped, config.locations.roofExit.coords.w)
    DoScreenFadeIn(500)
end

local function exitRoof()
    DoScreenFadeOut(500)

    while not IsScreenFadedOut() do
        Wait(10)
    end

    SetEntityCoords(cache.ped, config.locations.roofEntrance.coords.x, config.locations.roofEntrance.coords.y, config.locations.roofEntrance.coords.z, false, false, false, false)
    SetEntityHeading(cache.ped, config.locations.roofEntrance.coords.w)
    DoScreenFadeIn(500)
end

local function init()
    if config.useBlips then
        setLocationBlip()
    end

    registerMainEntrance()
    registerMainExit()
    registerEnterRoof()
    registerExitRoof()

    if QBX.PlayerData.job.name == 'reporter' and isLoggedIn then
    registerVehicleStorage()
    registerHeliStorage()
    end
end

RegisterNetEvent('qbx_newsjob:client:takeOutVehicle', function(data)
    if data.vehicle then
        local coords = config.locations.vehicleStorage.coords
        local veh = data.vehicle
        takeOutVehicle(veh, coords)
    elseif data.helicopter then
        local coords = config.locations.helicopterStorage.coords
        local veh = data.helicopter
        takeOutVehicle(veh, coords)
    end
end)

RegisterNetEvent('qbx_newsjob:client:target:enterLocation', function()
    enterLocation()
end)

RegisterNetEvent('qbx_newsjob:client:target:exitLocation', function()
    exitLocation()
end)

RegisterNetEvent('qbx_newsjob:client:target:enterRoof', function()
    enterRoof()
end)

RegisterNetEvent('qbx_newsjob:client:target:exitRoof', function()
    exitRoof()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function()
    destroyVehicleStorageZones()
    destroyHeliStorageZones()
    init()
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    if isLoggedIn then init() end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    destroyVehicleStorageZones()
    destroyHeliStorageZones()
    destroyMainExitZones()
    destroyEnterRoofZones()
    destroyExitRoofZones()
end)
