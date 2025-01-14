//
//  InputSystem.swift
//  STCEngine
//
//  Created by Sergey on 14.01.2025.
//

import Foundation
import STCCommon
import STCComponents

// see codes here: https://gist.github.com/swillits/df648e87016772c7f7e5dbed2b345066
public enum KeyCode {
    static let space: UInt16 = 0x31
    static let leftArrow: UInt16 = 0x7B
    static let rightArrow: UInt16 = 0x7C
    static let downArrow: UInt16 = 0x7D
    static let upArrow: UInt16 = 0x7E
    static let equals: UInt16 = 0x18
    static let minus: UInt16 = 0x1B
}

public struct KeyEventData {
    public let isPressed: Bool
    public let keyCode: UInt16
}

public struct DirectionData {
    public let xValue: Float
    public let yValue: Float
    
    public init(xValue: Float, yValue: Float) {
        self.xValue = xValue
        self.yValue = yValue
    }
}

public enum GamepadButton {
    case x
}

public struct GamepadButtonState {
    public let button: GamepadButton
    public let isPressed: Bool
    
    public init(button: GamepadButton, isPressed: Bool) {
        self.button = button
        self.isPressed = isPressed
    }
}

public enum InputControllerEvent {
    case key(KeyEventData)
    case padDirectionChanged(DirectionData)
    case gamepadButton(GamepadButtonState)
}

final class InputControllerState {
    // keyboard state
    var isUpArrowPressed = false
    var isDownArrowPressed = false
    var isLeftArrowPressed = false
    var isRightArrowPressed = false
    var isSpacePressed = false
    var isMinusPressed = false
    var isEqualsPressed = false
    
    // gamepad state
    var xValue: Float = 0
    var yValue: Float = 0
    var isGamedPadXPressed = false
}

public class InputSystem {
    private let state = InputControllerState()
    
    public init() {
        //
    }
 
    public func handle(_ event: InputControllerEvent) {
        switch event {
        case .key(let keyEventData):
            handleKeyEvent(keyEventData)
        case .gamepadButton(let data):
            handleGamepadButton(data)
        case .padDirectionChanged(let data):
            handleGamepadDirectionChanged(data)
        }
    }
    
    private func handleGamepadDirectionChanged(_ data: DirectionData) {
        state.xValue = data.xValue
        state.yValue = data.yValue
    }
    
    private func handleGamepadButton(_ data: GamepadButtonState) {
        switch data.button {
        case .x:
            state.isGamedPadXPressed = data.isPressed
        }
    }
    
    private func handleKeyEvent(_ data: KeyEventData) {
        switch data.keyCode {
        case KeyCode.downArrow:
            state.isDownArrowPressed = data.isPressed
        case KeyCode.upArrow:
            state.isUpArrowPressed = data.isPressed
        case KeyCode.leftArrow:
            state.isLeftArrowPressed = data.isPressed
        case KeyCode.rightArrow:
            state.isRightArrowPressed = data.isPressed
        case KeyCode.space:
            state.isSpacePressed = data.isPressed
        case KeyCode.minus:
            state.isMinusPressed = data.isPressed
        case KeyCode.equals:
            state.isEqualsPressed = data.isPressed
        default:
            break
        }
    }
    
    func state<T>(_ mapper: (InputControllerState) -> T = { $0 }) -> T {
        mapper(state)
    }
}

extension InputSystem: System {
    public func update(entities: [STCCommon.GameEntity], deltaTime: TimeInterval) {
        let inputState = state(remapLevelInput)
        entities
            .filter {
                $0.hasComponent(of: UserInputMarker.self)
            }
            .forEach {
                if let movement = $0.getComponent(of: MovementComponent.self) {
                    movement.accelerate = inputState.isMoveForwardPressed
                    movement.decelerate = inputState.isMoveBackwardPressed
                    movement.turnLeft = inputState.isTurnLeftPressed
                    movement.turnRight = inputState.isTurnRightPressed
                }
                if inputState.isShootPressed,
                   let shot = $0.getComponent(of: ShotComponent.self) {
                    shot.shotState = .requested
                }
            }
    }
}

final class LevelInputState {
    // tank
    var isMoveForwardPressed = false
    var isMoveBackwardPressed = false
    var isTurnLeftPressed = false
    var isTurnRightPressed = false
    // cannon
    var isShootPressed = false
    
    static func `default`() -> LevelInputState {
        LevelInputState()
    }
}

func remapLevelInput(_ input: InputControllerState) -> LevelInputState {
    let state = LevelInputState()
#if os(OSX)
    state.isMoveForwardPressed = input.isUpArrowPressed
    state.isMoveBackwardPressed = input.isDownArrowPressed
    state.isTurnLeftPressed = input.isLeftArrowPressed
    state.isTurnRightPressed = input.isRightArrowPressed
    state.isShootPressed = input.isSpacePressed
#endif

#if os(iOS)
    state.isMoveForwardPressed = input.yValue > 0
    state.isMoveBackwardPressed = input.yValue < 0
    state.isTurnLeftPressed = input.xValue < 0
    state.isTurnRightPressed = input.xValue > 0
    state.isShootPressed = input.isGamedPadXPressed
#endif
    return state
}
