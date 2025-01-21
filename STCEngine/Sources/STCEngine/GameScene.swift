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
    private let cameraNode = SKCameraNode()
    private var levelRect: CGRect = .zero
    
    private var previousTime: TimeInterval?
    public private(set) var deltaTime: TimeInterval = 0.0
    
    private var systems: [RunLoopEvent: [System]] = [:]
    private var collider: Collider?
    
    private var entitiesToSpawn: [GameEntity] = []
    private var entitiesToKill: [GameEntity] = []
    public private(set) var entities: [GameEntity] = []
    
    private let appearance: GameAppearance
        
    public required init(
        appearance: GameAppearance
    ) {
        self.appearance = appearance
        super.init(size: .zero)
        self.anchorPoint = .zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Initializer not implemented")
    }
    
    public func register(system: System, for event: RunLoopEvent) {
        var array = systems[event] ?? []
        array.append(system)
        systems[event] = array
    }
    
    public func register(collider: Collider) {
        self.collider = collider
    }
    
    public override func didMove(to view: SKView) {
        super.didMove(to: view)
        systems
            .flatMap { $0.value }
            .forEach { [weak self] in
                guard let self else { return }
                $0.onConnect(context: self)
            }
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
        deltaTime = currentTime - (previousTime ?? currentTime)
        entities = allEntities()
        for system in self.systems[.update] ?? [] {
            system.update(sceneContext: self)
        }
        previousTime = currentTime
    }
    
    public override func didSimulatePhysics() {
        super.didSimulatePhysics()
        alignCameraPosition()
        for system in self.systems[.physicsSimulated] ?? [] {
            system.update(sceneContext: self)
        }
        
        addChildren(entitiesToSpawn)
        entitiesToSpawn.removeAll()
        
        entitiesToKill.forEach { $0.removeFromParent() }
        entitiesToKill.removeAll()

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
        appearance.mapScaleFactor
    }
}

extension GameScene: SKPhysicsContactDelegate {
    nonisolated public func didBegin(_ contact: SKPhysicsContact) {
        guard let entityA = contact.bodyA.node as? GameEntity,
              let entityB = contact.bodyB.node as? GameEntity else {
            return
        }
        Task { @MainActor in
            collider?.onContact(entityA: entityA, entityB: entityB, sceneContext: self)
        }
    }
}

extension GameScene: SceneContext, SceneSetupContext {
    public func vision(_ start: CGPoint, rayLength: CGFloat, angle: CGFloat) -> [STCCommon.GameEntity] {
        let _end = start.vectorValue + .rotation(angle) * rayLength
        let end = _end.pointValue
        var nodes: [GameEntity] = []
        physicsWorld.enumerateBodies(alongRayStart: start, end: end) { body, _, _, _ in
            guard let node = body.node as? GameEntity else {
                return
            }
            nodes.append(node)
        }
        return nodes
    }
    
    @MainActor
    public func spawnEntity(_ entity: STCCommon.GameEntity) {
        entitiesToSpawn.append(entity)
    }
    
    @MainActor
    public func killEntity(_ entity: STCCommon.GameEntity) {
        entitiesToKill.append(entity)
    }
}
