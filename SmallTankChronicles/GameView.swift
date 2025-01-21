//
//  GameView.swift
//  SmallTankChronicles
//
//  Created by Sergey on 13.01.2025.
//

import STCEngine
import SwiftUI
import SpriteKit

struct GameView: View {
    @StateObject
    private var state: GameViewState
    
    init(parameters: GameParameters) {
        _state = StateObject(wrappedValue: GameViewState(parameters: parameters))
    }
    
    var body: some View {
        GeometryReader { gr in
            spriteView(gr.size)
        }
    }
    
    private func spriteView(_ size: CGSize) -> some View {
        ZStack {
            SpriteView(
                scene: state.gameScene(size),
                options: [.ignoresSiblingOrder],
                debugOptions: [.showsFPS, .showsPhysics, .showsNodeCount]
            )
#if os(OSX)
            .onKeyPress() { press in
                state.onKeyPress(press)
                return .handled
            }
#endif
            HudView()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    GameView(parameters: GameParameters())
}
