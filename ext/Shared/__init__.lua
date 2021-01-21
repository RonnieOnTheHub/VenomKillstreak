--print(SharedUtils:GetLevelName())
local mounted = false
Events:Subscribe('Level:LoadResources', function()
    print('Mounting additional super bundles')

    --ResourceManager:MountSuperBundle('SpChunks')

    -- Quad bike
    --ResourceManager:MountSuperBundle('xp3chunks')
    --ResourceManager:MountSuperBundle('levels/xp3_alborz/xp3_alborz')

    -- Dirt bike
    --ResourceManager:MountSuperBundle('mpchunks')
    ResourceManager:MountSuperBundle('Levels/MP_012/MP_012')
end)


Hooks:Install('ResourceManager:LoadBundles', 100, function(hook, bundles, compartment)
    print('Loading bundle')
    print(bundles)

    if #bundles == 1 and bundles[1] == SharedUtils:GetLevelName() then
        print('Loading additional bundles')

        bundles = {
            bundles[1]
        }

        --if SharedUtils:GetLevelName() ~= 'Levels/XP3_Alborz/XP3_Alborz' then
        --    table.insert(bundles, 'Levels/XP3_Alborz/XP3_Alborz')
        --end
        --table.insert(bundles, 'Levels/XP3_Alborz/ConquestLarge01')

        if SharedUtils:GetLevelName() ~= 'Levels/MP_012/MP_012' then
            table.insert(bundles, 'Levels/MP_012/MP_012')
        end
        table.insert(bundles, 'Levels/MP_012/Conquest_Large')

        print("printing all bundles:")
        print(bundles)

        hook:Pass(bundles, compartment)
    end
end)

Events:Subscribe('Level:RegisterEntityResources', function(levelData)
    local conquest = ResourceManager:SearchForInstanceByGuid(Guid('320240bc-173a-5e32-ca75-51e15ac01313'))
    print(conquest)
    local registry = RegistryContainer(conquest)
    ResourceManager:AddRegistry(registry, ResourceCompartment.ResourceCompartment_Game)
end)

local components = nil
local inputCurves = nil

