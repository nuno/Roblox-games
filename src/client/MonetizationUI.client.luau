-- Monetization UI Client Script
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Import shared configuration
local GameConfig = require(ReplicatedStorage:WaitForChild("GameConfig"))

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for remote events
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local purchaseShopItem = remoteEvents:WaitForChild("PurchaseShopItem")
local claimDailyReward = remoteEvents:WaitForChild("ClaimDailyReward")
local updatePlayerData = remoteEvents:WaitForChild("UpdatePlayerData")

-- Create main monetization UI
local monetizationGui = Instance.new("ScreenGui")
monetizationGui.Name = "MonetizationUI"
monetizationGui.ResetOnSpawn = false
monetizationGui.Parent = playerGui

-- Main menu frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 800, 0, 600)
mainFrame.Position = UDim2.new(0.5, -400, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = monetizationGui

local mainCorner = GameConfig.createUICorner(15)
mainCorner.Parent = mainFrame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 60)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = GameConfig.UI_COLORS.PRIMARY
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = GameConfig.createUICorner(15)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -120, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "💎 PREMIUM SHOP 💎"
titleLabel.TextColor3 = Color3.new(0, 0, 0)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleBar

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 50, 0, 50)
closeButton.Position = UDim2.new(1, -60, 0, 5)
closeButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

local closeCorner = GameConfig.createUICorner(8)
closeCorner.Parent = closeButton

-- Currency display
local currencyFrame = Instance.new("Frame")
currencyFrame.Name = "CurrencyFrame"
currencyFrame.Size = UDim2.new(1, -20, 0, 40)
currencyFrame.Position = UDim2.new(0, 10, 0, 70)
currencyFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
currencyFrame.BorderSizePixel = 0
currencyFrame.Parent = mainFrame

local currencyCorner = GameConfig.createUICorner(8)
currencyCorner.Parent = currencyFrame

local gemsLabel = Instance.new("TextLabel")
gemsLabel.Name = "GemsLabel"
gemsLabel.Size = UDim2.new(0.5, -5, 1, 0)
gemsLabel.Position = UDim2.new(0, 10, 0, 0)
gemsLabel.BackgroundTransparency = 1
gemsLabel.Text = "💎 Gems: 0"
gemsLabel.TextColor3 = GameConfig.UI_COLORS.PRIMARY
gemsLabel.TextScaled = true
gemsLabel.Font = Enum.Font.GothamBold
gemsLabel.TextXAlignment = Enum.TextXAlignment.Left
gemsLabel.Parent = currencyFrame

local coinsLabel = Instance.new("TextLabel")
coinsLabel.Name = "CoinsLabel"
coinsLabel.Size = UDim2.new(0.5, -5, 1, 0)
coinsLabel.Position = UDim2.new(0.5, 5, 0, 0)
coinsLabel.BackgroundTransparency = 1
coinsLabel.Text = "🪙 Coins: 0"
coinsLabel.TextColor3 = GameConfig.UI_COLORS.PRIMARY
coinsLabel.TextScaled = true
coinsLabel.Font = Enum.Font.GothamBold
coinsLabel.TextXAlignment = Enum.TextXAlignment.Left
coinsLabel.Parent = currencyFrame

-- Tab system
local tabFrame = Instance.new("Frame")
tabFrame.Name = "TabFrame"
tabFrame.Size = UDim2.new(1, -20, 0, 40)
tabFrame.Position = UDim2.new(0, 10, 0, 120)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

local tabs = {"Shop", "Daily", "Achievements", "VIP", "Gems"}
local tabButtons = {}
local contentFrames = {}

