# 🎮 Game Pass Setup Guide

This guide will walk you through creating Game Passes and Developer Products in Roblox Creator Hub and configuring them in your game.

## 📋 Step-by-Step Setup

### Step 1: Publish Your Game First
1. Open Roblox Studio
2. Use Rojo to sync your game files (`rojo serve` then connect in Studio)
3. Go to **File > Publish to Roblox As...**
4. Create a new game or update an existing one
5. Make sure your game is published (it can be private for testing)

### Step 2: Access Creator Hub
1. Go to [create.roblox.com](https://create.roblox.com)
2. Sign in with your Roblox account
3. Click on your published game

### Step 3: Create Game Passes

#### VIP Pass (169 Robux)
1. In Creator Hub, go to **Monetization > Passes**
2. Click **Create a Pass**
3. **Name**: "VIP Membership"
4. **Description**: "👑 VIP MEMBERSHIP - Get 1.5x coin multiplier, 2x gem multiplier, daily VIP bonus, and exclusive features!"
5. **Price**: 169 Robux
6. Upload an icon (optional - create a golden crown image)
7. Click **Create Pass**
8. **Copy the Pass ID** (you'll see it in the URL or pass details)

#### Double Gems Pass (99 Robux)
1. Click **Create a Pass** again
2. **Name**: "Double Gems Forever"
3. **Description**: "💎 DOUBLE GEMS - Permanently earn 2x gems from all sources! Perfect for dedicated players."
4. **Price**: 99 Robux
5. Upload an icon (optional - create a gem image)
6. Click **Create Pass**
7. **Copy the Pass ID**

#### Starter Pack (49 Robux)
1. Click **Create a Pass** again
2. **Name**: "Starter Pack"
3. **Description**: "🎁 STARTER PACK - Get 500 bonus gems to jumpstart your adventure! One-time purchase."
4. **Price**: 49 Robux
5. Upload an icon (optional - create a gift box image)
6. Click **Create Pass**
7. **Copy the Pass ID**

### Step 4: Create Developer Products

Go to **Monetization > Developer Products**

#### 100 Gems (19 Robux)
1. Click **Create a Product**
2. **Name**: "100 Gems"
3. **Description**: "💎 100 Gems - Perfect for trying out boosts and upgrades!"
4. **Price**: 19 Robux
5. Click **Create Product**
6. **Copy the Product ID**

#### 500 Gems (79 Robux)
1. **Name**: "500 Gems"
2. **Description**: "💎 500 Gems - Great value pack for serious players!"
3. **Price**: 79 Robux
4. **Copy the Product ID**

#### 1000 Gems (149 Robux)
1. **Name**: "1000 Gems"
2. **Description**: "💎 1000 Gems - Popular choice! Enough for multiple premium boosts."
3. **Price**: 149 Robux
4. **Copy the Product ID**

#### 2500 Gems (299 Robux)
1. **Name**: "2500 Gems"
2. **Description**: "💎 2500 Gems - Best value! For the ultimate gaming experience."
3. **Price**: 299 Robux
4. **Copy the Product ID**

### Step 5: Update Your Game Configuration

Once you have all the IDs, you need to update them in your game code:

1. Open `src/shared/GameConfig.luau` in your code editor
2. Find the `GAME_PASSES` section
3. Replace the placeholder IDs with your actual IDs
4. Find the `DEVELOPER_PRODUCTS` section
5. Replace the placeholder IDs with your actual product IDs
6. Save the file
7. Use Rojo to sync the changes to Roblox Studio
8. Test your game!

## 🔧 Configuration Template

Here's what your GameConfig should look like after setup:

```lua
GameConfig.GAME_PASSES = {
    VIP = 123456789,           -- Replace with your VIP pass ID
    DOUBLE_GEMS = 987654321,   -- Replace with your double gems pass ID
    STARTER_PACK = 456789123   -- Replace with your starter pack ID
}

GameConfig.DEVELOPER_PRODUCTS = {
    GEMS_100 = {id = 111111111, price = 19, gems = 100},
    GEMS_500 = {id = 222222222, price = 79, gems = 500},
    GEMS_1000 = {id = 333333333, price = 149, gems = 1000},
    GEMS_2500 = {id = 444444444, price = 299, gems = 2500}
}
```

## 🧪 Testing Your Setup

### Test Game Passes:
1. In Roblox Studio, go to **Test > Start Server**
2. Join as a player
3. Try purchasing a game pass (it won't charge you in Studio)
4. Check if the VIP benefits activate

### Test Developer Products:
1. In Studio, test the gem purchase buttons
2. The purchases won't actually charge in Studio
3. For real testing, publish your game and test on the Roblox website

## 💡 Pro Tips

### Pricing Strategy:
- **49 Robux Starter Pack**: Low entry point to convert free players
- **99 Robux Double Gems**: Good value for regular players
- **169 Robux VIP**: Premium tier for committed players
- **Gem Packages**: Multiple price points for different spending levels

### Marketing Your Passes:
- Use clear, benefit-focused descriptions
- Create attractive icons (use Canva or similar tools)
- Highlight the value proposition
- Test different prices and monitor conversion rates

### Revenue Optimization:
- Monitor which passes sell best
- Adjust gem rewards based on player behavior
- Consider seasonal sales or limited-time offers
- Track player retention and spending patterns

## 🚨 Important Notes

1. **Test Everything**: Always test purchases in a published game before going live
2. **Monitor Revenue**: Use Roblox Analytics to track your earnings
3. **Player Feedback**: Listen to your community about pricing and value
4. **Regular Updates**: Keep adding new content to maintain engagement
5. **Follow Roblox TOS**: Ensure all monetization follows Roblox's terms of service

## 📊 Expected Results

Once properly configured, you should see:
- Players purchasing game passes for permanent benefits
- Regular gem purchases for temporary boosts
- Increased player engagement and retention
- Steady revenue growth as your player base expands

Remember: The key to successful monetization is providing real value to players while maintaining a fun, fair gaming experience!