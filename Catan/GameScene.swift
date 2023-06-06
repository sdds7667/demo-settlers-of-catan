//
//  GameScene.swift
//  Catan
//
//  Created by Ion Plamadeala on 06/06/2023.
//


enum ColorScheme {
    static let grassGreen = SKColor(red: CGFloat(34.0/255.0), green: CGFloat(139.0/255.0), blue: CGFloat(34.0/255.0), alpha: (1.0))
    static let gold = SKColor(red: CGFloat(255.0/255.0), green: CGFloat(215.0/255.0), blue: CGFloat(0.0/255.0), alpha: CGFloat(1.0))
    static let mapBorder = SKColor.black
    static let forestGreen = SKColor(red:CGFloat(0.0),green:CGFloat(85.0/255.0),blue:CGFloat(23.0/255.0),alpha: CGFloat(1.0))
    static let sandYellow = SKColor(red: CGFloat(210.0/255.0), green: CGFloat(170.0/255.0), blue: CGFloat(109.0/255.0), alpha: (1.0))
    static let wheatYellow = SKColor(red: CGFloat(248.0/255.0), green: CGFloat(180.0/255.0), blue: CGFloat(35.0/255.0), alpha: (1.0))
}

enum Resource: String {
    case wheat = "wheat"
    case brick = "bricks"
    case stone = "coal"
    case sheep = "sheep"
    case wood = "wood"
    case desert = "cactus"
}

enum BuildingType: String {
    case village = "village"
    case city = "city"
}

import SpriteKit
import GameplayKit
let sqrt3 = CGFloat(3.0).squareRoot()

class Building {
    var sprite: SKSpriteNode
    
    init(color: SKColor) {
        sprite = SKSpriteNode(imageNamed: BuildingType.village.rawValue)
        sprite.xScale = CGFloat(64.0/512.0)
        sprite.yScale = CGFloat(64.0/512.0)
        sprite.color = color
        sprite.colorBlendFactor = 1
    }
    
    func placeAt(point: CGPoint) {
        sprite.position = point
    }
    
    func attachTo(scene: SKScene) {
        scene.addChild(sprite)
    }
    
}

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
    
    var corners : [Building?] = [nil, nil, nil, nil, nil, nil]
    
    private var cq: CGFloat = 0.0
    private var cr: CGFloat = 0.0
    private var cc: CGFloat = 0.0
    private var radius: CGFloat = 100.0
    private var x: CGFloat = 0.0
    private var y: CGFloat = 0.0
    private var resource: Resource
    private var scene: SKScene? = nil
    
    init(resource: Resource) {
        shapeNode = SKShapeNode()
        self.resource = resource
        
        self.icon = SKSpriteNode(imageNamed: resource.rawValue)
       
        self.icon.xScale = radius/(CGFloat(512) * 1.5)
        self.icon.yScale = radius/(CGFloat(512) * 1.5)
        
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
        shapeNode?.path = path
        shapeNode?.strokeColor = ColorScheme.mapBorder
        shapeNode?.lineWidth = 2.0
        
        switch (resource) {
            
        case .wheat:
            shapeNode?.fillColor = ColorScheme.wheatYellow
        case .brick:
            shapeNode?.fillColor = SKColor.red
        case .stone:
            shapeNode?.fillColor = SKColor.gray
        case .wood:
            shapeNode?.fillColor = ColorScheme.forestGreen
        case .sheep:
            shapeNode?.fillColor = ColorScheme.grassGreen
        case .desert:
            shapeNode?.fillColor = ColorScheme.sandYellow
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
                corner?.attachTo(scene: scene)
            }
            self.scene = scene
        }
    }
    
    private func pointCoords(index: CGFloat) -> CGPoint {
        let angle = index.truncatingRemainder(dividingBy: 6) * (2.0 * CGFloat.pi / 6.0)
        let x = radius * cos(angle)
        let y = radius * sin(angle)
        return CGPoint(x: x, y: y)
    }
    
    func addBuilding(building: Building, corner: CGFloat) {
        corners[Int(corner)] = building
        var newPostion = pointCoords(index: corner)
        newPostion.x += self.shapeNode!.position.x
        newPostion.y += self.shapeNode!.position.y
        building.placeAt(point:newPostion)
        if scene != nil {
            building.attachTo(scene: scene!)
        }
    }
    
    func placeAt(q: CGFloat, r: CGFloat, c: CGFloat) {
        cq = q
        cr = r
        cc = c
        
        x = radius * CGFloat(3.0)/2 * CGFloat(cq)
        y = radius * (sqrt3/2 * cq  + sqrt3 * cr)
        shapeNode?.position = CGPoint(x:x, y:y)
        icon.position = CGPoint(x: x, y: y)
    }
    
    
    
}



class Map {
    
    var map = [Int: [Int: Hex]]()
    let radius = CGFloat(75.0)
    
    init() {
        
        
        var resources : [Resource] = [
            .wheat, .wheat, .wheat, .wheat,
            .wood, .wood, .wood, .wood,
            .sheep, .sheep, .sheep, .sheep,
            .brick, .brick, .brick,
            .stone, .stone, .stone,
            .desert
        ]
        for q in -2...2 {
            var row = [Int: Hex]()
            for r in max(-2,-q-2)...min(2,-q+2) {
                let colorIndex = Int.random(in: 0...resources.count-1)
                let newHex = Hex(resource: resources[colorIndex])
                row[r]=newHex
                newHex.build(radius: radius)
                newHex.placeAt(q: CGFloat(q), r: CGFloat(r), c: CGFloat(0-r-q))
                resources.remove(at: colorIndex)
            }
            map[q]=row
        }
        
        map[0]?[0]?.addBuilding(building: Building(color: SKColor.white), corner: CGFloat(0.0))
        map[0]?[0]?.addBuilding(building: Building(color: SKColor.red), corner: CGFloat(1.0))
        map[0]?[0]?.addBuilding(building: Building(color: SKColor.yellow), corner: CGFloat(2.0))
        map[0]?[0]?.addBuilding(building: Building(color: SKColor.red), corner: CGFloat(3.0))
        map[0]?[0]?.addBuilding(building: Building(color: SKColor.red), corner: CGFloat(4.0))
    }
    
    public func attachTo(scene: SKScene) {
        for (_, row) in map {
            for (_, hex) in row {
                hex.attachTo(scene: scene)
            }
        }
    }
}



class GameScene: SKScene {
    
    var map: Map = Map()
    
    
    
    override func didMove(to view: SKView) {
        print("Starting the scene")
        map.attachTo(scene: self)
    }
   
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
