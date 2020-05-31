//
//  CurlyBoy.swift
//  Botanist
//
//  Created by Jaden Geller on 5/31/20.
//  Copyright © 2020 Jaden Geller. All rights reserved.
//

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
