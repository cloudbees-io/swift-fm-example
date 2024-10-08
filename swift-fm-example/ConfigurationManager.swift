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
    
    @Published var showMessage: Bool = false
    @Published var fontColor: String = Flags.INSTANCE.fontColor.value()
    @Published var fontSize: Int32 = Flags.INSTANCE.fontSize.value()
    @Published var message: String = Flags.INSTANCE.message.value()
    @Published var specialNumber: Double = Flags.INSTANCE.specialNumber.value()
    
    private var options: ROXOptions
    static var isRegistered = false
    
    private init() {
        options = ROXOptions()
        self.registerContainer() // Register the container if not already done
        setupConfigurationFetcher()
    }
    
    private func registerContainer() {
        // Register the container only once
        if !ConfigurationManager.isRegistered {
            print("--- register container ---")
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
                self.showMessage = Flags.INSTANCE.showMessage.isEnabled
                if self.showMessage {
                    print("enableTutorial is true")
                    // TODO: Put your code here that needs to be gated
                }
                
                // Update other flags
                self.message = Flags.INSTANCE.message.value()
                self.fontColor = Flags.INSTANCE.fontColor.value()
                self.fontSize = Flags.INSTANCE.fontSize.value()
                self.specialNumber = Flags.INSTANCE.specialNumber.value()
                
                // Print updated values for debug
                print("Message color is \(self.fontColor)")
                print("Message font size is \(self.fontSize)")
                print("Special number is \(self.specialNumber)")
            }
        }
        
        ROX.setup(withKey: "<Your Cloudbees Environment API Key>", options: options)
    }
    
    // Public method for testing purposes
    func fetchConfiguration(for result: RoxFetcherResult) {
        options.onConfigurationFetched?(result)
    }
    
}

