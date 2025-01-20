//
//  System.swift
//  STCEngine
//
//  Created by Sergey on 14.01.2025.
//

import Foundation

public protocol GameSceneSetupService {
    func spawnEntity(_ entity: GameEntity)
}

public protocol GameSceneEventHandler {
    @MainActor
    func onConnect(setupService: GameSceneSetupService)
}

public protocol System: GameSceneEventHandler {
    @MainActor
    func update(entities: [GameEntity], deltaTime: TimeInterval, commandService: CommandService)
}

public protocol Collider: GameSceneEventHandler {
    @MainActor
    func onContact(entityA: GameEntity, entityB: GameEntity, commandService: CommandService)
}

public protocol CommandService {
    @MainActor
    func vision(_ start: CGPoint, rayLength: CGFloat, angle: CGFloat) -> [GameEntity]
    func spawnEntity(_ entity: GameEntity)
    func killEntity(_ entity: GameEntity)
}
