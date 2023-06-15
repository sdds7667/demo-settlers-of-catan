//
//  SceneNode.swift
//  Catan
//
//  Created by Ion Plamadeala on 15/06/2023.
//

import Foundation
import SpriteKit

enum SceneListener {
    case sceneNode(_ node: SceneNode)
    case skNode(_ node: SKNode)
}

enum PositionListener {
    case sceneNode(_ node: SceneNode, delta: CGPoint)
    case skNode(_ node: SKNode, delta: CGPoint)
}

class SceneNode {
    
    private var sceneListeners: [SceneListener] = []
    private var positionListeners: [PositionListener] = []
    public var scene: SKScene? {
        didSet {
            if oldValue != nil || scene == nil {
                return
            }
            sceneListeners.forEach{
                switch ($0) {
                case .sceneNode(let node):
                    node.scene = scene
                
                case .skNode(let node):
                    scene?.addChild(node)
                }
            }
        }
    }
    
    public var position: CGPoint = CGPoint(x: 0.0, y: 0.0) {
        didSet {
            positionListeners.forEach{
                switch($0){
                case .sceneNode(let node, let delta):
                    node.position = position + delta
                case .skNode(let node, let delta):
                    node.position = position + delta
                }
            }
        }
    }
    
    internal func registerListener(_ listener: SceneNode) {
        registerListener(listener, delta: .zero)
    }
    
    internal func registerListener(_ listener: SKNode) {
        registerListener(listener, delta: .zero)
        
    }
    
    internal func registerListener(_ listener: SKNode, delta: CGPoint) {
        sceneListeners.append(.skNode(listener))
        scene?.addChild(listener)
        
        positionListeners.append(.skNode(listener, delta: delta))
        listener.position = position + delta
    }
    
    internal func registerListener(_ listener: SceneNode, delta: CGPoint) {
        sceneListeners.append(.sceneNode(listener))
        listener.scene = scene
        
        positionListeners.append(.sceneNode(listener, delta: delta))
        listener.position = position + delta
    }
    
    
    
}
