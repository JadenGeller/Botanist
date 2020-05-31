//
//  ContentView.swift
//  Botanist
//
//  Created by Jaden Geller on 5/30/20.
//  Copyright © 2020 Jaden Geller. All rights reserved.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @State var age: CGFloat = 0
    @State var treeType: String = "Curly"
    
    var body: some View {
        VStack {
            TreeGroup {
                if treeType == "Curly" {
                    CurlyBoy(age: age)
                } else if treeType == "Wavy" {
                    WavyBoy(age: age)
                } else if treeType == "Left" {
                    LeftBoy(age: age)
                } else {
                    EmptyTree()
                }
            }
            .stroke(lineWidth: 1)
            .frame(width: 300, height: 300)
            .background(Color.gray.opacity(0.1))
            
            Slider(value: $age, in: 0...20) {
                EmptyView()
            }.labelsHidden().padding()
            Text("Age: \(age, specifier: "%.1f")")
            
            Picker(selection: $treeType, label: EmptyView()) {
                Text("Curly").tag("Curly")
                Text("Wavy").tag("Wavy")
                Text("Left").tag("Left")
            }.labelsHidden()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

