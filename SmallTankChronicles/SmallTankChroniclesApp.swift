//
//  SmallTankChroniclesApp.swift
//  SmallTankChronicles
//
//  Created by Sergey on 13.01.2025.
//

import SwiftUI

@main
struct SmallTankChroniclesApp: App {
    // TODO: create factory
    let params = GameParameters()
    
    var body: some Scene {
        WindowGroup {
            GameView(params: params)
#if os(OSX)
                .onDisappear {
                    NSApplication.shared.terminate(nil)
                }
#endif
        }
    }
}
