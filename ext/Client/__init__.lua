-- Only enable while developing
local debug = false

Events:Subscribe(
	"vu-ks-venom:Invoke",
	function(stepNr, keyboardKey)
		print("Killstreak enabled")
		--Events:Dispatch("Killstreak:newTimer", json.encode({duration = 190, text = "Venom"}))
		Events:Dispatch("Killstreak:usedStep", stepNr, false)
		NetEvents:SendLocal("vu-ks-venom:Launch")
	end
)

if debug then
	Events:Subscribe("Player:UpdateInput", function()
		if InputManager:WentKeyUp(InputDeviceKeys.IDK_F9) then
			NetEvents:SendLocal("vu-ks-venom:Launch")
			print("Killstreak used")
		end

		if InputManager:WentKeyUp(InputDeviceKeys.IDK_F8) then
			NetEvents:SendLocal("vu-ks-venom:Save")
			print("saved")
		end

		if InputManager:WentKeyUp(InputDeviceKeys.IDK_F7) then
			NetEvents:SendLocal("vu-ks-venom:Record")
			print("record")
		end
	end)
end