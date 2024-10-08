//
//  flags.swift
//  swift-fm-example
//
//  Created by Ankur Vekariya on 25/09/24.
//


import ROX
import ROXCore

public class Flags : RoxContainer {
    // Define the feature flags
    let showMessage = RoxFlag()

    let fontColor = RoxString(withDefault: "Green",
      variations: ["Red", "Blue", "Green", "Yellow"])
    
    let message = RoxString(withDefault: "This is default message; try changing some flag values!")
      
    let fontSize = RoxInt(withDefault: 12, variations: [14, 18])
    
    let specialNumber = RoxDouble(withDefault: 3.14, variations: [2.71, 0.577])
   
    static let INSTANCE = Flags()
}
