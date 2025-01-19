//
//  ProjectileComponent.swift
//  STCEngine
//
//  Created by Sergey on 19.01.2025.
//

import STCCommon

public class ProjectileComponent: Component {
    public let velocity: STCFloat
    public let damage: STCFloat
    public let rechargeTime: STCFloat
    
    init(velocity: STCFloat, damage: STCFloat, rechargeTime: STCFloat) {
        self.velocity = velocity
        self.damage = damage
        self.rechargeTime = rechargeTime
    }
}
