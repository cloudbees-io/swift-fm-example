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
    @State private var displayText: String = "This is default message; try changing some flag values!"

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
            
            VStack {
                if configurationManager.showMessage {
                    Text(configurationManager.message)
                        .font(.system(size: CGFloat(configurationManager.fontSize)))
                        .foregroundColor(colorFromName(configurationManager.fontColor.lowercased()))
                        .padding()
                }
            }
            
            Spacer()
            Text("Sign in to the CloudBees platform to modify flag values and see the changes reflacted automatically in this application.")
                .font(.system(size: 14.0))
                .foregroundColor(.gray)
                .padding()
            
            Image("CB-stacked-logo-full-color")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .shadow(radius: 5)
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

