//
//  SmallTankChroniclesApp.swift
//  SmallTankChronicles
//
//  Created by Sergey on 13.01.2025.
//

import SwiftUI
#if os(OSX)
import AppKit
#endif

@main
struct SmallTankChroniclesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
#if os(OSX)
                .onDisappear {
                    NSApplication.shared.terminate(nil)
                }
#endif
        }
    }
}
