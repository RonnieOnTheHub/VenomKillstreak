local mounted = false

require('__shared/mapConfigurations')

function findVenom()
    local searchVehicle = ResourceManager:SearchForDataContainer("Vehicles/Venom/Venom")
    if searchVehicle ~= nil then
        print("SearchForDataContainer: found Venom")
        else
            print("SearchForDataContainer: Venom is not here")
    end
end

Events:Subscribe('Level:LoadResources', function()
    local firestorm = ResourceManager:SearchForDataContainer("Levels/MP_013/MP_013")
    if firestorm == nil then
        print('LoadResources: mounting additional super bundles')
        ResourceManager:MountSuperBundle('Levels/MP_013/MP_013')
    else
        print("LoadResources: Firestorm already loaded")
    end
end)


Hooks:Install('ResourceManager:LoadBundles', 100, function(hook, bundles, compartment)   
    local levelName = SharedUtils:GetLevelName()
    if #bundles == 1 and bundles[1] == levelName then
        print("LoadBundles patching")

        local mapConfiguration = mapConfigurations[levelName]
        if mapConfiguration == nil then
            mapConfiguration = mapConfigurations["default"]
            print("Picking default map config for " .. levelName)
        end

        bundles = {
            bundles[1]
        }

        for index, bundle in ipairs(mapConfiguration["bundles"]) do
            table.insert(bundles, bundle)
            print("LoadBundles: adding " .. bundle .. " into: " .. levelName)
        end
        print(bundles)

        hook:Pass(bundles, compartment)
    end
end)

Events:Subscribe('Level:RegisterEntityResources', function(levelData)
    local levelName = SharedUtils:GetLevelName()
    local mapConfiguration = mapConfigurations[levelName]
    if mapConfiguration == nil then
        print("Picking default map config for " .. levelName)
        mapConfiguration = mapConfigurations["default"]
    end

    print(mapConfiguration)
    local resource = ResourceManager:SearchForDataContainer(mapConfiguration["subworldData"])
    if resource == nil then
        print("Unable txo find: " .. mapConfiguration["subworldData"])
        return
    end
    local subworldData = SubWorldData(resource)
    if subworldData == nil or subworldData.registryContainer == nil then
        print("subworldData or registrycontainer is nil")
        return
    end
    local registry = RegistryContainer(subworldData.registryContainer)
    if registry == nil then
        print("registry is nill")
        return
    end
    ResourceManager:AddRegistry(registry, ResourceCompartment.ResourceCompartment_Game)
    findVenom()
end)

local components = nil
local inputCurves = nil


---instances changes
-- ziba walls
ResourceManager:RegisterInstanceLoadHandler(Guid('2DF41167-0BAB-11E1-AA4E-EFBA5D767A10'), Guid('1D25A98F-26AB-4C86-9E5E-1EAF698A31FF'), function(instance)
    local worldPartReferenceObjectData = WorldPartReferenceObjectData(instance)
    print("Partition Loaded: removed invisible walls on ziba")
    worldPartReferenceObjectData:MakeWritable()
    worldPartReferenceObjectData.excluded = true
end)

