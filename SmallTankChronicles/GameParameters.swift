//
//  GameParameters.swift
//  SmallTankChronicles
//
//  Created by Sergey on 15.01.2025.
//

import Foundation
import STCCommon
import STCEngine

struct GameParameters {
    let appearance = Appearance()
    let npcParameters = NpcParameters()
}

struct Appearance: GameAppearance {
    let mapScaleFactor: STCFloat = 3.0
}

struct NpcParameters {
    let fieldOfView: CGFloat = .pi
    let rayLength: CGFloat = 1500
    let raysCount: Int = 20
    let attackDistance: CGFloat = 1000.0
}
