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
    func draw(in path: inout Path, from position: CGPoint, with heading: Angle)
}
extension Tree {
    func draw(in path: inout Path, from position: CGPoint, with heading: Angle) {
        trunk.draw(in: &path, from: position, with: heading)
    }
}
extension Tree {
    public func path(in rect: CGRect) -> Path {
        Path { path in
            let startingPoint = CGPoint(x: rect.midX, y: rect.maxY)
            path.move(to: startingPoint)
            draw(in: &path, from: startingPoint, with: .degrees(-90))
        }
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

struct Leaf: Tree {
    typealias Trunk = Never
    
    func draw(in path: inout Path, from position: CGPoint, with heading: Angle) {
        path.addLine(to: position)
    }
}

struct Stem<Subtree: Tree>: Tree {
    var length: CGFloat
    var width: CGFloat = 0
    var angle: Angle = .zero
    var subtree: Subtree
    
    init(length: CGFloat, @TreeBuilder subtree: () -> Subtree) {
        self.length = length
        self.subtree = subtree()
    }
    
    typealias Trunk = Never
    
    func draw(in path: inout Path, from position: CGPoint, with heading: Angle) {
        let orthogonal = heading + .degrees(90)
        path.addLine(to: CGPoint(
            x: position.x - width * cos(CGFloat(orthogonal.radians)),
            y: position.y - width * sin(CGFloat(orthogonal.radians))
        ))
        subtree.draw(in: &path, from: CGPoint(
            x: position.x + length * cos(CGFloat(heading.radians)),
            y: position.y + length * sin(CGFloat(heading.radians))
        ), with: heading)
        path.addLine(to: CGPoint(
            x: position.x + width * cos(CGFloat(orthogonal.radians)),
            y: position.y + width * sin(CGFloat(orthogonal.radians))
        ))
    }
}
extension Stem {
    func width(_ width: CGFloat) -> Stem {
        var copy = self
        copy.width = width
        return copy
    }
}

extension Stem where Subtree == Leaf {
    init(length: CGFloat) {
        self.init(length: length) {
            Leaf()
        }
    }

}

private struct Rotate<Subtree: Tree>: Tree {
    let subtree: Subtree
    let angle: Angle

    typealias Trunk = Never

    func draw(in path: inout Path, from position: CGPoint, with heading: Angle) {
        subtree.draw(in: &path, from: position, with: heading + angle)
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
    
    func draw(in path: inout Path, from position: CGPoint, with heading: Angle) {
        forest.0.draw(in: &path, from: position, with: heading)
        forest.1.draw(in: &path, from: position, with: heading)
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
    
    func draw(in path: inout Path, from position: CGPoint, with heading: Angle) {
        forest.0.draw(in: &path, from: position, with: heading)
        forest.1.draw(in: &path, from: position, with: heading)
        forest.2.draw(in: &path, from: position, with: heading)
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
    
    func draw(in path: inout Path, from position: CGPoint, with heading: Angle) {
        forest.0.draw(in: &path, from: position, with: heading)
        forest.1.draw(in: &path, from: position, with: heading)
        forest.2.draw(in: &path, from: position, with: heading)
        forest.3.draw(in: &path, from: position, with: heading)
    }
}
func Branch<T0: Tree, T1: Tree, T2: Tree, T3: Tree>(@TreeBuilder _ branch: () -> Branch4<T0, T1, T2, T3>) -> some Tree {
    branch()
}

enum ConditionalTree<TrueTree: Tree, FalseTree: Tree>: Tree {
    case trueTree(TrueTree)
    case falseTree(FalseTree)
    
    typealias Trunk = Never
    
    func draw(in path: inout Path, from position: CGPoint, with heading: Angle) {
        switch self {
        case .trueTree(let tree):
            tree.draw(in: &path, from: position, with: heading)
        case .falseTree(let tree):
            tree.draw(in: &path, from: position, with: heading)
        }
    }
}

enum OptionalTree<SomeTree: Tree>: Tree {
    case someTree(SomeTree)
    case none
    
    typealias Trunk = Never
    
    func draw(in path: inout Path, from position: CGPoint, with heading: Angle) {
        switch self {
        case .someTree(let tree):
            tree.draw(in: &path, from: position, with: heading)
        case .none:
            break
        }
    }
}

struct TreeGroup<Trunk: Tree>: Tree {
    var trunk: Trunk
    
    init(@TreeBuilder _ trunk: () -> Trunk) {
        self.trunk = trunk()
    }
}
