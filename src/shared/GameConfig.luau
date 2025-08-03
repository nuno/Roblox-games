-- Shared Game Configuration and Utilities
local GameConfig = {}

-- Game Constants
GameConfig.COIN_VALUE = 10
GameConfig.COIN_SPAWN_INTERVAL = 3
GameConfig.MAX_COINS = 10
GameConfig.SPAWN_HEIGHT = 5
GameConfig.SPAWN_RADIUS = 100

-- Sprint System Constants
GameConfig.NORMAL_WALKSPEED = 16
GameConfig.SPRINT_WALKSPEED = 24

-- Monetization Constants
GameConfig.GEM_REWARDS = {
	DAILY_LOGIN = 50,
	ACHIEVEMENT = 25,
	COIN_MILESTONE = 10,
	VIP_DAILY_BONUS = 100
}

GameConfig.SHOP_ITEMS = {
	SPEED_BOOST = {price = 100, duration = 300, multiplier = 1.5},
	COIN_MAGNET = {price = 150, duration = 180, range = 20},
	DOUBLE_COINS = {price = 200, duration = 240, multiplier = 2},
	TRIPLE_COINS = {price = 500, duration = 120, multiplier = 3}
}

GameConfig.VIP_BENEFITS = {
	COIN_MULTIPLIER = 1.5,
	GEM_MULTIPLIER = 2,
	EXCLUSIVE_AREAS = true,
	DAILY_BONUS = true,
	PRIORITY_SUPPORT = true
}

GameConfig.ACHIEVEMENTS = {
	FIRST_COIN = {requirement = 1, reward = 25, title = "First Steps"},
	COIN_COLLECTOR = {requirement = 100, reward = 50, title = "Coin Collector"},
	COIN_MASTER = {requirement = 1000, reward = 100, title = "Coin Master"},
	SPEED_DEMON = {requirement = 50, reward = 75, title = "Speed Demon"}, -- Sprint 50 times
	DAILY_PLAYER = {requirement = 7, reward = 150, title = "Daily Player"} -- Login 7 days
}

-- ⚠️ IMPORTANT: REPLACE THESE WITH YOUR ACTUAL GAME PASS IDs! ⚠️
-- Follow the GAME_PASS_SETUP_GUIDE.md for step-by-step instructions
GameConfig.GAME_PASSES = {
	VIP = 1372825080,        -- ⚠️ REPLACE: Your VIP pass ID (169 Robux)
	DOUBLE_GEMS = 1372977147, -- ⚠️ REPLACE: Your double gems pass ID (99 Robux)
	STARTER_PACK = 1373181116 -- ⚠️ REPLACE: Your starter pack ID (49 Robux)
}

-- ⚠️ IMPORTANT: REPLACE THESE WITH YOUR ACTUAL DEVELOPER PRODUCT IDs! ⚠️
-- Create these in Roblox Creator Hub under Monetization > Developer Products
GameConfig.DEVELOPER_PRODUCTS = {
	GEMS_100 = {id = 3357158850, price = 19, gems = 100},   -- ⚠️ REPLACE: 100 gems product ID
	GEMS_500 = {id = 3357159476, price = 79, gems = 500},   -- ⚠️ REPLACE: 500 gems product ID
	GEMS_1000 = {id = 3357159901, price = 149, gems = 1000}, -- ⚠️ REPLACE: 1000 gems product ID
	GEMS_2500 = {id = 3357160481, price = 299, gems = 2500}  -- ⚠️ REPLACE: 2500 gems product ID
}

--[[
📋 SETUP CHECKLIST:
1. ✅ Publish your game to Roblox first
2. ⬜ Go to create.roblox.com and select your game
3. ⬜ Create 3 Game Passes (VIP, Double Gems, Starter Pack)
4. ⬜ Create 4 Developer Products (100, 500, 1000, 2500 gems)
5. ⬜ Copy the IDs and replace the 0000000000 placeholders above
6. ⬜ Save this file and sync with Rojo
7. ⬜ Test your monetization features!

📖 Need help? Check GAME_PASS_SETUP_GUIDE.md for detailed instructions!
--]]

-- UI Constants
GameConfig.UI_COLORS = {
	PRIMARY = Color3.new(1, 1, 0), -- Gold
	SECONDARY = Color3.new(0.8, 0.8, 0.8), -- Light gray
	BACKGROUND = Color3.new(0, 0, 0), -- Black
	SUCCESS = Color3.new(0, 1, 0), -- Green
}

-- Sound IDs (using built-in Roblox sounds)
GameConfig.SOUNDS = {
	COIN_COLLECT = "rbxasset://sounds/electronicpingshort.wav",
	GAME_START = "rbxasset://sounds/button_click.wav",
}

-- Utility Functions
function GameConfig.formatNumber(number)
	-- Format numbers with commas for better readability
	local formatted = tostring(number)
	local k
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if k == 0 then
			break
		end
	end
	return formatted
end

function GameConfig.getRandomSpawnPosition()
	-- Generate a random position within the spawn radius
	local x = math.random(-GameConfig.SPAWN_RADIUS, GameConfig.SPAWN_RADIUS)
	local z = math.random(-GameConfig.SPAWN_RADIUS, GameConfig.SPAWN_RADIUS)
	local y = GameConfig.SPAWN_HEIGHT

	return Vector3.new(x, y, z)
end

function GameConfig.createUICorner(radius)
	-- Helper function to create rounded corners
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 8)
	return corner
end

function GameConfig.createGlow(parent, color, brightness, range)
	-- Helper function to create glowing effects
	local pointLight = Instance.new("PointLight")
	pointLight.Color = color or GameConfig.UI_COLORS.PRIMARY
	pointLight.Brightness = brightness or 2
	pointLight.Range = range or 10
	pointLight.Parent = parent
	return pointLight
end

-- Game Messages
GameConfig.MESSAGES = {
	PLAYER_JOINED = "%s joined the coin collection game!",
	COIN_COLLECTED = "%s collected a coin! Total: %d",
	GAME_STARTED = "Coin Collection Game started!",
	COIN_SPAWNED = "Coin spawned at position: %s",
}

function GameConfig.formatMessage(messageKey, ...)
	local template = GameConfig.MESSAGES[messageKey]
	if template then
		return string.format(template, ...)
	end
	return "Unknown message"
end

-- Validation Functions
function GameConfig.isValidPlayer(player)
	return player and player.Parent and player:FindFirstChild("leaderstats")
end

function GameConfig.isValidCharacter(character)
	return character and character:FindFirstChild("Humanoid") and character:FindFirstChild("HumanoidRootPart")
end

return GameConfig