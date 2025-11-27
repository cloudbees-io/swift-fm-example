import Foundation
import SwiftUI
import ROX
import ROXCore

class UIUpdateManager: ObservableObject {
    static let shared = UIUpdateManager()
    
    // Production configuration values
    @Published var productionTitle: String = "This text is from SDK 1"
    @Published var productionTitleColor: String = "blue"
    @Published var productionTitleSize: Int = 16
    @Published var showProductionText: Bool = true
    
    // Staging configuration values
    @Published var stagingTitle: String = "This text is from SDK 2"
    @Published var stagingTitleColor: String = "red"
    @Published var stagingTitleSize: Int = 20
    @Published var showStagingText: Bool = true
    
    // SDK keys for reference in UI
    @Published var productionSDKKey: String = ""
    @Published var stagingSDKKey: String = ""

    // Dynamic API test values
    @Published var productionDynamicString: String = ""
    @Published var productionDynamicInt: Int = 0
    @Published var productionDynamicBool: Bool = false

    @Published var stagingDynamicString: String = ""
    @Published var stagingDynamicInt: Int = 0
    @Published var stagingDynamicBool: Bool = false

    // ROX instance references for Dynamic API
    private var productionInstance: ROXInstance?
    private var stagingInstance: ROXInstance?

    private init() {
        // Initialize with default values
    }
    
    func updateProductionValues() {
        DispatchQueue.main.async {
            self.productionTitle = Flags1.INSTANCE.title.value()
            self.productionTitleColor = Flags1.INSTANCE.titleColors.value()
            self.productionTitleSize = Int(Flags1.INSTANCE.titleSize.value())
            self.showProductionText = Flags1.INSTANCE.showtitle.isEnabled
            
            print("Production UI updated: \(self.productionTitle)")
            print("Production color: \(self.productionTitleColor)")
            print("Production size: \(self.productionTitleSize)")
        }
    }
    
    func updateStagingValues() {
        DispatchQueue.main.async {
            self.stagingTitle = Flags2.INSTANCE.title.value()
            self.stagingTitleColor = Flags2.INSTANCE.titleColors.value()
            self.stagingTitleSize = Int(Flags2.INSTANCE.titleSize.value())
            self.showStagingText = Flags2.INSTANCE.showtitle.isEnabled
            
            print("Staging UI updated: \(self.stagingTitle)")
            print("Staging color: \(self.stagingTitleColor)")
            print("Staging size: \(self.stagingTitleSize)")
        }
    }

    func setSDKKeys(production: String, staging: String) {
        self.productionSDKKey = production
        self.stagingSDKKey = staging
    }

    func setInstances(production: ROXInstance?, staging: ROXInstance?) {
        self.productionInstance = production
        self.stagingInstance = staging
    }

    func updateProductionDynamicAPIValues() {
        DispatchQueue.main.async {
            guard let instance = self.productionInstance else {
                print("Production instance not available for Dynamic API")
                return
            }

            // Test Dynamic API with production instance (no namespace)
            let dynamicAPI = instance.dynamicAPI()

            self.productionDynamicString = dynamicAPI.getValue("dynamic_test_string", withDefault: "Default Dynamic String (Prod)")
            self.productionDynamicInt = Int(dynamicAPI.getInt("dynamic_test_int", withDefault: 100))
            self.productionDynamicBool = dynamicAPI.isEnabled("dynamic_test_flag", withDefault: false)

            print("Production Dynamic API (Instance-based) - String: \(self.productionDynamicString)")
            print("Production Dynamic API (Instance-based) - Int: \(self.productionDynamicInt)")
            print("Production Dynamic API (Instance-based) - Bool: \(self.productionDynamicBool)")
        }
    }

    func updateStagingDynamicAPIValues() {
        DispatchQueue.main.async {
            guard let instance = self.stagingInstance else {
                print("Staging instance not available for Dynamic API")
                return
            }

            // Test Dynamic API with staging instance (with 'features' namespace)
            let dynamicAPI = instance.dynamicAPI()

            self.stagingDynamicString = dynamicAPI.getValue("features.dynamic_test_string", withDefault: "Default Dynamic String (Staging)")
            self.stagingDynamicInt = Int(dynamicAPI.getInt("features.dynamic_test_int", withDefault: 200))
            self.stagingDynamicBool = dynamicAPI.isEnabled("features.dynamic_test_flag", withDefault: false)

            print("Staging Dynamic API (Instance-based) - String: \(self.stagingDynamicString)")
            print("Staging Dynamic API (Instance-based) - Int: \(self.stagingDynamicInt)")
            print("Staging Dynamic API (Instance-based) - Bool: \(self.stagingDynamicBool)")
        }
    }
}
