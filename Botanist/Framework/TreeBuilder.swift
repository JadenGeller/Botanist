//
//  TreeBuilder.swift
//  Botanist
//
//  Created by Jaden Geller on 5/31/20.
//  Copyright © 2020 Jaden Geller. All rights reserved.
//

@resultBuilder
struct TreeBuilder {
    static func buildBlock() -> Leaf {
        return Leaf()
    }
    
    public static func buildBlock<T: Tree>(_ tree: T) -> T {
        tree
    }
    
    public static func buildBlock<T0: Tree, T1: Tree>(_ t0: T0, _ t1: T1) -> Branch2<T0, T1> {
        .init(forest: (t0, t1))
    }
    
    public static func buildBlock<T0: Tree, T1: Tree, T2: Tree>(_ t0: T0, _ t1: T1, _ t2: T2) -> Branch3<T0, T1, T2> {
        .init(forest: (t0, t1, t2))
    }
    
    public static func buildBlock<T0: Tree, T1: Tree, T2: Tree, T3: Tree>(_ t0: T0, _ t1: T1, _ t2: T2, _ t3: T3) -> Branch4<T0, T1, T2, T3> {
        .init(forest: (t0, t1, t2, t3))
    }
    
    public static func buildIf<T: Tree>(_ tree: T?) -> OptionalTree<T> {
        if let tree = tree {
            return .someTree(tree)
        } else {
            return .none
        }
    }
    
    public static func buildEither<FirstTree: Tree, SecondTree: Tree>(first tree: FirstTree) -> ConditionalTree<FirstTree, SecondTree> {
        .trueTree(tree)
    }
    
    public static func buildEither<FirstTree: Tree, SecondTree: Tree>(second tree: SecondTree) -> ConditionalTree<FirstTree, SecondTree> {
        .falseTree(tree)
    }
}