-- xp2_factory walls
ResourceManager:RegisterInstanceLoadHandler(Guid('A0EFD05D-D405-44FC-B568-042B36F85556'), Guid('18368EFD-FD6D-4901-8038-F867836F0A83'), function(instance)
    local referenceObjectData = ReferenceObjectData(instance)
    print("Partition Loaded: removed invisible1 walls on scrapmetal")
    referenceObjectData:MakeWritable()
    referenceObjectData.excluded = true
end)
ResourceManager:RegisterInstanceLoadHandler(Guid('A0EFD05D-D405-44FC-B568-042B36F85556'), Guid('6EAB5B8C-21A4-4165-AC47-779C850D86DE'), function(instance)
    local referenceObjectData = ReferenceObjectData(instance)
    print("Partition Loaded: removed invisible2 walls on scrapmetal")
    referenceObjectData:MakeWritable()
    referenceObjectData.excluded = true
end)
ResourceManager:RegisterInstanceLoadHandler(Guid('A0EFD05D-D405-44FC-B568-042B36F85556'), Guid('6EC86941-BFEE-404B-9171-333BCE1139CA'), function(instance)
    local referenceObjectData = ReferenceObjectData(instance)
    print("Partition Loaded: removed invisible3 walls on scrapmetal")
    referenceObjectData:MakeWritable()
    referenceObjectData.excluded = true
end)
ResourceManager:RegisterInstanceLoadHandler(Guid('A0EFD05D-D405-44FC-B568-042B36F85556'), Guid('FA5B12DF-FDBC-4285-A534-575053825A9B'), function(instance)
    local referenceObjectData = ReferenceObjectData(instance)
    print("Partition Loaded: removed invisible4 walls on scrapmetal")
    referenceObjectData:MakeWritable()
    referenceObjectData.excluded = true
end)
ResourceManager:RegisterInstanceLoadHandler(Guid('A0EFD05D-D405-44FC-B568-042B36F85556'), Guid('98B4C686-AFA4-44E8-BAB4-4E87B4F35297'), function(instance)
    local referenceObjectData = ReferenceObjectData(instance)
    print("Partition Loaded: removed invisible5 walls on scrapmetal")
    referenceObjectData:MakeWritable()
    referenceObjectData.excluded = true
end)
ResourceManager:RegisterInstanceLoadHandler(Guid('A0EFD05D-D405-44FC-B568-042B36F85556'), Guid('6DE1E7DE-5A5D-4D2E-B897-F58ADAFD5DC8'), function(instance)
    local referenceObjectData = ReferenceObjectData(instance)
    print("Partition Loaded: removed invisible6 walls on scrapmetal")
    referenceObjectData:MakeWritable()
    referenceObjectData.excluded = true
end)
ResourceManager:RegisterInstanceLoadHandler(Guid('A0EFD05D-D405-44FC-B568-042B36F85556'), Guid('99EE1CB1-54A9-4A0F-947C-CFB09E13E833'), function(instance)
    local referenceObjectData = ReferenceObjectData(instance)
    print("Partition Loaded: removed invisible7 walls on scrapmetal")
    referenceObjectData:MakeWritable()
    referenceObjectData.excluded = true
end)
ResourceManager:RegisterInstanceLoadHandler(Guid('A0EFD05D-D405-44FC-B568-042B36F85556'), Guid('3834705D-AACB-4611-9E67-F7A3419A5DED'), function(instance)
    local referenceObjectData = ReferenceObjectData(instance)
    print("Partition Loaded: removed invisible8 walls on scrapmetal")
    referenceObjectData:MakeWritable()
    referenceObjectData.excluded = true
end)
ResourceManager:RegisterInstanceLoadHandler(Guid('A0EFD05D-D405-44FC-B568-042B36F85556'), Guid('E8AB2428-205A-44BE-9782-A104C711D0A7'), function(instance)
    local referenceObjectData = ReferenceObjectData(instance)
    print("Partition Loaded: removed invisible9 walls on scrapmetal")
    referenceObjectData:MakeWritable()
    referenceObjectData.excluded = true
end)
ResourceManager:RegisterInstanceLoadHandler(Guid('A0EFD05D-D405-44FC-B568-042B36F85556'), Guid('7349B59B-73C0-4E03-AF5E-8E9620DC5678'), function(instance)
    local referenceObjectData = ReferenceObjectData(instance)
    print("Partition Loaded: removed invisible10 walls on scrapmetal")
    referenceObjectData:MakeWritable()
    referenceObjectData.excluded = true
end)
ResourceManager:RegisterInstanceLoadHandler(Guid('A0EFD05D-D405-44FC-B568-042B36F85556'), Guid('7A4D21AF-F1ED-436B-82FC-05DD32C52255'), function(instance)
    local referenceObjectData = ReferenceObjectData(instance)
    print("Partition Loaded: removed invisible11 walls on scrapmetal")
    referenceObjectData:MakeWritable()
    referenceObjectData.excluded = true
end)


--venom config data
ResourceManager:RegisterInstanceLoadHandler(Guid('97945D87-011D-11E0-B97C-FC495C335A52'), Guid('18bffc1c-4326-43d1-a326-19c590613b58'), function(instance)
    print("Partition Loaded: patched VehicleConfigData of venom")
    local vehicleConfigData = VehicleConfigData(instance)
    vehicleConfigData:MakeWritable()
    vehicleConfigData.vehicleModeAtReset = 4
    vehicleConfigData.vehicleModeChangeStartingTime = 0.0
end)

--venom entity data
ResourceManager:RegisterInstanceLoadHandler(Guid('97945D87-011D-11E0-B97C-FC495C335A52'), Guid('88f274dd-7c84-1ee5-6ee7-dd1d980148b3'), function(instance)
    print("Partition Loaded: patched VehicleEntityData of venom")
    local vehicleEntityData = VehicleEntityData(instance)
    vehicleEntityData:MakeWritable()
    vehicleEntityData.exitAllowed = true
end)