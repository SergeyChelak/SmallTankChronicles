//
//  GameViewState.swift
//  SmallTankChronicles
//
//  Created by Sergey on 14.01.2025.
//

import STCCommon
import STCEngine
import STCSystems
import STCUserInput
import STCLevel
import SwiftUI
#if os(iOS)
import GameController
#endif

class GameViewState: ObservableObject {    
    private let userInputController = UserInputController()
    private var gameScene: GameScene?
    
    private let parameters: GameParameters
    
    init(parameters: GameParameters) {
        self.parameters = parameters
#if os(iOS)
        setupController()
#endif
    }
    
    @MainActor
    func gameScene(_ size: CGSize) -> GameScene {
        let scene = gameScene ?? makeGameScene(
            parameters: parameters,
            userInputController: userInputController
        )
        scene.size = size
        self.gameScene = scene
        return scene
    }
    
#if os(iOS)
    private let virtualController: GCVirtualController = {
        let configuration = GCVirtualController.Configuration()
        configuration.elements = [
            GCInputDirectionPad,
            GCInputButtonX
        ]
        let controller = GCVirtualController(configuration: configuration)
        controller.connect()
        return controller
    }()
    
    private func setupController() {
        guard let extendedGamepad = virtualController.controller?.extendedGamepad else {
            print("Can't get extended gamepad")
            return
        }
        extendedGamepad.dpad.valueChangedHandler = { [weak userInputController] _, xValue, yValue in
            let data = DirectionData(xValue: xValue, yValue: yValue)
            userInputController?.handle(.padDirectionChanged(data))
        }
        
        extendedGamepad.buttonX.valueChangedHandler = { [weak userInputController] _, _, isPressed in
            let data = GamepadButtonState(button: .x, isPressed: isPressed)
            userInputController?.handle(.gamepadButton(data))
        }
    }
#endif
    
    
#if os(OSX)
    func onKeyPress(_ keyPress: KeyPress) {
        let isPressed = keyPress.phase == .down || keyPress.phase == .repeat
        let data = KeyEventData(isPressed: isPressed, keyEquivalent: keyPress.key)
        userInputController.handle(.key(data))
    }
#endif
}

@MainActor
func makeGameScene(
    parameters: GameParameters,
    userInputController: UserInputController
) -> GameScene {
    let scene = GameScene(appearance: parameters.appearance)
    // WARNING: Order is matter
    
    // input system
    let inputSystem = {
        let dataSource = UserInputDataSource(userInputController)
        return InputSystem(dataSource: dataSource)
    }()
    scene.register(system: LevelSystem(), for: .update)
    scene.register(system: inputSystem, for: .update)
    
    // TODO: add shot system
    scene.register(system: MovementSystem(), for: .update)
    
    let npcParams = parameters.npcParameters
    let npcSystem = NpcSystem(
        fieldOfView: npcParams.fieldOfView,
        rayLength: npcParams.rayLength,
        raysCount: npcParams.raysCount,
        attackDistance: npcParams.attackDistance
    )
    scene.register(system: npcSystem, for: .update)
    
    scene.register(collider: PhysicSystem())
    
    return scene
}
