//
//  GameScene.swift
//  Catan
//
//  Created by Ion Plamadeala on 06/06/2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var map: Map = Map()
    
    override func didMove(to view: SKView) {
        print("Starting the scene")
        map.attachTo(scene: self)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
    override func mouseUp(with event: NSEvent) {
        if event.type == .leftMouseUp {
            map.handleClick(position: event.location(in: self))
            
        }
    }
}