Events:Subscribe('Partition:Loaded', function(partition)
    --print(partition.name)
    for _, instance in pairs(partition.instances) do
        --alwaysFullThrottle
        if instance.instanceGuid == Guid("6c62b15d-848d-bdf3-bd66-218ad0554c14") then
            print("patched ChassisComponentData of venom")
            local chassisComponentData = ChassisComponentData(instance)
            chassisComponentData:MakeWritable()
            --chassisComponentData.alwaysFullThrottle = true --change
        end

        ----PropellerEngineConfigData
        --if instance.instanceGuid == Guid("EB2A9452-2248-42F7-95E7-9482B157B81D") then
        --    print("patched driver PropellerEngineConfigData of venom")
        --    local propellerEngineConfigData = PropellerEngineConfigData(instance)
        --    propellerEngineConfigData:MakeWritable()
        --    propellerEngineConfigData.rpmMin = 5000
        --    propellerEngineConfigData.enginePowerMultiplier = 8
        --end
        ----RotorComponentData
        --if instance.instanceGuid == Guid("03B35A30-0714-69E3-6BB5-37FE37542A99") then
        --    print("patched driver RotorComponentData of venom")
        --    local rotorComponentData = RotorComponentData(instance)
        --    rotorComponentData:MakeWritable()
        --    rotorComponentData.lowRpmModel.rotationRpm = 5000
        --end
        --
        ----EngineComponentData
        --if instance.instanceGuid == Guid("3E923765-87AC-4E84-93AA-606E8C5D5494") then
        --    print("patched driver RotorComponentData of venom")
        --    local engineComponentData = EngineComponentData(instance)
        --    engineComponentData:MakeWritable()
        --    engineComponentData.isPropertyConnectionTarget = 0
        --end

        --driver
        if instance.instanceGuid == Guid("98a7b028-ec93-4a59-a8f6-81b3ef119fce") then
            print("patched driver PlayerEntryComponentData of venom")
            local playerEntryComponentData = PlayerEntryComponentData(instance)
            playerEntryComponentData:MakeWritable()
            --playerEntryComponentData.entrySpottingSettings = 0
            --playerEntryComponentData.forbiddenForHuman = true
            --playerEntryComponentData.entryOrderNumber = 1     --change
            --components = playerEntryComponentData.components
            --inputCurves = playerEntryComponentData.inputCurves
            --playerEntryComponentData.components:clear()
            --playerEntryComponentData.inputCurves.clear()
            --playerEntryComponentData.transform = LinearTransform(
            --        Vec3(1, 0, 0),
            --        Vec3(0, 1, 0),
            --        Vec3(0, 0, 1),
            --        Vec3(0.391037047, -1.03854346, 2.8959167)
            --)
        end

        if instance.instanceGuid == Guid("1D25A98F-26AB-4C86-9E5E-1EAF698A31FF") then
            local worldPartReferenceObjectData = WorldPartReferenceObjectData(instance)
            worldPartReferenceObjectData:MakeWritable()
            worldPartReferenceObjectData.excluded = true
        end


        --gunner
        if instance.instanceGuid == Guid("9c0e9a63-5847-4501-9a2b-4f36ed182ef1") then
            print("patched gunner PlayerEntryComponentData of venom")
            local playerEntryComponentData = PlayerEntryComponentData(instance)
            playerEntryComponentData:MakeWritable()
            --playerEntryComponentData.entryOrderNumber = 0
            --playerEntryComponentData.entrySpottingSettings = 0
            --playerEntryComponentData.showSoldierGearInEntry = true
            --playerEntryComponentData.components:clear()
            --print(components)
            --playerEntryComponentData.components:add(components[1])
            --playerEntryComponentData.components:add(components[2])
            --playerEntryComponentData.components:add(components[3])
            --playerEntryComponentData.components:add(components[4])
            --playerEntryComponentData.components:add(components[5])
            --playerEntryComponentData.components:add(components[6])
            --playerEntryComponentData.components:add(components[7])
            --playerEntryComponentData.components:add(components[8])
            --playerEntryComponentData.inputCurves:add(inputCurves[1])
            --playerEntryComponentData.inputCurves:add(inputCurves[2])
        end

        --venom config data
        if instance.instanceGuid == Guid("18bffc1c-4326-43d1-a326-19c590613b58") then
            print("patched VehicleConfigData of venom")
            local vehicleConfigData = VehicleConfigData(instance)
            vehicleConfigData:MakeWritable()
            vehicleConfigData.vehicleModeAtReset = 4
            vehicleConfigData.vehicleModeChangeStartingTime = 0.0
            --vehicleConfigData.centerOfMassHandlingOffset = Vec3(0.01, 2, 0.05)
            --vehicleConfigData:ClearConstantForce()
            --vehicleConfigData.useGearbox = false
            local constantForceData = ConstantForceData()
            constantForceData.value = Vec3(1,1,1)
            --constantForceData.condition = 2
            constantForceData.typeOfForce = 0
            constantForceData.space = 1
            vehicleConfigData.constantForce:add(constantForceData)
        end

        --venom entity data
        if instance.instanceGuid == Guid("88f274dd-7c84-1ee5-6ee7-dd1d980148b3") then
            print("patched VehicleEntityData of venom")
            local vehicleEntityData = VehicleEntityData(instance)
            vehicleEntityData:MakeWritable()
        end

        if instance.instanceGuid == Guid("D6996433-B669-447F-8B53-C93BFCD02659") then
            print("patched driver SoundPatchAsset of venom")
            local soundPatchAsset = SoundPatchAsset(instance)
            soundPatchAsset:MakeWritable()
            soundPatchAsset.isPersistent = true
        end

    end
end)


--Events:Subscribe(
    --"BundleMounter:GetBundles",
    --function(bundles)
     --   print(SharedUtils:GetLevelName())
     --   name = SharedUtils:GetLevelName()
      --  if name ~= "Levels/MP_012/MP_012" and name ~= nil and mounted == false then
            --Events:Dispatch(
            ---    "BundleMounter:LoadBundles",
            --    "Levels/MP_012/MP_012",
            --    {
            --        "Levels/MP_012/MP_012",
             --       "Levels/MP_012/conquest_large"
            --    }
            --)
       -- end
    --end
--)
