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
        SpriteView(scene: GameScene(gameLoop: state.gameLoop))
            .ignoresSafeArea()
    }
}

class GameViewState: ObservableObject {
    struct Appearance: GameAppearance {
        var mapScaleFactor: STCFloat { 3.0 }
    }
    
    let gameLoop = SequentialGameLoop(appearance: Appearance())
}

#Preview {
    GameView()
}
