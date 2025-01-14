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
import SwiftUI
#if os(iOS)
import GameController
#endif

class GameViewState: ObservableObject {
    struct Appearance: GameAppearance {
        var mapScaleFactor: STCFloat { 3.0 }
    }
    
    private let appearance = Appearance()
    private let userInputController = UserInputController()
    let gameLoop: GameLoop
    
    init() {
        let gameLoop = SequentialGameLoop(appearance: appearance)
        self.gameLoop = gameLoop
        
        let inputSystem = {
            let dataSource = UserInputDataSource(userInputController)
            return InputSystem(dataSource: dataSource)
        }()
        gameLoop.register(system: inputSystem, for: .update)
        // TODO: add shot system
        gameLoop.register(system: MovementSystem(), for: .update)
        // TODO: add npc system
#if os(iOS)
        setupController()
#endif
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
    func onKeyPress(_ keyPress: KeyPress) -> Bool {
        let data = KeyEventData(isPressed: keyPress.phase == .down, keyEquivalent: keyPress.key)
        userInputController.handle(.key(data))
        return true
    }
#endif
}
