import Foundation
import UIKit
import ROX
import ROXCore
import SwiftUI

class AppDelegate: UIResponder, UIApplicationDelegate, ObservableObject {
    
    // SDK keys for different environments
    let productionSDKKey = "<SDK-KEY-1>"
    let stagingSDKKey = "<SDK-KEY-2>"
    
    // ROX instances
    private var productionInstance: ROXInstance?
    private var stagingInstance: ROXInstance?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Setup ROX SDK with options
        print("AppDelegate: Setting up ROX SDK")
        
        // Set SDK keys in UI manager
        UIUpdateManager.shared.setSDKKeys(production: productionSDKKey, staging: stagingSDKKey)

        // Create and setup production instance
        print("AppDelegate: Creating production ROX instance")
        productionInstance = ROX.instance(withKey: productionSDKKey)

        // Create and setup staging instance
        print("AppDelegate: Creating staging ROX instance")
        stagingInstance = ROX.instance(withKey: stagingSDKKey)

        // Pass instances to UI manager for Dynamic API access
        UIUpdateManager.shared.setInstances(production: productionInstance, staging: stagingInstance)

        // Create options for production instance
        let productionOptions = ROXOptions()
        productionOptions.verbose = .debug
        productionOptions.onConfigurationFetched = { result in
            print("PRODUCTION onConfigurationFetched called with result: \(result.fetcherStatus)")
            print("PRODUCTION SDK Key: \(self.productionSDKKey)")
            print("PRODUCTION hasChanges: \(result.hasChanges)")

            // Update UI through UIUpdateManager
            UIUpdateManager.shared.updateProductionValues()
            UIUpdateManager.shared.updateProductionDynamicAPIValues()
        }

        // Setup production instance with options
        print("AppDelegate: Setting up production ROX instance")
        productionInstance?.setup(withOptions: productionOptions)
        
        // Create options for staging instance
        let stagingOptions = ROXOptions()
        stagingOptions.verbose = .debug
        stagingOptions.onConfigurationFetched = { result in
            print("STAGING onConfigurationFetched called with result: \(result.fetcherStatus)")
            print("STAGING SDK Key: \(self.stagingSDKKey)")
            print("STAGING hasChanges: \(result.hasChanges)")

            // Update UI through UIUpdateManager
            UIUpdateManager.shared.updateStagingValues()
            UIUpdateManager.shared.updateStagingDynamicAPIValues()
        }

        // Setup staging instance with options
        print("AppDelegate: Setting up staging ROX instance")
        stagingInstance?.setup(withOptions: stagingOptions)
        
        // Register flag containers to their respective SDK keys
        print("AppDelegate: Registering flag containers")
        registerFlagContainers()
        
        // Set custom properties for each instance
        setCustomProperties()
        
        // Fetch configurations
        print("AppDelegate: Fetching configurations")
        fetchConfigurations()
        
