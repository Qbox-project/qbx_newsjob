lib.callback.register('qbx_newsjob:server:spawnVehicle', function(source, model, coords, plate)
    local netId = SpawnVehicle(source, model, coords, true)
    if not netId or netId == 0 then return end
    local veh = NetworkGetEntityFromNetworkId(netId)
    if not veh or veh == 0 then return end
    SetVehicleNumberPlateText(veh, plate)
    TriggerClientEvent('vehiclekeys:client:SetOwner', source, plate)
    return netId
end)

lib.addCommand('newscam', {help = 'Grab a news camera'}, function(source, _)
    local player = exports.qbx_core:GetPlayer(source)
    if player.PlayerData.job.name == "reporter" then
        TriggerClientEvent("Cam:ToggleCam", source)
    end
end)

lib.addCommand('newsmic', {help = 'Grab a news microphone'}, function(source, _)
    local player = exports.qbx_core:GetPlayer(source)
    if player.PlayerData.job.name == "reporter" then
        TriggerClientEvent("Mic:ToggleMic", source)
    end
end)

lib.addCommand('newsbmic', {help = 'Grab a Boom microphone'}, function(source, _)
    local player = exports.qbx_core:GetPlayer(source)
    if player.PlayerData.job.name == "reporter" then
        TriggerClientEvent("Mic:ToggleBMic", source)
    end
end)
