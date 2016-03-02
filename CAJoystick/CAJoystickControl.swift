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
    
    private let _backgroundImageView           = UIImageView()
    private let _thumbImageView                = UIImageView()
    
    
    // MARK: -
    
    private var _lastTouchPoint                = CGPoint.zero
    
    
    // MARK: -
    
    public private(set) var value              = CGVector.zero
    
    
    // MARK: - IB Attributes
    
    public override var contentMode:             UIViewContentMode {
        get {
            return _backgroundImageView.contentMode
        }
        set {
            _backgroundImageView.contentMode = contentMode
        }
    }
    

    // MARK: -
    
    public override var backgroundColor:         UIColor? {
        get {
            return _backgroundImageView.backgroundColor
        }
        set {
            _backgroundImageView.backgroundColor = newValue
        }
    }
    
    @IBInspectable public var backgroundImage:   UIImage? {
        get {
            return _backgroundImageView.image
        }
        set {
            _backgroundImageView.image = newValue
        }
    }
    
    
    // MARK: -
    
    @IBInspectable public var thumbColor:        UIColor? {
        get {
            return _thumbImageView.backgroundColor
        }
        set {
            _thumbImageView.backgroundColor = newValue
        }
    }
    
    @IBInspectable public var thumbImage:        UIImage? {
        get {
            return _thumbImageView.image
        }
        set {
            _thumbImageView.image = newValue
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
        _backgroundImageView.contentMode     = contentMode
        _backgroundImageView.backgroundColor = UIColor.lightGrayColor()
        _backgroundImageView.clipsToBounds   = true
        addSubview(_backgroundImageView)
        
        // Configure thumb image view
        _thumbImageView.contentMode     = .ScaleAspectFit
        _thumbImageView.backgroundColor = UIColor.darkGrayColor()
        _thumbImageView.clipsToBounds   = true
        addSubview(_thumbImageView)
    }
}


// MARK: - Layout

extension CAJoystickControl {
    
    private func thumbPositionForValue(value: CGVector) -> CGPoint {
        
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
        return CGPoint(x: scale(value.dx, CGRectGetWidth(bounds)), y: scale(-value.dy, CGRectGetHeight(bounds)))
    }
    
    private func valueForThumbPosition(position: CGPoint) -> CGVector {
        
        // Block to convert coordinates to value
        let invert    = { (ordinate: CGFloat, range: CGFloat) -> CGFloat in
            let rHalf = range / 2.0
            let dd    = ordinate - rHalf
            let dabs  = fabs(dd)
            let dMin  = rHalf * self.deadZone
            if  dabs  < dMin {
                return 0.0
            }
            let dMax  = rHalf * self.reach
            let vabs  = (dabs - dMin) / (dMax - dMin)
            return dd < 0 ? -vabs : vabs
        }
        
        // Scale coordinates to value x, y
        return CGVector(dx: invert(position.x, CGRectGetWidth(bounds)), dy: -invert(position.y, CGRectGetHeight(bounds)))
    }
    
    public override func layoutSubviews() {
        
        // Layout background image view
        _backgroundImageView.frame              = bounds
        _backgroundImageView.layer.cornerRadius = min(CGRectGetWidth(bounds), CGRectGetHeight(bounds)) / 2.0

        // Layout
        let thumbWidth                          = round(min(CGRectGetWidth(bounds), CGRectGetHeight(bounds)) * thumbSize)
        _thumbImageView.frame                   = CGRect(x: 0, y: 0, width: thumbWidth, height: thumbWidth)
        _thumbImageView.center                  = thumbPositionForValue(value)
        _thumbImageView.layer.cornerRadius      = min(CGRectGetWidth(_thumbImageView.frame), CGRectGetHeight(_thumbImageView.frame)) / 2.0
    }
}


// MARK: - Touch Tracking

extension CAJoystickControl {
    
    private func isPointInsideThumb(p: CGPoint) -> Bool {
        let r  = CGRectGetWidth(_thumbImageView.frame) / 2.0
        let dx = p.x - r
        let dy = p.y - r
        return dx * dx + dy * dy < r * r
    }
    
    
    // MARK: -
    
    private func nudgeThumbPositionByDx(dx: CGFloat, dy: CGFloat, animated: Bool, notify: Bool) {
        
        // Block to nudge a coordinate while keeping it within bounds
        let nudge   = { (x: CGFloat, dx: CGFloat, range: CGFloat) -> CGFloat in
            let min = range * (1.0 - self.reach) / 2.0
            let max = range - min
            var xx  = x + dx
            if  xx  < min {
                xx  = min
            }
            if  xx  > max {
                xx  = max
            }
            return xx
        }
        
        // Determine the new position of the thumb
        let newPos  = CGPoint(
            x: nudge(_thumbImageView.center.x, dx, CGRectGetWidth(bounds)),
            y: nudge(_thumbImageView.center.y, dy, CGRectGetHeight(bounds))
        )
        
        //
        do {
            let val = valueForThumbPosition(newPos)
            if  val.magnitude > 1.0 {
                
            }
        }
        
        // Update thumb position
        setThumbPosition(newPos, animationDuration: animated ? 0.1 : 0.0, notify: notify)
    }
    
    private func resetThumbPositionAnimated(animated: Bool, notify: Bool) {
        setThumbPosition(CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetMidX(bounds)), animationDuration: animated ? 0.3 : 0.0, notify: notify)
    }
    
    private func setThumbPosition(position: CGPoint, animationDuration duration: NSTimeInterval, notify: Bool) {
        
        // Abort if no change in position
        if  position == _thumbImageView.center {
            return
        }
        
        // Animate the change
        UIView.animateWithDuration(duration, delay: 0.0, options: [.BeginFromCurrentState],
            animations: {
                self._thumbImageView.center = position
            },
            completion: nil
        )
        
        // Update value
        value = valueForThumbPosition(position)
        
        // Generate change event if needed
        if  notify {
            self.sendActionsForControlEvents([.ValueChanged])
        }
    }
    
    
    // MARK: -
    
    public override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        _lastTouchPoint = touch.locationInView(_thumbImageView)
        return isPointInsideThumb(_lastTouchPoint)
    }
    
    public override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        
        let pp = touch.locationInView(_thumbImageView)
        let dx = pp.x - _lastTouchPoint.x
        let dy = pp.y - _lastTouchPoint.y
        nudgeThumbPositionByDx(dx, dy: dy, animated: true, notify: true)
        
        return true
    }
    
    public override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        _lastTouchPoint = CGPoint.zero
        resetThumbPositionAnimated(true, notify: true)
    }
    
    public override func cancelTrackingWithEvent(event: UIEvent?) {
        _lastTouchPoint = CGPoint.zero
        resetThumbPositionAnimated(true, notify: true)
    }
}

