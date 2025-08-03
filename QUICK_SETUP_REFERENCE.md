# 🚀 Quick Setup Reference Card

## 📋 Game Pass Setup Checklist

### 1. Publish Your Game First
- Use Rojo to sync your files to Roblox Studio
- File > Publish to Roblox As...
- Your game can be private for testing

### 2. Create Game Passes at [create.roblox.com](https://create.roblox.com)

| Pass Name | Price | Description Template |
|-----------|-------|---------------------|
| **VIP Membership** | 169 Robux | 👑 VIP MEMBERSHIP - Get 1.5x coin multiplier, 2x gem multiplier, daily VIP bonus, and exclusive features! |
| **Double Gems Forever** | 99 Robux | 💎 DOUBLE GEMS - Permanently earn 2x gems from all sources! Perfect for dedicated players. |
| **Starter Pack** | 49 Robux | 🎁 STARTER PACK - Get 500 bonus gems to jumpstart your adventure! One-time purchase. |

### 3. Create Developer Products

| Product Name | Price | Description Template |
|--------------|-------|---------------------|
| **100 Gems** | 19 Robux | 💎 100 Gems - Perfect for trying out boosts and upgrades! |
| **500 Gems** | 79 Robux | 💎 500 Gems - Great value pack for serious players! |
| **1000 Gems** | 149 Robux | 💎 1000 Gems - Popular choice! Enough for multiple premium boosts. |
| **2500 Gems** | 299 Robux | 💎 2500 Gems - Best value! For the ultimate gaming experience. |

### 4. Copy IDs and Update GameConfig.luau

Replace these placeholders in `src/shared/GameConfig.luau`:

```lua
GameConfig.GAME_PASSES = {
    VIP = YOUR_VIP_PASS_ID,           -- Replace 0000000000
    DOUBLE_GEMS = YOUR_DOUBLE_GEMS_ID, -- Replace 0000000000
    STARTER_PACK = YOUR_STARTER_PACK_ID -- Replace 0000000000
}

GameConfig.DEVELOPER_PRODUCTS = {
    GEMS_100 = {id = YOUR_100_GEMS_ID, price = 19, gems = 100},
    GEMS_500 = {id = YOUR_500_GEMS_ID, price = 79, gems = 500},
    GEMS_1000 = {id = YOUR_1000_GEMS_ID, price = 149, gems = 1000},
    GEMS_2500 = {id = YOUR_2500_GEMS_ID, price = 299, gems = 2500}
}
```

## 🎯 Where to Find IDs

### Game Pass IDs:
1. Go to create.roblox.com
2. Select your game
3. Go to Monetization > Passes
4. Click on a pass
5. The ID is in the URL: `...passes/123456789/configure`

### Developer Product IDs:
1. Go to Monetization > Developer Products
2. Click on a product
3. The ID is in the URL: `...products/123456789/configure`

## 🧪 Testing Steps

1. **Save and Sync**: Update GameConfig.luau and sync with Rojo
2. **Studio Test**: Test in Roblox Studio (purchases won't charge)
3. **Live Test**: Publish and test on Roblox website
4. **Monitor**: Check Creator Hub for purchase analytics

## 💰 Revenue Expectations

With proper setup, expect:
- **First Month**: $50-200 (building player base)
- **Month 2-3**: $200-800 (word of mouth growth)
- **Month 4+**: $500-2000+ (established community)

## 🆘 Troubleshooting

**Game passes not working?**
- Check IDs are correct in GameConfig.luau
- Ensure game is published
- Test with different Roblox account

**No purchases showing?**
- Wait 24-48 hours for analytics to update
- Check Creator Hub > Analytics > Revenue

**Players can't see shop?**
- Verify all scripts loaded properly
- Check for errors in Studio Output
- Ensure Rojo synced all files

## 📞 Need Help?

1. Check `GAME_PASS_SETUP_GUIDE.md` for detailed instructions
2. Review `MONETIZATION_GUIDE.md` for strategy tips
3. Test everything in Studio first
4. Monitor player feedback and adjust prices accordingly

---

**Remember**: The key to success is providing real value to players while maintaining a fun, fair gaming experience! 🎮💰