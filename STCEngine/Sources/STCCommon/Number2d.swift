//
//  Number2d.swift
//  STCEngine
//
//  Created by Sergey on 14.01.2025.
//

import Foundation

public protocol Number2d {
    var first: CGFloat { get set }
    var second: CGFloat { get set }
    
    static func new(_ first: CGFloat, _ second: CGFloat) -> Self
}

extension Number2d {
    public static func +(lhs: Self, rhs: Self) -> Self {
        .new(
            lhs.first + rhs.first,
            lhs.second + rhs.second
        )
    }
    
    public static func -(lhs: Self, rhs: Self) -> Self {
        .new(
            lhs.first - rhs.first,
            lhs.second - rhs.second
        )
    }
    
    public static func *(lhs: Self, scalar: CGFloat) -> Self {
        .new(
            lhs.first * scalar,
            lhs.second * scalar
        )
    }
    
    public static func *(lhs: Self, rhs: Self) -> Self {
        .new(
            lhs.first * rhs.first,
            lhs.second * rhs.second
        )
    }
    
    public static func /(lhs: Self, scalar: CGFloat) -> Self {
        .new(
            lhs.first / scalar,
            lhs.second / scalar
        )
    }
    
    public static prefix func -(val: Self) -> Self {
        .new(
            -val.first,
            -val.second
        )
    }
}

public func +=<T: Number2d>(lhs: inout T, rhs: T) {
    lhs = lhs + rhs
}

public func -=<T: Number2d>(lhs: inout T, rhs: T) {
    lhs = lhs - rhs
}

public func *=<T: Number2d>(lhs: inout T, scalar: CGFloat) {
    lhs = lhs * scalar
}

public func /=<T: Number2d>(lhs: inout T, scalar: CGFloat) {
    lhs = lhs / scalar
}

extension Number2d {
    public func squaredDistance(to other: Self) -> CGFloat {
        (self - other).squaredDistance()
    }
    
    public func squaredDistance() -> CGFloat {
        self.first.sqr() + self.second.sqr()
    }
    
    public func atan2() -> CGFloat {
        Darwin.atan2(second, first)
    }
}
