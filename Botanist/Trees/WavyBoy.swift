//
//  WavyBoy.swift
//  Botanist
//
//  Created by Jaden Geller on 5/31/20.
//  Copyright © 2020 Jaden Geller. All rights reserved.
//

import SwiftUI

// FIXME: Proxy for type inference
func _WavyBoy<Subtree: Tree>(age: CGFloat, @TreeBuilder subtree: () -> Subtree) -> WavyBoy<Subtree> {
    WavyBoy(age: age) {
        subtree()
    }
}

struct WavyBoy<Subtree: Tree>: Tree {
    var age: CGFloat
    var subtree: Subtree
    init(age: CGFloat, @TreeBuilder subtree: () -> Subtree) {
        self.age = age
        self.subtree = subtree()
    }

    var trunk: some Tree {
        TreeGroup {
            if age > 2 {
                _WavyBoy(age: age / 2) {
                    _WavyBoy(age: age / 2) {
                        Branch {
                            _WavyBoy(age: age - 2) {
                                _WavyBoy(age: age - 2) {
                                    WavyBoy<EmptyTree>(age: age - 2)
                                        .rotate(.degrees(-22.5))
                                }.rotate(.degrees(-22.5))
                            }.rotate(.degrees(45))
                            _WavyBoy(age: age - 2) {
                                _WavyBoy(age: age - 2) {
                                    WavyBoy<EmptyTree>(age: age - 2)
                                        .rotate(.degrees(22.5))
                                }.rotate(.degrees(22.5))
                            }.rotate(.degrees(-22.5))
                            subtree
                        }
                    }
                }
            } else {
                Stem(age: age, growth: LinearGrowth(rate: 5)) {
                    subtree
                }
            }
        }
    }
}

extension WavyBoy where Subtree == EmptyTree {
    init(age: CGFloat) {
        self.init(age: age) {
            EmptyTree()
        }
    }
}
