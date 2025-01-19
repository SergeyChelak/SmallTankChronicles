//
//  Contract.swift
//  STCEngine
//
//  Created by Sergey on 13.01.2025.
//

import Foundation
import STCCommon

public protocol GameContext: AnyObject {
    var appearance: GameAppearance { get }
    func setFrontend(_ frontend: GameSceneFrontend)
    @MainActor func update(entities: [GameEntity], currentTime: TimeInterval)
    @MainActor func physicsSimulated(entities: [GameEntity])
    @MainActor func didContactEntities(first: GameEntity, second: GameEntity)
}

public enum RunLoopEvent {
    case update, physicsSimulated
}

public protocol GameSceneFrontend: AnyObject {
    @MainActor func addEntities(_ nodes: [GameEntity])
    
    @MainActor func removeEntities(_ nodes: [GameEntity])
    
    @MainActor func rayCastEntities(from start: CGPoint, to end: CGPoint, handler: @escaping (GameEntity) -> ())
}
