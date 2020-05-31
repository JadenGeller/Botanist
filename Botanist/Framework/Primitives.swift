//
//  Primitives.swift
//  Botanist
//
//  Created by Jaden Geller on 5/31/20.
//  Copyright © 2020 Jaden Geller. All rights reserved.
//

import SwiftUI

protocol Tree {
    var path: Path { get }
}

struct EmptyTree: Tree {
    var path: Path {
        Path()
    }
}

struct Stem: Tree {
    let length: CGFloat
    let subtree: Tree
    
    init(length: CGFloat, @TreeBuilder subtree: () -> Tree = { EmptyTree() }) {
        self.length = length
        self.subtree = subtree()
    }
    
    var path: Path {
        Path { path in
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: 0, y: length))
            path.addPath(subtree.path, transform: .init(translationX: 0, y: length))
        }
    }
}

private struct Rotate: Tree {
    let subtree: Tree
    let angle: Angle
    
    var path: Path {
        Path { path in
            path.addPath(subtree.path, transform: CGAffineTransform(rotationAngle: CGFloat(angle.radians)))
        }
    }
}
extension Tree {
    func rotate(_ angle: Angle) -> Tree {
        Rotate(subtree: self, angle: angle)
    }
}

struct Branch: Tree {
    let subtrees: [Tree]
    init(@TreeBuilder subtrees: () -> [Tree]) {
        self.subtrees = subtrees()
    }
    init(@TreeBuilder subtree: () -> Tree) {
        self.subtrees = [subtree()]
    }
    
    var path: Path {
        Path { path in
            for subtree in subtrees {
                path.addPath(subtree.path)
            }
        }
    }
}