-- Create tabs
for i, tabName in ipairs(tabs) do
	local tabButton = Instance.new("TextButton")
	tabButton.Name = tabName .. "Tab"
	tabButton.Size = UDim2.new(0.2, -4, 1, 0)
	tabButton.Position = UDim2.new((i-1) * 0.2, 2, 0, 0)
	tabButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
	tabButton.BorderSizePixel = 0
	tabButton.Text = tabName
	tabButton.TextColor3 = Color3.new(1, 1, 1)
	tabButton.TextScaled = true
	tabButton.Font = Enum.Font.Gotham
	tabButton.Parent = tabFrame

	local tabCorner = GameConfig.createUICorner(8)
	tabCorner.Parent = tabButton

	tabButtons[tabName] = tabButton

	-- Create content frame
	local contentFrame = Instance.new("ScrollingFrame")
	contentFrame.Name = tabName .. "Content"
	contentFrame.Size = UDim2.new(1, -20, 1, -180)
	contentFrame.Position = UDim2.new(0, 10, 0, 170)
	contentFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
	contentFrame.BorderSizePixel = 0
	contentFrame.ScrollBarThickness = 8
	contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	contentFrame.Visible = false
	contentFrame.Parent = mainFrame

	local contentCorner = GameConfig.createUICorner(8)
	contentCorner.Parent = contentFrame

	contentFrames[tabName] = contentFrame
end

-- Shop button (always visible)
local shopButton = Instance.new("TextButton")
shopButton.Name = "ShopButton"
shopButton.Size = UDim2.new(0, 100, 0, 50)
shopButton.Position = UDim2.new(1, -120, 0, 200)
shopButton.BackgroundColor3 = GameConfig.UI_COLORS.PRIMARY
shopButton.BorderSizePixel = 0
shopButton.Text = "💎 SHOP"
shopButton.TextColor3 = Color3.new(0, 0, 0)
shopButton.TextScaled = true
shopButton.Font = Enum.Font.GothamBold
shopButton.Parent = monetizationGui

local shopCorner = GameConfig.createUICorner(10)
shopCorner.Parent = shopButton

-- Daily reward button
local dailyButton = Instance.new("TextButton")
dailyButton.Name = "DailyButton"
dailyButton.Size = UDim2.new(0, 100, 0, 50)
dailyButton.Position = UDim2.new(1, -120, 0, 260)
dailyButton.BackgroundColor3 = Color3.new(0, 0.8, 0)
dailyButton.BorderSizePixel = 0
dailyButton.Text = "🎁 DAILY"
dailyButton.TextColor3 = Color3.new(1, 1, 1)
dailyButton.TextScaled = true
dailyButton.Font = Enum.Font.GothamBold
dailyButton.Parent = monetizationGui

local dailyCorner = GameConfig.createUICorner(10)
dailyCorner.Parent = dailyButton

-- Function to switch tabs
local function switchTab(tabName)
	for name, button in pairs(tabButtons) do
		if name == tabName then
			button.BackgroundColor3 = GameConfig.UI_COLORS.PRIMARY
			button.TextColor3 = Color3.new(0, 0, 0)
			contentFrames[name].Visible = true
		else
			button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
			button.TextColor3 = Color3.new(1, 1, 1)
			contentFrames[name].Visible = false
		end
	end
end

