-- Boost Effects Client Script
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Import shared configuration
local GameConfig = require(ReplicatedStorage:WaitForChild("GameConfig"))

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Active boost effects
local activeEffects = {}
local coinMagnetConnection = nil

-- Create boost UI indicators
local boostGui = Instance.new("ScreenGui")
boostGui.Name = "BoostEffects"
boostGui.ResetOnSpawn = false
boostGui.Parent = playerGui

local boostFrame = Instance.new("Frame")
boostFrame.Name = "BoostFrame"
boostFrame.Size = UDim2.new(0, 300, 0, 100)
boostFrame.Position = UDim2.new(0, 20, 0, 320)
boostFrame.BackgroundTransparency = 1
boostFrame.Parent = boostGui

-- Speed boost effect
local function createSpeedBoostEffect()
	if activeEffects.SPEED_BOOST then return end

	local speedIndicator = Instance.new("Frame")
	speedIndicator.Name = "SpeedBoost"
	speedIndicator.Size = UDim2.new(0, 80, 0, 80)
	speedIndicator.Position = UDim2.new(0, 0, 0, 0)
	speedIndicator.BackgroundColor3 = Color3.new(0, 0.8, 1)
	speedIndicator.BorderSizePixel = 0
	speedIndicator.Parent = boostFrame

	local speedCorner = GameConfig.createUICorner(10)
	speedCorner.Parent = speedIndicator

	local speedIcon = Instance.new("TextLabel")
	speedIcon.Size = UDim2.new(1, 0, 0.7, 0)
	speedIcon.Position = UDim2.new(0, 0, 0, 0)
	speedIcon.BackgroundTransparency = 1
	speedIcon.Text = "⚡"
	speedIcon.TextColor3 = Color3.new(1, 1, 1)
	speedIcon.TextScaled = true
	speedIcon.Font = Enum.Font.GothamBold
	speedIcon.Parent = speedIndicator

	local speedTimer = Instance.new("TextLabel")
	speedTimer.Name = "Timer"
	speedTimer.Size = UDim2.new(1, 0, 0.3, 0)
	speedTimer.Position = UDim2.new(0, 0, 0.7, 0)
	speedTimer.BackgroundTransparency = 1
	speedTimer.Text = "5:00"
	speedTimer.TextColor3 = Color3.new(1, 1, 1)
	speedTimer.TextScaled = true
	speedTimer.Font = Enum.Font.Gotham
	speedTimer.Parent = speedIndicator

	-- Pulsing animation
	local pulseInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
	local pulseTween = TweenService:Create(speedIndicator, pulseInfo, {
		Size = UDim2.new(0, 85, 0, 85)
	})
	pulseTween:Play()

	activeEffects.SPEED_BOOST = {
		indicator = speedIndicator,
		tween = pulseTween,
		timer = speedTimer
	}

	-- Apply speed boost to character
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		local humanoid = player.Character.Humanoid
		local originalSpeed = humanoid.WalkSpeed
		humanoid.WalkSpeed = originalSpeed * GameConfig.SHOP_ITEMS.SPEED_BOOST.multiplier

		-- Create trail effect
		local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
		if rootPart then
			local attachment1 = Instance.new("Attachment")
			attachment1.Position = Vector3.new(-0.5, 0, 0)
			attachment1.Parent = rootPart

			local attachment2 = Instance.new("Attachment")
			attachment2.Position = Vector3.new(0.5, 0, 0)
			attachment2.Parent = rootPart

			local trail = Instance.new("Trail")
			trail.Attachment0 = attachment1
			trail.Attachment1 = attachment2
			trail.Color = ColorSequence.new(Color3.new(0, 0.8, 1))
			trail.Transparency = NumberSequence.new{
				NumberSequenceKeypoint.new(0, 0.5),
				NumberSequenceKeypoint.new(1, 1)
			}
			trail.Lifetime = 0.5
			trail.MinLength = 0
			trail.Parent = rootPart

			activeEffects.SPEED_BOOST.trail = trail
			activeEffects.SPEED_BOOST.attachments = {attachment1, attachment2}
		end
	end
