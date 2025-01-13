//
//  AccelerationComponent.swift
//  STCEngine
//
//  Created by Sergey on 13.01.2025.
//

import STCCommon

public class AccelerationComponent: Component {
    public var acceleration: STCFloat
    
    init(acceleration: STCFloat) {
        self.acceleration = acceleration
    }
}
