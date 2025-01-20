//
//  AccelerationComponent.swift
//  STCEngine
//
//  Created by Sergey on 13.01.2025.
//

import STCCommon

public class AccelerationComponent: Component {
    public var value: STCFloat
    
    public init(acceleration: STCFloat) {
        self.value = acceleration
    }
}