end

-- Coin magnet effect
local function createCoinMagnetEffect()
	if activeEffects.COIN_MAGNET then return end

	local magnetIndicator = Instance.new("Frame")
	magnetIndicator.Name = "CoinMagnet"
	magnetIndicator.Size = UDim2.new(0, 80, 0, 80)
	magnetIndicator.Position = UDim2.new(0, 90, 0, 0)
	magnetIndicator.BackgroundColor3 = Color3.new(1, 0.5, 0)
	magnetIndicator.BorderSizePixel = 0
	magnetIndicator.Parent = boostFrame

	local magnetCorner = GameConfig.createUICorner(10)
	magnetCorner.Parent = magnetIndicator

	local magnetIcon = Instance.new("TextLabel")
	magnetIcon.Size = UDim2.new(1, 0, 0.7, 0)
	magnetIcon.Position = UDim2.new(0, 0, 0, 0)
	magnetIcon.BackgroundTransparency = 1
	magnetIcon.Text = "🧲"
	magnetIcon.TextColor3 = Color3.new(1, 1, 1)
	magnetIcon.TextScaled = true
	magnetIcon.Font = Enum.Font.GothamBold
	magnetIcon.Parent = magnetIndicator

	local magnetTimer = Instance.new("TextLabel")
	magnetTimer.Name = "Timer"
	magnetTimer.Size = UDim2.new(1, 0, 0.3, 0)
	magnetTimer.Position = UDim2.new(0, 0, 0.7, 0)
	magnetTimer.BackgroundTransparency = 1
	magnetTimer.Text = "3:00"
	magnetTimer.TextColor3 = Color3.new(1, 1, 1)
	magnetTimer.TextScaled = true
	magnetTimer.Font = Enum.Font.Gotham
	magnetTimer.Parent = magnetIndicator

	activeEffects.COIN_MAGNET = {
		indicator = magnetIndicator,
		timer = magnetTimer
	}

	-- Start coin magnet logic
	coinMagnetConnection = RunService.Heartbeat:Connect(function()
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local rootPart = player.Character.HumanoidRootPart
			local magnetRange = GameConfig.SHOP_ITEMS.COIN_MAGNET.range

			-- Find nearby coins
			for _, obj in pairs(Workspace:GetChildren()) do
				if obj.Name == "Coin" and obj:IsA("Part") then
					local distance = (obj.Position - rootPart.Position).Magnitude
					if distance <= magnetRange then
						-- Move coin towards player
						local direction = (rootPart.Position - obj.Position).Unit
						obj.Position = obj.Position + direction * 2
					end
				end
			end
		end
	end)
end

-- Double/Triple coins effect
local function createCoinMultiplierEffect(multiplierType)
	if activeEffects[multiplierType] then return end

	local multiplier = GameConfig.SHOP_ITEMS[multiplierType].multiplier
	local color = multiplier == 2 and Color3.new(0, 1, 0) or Color3.new(1, 0, 1)

	local multiplierIndicator = Instance.new("Frame")
	multiplierIndicator.Name = multiplierType
	multiplierIndicator.Size = UDim2.new(0, 80, 0, 80)
	multiplierIndicator.Position = UDim2.new(0, multiplier == 2 and 180 or 270, 0, 0)
	multiplierIndicator.BackgroundColor3 = color
	multiplierIndicator.BorderSizePixel = 0
	multiplierIndicator.Parent = boostFrame

	local multiplierCorner = GameConfig.createUICorner(10)
	multiplierCorner.Parent = multiplierIndicator

	local multiplierIcon = Instance.new("TextLabel")
	multiplierIcon.Size = UDim2.new(1, 0, 0.7, 0)
	multiplierIcon.Position = UDim2.new(0, 0, 0, 0)
	multiplierIcon.BackgroundTransparency = 1
	multiplierIcon.Text = multiplier .. "x"
	multiplierIcon.TextColor3 = Color3.new(1, 1, 1)
	multiplierIcon.TextScaled = true
	multiplierIcon.Font = Enum.Font.GothamBold
	multiplierIcon.Parent = multiplierIndicator

	local multiplierTimer = Instance.new("TextLabel")
	multiplierTimer.Name = "Timer"
	multiplierTimer.Size = UDim2.new(1, 0, 0.3, 0)
	multiplierTimer.Position = UDim2.new(0, 0, 0.7, 0)
	multiplierTimer.BackgroundTransparency = 1
	multiplierTimer.Text = math.floor(GameConfig.SHOP_ITEMS[multiplierType].duration / 60) .. ":00"
	multiplierTimer.TextColor3 = Color3.new(1, 1, 1)
	multiplierTimer.TextScaled = true
	multiplierTimer.Font = Enum.Font.Gotham
	multiplierTimer.Parent = multiplierIndicator

	-- Glowing animation
	local glowInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
	local glowTween = TweenService:Create(multiplierIndicator, glowInfo, {
		BackgroundColor3 = color:lerp(Color3.new(1, 1, 1), 0.3)
	})
	glowTween:Play()

	activeEffects[multiplierType] = {
		indicator = multiplierIndicator,
		timer = multiplierTimer,
		tween = glowTween
	}
