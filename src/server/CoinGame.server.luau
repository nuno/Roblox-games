-- Coin Collection Game Server Script
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Import shared configuration
local GameConfig = require(ReplicatedStorage:WaitForChild("GameConfig"))

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

	print(GameConfig.formatMessage("PLAYER_JOINED", player.Name))
end

-- Create a coin at a random position
local function createCoin()
	if #activeCoins >= GameConfig.MAX_COINS then
		return
	end

	-- Get random spawn position
	local position = GameConfig.getRandomSpawnPosition()

	-- Create the coin part
	local coin = Instance.new("Part")
	coin.Name = "Coin"
	coin.Shape = Enum.PartType.Cylinder
	coin.Material = Enum.Material.Neon
	coin.BrickColor = BrickColor.new("Bright yellow")
	coin.Size = Vector3.new(0.5, 3, 3)
	coin.Position = position
	coin.Anchored = true
	coin.CanCollide = false
	coin.Parent = Workspace

	-- Add spinning effect
	local spin = Instance.new("BodyAngularVelocity")
	spin.AngularVelocity = Vector3.new(0, 10, 0)
	spin.MaxTorque = Vector3.new(0, math.huge, 0)
	spin.Parent = coin

	-- Add glowing effect using shared utility
	GameConfig.createGlow(coin, GameConfig.UI_COLORS.PRIMARY, 2, 10)

	-- Handle coin collection
	local function onTouched(hit)
		local character = hit.Parent
		if GameConfig.isValidCharacter(character) then
			local player = Players:GetPlayerFromCharacter(character)
			if GameConfig.isValidPlayer(player) then
				-- Award points
				player.leaderstats.Coins.Value = player.leaderstats.Coins.Value + GameConfig.COIN_VALUE

				-- Remove coin from active list
				for i, activeCoin in ipairs(activeCoins) do
					if activeCoin == coin then
						table.remove(activeCoins, i)
						break
					end
				end

				-- Destroy the coin
				coin:Destroy()

				print(GameConfig.formatMessage("COIN_COLLECTED", player.Name, player.leaderstats.Coins.Value))
			end
		end
	end

	coin.Touched:Connect(onTouched)
	table.insert(activeCoins, coin)

	print(GameConfig.formatMessage("COIN_SPAWNED", tostring(coin.Position)))
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
	if currentTime - lastSpawnTime >= GameConfig.COIN_SPAWN_INTERVAL then
		createCoin()
		lastSpawnTime = currentTime
	end
end)

print(GameConfig.formatMessage("GAME_STARTED"))