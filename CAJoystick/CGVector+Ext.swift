//
//  CGVector+Ext.swift
//  CAJoystick
//
//  Created by Rakesh TA on 29/02/2016.
//  Copyright © 2016 Raptor Soft. All rights reserved.
//

import CoreGraphics


// MARK: - Accessors

extension CGVector {
    
    /// Magnitude of the vector.
    public var magnitude:    CGFloat {
        return sqrt(dx * dx + dy * dy)
    }
    
    /// Angle in radians of the vector.
    public var angle:        CGFloat {
        if  dx == 0 && dy == 0 {
            return 0.0
        }
        return atan2(dx, dy)
    }
    
    /// Returns the normal vector for this vector if the magnitude is greater
    /// than zero. If the magnitude is zeor, the zero vector is returned.
    public var normal:       CGVector {
        let m = magnitude
        return m > 0.0 ? CGVector(dx: dx / m, dy: dy / m) : self
    }
}


// MARK: - Description

extension CGVector: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        return "{\(dx), \(dy)}"
    }
    
    public var debugDescription: String {
        return description
    }
}