end

-- Remove boost effect
local function removeBoostEffect(boostType)
	local effect = activeEffects[boostType]
	if not effect then return end

	-- Clean up visual effects
	if effect.indicator then
		effect.indicator:Destroy()
	end

	if effect.tween then
		effect.tween:Cancel()
	end

	-- Clean up specific effects
	if boostType == "SPEED_BOOST" then
		-- Reset speed
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			player.Character.Humanoid.WalkSpeed = GameConfig.NORMAL_WALKSPEED
		end

		-- Remove trail
		if effect.trail then
			effect.trail:Destroy()
		end
		if effect.attachments then
			for _, attachment in pairs(effect.attachments) do
				attachment:Destroy()
			end
		end
	elseif boostType == "COIN_MAGNET" then
		-- Stop magnet logic
		if coinMagnetConnection then
			coinMagnetConnection:Disconnect()
			coinMagnetConnection = nil
		end
	end

	activeEffects[boostType] = nil
end

-- Update timers
local function updateTimers()
	for boostType, effect in pairs(activeEffects) do
		if effect.timer then
			local timeText = effect.timer.Text
			local minutes, seconds = timeText:match("(%d+):(%d+)")
			if minutes and seconds then
				local totalSeconds = tonumber(minutes) * 60 + tonumber(seconds)
				totalSeconds = totalSeconds - 1

				if totalSeconds <= 0 then
					removeBoostEffect(boostType)
				else
					local newMinutes = math.floor(totalSeconds / 60)
					local newSeconds = totalSeconds % 60
					effect.timer.Text = string.format("%d:%02d", newMinutes, newSeconds)
				end
			end
		end
	end
end

-- Timer update loop
spawn(function()
	while true do
		wait(1)
		updateTimers()
	end
end)

-- Listen for boost purchases (mock system for now)
-- In a real implementation, this would be connected to the monetization system
local function simulateBoostPurchase(boostType)
	if boostType == "SPEED_BOOST" then
		createSpeedBoostEffect()
	elseif boostType == "COIN_MAGNET" then
		createCoinMagnetEffect()
	elseif boostType == "DOUBLE_COINS" then
		createCoinMultiplierEffect("DOUBLE_COINS")
	elseif boostType == "TRIPLE_COINS" then
		createCoinMultiplierEffect("TRIPLE_COINS")
	end
end

-- Expose function globally for integration
_G.ActivateBoostEffect = simulateBoostPurchase

-- Handle character respawning
player.CharacterAdded:Connect(function()
	-- Reapply speed boost if active
	wait(1) -- Wait for character to fully load
	if activeEffects.SPEED_BOOST and player.Character and player.Character:FindFirstChild("Humanoid") then
		local humanoid = player.Character.Humanoid
		humanoid.WalkSpeed = GameConfig.NORMAL_WALKSPEED * GameConfig.SHOP_ITEMS.SPEED_BOOST.multiplier
	end
end)

print("Boost Effects system loaded for " .. player.Name)