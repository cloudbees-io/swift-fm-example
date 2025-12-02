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
    
    func setCustomProperties() {
        // Set custom properties using instance-specific API
        print("AppDelegate: Setting custom properties")
        
        // Set production properties using instance method
        print("AppDelegate: Setting production custom properties")
        productionInstance?.setCustomProperty(key: "env-BBB-prod", value: "production")
        productionInstance?.setCustomProperty(key: "version", value: "1.0.0")
        productionInstance?.setCustomProperty(key: "platform", value: "iOS")
        
        // Set staging properties using instance method
        print("AppDelegate: Setting staging custom properties")
        stagingInstance?.setCustomProperty(key: "env-BBB-staging", value: "staging")
        stagingInstance?.setCustomProperty(key: "version", value: "1.0.0")
        stagingInstance?.setCustomProperty(key: "platform", value: "iOS")
        
        print("AppDelegate: Custom properties set for both instances")
    }
    
    func fetchConfigurations() {
        // Fetch configuration for production instance
        print("AppDelegate: Fetching production configuration")
        productionInstance?.fetch()
        
        // Fetch configuration for staging instance
        print("AppDelegate: Fetching staging configuration")
        stagingInstance?.fetch()
        
        print("AppDelegate: Configurations fetched successfully")
    }
}

