//
//  InputSystem.swift
//  STCEngine
//
//  Created by Sergey on 14.01.2025.
//

import Foundation
import STCCommon
import STCComponents

public class InputSystem: System {
    public init() {
        //
    }
    
    public func update(entities: [STCCommon.GameEntity], deltaTime: TimeInterval) {
//        let inputState = state(remapLevelInput)
//        entities
//            .filter {
//                $0.hasComponent(of: UserInputMarker.self)
//            }
//            .forEach {
//                if let movement = $0.getComponent(of: MovementComponent.self) {
//                    movement.accelerate = inputState.isMoveForwardPressed
//                    movement.decelerate = inputState.isMoveBackwardPressed
//                    movement.turnLeft = inputState.isTurnLeftPressed
//                    movement.turnRight = inputState.isTurnRightPressed
//                }
//                if inputState.isShootPressed,
//                   let shot = $0.getComponent(of: ShotComponent.self) {
//                    shot.shotState = .requested
//                }
//            }
    }
}
