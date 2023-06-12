//
//  HexNumberNode.swift
//  Catan
//
//  Created by Ion Plamadeala on 12/06/2023.
//

import Foundation
import SpriteKit

class HexNumberNode {
    
    private var circleShape: SKShapeNode
    private var number: SKLabelNode
    
    var _position: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var position: CGPoint {
        set{
            _position = newValue
            self.circleShape.position = newValue
            self.number.position = newValue
        }
        get{
            return _position
        }
    }
    
    init(num: Int, size: CGFloat ) {
        circleShape = SKShapeNode(circleOfRadius: size * 25.0/75.0)
        circleShape.zPosition = 1
        circleShape.fillColor = ColorScheme.mapBorder
        circleShape.strokeColor = ColorScheme.mapBorder
        number = SKLabelNode(text: "\(num)")
        number.zPosition = 2
        number.verticalAlignmentMode = .center
        number.horizontalAlignmentMode = .center
        number.fontSize = 32.0/75.0 * size
    }
    
    func attachTo(scene: SKScene) {
        scene.addChild(self.circleShape)
        scene.addChild(self.number)
    }
    
}
