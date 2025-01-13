//
//  MovementComponent.swift
//  STCEngine
//
//  Created by Sergey on 13.01.2025.
//

import STCCommon

public class MovementComponent: Component {
    public var movementSpeed: STCFloat = 0.0
    public var accelerate = false
    public var decelerate = false
    public var turnLeft = false
    public var turnRight = false
                
    public func reset() {
        accelerate = false
        decelerate = false
        turnLeft = false
        turnRight = false
    }
}
