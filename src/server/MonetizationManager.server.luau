-- Monetization Manager Server Script
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Import shared configuration
local GameConfig = require(ReplicatedStorage:WaitForChild("GameConfig"))

-- Data Stores
local playerDataStore = DataStoreService:GetDataStore("PlayerData")
local leaderboardStore = DataStoreService:GetOrderedDataStore("Leaderboard")

-- Remote Events
local remoteEvents = Instance.new("Folder")
remoteEvents.Name = "RemoteEvents"
remoteEvents.Parent = ReplicatedStorage

local purchaseGems = Instance.new("RemoteEvent")
purchaseGems.Name = "PurchaseGems"
purchaseGems.Parent = remoteEvents

local purchaseShopItem = Instance.new("RemoteEvent")
purchaseShopItem.Name = "PurchaseShopItem"
purchaseShopItem.Parent = remoteEvents

local claimDailyReward = Instance.new("RemoteEvent")
claimDailyReward.Name = "ClaimDailyReward"
claimDailyReward.Parent = remoteEvents

local updatePlayerData = Instance.new("RemoteEvent")
updatePlayerData.Name = "UpdatePlayerData"
updatePlayerData.Parent = remoteEvents

-- Player data cache
local playerData = {}

-- Default player data structure
local function getDefaultPlayerData()
	return {
		gems = 100, -- Starting gems
		coins = 0,
		vipStatus = false,
		doubleGemsPass = false,
		starterPackClaimed = false,
		lastDailyReward = 0,
		dailyStreak = 0,
		achievements = {},
		activeBoosts = {},
		totalCoinsCollected = 0,
		totalSprintTime = 0,
		joinDate = os.time()
	}
end

-- Save player data
local function savePlayerData(player)
	if playerData[player.UserId] then
		local success, errorMessage = pcall(function()
			playerDataStore:SetAsync(player.UserId, playerData[player.UserId])
		end)

		if not success then
			warn("Failed to save data for " .. player.Name .. ": " .. errorMessage)
		end
	end
end

-- Load player data
local function loadPlayerData(player)
	local data = getDefaultPlayerData()

	local success, savedData = pcall(function()
		return playerDataStore:GetAsync(player.UserId)
	end)

	if success and savedData then
		-- Merge saved data with default data (in case new fields were added)
		for key, value in pairs(savedData) do
			data[key] = value
		end
	end

	playerData[player.UserId] = data
	return data
end

