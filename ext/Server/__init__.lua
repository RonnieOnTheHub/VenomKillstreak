require('recorder/event-type')
require('recorder/recorder')
require('recorder/replayer')
require('recorder/serialization')
require('recorder/api')
require('XP2_Skybar')

g_BattleRecorder = Recorder()
g_BattleReplayer = nil
venom_player = nil
start_player = nil

NetEvents:Subscribe('vu-ks-venom:Launch', function(player)
	if g_BattleReplayer ~= nil then
		return
	end
	venom_player = player
	start_player = player.soldier.worldTransform:Clone()
	g_BattleReplayer = Replayer(map_skybar, player, 2)

	g_BattleReplayer._eventHandlers[EventType.RECORDING_ENDED] = function(event)
		g_BattleReplayer = nil
		venom_player = nil
		if venom_player ~= nil then
			venom_player:ExitVehicle(true, true)
			venom_player.soldier:SetPosition(start_player.trans)
		end
		g_BattleReplayer:stop()
	end
	g_BattleReplayer:play()
end)


Events:Subscribe('Player:Killed', function(player, inflictor, position, weapon, isRoadKill, isHeadShot, wasVictimInReviveState, info)
    if g_BattleReplayer == nil then
		return
	end
	if player.id == venom_player.id then
		venom_player:ExitVehicle(true, true)
		--g_BattleReplayer:stop()
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

NetEvents:Subscribe('vu-ks-venom:save', function(player)
	if not g_BattleRecorder:stopRecording() then
		return { 'NotRecording' }
	end

	if g_BattleRecorder:isRecording() then
		return { 'CurrentlyRecording' }
	end

	local recordingData = g_BattleRecorder:getRecordedEvents()

	print(serializeRecordingDataToBase64(recordingData))
end)

NetEvents:Subscribe('vu-ks-venom:record', function(player)
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

	local position = Vec3(-23.328125, 25.327930, 98.891602)

	local yaw = player.input.authoritativeAimingYaw
	local launchTransform = player.soldier.worldTransform:Clone()
	launchTransform.trans = position
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