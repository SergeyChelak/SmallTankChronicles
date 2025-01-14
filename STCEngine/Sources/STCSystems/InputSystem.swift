//
//  InputSystem.swift
//  STCEngine
//
//  Created by Sergey on 14.01.2025.
//

import Foundation
import STCCommon
import STCComponents

public protocol InputSystemDataSource {
    func getState() -> UserInputState
}

public struct UserInputState {
    // tank
    public var isMoveForwardPressed = false
    public var isMoveBackwardPressed = false
    public var isTurnLeftPressed = false
    public var isTurnRightPressed = false
    // cannon
    public var isShootPressed = false
    
    public init() { }
}

public class InputSystem: System {
    let dataSource: InputSystemDataSource
    
    public init(dataSource: InputSystemDataSource) {
        self.dataSource = dataSource
    }
    
    public func update(entities: [STCCommon.GameEntity], deltaTime: TimeInterval) {
        let inputState = dataSource.getState()
        entities
            .filter {
                $0.hasComponent(of: UserInputMarker.self)
            }
            .forEach {
                if let movement = $0.getComponent(of: MovementComponent.self) {
                    movement.accelerate = inputState.isMoveForwardPressed
                    movement.decelerate = inputState.isMoveBackwardPressed
                    movement.turnLeft = inputState.isTurnLeftPressed
                    movement.turnRight = inputState.isTurnRightPressed
                }
                if inputState.isShootPressed,
                   let shot = $0.getComponent(of: ShotComponent.self) {
                    shot.shotState = .requested
                }
            }
    }
}
