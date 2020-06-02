//
//  Primitives.swift
//  Botanist
//
//  Created by Jaden Geller on 5/31/20.
//  Copyright © 2020 Jaden Geller. All rights reserved.
//

import SwiftUI

protocol Tree: Shape {
    associatedtype Trunk: Tree
    var trunk: Trunk { get }
}
extension Tree {
    public func path(in rect: CGRect) -> Path {
        trunk.path(in: rect)
    }
}

extension Never: Tree {
    typealias Trunk = Never
}

extension Tree where Trunk == Never {
    var trunk: Never {
        fatalError("\(Self.self) is a primitive Tree")
    }
}

struct EmptyTree: Tree {
    typealias Trunk = Never

    func path(in rect: CGRect) -> Path {
        Path()
    }
}

struct Stem<Subtree: Tree>: Tree {
    var length: CGFloat
    var width: CGFloat = 0
    var subtree: Subtree
    
    init(length: CGFloat, @TreeBuilder subtree: () -> Subtree) {
        self.length = length
        self.subtree = subtree()
    }
    
    typealias Trunk = Never
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX - width / 2, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX - width / 2, y: rect.maxY - length))
            path.addLine(to: CGPoint(x: rect.midX + width / 2, y: rect.maxY - length))
            path.addLine(to: CGPoint(x: rect.midX + width / 2, y: rect.maxY))
            path.addPath(subtree.path(in: rect), transform: .init(translationX: 0, y: -length))
        }
    }
}
extension Stem {
    func width(_ width: CGFloat) -> Stem {
        var copy = self
        copy.width = width
        return copy
    }
}

extension Stem where Subtree == EmptyTree {
    init(length: CGFloat) {
        self.init(length: length) {
            EmptyTree()
        }
    }

}

private struct Rotate<Subtree: Tree>: Tree {
    let subtree: Subtree
    let angle: Angle

    typealias Trunk = Never

    func path(in rect: CGRect) -> Path {
        subtree.rotation(angle, anchor: .bottom).path(in: rect)
    }
}

// FIXME
extension Tree {
    func rotate(_ angle: Angle) -> some Tree {
        Rotate(subtree: self, angle: angle)
    }
}

struct Branch2<T0: Tree, T1: Tree>: Tree {
    var forest: (T0, T1)
    
    typealias Trunk = Never
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addPath(forest.0.path(in: rect))
            path.addPath(forest.1.path(in: rect))
        }
    }
}
func Branch<T0: Tree, T1: Tree>(@TreeBuilder _ branch: () -> Branch2<T0, T1>) -> some Tree {
    branch()
}

struct Branch3<T0: Tree, T1: Tree, T2: Tree>: Tree {
    var forest: (T0, T1, T2)
    
//    init(@TreeBuilder _ branch: () -> Branch3) {
//        self = branch()
//    }
    
    typealias Trunk = Never
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addPath(forest.0.path(in: rect))
            path.addPath(forest.1.path(in: rect))
            path.addPath(forest.2.path(in: rect))
        }
    }
}
func Branch<T0: Tree, T1: Tree, T2: Tree>(@TreeBuilder _ branch: () -> Branch3<T0, T1, T2>) -> some Tree {
    branch()
}

struct Branch4<T0: Tree, T1: Tree, T2: Tree, T3: Tree>: Tree {
    var forest: (T0, T1, T2, T3)
    
//    init(@TreeBuilder _ branch: () -> Branch4) {
//        self = branch()
//    }
    
    typealias Trunk = Never
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addPath(forest.0.path(in: rect))
            path.addPath(forest.1.path(in: rect))
            path.addPath(forest.2.path(in: rect))
            path.addPath(forest.3.path(in: rect))
        }
    }
}
func Branch<T0: Tree, T1: Tree, T2: Tree, T3: Tree>(@TreeBuilder _ branch: () -> Branch4<T0, T1, T2, T3>) -> some Tree {
    branch()
}

enum ConditionalTree<TrueTree: Tree, FalseTree: Tree>: Tree {
    case trueTree(TrueTree)
    case falseTree(FalseTree)
    
    typealias Trunk = Never
    
    func path(in rect: CGRect) -> Path {
        switch self {
        case .trueTree(let tree):
            return tree.path(in: rect)
        case .falseTree(let tree):
            return tree.path(in: rect)
        }
    }
}

struct TreeGroup<Trunk: Tree>: Tree {
    var trunk: Trunk
    
    init(@TreeBuilder _ trunk: () -> Trunk) {
        self.trunk = trunk()
    }
}
