//
//  ViewController.swift
//  CAJoystickExample
//
//  Created by Rakesh TA on 24/02/2016.
//  Copyright © 2016 Raptor Soft. All rights reserved.
//

import UIKit
import CAJoystick


final internal class ViewController: UIViewController {

    // MARK: - IB Outlets
    
    @IBOutlet weak var joystickControl: CAJoystickControl!
    
    @IBOutlet weak var xLabel:          UILabel!
    @IBOutlet weak var yLabel:          UILabel!
    
    @IBOutlet weak var aLabel:          UILabel!
    @IBOutlet weak var dLabel:          UILabel!
    
    @IBOutlet weak var cursorView:      UIView!
    
    
    // MARK: - Members
    
    private var displayLink:            CADisplayLink?
}


// MARK: View Lifecycle

extension ViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update initial value display
        joystickControl_valueChanged(joystickControl)
        
        // Create display link to update cursor position
        displayLink = CADisplayLink(target: self, selector: "displayLinkTimerFired:")
        displayLink!.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Invalidate display link
        displayLink?.invalidate()
        displayLink = nil
    }
}


// MARK: - Actions

extension ViewController {
    
    @IBAction func joystickControl_valueChanged(sender: CAJoystickControl) {
        xLabel.text = String(format: "x: %+.4f", arguments: [sender.value.dx])
        yLabel.text = String(format: "y: %+.4f", arguments: [sender.value.dy])
        aLabel.text = String(format: "%.4f :a", arguments: [sender.value.angle])
        dLabel.text = String(format: "%.4f :d", arguments: [sender.value.magnitude])
    }
}


// MARK: - Display Link

extension ViewController {
    
    @objc
    private func displayLinkTimerFired(displayLink: CADisplayLink) {
        
        let value            = joystickControl.value
        if  value.magnitude == 0.0 {
            return
        }

        cursorView.transform = CGAffineTransformIdentity
        var position         = cursorView.center

        let maxSpeed         = 4.0 as CGFloat
        position.x          += value.dx * maxSpeed
        position.y          -= value.dy * maxSpeed
        
        let margin           = 30.0 as CGFloat
        let viewSize         = view.bounds.size
        if  position.x       < margin {
            position.x       = margin
        }
        if  position.x       > viewSize.width - margin {
            position.x       = viewSize.width - margin
        }
        if  position.y       < margin {
            position.y       = margin
        }
        if  position.y       > viewSize.height - margin {
            position.y       = viewSize.height - margin
        }
        
        cursorView.center    = position
        cursorView.transform = CGAffineTransformMakeRotation(value.angle)
    }
}
