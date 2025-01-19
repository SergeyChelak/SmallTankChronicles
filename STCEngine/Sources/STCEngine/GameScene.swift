//
//  GameScene.swift
//  BattleTanks
//
//  Created by Sergey on 29.10.2024.
//

import STCCommon
import STCComponents
import SpriteKit

public class GameScene: SKScene {    
    private weak var context: GameContext?
    private let cameraNode = SKCameraNode()
    private var levelRect: CGRect = .zero
    
    public required init(
        size: CGSize,
        context: GameContext
    ) {
        super.init(size: size)
        self.anchorPoint = .zero
        self.context = context
        context.setFrontend(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(size: .zero)
        self.anchorPoint = .zero
    }
    
    public override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupCamera()
        physicsWorld.contactDelegate = self
    }
    
    private func setupCamera() {
        self.camera = cameraNode
        cameraNode.setScale(mapScaleFactor)
        alignCameraPosition()
    }
    
    public override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        let entities = allEntities()
        Task {
            context?.update(
                entities: entities,
                currentTime: currentTime
            )
        }
    }
    
    public override func didSimulatePhysics() {
        super.didSimulatePhysics()
        alignCameraPosition()
        context?.physicsSimulated(entities: allEntities())
    }
    
    private func alignCameraPosition() {
        guard let node = entities(with: PlayerMarker.self).first else {
            return
        }
        var x = node.position.x
        x = max(x, mapScaleFactor * size.width * 0.5)
        x = min(x, levelRect.width - mapScaleFactor * size.width * 0.5)
        
        var y = node.position.y
        y = max(y, mapScaleFactor * size.height * 0.5)
        y = min(y, levelRect.height - mapScaleFactor * size.height * 0.5)
        camera?.position = CGPoint(x: x, y: y)
    }
    
    private func allEntities() -> [GameEntity] {
        children
            .compactMap {
                $0 as? GameEntity
            }
    }
    
    private func entities<T: Component>(with type: T.Type) -> [GameEntity] {
        allEntities()
            .filter {
                $0.hasComponent(of: type)
            }
    }
    
    private var mapScaleFactor: STCFloat {
        context?.appearance.mapScaleFactor ?? 1.0
    }
}

extension GameScene: SKPhysicsContactDelegate {
    nonisolated public func didBegin(_ contact: SKPhysicsContact) {
        guard let entityA = contact.bodyA.node as? GameEntity,
              let entityB = contact.bodyB.node as? GameEntity else {
            return
        }
        Task { @MainActor in
            context?.didContactEntities(first: entityA, second: entityB)
        }
    }
}

extension GameScene: GameSceneFrontend {
    @MainActor
    public func addEntities(_ nodes: [GameEntity]) {
        addChildren(nodes)
    }
    
    @MainActor
    public func rayCastEntities(from start: CGPoint, to end: CGPoint, handler: @escaping (GameEntity) -> ()) {
        physicsWorld.enumerateBodies(alongRayStart: start, end: end) { body, _, _, _ in
            guard let node = body.node as? GameEntity else {
                return
            }
            handler(node)
        }
    }
}
