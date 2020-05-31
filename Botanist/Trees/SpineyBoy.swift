//
//  SpineyBoy.swift
//  Botanist
//
//  Created by Jaden Geller on 5/31/20.
//  Copyright © 2020 Jaden Geller. All rights reserved.
//

import SwiftUI

// FIXME: Proxy for type inference
func _SpineyBoy<Subtree: Tree>(age: CGFloat, @TreeBuilder subtree: () -> Subtree) -> SpineyBoy<Subtree> {
    SpineyBoy(age: age) {
        subtree()
    }
}

struct SpineyBoy<Subtree: Tree>: Tree {
    var age: CGFloat
    var subtree: Subtree
    init(age: CGFloat, @TreeBuilder subtree: () -> Subtree) {
        self.age = age
        self.subtree = subtree()
    }

    var trunk: some Tree {
        TreeGroup {
            if age > 4 {
                _SpineyBoy(age: age / 2) {
                    _SpineyBoy(age: age / 2) {
                        Branch {
                            _SpineyBoy(age: age - 4) {
                                _SpineyBoy(age: age - 4) {
                                    SpineyBoy<EmptyTree>(age: age - 4)
                                        .rotate(.degrees(-22.5))
                                }.rotate(.degrees(-22.5))
                            }.rotate(.degrees(45))
                            _SpineyBoy(age: age - 4) {
                                _SpineyBoy(age: age - 4) {
                                    SpineyBoy<EmptyTree>(age: age - 4)
                                        .rotate(.degrees(22.5))
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

extension SpineyBoy where Subtree == EmptyTree {
    init(age: CGFloat) {
        self.init(age: age) {
            EmptyTree()
        }
    }
}
