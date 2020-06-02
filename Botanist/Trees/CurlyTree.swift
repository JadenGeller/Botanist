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
    
    var trunk: some Tree {
        Stem(age: age, growth: ExponentialGrowth(rate: 1.1, scale: 8)) {
            Branch {
                Stem(age: age, growth: ExponentialGrowth(rate: 1.1, scale: 8)) {
                    if age > 2.5 {
                        CurlyTree(age: age - 2.5)
                            .rotate(.degrees(25.7))
                    }
                }.width(ExponentialGrowth(rate: 1.1, scale: 1.3).length(for: age))
                if age > 1.5 {
                    CurlyTree(age: age - 1.5)
                        .rotate(.degrees(-25.7))
                }
            }
        }.width(ExponentialGrowth(rate: 1.1, scale: 1.3).length(for: age))
    }
}
