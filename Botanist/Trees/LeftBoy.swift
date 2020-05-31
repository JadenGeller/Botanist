//
//  LeftBoy.swift
//  Botanist
//
//  Created by Jaden Geller on 5/31/20.
//  Copyright © 2020 Jaden Geller. All rights reserved.
//

import SwiftUI

struct LeftBoy: Tree {
    var age: CGFloat
    
    var trunk: some Tree {
        Stem(age: age, growth: ExponentialGrowth(rate: 1.3, scale: 10)) {
            Branch {
                if age > 1 {
                    LeftBoy(age: age - 1)
                        .rotate(.degrees(-20))
                }
                Stem(age: age, growth: ExponentialGrowth(rate: 1.3, scale: 10)) {
                    if age > 1 {
                        Branch {
                            LeftBoy(age: age - 1)
                                .rotate(.degrees(-20))
                            LeftBoy(age: age - 1)
                                .rotate(.degrees(20))
                        }
                    }
                }
            }
        }
    }
}
