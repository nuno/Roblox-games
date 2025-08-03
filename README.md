# 💰 Coin Collection Game - Monetization Edition

A comprehensive Roblox game featuring advanced monetization systems designed to generate **REAL REVENUE** for developers!

## 🎮 Game Overview

**Coin Collection Game** is a multiplayer Roblox experience where players compete to collect golden coins while enjoying premium features through our advanced monetization system. This isn't just a game - it's a complete revenue-generating platform with virtual currency, game passes, daily rewards, achievements, and more!

### 💎 NEW MONETIZATION FEATURES
- **Virtual Currency (Gems)**: Premium currency system with multiple earning methods
- **Game Passes**: VIP membership, Double Gems, and Starter Pack
- **Developer Products**: Purchasable gem packages (100-2500 gems)
- **Shop System**: Speed boosts, coin magnets, and multipliers
- **Daily Rewards**: Login streaks with increasing rewards
- **Achievement System**: 5+ achievements with gem rewards
- **VIP Benefits**: Exclusive multipliers and bonuses
- **Data Persistence**: All progress saved across sessions
- **Leaderboard System**: Competitive rankings

### 💰 Revenue Potential
- **100 Daily Users**: $90-260/month
- **500 Daily Users**: $550-1450/month
- **1000+ Daily Users**: $1400-3500/month

## 🎯 How to Play

### Basic Gameplay
1. **Join the Game**: When you spawn in, you'll see the game UI with your current score and gems
2. **Move Around**: Use WASD to walk, hold **Shift to sprint** for faster movement
3. **Collect Coins**: Walk around the baseplate and touch the glowing golden coins
4. **Earn Points**: Each coin gives you **10 points** (more with VIP multipliers!)
5. **Compete**: Check the leaderboard to see how you rank against other players

### Premium Features
6. **Open the Shop**: Click the "💎 SHOP" button to access premium features
7. **Buy Boosts**: Purchase speed boosts, coin magnets, and multipliers with gems
8. **Claim Daily Rewards**: Get free gems every day with increasing streak bonuses
9. **Unlock Achievements**: Complete challenges to earn bonus gems
10. **Go VIP**: Purchase VIP membership for permanent benefits and exclusive features

## ✨ Game Features

### 🎨 Visual Effects
- **Glowing Coins**: Golden coins with bright lighting effects
- **Spinning Animation**: Coins rotate continuously for visibility
- **UI Animations**: Score updates with bouncing text effects
- **Floating Text**: "+10" appears when you collect a coin
- **Boost Effects**: Visual indicators for active power-ups
- **Trail Effects**: Speed boost creates particle trails
- **Professional UI**: Modern, polished interface design

### 🔊 Audio
- **Collection Sound**: Satisfying ping sound when collecting coins
- **Built-in Roblox Sounds**: Uses reliable audio assets

### 📊 Core Game Mechanics
- **Sprint System**: Hold Shift to run faster and collect coins quicker
- **Automatic Spawning**: Up to 10 coins active at once
- **Random Positions**: Coins spawn in different locations
- **Leaderboard**: Real-time score tracking
- **Multiplayer**: Compete with friends
- **Mobile Support**: Touch controls with sprint button for mobile devices

### 💎 Monetization Systems
- **Gem Economy**: Earn and spend premium currency
- **Shop System**: Purchase temporary boosts and permanent upgrades
- **Daily Login Rewards**: Increasing rewards for consecutive days
- **Achievement System**: Complete challenges for gem rewards
- **VIP Membership**: Premium benefits and exclusive features
- **Game Pass Integration**: Robux purchases for permanent benefits
- **Developer Products**: Direct gem purchases with real money
- **Data Persistence**: All progress saved automatically

## 🛠️ Technical Details

### Project Structure
```
src/
├── client/                       # Client-side scripts
│   ├── CoinGameUI.client.luau           # Main game UI
│   ├── MonetizationUI.client.luau      # Shop, daily rewards, VIP
│   ├── BoostEffects.client.luau        # Visual boost effects
│   ├── SprintSystem.client.luau        # Enhanced movement system
│   └── Hello.client.luau               # (deprecated)
├── server/                       # Server-side scripts
│   ├── CoinGame.server.luau            # Core game logic
│   ├── MonetizationManager.server.luau # Revenue systems
│   └── Hello.server.luau               # (deprecated)
└── shared/                       # Shared modules
    ├── GameConfig.luau                 # Game configuration
    └── Hello.luau                      # (deprecated)

Additional Files:
├── MONETIZATION_GUIDE.md         # Detailed revenue strategy guide
└── default.project.json          # Rojo project configuration
```

### Configuration
Game settings can be modified in [`GameConfig.luau`](src/shared/GameConfig.luau):

#### Core Game Settings
- **COIN_VALUE**: Points per coin (default: 10)
- **COIN_SPAWN_INTERVAL**: Seconds between spawns (default: 3)
- **MAX_COINS**: Maximum coins on map (default: 10)
- **SPAWN_RADIUS**: Area where coins spawn (default: 100 studs)
- **NORMAL_WALKSPEED**: Regular walking speed (default: 16)
- **SPRINT_WALKSPEED**: Sprint speed when holding Shift (default: 24)

