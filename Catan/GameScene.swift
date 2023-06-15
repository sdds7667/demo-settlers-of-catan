//
//  GameScene.swift
//  Catan
//
//  Created by Ion Plamadeala on 06/06/2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var map: Map? = nil
    var controller: GameController? = nil
    var lastCorner: HexCorner? = nil
    
    override func didMove(to view: SKView) {
        print("Starting the scene")
        map = Map()
        controller = GameController(map: map!)
        map?.attachTo(scene: self)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
    override func mouseUp(with event: NSEvent) {
        if event.type == .leftMouseUp {
            if let corner = map?.handleCornerClick(position: event.location(in: self)) {
                controller?.handleCornerClick(corner: corner)
                return
            }
            if let edge = map?.handleEdgeClick(position: event.location(in: self)) {
                controller?.handleEdgeClick(edge: edge)
                return
            }
        }
    }
}
