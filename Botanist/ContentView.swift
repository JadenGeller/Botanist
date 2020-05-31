//
//  ContentView.swift
//  Botanist
//
//  Created by Jaden Geller on 5/30/20.
//  Copyright © 2020 Jaden Geller. All rights reserved.
//

import Foundation
import SwiftUI

protocol Tree {
    var path: Path { get }
}
//extension Tree {
//    var body: TurtlePath {
//        TurtlePath { path in
//            draw(in: &path)
//        }
//    }
//}

protocol Growth {
    func length(for age: CGFloat) -> CGFloat
}
struct LinearGrowth: Growth {
    var rate: CGFloat
    
    func length(for age: CGFloat) -> CGFloat {
        rate * age
    }
}
struct ExponentialGrowth: Growth {
    var rate: CGFloat
    var scale: CGFloat = 1
    var timeConstant: CGFloat = 1
    
    func length(for age: CGFloat) -> CGFloat {
        scale * (pow(rate, age / timeConstant) - 1)
    }
}

//struct TimeShifted<GrowthRate: Growth>: Growth {
//    var growth: GrowthRate
//    var growth: GrowthRate
//
//    func length(for age: CGFloat) -> CGFloat {
//        <#code#>
//    }
//}
//extension Growth {
//    func ageShift(_ ageDelta: CGFloat) ->
//}

//extension GrowthRate {
//    static func linear(rate: CGFloat) -> GrowthRate {
//        LinearGrowth(rate: rate)
//    }
//
//    static func exponential(rate: CGFloat, scale: CGFloat = 1, timeConstant: CGFloat = 1) -> GrowthRate {
//        ExponentialGrowth(rate: rate, scale: scale, timeConstant: timeConstant)
//    }
//}

struct Stem: Tree {
    let length: CGFloat
    let subtree: Tree
    
    init(length: CGFloat, @TreeBuilder subtree: () -> Tree = { EmptyTree() }) {
        self.length = length
        self.subtree = subtree()
    }
        
    init(age: CGFloat, growth: Growth, @TreeBuilder subtree: () -> Tree = { EmptyTree() }) {
        self.length = growth.length(for: age)
        self.subtree = subtree()
    }
    
    var path: Path {
        Path { path in
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: 0, y: length))
            path.addPath(subtree.path, transform: .init(translationX: 0, y: length))
        }
    }
}

struct EmptyTree: Tree {
    var path: Path {
        Path()
    }
}

@_functionBuilder
struct TreeBuilder {
    static func buildBlock() -> EmptyTree {
        return EmptyTree()
    }
    
    public static func buildBlock(_ subtree: Tree) -> Tree {
        subtree
    }
    
    public static func buildBlock(_ subtrees: Tree...) -> [Tree] {
        subtrees
    }
    
    public static func buildIf(_ tree: Tree?) -> Tree {
        tree ?? EmptyTree()
    }
    
    public static func buildEither(first tree: Tree) -> Tree {
        tree
    }
    
    public static func buildEither(second tree: Tree) -> Tree {
        tree
    }
}


struct Branch: Tree {
    let subtrees: [Tree]
    init(@TreeBuilder subtrees: () -> [Tree]) {
        self.subtrees = subtrees()
    }
    init(@TreeBuilder subtree: () -> Tree) {
        self.subtrees = [subtree()]
    }
    
    var path: Path {
        Path { path in
            for subtree in subtrees {
                path.addPath(subtree.path)
            }
        }
    }
}

struct Rotate: Tree {
    let subtree: Tree
    let angle: Angle
    
    var path: Path {
        Path { path in
            path.addPath(subtree.path, transform: CGAffineTransform(rotationAngle: CGFloat(angle.radians)))
        }
    }
}
extension Tree {
    func rotate(_ angle: Angle) -> Tree {
        Rotate(subtree: self, angle: angle)
    }
}

//extension Stem where Bud == EmptyTree {
//    init(length: CGFloat) {
//        self.length = length
//        self.bud = EmptyTree()
//    }
//}

//struct Branch: Tree {
//    let length: CGFloat
//
//    init(length: CGFloat) {
//        self.length = length
//    }
//
//    func draw(in path: inout TurtlePath) {
//        path.draw(length: length)
//    }
//}


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
    
//        (0..<7).reduce(TurtlePath) { path, _ in
//
//        }
//        TurtlePath { path in
//            path.draw(length: 100)
//            path.turn(.degrees(20))
//            path.draw(length: 100)
//            path.turn(.degrees(20))
//            path.draw(length: 100)
//            path.turn(.degrees(20))
//            path.draw(length: 100)
//            path.turn(.degrees(20))
//            path.draw(length: 100)
//        }
//        (0..<7).reduce(Path()) { path, _ in
//            path.currentPoint
//        }.stroke(lineWidth: 5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

