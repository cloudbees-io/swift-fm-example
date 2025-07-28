//
//  AppDelegate.swift
//  swift-fm-example
//
//  Created by Ankur Vekariya on 25/09/24.
//

import UIKit
import ROX
import ROXCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Initialize Multi-SDK ROX configurations
        do {
            // Create options with appropriate logging levels
            let prodOptions = ROXOptions()
//            prodOptions.verbose = .debug // Enable debug to see fetch events
            
            let stagingOptions = ROXOptions()
//            stagingOptions.verbose = .debug // Enable debug to see fetch events
            
            // Create two configurations for multi-SDK demo
            let prodConfig = try ROXConfigurationManager.add(key: "da0d45ee-6daf-4583-9c05-d8ce36b5103a")
            let stagingConfig = try ROXConfigurationManager.add(key: "db241ffa-bf9d-4c94-8169-5a686c2b5958")
            
            print("Multi-SDK Demo: Created configurations:")
            print("- Production: name='\(prodConfig.name)', SDK key='\(prodConfig.sdkKey)'")
            print("- Staging: name='\(stagingConfig.name)', SDK key='\(stagingConfig.sdkKey)'")
            
            // Initialize configuration managers with configurations and options
            ConfigurationManager.INSTANCE = ConfigurationManager(configuration: prodConfig, options: prodOptions)
            SecondConfigurationManager.INSTANCE = SecondConfigurationManager(configuration: stagingConfig, options: stagingOptions)
            
            print("Multi-SDK Demo: Configuration managers initialized")
            
        } catch {
            print("Multi-SDK Demo: Error initializing ROX configurations: \(error)")
        }
        
        return true
    }
}
