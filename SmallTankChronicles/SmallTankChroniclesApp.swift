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
    let parameters = GameParameters()
    
    var body: some Scene {
        WindowGroup {
            GameView(parameters: parameters)
#if os(OSX)
                .onDisappear {
                    NSApplication.shared.terminate(nil)
                }
#endif
        }
    }
}
