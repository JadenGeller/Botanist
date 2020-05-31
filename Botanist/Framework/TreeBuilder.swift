//
//  TreeBuilder.swift
//  Botanist
//
//  Created by Jaden Geller on 5/31/20.
//  Copyright © 2020 Jaden Geller. All rights reserved.
//

@_functionBuilder
struct TreeBuilder {
    static func buildBlock() -> EmptyTree {
        return EmptyTree()
    }
    
    public static func buildBlock(_ subtree: Tree) -> Tree {
        subtree
    }
    
    public static func buildBlock(_ subtrees: Tree...) -> [Tree] {
        subtrees
    }
    
    public static func buildIf(_ tree: Tree?) -> Tree {
        tree ?? EmptyTree()
    }
    
    public static func buildEither(first tree: Tree) -> Tree {
        tree
    }
    
    public static func buildEither(second tree: Tree) -> Tree {
        tree
    }
}
