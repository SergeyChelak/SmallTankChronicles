//
//  ShotComponent.swift
//  STCEngine
//
//  Created by Sergey on 14.01.2025.
//

import Foundation
import STCCommon

public class ShotComponent: Component {
    public enum State {
        case idle, requested
    }
    
//    let config: ProjectileConfiguration
    public var lastShotTime: Date = .init(timeIntervalSince1970: 0)
    public var shotState: State = .idle
    
//    init(config: ProjectileConfiguration) {
//        self.config = config
//    }
}
