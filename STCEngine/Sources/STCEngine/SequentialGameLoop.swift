//
//  SequentialGameLoop.swift
//  STCEngine
//
//  Created by Sergey on 13.01.2025.
//

import Foundation
import STCCommon

enum GameState {
    case run, win, lose
}

public class SequentialGameLoop {
    private var previousTime: TimeInterval?
    private var state: GameState = .run
    private var deltaTime: TimeInterval = 0.0
    private var systems: [RunLoopEvent: [System]] = [:]
    private var collider: Collider?
    private weak var frontend: GameSceneFrontend?
    public let appearance: GameAppearance
    
    private var entitiesToSpawn: [GameEntity] = []
    
    public init(appearance: GameAppearance) {
        self.appearance = appearance
    }
    
    public func register(system: System, for event: RunLoopEvent) {
        var array = systems[event] ?? []
        array.append(system)
        systems[event] = array
    }
    
    public func register(collider: Collider) {
        self.collider = collider
    }
}

extension SequentialGameLoop: GameLoop {
    public func setFrontend(_ frontend: GameSceneFrontend) {
        self.frontend = frontend
    }
    
    @MainActor
    public func update(entities: [STCCommon.GameEntity], currentTime: TimeInterval) {
        deltaTime = currentTime - (previousTime ?? currentTime)
        for system in self.systems[.update] ?? [] {
            system.update(entities: entities, deltaTime: deltaTime, commandService: self)
        }
        previousTime = currentTime
    }
    
    @MainActor
    public func physicsSimulated(entities: [STCCommon.GameEntity]) {
        for system in self.systems[.physicsSimulated] ?? [] {
            system.update(entities: entities, deltaTime: deltaTime, commandService: self)
        }
        
        frontend?.addEntities(entitiesToSpawn)
        entitiesToSpawn.removeAll()
    }
    
    @MainActor
    public func didContactEntities(first: STCCommon.GameEntity, second: STCCommon.GameEntity) {
        collider?.onContact(entityA: first, entityB: second)
    }
}

extension SequentialGameLoop: CommandService {
    @MainActor
    public func vision(_ start: CGPoint, rayLength: CGFloat, angle: CGFloat) -> [STCCommon.GameEntity] {
        let _end = start.vectorValue + .rotation(angle) * rayLength
        let end = _end.pointValue
        var nodes: [GameEntity] = []
        frontend?.rayCastEntities(from: start, to: end) {
            nodes.append($0)
        }
        return nodes
    }
    
    public func spawnEntity(_ entity: STCCommon.GameEntity) {
        entitiesToSpawn.append(entity)
    }
}
