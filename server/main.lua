local function checkReporterJob(source)
    local Player = exports.qbx_core:GetPlayer(source)
    return Player.PlayerData.job.name == 'reporter'
end

lib.addCommand('newscam', {
    help = Lang:t('info.newscam'),
}, function(source)
    if not checkReporterJob(source) then
        TriggerClientEvent('ox_lib:notify', source, { description = Lang:t('error.no_access'), type = 'error' })
		return
    end
    TriggerClientEvent('qbx_newsjob:client:toggleCam', source)
end)

lib.addCommand('newsmic', {
    help = Lang:t('info.newsmic'),
}, function(source)
    if not checkReporterJob(source) then
        TriggerClientEvent('ox_lib:notify', source, { description = Lang:t('error.no_access'), type = 'error' })
		return
    end
    TriggerClientEvent('qbx_newsjob:client:toggleMic', source)
end)

lib.addCommand('newsbmic', {
    help = Lang:t('info.newsbmic'),
}, function(source)
    if not checkReporterJob(source) then
        TriggerClientEvent('ox_lib:notify', source, { description = Lang:t('error.no_access'), type = 'error' })
		return
    end
    TriggerClientEvent('qbx_newsjob:client:toggleBMic', source)
end)

lib.callback.register('qbx_newsjob:server:spawnVehicle', function(source, model, coords, plate)
    local netId, veh = qbx.spawnVehicle(source, model, coords)
    if not netId or netId == 0 then return end
    if not veh or veh == 0 then return end
    SetEntityHeading(veh, coords.w)
    SetVehicleNumberPlateText(veh, plate)
    TriggerClientEvent('vehiclekeys:client:SetOwner', source, plate)
    return netId
end)
