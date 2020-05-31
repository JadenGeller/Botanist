//
//  CurlyBoy.swift
//  Botanist
//
//  Created by Jaden Geller on 5/31/20.
//  Copyright © 2020 Jaden Geller. All rights reserved.
//

import SwiftUI

struct CurlyBoy<Subtree: Tree>: Tree {
    var age: CGFloat
    var subtree: Subtree
    
    init(age: CGFloat, @TreeBuilder subtree: () -> Subtree) {
        self.age = age
        self.subtree = subtree()
    }
    
    var trunk: some Tree {
        Stem(age: age, growth: ExponentialGrowth(rate: 1.1)) {
            Branch {
                Stem(age: age, growth: ExponentialGrowth(rate: 1.1)) {
                    if age > 3 {
                        CurlyBoy<EmptyTree>(age: age - 3)
                            .rotate(.degrees(25.7))
                    }
                }
                if age > 2.5 {
                    CurlyBoy<EmptyTree>(age: age - 2.5)
                        .rotate(.degrees(-25.7))
                }
            }
        }
    }
}

extension CurlyBoy where Subtree == EmptyTree {
    init(age: CGFloat) {
        self.init(age: age) {
            EmptyTree()
        }
    }
}
