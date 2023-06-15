//
//  CGPoint+.swift
//  Catan
//
//  Created by Ion Plamadeala on 13/06/2023.
//

import Foundation

public extension CGPoint {
    
    private static let edgeAdj: [(CGFloat, CGFloat)] = [
        (+1, -1),
        (0, -1),
        (-1,  0),
        (-1, +1),
        (0, +1),
        (+1, 0)
    ].map{(CGFloat($0.0), CGFloat($0.1))}
    
    func distanceTo(other point: CGPoint) -> CGFloat {
        return sqrt(pow( (self.x-point.x), 2.0) + pow((self.y-point.y), 2.0))
    }
    
    static func +(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func *(left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x * right, y: left.y * right)
    }
    
    func hexNeighbour(direction: Int) -> CGPoint {
        return CGPoint(x: self.x + CGPoint.edgeAdj[direction % 6].0, y: self.y + CGPoint.edgeAdj[direction % 6].1)
        
    }
}
