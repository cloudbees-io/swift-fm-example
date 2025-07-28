//
//  ContentView.swift
//  swift-fm-example
//
//  Created by Ankur Vekariya on 25/09/24.
//

import SwiftUI
import ROX
import ROXCore

enum titleColor: String {
    case white = "White"
    case blue = "Blue"
    case green = "Green"
    case yellow = "Yellow"
}

struct ContentView: View {
    @StateObject private var configurationManager = ConfigurationManager.INSTANCE
    @StateObject private var secondConfigurationManager = SecondConfigurationManager.INSTANCE
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                // Header
                VStack(alignment: .leading, spacing: -5) {
                    Text("CloudBees")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text("Feature Management")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Multi-SDK Demo")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom)
                
                // Multi-SDK Configuration List
                List {
                
                // First Configuration (Named)
                if let config = configurationManager.roxConfiguration, configurationManager.showText {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(config.sdkKey.prefix(5))****")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(configurationManager.displayText)
                            .font(.system(size: CGFloat(configurationManager.titleSize)))
                            .foregroundColor(colorFromName(configurationManager.titleColor.lowercased()))
                    }
                    .padding()
                }
                
                // Second Configuration (Auto-generated)
                if let config = secondConfigurationManager.roxConfiguration, secondConfigurationManager.showText {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(config.sdkKey.prefix(5))****")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(secondConfigurationManager.displayText)
                            .font(.system(size: CGFloat(secondConfigurationManager.titleSize)))
                            .foregroundColor(colorFromName(secondConfigurationManager.titleColor.lowercased()))
                    }
                    .padding()
                }
                }
                
                Spacer()
            }
            .padding()

        }
        .onAppear {
            // Setup both configurations for multi-SDK demo
            configurationManager.setupConfigurationFetcher()
            secondConfigurationManager.setupConfigurationFetcher()
            
            print("Multi-SDK Demo: Configuration fetchers initialized")
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
    

