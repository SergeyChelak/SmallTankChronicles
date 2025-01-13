//
//  GameView.swift
//  SmallTankChronicles
//
//  Created by Sergey on 13.01.2025.
//

import STCCommon
import STCEngine
import SwiftUI
import SpriteKit

struct GameView: View {
    @StateObject
    private var state = GameViewState()
    
    var body: some View {
        SpriteView(
            scene: GameScene(gameLoop: state.gameLoop),
            options: [.ignoresSiblingOrder],
            debugOptions: [.showsFPS, .showsPhysics, .showsNodeCount]
        )
#if os(OSX)
        .onKeyPress(phases: [.up, .down]) { press in
            guard state.onKeyPress(press) else {
                return .ignored
            }
            return .handled
        }
#endif
        .ignoresSafeArea()
    }
}

class GameViewState: ObservableObject {
    struct Appearance: GameAppearance {
        var mapScaleFactor: STCFloat { 3.0 }
    }
    
    let gameLoop = SequentialGameLoop(appearance: Appearance())
    
#if os(OSX)
    func onKeyPress(_ keyPress: KeyPress) -> Bool {
//        print("key: \(keyPress)")
        return false
    }
#endif
}

#Preview {
    GameView()
}
