
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- SETTINGS
local ENABLE_ESP = true
local AIM_PART = "Head"
local AIM_RADIUS = 400
local HOLD_KEY = Enum.UserInputType.MouseButton2
local aimbotEnabled = true -- Default aktif

-- TOGGLE DENGAN TOMBOL T
UserInputService.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.T then
		aimbotEnabled = not aimbotEnabled
		print("[Zoro Aimbot] Aimbot " .. (aimbotEnabled and "Enabled" or "Disabled"))
	end
end)

-- Ambil target musuh terdekat
local function getClosestTarget()
	local closest = nil
	local shortestDist = AIM_RADIUS

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(AIM_PART) then
			local part = player.Character[AIM_PART]
			local screenPos, visible = Camera:WorldToViewportPoint(part.Position)

			if visible then
				local dist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
				if dist < shortestDist then
					shortestDist = dist
					closest = part
				end
			end
		end
	end

	return closest
end

-- Aimbot Kamera
RunService.RenderStepped:Connect(function()
	if aimbotEnabled and UserInputService:IsMouseButtonPressed(HOLD_KEY) then
		local target = getClosestTarget()
		if target then
			local newCF = CFrame.new(Camera.CFrame.Position, target.Position)
			Camera.CFrame = newCF
		end
	end
end)

-- ESP dengan BillboardGui
if ENABLE_ESP then
	local function createESP(player)
		player.CharacterAdded:Connect(function(character)
			local head = character:WaitForChild("Head", 5)
			if head and not head:FindFirstChild("ZoroESP") then
				local billboard = Instance.new("BillboardGui", head)
				billboard.Name = "ZoroESP"
				billboard.Size = UDim2.new(0, 100, 0, 40)
				billboard.StudsOffset = Vector3.new(0, 2.5, 0)
				billboard.AlwaysOnTop = true
				billboard.Adornee = head

				local nameTag = Instance.new("TextLabel", billboard)
				nameTag.Size = UDim2.new(1, 0, 1, 0)
				nameTag.Text = player.Name
				nameTag.TextColor3 = Color3.new(1, 0, 0)
				nameTag.TextStrokeTransparency = 0.5
				nameTag.BackgroundTransparency = 1
				nameTag.Font = Enum.Font.SourceSansBold
				nameTag.TextScaled = true
			end
		end)
	end

	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			createESP(p)
		end
	end

	Players.PlayerAdded:Connect(function(p)
		if p ~= LocalPlayer then
			createESP(p)
		end
	end)
end
