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
                Section(header: Text("Production SDK - Static Flags")) {
                    if uiManager.showProductionText {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(uiManager.productionSDKKey.prefix(5))****")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text(uiManager.productionTitle)
                                .font(.system(size: CGFloat(uiManager.productionTitleSize)))
                                .foregroundColor(colorFromName(uiManager.productionTitleColor.lowercased()))
                        }
                        .padding(.vertical, 4)
                    }
                }

                // Production Dynamic API
                Section(header: Text("Production SDK - Dynamic API")) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("String:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(uiManager.productionDynamicString)
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        HStack {
                            Text("Int:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(uiManager.productionDynamicInt)")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        HStack {
                            Text("Bool:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(uiManager.productionDynamicBool ? "Enabled" : "Disabled")")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(uiManager.productionDynamicBool ? .green : .red)
                        }
                    }
                    .padding(.vertical, 4)
                }

                // Staging Configuration
                Section(header: Text("Staging SDK - Static Flags")) {
                    if uiManager.showStagingText {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(uiManager.stagingSDKKey.prefix(5))****")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text(uiManager.stagingTitle)
                                .font(.system(size: CGFloat(uiManager.stagingTitleSize)))
                                .foregroundColor(colorFromName(uiManager.stagingTitleColor.lowercased()))
                        }
                        .padding(.vertical, 4)
                    }
                }

                // Staging Dynamic API
                Section(header: Text("Staging SDK - Dynamic API")) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("String:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(uiManager.stagingDynamicString)
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        HStack {
                            Text("Int:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(uiManager.stagingDynamicInt)")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        HStack {
                            Text("Bool:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(uiManager.stagingDynamicBool ? "Enabled" : "Disabled")")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(uiManager.stagingDynamicBool ? .green : .red)
                        }
                    }
                    .padding(.vertical, 4)
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

            // Initial Dynamic API update
            uiManager.updateProductionDynamicAPIValues()
            uiManager.updateStagingDynamicAPIValues()

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
    