-- Create shop items
local function createShopContent()
	local shopContent = contentFrames["Shop"]
	local yOffset = 10

	for itemId, item in pairs(GameConfig.SHOP_ITEMS) do
		local itemFrame = Instance.new("Frame")
		itemFrame.Name = itemId
		itemFrame.Size = UDim2.new(1, -20, 0, 80)
		itemFrame.Position = UDim2.new(0, 10, 0, yOffset)
		itemFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
		itemFrame.BorderSizePixel = 0
		itemFrame.Parent = shopContent

		local itemCorner = GameConfig.createUICorner(8)
		itemCorner.Parent = itemFrame

		local itemName = Instance.new("TextLabel")
		itemName.Size = UDim2.new(0.6, 0, 0.5, 0)
		itemName.Position = UDim2.new(0, 10, 0, 5)
		itemName.BackgroundTransparency = 1
		itemName.Text = itemId:gsub("_", " ")
		itemName.TextColor3 = Color3.new(1, 1, 1)
		itemName.TextScaled = true
		itemName.Font = Enum.Font.GothamBold
		itemName.TextXAlignment = Enum.TextXAlignment.Left
		itemName.Parent = itemFrame

		local itemDesc = Instance.new("TextLabel")
		itemDesc.Size = UDim2.new(0.6, 0, 0.5, 0)
		itemDesc.Position = UDim2.new(0, 10, 0.5, 0)
		itemDesc.BackgroundTransparency = 1
		itemDesc.Text = "Duration: " .. item.duration .. "s"
		itemDesc.TextColor3 = GameConfig.UI_COLORS.SECONDARY
		itemDesc.TextScaled = true
		itemDesc.Font = Enum.Font.Gotham
		itemDesc.TextXAlignment = Enum.TextXAlignment.Left
		itemDesc.Parent = itemFrame

		local buyButton = Instance.new("TextButton")
		buyButton.Size = UDim2.new(0.3, -10, 0.8, 0)
		buyButton.Position = UDim2.new(0.7, 0, 0.1, 0)
		buyButton.BackgroundColor3 = GameConfig.UI_COLORS.PRIMARY
		buyButton.BorderSizePixel = 0
		buyButton.Text = "💎 " .. item.price
		buyButton.TextColor3 = Color3.new(0, 0, 0)
		buyButton.TextScaled = true
		buyButton.Font = Enum.Font.GothamBold
		buyButton.Parent = itemFrame

		local buyCorner = GameConfig.createUICorner(6)
		buyCorner.Parent = buyButton

		buyButton.MouseButton1Click:Connect(function()
			purchaseShopItem:FireServer(itemId)
		end)

		yOffset = yOffset + 90
	end

	shopContent.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

-- Create achievements content
local function createAchievementsContent()
	local achievementsContent = contentFrames["Achievements"]
	local yOffset = 10

	for achievementId, achievement in pairs(GameConfig.ACHIEVEMENTS) do
		local achievementFrame = Instance.new("Frame")
		achievementFrame.Name = achievementId
		achievementFrame.Size = UDim2.new(1, -20, 0, 80)
		achievementFrame.Position = UDim2.new(0, 10, 0, yOffset)
		achievementFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
		achievementFrame.BorderSizePixel = 0
		achievementFrame.Parent = achievementsContent

		local achievementCorner = GameConfig.createUICorner(8)
		achievementCorner.Parent = achievementFrame

		local achievementTitle = Instance.new("TextLabel")
		achievementTitle.Size = UDim2.new(0.7, 0, 0.5, 0)
		achievementTitle.Position = UDim2.new(0, 10, 0, 5)
		achievementTitle.BackgroundTransparency = 1
		achievementTitle.Text = "🏆 " .. achievement.title
		achievementTitle.TextColor3 = GameConfig.UI_COLORS.PRIMARY
		achievementTitle.TextScaled = true
		achievementTitle.Font = Enum.Font.GothamBold
		achievementTitle.TextXAlignment = Enum.TextXAlignment.Left
		achievementTitle.Parent = achievementFrame

		local achievementDesc = Instance.new("TextLabel")
		achievementDesc.Size = UDim2.new(0.7, 0, 0.5, 0)
		achievementDesc.Position = UDim2.new(0, 10, 0.5, 0)
		achievementDesc.BackgroundTransparency = 1
		achievementDesc.Text = "Requirement: " .. achievement.requirement
		achievementDesc.TextColor3 = GameConfig.UI_COLORS.SECONDARY
		achievementDesc.TextScaled = true
		achievementDesc.Font = Enum.Font.Gotham
		achievementDesc.TextXAlignment = Enum.TextXAlignment.Left
		achievementDesc.Parent = achievementFrame

		local rewardLabel = Instance.new("TextLabel")
		rewardLabel.Size = UDim2.new(0.25, -10, 0.8, 0)
		rewardLabel.Position = UDim2.new(0.75, 0, 0.1, 0)
		rewardLabel.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
		rewardLabel.BorderSizePixel = 0
		rewardLabel.Text = "💎 " .. achievement.reward
		rewardLabel.TextColor3 = GameConfig.UI_COLORS.PRIMARY
		rewardLabel.TextScaled = true
		rewardLabel.Font = Enum.Font.GothamBold
		rewardLabel.Parent = achievementFrame

		local rewardCorner = GameConfig.createUICorner(6)
		rewardCorner.Parent = rewardLabel

		yOffset = yOffset + 90
	end

	achievementsContent.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

