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
}
