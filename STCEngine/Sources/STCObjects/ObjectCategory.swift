//
//  ObjectCategory.swift
//  STCEngine
//
//  Created by Sergey on 15.01.2025.
//

import Foundation
import SpriteKit

enum ObjectCategory: Int {
    case tank = 0
    case border
    case projectile
    case mutableObstacle
    case immutableObstacle
    
    var categoryBitMask: UInt32 {
        1 << self.rawValue
    }
}

extension SKPhysicsBody {
    func setObjectCategory(_ category: ObjectCategory) {
        self.categoryBitMask = category.categoryBitMask
    }
}
