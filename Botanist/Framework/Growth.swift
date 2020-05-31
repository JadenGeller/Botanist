//
//  Stem.swift
//  Botanist
//
//  Created by Jaden Geller on 5/31/20.
//  Copyright © 2020 Jaden Geller. All rights reserved.
//

import SwiftUI

protocol Growth {
    func length(for age: CGFloat) -> CGFloat
}
struct LinearGrowth: Growth {
    var rate: CGFloat
    
    func length(for age: CGFloat) -> CGFloat {
        rate * age
    }
}
struct ExponentialGrowth: Growth {
    var rate: CGFloat
    var scale: CGFloat = 1
    var timeConstant: CGFloat = 1
    
    func length(for age: CGFloat) -> CGFloat {
        scale * (pow(rate, age / timeConstant) - 1)
    }
}

extension Stem {
    init(age: CGFloat, growth: Growth, @TreeBuilder subtree: () -> Subtree) {
        self.length = growth.length(for: age)
        self.subtree = subtree()
    }
}

extension Stem where Subtree == EmptyTree {
    init(age: CGFloat, growth: Growth) {
        self.init(age: age, growth: growth) {
            EmptyTree()
        }
    }
}
