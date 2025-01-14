//
//  CGSize+Math.swift
//  STCEngine
//
//  Created by Sergey on 15.01.2025.
//

import Foundation

// MARK: CGSize adapter
extension CGSize: Number2d {
    public var first: CGFloat {
        get { width }
        set { self.width = newValue }
    }
    
    public var second: CGFloat {
        get { height }
        set { self.height = newValue }
    }
    
    public static func new(_ first: CGFloat, _ second: CGFloat) -> Self {
        Self(width: first, height: second)
    }
}
