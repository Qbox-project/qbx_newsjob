lib.addCommand('newscam', {
    help = Lang:t("info.newscam"),
}, function(source)
    local Player = exports.qbx_core:GetPlayer(source)
    if Player.PlayerData.job.name ~= "reporter" then return end
    TriggerClientEvent("Cam:ToggleCam", source)
end)

lib.addCommand('newsmic', {
    help = Lang:t("info.newsmic"),
}, function(source)
    local Player = exports.qbx_core:GetPlayer(source)
    if Player.PlayerData.job.name ~= "reporter" then return end
    TriggerClientEvent("Mic:ToggleMic", source)
end)

lib.addCommand('newsbmic', {
    help = Lang:t("info.newsbmic"),
}, function(source)
    local Player = exports.qbx_core:GetPlayer(source)
    if Player.PlayerData.job.name ~= "reporter" then return end
    TriggerClientEvent("Mic:ToggleBMic", source)
end)

lib.callback.register('qbx_newsjob:server:spawnVehicle', function(source, model, coords, plate, warp)
    local netId = SpawnVehicle(source, model, coords, warp)
    if not netId or netId == 0 then return end
    local veh = NetworkGetEntityFromNetworkId(netId)
    if not veh or veh == 0 then return end
    SetEntityHeading(veh, coords.w)
    SetVehicleNumberPlateText(veh, plate)
    TriggerClientEvent('vehiclekeys:client:SetOwner', source, plate)
    return netId
end)

lib.callback.register('qbx_newsjob:server:spawnHeli', function(source, model, coords, plate, warp)
    local netId = SpawnVehicle(source, model, coords, warp)
    if not netId or netId == 0 then return end
    local veh = NetworkGetEntityFromNetworkId(netId)
    if not veh or veh == 0 then return end
    SetEntityHeading(veh, coords.w)
    SetVehicleNumberPlateText(veh, plate)
    TriggerClientEvent('vehiclekeys:client:SetOwner', source, plate)
    return netId
end)