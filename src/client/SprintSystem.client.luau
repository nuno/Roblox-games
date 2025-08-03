-- Sprint System Client Script
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Import shared configuration
local GameConfig = require(ReplicatedStorage:WaitForChild("GameConfig"))

local player = Players.LocalPlayer

-- Sprint Configuration
local SPRINT_KEY = Enum.KeyCode.LeftShift

-- State tracking
local isSprinting = false
local sprintConnection = nil

-- Function to update player speed
local function updateWalkSpeed(speed)
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.WalkSpeed = speed
	end
end

-- Function to start sprinting
local function startSprint()
	if not isSprinting then
		isSprinting = true
		updateWalkSpeed(GameConfig.SPRINT_WALKSPEED)

		-- Visual feedback - could add breathing effects, camera shake, etc.
		print(player.Name .. " started sprinting!")
	end
end

-- Function to stop sprinting
local function stopSprint()
	if isSprinting then
		isSprinting = false
		updateWalkSpeed(GameConfig.NORMAL_WALKSPEED)

		print(player.Name .. " stopped sprinting!")
	end
end

-- Handle input events
local function onInputBegan(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == SPRINT_KEY then
		startSprint()
	end
end

local function onInputEnded(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == SPRINT_KEY then
		stopSprint()
	end
end

-- Function to setup sprint for character
local function setupSprint(character)
	local humanoid = character:WaitForChild("Humanoid")

	-- Reset to normal speed when character spawns
	humanoid.WalkSpeed = GameConfig.NORMAL_WALKSPEED

	-- Stop sprinting if character dies/respawns
	if isSprinting then
		stopSprint()
	end
end

-- Connect input events
UserInputService.InputBegan:Connect(onInputBegan)
UserInputService.InputEnded:Connect(onInputEnded)

-- Handle character spawning/respawning
if player.Character then
	setupSprint(player.Character)
end

player.CharacterAdded:Connect(setupSprint)

-- Handle mobile devices (touch controls)
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
	-- Create a sprint button for mobile users
	local playerGui = player:WaitForChild("PlayerGui")
	local coinGameUI = playerGui:WaitForChild("CoinGameUI")

	-- Create sprint button
	local sprintButton = Instance.new("TextButton")
	sprintButton.Name = "SprintButton"
	sprintButton.Size = UDim2.new(0, 80, 0, 80)
	sprintButton.Position = UDim2.new(1, -100, 1, -100)
	sprintButton.BackgroundColor3 = Color3.new(0, 0, 0)
	sprintButton.BackgroundTransparency = 0.3
	sprintButton.BorderSizePixel = 0
	sprintButton.Text = "🏃"
	sprintButton.TextColor3 = Color3.new(1, 1, 1)
	sprintButton.TextScaled = true
	sprintButton.Font = Enum.Font.GothamBold
	sprintButton.Parent = coinGameUI

	-- Add rounded corners
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 15)
	corner.Parent = sprintButton

	-- Mobile sprint controls
	sprintButton.TouchTap:Connect(function()
		if isSprinting then
			stopSprint()
			sprintButton.BackgroundColor3 = Color3.new(0, 0, 0)
		else
			startSprint()
			sprintButton.BackgroundColor3 = Color3.new(0, 0.5, 0)
		end
	end)
end

print("Sprint system loaded for " .. player.Name)