-- Create daily rewards content
local function createDailyContent()
	local dailyContent = contentFrames["Daily"]

	local rewardFrame = Instance.new("Frame")
	rewardFrame.Size = UDim2.new(1, -20, 0, 200)
	rewardFrame.Position = UDim2.new(0, 10, 0, 10)
	rewardFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
	rewardFrame.BorderSizePixel = 0
	rewardFrame.Parent = dailyContent

	local rewardCorner = GameConfig.createUICorner(10)
	rewardCorner.Parent = rewardFrame

	local rewardTitle = Instance.new("TextLabel")
	rewardTitle.Size = UDim2.new(1, 0, 0.3, 0)
	rewardTitle.Position = UDim2.new(0, 0, 0, 0)
	rewardTitle.BackgroundTransparency = 1
	rewardTitle.Text = "🎁 DAILY REWARD"
	rewardTitle.TextColor3 = GameConfig.UI_COLORS.PRIMARY
	rewardTitle.TextScaled = true
	rewardTitle.Font = Enum.Font.GothamBold
	rewardTitle.Parent = rewardFrame

	local rewardDesc = Instance.new("TextLabel")
	rewardDesc.Size = UDim2.new(1, -20, 0.4, 0)
	rewardDesc.Position = UDim2.new(0, 10, 0.3, 0)
	rewardDesc.BackgroundTransparency = 1
	rewardDesc.Text = "Claim your daily gems!\nStreak bonus increases rewards!"
	rewardDesc.TextColor3 = Color3.new(1, 1, 1)
	rewardDesc.TextScaled = true
	rewardDesc.Font = Enum.Font.Gotham
	rewardDesc.TextWrapped = true
	rewardDesc.Parent = rewardFrame

	local claimButton = Instance.new("TextButton")
	claimButton.Name = "ClaimButton"
	claimButton.Size = UDim2.new(0.8, 0, 0.25, 0)
	claimButton.Position = UDim2.new(0.1, 0, 0.7, 0)
	claimButton.BackgroundColor3 = Color3.new(0, 0.8, 0)
	claimButton.BorderSizePixel = 0
	claimButton.Text = "CLAIM REWARD"
	claimButton.TextColor3 = Color3.new(1, 1, 1)
	claimButton.TextScaled = true
	claimButton.Font = Enum.Font.GothamBold
	claimButton.Parent = rewardFrame

	local claimCorner = GameConfig.createUICorner(8)
	claimCorner.Parent = claimButton

	claimButton.MouseButton1Click:Connect(function()
		claimDailyReward:FireServer()
	end)
end

