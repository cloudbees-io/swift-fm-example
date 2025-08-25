//
//  flags.swift
//  swift-fm-example
//
//  Created by Ankur Vekariya on 25/09/24.
//


import Foundation
import ROX
import ROXCore

public class Flags1 : RoxContainer {
    // Define the feature flags
    let titleColors = RoxString(withDefault: "Blue",
      variations: ["White", "Blue", "Green", "Yellow", "red"])
      
    let titleSize = RoxInt(withDefault: 12, variations: [14, 18])
    
    // New flags for demo
    let title = RoxString(withDefault: "This text is from SDK 1", 
      variations: ["SDK 1 text updated", "Hello from SDK 1", "This text is from SDK 1"])
    
    let showtitle = RoxFlag(withDefault: true)
   
    static let INSTANCE = Flags1()
}

public class Flags2 : RoxContainer {
    // Define the feature flags
    let titleColors = RoxString(withDefault: "Yellow",
      variations: ["White", "Blue", "Green", "Yellow", "red"])
      
    let titleSize = RoxInt(withDefault: 12, variations: [14, 18])
    
    // New flags for demo
    let title = RoxString(withDefault: "This text is from SDK 2", 
      variations: ["SDK 2 text updated", "Hello from SDK 2", "This text is from SDK 2"])
    
    let showtitle = RoxFlag(withDefault: true)
   
    static let INSTANCE = Flags2()
}


