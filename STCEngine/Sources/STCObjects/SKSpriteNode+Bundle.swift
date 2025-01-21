//
//  File.swift
//  STCEngine
//
//  Created by Sergey on 21.01.2025.
//

import SpriteKit

extension SKTexture {
    convenience init?(imageNamed name: String, bundle: Bundle) {
#if os(OSX)
        let image = bundle.image(forResource: NSImage.Name(name))
#elseif os(iOS)
        let image = UIImage(named: name, in: bundle, compatibleWith: nil)
#endif
        guard let image else {
            return nil
        }
        self.init(image: image)
    }
}

extension SKSpriteNode {
    convenience init(imageNamed name: String, bundle: Bundle) {
        let texture = SKTexture(imageNamed: name, bundle: bundle)
        self.init(texture: texture)
    }
}
