//
//  PhysicSystem.swift
//  STCEngine
//
//  Created by Sergey on 15.01.2025.
//

import SpriteKit
import STCCommon
import STCComponents

@MainActor
public class PhysicSystem: Collider {
    private static let explodeNodeName = "Explode"
    
    nonisolated public init() { }
    
    @MainActor
    public func onContact(entityA: STCCommon.GameEntity, entityB: STCCommon.GameEntity) {
        guard let typeA = Body.from(entity: entityA),
              let typeB = Body.from(entity: entityB) else {
            return
        }
        switch (typeA, typeB) {
        case (.tank, .tank):
            collide(tankA: entityA, tankB: entityB)
        case (.tank, .projectile):
            collide(tank: entityA, projectile: entityB)
        case (.projectile, .tank):
            collide(tank: entityB, projectile: entityA)
        case (.tank, .obstacle):
            obstacleCollide(tank: entityA)
        case (.obstacle, .tank):
            obstacleCollide(tank: entityB)
        case (.projectile, .projectile):
            collide(projectileA: entityA, projectileB: entityB)
        case (.projectile, .obstacle):
            obstacleCollide(projectile: entityA)
        case (.obstacle, .projectile):
            obstacleCollide(projectile: entityB)
        default:
            break
        }
    }
    
    private func collide(tankA: GameEntity, tankB: GameEntity) {
        // collision of 2 tanks
        slowDownTank(tankA)
        slowDownTank(tankB)
    }
    
    private func collide(tank: GameEntity, projectile: GameEntity) {
        // collision tank with projectile
        fatalError("Uncomment code here")
//        if let component = tank.getComponent(of: HealthComponent.self),
//           let sprite = projectile as? Projectile {
//            component.health = max(0.0, component.health - sprite.config.damage)
//            if component.health == 0.0 {
//                explodeTank(tank)
//            }
//        }
//        explodeProjectile(projectile)
    }
    
    private func obstacleCollide(tank: GameEntity) {
        // collision tank with obstacle
        slowDownTank(tank)
    }
    
    private func obstacleCollide(projectile: GameEntity) {
        // collision projectile with obstacle
        explodeProjectile(projectile)
    }
    
    private func collide(projectileA: GameEntity, projectileB: GameEntity) {
        // collision of 2 projectiles
        explodeProjectile(projectileA) {
            projectileB.removeFromParent()
        }
    }
    
    private func explodeProjectile(_ projectile: GameEntity, completion: @escaping () -> Void = {}) {
        if let node = SKEmitterNode(fileNamed: Self.explodeNodeName) {
            node.zPosition = 1000
            projectile.addChild(node)
        }
        let actions = [
            SKAction.wait(forDuration: 0.05),
            SKAction.removeFromParent()
        ]
        projectile.run(.sequence(actions), completion: completion)
    }
    
    private func explodeTank(_ tank: GameEntity) {
        tank.physicsBody = nil
        if let node = SKEmitterNode(fileNamed: Self.explodeNodeName) {
            node.zPosition = 1000
            tank.addChild(node)
        }
        let time = 0.6
        let disappearActions = [
            SKAction.wait(forDuration: time),
            SKAction.removeFromParent()
        ]
        let actions = SKAction.group([
            .sequence(disappearActions),
            .fadeOut(withDuration: time)
        ])
        tank.run(actions)
    }
    
    private func slowDownTank(_ tank: GameEntity) {
        guard let component = tank.getComponent(of: MovementComponent.self) else {
            return
        }
        component.movementSpeed *= 0.5
    }
}

fileprivate enum Body {
    case tank, obstacle, projectile
    
    @MainActor
    static func from(entity: GameEntity) -> Body? {
        if isTank(entity) {
            return .tank
        }
        if isObstacle(entity) {
            return .obstacle
        }
        if isProjectile(entity) {
            return .projectile
        }
        return nil
    }
}

@MainActor
fileprivate func isTank(_ entity: GameEntity) -> Bool {
    entity.hasComponent(of: PlayerMarker.self) || entity.hasComponent(of: NpcMarker.self)
}

@MainActor
fileprivate func isObstacle(_ entity: GameEntity) -> Bool {
    entity.hasComponent(of: ObstacleMarker.self)
}

@MainActor
fileprivate func isProjectile(_ entity: GameEntity) -> Bool {
    entity.hasComponent(of: ProjectileMarker.self)
}