-- Create enhanced leaderstats
local function createLeaderstats(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = playerData[player.UserId].coins
	coins.Parent = leaderstats

	local gems = Instance.new("IntValue")
	gems.Name = "Gems"
	gems.Value = playerData[player.UserId].gems
	gems.Parent = leaderstats

	-- VIP status indicator
	local vipStatus = Instance.new("BoolValue")
	vipStatus.Name = "VIP"
	vipStatus.Value = playerData[player.UserId].vipStatus
	vipStatus.Parent = player

	print(GameConfig.formatMessage("PLAYER_JOINED", player.Name))
end

-- Check game pass ownership
local function checkGamePasses(player)
	local data = playerData[player.UserId]

	-- Check VIP pass
	local hasVIP = MarketplaceService:UserOwnsGamePassAsync(player.UserId, GameConfig.GAME_PASSES.VIP)
	data.vipStatus = hasVIP
	if player:FindFirstChild("VIP") then
		player.VIP.Value = hasVIP
	end

	-- Check double gems pass
	data.doubleGemsPass = MarketplaceService:UserOwnsGamePassAsync(player.UserId, GameConfig.GAME_PASSES.DOUBLE_GEMS)

	-- Check starter pack (one-time purchase)
	local hasStarterPack = MarketplaceService:UserOwnsGamePassAsync(player.UserId, GameConfig.GAME_PASSES.STARTER_PACK)
	if hasStarterPack and not data.starterPackClaimed then
		data.gems = data.gems + 500
		data.starterPackClaimed = true
		player.leaderstats.Gems.Value = data.gems
		print(player.Name .. " claimed starter pack!")
	end
end

-- Award gems with multipliers
local function awardGems(player, amount, reason)
	local data = playerData[player.UserId]
	local finalAmount = amount

	-- Apply VIP multiplier
	if data.vipStatus then
		finalAmount = finalAmount * GameConfig.VIP_BENEFITS.GEM_MULTIPLIER
	end

	-- Apply double gems pass
	if data.doubleGemsPass then
		finalAmount = finalAmount * 2
	end

	data.gems = data.gems + finalAmount
	player.leaderstats.Gems.Value = data.gems

	print(player.Name .. " earned " .. finalAmount .. " gems for " .. reason)
	return finalAmount
end

-- Award coins with multipliers
local function awardCoins(player, amount)
	local data = playerData[player.UserId]
	local finalAmount = amount

	-- Apply VIP multiplier
	if data.vipStatus then
		finalAmount = math.floor(finalAmount * GameConfig.VIP_BENEFITS.COIN_MULTIPLIER)
	end

	-- Apply active boost multipliers
	for boostType, boostData in pairs(data.activeBoosts) do
		if boostType == "DOUBLE_COINS" or boostType == "TRIPLE_COINS" then
			if tick() < boostData.expireTime then
				finalAmount = math.floor(finalAmount * GameConfig.SHOP_ITEMS[boostType].multiplier)
			else
				-- Remove expired boost
				data.activeBoosts[boostType] = nil
			end
		end
	end

	data.coins = data.coins + finalAmount
	data.totalCoinsCollected = data.totalCoinsCollected + finalAmount
	player.leaderstats.Coins.Value = data.coins

	-- Check for coin milestones and award gems
	local milestones = {100, 500, 1000, 2500, 5000, 10000}
	for _, milestone in ipairs(milestones) do
		if data.totalCoinsCollected >= milestone and not data.achievements["MILESTONE_" .. milestone] then
			data.achievements["MILESTONE_" .. milestone] = true
			awardGems(player, GameConfig.GEM_REWARDS.COIN_MILESTONE, "coin milestone")
		end
	end

	return finalAmount
end

-- Check and award achievements
local function checkAchievements(player)
	local data = playerData[player.UserId]

	for achievementId, achievement in pairs(GameConfig.ACHIEVEMENTS) do
		if not data.achievements[achievementId] then
			local qualified = false

			if achievementId == "FIRST_COIN" and data.totalCoinsCollected >= 1 then
				qualified = true
			elseif achievementId == "COIN_COLLECTOR" and data.totalCoinsCollected >= 100 then
				qualified = true
			elseif achievementId == "COIN_MASTER" and data.totalCoinsCollected >= 1000 then
				qualified = true
			elseif achievementId == "SPEED_DEMON" and data.totalSprintTime >= 50 then
				qualified = true
			elseif achievementId == "DAILY_PLAYER" and data.dailyStreak >= 7 then
				qualified = true
			end

			if qualified then
				data.achievements[achievementId] = true
				awardGems(player, achievement.reward, "achievement: " .. achievement.title)
			end
		end
	end
end

-- Handle daily rewards
local function handleDailyReward(player)
	local data = playerData[player.UserId]
	local currentTime = os.time()
	local lastReward = data.lastDailyReward
	local timeSinceLastReward = currentTime - lastReward

	-- Check if 24 hours have passed
	if timeSinceLastReward >= 86400 then -- 24 hours in seconds
		-- Check if streak continues (within 48 hours)
		if timeSinceLastReward <= 172800 then -- 48 hours
			data.dailyStreak = data.dailyStreak + 1
		else
			data.dailyStreak = 1 -- Reset streak
		end

		data.lastDailyReward = currentTime

		-- Calculate reward based on streak
		local baseReward = GameConfig.GEM_REWARDS.DAILY_LOGIN
		local streakBonus = math.min(data.dailyStreak * 5, 50) -- Max 50 bonus
		local totalReward = baseReward + streakBonus

		-- VIP bonus
		if data.vipStatus then
			totalReward = totalReward + GameConfig.GEM_REWARDS.VIP_DAILY_BONUS
		end

		awardGems(player, totalReward, "daily reward (streak: " .. data.dailyStreak .. ")")
		return true, totalReward, data.dailyStreak
	end

	return false, 0, data.dailyStreak
end

-- Handle shop purchases
local function handleShopPurchase(player, itemId)
	local data = playerData[player.UserId]
	local item = GameConfig.SHOP_ITEMS[itemId]

	if not item then
		return false, "Item not found"
	end

	if data.gems < item.price then
		return false, "Not enough gems"
	end

	-- Deduct gems
	data.gems = data.gems - item.price
	player.leaderstats.Gems.Value = data.gems

	-- Apply boost
	data.activeBoosts[itemId] = {
		expireTime = tick() + item.duration,
		multiplier = item.multiplier or 1,
		range = item.range or 0
	}

	return true, "Purchase successful"
end

-- Handle developer product purchases
MarketplaceService.ProcessReceipt = function(receiptInfo)
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local data = playerData[player.UserId]
	if not data then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	-- Find the product
	for productName, productData in pairs(GameConfig.DEVELOPER_PRODUCTS) do
		if productData.id == receiptInfo.ProductId then
			data.gems = data.gems + productData.gems
			player.leaderstats.Gems.Value = data.gems
			print(player.Name .. " purchased " .. productData.gems .. " gems!")
			return Enum.ProductPurchaseDecision.PurchaseGranted
		end
	end

	return Enum.ProductPurchaseDecision.NotProcessedYet
end

-- Remote event handlers
purchaseShopItem.OnServerEvent:Connect(function(player, itemId)
	local success, message = handleShopPurchase(player, itemId)
	purchaseShopItem:FireClient(player, success, message)
end)

claimDailyReward.OnServerEvent:Connect(function(player)
	local canClaim, reward, streak = handleDailyReward(player)
	claimDailyReward:FireClient(player, canClaim, reward, streak)
end)

updatePlayerData.OnServerEvent:Connect(function(player, dataType, value)
	local data = playerData[player.UserId]
	if dataType == "sprintTime" then
		data.totalSprintTime = data.totalSprintTime + value
		checkAchievements(player)
	end
end)

-- Player management
Players.PlayerAdded:Connect(function(player)
	loadPlayerData(player)
	createLeaderstats(player)

	-- Wait a bit then check game passes
	wait(2)
	checkGamePasses(player)
	checkAchievements(player)
end)

-- Note: PlayerRemoving is now handled below with leaderboard update

-- Auto-save every 5 minutes
spawn(function()
	while true do
		wait(300) -- 5 minutes
		for _, player in pairs(Players:GetPlayers()) do
			savePlayerData(player)
		end
	end
end)

-- Expose coin awarding function globally for integration
_G.MonetizationAwardCoins = awardCoins

-- Create leaderboard system
local function updateLeaderboard()
	spawn(function()
		local success, pages = pcall(function()
			return leaderboardStore:GetSortedAsync(false, 10)
		end)

		if success then
			local topPlayers = pages:GetCurrentPage()
			-- Store leaderboard data for client access
			local leaderboardData = ReplicatedStorage:FindFirstChild("LeaderboardData")
			if leaderboardData then
				leaderboardData:Destroy()
			end

			leaderboardData = Instance.new("Folder")
			leaderboardData.Name = "LeaderboardData"
			leaderboardData.Parent = ReplicatedStorage

			for i, entry in ipairs(topPlayers) do
				local playerEntry = Instance.new("StringValue")
				playerEntry.Name = "Player" .. i
				playerEntry.Value = entry.key .. ":" .. entry.value
				playerEntry.Parent = leaderboardData
			end
		end
	end)
end

-- Update leaderboard every 5 minutes
spawn(function()
	while true do
		wait(300) -- 5 minutes
		updateLeaderboard()
	end
end)

-- Update leaderboard when players leave (to include their final score)
Players.PlayerRemoving:Connect(function(player)
	local data = playerData[player.UserId]
	if data then
		-- Update leaderboard with final score
		spawn(function()
			pcall(function()
				leaderboardStore:SetAsync(player.Name, data.totalCoinsCollected)
			end)
		end)
	end
	savePlayerData(player)
	playerData[player.UserId] = nil
end)

-- Initial leaderboard update
updateLeaderboard()

print("Monetization Manager loaded!")