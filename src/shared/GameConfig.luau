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