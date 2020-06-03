//
//  CurlyTree.swift
//  Botanist
//
//  Created by Jaden Geller on 5/31/20.
//  Copyright © 2020 Jaden Geller. All rights reserved.
//

import SwiftUI

struct CurlyTree: Tree {
    var age: CGFloat
    
    var shoot: some Tree {
        Stem(age: age, growth: ExponentialGrowth(rate: 1.1, scale: 8)) {
            Stem(age: age, growth: ExponentialGrowth(rate: 1.1, scale: 8)) {
                if age > 2.5 {
                    CurlyTree(age: age - 2.5)
                        .rotate(.degrees(25.7))
                }
            }.scale(0.7)
            if age > 1.5 {
                CurlyTree(age: age - 1.5)
                    .rotate(.degrees(-25.7))
            }
        }.scale(0.7)
    }
}
