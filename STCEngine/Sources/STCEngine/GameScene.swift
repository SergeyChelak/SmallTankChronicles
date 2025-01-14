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
    private weak var gameLoop: GameLoop?
    private let cameraNode = SKCameraNode()
    private var levelRect: CGRect = .zero
    
    public required init(
        size: CGSize,
        gameLoop: GameLoop
    ) {
        super.init(size: size)
        self.anchorPoint = .zero
        self.gameLoop = gameLoop
        gameLoop.setFrontend(self)
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
            gameLoop?.update(
                entities: entities,
                currentTime: currentTime
            )
        }
    }
    
    public override func didSimulatePhysics() {
        super.didSimulatePhysics()
        alignCameraPosition()
        gameLoop?.physicsSimulated(entities: allEntities())
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
        gameLoop?.appearance.mapScaleFactor ?? 1.0
    }
}

extension GameScene: SKPhysicsContactDelegate {
    nonisolated public func didBegin(_ contact: SKPhysicsContact) {
        guard let entityA = contact.bodyA.node as? GameEntity,
              let entityB = contact.bodyB.node as? GameEntity else {
            return
        }
        Task { @MainActor in
            gameLoop?.didContactEntities(first: entityA, second: entityB)
        }
    }
}

extension GameScene: GameSceneFrontend {
    //
}
