//
//  WavyBoy.swift
//  Botanist
//
//  Created by Jaden Geller on 5/31/20.
//  Copyright © 2020 Jaden Geller. All rights reserved.
//

import SwiftUI

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
