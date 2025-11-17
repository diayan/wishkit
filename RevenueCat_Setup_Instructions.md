# RevenueCat Integration - Setup Instructions

## ✅ What's Been Implemented

All code is ready! Here's what was added:

### 1. **SubscriptionManager.swift**
- Handles all RevenueCat configuration
- Manages subscription state
- Provides entitlement checking
- Auto-refreshes customer info

### 2. **PaywallView.swift**
- Native RevenueCat paywall UI
- Integrated into onboarding flow
- Shows after last onboarding screen
- Includes restore purchases

### 3. **CustomerCenterView.swift**
- Subscription management interface
- Available in Settings (when subscribed)
- Allows users to manage/cancel subscriptions

### 4. **Integration Points**
- ✅ App initialization in `WishKitApp.swift`
- ✅ Onboarding flow updated
- ✅ Settings page with subscription management
- ✅ Entitlement checking throughout the app

---

## 🚀 Next Steps - Complete Setup

### Step 1: Add RevenueCat Package (2 minutes)

1. Open `WishKit.xcodeproj` in Xcode
2. Go to **File → Add Package Dependencies...**
3. Paste URL: `https://github.com/RevenueCat/purchases-ios-spm.git`
4. Click **Add Package**
5. Select both:
   - ☑️ **RevenueCat**
   - ☑️ **RevenueCatUI**
6. Click **Add Package**

### Step 2: Configure RevenueCat Dashboard (10 minutes)

