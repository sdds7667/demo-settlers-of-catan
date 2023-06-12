//
//  HexEdge.swift
//  Catan
//
//  Created by Ion Plamadeala on 12/06/2023.
//

import Foundation
import SpriteKit


class HexEdge {
    private var size: CGFloat = 50.0;
    private var neighbourEdges: [CGFloat: HexCorner] = [CGFloat: HexCorner]()
    private var direction: CGFloat
    private var circle: SKShapeNode
    private var circleRadius: CGFloat = 15.0
    private var _road: Road? = nil
    var road: Road? {
        set {
            if (newValue == nil) {
                return
            }
            
            _road = newValue
            _road?.placeAt(point: position, direction: direction)
            if _scene != nil {
                _road?.attachTo(scene: _scene!)
            }
            
        }
        get {
            return _road
        }
    }
    private var _scene: SKScene? = nil
    
    var scene: SKScene? {
        set {
            if (newValue == nil) {
                return
            }
            if (_scene != nil) {
                return
            }
            _scene = newValue
            road?.attachTo(scene: newValue!)
            newValue?.addChild(circle)
        }
        
        get {
            return _scene
        }
        
    }
    
    private var _viewPosition : CGPoint = CGPoint(x: 0.0, y: 0.0)
    public var position: CGPoint {
        set {
            _viewPosition = newValue
            road?.placeAt(point: newValue, direction: CGFloat(direction))
            circle.position = CGPoint(x:cos(direction) * (size/2) + newValue.x, y:sin(direction) * (size/2) + newValue.y)
            circle.zPosition = 500
        }
        get {
            return _viewPosition
        }
    }
    
    
    init(direction: CGFloat) {
        self.direction = (direction + 2) * (CGFloat.pi * 2 / 6)
        circle = SKShapeNode(circleOfRadius: circleRadius)
        circle.strokeColor = .clear
    }
    
    func containsPoint(point: CGPoint) -> Bool {
        return self.circle.position.distanceTo(other: point) < circleRadius
    }
    
    
    
}
