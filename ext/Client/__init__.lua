Events:Subscribe("Player:UpdateInput", function()
	if InputManager:WentKeyUp(InputDeviceKeys.IDK_F9) then
		NetEvents:SendLocal("vu-ks-attackheli:launch")
		print("Killstreak used")
	end

	if InputManager:WentKeyUp(InputDeviceKeys.IDK_F8) then
		NetEvents:SendLocal("vu-ks-attackheli:save")
		print("saved")
	end

	if InputManager:WentKeyUp(InputDeviceKeys.IDK_F7) then
		NetEvents:SendLocal("vu-ks-attackheli:record")
		print("record")
	end
end)