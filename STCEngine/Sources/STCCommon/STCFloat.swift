//
//  STCFloat.swift
//  STCEngine
//
//  Created by Sergey on 13.01.2025.
//

import Foundation

public typealias STCFloat = CGFloat

extension STCFloat {
    public func degreesToRadians() -> STCFloat {
        self * .pi / 180
    }
    
    public func radiansToDegrees() -> STCFloat {
        self * 180 / .pi
    }
    
    public func normalizeToPositiveRadians() -> STCFloat {
        var val = self.truncatingRemainder(dividingBy: 2.0 * .pi)
        if val < 0.0 {
            val += 2.0 * .pi
        }
        return val
    }
    
    public func signedAngleDifference(_ other: Self) -> STCFloat {
        let twoPi: STCFloat = 2.0 * .pi
        var difference = (self - other).truncatingRemainder(dividingBy: twoPi)
        if difference > .pi {
            difference -= twoPi
        } else if difference < -.pi {
            difference += twoPi
        }
        return difference
    }
    
    public func sqrt() -> STCFloat {
        Darwin.sqrt(self)
    }
    
    public func abs() -> STCFloat {
        Swift.abs(self)
    }
    
    public func min(_ other: STCFloat) -> STCFloat {
        Swift.min(self, other)
    }
    
    public func max(_ other: STCFloat) -> STCFloat {
        Swift.max(self, other)
    }
}
