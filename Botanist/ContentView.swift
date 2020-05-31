//
//  ContentView.swift
//  Botanist
//
//  Created by Jaden Geller on 5/30/20.
//  Copyright © 2020 Jaden Geller. All rights reserved.
//

import Foundation
import SwiftUI

struct CurlyBoy: Tree {
    var age: CGFloat
    var subtree: Tree
    init(age: CGFloat, @TreeBuilder subtree: () -> Tree = { EmptyTree() }) {
        self.age = age
        self.subtree = subtree()
    }
    
    var path: Path {
        Stem(age: age, growth: ExponentialGrowth(rate: 1.1)) {
            Branch {
                Stem(age: age, growth: ExponentialGrowth(rate: 1.1)) {
                    if age > 3 {
                        CurlyBoy(age: age - 3)
                            .rotate(.degrees(25.7))
                    }
                }
                if age > 2.5 {
                    CurlyBoy(age: age - 2.5)
                        .rotate(.degrees(-25.7))
                }
            }
        }.path
    }
}

struct WavyBoy: Tree {
    var age: CGFloat
    var subtree: Tree
    init(age: CGFloat, @TreeBuilder subtree: () -> Tree = { EmptyTree() }) {
        self.age = age
        self.subtree = subtree()
    }

    var path: Path {
        if age > 2 {
            return WavyBoy(age: age / 2) {
                WavyBoy(age: age / 2) {
                    Branch {
                        WavyBoy(age: age - 2) {
                            WavyBoy(age: age - 2) {
                                WavyBoy(age: age - 2)
                                    .rotate(.degrees(-22.5))
                            }.rotate(.degrees(-22.5))
                        }.rotate(.degrees(45))
                        WavyBoy(age: age - 2) {
                            WavyBoy(age: age - 2) {
                                WavyBoy(age: age - 2)
                                    .rotate(.degrees(22.5))
                            }.rotate(.degrees(22.5))
                        }.rotate(.degrees(-22.5))
                        subtree
                    }
                }
            }.path
        } else {
            return Stem(age: age, growth: LinearGrowth(rate: 5)) {
                subtree
            }.path
        }
    }
}

struct LeftBoy: Tree {
    var age: CGFloat

    var path: Path {
        Stem(age: age, growth: ExponentialGrowth(rate: 1.3, scale: 10)) {
            Branch {
                if age > 1 {
                    LeftBoy(age: age - 1)
                        .rotate(.degrees(-20))
                }
                Stem(age: age, growth: ExponentialGrowth(rate: 1.3, scale: 10)) {
                    if age > 1 {
                        Branch {
                            LeftBoy(age: age - 1)
                                .rotate(.degrees(-20))
                            LeftBoy(age: age - 1)
                                .rotate(.degrees(20))
                        }
                    }
                }
            }
        }.path
    }
}

struct ContentView: View {
    @State var age: CGFloat = 0
    
    var body: some View {
        VStack {
            WavyBoy(age: age).path
            .stroke(lineWidth: 1)
            .offset(x: 150)
            .frame(width: 300, height: 300)
            .background(Color.gray.opacity(0.1))
            
            Slider(value: $age, in: 0...20) {
                EmptyView()
            }.labelsHidden().padding()
            Text("Age: \(age, specifier: "%.1f")")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

