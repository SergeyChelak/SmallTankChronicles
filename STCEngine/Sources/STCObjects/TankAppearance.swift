//
//  TankAppearance.swift
//  STCEngine
//
//  Created by Sergey on 15.01.2025.
//

import Foundation

struct TankAppearance {
    let color: TankColor
    let cannon: TankCannon
    let hull: TankHull
    let tracks: TankTracks
    
    let maxSpeed: CGFloat
    let rotationSpeed: CGFloat
    
    var hullImageName: String {
        [ "Hull",
          color.key,
          hull.key
        ].joined(separator: "_")
    }
    
    var cannonImageName: String {
        [ "Gun",
          color.key,
          cannon.key
        ].joined(separator: "_")
    }
    
    var trackAtlasName: String {
        tracks.key
    }
}

enum TankColor {
    case bronze
    case yellow
    case cyan
    case blue

    var key: String {
        switch self {
        case .bronze:
            return "A"
        case .yellow:
            return "B"
        case .cyan:
            return "C"
        case .blue:
            return "D"
        }
    }
}

enum TankCannon {
    case standard
    case lightImproved
    case semiStandard
    case light
    case standardImproved
    case double
    case heavy
    case heavyImproved

    var key: String {
        switch self {
        case .standard:
            return "01"
        case .lightImproved:
            return "02"
        case .semiStandard:
            return "03"
        case .light:
            return "04"
        case .standardImproved:
            return "05"
        case .double:
            return "06"
        case .heavy:
            return "07"
        case .heavyImproved:
            return "08"
        }
    }
}

enum TankHull {
    case hull1
    case hull2
    case hull3
    case hull4
    case hull5
    case hull6
    case hull7
    case hull8

    var key: String {
        switch self {
        case .hull1:
            return "01"
        case .hull2:
            return "02"
        case .hull3:
            return "03"
        case .hull4:
            return "04"
        case .hull5:
            return "05"
        case .hull6:
            return "06"
        case .hull7:
            return "07"
        case .hull8:
            return "08"
        }
    }
}

enum TankTracks {
    case type1
    case type2
    case type3
    
    var key: String {
        switch self {
        case .type1:
            return "Track_1"
        case .type2:
            return "Track_2"
        case .type3:
            return "Track_3"
        }
    }
}