#### A. Create RevenueCat Account
1. Go to [app.revenuecat.com](https://app.revenuecat.com)
2. Sign up (it's free!)
3. Create a new project: "Wishly"

#### B. Add Your App
1. In RevenueCat dashboard → **Apps**
2. Click **+ New App**
3. Platform: **iOS**
4. Bundle ID: `your.bundle.id` (get from Xcode)
5. App Name: **Wishly**

#### C. Connect App Store Connect
1. In RevenueCat → **App Settings → Service Credentials**
2. Follow instructions to add App Store Connect API key
3. This allows RevenueCat to verify purchases

#### D. Create Products
1. Go to **Products** in RevenueCat dashboard
2. Create two products:

   **Product 1 - Weekly Subscription:**
   - Product ID: `weekly`
   - Type: Auto-renewable subscription
   - Duration: 1 week
   - Free Trial: 3 days

   **Product 2 - Yearly Subscription:**
   - Product ID: `yearly`
   - Type: Auto-renewable subscription
   - Duration: 1 year
   - Free Trial: 3 days (optional)

#### E. Create Offering
1. Go to **Offerings**
2. Click **+ New Offering**
3. Name it: "Default"
4. Make it current
5. Add packages:
   - **Weekly Package**: Link to `weekly` product
   - **Yearly Package**: Link to `yearly` product

#### F. Create Entitlement
1. Go to **Entitlements**
2. Click **+ New Entitlement**
3. Identifier: `Wishly Pro` (exact match!)
4. Attach products:
   - ☑️ weekly
   - ☑️ yearly

#### G. Get API Keys
1. Go to **API Keys** in RevenueCat
2. You'll see:
   - **Public API Key** (starts with `appl_` for production)
   - **Test API Key** (starts with `test_`)

3. **IMPORTANT**: Replace the test key in code with your production key before release:
   ```swift
   // In SubscriptionManager.swift line 29:
   private let apiKey = "appl_YOUR_PRODUCTION_KEY_HERE"
   ```

### Step 3: Create Products in App Store Connect (15 minutes)

1. Go to [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
2. Select your app
3. Go to **Features → In-App Purchases**
4. Click **+** to add auto-renewable subscriptions

**Weekly Subscription:**
- Reference Name: "Wishly Pro Weekly"
- Product ID: `weekly` (must match RevenueCat!)
- Subscription Group: Create "Wishly Pro"
- Duration: 1 week
- Price: $4.99/week (or your price)
- Free Trial: 3 days
- Add localized description

**Yearly Subscription:**
- Reference Name: "Wishly Pro Yearly"
- Product ID: `yearly` (must match RevenueCat!)
- Subscription Group: "Wishly Pro" (same group)
- Duration: 1 year
- Price: $29.99/year (or your price)
- Free Trial: 3 days
- Add localized description

### Step 4: Design Your Paywall in RevenueCat

1. Go to **Paywalls** in RevenueCat dashboard
2. Click **+ New Paywall**
3. Use the visual editor to customize:
   - Add your app icon (use the ones from `/PaywallIcons/`)
   - Set colors (use `#FF4D33` for brand consistency)
   - Add copy about "Wishly Pro" features
   - Customize layout

**Suggested Features to Highlight:**
- ✨ Unlimited AI-generated messages
- 🎨 All themes unlocked
- ⚡ Priority message generation
- 🔄 Save unlimited messages
- 💫 No ads

### Step 5: Build and Test

1. In Xcode, build the project (Cmd+B)
2. If you get errors, make sure:
   - RevenueCat packages are added
   - Bundle ID matches RevenueCat config

3. Run in simulator
4. Complete onboarding → Paywall should appear!

### Step 6: Test Purchases (Sandbox)

1. In Xcode: **Product → Scheme → Edit Scheme**
2. Run tab → Options
3. StoreKit Configuration: Create new if needed
4. Add your products

Or use App Store Sandbox:
1. Settings → App Store → Sandbox Account
2. Sign in with test account
3. Test purchasing in your app

---

## 💡 How to Use Subscription State in Your App

### Check if User is Subscribed

```swift
// Anywhere in your app:
@State private var subscriptionManager = SubscriptionManager.shared

// Then use:
if subscriptionManager.isSubscribed {
    // Show premium features
} else {
    // Show paywall or limited features
}
```

### Example: Limit Message Generation

```swift
// In MessageThemeView or wherever you generate messages:
func generateMessage() {
    let messageCount = UserDefaults.standard.integer(forKey: "monthlyMessageCount")

    if !subscriptionManager.isSubscribed && messageCount >= 5 {
        // Show upgrade prompt
        showPaywall = true
    } else {
        // Generate message
        proceedWithGeneration()
    }
}
```

### Show Paywall Anywhere

```swift
@State private var showPaywall = false

// Later:
.sheet(isPresented: $showPaywall) {
    PaywallView {
        // Called when paywall is dismissed or purchase complete
        print("Paywall closed")
    }
}
```

---

## 🔧 Configuration Reference

### Files Modified:
- ✅ `WishKitApp.swift` - RevenueCat initialization
- ✅ `OnboardingView.swift` - Paywall after onboarding
- ✅ `SettingsView.swift` - Subscription management

### Files Created:
- ✅ `SubscriptionManager.swift` - Core subscription logic
- ✅ `PaywallView.swift` - Paywall UI
- ✅ `CustomerCenterView.swift` - Manage subscription

### Environment:
- **Test Mode**: Using `test_aXUXlLiUwcsGpaIojOKQIWXWLmn`
- **Production**: Replace with your production key
- **Entitlement**: `"Wishly Pro"`
- **Products**: `weekly`, `yearly`

---

## 📊 Analytics & Dashboard

RevenueCat provides built-in analytics:
- Monthly Recurring Revenue (MRR)
- Active subscriptions
- Churn rate
- Trial conversion
- Revenue charts

Access at: [app.revenuecat.com](https://app.revenuecat.com)

---

## 🐛 Troubleshooting

### Build Errors
- **"Cannot find RevenueCat in scope"** → Add package (Step 1)
- **"Missing import"** → Clean build folder (Cmd+Shift+K)

### Runtime Issues
- **"No offerings found"** → Check RevenueCat dashboard setup
- **"Invalid product ID"** → Ensure App Store Connect IDs match RevenueCat
- **"Purchase failed"** → Check sandbox account or test mode

### Testing
- Use RevenueCat's **Debug Mode** (already enabled in code)
- Check Xcode console for RevenueCat logs (marked with 📱)
- Verify products in RevenueCat dashboard

---

## 🚢 Before App Store Release

1. **Replace Test API Key:**
   ```swift
   // SubscriptionManager.swift line 29
   private let apiKey = "appl_YOUR_PRODUCTION_KEY"
   ```

2. **Change Log Level:**
   ```swift
   // SubscriptionManager.swift line 38
   Purchases.logLevel = .info // or .error for production
   ```

3. **Test with TestFlight:**
   - Submit build to TestFlight
   - Test actual purchases with real payment method
   - Verify 3-day trial works correctly

4. **Add Subscription Terms:**
   - Add privacy policy URL
   - Add terms of service
   - Document auto-renewal terms

---

## ✨ You're All Set!

Once you complete Step 1 (add package), your app will compile and the subscription system will be fully functional. The paywall will appear after onboarding, and users can manage subscriptions from Settings.

Need help? Check:
- [RevenueCat Docs](https://docs.revenuecat.com)
- [RevenueCat Community](https://community.revenuecat.com)
- Your RevenueCat dashboard has a support chat!
