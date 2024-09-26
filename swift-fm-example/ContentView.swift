//
//  ContentView.swift
//  swift-fm-example
//
//  Created by Ankur Vekariya on 25/09/24.
//

import SwiftUI

enum TitleColor: String {
    case white = "White"
    case blue = "Blue"
    case green = "Green"
    case yellow = "Yellow"
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear{
            flags.INSTANCE.enableTutorial.enabled {
              // TODO: Put your code here that needs to be gated
            }
            
            print("color == \(flags.INSTANCE.titleColors)")
//            switch flags.INSTANCE.titleColors {
//              case "White":
//                print("Title color is White")
//              case "Blue":
//                print("Title color is Blue")
//              case "Green":
//                print("Title color is Green")
//              case "Yellow":
//                print("Title color is Yellow")
//              default:
//                print("Title color is default - White")
//            }
            
         }
    }

}

#Preview {
    ContentView()
}
