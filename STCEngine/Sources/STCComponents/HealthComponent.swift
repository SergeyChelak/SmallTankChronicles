//
//  HealthComponent.swift
//  STCEngine
//
//  Created by Sergey on 13.01.2025.
//

import STCCommon

public class HealthComponent: Component {
    public var health: STCFloat
    
    public init(health: STCFloat) {
        self.health = health
    }
}
