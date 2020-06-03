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
            Group {
                if treeType == "Curly" {
                    CurlyTree(age: age)
                } else if treeType == "Spiney" {
                    SpineyTree(age: age) {
                        Leaf()
                    }
                } else if treeType == "Reachy" {
                    ReachyTree(age: age)
                } else if treeType == "Weepy" {
                    WeepyTree(age: age)
                } else {
                    EmptyView()
                }
            }
            .frame(width: 300, height: 300)
            .background(Color.gray.opacity(0.1))
            
            Slider(value: $age, in: 0...20) {
                EmptyView()
            }.labelsHidden().padding()
            Text("Age: \(age, specifier: "%.1f")")
            
            Picker(selection: $treeType, label: EmptyView()) {
                Text("Curly").tag("Curly")
                Text("Spiney").tag("Spiney")
                Text("Reachy").tag("Reachy")
                Text("Weepy").tag("Weepy")
            }.labelsHidden()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

