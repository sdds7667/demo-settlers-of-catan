//
//  HexCorner.swift
//  Catan
//
//  Created by Ion Plamadeala on 12/06/2023.
//

import Foundation
import SpriteKit

class HexCorner: GuidableNode {
    private var size: CGFloat = 50.0
    var neighbourRoads: [HexEdge] = [HexEdge]()
    private var _neighbors: [HexCorner]? = nil
    private var neighbors: [HexCorner] {
        get {
            if self._neighbors == nil {
                self._neighbors = []
                for road in neighbourRoads {
                    if self == road.neighbourCorner[0] {
                        self._neighbors!.append(road.neighbourCorner[1])
                    } else {
                        self._neighbors!.append(road.neighbourCorner[0])
                    }
                }
                return self._neighbors!
            }
            return self._neighbors!
        }
    }
    
    private var circleRadius: CGFloat = 11.0
    
    
    public var building: Building? {
        didSet {
            if building == nil {
                return
            }
            registerListener(building!, delta: CGPoint(x: 0, y: +3.0))
        }
    }
    
    init() {
        super.init(guideRadius: 11.0)
    }
  
    
    public func isValidBuildingPosition() -> Bool {
        return self.building == nil && self.neighbors.allSatisfy{$0.building == nil}
    }
    
}
