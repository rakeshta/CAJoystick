//
//  CAJoystickControl.swift
//  CAJoystick
//
//  Created by Rakesh TA on 24/02/2016.
//  Copyright © 2016 Raptor Soft. All rights reserved.
//

import UIKit

@IBDesignable
public class CAJoystickControl: UIControl {

    // MARK: - Members
    
    private let backgroundImageView            = UIImageView()
    private let thumbImageView                 = UIImageView()
    
    
    // MARK: -
    
    public private(set) var value              = CGPoint.zero
    
    
    // MARK: - Accessors
    
//    public var 
    
    
    // MARK: - IB Attributes
    
    public override var contentMode:             UIViewContentMode {
        get {
            return backgroundImageView.contentMode
        }
        set {
            backgroundImageView.contentMode = contentMode
        }
    }
    

    // MARK: -
    
    public override var backgroundColor:         UIColor? {
        get {
            return backgroundImageView.backgroundColor
        }
        set {
            backgroundImageView.backgroundColor = newValue
        }
    }
    
    @IBInspectable public var backgroundImage:   UIImage? {
        get {
            return backgroundImageView.image
        }
        set {
            backgroundImageView.image = newValue
        }
    }
    
    
    // MARK: -
    
    @IBInspectable public var thumbColor:        UIColor? {
        get {
            return thumbImageView.backgroundColor
        }
        set {
            thumbImageView.backgroundColor = newValue
        }
    }
    
    @IBInspectable public var thumbImage:        UIImage? {
        get {
            return thumbImageView.image
        }
        set {
            thumbImageView.image = newValue
        }
    }

    @IBInspectable public var thumbSize:         CGFloat = 0.40 {
        didSet {
            setNeedsLayout()
        }
    }
    
    
    // MARK: -
    
    @IBInspectable public var reach:             CGFloat = 0.80
    @IBInspectable public var deadZone:          CGFloat = 0.05
    
    
    // MARK: -
    
    @IBInspectable public override var enabled:  Bool {
        get {
            return super.enabled
        }
        set {
            super.enabled = newValue
        }
    }
    
    
    // MARK: - Init
    
    public convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        postinit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        postinit()
    }
    
    
    // MARK: -
    
    private func postinit() {
        
        // Configure background image view
        backgroundImageView.contentMode     = contentMode
        backgroundImageView.backgroundColor = UIColor.lightGrayColor()
        backgroundImageView.clipsToBounds   = true
        addSubview(backgroundImageView)
        
        // Configure thumb image view
        thumbImageView.contentMode     = .ScaleAspectFit
        thumbImageView.backgroundColor = UIColor.darkGrayColor()
        thumbImageView.clipsToBounds   = true
        addSubview(thumbImageView)
    }
}


// MARK: - Layout

extension CAJoystickControl {
    
    private var thumbPositionForValue: CGPoint {
        
        // Block to convert value to coordinates
        let scale = { (value: CGFloat, range: CGFloat) -> CGFloat in
            
            let rHalf = range / 2.0
            if  value == 0 {
                return rHalf
            }
            
            let dMin  = rHalf * self.deadZone
            let dMax  = rHalf * self.reach
            return rHalf + dMin + (dMax - dMin) * value
        }
        
        // Scale value x, y to coordinates
        return CGPoint(x: scale(value.x, CGRectGetWidth(bounds)), y: scale(value.y, CGRectGetHeight(bounds)))
    }
    
    private var valueForThumbPosition: CGPoint {
        
        // Block to convert coordinates to value
        let invert = { (ordniate: CGFloat, range: CGFloat) -> CGFloat in
            return 0.0
        }
        
        // Scale coordinates to value x, y
        let center = thumbImageView.center
        return CGPoint(x: invert(center.x, CGRectGetWidth(bounds)), y: invert(center.y, CGRectGetHeight(bounds)))
    }
    
    public override func layoutSubviews() {
        
        // Layout background image view
        backgroundImageView.frame              = bounds
        backgroundImageView.layer.cornerRadius = min(CGRectGetWidth(bounds), CGRectGetHeight(bounds)) / 2.0

        // Layout
        let thumbWidth                         = round(min(CGRectGetWidth(bounds), CGRectGetHeight(bounds)) * thumbSize)
        thumbImageView.frame                   = CGRect(x: 0, y: 0, width: thumbWidth, height: thumbWidth)
        thumbImageView.center                  = thumbPositionForValue
        thumbImageView.layer.cornerRadius      = min(CGRectGetWidth(thumbImageView.frame), CGRectGetHeight(thumbImageView.frame)) / 2.0
    }
}

