//
//  ConfigurationManager.swift
//  swift-fm-example
//
//  Created by Ankur Vekariya on 30/09/24.
//

import Foundation
import Combine
import ROX
import ROXCore

class ConfigurationManager: ObservableObject {
    
    static let shared = ConfigurationManager() // Singleton instance
    
    @Published var enableTutorial: Bool = false
    @Published var titleColor: String = Flags.INSTANCE.titleColors.value()
    @Published var titleSize: Int32 = Flags.INSTANCE.titleSize.value()
    @Published var specialNumber: Double = Flags.INSTANCE.specialNumber.value()
    
    private var options: ROXOptions
    private static var isRegistered = false
    
    private init() {
        options = ROXOptions()
        self.registerContainer() // Register the container if not already done
        setupConfigurationFetcher()
    }
    
    private func registerContainer() {
        // Register the container only once
        if !ConfigurationManager.isRegistered {
            ROX.register(container: Flags.INSTANCE)
            ConfigurationManager.isRegistered = true // Set the flag to true
        }
    }
    
    func setupConfigurationFetcher() {
        options.onConfigurationFetched = { [weak self] (result: RoxFetcherResult) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result.fetcherStatus {
                case .appliedFromLocalStorage:
                    print("--- Read Configuration from local storage ---")
                case .appliedFromNetwork:
                    print("--- Read Configuration from network ---")
                default:
                    print("--- Read Configuration from other ---")
                }
                
                // Update the enableTutorial flag
                self.enableTutorial = Flags.INSTANCE.enableTutorial.isEnabled
                if self.enableTutorial {
                    print("enableTutorial is true")
                    // TODO: Put your code here that needs to be gated
                }
                
                // Update other flags
                self.titleColor = Flags.INSTANCE.titleColors.value()
                self.titleSize = Flags.INSTANCE.titleSize.value()
                self.specialNumber = Flags.INSTANCE.specialNumber.value()
                
                // Print updated values for debug
                print("Title color is \(self.titleColor)")
                print("Title size is \(self.titleSize)")
                print("Special number is \(self.specialNumber)")
            }
        }
        
        ROX.setup(withKey: "66f3eecd32af1c29ced3c605", options: options)
    }
    
    // Public method for testing purposes
    func fetchConfiguration(for result: RoxFetcherResult) {
        options.onConfigurationFetched?(result)
    }
    
}

