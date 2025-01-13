//
//  CGVector+Math.swift
//  STCEngine
//
//  Created by Sergey on 14.01.2025.
//

import Foundation

extension CGVector: Number2d {
    public var first: CGFloat {
        get {
            dx
        }
        set {
            self.dx = newValue
        }
    }
    
    public var second: CGFloat {
        get {
            dy
        }
        set {
            self.dy = newValue
        }
    }
    
    public static func new(_ first: CGFloat, _ second: CGFloat) -> CGVector {
        Self(dx: first, dy: second)
    }
}

extension CGVector {
    public var pointValue: CGPoint {
        CGPoint(x: dx, y: dy)
    }
    
    public func norm() -> CGFloat {
        sqrt(dx * dx + dy * dy)
    }
    
    public func normalized() -> Self {
        let norm = self.norm()
        return CGVector(dx: dx / norm, dy: dy / norm)
    }
    
    public static func rotation(_ radians: CGFloat) -> CGVector {
        CGVector(dx: cos(radians), dy: sin(radians))
    }
}
