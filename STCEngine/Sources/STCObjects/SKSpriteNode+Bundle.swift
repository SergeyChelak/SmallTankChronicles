//
//  File.swift
//  STCEngine
//
//  Created by Sergey on 21.01.2025.
//

import SpriteKit

extension SKSpriteNode {
    convenience init(imageNamed name: String, bundle: Bundle) {
#if os(OSX)
        let image = bundle.image(forResource: NSImage.Name(name))
#elseif os(iOS)
        let image = UIImage(named: name, in: bundle, compatibleWith: nil)
#endif
        let texture: SKTexture? = if let image {
            SKTexture(image: image)
        } else {
            nil
        }
        self.init(texture: texture)
    }
}
