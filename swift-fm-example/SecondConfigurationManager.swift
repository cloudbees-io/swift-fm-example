import Foundation
import SwiftUI
import ROX
import ROXCore

class SecondConfigurationManager: ObservableObject {
    static var INSTANCE: SecondConfigurationManager!
    
    @Published var titleColor: String = "red"
    @Published var titleSize: Int = 20
    @Published var displayText: String = "This text is from SDK 2"
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
                    print("Config2 - Applied from local storage")
                case .appliedFromNetwork:
                    print("Config2 - Applied from network")
                case .errorFetchFailed:
                    print("Config2 - Error fetching configuration")
                case .appliedFromEmbedded:
                    print("Config2 - Applied from embedded")
                case .noUpdate:
                    print("Config2 - No update in configuration")
                @unknown default:
                    print("Config2 - Unknown status")
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
        
        // Get operations for this specific configuration
        // Use the configuration's actual name (which is auto-generated from the SDK key)
        if let operations = ROX.using(configuration.name) {
            roxOperations = operations
            
            // Set this configuration as active before performing operations
            ROXConfigurationManager.setActiveConfiguration(configuration)
            
            // Ensure all operations are performed within this configuration's context
            ROXConfigurationManager.withConfiguration(configuration) {
                // Register container with the correct namespace
                operations.register(Flags2.INSTANCE)
                
                // Set environment property
                operations.setCustomStringProperty(key: "env", value: "staging")
                operations.setCustomStringProperty(key: "version", value: "1.0.0")
                operations.setCustomStringProperty(key: "platform", value: "iOS")
                
                // Fetch configuration
                operations.fetch()
            }
            
            isConfigured = true
        }
    }
    
    func updateValues() {
        DispatchQueue.main.async {
            // Update published properties with current flag values
            self.titleColor = Flags2.INSTANCE.titleColors.value()
            self.titleSize = Int(Flags2.INSTANCE.titleSize.value())
            self.displayText = Flags2.INSTANCE.title.value()
            self.showText = Flags2.INSTANCE.showtitle.isEnabled
            
            // Print updated values for debug
            print("Config2 - title color is \(self.titleColor)")
            print("Config2 - title size is \(self.titleSize)")
            print("Config2 - Display text: \(self.displayText)")
            print("Config2 - Show text: \(self.showText)")
        }
    }
}
