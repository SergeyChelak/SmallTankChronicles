//
//  NpcSystem.swift
//  STCEngine
//
//  Created by Sergey on 14.01.2025.
//

import Foundation
import STCCommon
import STCComponents

public class NpcSystem: System {
    private let angleStep: CGFloat
    private let halfFOV: CGFloat
    private let rayLength: CGFloat
    private let squareAttackDistance: CGFloat
    
    public init(
        fieldOfView: CGFloat,
        rayLength: CGFloat,
        raysCount: Int,
        attackDistance: CGFloat
    ) {
        self.halfFOV = fieldOfView * 0.5
        self.rayLength = rayLength
        self.angleStep = fieldOfView / CGFloat(raysCount)
        self.squareAttackDistance = attackDistance.sqr()
    }
    
    @MainActor
    public func update(sceneContext: any STCCommon.SceneContext) {
        for entity in sceneContext.entities {
            guard entity.hasComponent(of: NpcMarker.self) else {
                continue
            }
            let entities = detectEntities(entity, sceneContext: sceneContext)
            updateState(npc: entity, visibleEntities: entities)
        }
    }
    
    @MainActor
    private func detectEntities(
        _ entity: GameEntity,
        sceneContext: any STCCommon.SceneContext
    ) -> [GameEntity] {
        let angle = entity.angle
        return stride(
            from: angle - halfFOV,
            to: angle + halfFOV,
            by: angleStep
        )
        .compactMap {
            sceneContext.vision(
                entity.position,
                rayLength: rayLength,
                angle: $0
            )
        }
        .flatMap { $0 }
        .unique()
    }
    
    @MainActor
    private func updateState(npc: GameEntity, visibleEntities: [GameEntity]) {
        var player: GameEntity?
        var obstacles: [GameEntity] = []
        var borders: [GameEntity] = []
        for entity in visibleEntities {
            if entity.hasComponent(of: PlayerMarker.self) {
                player = entity
                continue
            }
            if entity.hasComponent(of: BorderMarker.self) {
                borders.append(entity)
                continue
            }
            let threshold = (1.5 * max(npc.size.height, npc.size.width)).sqr()
            let squareDistance = npc.position.squaredDistance(to: entity.position)
            if squareDistance < threshold {
                obstacles.append(entity)
            }
        }
        if let player {
            attack(player: player, by: npc)
            return
        }
        move(for: npc, from: obstacles, borders: borders)
    }
    
    @MainActor
    private func attack(player: GameEntity, by entity: GameEntity) {
        guard let comp = entity.getComponent(of: MovementComponent.self),
              let shotComponent = entity.getComponent(of: ShotComponent.self) else {
            return
        }
        let entityAngle = entity.angle
        let angle = (player.position - entity.position).atan2()
        let diff = entityAngle.signedAngleDifference(angle)
        guard abs(diff) < 2e-1 else {
            if diff > 0 {
                comp.turnRight = true
            } else {
                comp.turnLeft = true
            }
            return
        }
        let squareDistance = player.position.squaredDistance(to: entity.position)
        if squareDistance > squareAttackDistance {
            comp.accelerate = true
        } else {
            comp.movementSpeed *= 0.9
        }
        shotComponent.shotState = .requested
    }
        
    @MainActor
    private func move(for entity: GameEntity, from obstacles: [GameEntity], borders: [GameEntity]) {
        guard let comp = entity.getComponent(of: MovementComponent.self),
              let maxSpeed = entity.getComponent(of: MaxSpeedComponent.self) else {
            return
        }
        // check for edges
        let dist = 1.5 * entity.size.width.max(entity.size.height)
        let pos = entity.position
        for edge in borders {
            let left = pos.x - edge.position.x - edge.size.width < dist
            let right = -pos.x + edge.position.x < dist
            let bottom = pos.y - edge.position.y - edge.size.height < dist
            let top = -pos.y + edge.position.y < dist
            
            if left || right {
                comp.turnRight = true
                comp.movementSpeed = 0
                return
            }
            
            if top || bottom {
                comp.turnLeft = true
                comp.movementSpeed = 0
                return
            }
        }
        // move slowly in patrol mode
        if obstacles.isEmpty {
            comp.movementSpeed = 0.2 * maxSpeed.value
            return
        }
        // turn to avoid obstacles
        let point = obstacles
            .map { $0.position - entity.position }
            .reduce(.zero) { acc, point in
                acc + point
            }
        let angle = .pi + point.atan2()
        let entityAngle = entity.angle
        let diff = entityAngle.signedAngleDifference(angle)
        if abs(diff) < 2e-1 {
            comp.movementSpeed = 0.2 * maxSpeed.value
            return
        }
        if diff > 0 {
            comp.turnRight = true
        } else {
            comp.turnLeft = true
        }
//        comp.movementSpeed = -0.2 * comp.maxSpeed
    }
}


extension GameEntity {
    var angle: STCFloat {
        let phase = getComponent(of: PhaseComponent.self)?.phase ?? 0.0
        return (phase + self.zRotation).normalizeToPositiveRadians()
    }
}
