//
//  ConfigurationManager.swift
//  swift-fm-example
//
//  Created by Ankur Vekariya on 30/09/24.
//

import Foundation
import SwiftUI
import ROX
import ROXCore

class ConfigurationManager: ObservableObject {
    static var INSTANCE: ConfigurationManager!
    
    @Published var titleColor: String = "blue"
    @Published var titleSize: Int = 16
    @Published var displayText: String = "This text is from SDK 1"
    @Published var showText: Bool = true
    
    // Make configuration accessible to allow proper context switching from outside
    var roxConfiguration: ROXConfiguration?
    private var isConfigured: Bool = false
    private var roxOperations: ROXOperations?
    
    private init() {
        // Initialize with default values
        updateValues()
    }
    
    init(configuration: ROXConfiguration, options: ROXOptions) {
        self.roxConfiguration = configuration
        
        // Set up configuration fetched handler
        options.onConfigurationFetched = { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result.fetcherStatus {
                case .appliedFromLocalStorage:
                    print("Config1 - Applied from local storage")
                case .appliedFromNetwork:
                    print("Config1 - Applied from network")
                case .errorFetchFailed:
                    print("Config1 - Error fetching configuration")
                case .appliedFromEmbedded:
                    print("Config1 - Applied from embedded")
                case .noUpdate:
                    print("Config1 - No update in configuration")
                @unknown default:
                    print("Config1 - Unknown status")
                }
                
                // Update flag values
                self.updateValues()
            }
        }
        
        // Set up configuration with options
        configuration.setup(options: options)
        
        // Then register container and set up fetcher
        setupConfigurationFetcher()
        updateValues()
    }
    
    func setupConfigurationFetcher() {
        guard !isConfigured, let configuration = roxConfiguration else { return }
        
        // Get operations for this specific configuration using the actual configuration name
        if let operations = ROX.using(configuration.name) {
            roxOperations = operations
            
            // IMPORTANT: Set the active configuration to production before performing operations
            // This ensures the correct SDK key context is used for API calls
            ROXConfigurationManager.setActiveConfiguration(configuration)
            
            // Register container with the correct namespace
            // This will use the withConfiguration method to ensure proper context switching
            ROXConfigurationManager.withConfiguration(configuration) {
                operations.register(Flags1.INSTANCE)
                
                // Set environment property
                operations.setCustomStringProperty(key: "env", value: "production")
                operations.setCustomStringProperty(key: "version", value: "1.0.0")
                operations.setCustomStringProperty(key: "platform", value: "iOS")
                
                // Fetch configuration
                operations.fetch()
            }
            
            print("Production configuration setup complete with SDK key: \(configuration.sdkKey)")
            isConfigured = true
        } else {
            print("Failed to get operations for production configuration")
        }
    }
    
    func updateValues() {
        DispatchQueue.main.async {
            // Log the current SDK key context when reading flag values
            let currentSDKKey = UserDefaults.standard.string(forKey: "ROX_CURRENT_SDK_KEY") ?? "none"
            print("ConfigurationManager1: updateValues - Current SDK key: \(currentSDKKey)")
            
            // Update published properties with current flag values
            self.titleColor = Flags1.INSTANCE.titleColors.value()
            let titleSizeValue = Flags1.INSTANCE.titleSize.value()
            self.titleSize = Int(titleSizeValue)
            self.displayText = Flags1.INSTANCE.title.value()
            self.showText = Flags1.INSTANCE.showtitle.isEnabled
            
            // Print updated values for debug with detailed information
            print("Config1 - SDK Key: \(currentSDKKey)")
            print("Config1 - title color is \(self.titleColor)")
            print("Config1 - title size raw value: \(titleSizeValue), converted: \(self.titleSize)")
            print("Config1 - Display text: \(self.displayText)")
            print("Config1 - Show text: \(self.showText)")
            
        }
    }
}
