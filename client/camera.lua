local holdingCam = false
local holdingMic = false
local holdingBmic = false
local camModel = 'prop_v_cam_01'
local camanimDict = 'missfinale_c2mcs_1'
local camanimName = 'fin_c2_mcs_1_camman'
local micModel = 'p_ing_microphonel_01'
local micanimDict = 'missheistdocksprep1hold_cellphone'
local micanimName = 'hold_cellphone'
local bmicModel = 'prop_v_bmike_01'
local bmicanimDict = 'missfra1'
local bmicanimName = 'mcs2_crew_idle_m_boom'
local bmic_net
local mic_net
local cam_net
local UI = {
	x =  0.000 ,
	y = -0.001 ,
}
local fov_max = 70.0
local fov_min = 5.0
local zoomspeed = 10.0
local speed_lr = 8.0
local speed_ud = 8.0
local camera = false
local fov = (fov_max+fov_min)*0.5
local new_z
local movcamera
local newscamera
local isLoggedIn = LocalPlayer.state.isLoggedIn

--FUNCTIONS--
local function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(1)
	HideHudComponentThisFrame(2)
	HideHudComponentThisFrame(3)
	HideHudComponentThisFrame(4)
	HideHudComponentThisFrame(6)
	HideHudComponentThisFrame(7)
	HideHudComponentThisFrame(8)
	HideHudComponentThisFrame(9)
	HideHudComponentThisFrame(13)
	HideHudComponentThisFrame(11)
	HideHudComponentThisFrame(12)
	HideHudComponentThisFrame(15)
	HideHudComponentThisFrame(18)
	HideHudComponentThisFrame(19)
end

local function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		local new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

local function HandleZoom(cam)
	if not cache.vehicle then

		if IsControlJustPressed(0,241) then
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0,242) then
			fov = math.min(fov + zoomspeed, fov_max)
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
	else
		if IsControlJustPressed(0,17) then
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0,16) then
			fov = math.min(fov + zoomspeed, fov_max)
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
	end
end

local function drawRct(x,y,width,height,r,g,b,a)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end

---------------------------------------------------------------------------
-- Toggling Cam --
---------------------------------------------------------------------------

RegisterNetEvent('qbx_newsjob:client:toggleCam', function()
    if not holdingCam then
        lib.requestModel(camModel, 5000)
        local plyCoords = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 0.0, -5.0)
        local camspawned = CreateObject(camModel, plyCoords.x, plyCoords.y, plyCoords.z, true, true, true)
        SetModelAsNoLongerNeeded(camModel)
        Wait(1000)
        local netid = ObjToNet(camspawned)
        SetNetworkIdExistsOnAllMachines(netid, true)
        NetworkSetNetworkIdDynamic(netid, true)
        SetNetworkIdCanMigrate(netid, false)
        AttachEntityToEntity(camspawned, cache.ped, GetPedBoneIndex(cache.ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 0, true)
        lib.playAnim(cache.ped, camanimDict, camanimName, 1.0, -1, -1, 50, 0, false, false, false)
        cam_net = netid
        holdingCam = true
		lib.showTextUI(Lang:t('info.weazle_overlay'))
    else
		lib.hideTextUI()
        ClearPedSecondaryTask(cache.ped)
        DetachEntity(NetToObj(cam_net), true, true)
        DeleteEntity(NetToObj(cam_net))
        cam_net = nil
        holdingCam = false
    end
end)

CreateThread(function()
	while true do
		if not isLoggedIn then return end
		if QBX.PlayerData.job.name == 'reporter' then
			if holdingCam then
				lib.requestAnimDict(camanimDict, 5000)

				if not IsEntityPlayingAnim(cache.ped, camanimDict, camanimName, 3) then
					TaskPlayAnim(cache.ped, camanimDict, camanimName, 1.0, -1, -1, 50, 0, false, false, false)
				end
                RemoveAnimDict(camanimDict)

				DisablePlayerFiring(cache.playerId, true)
				DisableControlAction(0,25, true)
				DisableControlAction(0, 44, true)
				DisableControlAction(0,37, true)
				SetCurrentPedWeapon(cache.ped, `WEAPON_UNARMED`, true)
				Wait(0)
			else
				Wait(100)
			end
		else
			Wait(1000)
		end
	end
end)