#### Monetization Settings
- **GEM_REWARDS**: Daily login, achievement, and milestone rewards
- **SHOP_ITEMS**: Boost prices, durations, and effects
- **VIP_BENEFITS**: Multipliers and exclusive features
- **ACHIEVEMENTS**: Requirements and rewards for each achievement
- **GAME_PASSES**: Robux prices for VIP, Double Gems, and Starter Pack
- **DEVELOPER_PRODUCTS**: Gem packages and their Robux costs

#### Important: Set Your Own Game Pass IDs!
Before publishing, you must create your own Game Passes and Developer Products in Roblox and update the IDs in GameConfig.luau:
```lua
GameConfig.GAME_PASSES = {
    VIP = YOUR_VIP_PASS_ID,           -- Replace with your VIP pass ID
    DOUBLE_GEMS = YOUR_DOUBLE_GEMS_ID, -- Replace with your double gems pass ID
    STARTER_PACK = YOUR_STARTER_PACK_ID -- Replace with your starter pack ID
}

GameConfig.DEVELOPER_PRODUCTS = {
    GEMS_100 = {id = YOUR_PRODUCT_ID, price = 19, gems = 100},
    -- ... update all product IDs
}
```

## 🚀 Setup Instructions

### Prerequisites
- [Rojo](https://rojo.space/) for syncing code to Roblox Studio
- [Aftman](https://github.com/LPGhatguy/aftman) for tool management (optional)

### Installation Steps

1. **Clone/Download** this project to your computer

2. **Install Rojo** (if not already installed):
   ```bash
   # Using Aftman (recommended)
   aftman install

   # Or install manually
   # Visit https://rojo.space/docs/installation/
   ```

3. **Open Roblox Studio** and create a new place

4. **Start Rojo** in the project directory:
   ```bash
   rojo serve
   ```

5. **Connect Roblox Studio** to Rojo:
   - Install the Rojo plugin in Studio
   - Click "Connect" in the plugin
   - The default address should be `localhost:34872`

6. **Sync the Project**:
   - Click "Sync In" to load the game files
   - The game structure will appear in your workspace

7. **Test the Game**:
   - Press F5 or click "Play" to test in Studio
   - Walk around and collect coins!

8. **Publish** (optional):
   - Save your place in Studio
   - Publish to Roblox for others to play

## 🎮 Game Controls

### Desktop Controls
- **WASD** or **Arrow Keys**: Move your character
- **Left Shift**: Hold to sprint (run faster)
- **Space**: Jump
- **Mouse**: Look around
- **Touch Coins**: Walk into golden coins to collect them

### Mobile Controls
- **Virtual Joystick**: Move your character
- **Sprint Button** (🏃): Tap to toggle sprint mode
- **Touch Coins**: Walk into golden coins to collect them

## 🏆 Tips for High Scores

1. **Use Sprint**: Hold Shift to run faster and reach coins before other players
2. **Move Strategically**: Coins spawn every 3 seconds, so keep moving efficiently
3. **Check All Areas**: Coins can spawn anywhere within 100 studs of center
4. **Listen for Sounds**: The collection sound helps confirm you got a coin
5. **Watch the UI**: Your score updates in real-time
6. **Play with Friends**: More fun with competition!

## 🔧 Customization

Want to modify the game? Here are some easy changes:

### Change Coin Value
In [`GameConfig.luau`](src/shared/GameConfig.luau), modify:
```lua
GameConfig.COIN_VALUE = 20  -- Change from 10 to 20 points
```

### Adjust Spawn Rate
```lua
GameConfig.COIN_SPAWN_INTERVAL = 2  -- Spawn every 2 seconds instead of 3
```

### Increase Max Coins
```lua
GameConfig.MAX_COINS = 15  -- Allow up to 15 coins at once
```

### Change Sprint Speed
```lua
GameConfig.SPRINT_WALKSPEED = 30  -- Make sprinting even faster
GameConfig.NORMAL_WALKSPEED = 20  -- Increase normal walking speed
```

### Change Colors
```lua
GameConfig.UI_COLORS = {
    PRIMARY = Color3.new(0, 1, 0),  -- Change to green coins
    -- ... other colors
}
```

## 🐛 Troubleshooting

### Common Issues

**Coins not spawning?**
- Check that the server script is running
- Verify Rojo connection is active
- Look for error messages in Studio output

**UI not showing?**
- Ensure the client script loaded properly
- Check that ReplicatedStorage contains GameConfig
- Restart the test session

**No sound effects?**
- Roblox audio may be disabled in Studio
- Test in a published game for full audio

### Getting Help

If you encounter issues:
1. Check the Studio Output window for error messages
2. Verify all scripts are in the correct locations
3. Make sure Rojo is properly syncing files
4. Try restarting Roblox Studio

## 📝 License

This project is open source and available for educational purposes. Feel free to modify and improve the game!

## 🎉 Have Fun!

Enjoy collecting coins and competing with friends! The game is designed to be simple but engaging, perfect for learning Roblox development or just having fun.

---

*Created with ❤️ for the Roblox community*