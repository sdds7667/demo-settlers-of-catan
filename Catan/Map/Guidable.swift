//
//  File.swift
//  Catan
//
//  Created by Ion Plamadeala on 15/06/2023.
//

import Foundation
import SpriteKit

class GuidableNode: SceneNode, Equatable {
    
    
    private var circle: SKShapeNode
    private var guideRadius: CGFloat
    private var id: UUID
    
    init(guideRadius: CGFloat) {
        circle = SKShapeNode(circleOfRadius: guideRadius)
        self.guideRadius = guideRadius
        self.id = UUID.init()
        super.init()
        initialize(guideOffset: .zero)
    }
    
    init(guideRadius: CGFloat, guideOffset: CGPoint) {
        circle = SKShapeNode(circleOfRadius: guideRadius)
        circle.strokeColor = .clear
        circle.zPosition = 20
        self.guideRadius = guideRadius
        self.id = UUID.init()
        super.init()
        initialize(guideOffset: guideOffset)
    }
    
    func initialize(guideOffset: CGPoint) {
        circle.strokeColor = .clear
        circle.zPosition = 20
        self.registerListener(circle, delta: guideOffset)
    }
    
    
    public var guide: Bool = false {
        didSet {
            circle.strokeColor = (guide ? .white : .clear)
        }
    }
    
    public func containsPoint(point: CGPoint) -> Bool {
        return self.circle.position.distanceTo(other: point) < self.guideRadius
    }
    
    static func == (lhs: GuidableNode, rhs: GuidableNode) -> Bool {
        return lhs.id == rhs.id
    }
}