        return true
    }
    
    func registerFlagContainers() {
        // Register Flags1 to production instance
        print("AppDelegate: Registering Flags1 to production instance")
        productionInstance?.register(container: Flags1.INSTANCE)
        
        // Register Flags2 to staging instance
        print("AppDelegate: Registering Flags2 to staging instance")
        stagingInstance?.register("features", container: Flags2.INSTANCE)
        
        print("AppDelegate: Flag containers registered successfully")
    }
    
    /**
     # Target Groups Support - Alternative to ROXDynamicPropertyContext

     **IMPORTANT**: The CloudBees iOS SDK fully supports target groups through multiple methods,
     NOT just `setGlobalContext(ROXDynamicPropertyContext)`.

     ## Recommended Approaches for Target Groups:

     ### 1. `setCustomProperty()` - Static Values (RECOMMENDED)
     - Use this to set user/device properties that target groups can evaluate
     - Properties are directly usable in CloudBees console target group conditions
     - Example: userTier, userId, region, appVersion

     ### 2. `setCustomProperty()` - Dynamic/Computed Values
     - Use closures to compute properties dynamically at evaluation time
     - Ideal for session-based data that changes during app lifecycle
     - Example: current user role, cart value, login state

     ### 3. Instance-Specific Properties (Multi-SDK)
     - Set different properties per SDK instance
     - Useful for environment-specific targeting

     ## CloudBees Console Usage:
     Once you set properties here, create target groups in CloudBees console like:
     - `userTier == "premium"`
     - `region == "us-east"`
     - `version >= "1.0.0"`

     The SDK automatically evaluates these conditions using your custom properties.
     */
    func setCustomProperties() {
        print("AppDelegate: Setting custom properties for TARGET GROUPS")

        // ========================================
        // METHOD 1: Static Custom Properties
        // Best for: User attributes, device info, app configuration
        // Target Group Usage: Directly in CloudBees console conditions
        // ========================================

        // Production instance properties
        print("AppDelegate: Setting PRODUCTION custom properties")
        productionInstance?.setCustomProperty(key: "environment", value: "production")
        productionInstance?.setCustomProperty(key: "version", value: "1.0.0")
        productionInstance?.setCustomProperty(key: "platform", value: "iOS")

        // Example: User-specific properties for target groups
        // In CloudBees console, create target group: userTier == "premium"
        productionInstance?.setCustomProperty(key: "userTier", value: "premium")
        productionInstance?.setCustomProperty(key: "userId", value: "user_12345")
        productionInstance?.setCustomProperty(key: "region", value: "us-east")

        // Example: Boolean properties for binary conditions
        // In CloudBees console: isPremiumUser == true
        productionInstance?.setCustomProperty(key: "isPremiumUser", value: true)

        // Example: Numeric properties for range conditions
        // In CloudBees console: accountAge > 30
        productionInstance?.setCustomProperty(key: "accountAge", value: 90)

        // Staging instance properties
        print("AppDelegate: Setting STAGING custom properties")
        stagingInstance?.setCustomProperty(key: "environment", value: "staging")
        stagingInstance?.setCustomProperty(key: "version", value: "1.0.0")
        stagingInstance?.setCustomProperty(key: "platform", value: "iOS")
        stagingInstance?.setCustomProperty(key: "userTier", value: "basic")
        stagingInstance?.setCustomProperty(key: "region", value: "us-west")

        // ========================================
        // METHOD 2: Dynamic/Computed Properties (Alternative approach)
        // Uncomment to see dynamic properties in action
        // ========================================
        /*
        // These closures are evaluated every time a flag is checked
        // No need to manually update when user context changes!

        ROX.setCustomProperty(key: "currentUserId") {
            // This gets the current user ID at evaluation time
            return UserSessionManager.shared.currentUserId ?? "anonymous"
        }

        ROX.setCustomProperty(key: "currentUserRole") {
            return UserSessionManager.shared.currentRole ?? "guest"
        }

        ROX.setCustomProperty(key: "hasActiveSubscription") {
            return UserSessionManager.shared.hasSubscription
        }

        ROX.setCustomProperty(key: "cartTotal") {
            return CartManager.shared.totalValue
        }
        */

        print("AppDelegate: Custom properties configured for TARGET GROUPS")
        print("AppDelegate: These properties can now be used in CloudBees console target group conditions")
    }

    /**
     # ROXDynamicPropertyContext Usage (Optional Advanced Approach)

     This demonstrates using ROXDynamicPropertyContext for per-evaluation context.
     This is DIFFERENT from custom properties and serves different use cases:

     - Custom Properties: User/device attributes for target groups
     - Dynamic Context: Evaluation-time context for A/B tests, experiments

     Uncomment the code below to see ROXDynamicPropertyContext in action.
     */
    func setDynamicPropertyContextExample() {
        // Example 1: Global context for A/B testing
        guard let globalContext = RoxDynamicPropertyContext(values: [
            "experimentVariant": "variantA" as NSString,
            "testId": "experiment_001" as NSString,
            "sessionType": "mobile" as NSString
        ]) else {
            print("Failed to create global context")
            return
        }

        // This context will be used for all flag evaluations
        ROX.setGlobalContext(context: globalContext)

        print("Global context set for experiments")
    }

    func evaluateFlagWithContext() {
        // Example 2: Per-evaluation context (overrides global)
        guard let localContext = RoxDynamicPropertyContext(values: [
            "featureAccessLevel": NSNumber(value: 5),
            "tempOverride": "enabled" as NSString
        ]) else {
            print("Failed to create local context")
            return
        }

        // Pass context directly to flag evaluation
        if Flags1.INSTANCE.showtitle.isEnabled(localContext) {
            print("Flag enabled with local context")
        }

        // Get string value with context (use value() method)
        let title = Flags1.INSTANCE.title.value(localContext)
        print("Title with context: \(title)")
    }

    func fetchConfigurations() {
        // Fetch configuration for production instance
        print("AppDelegate: Fetching production configuration")
        productionInstance?.fetch()

        // Fetch configuration for staging instance
        print("AppDelegate: Fetching staging configuration")
        stagingInstance?.fetch()

        print("AppDelegate: Configurations fetched successfully")

        // Validate target groups after fetch
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.validateTargetGroups()
        }
    }

    func validateTargetGroups() {
        print("\n🔍 TARGET GROUP VALIDATION:")
        print("Production - showPremiumFeature: \(Flags1.INSTANCE.showPremiumFeature.isEnabled)")
        print("Staging - showPremiumFeature: \(Flags2.INSTANCE.showPremiumFeature.isEnabled)")
        print("\n")

        // Run comprehensive validation tests
        // This validates the three approaches the customer tried
        TargetGroupsValidation.validateAllApproaches(with: productionInstance)

        // Optional: Test different property types
        // Uncomment to run additional validation tests
        // TargetGroupsValidation.testDifferentPropertyTypes(with: productionInstance)
    }
}

