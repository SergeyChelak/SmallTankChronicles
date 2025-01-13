//
//  Contract.swift
//  STCEngine
//
//  Created by Sergey on 13.01.2025.
//

import Foundation
import STCCommon

public protocol GameLoop: AnyObject {
    var appearance: GameAppearance { get }
    @MainActor func update(entities: [GameEntity], currentTime: TimeInterval)
    func physicsSimulated(entities: [GameEntity])
    @MainActor func didContactEntities(first: GameEntity, second: GameEntity)
}

public enum RunLoopEvent {
    case update, physicsSimulated
}

public protocol System {
    func update(entities: [GameEntity], deltaTime: TimeInterval)
}

public protocol Collider {
    func onContact(_ first: GameEntity, second: GameEntity)
}
