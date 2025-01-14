//
//  GameView.swift
//  SmallTankChronicles
//
//  Created by Sergey on 13.01.2025.
//

import STCCommon
import STCEngine
import STCSystems
import SwiftUI
import SpriteKit
#if os(iOS)
import GameController
#endif

struct GameView: View {
    @StateObject
    private var state = GameViewState()
    
    var body: some View {
        GeometryReader { gr in
            spriteView(gr.size)
        }
    }
    
    private func spriteView(_ size: CGSize) -> some View {
        SpriteView(
            scene: GameScene(
                size: size,
                gameLoop: state.gameLoop
            ),
            options: [.ignoresSiblingOrder],
            debugOptions: [.showsFPS, .showsPhysics, .showsNodeCount]
        )
#if os(OSX)
        .onKeyPress(phases: [.up, .down]) { press in
            state.onKeyPress(press) ? .handled : .ignored
        }
#endif
        .ignoresSafeArea()
    }
}

class GameViewState: ObservableObject {
    struct Appearance: GameAppearance {
        var mapScaleFactor: STCFloat { 3.0 }
    }
    
    private let appearance = Appearance()
    private let inputSystem = InputSystem()
    private let movementSystem = MovementSystem()
    let gameLoop: GameLoop
    
    init() {
        let gameLoop = SequentialGameLoop(appearance: appearance)
        gameLoop.register(system: inputSystem, for: .update)
        // TODO: add shot system
        gameLoop.register(system: movementSystem, for: .update)
        // TODO: add npc system
        self.gameLoop = gameLoop
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
        extendedGamepad.dpad.valueChangedHandler = { [weak inputSystem] _, xValue, yValue in
            let data = DirectionData(xValue: xValue, yValue: yValue)
            inputSystem?.handle(.padDirectionChanged(data))
        }
        
        extendedGamepad.buttonX.valueChangedHandler = { [weak inputSystem] _, _, isPressed in
            let data = GamepadButtonState(button: .x, isPressed: isPressed)
            inputSystem?.handle(.gamepadButton(data))
        }
    }
#endif
    
    
#if os(OSX)
    func onKeyPress(_ keyPress: KeyPress) -> Bool {
//        let data = KeyEventData(isPressed: keyPress.phase == .down, keyCode: keyPress.key)
//        self.inputSystem.handle(.key(data))
        return true
    }
#endif
}

#Preview {
    GameView()
}
