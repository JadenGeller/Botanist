//
//  CurlyTree.swift
//  Botanist
//
//  Created by Jaden Geller on 5/31/20.
//  Copyright © 2020 Jaden Geller. All rights reserved.
//

import SwiftUI

struct CurlyTree: Tree, View {
    var age: CGFloat
    
    var shoot: some Tree {
        Stem(age: age, growth: ExponentialGrowth(rate: 1.1, scale: 8)) {
            Stem(age: age, growth: ExponentialGrowth(rate: 1.1, scale: 8)) {
                if age > 2.5 {
                    CurlyTree(age: age - 2.5)
                        .rotate(.degrees(25.7))
                }
            }
            if age > 1.5 {
                CurlyTree(age: age - 1.5)
                    .rotate(.degrees(-25.7))
            }
        }.scale(0.7)
    }
    
    var body: some View {
        Trunk(diameter: pow(1.2, age) / 3, shoot: shoot)
    }
}
