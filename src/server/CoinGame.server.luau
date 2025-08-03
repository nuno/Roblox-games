-- Coin Collection Game Server Script
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Game Configuration
local COIN_SPAWN_INTERVAL = 3 -- seconds
local MAX_COINS = 10
local COIN_VALUE = 10
local SPAWN_HEIGHT = 5
local SPAWN_RADIUS = 100

-- Storage for active coins
local activeCoins = {}
local lastSpawnTime = 0

-- Create leaderstats for players
local function createLeaderstats(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = 0
	coins.Parent = leaderstats

	print(player.Name .. " joined the coin collection game!")
end

-- Create a coin at a random position
local function createCoin()
	if #activeCoins >= MAX_COINS then
		return
	end

	-- Random position on the baseplate
	local x = math.random(-SPAWN_RADIUS, SPAWN_RADIUS)
	local z = math.random(-SPAWN_RADIUS, SPAWN_RADIUS)
	local y = SPAWN_HEIGHT

	-- Create the coin part
	local coin = Instance.new("Part")
	coin.Name = "Coin"
	coin.Shape = Enum.PartType.Cylinder
	coin.Material = Enum.Material.Neon
	coin.BrickColor = BrickColor.new("Bright yellow")
	coin.Size = Vector3.new(0.5, 3, 3)
	coin.Position = Vector3.new(x, y, z)
	coin.Anchored = true
	coin.CanCollide = false
	coin.Parent = Workspace

	-- Add spinning effect
	local spin = Instance.new("BodyAngularVelocity")
	spin.AngularVelocity = Vector3.new(0, 10, 0)
	spin.MaxTorque = Vector3.new(0, math.huge, 0)
	spin.Parent = coin

	-- Add glowing effect
	local pointLight = Instance.new("PointLight")
	pointLight.Color = Color3.new(1, 1, 0)
	pointLight.Brightness = 2
	pointLight.Range = 10
	pointLight.Parent = coin

	-- Handle coin collection
	local function onTouched(hit)
		local humanoid = hit.Parent:FindFirstChild("Humanoid")
		if humanoid then
			local player = Players:GetPlayerFromCharacter(hit.Parent)
			if player and player.leaderstats then
				-- Award points
				player.leaderstats.Coins.Value = player.leaderstats.Coins.Value + COIN_VALUE

				-- Remove coin from active list
				for i, activeCoin in ipairs(activeCoins) do
					if activeCoin == coin then
						table.remove(activeCoins, i)
						break
					end
				end

				-- Destroy the coin
				coin:Destroy()

				print(player.Name .. " collected a coin! Total: " .. player.leaderstats.Coins.Value)
			end
		end
	end

	coin.Touched:Connect(onTouched)
	table.insert(activeCoins, coin)

	print("Coin spawned at position: " .. tostring(coin.Position))
end

-- Initialize leaderstats for existing players
for _, player in pairs(Players:GetPlayers()) do
	createLeaderstats(player)
end

-- Connect player joining
Players.PlayerAdded:Connect(createLeaderstats)

-- Main game loop
RunService.Heartbeat:Connect(function()
	local currentTime = tick()

	-- Spawn coins at intervals
	if currentTime - lastSpawnTime >= COIN_SPAWN_INTERVAL then
		createCoin()
		lastSpawnTime = currentTime
	end
end)

print("Coin Collection Game started!")