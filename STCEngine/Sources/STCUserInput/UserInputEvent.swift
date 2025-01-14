//
//  UserInputEvent.swift
//  STCEngine
//
//  Created by Sergey on 14.01.2025.
//

import Foundation
import SwiftUI

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

public struct KeyEventData {
    public let isPressed: Bool
    public let keyEquivalent: KeyEquivalent
    
    public init(isPressed: Bool, keyEquivalent: KeyEquivalent) {
        self.isPressed = isPressed
        self.keyEquivalent = keyEquivalent
    }
}

public struct GamepadButtonState {
    public let button: GamepadButton
    public let isPressed: Bool
    
    public init(button: GamepadButton, isPressed: Bool) {
        self.button = button
        self.isPressed = isPressed
    }
}

public enum UserInputEvent {
    case key(KeyEventData)
    case padDirectionChanged(DirectionData)
    case gamepadButton(GamepadButtonState)
}


