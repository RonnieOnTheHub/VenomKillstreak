require('recorder/event-type')
require('recorder/recorder')
require('recorder/replayer')
require('recorder/serialization')
require('recorder/api')
require('Maps')

g_BattleRecorder = Recorder()
g_BattleReplayer = nil
venom_player = nil
start_player = nil



NetEvents:Subscribe('vu-ks-venom:Launch', function(player)
	if g_BattleReplayer ~= nil then
		print("killstreak already going")
		return
	end

	venom_player = player
	start_player = player.soldier.worldTransform:Clone()

	local levelName = SharedUtils:GetLevelName()
	if mapData[levelName] == nil then
		print("levelName is nil")
		return
	end
	print("MAPDATA: printing mapdata")
	print(levelName)
	print(mapData[levelName])
	g_BattleReplayer = Replayer(mapData[levelName], player, 2)

	g_BattleReplayer._eventHandlers[EventType.RECORDING_ENDED] = function(event)
		local location = start_player
		if player ~= nil then
			player:ExitVehicle(true, true)
		end

		if player ~= nil and location ~= nil and player.soldier ~= nil then
			player.soldier:SetPosition(location.trans)
		end

		if g_BattleReplayer ~= nil then
			g_BattleReplayer:stop()
		end
		
		g_BattleReplayer = nil
		venom_player = nil
		start_player = nil
	end
	g_BattleReplayer:play()
end)


Events:Subscribe('Player:Killed', function(player, inflictor, position, weapon, isRoadKill, isHeadShot, wasVictimInReviveState, info)
    if g_BattleReplayer == nil then
		return
	end
	if player.id == venom_player.id then
		venom_player:ExitVehicle(true, true)
		if g_BattleReplayer ~= nil then
			g_BattleReplayer:stop()
		end
		venom_player.soldier:ForceDead()

		g_BattleReplayer = nil
		venom_player = nil
	end
end)

Events:Subscribe('Vehicle:Exit', function(vehicle, player)
	if g_BattleReplayer == nil then
		return
	end

	if player.id == venom_player.id then
		g_BattleReplayer:stop()
		g_BattleReplayer = nil
		venom_player = nil
	end
end)

NetEvents:Subscribe('vu-ks-venom:Save', function(player)
	if not g_BattleRecorder:stopRecording() then
		return { 'NotRecording' }
	end

	if g_BattleRecorder:isRecording() then
		return { 'CurrentlyRecording' }
	end

	local recordingData = g_BattleRecorder:getRecordedEvents()

	print(serializeRecordingDataToBase64(recordingData))
end)

NetEvents:Subscribe('vu-ks-venom:Record', function(player)
	local result = g_BattleRecorder:startRecording()

	if result == StartRecordingResult.STARTED then
		print('Recording has started!')
	elseif result == StartRecordingResult.NO_LEVEL then
		print('Cannot start recording. No level is currently loaded.')
		return
	elseif result == StartRecordingResult.ALREADY_RECORDING then
		print('Cannot start recording. A recording is already in-progress.')
		return
	end


	local yaw = player.input.authoritativeAimingYaw
	local launchTransform = player.soldier.worldTransform:Clone()
	local params = EntityCreationParams()
	params.transform = launchTransform
	params.networked = true
	local vehicleName = "Vehicles/Venom/Venom"
	local blueprint = ResourceManager:SearchForDataContainer(vehicleName)
	if blueprint == nil then
		print("Missing blueprint"..vehicleName)
		return
	end
	local entity = EntityManager:CreateEntitiesFromBlueprint(blueprint, params)
	if entity == nil then
		print("Missing entity")
		return
	end
	local vehicleEntityBus = EntityBus(entity)
	for _,entity in pairs(vehicleEntityBus.entities) do
		entity = Entity(entity)
		entity:Init(Realm.Realm_ClientAndServer, true)

		if entity:Is('ServerVehicleEntity') then
			player:EnterVehicle(entity, 0)
			break
		end

	end
end)

Events:Subscribe('Level:Loaded', function(levelName, gameMode)
	if levelName == "XP2_Skybar" then
		local res = RCON:SendCommand("vu.DesertingAllowed", {"true"})
		print(levelName .. " vu.DesertingAllowed true")
		print(res)
	else
		RCON:SendCommand("vu.DesertingAllowed", {"false"})
	end
end)