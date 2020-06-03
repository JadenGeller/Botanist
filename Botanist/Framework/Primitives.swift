//
//  Primitives.swift
//  Botanist
//
//  Created by Jaden Geller on 5/31/20.
//  Copyright © 2020 Jaden Geller. All rights reserved.
//

import SwiftUI

extension Angle {
    var orthogonal: Angle {
        self + .degrees(90)
    }
}

struct CrossSection {
    var midpoint: CGPoint
    var heading: Angle
    var radius: CGFloat
    
    var leftPoint: CGPoint {
        CGPoint(
            x: midpoint.x - radius * cos(CGFloat(heading.orthogonal.radians)),
            y: midpoint.y - radius * sin(CGFloat(heading.orthogonal.radians))
        )
    }
    
    var rightPoint: CGPoint {
        CGPoint(
            x: midpoint.x + radius * cos(CGFloat(heading.orthogonal.radians)),
            y: midpoint.y + radius * sin(CGFloat(heading.orthogonal.radians))
        )
    }
    
    func extending(by length: CGFloat) -> CrossSection {
        CrossSection(
            midpoint: CGPoint(
                x: midpoint.x + length * cos(CGFloat(heading.radians)),
                y: midpoint.y + length * sin(CGFloat(heading.radians))
            ),
            heading: heading,
            radius: radius
        )
    }
    
    func rotating(by angle: Angle) -> CrossSection {
        CrossSection(midpoint: midpoint, heading: heading + angle, radius: radius)
    }
    
    func scaling(by multiplier: CGFloat) -> CrossSection {
        CrossSection(midpoint: midpoint, heading: heading, radius: radius * multiplier)
    }
}

protocol Tree {
    associatedtype Shoot: Tree
    var shoot: Shoot { get } // FIXME: Is subtree a better name?
    func draw(in path: inout Path, from crossSection: CrossSection)
}
extension Tree {
    func draw(in path: inout Path, from crossSection: CrossSection) {
        shoot.draw(in: &path, from: crossSection)
    }
}

struct Trunk<Shoot: Tree>: Tree, Shape {
    var diameter: CGFloat
    var shoot: Shoot

    public func path(in rect: CGRect) -> Path {
        Path { path in
            let crossSection = CrossSection(
                midpoint: CGPoint(x: rect.midX, y: rect.maxY),
                heading: .degrees(-90),
                radius: diameter / 2
            )
            path.move(to: crossSection.leftPoint)
            draw(in: &path, from: crossSection)
            path.addLine(to: crossSection.rightPoint)
        }
    }
}

extension Never: Tree {
    typealias Shoot = Never
}

extension Tree where Shoot == Never {
    var shoot: Never {
        fatalError("\(Self.self) is a primitive Tree")
    }
}

struct Leaf: Tree {
    typealias Shoot = Never
    
    func draw(in path: inout Path, from crossSection: CrossSection) {
        path.addLine(to: crossSection.midpoint) // FIXME: Is this even useful?
    }
}

struct Stem<Subtree: Tree>: Tree {
    var length: CGFloat
    var subtree: Subtree
    
    init(length: CGFloat, @TreeBuilder subtree: () -> Subtree) {
        self.length = length
        self.subtree = subtree()
    }
    
    typealias Shoot = Never
    
    func draw(in path: inout Path, from crossSection: CrossSection) {
        let crossSection = crossSection.extending(by: length)
        path.addLine(to: crossSection.leftPoint)
        subtree.draw(in: &path, from: crossSection)
        path.addLine(to: crossSection.rightPoint)
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

    typealias Shoot = Never

    func draw(in path: inout Path, from crossSection: CrossSection) {
        subtree.draw(in: &path, from: crossSection.rotating(by: angle))
    }
}

// FIXME
extension Tree {
    func rotate(_ angle: Angle) -> some Tree {
        Rotate(subtree: self, angle: angle)
    }
}

private struct Scale<Subtree: Tree>: Tree {
    let subtree: Subtree
    let multiplier: CGFloat

    typealias Shoot = Never

    func draw(in path: inout Path, from crossSection: CrossSection) {
        subtree.draw(in: &path, from: crossSection.scaling(by: multiplier))
    }
}

// FIXME
extension Tree {
    func scale(_ multiplier: CGFloat) -> some Tree {
        Scale(subtree: self, multiplier: multiplier)
    }
}

struct Branch2<T0: Tree, T1: Tree>: Tree {
    var forest: (T0, T1)
    
    typealias Shoot = Never
    
    func draw(in path: inout Path, from crossSection: CrossSection) {
        forest.0.draw(in: &path, from: crossSection)
        path.addLine(to: crossSection.rightPoint)
        path.addLine(to: crossSection.leftPoint)
        forest.1.draw(in: &path, from: crossSection)
    }
}

struct Branch3<T0: Tree, T1: Tree, T2: Tree>: Tree {
    var forest: (T0, T1, T2)
    
    typealias Shoot = Never
    
    func draw(in path: inout Path, from crossSection: CrossSection) {
        forest.0.draw(in: &path, from: crossSection)
        path.addLine(to: crossSection.rightPoint)
        path.addLine(to: crossSection.leftPoint)
        forest.1.draw(in: &path, from: crossSection)
        path.addLine(to: crossSection.rightPoint)
        path.addLine(to: crossSection.leftPoint)
        forest.2.draw(in: &path, from: crossSection)
    }
}

struct Branch4<T0: Tree, T1: Tree, T2: Tree, T3: Tree>: Tree {
    var forest: (T0, T1, T2, T3)
    
    typealias Shoot = Never
    
    func draw(in path: inout Path, from crossSection: CrossSection) {
        forest.0.draw(in: &path, from: crossSection)
        path.addLine(to: crossSection.rightPoint)
        path.addLine(to: crossSection.leftPoint)
        forest.1.draw(in: &path, from: crossSection)
        path.addLine(to: crossSection.rightPoint)
        path.addLine(to: crossSection.leftPoint)
        forest.2.draw(in: &path, from: crossSection)
        path.addLine(to: crossSection.rightPoint)
        path.addLine(to: crossSection.leftPoint)
        forest.3.draw(in: &path, from: crossSection)
    }
}

enum ConditionalTree<TrueTree: Tree, FalseTree: Tree>: Tree {
    case trueTree(TrueTree)
    case falseTree(FalseTree)
    
    typealias Shoot = Never
    
    func draw(in path: inout Path, from crossSection: CrossSection) {
        switch self {
        case .trueTree(let tree):
            tree.draw(in: &path, from: crossSection)
        case .falseTree(let tree):
            tree.draw(in: &path, from: crossSection)
        }
    }
}

enum OptionalTree<SomeTree: Tree>: Tree {
    case someTree(SomeTree)
    case none
    
    typealias Shoot = Never
    
    func draw(in path: inout Path, from crossSection: CrossSection) {
        switch self {
        case .someTree(let tree):
            tree.draw(in: &path, from: crossSection)
        case .none:
            break
        }
    }
}

struct TreeGroup<Shoot: Tree>: Tree {
    var shoot: Shoot
    
    init(@TreeBuilder _ shoot: () -> Shoot) {
        self.shoot = shoot()
    }
}
