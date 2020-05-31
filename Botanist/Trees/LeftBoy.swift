//
//  ReachyBoy.swift
//  Botanist
//
//  Created by Jaden Geller on 5/31/20.
//  Copyright © 2020 Jaden Geller. All rights reserved.
//

import SwiftUI

struct ReachyBoy: Tree {
    var age: CGFloat
    
    var trunk: some Tree {
        Stem(age: age, growth: ExponentialGrowth(rate: 1.2, scale: 2)) {
            Branch {
                if age > 3 {
                    ReachyBoy(age: age - 3)
                        .rotate(.degrees(-20))
                }
                Stem(age: age, growth: ExponentialGrowth(rate: 1.2, scale: 2)) {
                    if age > 3 {
                        Branch {
                            ReachyBoy(age: age - 3)
                                .rotate(.degrees(-20))
                            ReachyBoy(age: age - 3)
                                .rotate(.degrees(20))
                        }
                    }
                }
            }
        }
    }
}