-- Create VIP content
local function createVIPContent()
	local vipContent = contentFrames["VIP"]

	local vipFrame = Instance.new("Frame")
	vipFrame.Size = UDim2.new(1, -20, 0, 300)
	vipFrame.Position = UDim2.new(0, 10, 0, 10)
	vipFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
	vipFrame.BorderSizePixel = 0
	vipFrame.Parent = vipContent

	local vipCorner = GameConfig.createUICorner(10)
	vipCorner.Parent = vipFrame

	local vipTitle = Instance.new("TextLabel")
	vipTitle.Size = UDim2.new(1, 0, 0.2, 0)
	vipTitle.Position = UDim2.new(0, 0, 0, 0)
	vipTitle.BackgroundTransparency = 1
	vipTitle.Text = "👑 VIP MEMBERSHIP"
	vipTitle.TextColor3 = GameConfig.UI_COLORS.PRIMARY
	vipTitle.TextScaled = true
	vipTitle.Font = Enum.Font.GothamBold
	vipTitle.Parent = vipFrame

	local benefitsList = Instance.new("TextLabel")
	benefitsList.Size = UDim2.new(1, -20, 0.6, 0)
	benefitsList.Position = UDim2.new(0, 10, 0.2, 0)
	benefitsList.BackgroundTransparency = 1
	benefitsList.Text = "VIP Benefits:\n• 1.5x Coin Multiplier\n• 2x Gem Multiplier\n• Daily VIP Bonus\n• Exclusive Areas\n• Priority Support"
	benefitsList.TextColor3 = Color3.new(1, 1, 1)
	benefitsList.TextScaled = true
	benefitsList.Font = Enum.Font.Gotham
	benefitsList.TextWrapped = true
	benefitsList.TextYAlignment = Enum.TextYAlignment.Top
	benefitsList.Parent = vipFrame

	local buyVIPButton = Instance.new("TextButton")
	buyVIPButton.Size = UDim2.new(0.8, 0, 0.15, 0)
	buyVIPButton.Position = UDim2.new(0.1, 0, 0.8, 0)
	buyVIPButton.BackgroundColor3 = GameConfig.UI_COLORS.PRIMARY
	buyVIPButton.BorderSizePixel = 0
	buyVIPButton.Text = "BUY VIP - " .. GameConfig.GAME_PASSES.VIP .. " ROBUX"
	buyVIPButton.TextColor3 = Color3.new(0, 0, 0)
	buyVIPButton.TextScaled = true
	buyVIPButton.Font = Enum.Font.GothamBold
	buyVIPButton.Parent = vipFrame

	local vipButtonCorner = GameConfig.createUICorner(8)
	vipButtonCorner.Parent = buyVIPButton

	buyVIPButton.MouseButton1Click:Connect(function()
		MarketplaceService:PromptGamePassPurchase(player, GameConfig.GAME_PASSES.VIP)
	end)
end

-- Create gems purchase content
local function createGemsContent()
	local gemsContent = contentFrames["Gems"]
	local yOffset = 10

	for productName, product in pairs(GameConfig.DEVELOPER_PRODUCTS) do
		local productFrame = Instance.new("Frame")
		productFrame.Size = UDim2.new(1, -20, 0, 80)
		productFrame.Position = UDim2.new(0, 10, 0, yOffset)
		productFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
		productFrame.BorderSizePixel = 0
		productFrame.Parent = gemsContent

		local productCorner = GameConfig.createUICorner(8)
		productCorner.Parent = productFrame

		local gemAmount = Instance.new("TextLabel")
		gemAmount.Size = UDim2.new(0.6, 0, 0.6, 0)
		gemAmount.Position = UDim2.new(0, 10, 0, 5)
		gemAmount.BackgroundTransparency = 1
		gemAmount.Text = "💎 " .. GameConfig.formatNumber(product.gems) .. " Gems"
		gemAmount.TextColor3 = GameConfig.UI_COLORS.PRIMARY
		gemAmount.TextScaled = true
		gemAmount.Font = Enum.Font.GothamBold
		gemAmount.TextXAlignment = Enum.TextXAlignment.Left
		gemAmount.Parent = productFrame

		local buyButton = Instance.new("TextButton")
		buyButton.Size = UDim2.new(0.3, -10, 0.8, 0)
		buyButton.Position = UDim2.new(0.7, 0, 0.1, 0)
		buyButton.BackgroundColor3 = Color3.new(0, 0.8, 0)
		buyButton.BorderSizePixel = 0
		buyButton.Text = "R$ " .. product.price
		buyButton.TextColor3 = Color3.new(1, 1, 1)
		buyButton.TextScaled = true
		buyButton.Font = Enum.Font.GothamBold
		buyButton.Parent = productFrame

		local buyCorner = GameConfig.createUICorner(6)
		buyCorner.Parent = buyButton

		buyButton.MouseButton1Click:Connect(function()
			MarketplaceService:PromptProductPurchase(player, product.id)
		end)

		yOffset = yOffset + 90
	end

	gemsContent.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

