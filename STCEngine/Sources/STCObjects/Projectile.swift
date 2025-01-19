//
//  Projectile.swift
//  STCEngine
//
//  Created by Sergey on 19.01.2025.
//

import SpriteKit

public enum ProjectileAppearance {
    case sniper
    case light
    case medium
    case heavy
    case plasma
    
    var imageNamed: String {
        switch self {
        case .sniper:
            return "Sniper_Shell"
        case .light:
            return "Light_Shell"
        case .medium:
            return "Medium_Shell"
        case .heavy:
            return "Heavy_Shell"
        case .plasma:
            return "Plasma"
        }
    }
}

public class Projectile: SKSpriteNode {
    let appearance: ProjectileAppearance
    
    public init(config: ProjectileAppearance) {
        self.appearance = config
        super.init(texture: nil, color: .clear, size: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupChildren()
        setupPhysics()
    }
    
    private func setupChildren() {
        let node = SKSpriteNode(imageNamed: appearance.imageNamed)
        self.size = node.size
        addChild(node)
    }
    
    private func setupPhysics() {
        let physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 60))
        physicsBody.affectedByGravity = false
        physicsBody.isDynamic = true
        physicsBody.allowsRotation = false
        physicsBody.setObjectCategory(.projectile)
        // collide with everything
        physicsBody.contactTestBitMask = UInt32.max
        self.physicsBody = physicsBody

    }
}
