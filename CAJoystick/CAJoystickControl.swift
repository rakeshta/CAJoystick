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
    
    private var thumbCenter: CGPoint {
        let x = CGRectGetWidth(bounds)  * (1.0 + value.x) / 2.0
        let y = CGRectGetHeight(bounds) * (1.0 + value.y) / 2.0
        return CGPoint(x: x, y: y)
    }
    
    public override func layoutSubviews() {
        
        // Layout background image view
        backgroundImageView.frame              = bounds
        backgroundImageView.layer.cornerRadius = min(CGRectGetWidth(bounds), CGRectGetHeight(bounds)) / 2.0

        // Layout
        let thumbWidth                         = round(min(CGRectGetWidth(bounds), CGRectGetHeight(bounds)) * thumbSize)
        thumbImageView.frame                   = CGRect(x: 0, y: 0, width: thumbWidth, height: thumbWidth)
        thumbImageView.center                  = thumbCenter
        thumbImageView.layer.cornerRadius      = min(CGRectGetWidth(thumbImageView.frame), CGRectGetHeight(thumbImageView.frame)) / 2.0
    }
}

