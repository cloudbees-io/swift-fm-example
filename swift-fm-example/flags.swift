//
//  flags.swift
//  swift-fm-example
//
//  Created by Ankur Vekariya on 25/09/24.
//


import ROX
import ROXCore

public class flags : RoxContainer {
  // Define the feature flags
  let enableTutorial = RoxFlag()
    // Using a simple singleton pattern
    // a single instance should be used and injected to using classes and unit tests
//  let titleColors = RoxString(withDefault: "White", variations: ["White", "Blue", "Green", "Yellow"])
    
    let titleColors = RoxString(withDefault: "White",
      variations: ["White", "Blue", "Green", "Yellow"])
      
    let titleSize = RoxInt(withDefault: 12, variations: [14, 18])
    
    let specialNumber = RoxDouble(withDefault: 3.14, variations: [2.71, 0.577])
   
    static let INSTANCE = flags()
}
