--print(SharedUtils:GetLevelName())
local mounted = false
Events:Subscribe('Level:LoadResources', function()
    print('Mounting additional super bundles')
    ResourceManager:MountSuperBundle('Levels/MP_012/MP_012')
end)


Hooks:Install('ResourceManager:LoadBundles', 100, function(hook, bundles, compartment)
    
    if #bundles == 1 and bundles[1] == SharedUtils:GetLevelName() then
        -- print('Loading additional bundles')

        bundles = {
            bundles[1]
        }

        if SharedUtils:GetLevelName() ~= 'Levels/MP_012/MP_012' then
            table.insert(bundles, 'Levels/MP_012/MP_012')
        end
        table.insert(bundles, 'Levels/MP_012/Conquest_Large')

        -- print("printing all bundles:")
        -- print(bundles)

        hook:Pass(bundles, compartment)
    end
end)

Events:Subscribe('Level:RegisterEntityResources', function(levelData)
    local conquest = ResourceManager:SearchForInstanceByGuid(Guid('320240bc-173a-5e32-ca75-51e15ac01313'))-- Add the conquest registery
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
            -- print("patched ChassisComponentData of venom")
            local chassisComponentData = ChassisComponentData(instance)
            chassisComponentData:MakeWritable()
            --chassisComponentData.alwaysFullThrottle = true --change
        end
        
        --driver
        -- if instance.instanceGuid == Guid("98a7b028-ec93-4a59-a8f6-81b3ef119fce") then
        --     print("patched driver PlayerEntryComponentData of venom")
        --     local playerEntryComponentData = PlayerEntryComponentData(instance)
        --     playerEntryComponentData:MakeWritable()
        --     --playerEntryComponentData.entrySpottingSettings = 0
        --     --playerEntryComponentData.forbiddenForHuman = true
        --     --playerEntryComponentData.entryOrderNumber = 1     --change
        -- end

        --invisible walls on ziba
        if instance.instanceGuid == Guid("1D25A98F-26AB-4C86-9E5E-1EAF698A31FF") then
            local worldPartReferenceObjectData = WorldPartReferenceObjectData(instance)
            worldPartReferenceObjectData:MakeWritable()
            worldPartReferenceObjectData.excluded = true
        end


        --gunner
        -- if instance.instanceGuid == Guid("9c0e9a63-5847-4501-9a2b-4f36ed182ef1") then
        --     print("patched gunner PlayerEntryComponentData of venom")
        --     local playerEntryComponentData = PlayerEntryComponentData(instance)
        --     playerEntryComponentData:MakeWritable()
        --     --playerEntryComponentData.entryOrderNumber = 0
        -- end

        --venom config data
        if instance.instanceGuid == Guid("18bffc1c-4326-43d1-a326-19c590613b58") then
            print("patched VehicleConfigData of venom")
            local vehicleConfigData = VehicleConfigData(instance)
            vehicleConfigData:MakeWritable()
            vehicleConfigData.vehicleModeAtReset = 4
            vehicleConfigData.vehicleModeChangeStartingTime = 0.0
        end

        --venom entity data
        if instance.instanceGuid == Guid("88f274dd-7c84-1ee5-6ee7-dd1d980148b3") then
            print("patched VehicleEntityData of venom")
            local vehicleEntityData = VehicleEntityData(instance)
            vehicleEntityData:MakeWritable()
            vehicleEntityData.exitAllowed = true
        end

    end
end)