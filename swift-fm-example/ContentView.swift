//
//  ContentView.swift
//  swift-fm-example
//
//  Created by Ankur Vekariya on 25/09/24.
//

import SwiftUI
import ROX
import ROXCore

enum TitleColor: String {
    case white = "White"
    case blue = "Blue"
    case green = "Green"
    case yellow = "Yellow"
}

struct ContentView: View {
    @StateObject private var configurationManager = ConfigurationManager.shared

    var body: some View {
        VStack(spacing: 20) {
            
            VStack(alignment: .leading, spacing: -5) {
                Text("CloudBees")
                    .font(.subheadline)
                    .fontWeight(.bold)
                Text("Feature Management")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            // Title color text
            HStack {
                Text("Title color is: ")
                    .foregroundColor(Color(.black))
                Text("\(configurationManager.titleColor)")
                    .foregroundColor(colorFromName(configurationManager.titleColor.lowercased()))
                    .font(.headline)
            }
           
            
            // Title size text
            Text("Title size is \(configurationManager.titleSize)")
                .font(.system(size: CGFloat(configurationManager.titleSize)))
            
            // Special number text
            Text("Special number is \(configurationManager.specialNumber)")
                .font(.body)

            // Enable tutorial toggle
            HStack {
                Text("Enable Tutorial")
                Toggle("", isOn: $configurationManager.enableTutorial)
                    .labelsHidden() // Hides the default label of the toggle
            }
            .padding() // Optional: Add padding around the HStack
            
            Spacer()
        }
        .padding()
        .onAppear {
            // You might want to trigger the fetching of configuration here
            configurationManager.setupConfigurationFetcher() // Assuming there's a method to fetch configuration
        }
    }
    
    
    func colorFromName(_ name: String) -> Color {
        switch name {
        case "red":
            return .red
        case "green":
            return .green
        case "blue":
            return .blue
        case "yellow":
            return .yellow
        case "black":
            return .black
        case "white":
            return .white
        default:
            return .gray // Fallback color
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

