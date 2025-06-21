-- [[ SAFE AIMBOT + ESP - BY ZORO ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- SETTINGS
local ENABLE_AIMBOT = true
local ENABLE_ESP = true
local AIM_PART = "Head"
local AIM_RADIUS = 250
local HOLD_KEY = Enum.UserInputType.MouseButton2

-- GET TARGET
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

-- BYPASS AIMBOT (SAFE: ONLY CAMERA MOVEMENT)
RunService.RenderStepped:Connect(function()
	if ENABLE_AIMBOT and UserInputService:IsMouseButtonPressed(HOLD_KEY) then
		local target = getClosestTarget()
		if target then
			local newCF = CFrame.new(Camera.CFrame.Position, target.Position)
			Camera.CFrame = newCF
		end
	end
end)

-- ESP (SAFE: Drawing API, no GUI injection)
if ENABLE_ESP then
	local function createESP(player)
		local box = Drawing.new("Square")
		box.Color = Color3.fromRGB(255, 0, 0)
		box.Thickness = 1
		box.Transparency = 1
		box.Filled = false

		local nameTag = Drawing.new("Text")
		nameTag.Color = Color3.new(1, 1, 1)
		nameTag.Size = 14
		nameTag.Center = true
		nameTag.Outline = true

		RunService.RenderStepped:Connect(function()
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local hrp = player.Character.HumanoidRootPart
				local pos, visible = Camera:WorldToViewportPoint(hrp.Position)

				if visible then
					local size = (Camera:WorldToViewportPoint(hrp.Position + Vector3.new(2,3,0)) - Camera:WorldToViewportPoint(hrp.Position - Vector3.new(2,3,0))).Magnitude
					box.Size = Vector2.new(size, size * 1.5)
					box.Position = Vector2.new(pos.X - box.Size.X/2, pos.Y - box.Size.Y/2)
					box.Visible = true

					nameTag.Text = player.Name
					nameTag.Position = Vector2.new(pos.X, pos.Y - (box.Size.Y / 2) - 15)
					nameTag.Visible = true
				else
					box.Visible = false
					nameTag.Visible = false
				end
			else
				box.Visible = false
				nameTag.Visible = false
			end
		end)
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			createESP(player)
		end
	end

	Players.PlayerAdded:Connect(function(player)
		if player ~= LocalPlayer then
			createESP(player)
		end
	end)
end
