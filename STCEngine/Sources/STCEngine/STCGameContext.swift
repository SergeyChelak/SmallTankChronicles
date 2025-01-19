//
//  STCGameContext.swift
//  STCEngine
//
//  Created by Sergey on 13.01.2025.
//

import Foundation
import STCCommon

enum GameState {
    case run, win, lose
}

public class STCGameContext {
    private var previousTime: TimeInterval?
    private var state: GameState = .run
    private var deltaTime: TimeInterval = 0.0
    private var systems: [RunLoopEvent: [System]] = [:]
    private var collider: Collider?
    private weak var frontend: GameSceneFrontend?
    public let appearance: GameAppearance
    
    private var entitiesToSpawn: [GameEntity] = []
    private var entitiesToKill: [GameEntity] = []
    
    public init(appearance: GameAppearance) {
        self.appearance = appearance
    }
    
    public func register(system: System, for event: RunLoopEvent) {
        var array = systems[event] ?? []
        array.append(system)
        system.onConnect(setupService: self)
        systems[event] = array
    }
    
    public func register(collider: Collider) {
        self.collider = collider
    }
}

extension STCGameContext: GameContext {
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
        
        frontend?.removeEntities(entitiesToKill)
        entitiesToKill.removeAll()
    }
    
    @MainActor
    public func didContactEntities(first: STCCommon.GameEntity, second: STCCommon.GameEntity) {
        collider?.onContact(entityA: first, entityB: second, commandService: self)
    }
}

extension STCGameContext: CommandService {
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
    
    public func killEntity(_ entity: GameEntity) {
        entitiesToKill.append(entity)
    }
}

extension STCGameContext: GameSceneSetupService {
    //
}
