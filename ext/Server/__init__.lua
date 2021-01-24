require('recorder/event-type')
require('recorder/recorder')
require('recorder/replayer')
require('recorder/serialization')
require('recorder/api')
require('XP2_Skybar')

g_BattleRecorder = Recorder()

NetEvents:Subscribe('vu-ks-attackheli:launch', function(player)
	local launchTransform = player.soldier.worldTransform:Clone()
	local g_BattleReplayer = Replayer(map_skybar, player, 2)
	g_BattleReplayer._eventHandlers[EventType.RECORDING_ENDED] = function(event)
		player:ExitVehicle(true, true)
		player.soldier:SetPosition(launchTransform.trans)
		g_BattleReplayer:stop()
	end
	g_BattleReplayer:play()
end)


-- NetEvents:Subscribe('vu-ks-attackheli:save', function(player)
-- 	if not g_BattleRecorder:stopRecording() then
-- 		return { 'NotRecording' }
-- 	end

-- 	if g_BattleRecorder:isRecording() then
-- 		return { 'CurrentlyRecording' }
-- 	end

-- 	local recordingData = g_BattleRecorder:getRecordedEvents()

-- 	print(serializeRecordingDataToBase64(recordingData))
-- end)

-- NetEvents:Subscribe('vu-ks-attackheli:record', function(player)
-- 	local result = g_BattleRecorder:startRecording()

-- 	if result == StartRecordingResult.STARTED then
-- 		print('Recording has started!')
-- 	elseif result == StartRecordingResult.NO_LEVEL then
-- 		print('Cannot start recording. No level is currently loaded.')
-- 	elseif result == StartRecordingResult.ALREADY_RECORDING then
-- 		print('Cannot start recording. A recording is already in-progress.')
-- 	end

-- 	local launchTransform = LinearTransform(Vec3(0.206504, 0.000000, -0.978446), Vec3(0.000000, 1.000000, 0.000000), Vec3(0.978446, 0.000000, 0.206504), Vec3(-23.328125, 25.327930, 98.891602))

-- 	local yaw = player.input.authoritativeAimingYaw
-- 	local launchTransform = player.soldier.worldTransform:Clone()
-- 	launchTransform.trans = position
-- 	local params = EntityCreationParams()
-- 	params.transform = launchTransform
-- 	params.networked = true
-- 	local vehicleName = "Vehicles/Venom/Venom"
-- 	local blueprint = ResourceManager:SearchForDataContainer(vehicleName)
-- 	if blueprint == nil then
-- 		print("Missing blueprint"..vehicleName)
-- 		return
-- 	end
-- 	local entity = EntityManager:CreateEntitiesFromBlueprint(blueprint, params)
-- 	if entity == nil then
-- 		print("Missing entity")
-- 		return
-- 	end
-- 	local vehicleEntityBus = EntityBus(entity)
-- 	for _,entity in pairs(vehicleEntityBus.entities) do
-- 		entity = Entity(entity)
-- 		entity:Init(Realm.Realm_ClientAndServer, true)

-- 		if entity:Is('ServerVehicleEntity') then
-- 			ForcePlayerIntoVehicle(player, entity)
-- 			break
-- 		end

-- 	end
-- end