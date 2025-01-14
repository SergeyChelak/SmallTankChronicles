//
//  System.swift
//  STCEngine
//
//  Created by Sergey on 14.01.2025.
//

import Foundation

public protocol System {
    @MainActor
    func update(entities: [GameEntity], deltaTime: TimeInterval, commandService: CommandService)
}

public protocol Collider {
    func onContact(_ first: GameEntity, second: GameEntity)
}

public protocol CommandService {
    func vision(_ start: CGPoint, rayLength: CGFloat, angle: CGFloat) -> [GameEntity]
    func spawnEntity(_ entity: GameEntity)
}
