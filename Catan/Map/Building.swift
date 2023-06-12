//
//  Building.swift
//  Catan
//
//  Created by Ion Plamadeala on 12/06/2023.
//

import Foundation
import SpriteKit

class Building {
    var sprite: SKShapeNode
    
    init(color: SKColor, size: CGFloat) {
        sprite = SKShapeNode()
        let path = CGMutablePath()
        let size = CGFloat(9.0)
        path.move(to:CGPoint(x: 0, y: size))
        path.addLine(to: CGPoint(x: -size, y: +size - size * 2 * 1/3))
        path.addLine(to: CGPoint(x: -size, y: +size - size * 2 * 3/3))
        path.addLine(to: CGPoint(x: +size, y: +size - size * 2 * 3/3))
        path.addLine(to: CGPoint(x: +size, y: +size - size * 2 * 1/3))
        path.closeSubpath()
        sprite.path = path
        sprite.fillColor = color
        sprite.strokeColor = .black
        sprite.lineWidth = 1.0
    }
    
    func placeAt(point: CGPoint) {
        sprite.position = point
        sprite.zPosition = 15
    }
    
    func attachTo(scene: SKScene) {
        scene.addChild(sprite)
    }
    
}
