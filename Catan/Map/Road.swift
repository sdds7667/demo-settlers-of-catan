//
//  Road.swift
//  Catan
//
//  Created by Ion Plamadeala on 12/06/2023.
//

import Foundation
import SpriteKit

class Road: SceneNode {
    
    var shapeNode: SKShapeNode
    
    init(color: SKColor, size: CGFloat) {
        shapeNode = SKShapeNode()
        let path = CGMutablePath()
        // old: 75 -> 38
        
        let width = CGFloat(size * 38.0/75.0)
        let height = CGFloat(size * 8.0/75.0)
        let delta = CGFloat(size * 4.3/75.0)
        path.move(to: CGPoint(x: delta, y: -height))
        path.addLine(to: CGPoint(x: 2*width - delta, y: -height))
        path.addLine(to: CGPoint(x: 2*width, y: CGFloat(0.0)))
        path.addLine(to: CGPoint(x: 2*width - delta, y: +height))
        path.addLine(to: CGPoint(x: delta, y: +height))
        path.addLine(to: CGPoint(x: CGFloat(0.0), y: CGFloat(0.0)))
        path.closeSubpath()
        shapeNode.fillColor = color
        shapeNode.lineWidth = 1.0
        shapeNode.strokeColor = SKColor.black
        shapeNode.path = path
        shapeNode.zPosition = 5.0
        super.init()
        registerListener(shapeNode)
    }
    
    var direction: CGFloat = CGFloat(0.0){
        didSet {
            self.shapeNode.zRotation = direction
        }
    }
    

}