---------------------------------------------------------------------------
-- Movie Cam --
---------------------------------------------------------------------------

CreateThread(function()
	while true do
		if not isLoggedIn then return end
		if QBX.PlayerData.job.name == 'reporter' then
			if holdingCam then
				if IsControlJustReleased(1, 244) then
					movcamera = true
					SetTimecycleModifier('default')
					SetTimecycleModifierStrength(0.3)
					local scaleform = lib.requestScaleformMovie('security_camera', 5000)
					if not scaleform then return end
					while not HasScaleformMovieLoaded(scaleform) do
						Wait(10)
					end

					local vehicle = cache.vehicle
					local cam1 = CreateCam('DEFAULT_SCRIPTED_FLY_CAMERA', true)

					AttachCamToEntity(cam1, cache.ped, 0.0,0.0,1.0, true)
					SetCamRot(cam1, 2.0, 1.0, GetEntityHeading(cache.ped), 0)
					SetCamFov(cam1, fov)
					RenderScriptCams(true, false, 0, true, false)
					PushScaleformMovieFunction(scaleform, 'security_camera')
					PopScaleformMovieFunctionVoid()

					while movcamera and not IsEntityDead(cache.ped) and cache.vehicle == vehicle do
						if IsControlJustPressed(0, 177) then
							PlaySoundFrontend(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
							movcamera = false
						end

						SetEntityRotation(cache.ped, 0, 0, new_z,2, true)
						local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
						CheckInputRotation(cam1, zoomvalue)
						HandleZoom(cam1)
						HideHUDThisFrame()
						drawRct(UI.x + 0.0, 	UI.y + 0.0, 1.0,0.15,0,0,0,255) -- Top Bar
						DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
						drawRct(UI.x + 0.0, 	UI.y + 0.85, 1.0,0.16,0,0,0,255) -- Bottom Bar
						local camHeading = GetGameplayCamRelativeHeading()
						local camPitch = GetGameplayCamRelativePitch()
						if camPitch < -70.0 then
							camPitch = -70.0
						elseif camPitch > 42.0 then
							camPitch = 42.0
						end
						camPitch = (camPitch + 70.0) / 112.0
						if camHeading < -180.0 then
							camHeading = -180.0
						elseif camHeading > 180.0 then
							camHeading = 180.0
						end
						camHeading = (camHeading + 180.0) / 360.0
						SetTaskMoveNetworkSignalFloat(cache.ped, 'Pitch', camPitch)
						SetTaskMoveNetworkSignalFloat(cache.ped, 'Heading', camHeading * -1.0 + 1.0)
						Wait(1)
					end
					movcamera = false
					ClearTimecycleModifier()
					fov = (fov_max+fov_min)*0.5
					RenderScriptCams(false, false, 0, true, false)
					SetScaleformMovieAsNoLongerNeeded(scaleform)
					DestroyCam(cam1, false)
					SetNightvision(false)
					SetSeethrough(false)
				end
				Wait(7)
			else
				Wait(100)
			end
		else
			Wait(1000)
		end
	end
end)

---------------------------------------------------------------------------
-- News Cam --
---------------------------------------------------------------------------

CreateThread(function()
	while true do
		if not isLoggedIn then return end
		if QBX.PlayerData.job.name == 'reporter' then
			if holdingCam then
				if IsControlJustReleased(1, 38) then
					newscamera = true
					SetTimecycleModifier('default')
					SetTimecycleModifierStrength(0.3)
					local scaleform = lib.requestScaleformMovie('security_camera', 5000)
					local scaleform2 = lib.requestScaleformMovie('breaking_news', 5000)
					if not scaleform or not scaleform2 then return end
					while not HasScaleformMovieLoaded(scaleform) do
						Wait(10)
					end
					while not HasScaleformMovieLoaded(scaleform2) do
						Wait(10)
					end
					local vehicle = cache.vehicle
					local cam2 = CreateCam('DEFAULT_SCRIPTED_FLY_CAMERA', true)
					local msg = Lang:t('info.title_breaking_news')
					local bottom = Lang:t('info.bottom_breaking_news')
					local title = Lang:t('info.breaking_news')
					AttachCamToEntity(cam2, cache.ped, 0.0,0.0,1.0, true)
					SetCamRot(cam2, 2.0,1.0,GetEntityHeading(cache.ped), 0)
					SetCamFov(cam2, fov)
					RenderScriptCams(true, false, 0, true, false)
					PushScaleformMovieFunction(scaleform, 'SET_CAM_LOGO')
					PushScaleformMovieFunction(scaleform2, 'breaking_news')
					PopScaleformMovieFunctionVoid()
					BeginScaleformMovieMethod(scaleform2, 'SET_TEXT')
					PushScaleformMovieFunctionParameterString(msg)
					PushScaleformMovieFunctionParameterString(bottom)
					EndScaleformMovieMethod()
					BeginScaleformMovieMethod(scaleform2, 'SET_SCROLL_TEXT')
					PushScaleformMovieFunctionParameterInt(0) -- 0 = top, 1 = bottom
					PushScaleformMovieFunctionParameterInt(0)
					PushScaleformMovieFunctionParameterString(title)
					EndScaleformMovieMethod()
					BeginScaleformMovieMethod(scaleform2, 'DISPLAY_SCROLL_TEXT')
					PushScaleformMovieFunctionParameterInt(0)
					PushScaleformMovieFunctionParameterInt(0)
					EndScaleformMovieMethod()

					while newscamera and not IsEntityDead(cache.ped) and (cache.vehicle == vehicle) do
						if IsControlJustPressed(1, 177) then
							PlaySoundFrontend(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
							newscamera = false
						end
						SetEntityRotation(cache.ped, 0, 0, new_z,2, true)
						local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
						CheckInputRotation(cam2, zoomvalue)
						HandleZoom(cam2)
						HideHUDThisFrame()
						DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
						DrawScaleformMovie(scaleform2, 0.5, 0.63, 1.0, 1.0, 255, 255, 255, 255, 0)
						local camHeading = GetGameplayCamRelativeHeading()
						local camPitch = GetGameplayCamRelativePitch()
						if camPitch < -70.0 then
							camPitch = -70.0
						elseif camPitch > 42.0 then
							camPitch = 42.0
						end
						camPitch = (camPitch + 70.0) / 112.0
						if camHeading < -180.0 then
							camHeading = -180.0
						elseif camHeading > 180.0 then
							camHeading = 180.0
						end
						camHeading = (camHeading + 180.0) / 360.0
						SetTaskMoveNetworkSignalFloat(cache.ped, 'Pitch', camPitch)
						SetTaskMoveNetworkSignalFloat(cache.ped, 'Heading', camHeading * -1.0 + 1.0)
						Wait(1)
					end
					newscamera = false
					ClearTimecycleModifier()
					fov = (fov_max+fov_min)*0.5
					RenderScriptCams(false, false, 0, true, false)
					SetScaleformMovieAsNoLongerNeeded(scaleform)
					DestroyCam(cam2, false)
					SetNightvision(false)
					SetSeethrough(false)
				end
				Wait(7)
			else
				Wait(100)
			end
		else
			Wait(1000)
		end
	end
end)

---------------------------------------------------------------------------
--B Mic --
---------------------------------------------------------------------------

RegisterNetEvent('qbx_newsjob:client:toggleBMic', function()
    if not holdingBmic then
        lib.requestModel(bmicModel, 5000)
        local plyCoords = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 0.0, -5.0)
        local bmicspawned = CreateObject(bmicModel, plyCoords.x, plyCoords.y, plyCoords.z, true, true, false)
        SetModelAsNoLongerNeeded(bmicModel)
        Wait(1000)
        local netid = ObjToNet(bmicspawned)
        SetNetworkIdExistsOnAllMachines(netid, true)
        NetworkSetNetworkIdDynamic(netid, true)
        SetNetworkIdCanMigrate(netid, false)
        AttachEntityToEntity(bmicspawned, cache.ped, GetPedBoneIndex(cache.ped, 28422), -0.08, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 0, true)
        lib.playAnim(cache.ped, bmicanimDict, bmicanimName, 1.0, -1, -1, 50, 0, false, false, false)
        bmic_net = netid
        holdingBmic = true
    else
        ClearPedSecondaryTask(cache.ped)
        DetachEntity(NetToObj(bmic_net), true, true)
        DeleteEntity(NetToObj(bmic_net))
        bmic_net = nil
        holdingBmic = false
    end
end)

CreateThread(function()
	while true do
		if not isLoggedIn then return end
		if QBX.PlayerData.job.name == 'reporter' then
			if holdingBmic then
				lib.requestAnimDict(bmicanimDict, 5000)
				if not IsEntityPlayingAnim(cache.ped, bmicanimDict, bmicanimName, 3) then
					TaskPlayAnim(cache.ped, bmicanimDict, bmicanimName, 1.0, -1, -1, 50, 0, false, false, false)
				end
                RemoveAnimDict(bmicanimDict)
				DisablePlayerFiring(cache.playerId, true)
				DisableControlAction(0,25, true)
				DisableControlAction(0, 44, true)
				DisableControlAction(0,37, true)
				SetCurrentPedWeapon(cache.ped, joaat('WEAPON_UNARMED'), true)
				if IsPedInAnyVehicle(cache.ped, false) or QBX.PlayerData.metadata.ishandcuffed or holdingMic then
					ClearPedSecondaryTask(cache.ped)
					DetachEntity(NetToObj(bmic_net), true, true)
					DeleteEntity(NetToObj(bmic_net))
					bmic_net = nil
					holdingBmic = false
				end
				Wait(7)
			else
				Wait(100)
			end
		else
			Wait(1000)
		end
	end
end)

---------------------------------------------------------------------------
-- Events --
---------------------------------------------------------------------------

-- Activate camera
RegisterNetEvent('camera:Activate', function()
	camera = not camera
end)

---------------------------------------------------------------------------
-- Toggling Mic --
---------------------------------------------------------------------------
RegisterNetEvent('qbx_newsjob:client:toggleMic', function()
    if not holdingMic then
        lib.requestModel(micModel, 5000)
        local plyCoords = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 0.0, -5.0)
        local micspawned = CreateObject(micModel, plyCoords.x, plyCoords.y, plyCoords.z, true, true, true)
        SetModelAsNoLongerNeeded(micModel)
        Wait(1000)
        local netid = ObjToNet(micspawned)
        SetNetworkIdExistsOnAllMachines(netid, true)
        NetworkSetNetworkIdDynamic(netid, true)
        SetNetworkIdCanMigrate(netid, false)
        AttachEntityToEntity(micspawned, cache.ped, GetPedBoneIndex(cache.ped, 60309), 0.055, 0.05, 0.0, 240.0, 0.0, 0.0, true, true, false, true, 0, true)
        lib.playAnim(cache.ped, micanimDict, micanimName, 1.0, -1, -1, 50, 0, false, false, false)
        mic_net = netid
        holdingMic = true
    else
        ClearPedSecondaryTask(cache.ped)
        DetachEntity(NetToObj(mic_net), true, true)
        DeleteEntity(NetToObj(mic_net))
        mic_net = nil
        holdingMic = false
    end
end)