-- Initialize content
createShopContent()
createDailyContent()
createVIPContent()
createGemsContent()

-- Update currency display
local function updateCurrencyDisplay()
	if player:FindFirstChild("leaderstats") then
		if player.leaderstats:FindFirstChild("Gems") then
			gemsLabel.Text = "💎 Gems: " .. GameConfig.formatNumber(player.leaderstats.Gems.Value)
		end
		if player.leaderstats:FindFirstChild("Coins") then
			coinsLabel.Text = "🪙 Coins: " .. GameConfig.formatNumber(player.leaderstats.Coins.Value)
		end
	end
end

-- Connect events
shopButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = true
	switchTab("Shop")
	updateCurrencyDisplay()
end)

dailyButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = true
	switchTab("Daily")
	updateCurrencyDisplay()
end)

closeButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

-- Tab switching
for tabName, button in pairs(tabButtons) do
	button.MouseButton1Click:Connect(function()
		switchTab(tabName)
	end)
end

-- Remote event responses
purchaseShopItem.OnClientEvent:Connect(function(success, message)
	if success then
		-- Show success effect
		local successLabel = Instance.new("TextLabel")
		successLabel.Size = UDim2.new(0, 200, 0, 50)
		successLabel.Position = UDim2.new(0.5, -100, 0.5, -25)
		successLabel.BackgroundTransparency = 1
		successLabel.Text = "Purchase Successful!"
		successLabel.TextColor3 = Color3.new(0, 1, 0)
		successLabel.TextScaled = true
		successLabel.Font = Enum.Font.GothamBold
		successLabel.Parent = monetizationGui

		local tween = TweenService:Create(successLabel, TweenInfo.new(2), {TextTransparency = 1})
		tween:Play()
		tween.Completed:Connect(function()
			successLabel:Destroy()
		end)

		updateCurrencyDisplay()
	else
		-- Show error message
		warn("Purchase failed: " .. message)
	end
end)

claimDailyReward.OnClientEvent:Connect(function(canClaim, reward, streak)
	if canClaim then
		local rewardLabel = Instance.new("TextLabel")
		rewardLabel.Size = UDim2.new(0, 300, 0, 100)
		rewardLabel.Position = UDim2.new(0.5, -150, 0.5, -50)
		rewardLabel.BackgroundTransparency = 1
		rewardLabel.Text = "Daily Reward Claimed!\n+" .. reward .. " Gems\nStreak: " .. streak
		rewardLabel.TextColor3 = GameConfig.UI_COLORS.PRIMARY
		rewardLabel.TextScaled = true
		rewardLabel.Font = Enum.Font.GothamBold
		rewardLabel.Parent = monetizationGui

		local tween = TweenService:Create(rewardLabel, TweenInfo.new(3), {TextTransparency = 1})
		tween:Play()
		tween.Completed:Connect(function()
			rewardLabel:Destroy()
		end)

		updateCurrencyDisplay()
	else
		warn("Daily reward not available yet")
	end
end)

-- Monitor leaderstats changes
player.CharacterAdded:Connect(function()
	wait(2)
	updateCurrencyDisplay()

	if player:FindFirstChild("leaderstats") then
		if player.leaderstats:FindFirstChild("Gems") then
			player.leaderstats.Gems.Changed:Connect(updateCurrencyDisplay)
		end
		if player.leaderstats:FindFirstChild("Coins") then
			player.leaderstats.Coins.Changed:Connect(updateCurrencyDisplay)
		end
	end
end)

-- Initial setup
if player.Character and player:FindFirstChild("leaderstats") then
	updateCurrencyDisplay()
end

-- Default to shop tab
switchTab("Shop")

print("Monetization UI loaded for " .. player.Name)