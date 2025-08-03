-- Coin Collection Game Client Script
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Import shared configuration
local GameConfig = require(ReplicatedStorage:WaitForChild("GameConfig"))

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create main UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoinGameUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Game title
local titleFrame = Instance.new("Frame")
titleFrame.Name = "TitleFrame"
titleFrame.Size = UDim2.new(0, 300, 0, 60)
titleFrame.Position = UDim2.new(0.5, -150, 0, 20)
titleFrame.BackgroundColor3 = GameConfig.UI_COLORS.BACKGROUND
titleFrame.BackgroundTransparency = 0.3
titleFrame.BorderSizePixel = 0
titleFrame.Parent = screenGui

local titleCorner = GameConfig.createUICorner(10)
titleCorner.Parent = titleFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🪙 COIN COLLECTION GAME 🪙"
titleLabel.TextColor3 = GameConfig.UI_COLORS.PRIMARY
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleFrame

-- Score display
local scoreFrame = Instance.new("Frame")
scoreFrame.Name = "ScoreFrame"
scoreFrame.Size = UDim2.new(0, 200, 0, 50)
scoreFrame.Position = UDim2.new(0, 20, 0, 100)
scoreFrame.BackgroundColor3 = GameConfig.UI_COLORS.BACKGROUND
scoreFrame.BackgroundTransparency = 0.3
scoreFrame.BorderSizePixel = 0
scoreFrame.Parent = screenGui

local scoreCorner = GameConfig.createUICorner(8)
scoreCorner.Parent = scoreFrame

local scoreLabel = Instance.new("TextLabel")
scoreLabel.Name = "ScoreLabel"
scoreLabel.Size = UDim2.new(1, 0, 1, 0)
scoreLabel.Position = UDim2.new(0, 0, 0, 0)
scoreLabel.BackgroundTransparency = 1
scoreLabel.Text = "Coins: 0"
scoreLabel.TextColor3 = Color3.new(1, 1, 1)
scoreLabel.TextScaled = true
scoreLabel.Font = Enum.Font.Gotham
scoreLabel.Parent = scoreFrame

-- Instructions
local instructionsFrame = Instance.new("Frame")
instructionsFrame.Name = "InstructionsFrame"
instructionsFrame.Size = UDim2.new(0, 250, 0, 80)
instructionsFrame.Position = UDim2.new(1, -270, 0, 100)
instructionsFrame.BackgroundColor3 = GameConfig.UI_COLORS.BACKGROUND
instructionsFrame.BackgroundTransparency = 0.3
instructionsFrame.BorderSizePixel = 0
instructionsFrame.Parent = screenGui

local instructionsCorner = GameConfig.createUICorner(8)
instructionsCorner.Parent = instructionsFrame

local instructionsLabel = Instance.new("TextLabel")
instructionsLabel.Name = "InstructionsLabel"
instructionsLabel.Size = UDim2.new(1, -10, 1, -10)
instructionsLabel.Position = UDim2.new(0, 5, 0, 5)
instructionsLabel.BackgroundTransparency = 1
instructionsLabel.Text = "Walk into the golden coins to collect them!\n\nEach coin = " .. GameConfig.COIN_VALUE .. " points"
instructionsLabel.TextColor3 = GameConfig.UI_COLORS.SECONDARY
instructionsLabel.TextScaled = true
instructionsLabel.Font = Enum.Font.Gotham
instructionsLabel.TextWrapped = true
instructionsLabel.Parent = instructionsFrame

-- Create coin collection sound effect
local coinSound = Instance.new("Sound")
coinSound.Name = "CoinCollectSound"
coinSound.SoundId = GameConfig.SOUNDS.COIN_COLLECT
coinSound.Volume = 0.5
coinSound.Parent = SoundService

-- Function to update score display
local function updateScoreDisplay()
	if GameConfig.isValidPlayer(player) then
		local coins = player.leaderstats.Coins.Value
		scoreLabel.Text = "Coins: " .. GameConfig.formatNumber(coins)

		-- Animate score update
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
		local scaleTween = TweenService:Create(scoreLabel, tweenInfo, {
			TextSize = scoreLabel.TextSize * 1.2
		})
		scaleTween:Play()

		scaleTween.Completed:Connect(function()
			local returnTween = TweenService:Create(scoreLabel, tweenInfo, {
				TextSize = scoreLabel.TextSize / 1.2
			})
			returnTween:Play()
		end)
	end
end

-- Function to play coin collection effect
local function playCoinEffect()
	coinSound:Play()

	-- Create floating "+10" text effect
	local effectLabel = Instance.new("TextLabel")
	effectLabel.Size = UDim2.new(0, 100, 0, 50)
	effectLabel.Position = UDim2.new(0.5, -50, 0.5, -25)
	effectLabel.BackgroundTransparency = 1
	effectLabel.Text = "+" .. GameConfig.COIN_VALUE
	effectLabel.TextColor3 = GameConfig.UI_COLORS.PRIMARY
	effectLabel.TextScaled = true
	effectLabel.Font = Enum.Font.GothamBold
	effectLabel.TextStrokeTransparency = 0
	effectLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
	effectLabel.Parent = screenGui

	-- Animate the effect
	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local moveTween = TweenService:Create(effectLabel, tweenInfo, {
		Position = UDim2.new(0.5, -50, 0.3, -25),
		TextTransparency = 1
	})
	moveTween:Play()

	moveTween.Completed:Connect(function()
		effectLabel:Destroy()
	end)
end

-- Wait for leaderstats to be created
player.CharacterAdded:Connect(function()
	player:WaitForChild("leaderstats", 10)
	if player.leaderstats and player.leaderstats:FindFirstChild("Coins") then
		-- Initial score update
		updateScoreDisplay()

		-- Connect to score changes
		local lastScore = player.leaderstats.Coins.Value
		player.leaderstats.Coins.Changed:Connect(function(newValue)
			if newValue > lastScore then
				playCoinEffect()
			end
			lastScore = newValue
			updateScoreDisplay()
		end)
	end
end)

-- If player already has character, set up immediately
if player.Character and player:FindFirstChild("leaderstats") then
	updateScoreDisplay()

	local lastScore = player.leaderstats.Coins.Value
	player.leaderstats.Coins.Changed:Connect(function(newValue)
		if newValue > lastScore then
			playCoinEffect()
		end
		lastScore = newValue
		updateScoreDisplay()
	end)
end

print("Coin Game UI loaded for " .. player.Name)