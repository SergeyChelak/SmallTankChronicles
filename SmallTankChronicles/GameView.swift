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
    
    init(params: GameParameters) {
        _state = StateObject(wrappedValue: GameViewState(parameters: params))
    }
    
    var body: some View {
        GeometryReader { gr in
            spriteView(gr.size)
        }
    }
    
    private func spriteView(_ size: CGSize) -> some View {
        SpriteView(
            scene: state.gameScene(size),
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

//#Preview {
//    GameView()
//}
