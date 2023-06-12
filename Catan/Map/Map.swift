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
    var selectedCorner: HexCorner? = nil
    
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
        for q in -2...2 {
            var row = [Int: Hex]()
            for r in max(-2,-q-2)...min(2,-q+2) {
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
    
    public func handleClick(position: CGPoint) {
        for corner in corners {
            if (corner.containsPoint(point: position)) {
                corner.building = Building(color: color[Int.random(in: 0..<color.count)], size: radius)
                return
            }
        }
        
        for edge in edges {
            if edge.containsPoint(point: position) {
                edge.road = Road(color: color[Int.random(in: 0..<color.count)], size: radius)
                return
            }
        }
    }
}
