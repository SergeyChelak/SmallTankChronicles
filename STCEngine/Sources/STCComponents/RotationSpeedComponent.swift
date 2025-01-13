//
//  RotationSpeedComponent.swift
//  STCEngine
//
//  Created by Sergey on 13.01.2025.
//

import STCCommon

public class RotationSpeedComponent: Component {
    public var rotationSpeed: STCFloat
    
    init(rotationSpeed: STCFloat) {
        self.rotationSpeed = rotationSpeed
    }
}
