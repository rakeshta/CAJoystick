//
//  CAJoystickVector.swift
//  CAJoystick
//
//  Created by Rakesh Ayyaswami on 2/28/16.
//  Copyright © 2016 Raptor Soft. All rights reserved.
//

import Foundation


/// This structure represents the position or 'value' of the thumbstick with respect to the center.
public struct CAJoystickVector {
    
    // MARK: - Members
    
    /// Horizontal distance of the thumbstick from the center. Ranges from -1 to 1.
    public var dx:           CGFloat
    
    /// Vertical distance of the thumbsick from the center. Ranges from -1 to 1.
    public var dy:           CGFloat
    
    
    // MARK: - Accessors

    /// Distance of the thumbstick from the center. Ranges from 0 to 1.
    public var magnitude:    CGFloat {
        return sqrt(dx * dx + dy * dy)
    }
    
    /// The angle in radians. Ranges from 0 to 2Pi.
    public var angle:        CGFloat {
        if  dx == 0 && dy == 0 {
            return 0.0
        }
        let a = atan2(dx, dy)
        return a < 0.0 ? CGFloat(2.0 * M_PI) + a : a
    }
    
    
    // MARK: - Constants
    
    public static let zero = CAJoystickVector(dx: 0.0, dy: 0.0)
}


// MARK: - Equatable

extension CAJoystickVector: Equatable {
    
}

public func == (lhs: CAJoystickVector, rhs: CAJoystickVector) -> Bool {
    return lhs.dx == rhs.dx && lhs.dy == rhs.dy
}


// MARK: - Description

extension CAJoystickVector: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        return "{\(dx), \(dy)}"
    }
    
    public var debugDescription: String {
        return description
    }
}


// MARK: - Conversion

extension CAJoystickVector {
    
    /// Converts to a `CGVector`.
    public var toCGVector:  CGVector {
        return CGVector(dx: dx, dy: dy)
    }
    
    /// Converts to a `CGPoint`.
    public var toCGPoint:   CGPoint {
        return CGPoint(x: dx, y: dy)
    }
    
    /// Initializes with a `CGVector`
    public init(_ vector: CGVector) {
        self.init(dx: vector.dx, dy: vector.dy)
    }
    
    /// Initializes with a `CGPoint`
    public init(_ point: CGPoint) {
        self.init(dx: point.x, dy: point.y)
    }
}
