//
//  UserInputDataSource.swift
//  SmallTankChronicles
//
//  Created by Sergey on 14.01.2025.
//

import Foundation
import STCSystems
import STCUserInput

class UserInputDataSource: InputSystemDataSource {
    private let inputController: UserInputController
    
    init(_ inputController: UserInputController) {
        self.inputController = inputController
    }
    
    func getState() -> STCSystems.UserInputState {
        var state = UserInputState()
    #if os(OSX)
        let input = inputController.keyboardPressState
        state.isMoveForwardPressed = input.isUpArrowPressed
        state.isMoveBackwardPressed = input.isDownArrowPressed
        state.isTurnLeftPressed = input.isLeftArrowPressed
        state.isTurnRightPressed = input.isRightArrowPressed
        state.isShootPressed = input.isSpacePressed
    #endif

    #if os(iOS)
        let input = inputController.gamepadPressState
        state.isMoveForwardPressed = input.yValue > 0
        state.isMoveBackwardPressed = input.yValue < 0
        state.isTurnLeftPressed = input.xValue < 0
        state.isTurnRightPressed = input.xValue > 0
        state.isShootPressed = input.isXPressed
    #endif
        return state

    }
}
