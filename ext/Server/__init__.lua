NetEvents:Subscribe('vu-ks-attackheli:Launch', function(player, position)
	--print("Spawning attackheli "..tostring(player.name))
	position.y = position.y+3 
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
	end
end)