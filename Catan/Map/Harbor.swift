//
//  Harbor.swift
//  Catan
//
//  Created by Ion Plamadeala on 16/06/2023.
//

import Foundation
import SpriteKit

enum Harbor {
    case twoToOne(resource: Resource)
    case threeToOne
}

class HarborNode: SceneNode {
    var icon: SKSpriteNode? = nil
//    var label: SKLabelNode
//    var rateLabel: SKLabelNode
    let harbor: Harbor
    
    init(harbor: Harbor) {
        self.harbor = harbor
        switch(harbor) {
        case .twoToOne(let resource):
            self.icon = SKSpriteNode(imageNamed: resource.rawValue)
            self.icon?.xScale = 0.05
            self.icon?.yScale = 0.05
//            rateLabel = SKLabelNode(text: "2")
        case .threeToOne:
            self.icon = SKSpriteNode(imageNamed: "help")
            self.icon?.xScale = 0.05
            self.icon?.yScale = 0.05
//            rateLabel = SKLabelNode(text: "3")
        }
        super.init()
        if icon != nil {
            registerListener(self.icon!)
        }
//        label = SKLabelNode(text: ": 1")
//        label.fontSize = 18
//        label.verticalAlignmentMode = .center
//
//
//        super.init()
//        rateLabel.fontSize = 18
//        rateLabel.verticalAlignmentMode = .center
//        switch(harbor) {
//        case .twoToOne(_):
//            self.registerListener(rateLabel, delta: CGPoint(x: -30.0, y: 0.0))
//        case .threeToOne:
//            self.registerListener(rateLabel, delta: CGPoint(x: -5.0, y: 0.0))
//
//        }
//        if (self.icon != nil) {
//            self.registerListener(self.icon!, delta: (CGPoint(x: -10.0, y: 0.0)))
//        }
//        self.registerListener(label, delta: CGPoint(x: +15, y: 0.0))
        
    }
}
