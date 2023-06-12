//
//  CGPoint+.swift
//  Catan
//
//  Created by Ion Plamadeala on 13/06/2023.
//

import Foundation

public extension CGPoint {
    func distanceTo(other point: CGPoint) -> CGFloat {
        return sqrt(pow( (self.x-point.x), 2.0) + pow((self.y-point.y), 2.0))
    }
    
    static func +(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
}
