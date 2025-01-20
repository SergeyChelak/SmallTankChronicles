//
//  TankFactory.swift
//  STCEngine
//
//  Created by Sergey on 20.01.2025.
//

import Foundation
import STCCommon

public struct TankFactory {
    public init() { }
    
    @MainActor
    public func model1(
        color: TankColor
    ) -> Tank {
        create(
            hull: .hull1,
            cannon: .heavy,
            tracks: .type1,
            color: color
        )
    }
    
    @MainActor
    public func model2(
        color: TankColor
    ) -> Tank {
        create(
            hull: .hull2,
            cannon: .heavyImproved,
            tracks: .type1,
            color: color
        )
    }
    
    @MainActor
    public func model3(
        color: TankColor
    ) -> Tank {
        create(
            hull: .hull3,
            cannon: .standard,
            tracks: .type2,
            color: color)
    }
    
    // TODO: add more models
    
    @MainActor
    func create(
        hull: TankHull,
        cannon: TankCannon,
        tracks: TankTracks,
        color: TankColor
    ) -> Tank {
        let appearance = TankAppearance(
            color: color,
            cannon: cannon,
            hull: hull,
            tracks: tracks
        )
        return Tank(appearance)
    }
}

extension TankColor {
    static func from(string: String?) -> TankColor {
        switch string {
        case "bronze": return .bronze
        case "blue": return .blue
        case "cyan": return .cyan
        default: return .yellow
        }
    }
}
