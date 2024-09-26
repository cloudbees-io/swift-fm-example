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
          
          //Register the flags instance
          ROX.register(container: flags.INSTANCE)
        
            let options = ROXOptions()
            options.onConfigurationFetched = { (result: RoxFetcherResult) -> Void in
            switch result.fetcherStatus {
            case .appliedFromLocalStorage:
                print ("--- Read Configuration from local storage ---")
            case .appliedFromNetwork:
                print ("--- Read Configuration from network ---")
            default:
                print ("--- Read Configuration from other ---")
            }
            // Boolean flag example
            flags.INSTANCE.enableTutorial.enabled {
                print("enableTutorial is true")
                // TODO: Put your code here that needs to be gated
            }
            
            // String flag example
                    print("Title color is \(flags.INSTANCE.titleColors.value())")
                    
                    // Integer flag example
                    print("Title size is \(flags.INSTANCE.titleSize.value())")
                  
                    // Double flag example
                    print("Special number is \(flags.INSTANCE.specialNumber.value())")
        }

          // Setup the environment key
        ROX.setup(withKey: "66f3eecd32af1c29ced3c605", options: options)

        return true
    }
}
