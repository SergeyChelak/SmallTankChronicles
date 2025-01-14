//
//  MaxSpeedComponent.swift
//  STCEngine
//
//  Created by Sergey on 13.01.2025.
//

import STCCommon

public class MaxSpeedComponent: Component {
    public var value: STCFloat
    
    public init(maxSpeed: STCFloat) {
        self.value = maxSpeed
    }
}
