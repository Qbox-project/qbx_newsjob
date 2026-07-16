local config = require 'config.client'
local vehiclesSpawning = {}

local function checkReporterJob(source)
    local player = exports.qbx_core:GetPlayer(source)
    return player and player.PlayerData.job.name == 'reporter' and player
end

lib.addCommand('newscam', {
    help = locale('info.newscam'),
}, function(source)
    if not checkReporterJob(source) then
        TriggerClientEvent('ox_lib:notify', source, { description = locale('error.no_access'), type = 'error' })
		return
    end
    TriggerClientEvent('qbx_newsjob:client:toggleCam', source)
end)

lib.addCommand('newsmic', {
    help = locale('info.newsmic'),
}, function(source)
    if not checkReporterJob(source) then
        TriggerClientEvent('ox_lib:notify', source, { description = locale('error.no_access'), type = 'error' })
		return
    end
    TriggerClientEvent('qbx_newsjob:client:toggleMic', source)
end)

lib.addCommand('newsbmic', {
    help = locale('info.newsbmic'),
}, function(source)
    if not checkReporterJob(source) then
        TriggerClientEvent('ox_lib:notify', source, { description = locale('error.no_access'), type = 'error' })
		return
    end
    TriggerClientEvent('qbx_newsjob:client:toggleBMic', source)
end)

lib.callback.register('qbx_newsjob:server:spawnVehicle', function(source, model)
    local player = checkReporterJob(source)
    if not player or vehiclesSpawning[source] or type(model) ~= 'string' then return end

    local grade = player.PlayerData.job.grade.level
    local spawnCoords
    if config.authorizedVehicles[grade]?[model] then
        spawnCoords = config.locations.vehicleStorage.coords
    elseif config.authorizedhelicopters[grade]?[model] then
        spawnCoords = config.locations.helicopterStorage.coords
    else
        return
    end

    if #(GetEntityCoords(GetPlayerPed(source)) - spawnCoords.xyz) > 10.0 then return end

    vehiclesSpawning[source] = true
    local plate = ('NEWS%s'):format(lib.string.random('1111'))
    local netId, veh = qbx.spawnVehicle({ model = model, spawnSource = spawnCoords, props = { plate = plate } })
    vehiclesSpawning[source] = nil
    if not netId or netId == 0 then return end
    if not veh or veh == 0 then return end
    SetEntityHeading(veh, spawnCoords.w)
    SetVehicleNumberPlateText(veh, plate)
    TriggerClientEvent('vehiclekeys:client:SetOwner', source, plate)
    return netId
end)

AddEventHandler('playerDropped', function()
    vehiclesSpawning[source] = nil
end)
