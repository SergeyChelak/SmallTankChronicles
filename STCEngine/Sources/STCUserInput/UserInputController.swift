//
//  UserInputController.swift
//  STCEngine
//
//  Created by Sergey on 14.01.2025.
//

import Foundation

public final class UserInputController {
    public let keyboardPressState = KeyboardState()
    public let gamepadPressState = GamepadState()
    
    public init() { }
    
    public func handle(_ event: UserInputEvent) {
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
        gamepadPressState.xValue = data.xValue
        gamepadPressState.yValue = data.yValue
    }
    
    private func handleGamepadButton(_ data: GamepadButtonState) {
        switch data.button {
        case .x:
            gamepadPressState.isXPressed = data.isPressed
        }
    }
    
    private func handleKeyEvent(_ data: KeyEventData) {
        switch data.keyEquivalent {
        case .downArrow:
            keyboardPressState.isDownArrowPressed = data.isPressed
        case .upArrow:
            keyboardPressState.isUpArrowPressed = data.isPressed
        case .leftArrow:
            keyboardPressState.isLeftArrowPressed = data.isPressed
        case .rightArrow:
            keyboardPressState.isRightArrowPressed = data.isPressed
        case .space:
            keyboardPressState.isSpacePressed = data.isPressed
        case "-":
            keyboardPressState.isMinusPressed = data.isPressed
        case "+":
            keyboardPressState.isEqualsPressed = data.isPressed
        default:
            break
        }
    }
}
