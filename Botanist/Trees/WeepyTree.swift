//
//  WeepyTree.swift
//  Botanist
//
//  Created by Jaden Geller on 6/2/20.
//  Copyright © 2020 Jaden Geller. All rights reserved.
//

import SwiftUI

struct WeepyTree: Tree, View {
    var age: CGFloat
    
    var shoot: some Tree {
        TreeGeometryReader { geometry in
            Stem(age: self.age, growth: ExponentialGrowth(rate: 1.1, scale: 8)) {
                if self.age > 1.4 && geometry.heading < .degrees(90) + .degrees(Double(self.age)) {
                    WeepyTree(age: self.age - 1.4)
                        .rotate(.degrees(-10))
                    WeepyTree(age: self.age - 1.4)
                        .rotate(.degrees(25))
                }
            }.scale(0.7)
        }
    }
    
    var body: some View {
        Trunk(diameter: pow(1.3, age) / 5, shoot: shoot)
    }
}
