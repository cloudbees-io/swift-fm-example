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
    @StateObject private var uiManager = UIUpdateManager.shared
    
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
                
                // Production Configuration
                if uiManager.showProductionText {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(uiManager.productionSDKKey.prefix(5))****")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(uiManager.productionTitle)
                            .font(.system(size: CGFloat(uiManager.productionTitleSize)))
                            .foregroundColor(colorFromName(uiManager.productionTitleColor.lowercased()))
                    }
                    .padding()
                }
                
                // Staging Configuration
                if uiManager.showStagingText {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(uiManager.stagingSDKKey.prefix(5))****")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(uiManager.stagingTitle)
                            .font(.system(size: CGFloat(uiManager.stagingTitleSize)))
                            .foregroundColor(colorFromName(uiManager.stagingTitleColor.lowercased()))
                    }
                    .padding()
                }
                }
                
                Spacer()
            }
            .padding()

        }
        .onAppear {
            // Initial UI update
            uiManager.updateProductionValues()
            uiManager.updateStagingValues()
            
            print("Multi-SDK Demo: UI manager initialized")
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
    

