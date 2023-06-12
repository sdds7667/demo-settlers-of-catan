//
//  HexCorner.swift
//  Catan
//
//  Created by Ion Plamadeala on 12/06/2023.
//

import Foundation
import SpriteKit

class HexCorner {
    private var size: CGFloat = 50.0
    var neighbourRoads: [CGFloat: HexEdge] = [CGFloat: HexEdge]()
    private var circleRadius: CGFloat = 15.0
    private var circle: SKShapeNode
    
    
    private var _building: Building? = nil
    public var building: Building? {
        set {
            if newValue == nil {
                return
            }
            _building = newValue
            if scene == nil {
                return
            }
            _building?.attachTo(scene: scene!)
            _building?.placeAt(point: position + CGPoint(x: 0.0, y: +3.0))
        }
        
        get {
            return _building
        }
        
    }
    
    
    private var _scene: SKScene? = nil
    public var scene: SKScene? {
        set {
            if (newValue == nil) {
                return
            }
            if _scene == nil {
                circle.zPosition = 500
                newValue!.addChild(circle)
            }
            _scene = newValue
            building?.attachTo(scene: newValue!)
        }
        
        get {
            return _scene
        }
    }
    
    private var _position: CGPoint = CGPoint(x: 0.0, y: 0.0)
    public var position: CGPoint {
        set {
            _position = newValue
            building?.placeAt(point: newValue + CGPoint(x: 0.0, y: +5.0))
            circle.position = newValue
        }
        
        get {
            return _position
        }
        
    }
    
    init() {
//        self.circle.strokeColor = .clear
        circle = SKShapeNode(circleOfRadius: circleRadius)
        circle.strokeColor = .clear
    }
    
    func containsPoint(point: CGPoint) -> Bool {
        return self.circle.position.distanceTo(other: point) < self.circleRadius
    }
    
    func select() {
        self.circle.fillColor = SKColor.black
    }
    
    func unselect() {
        self.circle.fillColor = .clear
    }
    
}
