//
//  CGPoint+Math.swift
//  STCEngine
//
//  Created by Sergey on 14.01.2025.
//

import Foundation

// MARK: CGPoint adapter
extension CGPoint: Number2d {
    public var first: CGFloat {
        get { x }
        set { self.x = newValue }
    }
    
    public var second: CGFloat {
        get { y }
        set { self.y = newValue }
    }
    
    public static func new(_ first: CGFloat, _ second: CGFloat) -> Self {
        Self(x: first, y: second)
    }
}

// MARK: Geometry
extension CGPoint {
    public func size(_ other: Self) -> CGSize {
        let val = self - other
        return CGSize(
            width: Swift.abs(val.x),
            height: Swift.abs(val.y)
        )
    }
}

// MARK: typecast
extension CGPoint {
    public var vectorValue: CGVector {
        CGVector(dx: x, dy: y)
    }
}
