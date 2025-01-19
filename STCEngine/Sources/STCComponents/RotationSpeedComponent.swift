//
//  RotationSpeedComponent.swift
//  STCEngine
//
//  Created by Sergey on 13.01.2025.
//

import STCCommon

public class RotationSpeedComponent: Component {
    public var value: STCFloat
    
    public init(rotationSpeed: STCFloat) {
        self.value = rotationSpeed
    }
}
