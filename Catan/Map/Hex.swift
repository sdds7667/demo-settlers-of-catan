//
//  Hex.swift
//  Catan
//
//  Created by Ion Plamadeala on 12/06/2023.
//

import Foundation
import SpriteKit

let sqrt3=CGFloat(sqrt(3.0))

class Hex {
    
    var shapeNode: SKShapeNode? = nil
    var icon: SKSpriteNode
    var color: NSColor? {
        set{
            if (newValue != nil) {
                shapeNode?.fillColor = newValue!
            }
        }
        get {
            return shapeNode?.fillColor
        }
    }
    
    private var axialCoordinates: CGPoint? = nil
    
    /**
     Represents the q and r coordinates of the hex in axial coordinates.
     */
    var position: CGPoint? {
        set {
            axialCoordinates = newValue
            newValue.map(placeAt)
        }
        get {
            return axialCoordinates
        }
    }
    
    
    var corners : [HexCorner?] = [nil, nil, nil, nil, nil, nil]
    var roads: [HexEdge?] = [nil, nil, nil, nil, nil, nil]
    
    private var radius: CGFloat = 50
    private var resource: Resource
    private var scene: SKScene? = nil
    
    private var _number: Int?
    private var _number_node: HexNumberNode?
    var number: Int? {
        set {
            _number = newValue
            scene.map({scene in
                newValue.map{nv in
                    _number_node = HexNumberNode(num: nv, size: radius)
                    let ownPosition = self.shapeNode!.position
                    let numberPosition = CGPoint(x: ownPosition.x , y: ownPosition.y - CGFloat(radius * 30.0/75.0) )
                    _number_node?.position = numberPosition
                    _number_node?.attachTo(scene: scene)
                }
            })
        }
        get {
            return _number
        }
        
    }
    
    init(resource: Resource) {
        shapeNode = SKShapeNode()
        self.resource = resource
        self.icon = SKSpriteNode(imageNamed: resource.rawValue)
    }
    
    
    
    func build(radius: CGFloat) {
        let path = CGMutablePath()
        for i in 0..<6 {
            let angle = CGFloat(i) * (2.0 * CGFloat.pi / 6.0)
            let x = radius * cos(angle)
            let y = radius * sin(angle)
            let point = CGPoint(x: x, y: y)
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        self.icon.xScale = (100/(CGFloat(512) * 1.5) / 75.0) * radius
        self.icon.yScale = (100/(CGFloat(512) * 1.5) / 75.0) * radius
        shapeNode?.path = path
        shapeNode?.strokeColor = ColorScheme.mapBorder
        shapeNode?.lineWidth = 5
        
        switch (resource) {
            
        case .wheat:
            shapeNode?.fillColor = ColorScheme.wheatYellow
        case .brick:
            shapeNode?.fillColor = ColorScheme.brickRed
        case .stone:
            shapeNode?.fillColor = ColorScheme.stoneGray
        case .wood:
            shapeNode?.fillColor = ColorScheme.warmWoodBrown
        case .sheep:
            shapeNode?.fillColor = ColorScheme.grassGreen
        case .desert:
            shapeNode?.fillColor = ColorScheme.desertSand
        }
        self.radius = radius
        self.scene?.addChild(shapeNode!)
        self.scene?.addChild(icon)
    }
    
    func attachTo(scene: SKScene) {
        if shapeNode != nil {
            scene.addChild(shapeNode!)
            scene.addChild(icon)
            for corner in corners {
                corner?.scene = scene
            }
            for road in roads {
                road?.scene = scene
            }
            self.scene = scene
            self.number = self._number
        }
    }
    
    public func cornerPosition(index: CGFloat) -> CGPoint {
        let angle = index * (2.0 * CGFloat.pi / 6.0)
        let x = (radius+1.5) * cos(angle)
        let y = (radius+1.5) * sin(angle)
        
        let viewPosition = shapeNode?.position
        if (viewPosition == nil) {
            return CGPoint(x:  x, y: y)
        } else {
            return CGPoint(x: viewPosition!.x + x, y: viewPosition!.y + y)
        }
    }
    
    

    private func placeAt(axialCoordinates: CGPoint) {
        let cq = axialCoordinates.x
        let cr = axialCoordinates.y
        let x = (radius + 1.5) * CGFloat(3.0)/2 * cq
        let y = (radius + 1.5) * (sqrt3/2 * cq  + sqrt3 * cr)
        shapeNode?.position = CGPoint(x:x, y:y-radius * (20.0/75.0))
        icon.position = CGPoint(x: x, y: y)
    }

    
}
