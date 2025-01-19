//
//  PhaseComponent.swift
//  STCEngine
//
//  Created by Sergey on 13.01.2025.
//

import STCCommon

public class PhaseComponent: Component {
    public var phase: STCFloat
    
    public init(phase: STCFloat = 0.5 * .pi) {
        self.phase = phase
    }
}
