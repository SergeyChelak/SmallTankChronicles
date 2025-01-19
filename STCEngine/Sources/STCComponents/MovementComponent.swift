//
//  MovementComponent.swift
//  STCEngine
//
//  Created by Sergey on 13.01.2025.
//

import STCCommon
import CoreGraphics

public class MovementComponent: Component {
    public var movementSpeed: STCFloat = 0.0
    public var accelerate = false
    public var decelerate = false
    public var turnLeft = false
    public var turnRight = false
    
    public init(
        movementSpeed: STCFloat = 0.0,
        accelerate: Bool = false,
        decelerate: Bool = false,
        turnLeft: Bool = false,
        turnRight: Bool = false
    ) {
        self.movementSpeed = movementSpeed
        self.accelerate = accelerate
        self.decelerate = decelerate
        self.turnLeft = turnLeft
        self.turnRight = turnRight
    }
                
    public func reset() {
        accelerate = false
        decelerate = false
        turnLeft = false
        turnRight = false
    }
}
