import Foundation
import UIKit
import ROX
import ROXCore
import SwiftUI

class AppDelegate: UIResponder, UIApplicationDelegate, ObservableObject {

    // SDK key - change this to reproduce customer's bug
    let projectKey = "<YOUR_SDK_KEY>"
    // ROX instance - matches customer's implementation
    private var instance: ROXInstance?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        print("🚀 SETUP CALLED")

        // Create instance - matches customer's ROX.instance(withKey:)
        instance = ROX.instance(withKey: projectKey)

        // Set custom properties BEFORE setup - CRITICAL for target groups!
        setCustomProperties()

        // Create options - matches customer's createRoxOptions()
        let options = ROXOptions()
        options.verbose = .debug  // Enable verbose logging to see what's happening

        // Configuration fetched callback - matches customer's pattern
        options.onConfigurationFetched = { [weak self] result in
            print("✅ onConfigurationFetched called")
            print("   Result: \(result.fetcherStatus)")
            print("   HasChanges: \(result.hasChanges)")

            // Decode fetcher status
            switch result.fetcherStatus.rawValue {
            case 1:
                print("   Status: APPLIED_FROM_EMBEDDED")
            case 2:
                print("   Status: APPLIED_FROM_NETWORK")
            case 3:
                print("   Status: APPLIED_FROM_CACHE")
            case 4:
                print("   Status: ERROR_FETCH_FAILED")
            default:
                print("   Status: UNKNOWN (\(result.fetcherStatus.rawValue))")
            }

            // Test Dynamic API after configuration is fetched
            self?.testDynamicAPI()
        }

        // Setup instance - matches customer's instance?.setup()
        instance?.setup(withOptions: options)

        return true
    }

    // Matches customer's setGlobalOptions method
    func setCustomProperties() {
        guard let instance = instance else {
            print("❌ Error: instance is nil")
            return
        }

        print("🔧 Setting custom properties...")

        // Set custom properties - matches customer's implementation
        let properties: [String: String] = [
            "userTier": "premium",
            "userId": "user_12345",
            "region": "us-east"
        ]

        for (key, value) in properties {
            instance.setCustomProperty(key: key, value: value)
            print("   ✓ setting this custom property \(key) : \(value)")
        }
    }

    // Test Dynamic API - matches customer's getValue usage
    func testDynamicAPI() {
        guard let instance = instance else {
            print("❌ Error: instance is nil")
            return
        }

        print("\n🧪 Testing Dynamic API...")

        // Debug: Check if custom properties are still set
        print("   📝 Custom properties should be:")
        print("      userTier = 'premium'")
        print("      userId = 'user_12345'")
        print("      region = 'us-east'")

        // Test 1: Check if showPremiumFeature exists
        let flagValue = instance.dynamicAPI().getValue("showPremiumFeature", withDefault: "false")
        print("\n   Test 1: showPremiumFeature")
        print("   🚩 Flag 'showPremiumFeature' = '\(flagValue)'")
        print("   🎯 Expected: 'true' (with target group: userTier == 'premium')")

        // Check if target group is working (accepts "true" or "ture" - dashboard typo)
        if flagValue == "true" || flagValue == "ture" {
            print("   ✅✅✅ SUCCESS! Custom properties ARE WORKING! ✅✅✅")
            print("   📊 Target group evaluated:")
            print("      - Custom property 'userTier' = 'premium' ✓")
            print("      - Target group condition matched ✓")
            print("      - Returned target group value ✓")
            if flagValue == "ture" {
                print("   ⚠️  Note: Fix typo in dashboard ('ture' → 'true')")
            }
        } else {
            print("   ❌ FAIL: Flag not configured with target group")
        }

        // Test 2: Check existing flags (fontColor, message)
        let fontColor = instance.dynamicAPI().getValue("fontColor", withDefault: "default")
        let message = instance.dynamicAPI().getValue("message", withDefault: "default")

        print("\n   Test 2: Existing flags (verify Dynamic API works)")
        print("   🚩 fontColor = '\(fontColor)'")
        print("   🚩 message = '\(message)'")

        if fontColor != "default" || message != "default" {
            print("   ✅ Dynamic API is working correctly!")
        }

        print("\n   💡 Next Steps:")
        print("      1. Go to CloudBees dashboard: https://app.rollout.io")
        print("      2. Find flag 'showPremiumFeature'")
        print("      3. Make sure it's ACTIVE/DEPLOYED (not Stale)")
        print("      4. Add target group: userTier == \"premium\" → true")
        print("      5. Restart app to fetch new configuration")
    }
}

