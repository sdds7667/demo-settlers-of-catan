//
//  HexEdge.swift
//  Catan
//
//  Created by Ion Plamadeala on 12/06/2023.
//

import Foundation
import SpriteKit


class HexEdge: GuidableNode {
    
    
    private var size: CGFloat = 50.0;
    var neighbourCorner : [HexCorner] = [HexCorner]()
    private var direction: CGFloat
    private var circleRadius: CGFloat = 11.0
    var road: Road? {
        didSet {
            if road == nil {
                return
            }
            registerListener(road!)
            road?.direction = direction
        }
        
    }
    
    init(direction: CGFloat) {
       
        self.direction =  (direction + 2) * (CGFloat.pi * 2 / 6)
        super.init(guideRadius: circleRadius, guideOffset: CGPoint(x: cos(self.direction) * size/2, y: sin(self.direction) * size/2))
    }

}
