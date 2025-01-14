//
//  MovementSystem.swift
//  STCEngine
//
//  Created by Sergey on 14.01.2025.
//

import STCCommon
import STCComponents
import SpriteKit

public class MovementSystem: System {
    public init() { }
    
    @MainActor
    public func update(
        entities: [STCCommon.GameEntity],
        deltaTime: TimeInterval,
        commandService: any STCCommon.CommandService
    ) {
        entities.forEach {
            update(entity: $0, deltaTime: deltaTime)
        }
    }
    
    @MainActor
    func update(entity: GameEntity, deltaTime: TimeInterval) {
        guard let comp = entity.getComponent(of: MovementComponent.self),
              let rotationSpeedComponent = entity.getComponent(of: RotationSpeedComponent.self),
              let accelerateComp = entity.getComponent(of: AccelerationComponent.self) else {
            return
        }
        let maxSpeed = entity.getComponent(of: MaxSpeedComponent.self)?.value ?? STCFloat.infinity
        comp.updateSpeed(acceleration: accelerateComp.value, maxSpeed: maxSpeed)
        
        let rotation = comp.turnDirection * rotationSpeedComponent.value * deltaTime
        let initialPhase = entity.getComponent(of: PhaseComponent.self)?.phase ?? 0.0
        let angle = initialPhase + entity.zRotation + rotation
        let vector: CGVector = .rotation(angle) * comp.movementSpeed * deltaTime
        
        let actions: SKAction = .group([
            .move(by: vector, duration: deltaTime),
            .rotate(byAngle: rotation, duration: deltaTime)
        ])
        entity.run(actions)
        // required!
        comp.reset()
        
        // TODO: maybe there is a better place
//        if let tank = entity as? Tank {
//            tank.setTrackAnimated(comp.movementSpeed != 0.0)
//        }
    }
}

fileprivate extension MovementComponent {
    var turnDirection: STCFloat {
        if turnLeft {
            return 1
        }
        if turnRight {
            return -1
        }
        return 0
    }
    
    func updateSpeed(acceleration: STCFloat, maxSpeed: STCFloat) {
        if accelerate {
            movementSpeed = min(movementSpeed + acceleration, maxSpeed)
        }
        if decelerate {
            movementSpeed = max(movementSpeed - acceleration, -maxSpeed)
        }
    }
}
