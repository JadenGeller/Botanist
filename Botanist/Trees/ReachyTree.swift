//
//  ReachyTree.swift
//  Botanist
//
//  Created by Jaden Geller on 5/31/20.
//  Copyright © 2020 Jaden Geller. All rights reserved.
//

import SwiftUI

struct ReachyTree: Tree, View {
    var age: CGFloat
    
    var shoot: some Tree {
        Stem(age: age, growth: ExponentialGrowth(rate: 1.2, scale: 2)) {
            if age > 3 {
                ReachyTree(age: age - 3)
                    .rotate(.degrees(-20))
                    .scale(0.2)
            }
            Stem(age: age, growth: ExponentialGrowth(rate: 1.2, scale: 2)) {
                if age > 3 {
                    ReachyTree(age: age - 3)
                        .rotate(.degrees(-20))
                        .scale(0.4)
                    ReachyTree(age: age - 3)
                        .rotate(.degrees(20))
                        .scale(0.5)
                }
            }
        }
    }
    
    var body: some View {
        Trunk(diameter: pow(1.3, age) / 5, shoot: shoot)
    }
}
