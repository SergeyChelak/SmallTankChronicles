//
//  LevelSystem.swift
//  STCEngine
//
//  Created by Sergey on 20.01.2025.
//

import Foundation
import STCCommon
import STCComponents
import STCObjects

public class LevelSystem: System {
    private let tankFactory = TankFactory()
    
    public init() { }
    
    @MainActor
    public func update(sceneContext: any STCCommon.SceneContext) {
        // do nothing
    }
    
    @MainActor
    public func onConnect(context: SceneSetupContext) {
        let maxSpeed = 600.0
        let tank = tankFactory.model1(color: .blue)
        tank.addComponents(
            PhaseComponent(),
            AccelerationComponent(acceleration: 0.1 * maxSpeed),
            MaxSpeedComponent(maxSpeed: maxSpeed),
            RotationSpeedComponent(rotationSpeed: .pi / 3),
            MovementComponent(),
            
            HealthComponent(health: 500),
            PlayerMarker(),
            UserInputMarker()
//            ShotComponent(config: .heavy)
        )
        tank.position = CGPoint(x: -1000.0, y: -1000.0)
        tank.zRotation = 0.0
        tank.zPosition = 0.0
        context.spawnEntity(tank)
        print("[LevelSystem] onConnect")
    }
}
