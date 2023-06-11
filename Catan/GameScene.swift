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
    
    init(color: SKColor, size: CGFloat) {
        sprite = SKSpriteNode(imageNamed: BuildingType.village.rawValue)
        sprite.xScale = CGFloat(size * (48.0/512.0) / 75.0)
        sprite.yScale = CGFloat(size * (48.0/512.0) / 75.0)
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
    
    init(color: SKColor, size: CGFloat) {
        shapeNode = SKShapeNode()
        let path = CGMutablePath()
        // old: 75 -> 38
        
        let width = CGFloat(size * 38.0/75.0)
        let height = CGFloat(size * 8.0/75.0)
        let delta = CGFloat(size * 4.5/75.0)
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

class HexEdge {
    private var size: CGFloat = 50.0;
    private var _position: CGPoint = CGPoint(x: 0.0, y: 0.0);
    private var neighbourEdges: [CGFloat: HexCorner] = [CGFloat: HexCorner]()
    private var road: Road? = nil
    private var _scene: SKScene? = nil
    
    var scene: SKScene? {
        set {
            if (newValue == nil) {
                return
            }
            _scene = newValue
            road?.attachTo(scene: newValue!)
        }
        
        get {
            return _scene
        }
        
    }
    
}

class HexCorner {
    private var size: CGFloat = 50.0
    private var building: Building? = nil
    var neighbourRoads: [CGFloat: HexEdge] = [CGFloat: HexEdge]()
    
    private var _scene: SKScene? = nil
    
    public var scene: SKScene? {
        set {
            if (newValue == nil) {
                return
            }
            _scene = newValue
            building?.attachTo(scene: newValue!)
        }
        
        get {
            return _scene
        }
        
    }
}

class HexNumberNode {
    
    private var circleShape: SKShapeNode
    private var number: SKLabelNode
    
    var _position: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var position: CGPoint {
        set{
            _position = newValue
            self.circleShape.position = newValue
            self.number.position = newValue
        }
        get{
            return _position
        }
    }
    
    init(num: Int, size: CGFloat ) {
        circleShape = SKShapeNode(circleOfRadius: size * 25.0/75.0)
        circleShape.zPosition = 1
        circleShape.fillColor = ColorScheme.mapBorder
        circleShape.strokeColor = ColorScheme.mapBorder
        number = SKLabelNode(text: "\(num)")
        number.zPosition = 2
        number.verticalAlignmentMode = .center
        number.horizontalAlignmentMode = .center
        number.fontSize = 32.0/75.0 * size
    }
    
    func attachTo(scene: SKScene) {
        scene.addChild(self.circleShape)
        scene.addChild(self.number)
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
    
    private func pointCoords(index: CGFloat) -> CGPoint {
        let angle = index * (2.0 * CGFloat.pi / 6.0)
        let x = (radius+1.5) * cos(angle)
        let y = (radius+1.5) * sin(angle)
        return CGPoint(x: x, y: y)
    }
    
    //    func addBuilding(building: Building, corner: CGFloat) {
    //        corners[Int(corner)] = building
    //        var newPostion = pointCoords(index: corner)
    //        newPostion.x += self.shapeNode!.position.x
    //        newPostion.y += self.shapeNode!.position.y + CGFloat(6.0)
    //        building.placeAt(point:newPostion)
    //        if scene != nil {
    //            building.attachTo(scene: scene!)
    //        }
    //    }
    //
    private func placeAt(axialCoordinates: CGPoint) {
        let cq = axialCoordinates.x
        let cr = axialCoordinates.y
        let x = (radius + 1.5) * CGFloat(3.0)/2 * cq
        let y = (radius + 1.5) * (sqrt3/2 * cq  + sqrt3 * cr)
        shapeNode?.position = CGPoint(x:x, y:y-radius * (20.0/75.0))
        icon.position = CGPoint(x: x, y: y)
    }
    
    //    func addRoad(corner: Int, color: SKColor) {
    //        let road = Road(color:color, size: radius)
    //        roads[corner] = road
    //        if scene != nil {
    //            road.attachTo(scene: self.scene!)
    //        }
    //        var newPosition = pointCoords(index: CGFloat(corner))
    //        newPosition.x += self.shapeNode!.position.x
    //        newPosition.y += self.shapeNode!.position.y
    //        road.placeAt(point:newPosition, direction:(CGFloat.pi / 3) * CGFloat(2+corner))
    //    }
    
    
}





class Map {
    
    var map = [Int: [Int: Hex]]()
    let radius = CGFloat(50.0)
    
    init() {
        
        let color: [SKColor] = [
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
        
        var numbers : [Int] = [
            2, 12, 3, 3, 4, 4, 5, 5, 6, 6, 8, 8, 9, 9, 10, 10, 11, 11
        ]
        for q in -2...2 {
            var row = [Int: Hex]()
            for r in max(-2,-q-2)...min(2,-q+2) {
                let colorIndex = Int.random(in: 0...resources.count-1)
                let newHex = Hex(resource: resources[colorIndex])
                
                
                row[r] = newHex
                newHex.build(radius: radius)
                newHex.position = CGPoint(x: CGFloat(q), y: CGFloat(r))
                //                newHex.addRoad(corner: 0, color: color[Int.random(in: 0...color.count-1)])
                //                newHex.addRoad(corner: 1, color: color[Int.random(in: 0...color.count-1)])
                //                newHex.addRoad(corner: 2, color: color[Int.random(in: 0...color.count-1)])
                if (resources[colorIndex] != .desert) {
                    let numberIndex = Int.random(in: 0..<numbers.count)
                    newHex.number = numbers[numberIndex]
                    numbers.remove(at: numberIndex)
                }
                resources.remove(at: colorIndex)
            }
            map[q] = row
            
        }
        
        
        let edgeAdj: [(Int, Int)] = [
            (+1, -1),
            (0, -1),
            (-1,  0),
            (-1, +1),
            (0, +1),
            (+1, 0)
        ]
        
        let cornerAdj: [[(Int, Int)]] = [
            [edgeAdj[5], edgeAdj[0]],
            [edgeAdj[0], edgeAdj[1]],
            [edgeAdj[1], edgeAdj[2]],
            [edgeAdj[2], edgeAdj[3]],
            [edgeAdj[3], edgeAdj[4]],
            [edgeAdj[4], edgeAdj[5]]
        ]
        
        
        
        for q in -2...2 {
            for r in max(-2,-q-2)...min(2,-q+2) {
                let hex: Hex = map[q]![r]!
                for (ind, corner) in hex.corners.enumerated() {
                    if (corner == nil) {
                        let newCorner = HexCorner()
                        hex.corners[ind] = newCorner
                        
                        let q1 = q + cornerAdj[ind][0].0
                        let r1 = r + cornerAdj[ind][0].1
                        let n1 = map[q1]?[r1]
                        n1?.corners[ (ind+2) % 6 ] = newCorner
                        
                        let q2 = q + cornerAdj[ind][1].0
                        let r2 = r + cornerAdj[ind][1].1
                        let n2 = map[q2]?[r2]
                        n2?.corners[ (ind+4) % 6 ] = newCorner
                    }
                }
                for (ind, edge) in hex.roads.enumerated() {
                    if (edge == nil) {
                        let newEdge = HexEdge()
                        hex.roads[ind] = newEdge
                        let qa = q + edgeAdj[ind].0
                        let ra = r + edgeAdj[ind].1
                        map[qa]?[ra]?.roads[(ind+3) % 6] = newEdge
                    }
                }
            }
        }
        
        
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
