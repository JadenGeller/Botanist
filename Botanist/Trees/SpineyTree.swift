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

struct SpineyTree<Subtree: Tree>: Tree {
    var age: CGFloat
    var subtree: Subtree
    init(age: CGFloat, @TreeBuilder subtree: () -> Subtree) {
        self.age = age
        self.subtree = subtree()
    }

    var trunk: some Tree {
        TreeGroup {
            if age > 4 {
                _SpineyTree(age: age / 2) {
                    _SpineyTree(age: age / 2) {
                        Branch {
                            _SpineyTree(age: age - 4) {
                                _SpineyTree(age: age - 4) {
                                    _SpineyTree(age: age - 4) {
                                        Leaf()
                                    }.rotate(.degrees(-22.5))
                                }.rotate(.degrees(-22.5))
                            }.rotate(.degrees(45))
                            _SpineyTree(age: age - 4) {
                                _SpineyTree(age: age - 4) {
                                    _SpineyTree(age: age - 4) {
                                        Leaf()
                                    }.rotate(.degrees(22.5))
                                }.rotate(.degrees(22.5))
                            }.rotate(.degrees(-22.5))
                            subtree
                        }
                    }
                }
            } else {
                Stem(age: age, growth: LinearGrowth(rate: 2)) {
                    subtree
                }
            }
        }
    }
}
