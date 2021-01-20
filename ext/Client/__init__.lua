local STRIKE_AREA_RADIUS = 50
local STRIKE_DURATION = 15
local STRIKE_MISSILE_COUNT = 40
local debug = true
local FiringMode = {
	Disabled = 0,
	Target = 1,
	Area = 2
}

local configs = {
	[FiringMode.Target] = {
		{radius = 1, segments = 15, width = 0.5},
		{radius = 2, segments = 20, width = 0.5},
		{radius = 3, segments = 25, width = 0.5}
	},
	[FiringMode.Area] = {{radius = STRIKE_AREA_RADIUS, segments = 80, width = 1}}
}

local pointOfAim = {
	position = Vec3(),
	points = {},
	mode = FiringMode.Disabled
}

local pointOfAimCircle = {
	position = Vec3(),
	points = {},
	mode = FiringMode.Area
}

local targets = {}
local pending = {}
local zones = {}

local drawHudEvent = nil
local updateEvent = nil

local RED = Vec4(1, 0, 0, 0.5)
local WHITE = Vec4(1, 1, 1, 0.5)

local outOfBound = false

--zones[#zones + 1] = {position = ClientUtils:GetCameraTransform().trans, points = {}, timer = 0}

Events:Subscribe(
	"vu-ks-attackheli:Disable",
	function(stepNr)
		print("Killstreak disabled")
		pointOfAim.mode = FiringMode.Disabled
		Events:Unsubscribe("Player:UpdateInput")
		Events:Unsubscribe("UpdateManager:Update")
		Events:Unsubscribe("UI:DrawHud")
		updateEvent = nil
		drawHudEvent = nil
	end
)

Hooks:Install(
	"UI:PushScreen",
	1,
	function(hook, screen, priority, parentGraph, stateNodeGuid)
		local screen = UIGraphAsset(screen)

		if screen.name == "UI/Flow/Screen/KillScreen" and (pointOfAim.mode == 1 or pointOfAim.mode == 2) then
			pointOfAim.mode = FiringMode.Disabled
			Events:Unsubscribe("Player:UpdateInput")
			Events:Unsubscribe("UpdateManager:Update")
			Events:Unsubscribe("UI:DrawHud")
			updateEvent = nil
			drawHudEvent = nil
		end
	end
)

Events:Subscribe(
	"vu-ks-attackheli:Invoke",
	function(stepNr, keyboardKey)
		print("Killstreak enabled")
		pointOfAim.mode = FiringMode.Target
		Events:Subscribe(
			"Player:UpdateInput",
			function()
				if updateEvent == nil then
					updateEvent = Events:Subscribe("UpdateManager:Update", OnUpdate)
				end

				if drawHudEvent == nil then
					drawHudEvent = Events:Subscribe("UI:DrawHud", OnDrawHud)
				end
				if outOfBound then
					return
				end
				if InputManager:WentKeyUp(InputDeviceKeys.IDK_F9) and pointOfAim.mode == FiringMode.Target then
					NetEvents:SendLocal("vu-ks-attackheli:Launch", pointOfAim.position)
					print("Killstreak used")
					pointOfAim.mode = FiringMode.Disabled
					Events:Dispatch("Killstreak:usedStep", stepNr)
					Events:Unsubscribe("Player:UpdateInput")
					Events:Unsubscribe("UpdateManager:Update")
					Events:Unsubscribe("UI:DrawHud")
					updateEvent = nil
					drawHudEvent = nil
				end
			end
		)
	end
)
if debug then
	Events:Subscribe(
		"Player:UpdateInput",
		function()
			if InputManager:WentKeyDown(InputDeviceKeys.IDK_F1) then
				pointOfAim.mode = FiringMode.Target

				if drawHudEvent == nil then
					drawHudEvent = Events:Subscribe("UI:DrawHud", OnDrawHud)
				end

				if updateEvent == nil then
					updateEvent = Events:Subscribe("UpdateManager:Update", OnUpdate)
				end
			end

			if InputManager:WentKeyDown(InputDeviceKeys.IDK_F3) then
				pointOfAim.mode = FiringMode.Disabled
			end

			if InputManager:WentKeyDown(InputDeviceKeys.IDK_F9) and pointOfAim.mode == FiringMode.Target then
				if outOfBound then
					return
				end
				NetEvents:SendLocal("vu-ks-attackheli:Launch", pointOfAim.position)

				targets[#targets + 1] = {position = pointOfAim.position:Clone(), points = {}, timer = MISSILE_AIRTIME}
			end
		end
	)
end
function OnDrawHud()
	if pointOfAim.mode ~= FiringMode.Disabled then
		distX = ClientUtils:GetCameraTransform().trans:Distance(pointOfAim.position)
		if distX < STRIKE_AREA_RADIUS then
			DrawTarget(pointOfAim.points, pointOfAim.mode, WHITE)
			if outOfBound == true then
				outOfBound = false
			end
		else
			if outOfBound == false then
				outOfBound = true
			end
		end
		for _, zone in pairs(zones) do
			if #zone.points > 0 then
				DrawTarget(pointOfAimCircle.points, FiringMode.Area, WHITE)
			end
		end

	end
end

function DrawTarget(points, mode, color)
	local vertices = {}
	for index, config in pairs(configs[mode]) do
		local len = #points[index].inner

		for i = 1, len - 1 do
			DrawTriangle(vertices, points[index].inner[i], points[index].outer[i], points[index].outer[i + 1], color)
			DrawTriangle(vertices, points[index].inner[i], points[index].inner[i + 1], points[index].outer[i + 1], color)
		end

		DrawTriangle(vertices, points[index].inner[len], points[index].outer[len], points[index].outer[1], color)
		DrawTriangle(vertices, points[index].inner[len], points[index].inner[1], points[index].outer[1], color)
	end

	DebugRenderer:DrawVertices(0, vertices)
end

function DrawTriangle(vertices, pt1, pt2, pt3, color)
	local i = #vertices

	vertices[i + 1] = GetVertexForPoint(pt1, color)
	vertices[i + 2] = GetVertexForPoint(pt2, color)
	vertices[i + 3] = GetVertexForPoint(pt3, color)
end

function GetVertexForPoint(vec3, color)
	local vertex = DebugVertex()
	vertex.pos = vec3
	vertex.color = color

	return vertex
end

function OnUpdate(delta, pass)
	-- Only do raycast on presimulation UpdatePass
	if pass ~= UpdatePass.UpdatePass_PreSim then
		return
	end

	-- Point of aim
	local raycastHit = Raycast()

	if raycastHit == nil then
		return
	end
	--pointOfAimCircle.position = ClientUtils:GetCameraTransform().trans
	pointOfAim.position = raycastHit.position

	if pointOfAim.mode ~= FiringMode.Disabled then
		for index, config in pairs(configs[pointOfAim.mode]) do
			local innerPoints = GetCirclePoints(pointOfAim.position, config.radius - config.width, config.segments)
			local outerPoints = GetCirclePoints(pointOfAim.position, config.radius, config.segments)

			pointOfAim.points[index] = {inner = {}, outer = {}}

			for i = 1, config.segments do
				pointOfAim.points[index].inner[i] = RaycastDown(innerPoints[i])
				pointOfAim.points[index].outer[i] = RaycastDown(outerPoints[i])
			end
		end

		--for index, config in pairs(configs[pointOfAimCircle.mode]) do
		--	local innerPoints = GetCirclePoints(pointOfAimCircle.position, config.radius - config.width, config.segments)
		--	local outerPoints = GetCirclePoints(pointOfAimCircle.position, config.radius, config.segments)
--
		--	pointOfAimCircle.points[index] = {inner = {}, outer = {}}

		--	for i = 1, config.segments do
		--		pointOfAimCircle.points[index].inner[i] = RaycastDown(innerPoints[i])
		--		pointOfAimCircle.points[index].outer[i] = RaycastDown(outerPoints[i])
		--	end
		--end
	end

	-- Targets
	for _, target in pairs(targets) do
		if #target.points == 0 then
			for index, config in pairs(configs[FiringMode.Target]) do
				local innerPoints = GetCirclePoints(target.position, config.radius - config.width, config.segments)
				local outerPoints = GetCirclePoints(target.position, config.radius, config.segments)

				target.points[index] = {inner = {}, outer = {}}

				for i = 1, config.segments do
					target.points[index].inner[i] = RaycastDown(innerPoints[i])
					target.points[index].outer[i] = RaycastDown(outerPoints[i])
				end
			end
		end
	end

	-- Targets
	for _, zone in pairs(zones) do
		if #zone.points == 0 then
			for index, config in pairs(configs[FiringMode.Area]) do
				local innerPoints = GetCirclePoints(zone.position, config.radius - config.width, config.segments)
				local outerPoints = GetCirclePoints(zone.position, config.radius, config.segments)

				zone.points[index] = {inner = {}, outer = {}}

				for i = 1, config.segments do
					zone.points[index].inner[i] = RaycastDown(innerPoints[i])
					zone.points[index].outer[i] = RaycastDown(outerPoints[i])
				end
			end
		end
	end
end

function GetCirclePoints(center, radius, segmentCount)
	local points = {}

	local yaw = 0

	local yawOffset = 2 * math.pi / segmentCount

	for i = 0, segmentCount do
		yaw = yaw + yawOffset

		local direction = MathUtils:GetTransformFromYPR(yaw, 0, 0)

		points[#points + 1] = center + direction.forward * radius
	end

	return points
end

function RaycastDown(position)
	local castStart = Vec3(position.x, position.y + 100, position.z)

	local castEnd = Vec3(position.x, position.y - 100, position.z)

	-- Perform raycast, returns a RayCastHit object.
	local raycastHit =
		RaycastManager:Raycast(
		castStart,
		castEnd,
		RayCastFlags.DontCheckWater | RayCastFlags.DontCheckCharacter | RayCastFlags.DontCheckRagdoll |
			RayCastFlags.CheckDetailMesh
	)

	if raycastHit == nil then
		return position
	end

	return raycastHit.position
end

-- stolen't https://github.com/EmulatorNexus/VEXT-Samples/blob/80cddf7864a2cdcaccb9efa810e65fae1baeac78/no-headglitch-raycast/ext/Client/__init__.lua
function Raycast()
	local localPlayer = PlayerManager:GetLocalPlayer()

	if localPlayer == nil then
		return
	end

	-- We get the camera transform, from which we will start the raycast. We get the direction from the forward vector. Camera transform
	-- is inverted, so we have to invert this vector.
	local transform = ClientUtils:GetCameraTransform()
	local direction = Vec3(-transform.forward.x, -transform.forward.y, -transform.forward.z)

	if transform.trans == Vec3(0, 0, 0) then
		return
	end

	local castStart = transform.trans

	-- We get the raycast end transform with the calculated direction and the max distance.
	local castEnd =
		Vec3(
		transform.trans.x + (direction.x * 1000),
		transform.trans.y + (direction.y * 1000),
		transform.trans.z + (direction.z * 1000)
	)

	-- Perform raycast, returns a RayCastHit object.
	local raycastHit =
		RaycastManager:Raycast(
		castStart,
		castEnd,
		RayCastFlags.DontCheckWater | RayCastFlags.DontCheckCharacter | RayCastFlags.DontCheckRagdoll |
			RayCastFlags.CheckDetailMesh
	)

	return raycastHit
end
