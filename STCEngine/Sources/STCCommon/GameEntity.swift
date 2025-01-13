//
//  GameEntity.swift
//  STCEngine
//
//  Created by Sergey on 13.01.2025.
//

import SpriteKit

public typealias GameEntity = SKSpriteNode

fileprivate func identifier<T: Component>(of type: T.Type) -> ComponentIdentifier {
    "#component#" + String(describing: type.self)
}

extension GameEntity {
    var lazyUserData: NSMutableDictionary {
        let data = userData ?? [:]
        userData = data
        return data
    }
    
    public func addComponents(_ items: Component...) {
        items.forEach {
            addComponent($0)
        }
    }
    
    public func addComponent<T: Component>(_ component: T) {
        let key = identifier(of: T.self)
        lazyUserData[key] = component
    }
    
    public func removeComponent<T: Component>(of type: T.Type) {
        let key = identifier(of: T.self)
        lazyUserData.removeObject(forKey: key)
    }
    
    public func getComponent<T: Component>(of type: T.Type) -> T? {
        let key = identifier(of: T.self)
        return lazyUserData[key] as? T
    }
    
    public func hasComponent<T: Component>(of type: T.Type) -> Bool {
        getComponent(of: type) != nil
    }
    
    public var allComponents: [Component] {
        lazyUserData.allValues
            .compactMap {
                $0 as? Component
            }
    }
}
