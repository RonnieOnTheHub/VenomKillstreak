NetEvents:Subscribe('vu-ks-attackheli:Launch', function(player, dollo)
	local launchTransform = LinearTransform(Vec3(0.206504, 0.000000, -0.978446), Vec3(0.000000, 1.000000, 0.000000), Vec3(0.978446, 0.000000, 0.206504), Vec3(-23.328125, 25.327930, 98.891602))

	--local yaw = player.input.authoritativeAimingYaw
	--local launchTransform = player.soldier.worldTransform:Clone()
	--launchTransform.trans = position
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
			ForcePlayerIntoVehicle(player, entity)
			break
		end

	end

end)

function ForcePlayerIntoVehicle(player, vehicle)
	player:EnterVehicle(vehicle, 0)
	player:EnableInput(EntryInputActionEnum.EIAInteract, false)
	player:EnableInput(EntryInputActionEnum.EIAChangeVehicle, false)
	player:EnableInput(EntryInputActionEnum.EIAChangeEntry, false)
	player:EnableInput(EntryInputActionEnum.EIAChangeEntry1, false)
	player:EnableInput(EntryInputActionEnum.EIAChangeEntry2, false)
	player:EnableInput(EntryInputActionEnum.EIAChangeEntry3, false)
	player:EnableInput(EntryInputActionEnum.EIAChangeEntry4, false)
	player:EnableInput(EntryInputActionEnum.EIAChangeEntry5, false)
	player:EnableInput(EntryInputActionEnum.EIAChangeEntry6, false)
	player:EnableInput(EntryInputActionEnum.EIAChangeEntry7, false)
	player:EnableInput(EntryInputActionEnum.EIAChangeEntry8, false)
end