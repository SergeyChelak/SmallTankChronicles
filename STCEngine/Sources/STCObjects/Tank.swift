//
//  Tank.swift
//  STCEngine
//
//  Created by Sergey on 15.01.2025.
//

import Foundation
import SpriteKit
import STCCommon

public class Tank: SKSpriteNode {
    enum Element: String {
        case cannon
        case hull
        case leftTrack
        case rightTrack
    }
    
    let appearance: TankAppearance
    private var trackTextures: [SKTexture] = []
    private var isTracksAnimating = false
    
    public init(_ appearance: TankAppearance) {
        self.appearance = appearance
        super.init(texture: nil, color: .clear, size: .zero)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupChildren()
        setupPhysics()
    }
    
    private func setupChildren() {
        let hull = SKSpriteNode(imageNamed: appearance.hullImageName, bundle: .module)
        hull.name = Element.hull.rawValue
        hull.zPosition = 9
        self.size = hull.size
        addChild(hull)
        
        let cannon = SKSpriteNode(imageNamed: appearance.cannonImageName, bundle: .module)
        cannon.name = Element.cannon.rawValue
        cannon.zPosition = 10
        cannon.anchorPoint = CGPoint(x: 0.5, y: 0.2)
        cannon.position = CGPoint(x: 0, y: -20)
        addChild(cannon)
        
        let tracks = createTracks()
        addChildren(tracks)
    }
    
    private func createTracks() -> [SKSpriteNode] {
        trackTextures = appearance.tracksImageNames.compactMap {
            SKTexture(imageNamed: $0, bundle: .module)
        }
        guard let texture = trackTextures.first else {
            return []
        }
        let xOffset = 0.25 * self.size.width + 5
        return [
            (-1, Element.leftTrack),
            (1, Element.rightTrack)
        ]
            .map { i, elem in
                let node = SKSpriteNode(texture: texture)
                node.name = elem.rawValue
                node.zPosition = 8
                node.position -= CGPoint(x: CGFloat(i) * xOffset, y: 0)
                return node
            }
    }
    
    private func setupPhysics() {
        let bodySize = self.size * CGSize(width: 0.7, height: 1.0)
        let body = SKPhysicsBody(rectangleOf: bodySize)
        body.isDynamic = true
        body.allowsRotation = true
        body.affectedByGravity = false
        body.setObjectCategory(.tank)
        body.contactTestBitMask = UInt32.max
        self.physicsBody = body
    }

    func setTrackAnimated(_ isAnimating: Bool) {
        guard self.isTracksAnimating != isAnimating else {
            return
        }
        self.isTracksAnimating = isAnimating
        trackNodes
            .forEach {
                guard isAnimating else {
                    $0.removeAllActions()
                    return
                }
                let action: SKAction = .animate(
                    with: trackTextures,
                    timePerFrame: 0.005
                )
                $0.run(.repeatForever(action))
            }
    }
    
    private var trackNodes: [SKNode] {
        [
            Element.leftTrack,
            Element.rightTrack
        ].compactMap {
            childNode(withName: $0.rawValue)
        }
    }
}
