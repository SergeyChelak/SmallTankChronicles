//
//  SKNode+Utils.swift
//  STCEngine
//
//  Created by Sergey on 15.01.2025.
//

import SpriteKit

// MARK: nested nodes
extension SKNode {
    public func addChildren(_ nodes: SKNode...) {
        nodes.forEach { addChild($0) }
    }
    
    public func addChildren(_ nodes: [SKNode]) {
        nodes.forEach { addChild($0) }
    }
}
