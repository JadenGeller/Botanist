//
//  SpineyTree.swift
//  Botanist
//
//  Created by Jaden Geller on 5/31/20.
//  Copyright © 2020 Jaden Geller. All rights reserved.
//

import SwiftUI

// FIXME: Proxy for type inference
func _SpineyTree<Subtree: Tree>(age: CGFloat, @TreeBuilder subtree: () -> Subtree) -> SpineyTree<Subtree> {
    SpineyTree(age: age) {
        subtree()
    }
}

struct SpineyTree<Subtree: Tree>: Tree, View {
    var age: CGFloat
    var subtree: Subtree
    init(age: CGFloat, @TreeBuilder subtree: () -> Subtree) {
        self.age = age
        self.subtree = subtree()
    }

    var shoot: some Tree {
        TreeGroup {
            if age > 4 {
                _SpineyTree(age: age / 2) {
                    _SpineyTree(age: age / 2) {
                        _SpineyTree(age: age - 4) {
                            _SpineyTree(age: age - 4) {
                                _SpineyTree(age: age - 4) {
                                    Leaf()
                                }.rotate(.degrees(-22.5)).scale(0.7)
                            }.rotate(.degrees(-22.5)).scale(0.7)
                        }.rotate(.degrees(45)).scale(0.7)
                        _SpineyTree(age: age - 4) {
                            _SpineyTree(age: age - 4) {
                                _SpineyTree(age: age - 4) {
                                    Leaf()
                                }.rotate(.degrees(22.5)).scale(0.7)
                            }.rotate(.degrees(22.5)).scale(0.7)
                        }.rotate(.degrees(-22.5)).scale(0.7)
                        subtree
                    }
                }
            } else {
                Stem(age: age, growth: LinearGrowth(rate: 2)) {
                    subtree
                }
            }
        }
    }
    
    var body: some View {
        Trunk(diameter: age, shoot: shoot)
    }
}
