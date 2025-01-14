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

// MARK: other
extension SKNode {
    public func setScale(xScale: CGFloat, yScale: CGFloat) {
        self.xScale = xScale
        self.yScale = yScale
    }
}

// MARK: ...
public func textures(from atlasName: String) -> [SKTexture] {
    let atlas = SKTextureAtlas(named: atlasName)
    return atlas
        .textureNames
        .map { atlas.textureNamed($0) }
}

