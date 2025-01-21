//
//  System.swift
//  STCEngine
//
//  Created by Sergey on 14.01.2025.
//

import Foundation

public protocol SceneEntityManagementContext {
    @MainActor
    func spawnEntity(_ entity: GameEntity)
    @MainActor
    func killEntity(_ entity: GameEntity)
}

public protocol SceneSetupContext: SceneEntityManagementContext {
    
}

public protocol GameSceneEventHandler {
    @MainActor
    func onConnect(context: SceneSetupContext)
}

public protocol System: GameSceneEventHandler {
    @MainActor
    func update(sceneContext: SceneContext)
}

public protocol Collider: GameSceneEventHandler {
    @MainActor
    func onContact(entityA: GameEntity, entityB: GameEntity, sceneContext: SceneContext)
}

public protocol SceneContext: SceneEntityManagementContext {
    @MainActor
    var deltaTime: TimeInterval { get }
    @MainActor
    var entities: [GameEntity] { get }
    @MainActor
    func vision(_ start: CGPoint, rayLength: CGFloat, angle: CGFloat) -> [GameEntity]    
}
