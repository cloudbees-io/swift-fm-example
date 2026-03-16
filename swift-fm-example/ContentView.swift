//
//  ContentView.swift
//  swift-fm-example
//
//  Simple UI to test customer's Dynamic API implementation
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header
                VStack(alignment: .leading, spacing: 5) {
                    Text("CloudBees")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text("Customer Bug Test")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Dynamic API + Custom Properties")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding()

                // Instructions
                VStack(alignment: .leading, spacing: 10) {
                    Text("Test Instructions:")
                        .font(.headline)
                        .fontWeight(.bold)

                    Text("1. Check Xcode console for test results")
                    Text("2. Look for '🧪 Testing Dynamic API...'")
                    Text("3. Verify showPremiumFeature = true")

                    Divider()

                    Text("To reproduce bug:")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.top)

                    Text("1. Run app ONLINE with SDK-KEY-1")
                    Text("2. Stop app")
                    Text("3. Change projectKey to SDK-KEY-2")
                    Text("4. Run app OFFLINE")
                    Text("5. Check if custom properties work")
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)

                Spacer()

                Text("See Xcode Console for results")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
    

