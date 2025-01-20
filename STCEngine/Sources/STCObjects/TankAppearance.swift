//
//  TankAppearance.swift
//  STCEngine
//
//  Created by Sergey on 15.01.2025.
//

import Foundation

public struct TankAppearance {
    public let color: TankColor
    public let cannon: TankCannon
    public let hull: TankHull
    public let tracks: TankTracks
        
    public var hullImageName: String {
        [ "Hull",
          color.key,
          hull.key
        ].joined(separator: "_")
    }
    
    public var cannonImageName: String {
        [ "Gun",
          color.key,
          cannon.key
        ].joined(separator: "_")
    }
    
    public var trackAtlasName: String {
        tracks.key
    }
}

public enum TankColor {
    case bronze
    case yellow
    case cyan
    case blue

    public var key: String {
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

public enum TankCannon {
    case standard
    case lightImproved
    case semiStandard
    case light
    case standardImproved
    case double
    case heavy
    case heavyImproved

    public var key: String {
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

public enum TankHull {
    case hull1
    case hull2
    case hull3
    case hull4
    case hull5
    case hull6
    case hull7
    case hull8

    public var key: String {
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

public enum TankTracks {
    case type1
    case type2
    case type3
    
    public var key: String {
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
