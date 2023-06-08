//
//  GameScene.swift
//  Catan
//
//  Created by Ion Plamadeala on 06/06/2023.
//


enum ColorScheme {
    
    static let grassGreen = SKColor(red: CGFloat(83.0/255.0), green: CGFloat(130.0/255.0), blue: CGFloat(75.0/255.0), alpha: CGFloat(1.0))
    static let warmWoodBrown = SKColor(red: CGFloat(136.0/255.0), green: CGFloat(84.0/255.0), blue: CGFloat(24.0/255.0), alpha: CGFloat(1.0))
    static let stoneGray = SKColor(red: CGFloat(121.0/255.0), green: CGFloat(121.0/255.0), blue: CGFloat(121.0/255.0), alpha: CGFloat(1.0))
    static let brickRed = SKColor(red: CGFloat(174.0/255.0), green: CGFloat(32.0/255.0), blue: CGFloat(36.0/255.0), alpha: CGFloat(1.0))
    static let wheatYellow = SKColor(red: CGFloat(244.0/255.0), green: CGFloat(201.0/255.0), blue: CGFloat(95.0/255.0), alpha: CGFloat(1.0))
    static let desertSand = SKColor(red: CGFloat(225.0/255.0), green: CGFloat(169.0/255.0), blue: CGFloat(95.0/255.0), alpha: CGFloat(1.0))

    static let mapBorder = SKColor(red: CGFloat(51.0/255.0), green: CGFloat(51.0/255.0), blue: CGFloat(51.0/255.0), alpha: CGFloat(1.0))

    
    static let color1 = SKColor(red: CGFloat(0.0/255.0), green: CGFloat(112.0/255.0), blue: CGFloat(110.0/255.0), alpha: CGFloat(1.0))
    static let color2 = SKColor(red: CGFloat(255.0/255.0), green: CGFloat(99.0/255.0), blue: CGFloat(71.0/255.0), alpha: CGFloat(1.0))
    static let color3 = SKColor(red: CGFloat(98.0/255.0), green: CGFloat(44.0/255.0), blue: CGFloat(168.0/255.0), alpha: CGFloat(1.0))
    static let color4 = SKColor(red: CGFloat(218.0/255.0), green: CGFloat(165.0/255.0), blue: CGFloat(32.0/255.0), alpha: CGFloat(1.0))


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
        sprite.xScale = CGFloat(48.0/512.0)
        sprite.yScale = CGFloat(48.0/512.0)
        sprite.color = color
        sprite.colorBlendFactor = 1
    }
    
    func placeAt(point: CGPoint) {
        sprite.position = point
        sprite.zPosition = 15
    }
    
    func attachTo(scene: SKScene) {
        scene.addChild(sprite)
    }
    
}

class Road {
    
    var shapeNode: SKShapeNode
    
    init(color: SKColor) {
        shapeNode = SKShapeNode()
        let path = CGMutablePath()
        let width = CGFloat(38)
        let height = CGFloat(8)
        let delta = CGFloat(5.0 )
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
//        shapeNode.lineWidth = 2.0
        
        shapeNode.path = path
    }
    
    func attachTo(scene: SKScene) {
        scene.addChild(self.shapeNode)
    }
    
    func placeAt(point: CGPoint, direction: CGFloat) {
        shapeNode.position = point
        shapeNode.zPosition = 10
        shapeNode.zRotation = direction
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
    var roads: [Road?] = [nil, nil, nil, nil, nil, nil]

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
                corner?.attachTo(scene: scene)
            }
            for road in roads {
                road?.attachTo(scene: scene)
            }
            self.scene = scene
        }
    }
    
    private func pointCoords(index: CGFloat) -> CGPoint {
        let angle = index * (2.0 * CGFloat.pi / 6.0)
        let x = (radius+1.5) * cos(angle)
        let y = (radius+1.5) * sin(angle)
        return CGPoint(x: x, y: y)
    }
    
    func addBuilding(building: Building, corner: CGFloat) {
        corners[Int(corner)] = building
        var newPostion = pointCoords(index: corner)
        newPostion.x += self.shapeNode!.position.x
        newPostion.y += self.shapeNode!.position.y + CGFloat(6.0)
        building.placeAt(point:newPostion)
        if scene != nil {
            building.attachTo(scene: scene!)
        }
    }
    
    func placeAt(q: CGFloat, r: CGFloat, c: CGFloat) {
        cq = q
        cr = r
        cc = c
        
        x = (radius + 1.5) * CGFloat(3.0)/2 * CGFloat(cq)
        y = (radius + 1.5) * (sqrt3/2 * cq  + sqrt3 * cr)
        shapeNode?.position = CGPoint(x:x, y:y)
        icon.position = CGPoint(x: x, y: y)
    }
    
    func addRoad(corner: Int, color: SKColor) {
        let road = Road(color:color)
        roads[corner] = road
        if scene != nil {
            road.attachTo(scene: self.scene!)
        }
        var newPosition = pointCoords(index: CGFloat(corner))
        newPosition.x += self.shapeNode!.position.x
        newPosition.y += self.shapeNode!.position.y
        road.placeAt(point:newPosition, direction:(CGFloat.pi / 3) * CGFloat(2+corner))
    }
    
    
}



class Map {
    
    var map = [Int: [Int: Hex]]()
    let radius = CGFloat(75.0)
    
    init() {
        
        var color: [SKColor] = [
            ColorScheme.color1,
            ColorScheme.color2,
            ColorScheme.color3,
            ColorScheme.color4,
        ]
        
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
                newHex.addRoad(corner: 0, color: color[Int.random(in: 0...color.count-1)])
                newHex.addRoad(corner: 1, color: color[Int.random(in: 0...color.count-1)])
                newHex.addRoad(corner: 2, color: color[Int.random(in: 0...color.count-1)])
                resources.remove(at: colorIndex)
            }
            map[q]=row
        }
        
        map[0]?[0]?.addBuilding(building: Building(color: ColorScheme.color1), corner: CGFloat(0.0))
        map[0]?[0]?.addBuilding(building: Building(color: ColorScheme.color2), corner: CGFloat(1.0))
        map[0]?[0]?.addBuilding(building: Building(color: ColorScheme.color3), corner: CGFloat(2.0))
        map[0]?[0]?.addBuilding(building: Building(color: ColorScheme.color4), corner: CGFloat(3.0))
//        map[0]?[0]?.addBuilding(building: Building(color: SKColor.red), corner: CGFloat(1.0))
//        map[0]?[0]?.addBuilding(building: Building(color: SKColor.yellow), corner: CGFloat(2.0))
//        map[0]?[0]?.addBuilding(building: Building(color: SKColor.red), corner: CGFloat(3.0))
//        map[0]?[0]?.addBuilding(building: Building(color: SKColor.red), corner: CGFloat(4.0))
        
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
