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
    
    public let appearance: GameAppearance
    
    public init(appearance: GameAppearance) {
        self.appearance = appearance
    }
    
    public func register(system: System, for event: RunLoopEvent) {
        var array = systems[event] ?? []
        array.append(system)
        systems[event] = array
    }
    
    public func register(collider: Collider) {
        //
    }
}

extension SequentialGameLoop: GameLoop {    
    @MainActor
    public func update(entities: [STCCommon.GameEntity], currentTime: TimeInterval) {
        deltaTime = currentTime - (previousTime ?? currentTime)
        for system in self.systems[.update] ?? [] {
            system.update(entities: entities, deltaTime: deltaTime)
        }
        previousTime = currentTime
    }
    
    @MainActor
    public func physicsSimulated(entities: [STCCommon.GameEntity]) {
        for system in self.systems[.physicsSimulated] ?? [] {
            system.update(entities: entities, deltaTime: deltaTime)
        }
    }
    
    @MainActor
    public func didContactEntities(first: STCCommon.GameEntity, second: STCCommon.GameEntity) {
        //
    }
}
