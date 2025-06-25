-- Bruh Egg
-- DC | Austin11111888
-- Test Commit | 9
-- Report Issues To Me | Thank You
if game.PlaceId == 85896571713843 then
	repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
	task.wait(0.5)

	--// Config \\--
	local RiftNames = {"bruh-egg", "rainbow-egg", "spikey-egg", "void-egg", "nightmare-egg"}
	local RejoinIfMissing = true

	--// Services \\--
	local Players = game:GetService("Players")
	local TeleportService = game:GetService("TeleportService")
	local TweenService = game:GetService("TweenService")
	local RunService = game:GetService("RunService")
	local Workspace = game:GetService("Workspace")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local VirtualInputManager = game:GetService("VirtualInputManager")
	local player = Players.LocalPlayer

	--// References \\--
	local IslandsFolder = Workspace.Worlds["The Overworld"].Islands
	local Path = Workspace:WaitForChild("Rendered"):WaitForChild("Rifts")
	local Teleport = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("RemoteEvent")

	local IslandRefs = {
		Floating = {
			Position = IslandsFolder["Floating Island"].Island.Input.Position,
			Teleport = "Workspace.Worlds.The Overworld.Islands.Floating Island.Island.Portal.Spawn"
		},
		Space = {
			Position = IslandsFolder["Outer Space"].Island.Input.Position,
			Teleport = "Workspace.Worlds.The Overworld.Islands.Outer Space.Island.Portal.Spawn"
		},
		Twilight = {
			Position = IslandsFolder["Twilight"].Island.Input.Position,
			Teleport = "Workspace.Worlds.The Overworld.Islands.Twilight.Island.Portal.Spawn"
		},
		Void = {
			Position = IslandsFolder["The Void"].Island.Input.Position,
			Teleport = "Workspace.Worlds.The Overworld.Islands.The Void.Island.Portal.Spawn"
		},
		Zen = {
			Position = IslandsFolder["Zen"].Island.Input.Position,
			Teleport = "Workspace.Worlds.The Overworld.Islands.Zen.Island.Portal.Spawn"
		}
	}

	--// Helper Functions \\--
	local function getClosestIsland(targetPosition)
		local closestKey = nil
		local shortestDistance = math.huge

		for key, data in pairs(IslandRefs) do
			local dist = (targetPosition - data.Position).Magnitude
			if dist < shortestDistance then
				shortestDistance = dist
				closestKey = key
			end
		end

		return closestKey, shortestDistance
	end

	local function tweenToRift(target)
		if not (target and target:IsA("BasePart")) then
			warn("⚠️ Invalid Target Passed To Function")
			return
		end

		local character = player.Character or player.CharacterAdded:Wait()
		local root = character:FindFirstChild("HumanoidRootPart")
		if not root then
			warn("⚠️ HumanoidRootPart Not Found")
			return
		end

		local startPos = root.Position
		local endPos = target.Position + Vector3.new(0, 10, 0)
		local totalDistance = (startPos - endPos).Magnitude

		local studsPerSecond = 500
		local totalTime = math.clamp(totalDistance / studsPerSecond, 4, 500)
		local speed = totalDistance / totalTime

		local direction = (endPos - startPos).Unit
		local startTime = tick()

		local connection
		connection = RunService.Heartbeat:Connect(function()
			local elapsed = tick() - startTime
			local moveAmount = math.min(elapsed * speed, totalDistance)
			local newPos = startPos + direction * moveAmount

			root.CFrame = CFrame.new(newPos, newPos + root.CFrame.LookVector)

			if moveAmount >= totalDistance then
				connection:Disconnect()
				print(string.format("✅ Arrived At %s (%.2f studs)", target.Name, totalDistance))
			end
		end)

		print(string.format("🚶 Moving To Rift '%s' Over %.2f Seconds (%.2f studs)", target.Name, totalTime, totalDistance))
	end

    local function formatTime(seconds)
        local mins = math.floor(seconds / 60)
        local secs = seconds % 60
        return string.format("%d minute%s %d second%s", mins, mins ~= 1 and "s" or "", secs, secs ~= 1 and "s" or "")
    end

	--// Main Loop \\--
	while true do
		task.wait(0.5)
		local found = false

		for _, rift in pairs(Path:GetChildren()) do
			for _, targetName in ipairs(RiftNames) do
				if rift.Name == targetName then
					print("✅ Rift Found:", rift.Name)
					found = true

                    local despawnAt = rift:GetAttribute("DespawnAt")
                    local timeLeft = math.max(0, math.floor(despawnAt - os.time()))

                    local expiresIn = formatTime(timeLeft)
					
                    local output = rift:FindFirstChild("Output")
					if output and output:IsA("BasePart") then
						local closestKey, distance = getClosestIsland(output.Position)

						if closestKey then
							local data = IslandRefs[closestKey]
							print(string.format("📍 Closest island to '%s' Output is: %s (%.2f studs away)", rift.Name, closestKey, distance))

							Teleport:FireServer("Teleport", data.Teleport)
							task.wait(2)
							tweenToRift(output)
							task.spawn(function()
							    while output do
							        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
							        task.wait()
							        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
							        task.wait()
							    end
							end)
							task.spawn(function()
								while true do
									task.wait(0.5)
									if not output or not output.Parent or not Path:FindFirstChild(rift.Name) then
										warn("❌ Rift despawned. Kicking player...")
										player:Kick("❌ Rift Despawned.\nRejoining...")
										task.wait(0.25)
										TeleportService:Teleport(game.PlaceId, player)
										break
									end
									local distance = (root.CFrame - output.CFrame).Magnitude
									if distance <= 15 then
										local goalCFrame = CFrame.new(output.CFrame + Vector3.new(0, 5, 0))
										local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
										local tween = TweenService:Create(root, tweenInfo, { CFrame = goalCFrame })
										tween:Play()
									end
								end
							end)
						else
							warn("⚠️ No Valid Island Positions To Compare.")
						end
					else
						warn("⚠️ No Output Found In Rift:", rift.Name)
					end

					break
				end
			end
			if found then break end
		end

		if not found and RejoinIfMissing then
			warn("❌ Target Rift Not Found. Rejoining...")
			player:Kick("❌ Rift Not Found.\nRejoining...")
			task.wait(0.25)
			TeleportService:Teleport(game.PlaceId, player)
			break
		else
			break
		end
	end
else
	return game.Players.LocalPlayer:Kick("❌ Invalid SessionID.")
end
