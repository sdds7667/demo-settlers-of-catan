//
//  Map.swift
//  Catan
//
//  Created by Ion Plamadeala on 12/06/2023.
//

import Foundation
import Cocoa
import SpriteKit

let color: [SKColor] = [
    ColorScheme.color1,
    ColorScheme.color2,
    ColorScheme.color3,
    ColorScheme.color4,
]

class Map {
    
    var map = [Int: [Int: Hex]]()
    var edges: [HexEdge] = []
    var corners: [HexCorner] = []
    var harborPathways: [SKShapeNode] = []
    var harbors: [HarborNode] = []
    var selectedCorner: HexCorner? = nil
    var showsGuides = false
    
    let radius = CGFloat(50.0)
    
    init() {
        
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
        
        let mapRadius = 2
        
        for q in -mapRadius...mapRadius {
            var row = [Int: Hex]()
            for r in max(-mapRadius,-q-mapRadius)...min(mapRadius,-q+mapRadius) {
                
                let distance = max(abs(q), max(abs(r), abs(-q-r)))
                if (distance == 3) {
                    let newHex = Hex(resource: .water)
                    row[r] = newHex
                    newHex.build(radius: radius)
                    newHex.position = CGPoint(x: CGFloat(q), y: CGFloat(r))
                    continue
                }
                
                let colorIndex = Int.random(in: 0...resources.count-1)
                let newHex = Hex(resource: resources[colorIndex])
                
                
                row[r] = newHex
                newHex.build(radius: radius)
                newHex.position = CGPoint(x: CGFloat(q), y: CGFloat(r))
                if (resources[colorIndex] != .desert) {
                    let numberIndex = Int.random(in: 0..<numbers.count)
                    newHex.number = numbers[numberIndex]
                    numbers.remove(at: numberIndex)
                }
                resources.remove(at: colorIndex)
            }
            map[q] = row
            
        }
        
        var isHarbor = true
        var directions = [2, 1, 1,0,5,5,4,3,3].makeIterator()
        var rate: [Harbor] = [
            .threeToOne,
            .threeToOne,
            .threeToOne,
            .threeToOne,
            .twoToOne(resource: .brick),
            .twoToOne(resource: .stone),
            .twoToOne(resource: .wood),
            .twoToOne(resource: .sheep),
            .twoToOne(resource: .wheat)
        ]
        let path = CGMutablePath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: radius/2, y: 0.0))
        
        for hex in self.get_cube_ring(radius: 3) {
            if !isHarbor {
                isHarbor = true
                continue
            }
            isHarbor = false
            let dir = directions.next()!
            
            
            let skShapeNode = SKShapeNode(path: path)
            skShapeNode.position = Hex.positionFor(axialCoordinates: hex, radius: radius-0.5) + Hex.cornerPosition(index: CGFloat(dir), radius: radius-0.5)
            skShapeNode.zRotation = CGFloat((((dir + 3) % 6) * 60)) * CGFloat.pi / 180
            skShapeNode.lineWidth = 4.5
            skShapeNode.strokeColor = ColorScheme.mapBorder
            skShapeNode.zPosition = 0.0
            harborPathways.append(skShapeNode)
            
            let sk2 = SKShapeNode(path: path)
            sk2.position = Hex.positionFor(axialCoordinates: hex, radius: radius-0.5) + Hex.cornerPosition(index: CGFloat((dir+1)%6), radius: radius-0.5)
            sk2.zRotation = CGFloat((((dir + 4) % 6) * 60)) * CGFloat.pi / 180
            sk2.lineWidth = 4.5
            sk2.strokeColor = ColorScheme.mapBorder
            sk2.zPosition = 0.0
            harborPathways.append(sk2)
            
            let harborIndex = Int.random(in: 0..<rate.count)
            let harbor = HarborNode(harbor: rate[harborIndex])
            harbor.position = Hex.positionFor(axialCoordinates: hex, radius: radius-1.3)
            rate.remove(at: harborIndex)
            harbors.append(harbor)
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
            [edgeAdj[0], edgeAdj[5]],
            [edgeAdj[5], edgeAdj[4]],
            [edgeAdj[4], edgeAdj[3]],
            [edgeAdj[3], edgeAdj[2]],
            [edgeAdj[2], edgeAdj[1]],
            [edgeAdj[1], edgeAdj[0]]
        ]
        
        
        var hexId = 0
        
        for q in -2...2 {
            for r in max(-2,-q-2)...min(2,-q+2) {
                let hex: Hex = map[q]![r]!
                hexId+=1
                for (ind, corner) in hex.corners.enumerated() {
                    
                    if (corner == nil) {
                        let newCorner = HexCorner()
                        corners.append(newCorner)
                        hex.corners[ind] = newCorner
                        
                        let q1 = q + cornerAdj[ind][0].0
                        let r1 = r + cornerAdj[ind][0].1
                        let n1 = map[q1]?[r1]
                        n1?.corners[ (ind+2) % 6 ] = newCorner
                        
                        
                        let q2 = q + cornerAdj[ind][1].0
                        let r2 = r + cornerAdj[ind][1].1
                        let n2 = map[q2]?[r2]
                        n2?.corners[ (ind+4) % 6 ] = newCorner
                        
                        
                        newCorner.position = hex.cornerPosition(index: CGFloat(ind))
                    }
                }
                
                for (ind, edge) in hex.roads.enumerated() {
                    
                    if (edge == nil) {
                        let newEdge = HexEdge(direction: CGFloat(ind))
                        edges.append(newEdge)
                        hex.roads[ind] = newEdge
                        let qa = q + edgeAdj[5 - ind].0
                        let ra = r + edgeAdj[5 - ind].1
                        map[qa]?[ra]?.roads[(ind+3) % 6] = newEdge
                        newEdge.position = hex.cornerPosition(index: CGFloat(ind))
                        hex.corners[ind]!.neighbourRoads.append(newEdge)
                        hex.corners[(ind + 1) % 6]!.neighbourRoads.append(newEdge)
                        newEdge.neighbourCorner.append(hex.corners[ind]!)
                        newEdge.neighbourCorner.append(hex.corners[(ind + 1) % 6]!)
                    }
                }
            }
        }
        
        
    }
    
    public func showGuides() {
        if showsGuides {
            return
        }
        showsGuides = true
        for corner in corners {
            if (corner.isValidBuildingPosition()) {
                corner.guide = true
            }
        }
    }
    
    public func hideGuides() {
        if !showsGuides {
            return
        }
        showsGuides = false
        for corner in corners {
            corner.guide = false
        }
    }
    
    public func hideRoadGuides() {
        for edge in edges {
            edge.guide = false
        }
    }
    
    
    
    public func attachTo(scene: SKScene) {
        for (_, row) in map {
            for (_, hex) in row {
                hex.attachTo(scene: scene)
            }
        }
        
        for harborPathway in harborPathways {
            scene.addChild(harborPathway)
        }
        
        for harbor in harbors {
            harbor.scene = scene
        }
        
    }
    
    
    public func handleCornerClick(position: CGPoint) -> HexCorner? {
        for corner in corners {
            if (corner.containsPoint(point: position)) {
                return corner
            }
        }
        return nil
    }
    
    public func handleEdgeClick(position: CGPoint) -> HexEdge? {
        for edge in edges {
            if edge.containsPoint(point: position) {
                return edge
            }
        }
        return nil
    }
    
    
    /*
     function cube_scale(hex, factor):
     return Cube(hex.q * factor, hex.r * factor, hex.s * factor)
     
     function cube_ring(center, radius):
     var results = []
     # this code doesn't work for radius == 0; can you see why?
     var hex = cube_add(center,
     cube_scale(cube_direction(4), radius))
     for each 0 ≤ i < 6:
     for each 0 ≤ j < radius:
     results.append(hex)
     hex = cube_neighbor(hex, i)
     return results
     */
    func get_cube_ring(radius: Int) -> [CGPoint] {
        var results: [CGPoint] = []
        var hex = CGPoint(x: +3, y: -3)
        
        
        for i in 0..<6 {
            for j in 0..<radius {
                results.append(hex)
                hex = hex.hexNeighbour(direction: (i + 2))
            }
        }
        
        
        return results
    }
    
    
}
